%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_INVERT_VALUES_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_invert_values_v2, `01/02/2023 15:53:36` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVERT HEADER VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_last:- i_analyse_invert_header_values___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invert_header_values___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	header_level_scenario( _, `Credit Note`, _, _, Action, _, _, _, _, _, _, _, Dependency ),
	
	sys_call( Dependency ),
	
	q_sys_member( Action, [ `Process With Negative Values`, `Process With Positive Values` ] ),
	
	check_and_invert_values( Action, invoice, [ total_net, total_invoice, total_vat ] ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_and_invert_values( _, _, [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_and_invert_values( Action, Type, [ H | T ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	not( grammar_set( invert_nothing ) ),
	
	(
		not( result( _, Type, H, _ ) ) -> true

		;

		result( _, Type, H, Value ),

		(
			grammar_set( invert_everything )

			;

			(
				Action = `Process With Negative Values`,
				
				q_sys_comp_str_gt( Value, `0` )
				
				;
				
				Action = `Process With Positive Values`,
				
				q_sys_comp_str_gt( `0`, Value )
				
			),

			sys_assertz( grammar_set( invert_everything ) )

			;

			sys_assertz( grammar_set( invert_nothing ) )

		),

		not( grammar_set( invert_nothing ) ),

		sys_calculate_str_multiply( Value, `-1`, InvertedValue ),

		sys_retractall( result( _, Type, H, Value ) ),

		assertz_derived_data( Type, H, InvertedValue, variable_inverted )

	),

	check_and_invert_values( Action, Type, T )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVERT LINE VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_invert_line_values___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invert_line_values___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	header_level_scenario( _, `Credit Note`, _, _, Action, _, _, _, _, _, _, _, Dependency ),
	
	sys_call( Dependency ),

	not( grammar_set( invert_nothing ) ),
	
	grammar_set( invert_everything ),
	
	(
		Action = `Process With Negative Values`,
	
		check_and_invert_values( Action, LID, [ line_unit_amount, line_net_amount, line_vat_amount, line_total_amount ] )
		
		;
		
		Action = `Process With Positive Values`,
		
		(
			result( _, LID, line_unit_amount, Unit ),
			
			(
				q_sys_comp_str_ge( Unit, `0` ),
			
				check_and_invert_values( Action, LID, [ line_quantity, line_net_amount, line_vat_amount, line_total_amount ] )
				
				;
				
				q_sys_comp_str_lt( Unit, `0` ),
				
				check_and_invert_values( Action, LID, [ line_unit_amount, line_net_amount, line_vat_amount, line_total_amount ] )
				
			)
			
			;
			
			result( _, LID, line_quantity, Quantity ),
			
			(
				q_sys_comp_str_ge( Quantity, `0` ),
			
				check_and_invert_values( Action, LID, [ line_unit_amount, line_net_amount, line_vat_amount, line_total_amount ] )
				
				;
				
				q_sys_comp_str_lt( Quantity, `0` ),
				
				check_and_invert_values( Action, LID, [ line_quantity, line_net_amount, line_vat_amount, line_total_amount ] )
				
			)
			
			;
			
			check_and_invert_values( Action, LID, [ line_net_amount, line_vat_amount, line_total_amount ] )
			
		)
		
	),

	!
.
