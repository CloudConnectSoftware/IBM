%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_INTERVENTION_GENERATION_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_intervention_generation_v2, `08/11/2022 10:31:56` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic rkb_result/8.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GENERATE INTERVENTION FORMS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_first:- i_generate_initial_intervention_forms___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_generate_initial_intervention_forms___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( ignore_enquire ) ),
	
	not( result( _, _, force_result, `success` ) ),

	not( dbg_instance ),

	i_user_data( header_level_document_scenarios( Header_Level_Document_Scenarios_List ) ),
	i_user_data( line_level_document_scenarios( Line_Level_Document_Scenarios_List ) ),
	
	(
		Header_Level_Document_Scenarios_List \= [ ]
		;
		Line_Level_Document_Scenarios_List \= [ ]
	),

	i_generate_rules_intervention_form,

	(
		i_generate_customer_intervention_form
		
		;
		
		true
		
	),
	
	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_generate_rules_intervention_form
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	get_initial_form_values( From, Send_From, Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, Forward_Address_List, RTS_Email_Subject, Forward_Email_Subject ),

	!,
	
	(
		service_overview( `Rules Intervention Role`, Rules_Intervention_Role_Raw, Rules_Intervention_Role_Dependency ),

		create_string_from_template( Rules_Intervention_Role_Raw, Rules_Intervention_Role ),

		sys_call( Rules_Intervention_Role_Dependency )
		
		;
		
		Rules_Intervention_Role = `CloudTrade`
		
	),
	
	!,
	
	populate_initial_intervention( `rules_intervention_form`, Rules_Intervention_Role, Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, `The system has detected the below errors. Please see details on the right for instructions on how to action them.`, `If there are any errors that are mapping issues, then please fix the mapping, wait for the mapping to update, and press submit. Otherwise, please select the fail option for each error and click the submit button. If the rules require changing, please enter the name of the new set of rules in the 'Rules' box and click the submit button. Please refer to your user guides for further instructions.`, RTS_Email_Subject, Forward_Email_Subject, [ From ], Send_From, Forward_Address_List, F0 ),
	
	trace( [ `GENERATING RULES INTERVENTION FORM` ] ),
	
	!,
	
	add_rules_file_name_to_form( F0, F1 ),
	
	!,
	
	add_quick_action_dropdown_to_form( `rules`, F1, F2 ),
	
	!,
	
	add_rules_header_level_document_scenario_questions_to_form( Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, F2, F3 ),

	!,
	
	add_rules_line_level_document_scenario_questions_to_form( Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, F3, F4 ),
	
	!,
	
	add_email_templates_to_form( F4, F5 ),
	
	!,
	
	(	i_mail( subject, `Mitie Submission` ),
		add_completion_to_form( F5, F6 )
		;	F5 = F6
	),

	!,

	(	qq_op_param( bespoke_rules_intervention_section, Intervention_Section_Function_Name ), % E.g. qq_op_param( bespoke_rules_intervention_section, add_custom_dropdown_to_form )
		Intervention_Section_Function =.. [ Intervention_Section_Function_Name, F6, F7 ], % E.g. Intervention_Section_Function =.. [ add_custom_dropdown_to_form, F6, F7 ]
		sys_call( Intervention_Section_Function ) % E.g. sys_call( generate_custom_dropdown( F6, F7 ) )
		;	F6 = F7
	),

	!,

	sys_asserta( i_user_data( rules_intervention_form( F7 ) ) ),
	trace( [ `FINISHED GENERATING RULES INTERVENTION FORM` ] ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_generate_customer_intervention_form
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	get_initial_form_values( From, Send_From, Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, Forward_Address_List, RTS_Email_Subject, Forward_Email_Subject ),
	
	!,
	
	service_overview( `Customer Intervention Role`, Customer_Intervention_Role_Raw, Customer_Intervention_Role_Dependency ),

	Customer_Intervention_Role_Raw \= ``,

	create_string_from_template( Customer_Intervention_Role_Raw, Customer_Intervention_Role ),

	sys_call( Customer_Intervention_Role_Dependency ),
	
	!,

	populate_initial_intervention( `customer_intervention_form`, Customer_Intervention_Role, Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, Transferred_Intervention_Questions_List, `The system has detected the below errors with this document. Please see details on the right for instructions on how to action them.`, `If there are any errors that you believe are mapping issues, then please transfer the document to the technical/mapping queue. Otherwise, please select the fail option for each error and click the submit button. If no fail options are available, please either forward the document to an email address, return it to the sender, or delete it. Please refer to your user guides for further instructions.`, RTS_Email_Subject, Forward_Email_Subject, [ From ], Send_From, Forward_Address_List, F0 ),
	
	trace( [ `GENERATING CUSTOMER INTERVENTION FORM` ] ),
	
	!,
	
	add_customer_header_level_document_scenario_questions_to_form( Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, F0, F1 ),

	!,
	
	add_customer_line_level_document_scenario_questions_to_form( Ignored_Rules_Intervention_Questions_List, Ignored_Customer_Intervention_Questions_List, F1, F2 ),
	
	!,
	
	add_email_templates_to_form( F2, F3 ),
	
	!,
	
	add_quick_action_dropdown_to_form( `customer`, F3, F4 ),
	
	!,
	
	add_completion_to_form( F4, F5 ),
	
	!,

	(	qq_op_param( bespoke_customer_intervention_section, Intervention_Section_Function_Name ), % E.g. qq_op_param( bespoke_customer_intervention_section, add_custom_dropdown_to_form )
		Intervention_Section_Function =.. [ Intervention_Section_Function_Name, F5, F6 ], % E.g. Intervention_Section_Function =.. [ add_custom_dropdown_to_form, F5, F6 ]
		sys_call( Intervention_Section_Function ) % E.g. sys_call( generate_custom_dropdown( F5, F6 ) )
		;	F5 = F6
	),

	!,

	sys_asserta( i_user_data( customer_intervention_form( F6 ) ) ),
	trace( [ `FINISHED GENERATING CUSTOMER INTERVENTION FORM` ] ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SET INTERVENTION FORMS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_last:- i_set_intervention_forms___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_set_intervention_forms___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( ignore_enquire ) ),
	
	not( result( _, _, force_result, `success` ) ),
	
	not( dbg_instance ),

	not( rkb_result( _, _, _, _, _, _, _, _ ) ),

	(
		grammar_set( customer_intervention_required )
		
		;
		
		grammar_set( rules_intervention_required )
		
	),
	
	sys_retractall( result( _, invoice, enquiry_role, _ ) ),

	(
		i_user_data( customer_intervention_form( Customer_Form ) ),
		json_get( Customer_Form, `role`, Customer_Role ),

		set_enquire_form( Customer_Form ),
		trace( [ `CUSTOMER INTERVENTION FORM` ] ),
		json_trace( Customer_Form ),

		(
			qq_op_param( customer_intervention_role_list, Roles_List ),

			set_forms_for_additional_roles( Customer_Form, Customer_Role, Roles_List )
			
			;

			true

		)

		;

		true

	),
	
	!,
	
	(
		i_user_data( rules_intervention_form( Rules_Form ) ),
		json_get( Rules_Form, `role`, Rules_Role ),
		
		set_enquire_form( Rules_Form ),
		trace( [ `RULES INTERVENTION FORM` ] ),
		json_trace( Rules_Form )

		;

		true

	),
	
	!,

	(	(	q_enquire_form( `customer_intervention_form`, _ )
			;	q_enquire_form( Form_Name, _ ),
				q_sys_sub_string( Form_Name, _, _, `customer_intervention_form` )
		),
		sys_assertz( grammar_set( customer_intervention_required ) )
		;	true
	),

	!,
	
	(
		grammar_set( customer_intervention_required ),
		
		Customer_Role = Role,
		trace( [ `SENDING TO CUSTOMER INTERVENTION` ] )
		
		;
		
		Rules_Role = Role,
		trace( [ `SENDING TO RULES INTERVENTION` ] )
		
	),

	assertz_derived_data( invoice, enquiry_role, Role, i_analyse_enquiry_role ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:- multifile set_forms_for_additional_roles/3.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set_forms_for_additional_roles( _, _, [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set_forms_for_additional_roles( Form_In, Customer_Role, [ Role | Remaining_Roles ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		Customer_Role \= Role,
		
		json_clone( Form_In, F0 ),

		json_set_cut( F0, `role`, Role, F1 ),

		string_to_lower( Role, Role_1 ),
		strip_string2_from_string1( Role_1, `\\|,<.>/?;:'@#~]}[{=+-)(*&^%$£"!`, Role_2 ),
		string_string_replace( Role_2, ` `, `_`, Role_Edited ),
		strcat_list( [ `zcustomer_intervention_form_`, Role_Edited ], Form_Name ),
		
		json_set_cut( F1, `name`, Form_Name, F2 ),

		set_enquire_form( F2 ),
		trace( [ `SET FORM FOR ROLE:`, Role ] )

		;

		Customer_Role = Role

	),

	set_forms_for_additional_roles( Form_In, Customer_Role, Remaining_Roles )
.
