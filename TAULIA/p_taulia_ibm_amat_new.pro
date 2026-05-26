%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_TAULIA_IBM_AMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_taulia_ibm_amat, `2026-05-22 07:54:53` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_final_rule( [ check( save_flags_for_completion ) ] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_trace_lists.

i_rules_file( `d_taulia_ibm_amat.pro` ).

i_rules_file( `u_process_params_v2.pro` ).
i_rules_file( `u_predicates_and_lookups_v2.pro` ).

i_rules_file( `u_insert_connection_codes_v2.pro` ).
i_rules_file( `u_invert_values_v2.pro` ).
i_rules_file( `u_portal_values_v2.pro` ).

i_rules_file( `u_invoice_number_validation_v2.pro` ).
i_rules_file( `u_data_format_validation_v2.pro` ).
i_rules_file( `u_date_validation_v2.pro` ).
i_rules_file( `u_supporting_document_v2.pro` ).
i_rules_file( `p_duplicate_v2.pro` ).

i_rules_file( `u_error_detection_v2.pro` ).
i_rules_file( `u_error_conditions_v2.pro` ).
i_rules_file( `u_intervention_analysis_v2.pro` ).
i_rules_file( `u_failure_automation_v2.pro` ).
i_rules_file( `u_intervention_generation_v2.pro` ).
i_rules_file( `u_json_functions_v2.pro` ).

i_rules_file( `u_taulia.pro` ).

%-----------------------------------------------------------------------
% Order Number Regexp (Must not include beginning and end of string characters)
%-----------------------------------------------------------------------
% i_op_param( order_number_regexp, _, _, _, `` ).

%-----------------------------------------------------------------------
% Old Date Check Number of Days (i_op_param required for each variable to check)
%-----------------------------------------------------------------------
% i_op_param( old_date_check_number_of_days( invoice_date ), _, _, _, `` ).

%-----------------------------------------------------------------------
% Future Date Check Number of Days (i_op_param required for each variable to check)
%-----------------------------------------------------------------------
% i_op_param( future_date_check_number_of_days( invoice_date ), _, _, _, `` ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without(supplier_registration_number)
	, supplier_registration_number( FROM )
	
] ):- i_mail( from, FROM ).

%=======================================================================
i_final_rule( [
%=======================================================================

	without(suppliers_code_for_buyer ) % 610037
	, without(buyer_registration_number)
	, buyer_registration_number( TO )
	
] ):- i_mail( to, TO ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVALID CURRENCY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_invalid_currency___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invalid_currency___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, currency, Currency ),
	not( q_regexp_match( `^[A-Z]{3}$`, Currency, _ ) ),
	sys_retractall( result( _, invoice, currency, _ ) ),
	trace( [ `Invalid Currency, Removed`, Currency ] ),
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INDIA TCS TAX TOTALS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_india_tcs_tax_totals___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_india_tcs_tax_totals___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	grammar_set( amat_tcs_india_tax ),
	result( _, invoice, vat_rate_1, _ ),

	(	result( _, invoice, rate_1_net, Net ),
		(	result( _, invoice, total_net, _ )
			->	sys_retractall( result( _, invoice, total_net, _ ) )
			;	true
		),
		assertz_derived_data( invoice, total_net, Net )
		;	true
	),

	(	result( _, invoice, rate_1_gross, Gross ),
		(	result( _, invoice, total_invoice, _ )
			->	sys_retractall( result( _, invoice, total_invoice, _ ) )
			;	true
		),
		assertz_derived_data( invoice, total_invoice, Gross )
		;	true
	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ROUNDING DISCREPANCY - TAX
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:-i_analyse_tax_discrepancy.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_tax_discrepancy
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, total_vat, Total_VAT ),
	sys_findall(
		Total,
		(
			(
				result( _, LID, line_credit_indicator, `true` ),
				result( _, LID, line_vat_amount, PreTotal ),
				sys_calculate_str_multiply( PreTotal, `-1`, Total )
				;
				result( _, LID, line_credit_indicator, LCI ),
				not( LCI == `true` ),
				result( _, LID, line_vat_amount, Total )
				;
				not( result( _, LID, line_credit_indicator, _ ) ),
				result( _, LID, line_vat_amount, Total )
			),
			sys_string_number( Total, _ )
		),
		List_of_totals_Raw
	),
	
	i_force_list( List_of_totals_Raw, List_of_totals ),
    
	i_user_check( sum_string_list, List_of_totals, Sum_of_totals ),

	not( q_sys_comp_str_eq( Sum_of_totals, Total_VAT ) ),

	sys_calculate_str_subtract( Total_VAT, Sum_of_totals, Difference ),

	q_sys_comp_str_le( Difference, `0.1` ),
	q_sys_comp_str_ge( Difference, `-0.1` ),

	result( _, LID, line_vat_amount, Line_VAT ),

	not( q_sys_comp_str_eq( Line_VAT, `0` ) ),

	sys_calculate_str_add( Line_VAT, Difference, New_Line_VAT ),

	sys_retractall( result( _, LID, line_vat_amount, _ ) ),

	result( _, LID, line_total_amount, Line_gross ),

	sys_calculate_str_add( Line_gross, Difference, New_Line_gross ),

	sys_retractall( result( _, LID, line_total_amount, _ ) ),

	assertz_derived_data( LID, line_vat_amount, New_Line_VAT, i_analyse_tax_discrepancy_line ),

	assertz_derived_data( LID, line_total_amount, New_Line_gross, i_analyse_tax_discrepancy_line ),
 
    !

.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINE_BUYERS_ORDER_NUMBER VALIDITY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):-i_analyse_line_buyers_order_number( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_buyers_order_number( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
  
	result( _, LID, line_buyers_order_number, LBON ),
	(

		q_regexp_match( `^\\d{1,5}$`, LBON, _ )

		;

		sys_assertz( grammar_set( invalid_line_buyers_order_number ) ),
		sys_retractall( result( _, LID, line_buyers_order_number, _ ) ),
		debug( [ `line_buyers_order_number removed - invalid format` ] )

	),

    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PREDICATES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
%
%-----------------------------------------------------------------------
