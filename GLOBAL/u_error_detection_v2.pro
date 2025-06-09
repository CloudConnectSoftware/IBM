%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_ERROR_DETECTION_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_error_detection_v2, `08/06/2022 06:20:26` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Detects all errors and stores them in i_user_data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR EARLY ANALYSIS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_early_analysis___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_early_analysis___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	service_overview( `Create Output File After Analysis?`, `True`, Scenario_Dependency ),

	sys_call( Scenario_Dependency ),

	not( grammar_set( i_analyse_early_analysis ) ),

	sys_assertz( grammar_set( i_analyse_early_analysis ) ),

	warn( [ `Create Output File After Analysis` ] ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR HEADER LEVEL DOCUMENT SCENARIOS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- grammar_set( i_analyse_early_analysis ), i_analyse_header_level_document_scenarios___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_first:- not( grammar_set( i_analyse_early_analysis ) ), i_analyse_header_level_document_scenarios___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_header_level_document_scenarios___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	debug( [ `CHECKING FOR ERRORS` ] ),

	sys_findall(
		( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text, Scenario, Invoice_Error_String, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, `` ),
		(
			header_level_scenario( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text_Raw, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, Scenario_Dependency ),
			(
				(
					strcat_list( [ `Missing `, Data_Item_Name ], Scenario )
					;
					strcat_list( [ `Invalid `, Data_Item_Name ], Scenario )
				)
				->	qq_op_param( disable_data_item_check_scenarios, Scenarios_List ),
					ensure_scenarios_have_not_occurred( Scenarios_List ),
					header_level_item( _, Data_Item_Name, `Yes`, _, _, _, _, _, _, _, _, _, _, _, _, _ )
				;	
				true
			),
			(
				Rules_Intervention = `Yes`,
				q_sys_member( Action, [ `Action From Intervention`, `Flag As Fail and Post`, `Return to Sender`, `Forward to Email Address`, `Delete` ] )
				;
				Rules_Intervention = `No`,
				(
					Customer_Intervention = `Yes`
					;
					Customer_Intervention = `No`,
					q_sys_member( Action, [ `Action From Intervention`, `Flag As Fail and Post`, `Return to Sender`, `Forward to Email Address`, `Delete` ] )
				)
			),
			sys_call( Scenario_Dependency ),
			create_string_from_template( Error_Description_Text_Raw, Error_Description_Text ),
			not( grammar_set( Ref, Scenario ) ),
			sys_assertz( grammar_set( Ref, Scenario ) ),
			string_to_lower( Portal_Reason, Reason_L ),
			string_string_replace( Reason_L, ` `, `_`, Reason_Replaced ),
			strip_string2_from_string1( Reason_Replaced, `\\|,./?;:'@#~]}[{=+-)(*&^%$£"!`, Reason_Stripped ),
			strcat_list( [ `i_analyse_`, Reason_Stripped ], Invoice_Error_String ),
			error( [ Scenario ] )
		),
		Header_Level_Document_Scenarios_List_Raw
	),

	i_force_list( Header_Level_Document_Scenarios_List_Raw, Header_Level_Document_Scenarios_List ),

	sys_asserta( i_user_data( header_level_document_scenarios( Header_Level_Document_Scenarios_List ) ) ),

	(
		Header_Level_Document_Scenarios_List = [ ],

		debug( [ `No header level errors` ] )

		;

		true

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR LINE LEVEL DOCUMENT SCENARIOS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- grammar_set( i_analyse_early_analysis ), i_analyse_line_level_document_scenarios___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_first:- not( grammar_set( i_analyse_early_analysis ) ), i_analyse_line_level_document_scenarios___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_level_document_scenarios___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		qq_op_param( disable_data_item_check_scenarios, Scenarios_List ),
		ensure_scenarios_have_not_occurred( Scenarios_List ),
	
		sys_findall(
			( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text, Error_Name, Invoice_Error_String, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, `` ),
			(
				line_level_scenario( Ref, Scenario, Rules_Intervention, Customer_Intervention, Action, Email_Address, Error_Description_Text_Raw, Quick_Action_Rules, Quick_Action_Customer, Portal_Reason, Ignore_From_Rules_Intervention, Ignore_From_Customer_Intervention, Scenario_Dependency ),
				(
					(
						strcat_list( [ `Missing `, Data_Item_Name ], Scenario )
						;
						strcat_list( [ `Invalid `, Data_Item_Name ], Scenario )
					)
					->	line_level_item( _, Data_Item_Name, `Yes`, _, _, _, _, _, _, _, _, _, _, _, _, _ )
					;
					true
				),
				(
					Rules_Intervention = `Yes`,
					q_sys_member( Action, [ `Action From Intervention`, `Flag As Fail and Post`, `Return to Sender`, `Forward to Email Address`, `Delete` ] )
					;
					Rules_Intervention = `No`,
					(
						Customer_Intervention = `Yes`
						;
						Customer_Intervention = `No`,
						q_sys_member( Action, [ `Action From Intervention`, `Flag As Fail and Post`, `Return to Sender`, `Forward to Email Address`, `Delete` ] )
					)
				),
				sys_findall(
					LID_String,
					(
						result( _, LID, _, _ ),
						not( dead_line( LID ) ),
						sys_string_number( LID_String, LID ),
						check_for_line_scenario( Ref, Scenario, LID, LID_String, Scenario_Dependency )
					),
					List_of_Line_Numbers_Raw
				),
				i_force_list( List_of_Line_Numbers_Raw, List_of_Line_Numbers ),
				List_of_Line_Numbers \= [ ],
				sys_stringlist_concat( List_of_Line_Numbers, `, `, Occurred_At_Lines ),
				strcat_list( [ Scenario, ` at lines `, Occurred_At_Lines ], Error_Name ),
				sys_asserta( i_user_data( error_lines( Scenario, Occurred_At_Lines ) ) ),
				create_string_from_template( Error_Description_Text_Raw, Error_Description_Text ),
				not( grammar_set( Ref, Scenario ) ),
				sys_assertz( grammar_set( Ref, Scenario ) ),
				string_to_lower( Portal_Reason, Reason_L ),
				string_string_replace( Reason_L, ` `, `_`, Reason_Replaced ),
				strip_string2_from_string1( Reason_Replaced, `\\|,./?;:'@#~]}[{=+-)(*&^%$£"!`, Reason_Stripped ),
				strcat_list( [ `i_analyse_`, Reason_Stripped ], Invoice_Error_String ),
				error( [ Error_Name ] )
			),
			Line_Level_Document_Scenarios_List_Raw
		),

		i_force_list( Line_Level_Document_Scenarios_List_Raw, Line_Level_Document_Scenarios_List )
		
		;
		
		Line_Level_Document_Scenarios_List = [ ]

	),

	sys_asserta( i_user_data( line_level_document_scenarios( Line_Level_Document_Scenarios_List ) ) ),

	(
		Line_Level_Document_Scenarios_List = [ ],

		debug( [ `No line level errors` ] )

		;

		true

	),

	debug( [ `FINISHED CHECKING FOR ERRORS` ] ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_for_line_scenario( Ref, Scenario, LID, LID_String, Scenario_Dependency )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	strcat_list( [ Ref, `_`, Scenario ], Scenario_Ref ),

	not( grammar_set( `tested_document_scenario`, Scenario_Ref, LID ) ),

	sys_assertz( grammar_set( `testing_document_scenario`, Scenario_Ref, LID ) ),

	!,
	
	(
		sys_call( Scenario_Dependency ),
		
		not( grammar_set( Ref, Scenario, LID_String ) ),
		
		sys_assertz( grammar_set( Ref, Scenario, LID_String ) ),
		
		Test_Result = `Success`
		
		;
		
		Test_Result = `Fail`
		
	),
	
	!,
	
	sys_retract( grammar_set( `testing_document_scenario`, Scenario_Ref, LID ) ),
	
	sys_assertz( grammar_set( `tested_document_scenario`, Scenario_Ref, LID ) ),
	
	!,
	
	(
		Test_Result = `Success`
		
		;
		
		Test_Result = `Fail`,
		
		fail
		
	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ERROR NAME AND DESCRIPTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- grammar_set( i_analyse_early_analysis ), i_analyse_error_name_and_description___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_first:- not( grammar_set( i_analyse_early_analysis ) ), i_analyse_error_name_and_description___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_error_name_and_description___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( dbg_instance ),

	i_user_data( header_level_document_scenarios( Header_Level_Document_Scenarios_List ) ),
	i_user_data( line_level_document_scenarios( Line_Level_Document_Scenarios_List ) ),
	
	sys_findall(
		Error_Name,
		(
			q_sys_member( ( Ref, _, _, _, _, _, _, Error_Name, _, _, _, _, _, _, Intervention_Value ), Header_Level_Document_Scenarios_List ),
			Intervention_Value \= `Ignore Error`,
			not( grammar_set( `error name scenario`, Ref ) ),
			sys_assertz( grammar_set( `error name scenario`, Ref ) )
			;
			q_sys_member( ( Ref, _, _, _, _, _, _, Error_Name, _, _, _, _, _, _, Intervention_Value ), Line_Level_Document_Scenarios_List ),
			Intervention_Value \= `Ignore Error`,
			not( grammar_set( `error name scenario`, Ref ) ),
			sys_assertz( grammar_set( `error name scenario`, Ref ) )
		),
		List_of_Error_Names_Raw
	),

	i_force_list( List_of_Error_Names_Raw, List_of_Error_Names ),

	!,

	List_of_Error_Names \= [ ],

	sys_stringlist_concat( List_of_Error_Names, `, `, Error_Name_Text ),

	assertz_derived_data( invoice, error_name, Error_Name_Text, i_analyse_error_name ),

	!,

	sys_findall(
		Error_Description,
		(
			q_sys_member( ( Ref, _, _, _, _, _, Error_Description, _, _, _, _, _, _, _, Intervention_Value ), Header_Level_Document_Scenarios_List ),
			Error_Description \= ``,
			Intervention_Value \= `Ignore Error`,
			not( grammar_set( `error description scenario`, Ref ) ),
			sys_assertz( grammar_set( `error description scenario`, Ref ) )
			;
			q_sys_member( ( Ref, _, _, _, _, _, Error_Description, _, _, _, _, _, _, _, Intervention_Value ), Line_Level_Document_Scenarios_List ),
			Error_Description \= ``,
			Intervention_Value \= `Ignore Error`,
			not( grammar_set( `error description scenario`, Ref ) ),
			sys_assertz( grammar_set( `error description scenario`, Ref ) )
		),
		List_of_Error_Descriptions_Raw
	),

	i_force_list( List_of_Error_Descriptions_Raw, List_of_Error_Descriptions ),

	!,

	(
		List_of_Error_Descriptions \= [ ],

		sys_stringlist_concat( List_of_Error_Descriptions, `

`, Error_Description_Raw ),
		
		create_string_from_template( Error_Description_Raw, Error_Description )
		
		;

		Error_Description = ``
		
	),
		
	assertz_derived_data( invoice, error_description_text, Error_Description, i_analyse_error_description_text ),

	!
.
