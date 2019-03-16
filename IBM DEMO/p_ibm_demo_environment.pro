%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_DEMO_ENVIRONMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_demo_environment, `08/08/2018 14:43:59` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
,,,,,,,,,,,,,,,,,,,,,,, % Syntax error to crash instances as they need to be shut down and I cannot access server right now - will fix later today
i_rules_file( `d_ibm_demo_environment.pro` ).
i_rules_file( `d_ibm_demo_extra_variables.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Fields
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_user_field( invoice, rounding_amount, `Rounding Amount` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CUSTOMER INFORMATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% Customer Name
%-----------------------------------------------------------------------
i_op_param( rules_intervention_role, _, _, _, `IBM Demo (Technical)` ). % This will be the role for customer intervention
i_op_param( customer_name, _, _, _, `IBM Demo` ). % This will be the role for customer intervention

%-----------------------------------------------------------------------
% Customer Forward Address List
%-----------------------------------------------------------------------
% i_op_param( customer_forward_address_list, _, _, _, `` ).

%-----------------------------------------------------------------------
% Custom Scenario
%-----------------------------------------------------------------------
% document_reason_lookup( ``, ``, ``, _, _ ).

%-----------------------------------------------------------------------
% Email Template Beginning Text
%-----------------------------------------------------------------------
beginning_text( Text )
:-
	i_mail( to, To ),
	i_mail( from, From ),
	i_mail( received_date, Date ),
	q_sys_sub_string( Date, 4, 2, Day ),
	q_sys_sub_string( Date, 1, 2, Month_no ),
	month_lookup( Month_no, Month ),
	q_sys_sub_string( Date, 7, 4, Year ),
	q_sys_sub_string( Date, 12, 5, Time ),
	strcat_list( [ `The attached document was submitted to `, To, ` by `, From, ` at `, Time, ` (GMT) on `, Day, ` `, Month, ` `, Year, `. Documents submitted to this address are processed by an automated system which extracts data from the text contained within the document.<br><br>Unfortunately this document cannot be processed because of the following errors that have been detected by the system:<br><br><br>` ], Text )
.

%-----------------------------------------------------------------------
% Email Template Remaining Rejection Text
%-----------------------------------------------------------------------
remaining_rejection_text( Text )
:-
	Text = `<br>
<br>
Please can you amend and resubmit. If you have any queries, please email your customer contact.<br>
<br>
Thank you<br>
<br>
<br>
<br>
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND`
.

%-----------------------------------------------------------------------
% Email Template Remaining Forward Text
%-----------------------------------------------------------------------
remaining_forward_text( Text )
:-
	Text = `<br>
<br>
As the document has not been processed, it will need to be dealt with manually.<br>
<br>
Kindest regards<br>
<br>
<br>
<br>
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND`
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE TOTALS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_missing_invoice_totals___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_missing_invoice_totals___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		not( result( _, invoice, total_net, _ ) ),
		result( _, invoice, total_vat, VAT ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			not( result( _, invoice, rounding_amount, _ ) ),
			Sub_3 = `0`
		),
		result( _, invoice, total_invoice, Total ),
		sys_calculate_str_add( VAT, Sub_3, X ),
		sys_calculate_str_subtract( Total, X, Net ),
		assertz_derived_data( invoice, total_net, Net, i_analyse_total_net )

		;

		not( result( _, invoice, total_vat, _ ) ),
		result( _, invoice, total_net, Net ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			not( result( _, invoice, rounding_amount, _ ) ),
			Sub_3 = `0`
		),
		result( _, invoice, total_invoice, Total ),
		sys_calculate_str_add( Net, Sub_3, X ),
		sys_calculate_str_subtract( Total, X, VAT ),
		assertz_derived_data( invoice, total_vat, VAT, i_analyse_total_vat )

		;

		not( result( _, invoice, total_invoice, _ ) ),
		result( _, invoice, total_net, Net ),
		result( _, invoice, total_vat, VAT ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			not( result( _, invoice, rounding_amount, _ ) ),
			Sub_3 = `0`
		),
		sys_calculate_str_add( Net, VAT, X ),
		sys_calculate_str_add( X, Sub_3, Total ),
		assertz_derived_data( invoice, total_invoice, Total, i_analyse_total_invoice )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVOICE TYPE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_invoice_type___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_type___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, invoice, invoice_type, _ ) ),

	(
		grammar_set( credit_note ),

		assertz_derived_data( invoice, invoice_type, `CN`, i_analyse_invoice_type )

		;

		result( _, invoice, order_number, _ ),

		assertz_derived_data( invoice, invoice_type, `PO`, i_analyse_invoice_type )

		;

		assertz_derived_data( invoice, invoice_type, `NP`, i_analyse_invoice_type )

	),

	!
.
