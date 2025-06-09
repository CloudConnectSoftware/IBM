%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_INSERT_CONNECTION_CODES_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_insert_connection_codes_v2, `01/02/2023 15:52:13` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GET CONNECTION HEADER LEVEL CODES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_initialise_rule( [
%=======================================================================

	trace( [ `Acquiring Connection Header Level Codes` ] )

	, check( i_user_check( get_header_level_values, Rules, Values ) )
	
	, q10( [ Values ] )
	
	, set( got_header_level_codes )

] )
:-
	get_rules_file_name( RulesRaw ),

	string_to_lower( RulesRaw, RulesL ),

	string_string_replace( RulesL, `.pro`, ``, Rules )
	
	;
	
	not( grammar_set( got_header_level_codes ) ),
	
	chained_to( RulesRaw ),

	string_to_lower( RulesRaw, Rules )
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_user_check( get_header_level_values, Rules, Values )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	connection_lookup_table( List_of_Rules, List_of_Values, Scenario_Dependency ),

	sys_call( Scenario_Dependency ),
	
	sys_string_split( List_of_Rules, `,`, Rules_List_Raw ),

	transform_list( string_to_lower, Rules_List_Raw, Rules_List_Raw_2 ),
	transform_list( sys_string_trim, Rules_List_Raw_2, Rules_List ),
	
	q_sys_member( Rules, Rules_List ),
	
	sys_findall(
		( Variable, Value ),
		(
			q_sys_member( ( Variable, Value ), List_of_Values ),
			not( sub_atom( Variable, 1, _, line_ ) ),
			Value \= ``
		),
		List_of_Header_Values_Raw
	),
	
	i_force_list( List_of_Header_Values_Raw, List_of_Header_Values ),
	
	List_of_Header_Values \= [ ],
	
	get_values( List_of_Header_Values, Values ),
	
	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_values( [ ], _ ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_values( [ ( Variable, Value ) | Remaining_Values ], [ Read, Trace | Remaining_Reads ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	Read =..[ Variable, Value ],
	
	sys_string_atom( Var_String, Variable ),
	
	Trace =.. [ trace, [ Var_String, Value ] ]

	-> get_values( Remaining_Values, Remaining_Reads )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GET CONNECTION LINE LEVEL CODES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_connection_line_values( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_connection_line_values( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		get_rules_file_name( RulesRaw ),
		
		string_to_lower( RulesRaw, RulesL ),
		
		string_string_replace( RulesL, `.pro`, ``, Rules )
		
		;
		
		chained_to( RulesRaw ),

		string_to_lower( RulesRaw, Rules )
		
	),
	
	!,
	
	connection_lookup_table( List_of_Rules, List_of_Values, Scenario_Dependency ),

	sys_string_split( List_of_Rules, `,`, Rules_List_Raw ),

	transform_list( string_to_lower, Rules_List_Raw, Rules_List_Raw_2 ),
	transform_list( sys_string_trim, Rules_List_Raw_2, Rules_List ),
	
	q_sys_member( Rules, Rules_List ),

	sys_call( Scenario_Dependency ),
	
	sys_findall(
		( Variable, Value ),
		(
			q_sys_member( ( Variable, Value ), List_of_Values ),
			sub_atom( Variable, 1, _, line_ ),
			Value \= ``
		),
		List_of_Line_Values_Raw
	),
	
	i_force_list( List_of_Line_Values_Raw, List_of_Line_Values ),
	
	populate_connection_line_values( LID, List_of_Line_Values ),
	
	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
populate_connection_line_values( _, [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
populate_connection_line_values( LID, [ ( Variable, Value ) | Remaining_Values ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		not( result( _, LID, Variable, _ ) ),
		
		assertz_derived_data( LID, Variable, Value, i_insert_connection_line_value )
		
		;
		
		true
		
	)
	
	-> populate_connection_line_values( LID, Remaining_Values )
.
