%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_MICRON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_micron, `15/10/2018 16:18:25` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `d_ibm_micron.pro` ).
i_rules_file( `d_iso_currency_codes.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_numerical_validation.pro` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Fields
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_user_field( invoice, customer_id, `customer_id` ).
i_user_field( invoice, plant_code, `Plant Code` ).
i_user_field( invoice, total_local_vat, `Total Local VAT` ).
i_user_field( invoice, exchange_rate, `Exchange Rate` ).
i_user_field( invoice, rounding_amount, `Rounding Amount` ).
i_user_field( invoice, customer_id, `Customer ID` ).
i_user_field( invoice, scan_id, `scan_id` ).
i_user_field( invoice, supplier_bank_name, `supplier_bank_name` ).
i_user_field( invoice, supplier_bank_code, `supplier_bank_code` ).
i_user_field( invoice, supplier_bank_swift, `supplier_bank_swift` ).
i_user_field( invoice, ship_from, `ship_from` ).
i_user_field( invoice, ship_to, `ship_to` ).
i_user_field( invoice, bill_from, `bill_from` ).
i_user_field( invoice, bill_to, `bill_to` ).
i_user_field( invoice, swiss_supplier_name, `swiss_supplier_name` ).
i_user_field( invoice, swiss_supplier_country, `swiss_supplier_country` ).
i_user_field( invoice, swiss_supplier_address_1, `swiss_supplier_address_1` ).
i_user_field( invoice, swiss_supplier_address_2, `swiss_supplier_address_2` ).
i_user_field( invoice, swiss_supplier_address_3, `swiss_supplier_address_3` ).
i_user_field( invoice, swiss_buyer_name, `swiss_buyer_name` ).
i_user_field( invoice, swiss_buyer_address_1, `swiss_buyer_address_1` ).
i_user_field( invoice, swiss_buyer_address_2, `swiss_buyer_address_2` ).
i_user_field( invoice, swiss_buyer_address_3, `swiss_buyer_address_3` ).
i_user_field( invoice, swiss_buyer_address_4, `swiss_buyer_address_4` ).
i_user_field( invoice, swiss_buyer_address_5, `swiss_buyer_address_5` ).
i_user_field( invoice, tax_invoice_flag, `Tax Invoice Flag` ).
i_user_field( invoice, credit_note_flag, `Credit Note Flag` ).

i_user_field( line, line_po_item, `line_po_item` ).
i_user_field( line, line_packing_list, `line_packing_list` ).
i_user_field( line, line_proforma, `line_proforma` ).
i_user_field( line, line_internal_order_number, `line_internal_order_number` ).
i_user_field( line, line_gl, `line_gl` ).
i_user_field( line, line_lot_number, `line_lot_number` ).

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
i_op_param( rules_intervention_role, _, _, _, `Micron Test (Technical)` ):- i_test_indicator. % This will be the role for rules intervention
i_op_param( rules_intervention_role, _, _, _, `Micron (Technical)` ):- not( i_test_indicator ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `Micron Test` ):- i_test_indicator. % This will be the role for customer intervention (this field is mandatory)
i_op_param( customer_name, _, _, _, `Micron` ):- not( i_test_indicator ). % This will be the role for customer intervention (this field is mandatory)

%-----------------------------------------------------------------------
% Duplicate Table to Use
%-----------------------------------------------------------------------
% i_op_param( duplicate_table_to_use, _, _, _, `` ).

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
% PRESERVE TAX INVOICE FLAG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	test( tax_invoice ), tax_invoice_flag( `true` )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PRESERVE CREDIT NOTE FLAG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	test( credit_note ), credit_note_flag( `true` )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PRESERVE TAX INVOICE FLAG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, tax_invoice_flag, Flag )
	
	, check( Flag = `true` )
	
	, set( tax_invoice )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PRESERVE CREDIT NOTE FLAG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, credit_note_flag, Flag )
	
	, check( Flag = `true` )
	
	, set( credit_note )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REMOVE VARIABLES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( buyer_registration_number )
	, remove( plant_code )
	, remove( due_date )
	, remove( buyers_code_for_supplier )
	, remove( buyer_vat_number )
	, remove( total_percent_discount )
	, remove( supplier_bank_ogm )
	, remove( payment_terms )
	, remove( narrative )
	, remove( customer_comments )
	, remove( erp_ref_number )
	, remove( total_discount )
	, remove( por_reference )
	, remove( tax_reporting_country )
	, remove( vat_region )
	, remove( attention_of )
	, remove( ob10_link )
	, remove( payment_reference )
	, remove( ship_from )
	, remove( swiss_date_of_supply )

	, remove( line_cost_centre )
	, remove( line_internal_order_number )
	, remove( line_gl )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SCAN ID & CUSTOMER ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_scan_id_and_customer_id___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_scan_id_and_customer_id___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	instance( I ),
	string_to_upper( I, I_U ),
	(
		not( q_sys_sub_string( I_U, _, _, `DBG` ) ),
		i_mail( unique_id, ID ),
		sys_string_number( IDS, ID )
		;
		q_sys_sub_string( I_U, _, _, `DBG` ),
		IDS = `Test`
	),
	string_pad_left( IDS, 8, `0`, IDPad ),
	date_get( today, Today ),
	sys_date_string( Today, 'yyyy-mm-dd', TodayWithHyphen ),
	strip_string2_from_string1( TodayWithHyphen, `-`, TodayString ),
	strcat_list( [ TodayString, `_CT`, IDPad ], Scan_ID ),

	sys_retractall( result( _, invoice, scan_id, _ ) ),
	assertz_derived_data( invoice, scan_id, Scan_ID, i_analyse_scan_id_and_customer_id ),

	sys_retractall( result( _, invoice, customer_id, _ ) ),
	assertz_derived_data( invoice, customer_id, Scan_ID, i_analyse_scan_id_and_customer_id ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CURRENCY CODE VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_currency_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_currency_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, currency, Currency ),

	sys_retractall( result( _, invoice, currency, _ ) ),

	string_to_upper( Currency, Currency_U ),

	(
		iso_currency_code( Currency_U ),

		assertz_derived_data( invoice, currency, Currency_U, i_analyse_currency )

		;

		trace( [ `currency invalid - value removed`, Currency ] )

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

		result( _, invoice, tax_invoice, _ ),

		assertz_derived_data( invoice, invoice_type, `Tax Invoice`, i_analyse_invoice_type )

		;

		assertz_derived_data( invoice, invoice_type, `Invoice`, i_analyse_invoice_type )

	),

	!
.
