%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_DATA_FORMAT_VALIDATION_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_data_format_validation_v2, `03/09/2021 06:39:34` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ORDER NUMBER VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, order_number, Order_Number )
	
	, or( [
	
		[ check( order_number_validation( Order_Number, Order_Number_Final ) )
        
			, remove( order_number )
        
            , generic_item( [ order_number, Order_Number_Final ] )
            
        ]
		
		, [ set( invoice, `i_analyse_invalid_order_number` )
			
			, trace( [ `order_number invalid`, Order_Number ] )

		]
		
	] )

] ):- qq_op_param( order_number_regexp, _ ).

%-----------------------------------------------------------------------
order_number_validation( Order_Number, Order_Number_Final )
%-----------------------------------------------------------------------
:-
	string_to_upper( Order_Number, Order_Number_U ),
    
	(	qq_op_param( order_number_regexp_dont_strip_characters, Characters_to_Keep )
		->	true
		;	Characters_to_Keep = [ ]
	),

	compare_lists( [ `-`, `.`, `,`, `;`, `:`, `_`, `/`, `\\`, `*`, `(`, `)`, `[`, `]`, `{`, `}`, `#`, `~`, `@`, `'`, `?`, `>`, `<`, `&`, `^`, `%`, `$`, `€`, `£`, `"`, `!`, `¬`, `|`, `+`, `=` ], Characters_to_Keep, Characters_to_Strip ),

    i_user_check( gen_clean_and_extract_from_string, Order_Number_U, ` `, Characters_to_Strip, Order_Number_Final ),

	qq_op_param( order_number_regexp, Order_Number_Regexp ),

    strcat_list( [ `^`, Order_Number_Regexp, `$` ], Order_Number_Regexp_Final ),

	q_regexp_match( Order_Number_Regexp_Final, Order_Number_Final, _ ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GENERIC FORMAT VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	process_list_of_validations( [ List_of_Validations ] )
	
] )
:-
	sys_findall(
		( Without, Variable, Validation_Regexp_Final, Remove, Invalid_Flag, Invalid_Trace, Special_Characters_to_Ignore ),
		(
			validation_regexp( Variable, Validation_Regexp, Special_Characters_to_Ignore ),
			Validation_Regexp \= ``,
			strcat_list( [ `^`, Validation_Regexp, `$` ], Validation_Regexp_Final ),
			sys_string_atom( Variable_String, Variable ),
			strcat_list( [ `i_analyse_invalid_`, Variable_String ], Invalid_Flag ),
			strcat_list( [ Variable_String, ` invalid` ], Invalid_Trace ),
			Remove =.. [ remove, Variable ],
			Without =.. [ without, Variable ]
		),
		List_of_Validations
	),
	List_of_Validations \= [ ]
.

%=======================================================================
i_rule( process_list_of_validations( [ [ ] ] ), [ ] ).
%=======================================================================
i_rule( process_list_of_validations( [ List_of_Validations ] ), [
%=======================================================================

	check( List_of_Validations = [ ( Without, Variable, Validation_Regexp_Final, Remove, Invalid_Flag, Invalid_Trace, Special_Characters_to_Ignore ) | Remaining_Evaluations ] )

	, or( [

		Without
	
		, [ with( invoice, Variable, Value )
			, check( string_to_upper( Value, Value_U ) )
			, or( [
				[ check( q_sys_is_list( Special_Characters_to_Ignore ) )
					, check( compare_lists( [ `-`, `.`, `,`, `;`, `:`, `_`, `/`, `\\`, `*`, `(`, `)`, `[`, `]`, `{`, `}`, `#`, `~`, `@`, `'`, `?`, `>`, `<`, `&`, `^`, `%`, `$`, `€`, `£`, `"`, `!`, `¬`, `|`, `+`, `=` ], Special_Characters_to_Ignore, Special_Characters_to_Clean ) )
					, check( i_user_check( gen_clean_and_extract_from_string, Value_U, ` `, Special_Characters_to_Clean, Value_Final ) )
				]
				, [ peek_fails( check( q_sys_is_list( Special_Characters_to_Ignore ) ) )
					, check( i_user_check( gen_clean_and_extract_from_string, Value_U, Value_Final ) )
				]
			] )
			, or( [
				[ check( q_regexp_match( Validation_Regexp_Final, Value_Final, _ ) )
					, Remove
            		, generic_item( [ Variable, Value_Final ] )
				]
				, [ set( invoice, Invalid_Flag )
					, trace( [ Invalid_Trace, Value_Final ] )
				]
			] )
        ]

	] )

	, process_list_of_validations( [ Remaining_Evaluations ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NUMERICAL VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_invalid_numbers___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invalid_numbers___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_findall(
		( Type, Variable_String ),
		(
			result( _, Type, Variable, Value ),
			sys_string_atom( Variable_String, Variable ),
			(
				header_level_item( _, Data_Item_Name, _, _, _, _, _, _, Variable_String, `Number`, _, _, _, _, _, _ )
				;
				line_level_item( _, Data_Item_Name, _, _, _, _, _, _, Variable_String, `Number`, _, _, _, _, _, _ )
			),
			not( sys_string_number( Value, _ ) ),
			strcat_list( [ Data_Item_Name, ` Invalid (`, Variable_String, `) ` ], Trace ),
			trace( [ Trace, Value ] )
		),
		List_of_Invalid_Numbers_Raw
	),
	
	i_force_list( List_of_Invalid_Numbers_Raw, List_of_Invalid_Numbers ),
	
	invalidate_values( List_of_Invalid_Numbers ),
	
	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
invalidate_values( [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
invalidate_values( [ ( Type, Variable_String ) | Remaining_Items ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		q_sys_member( Variable_String, [ `total_invoice`, `total_net`, `total_vat`, `default_vat_rate`, `total_discount`, `line_total_amount`, `line_net_amount`, `line_vat_amount`, `line_vat_rate`, `line_amount_discount`, `line_percent_discount`, `line_quantity`, `line_unit_amount` ] ),

		sys_string_atom( Variable_String, Variable ),

		sys_retractall( result( _, Type, Variable, _ ) )

		;

		strcat_list( [ `i_analyse_invalid_`, Variable_String ], Invalid_Flag ),
	
		sys_assertz( grammar_set( Type, Invalid_Flag ) )

	),
	
	invalidate_values( Remaining_Items )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DATE VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_invalid_dates___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invalid_dates___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		i_date_format( Date_Format )
		
		;
		
		true
		
	),
	
	sys_findall(
		( Type, Variable_String ),
		(
			result( _, Type, Variable, Value ),
			sys_string_atom( Variable_String, Variable ),
			(
				header_level_item( _, Data_Item_Name, _, _, _, _, _, _, Variable_String, `Date`, _, _, _, _, _, _ )
				;
				line_level_item( _, Data_Item_Name, _, _, _, _, _, _, Variable_String, `Date`, _, _, _, _, _, _ )
			),
			not( q_date_is_legal( Value, Date_Format, _ ) ),
			strcat_list( [ Data_Item_Name, ` Invalid (`, Variable_String, `) ` ], Trace ),
			trace( [ Trace, Value ] )
		),
		List_of_Invalid_Dates_Raw
	),
	
	i_force_list( List_of_Invalid_Dates_Raw, List_of_Invalid_Dates ),
	
	invalidate_values( List_of_Invalid_Dates ),
	
	!
.
