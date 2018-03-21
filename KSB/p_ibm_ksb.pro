%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_KSB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_ksb, `21/03/2018 12:07:01` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_ksb.pro` ).
i_rules_file( `d_iso_currency_codes.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_invoice_date_validation.pro` ).
i_rules_file( `u_numerical_validation.pro` ).

i_op_param( unique_id, _, To, _, Scan_ID )
:-
	instance( I ),
	string_to_upper( I, I_U ),
	q_sys_sub_string( I_U, _, _, `DBG` ),
	IDS = `Test`,
	string_pad_left( IDS, 8, `0`, IDPad ),
	date_get( today, Today ),
	sys_date_string( Today, 'yyyy-mm-dd', TodayWithHyphen ),
	strip_string2_from_string1( TodayWithHyphen, `-`, TodayString ),
	strcat_list( [ TodayString, `_CT`, IDPad ], Scan_ID )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Fields
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_user_field( invoice, plant_code, `Plant Code` ).
i_user_field( invoice, total_local_vat, `Total Local VAT` ).
i_user_field( invoice, total_percent_discount, `total_percent_discount` ).
i_user_field( invoice, exchange_rate, `Exchange Rate` ).
i_user_field( invoice, rounding_amount, `Rounding Amount` ).
i_user_field( invoice, por_reference, `POR Reference` ).
i_user_field( invoice, customer_id, `Customer ID` ).
i_user_field( invoice, supplier_bank_iban, `supplier_bank_iban` ).
i_user_field( invoice, supplier_bank_account_number_2, `supplier_bank_account_number_2` ).
i_user_field( invoice, supplier_bank_code_2, `supplier_bank_code_2` ).
i_user_field( invoice, supplier_bank_iban_2, `supplier_bank_iban_2` ).
i_user_field( invoice, supplier_bank_account_number_3, `supplier_bank_account_number_3` ).
i_user_field( invoice, supplier_bank_code_3, `supplier_bank_code_3` ).
i_user_field( invoice, supplier_bank_iban_3, `supplier_bank_iban_3` ).
i_user_field( invoice, supplier_bank_account_number_4, `supplier_bank_account_number_4` ).
i_user_field( invoice, supplier_bank_code_4, `supplier_bank_code_4` ).
i_user_field( invoice, supplier_bank_iban_4, `supplier_bank_iban_4` ).
i_user_field( invoice, supplier_bank_account_number_5, `supplier_bank_account_number_5` ).
i_user_field( invoice, supplier_bank_code_5, `supplier_bank_code_5` ).
i_user_field( invoice, supplier_bank_iban_5, `supplier_bank_iban_5` ).
i_user_field( invoice, supplier_bank_account_number_6, `supplier_bank_account_number_6` ).
i_user_field( invoice, supplier_bank_code_6, `supplier_bank_code_6` ).
i_user_field( invoice, supplier_bank_iban_6, `supplier_bank_iban_6` ).
i_user_field( invoice, tax_invoice_flag, `Tax Invoice Flag` ).

i_user_field( line, line_internal_order_number, `Line Internal Order Number` ).
i_user_field( line, line_gl, `Line GL` ).

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
i_op_param( rules_intervention_role, _, _, _, `KSB Test (Technical)` ):- i_test_indicator. % This will be the role for rules intervention
i_op_param( rules_intervention_role, _, _, _, `KSB (Technical)` ):- not( i_test_indicator ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `KSB Test` ):- i_test_indicator. % This will be the role for customer intervention (this field is mandatory)
i_op_param( customer_name, _, _, _, `KSB` ):- not( i_test_indicator ). % This will be the role for customer intervention (this field is mandatory)
i_op_param( default_rts_email_subject, _, _, _, `KSB Invoice Processing Error` ).
i_op_param( default_forward_email_subject, _, _, _, `KSB Invoice Processing Error` ).

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
document_reason_lookup( `Multiple POs Quoted`, `failed`, `i_anlyse_multiple_po_quoted`, _, _ ).

%-----------------------------------------------------------------------
% Email Template Beginning Text
%-----------------------------------------------------------------------
beginning_text( Text )
:-
	Text = `Dear Sir/Madam,<br>Your document has been rejected by our Accounts Payable Department due to following reason:<br><br>`
.

%-----------------------------------------------------------------------
% Email Template Remaining Rejection Text
%-----------------------------------------------------------------------
remaining_rejection_text( Text )
:-
	(
		( result( _, invoice, buyer_registration_number, `1001` ); data( invoice, buyer_registration_number, `1001` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		( result( _, invoice, buyer_registration_number, `1009` ); data( invoice, buyer_registration_number, `1009` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1009@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		( result( _, invoice, buyer_registration_number, `1017` ); data( invoice, buyer_registration_number, `1017` ) ),
		Contact_Details = `Invoices:  AP_Invoices_AT@ksb.com<br>Accounts Payable Team: AP_Queries_AT@ksb.com / +43 5 910 30 333`
		;
		( result( _, invoice, buyer_registration_number, `1025` ); data( invoice, buyer_registration_number, `1025` ) ),
		Contact_Details = `Invoices:  AP_Invoices_CH@ksb.com<br>Accounts Payable Team: AP_Queries_CH@ksb.com / +41 432 109 911`
		;
		( result( _, invoice, buyer_registration_number, `1011` ); data( invoice, buyer_registration_number, `1001` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		not( result( _, invoice, buyer_registration_number, _ ) ), not( data( invoice, buyer_registration_number, _ ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
	),
	strcat_list( [ `<br><br>Below we are attaching copy of the document image for your reference.<br>Please send us a corrected invoice to email address for invoices, you don't have to send us Credit Note as we don't register your invoice in our books.<br>If you are not involved in billing process for KSB we kindly ask you to forward this message to the relevant department in your company.<br>In case of any questions please contact Accounts Payable Team.<br>Thank you for your understanding.<br>With kind regards,<br>KSB Accounts Payable Team<br><br>Contact details:<br>`, Contact_Details, `<br><br>THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND` ], Text )
.

%-----------------------------------------------------------------------
% Email Template Remaining Forward Text
%-----------------------------------------------------------------------
remaining_forward_text( Text )
:-
	(
		( result( _, invoice, buyer_registration_number, `1001` ); data( invoice, buyer_registration_number, `1001` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		( result( _, invoice, buyer_registration_number, `1009` ); data( invoice, buyer_registration_number, `1009` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1009@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		( result( _, invoice, buyer_registration_number, `1017` ); data( invoice, buyer_registration_number, `1017` ) ),
		Contact_Details = `Invoices:  AP_Invoices_AT@ksb.com<br>Accounts Payable Team: AP_Queries_AT@ksb.com / +43 5 910 30 333`
		;
		( result( _, invoice, buyer_registration_number, `1025` ); data( invoice, buyer_registration_number, `1025` ) ),
		Contact_Details = `Invoices:  AP_Invoices_CH@ksb.com<br>Accounts Payable Team: AP_Queries_CH@ksb.com / +41 432 109 911`
		;
		( result( _, invoice, buyer_registration_number, `1011` ); data( invoice, buyer_registration_number, `1001` ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
		;
		not( result( _, invoice, buyer_registration_number, _ ) ), not( data( invoice, buyer_registration_number, _ ) ),
		Contact_Details = `Invoices:  AP_Invoices_DE_1001@ksb.com<br>Accounts Payable Team: AP_Queries_DE@ksb.com / +49623386 1133`
	),
	strcat_list( [ `<br><br>Below we are attaching copy of the document image for your reference.<br>Please send us a corrected invoice to email address for invoices, you don't have to send us Credit Note as we don't register your invoice in our books.<br>If you are not involved in billing process for KSB we kindly ask you to forward this message to the relevant department in your company.<br>In case of any questions please contact Accounts Payable Team.<br>Thank you for your understanding.<br>With kind regards,<br>KSB Accounts Payable Team<br><br>Contact details:<br>`, Contact_Details, `<br><br>THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND` ], Text )
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FIXED VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	plant_code( `0000` )
	, due_date( `01/01/1900` )
	, total_percent_discount( `0` )
	, exchange_rate( `0` )
	, total_local_vat( `0` )
	, total_discount( `0.0000` )

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

	remove( buyer_vat_number )
	, remove( supplier_bank_ogm )
	, remove( payment_terms )
	, remove( narrative )
	, remove( customer_comments )
	, remove( erp_ref_number )
	, remove( por_reference )
	, remove( tax_reporting_country )
	, remove( vat_region )
	, remove( ob10_link )
	, remove( payment_reference )
	, remove( ship_from_dummy )
	, remove( ship_to_dummy )
	, remove( bill_from_dummy )
	, remove( bill_to_dummy )

	, remove( line_cost_centre )
	, remove( line_internal_order_number )
	, remove( line_gl )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BANK ACCOUNTS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	q10( [ without( supplier_bank_account_number ), supplier_bank_account_number( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code ), supplier_bank_code( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban ), supplier_bank_iban( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_account_number_2 ), supplier_bank_account_number_2( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code_2 ), supplier_bank_code_2( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban_2 ), supplier_bank_iban_2( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_account_number_3 ), supplier_bank_account_number_3( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code_3 ), supplier_bank_code_3( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban_3 ), supplier_bank_iban_3( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_account_number_4 ), supplier_bank_account_number_4( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code_4 ), supplier_bank_code_4( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban_4 ), supplier_bank_iban_4( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_account_number_5 ), supplier_bank_account_number_5( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code_5 ), supplier_bank_code_5( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban_5 ), supplier_bank_iban_5( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_account_number_6 ), supplier_bank_account_number_6( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_code_6 ), supplier_bank_code_6( `XXXXXX` ) ] )
	, q10( [ without( supplier_bank_iban_6 ), supplier_bank_iban_6( `XXXXXX` ) ] )

] ).

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

	check( i_analyse_order_number___ )

] ).

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_order_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, order_number, Order_Number ),

	sys_retractall( result( _, invoice, order_number, _ ) ),

	string_to_upper( Order_Number, Order_Number_U ),

	(
		i_user_check( gen_clean_and_extract_from_string, Order_Number_U, Order_Number_Final ),

		q_regexp_match( `^4\\d{9}$`, Order_Number_Final, _ ),

		assertz_derived_data( invoice, order_number, Order_Number_Final, i_analyse_order_number )

		;

		trace( [ `order_number invalid - value removed`, Order_Number ] )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ADD A SINGLE SUMMARY LINE FOR NON-PO INVOICES MORE THAN 50 LINES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without( order_number )

	, with( 51, _, _ )

	, remove( line_item ), remove( line_item_for_buyer ), remove( line_descr ), remove( line_pack_size ), remove( line_reference )
	, remove( line_start_date ), remove( line_end_date ), remove( line_from_date ), remove( line_to_date ), remove( line_delivery_note_number )
	, remove( line_buyers_order_number ), remove( line_order_line_number ), remove( line_original_order_date )
	, remove( line_net_amount ), remove( line_quantity ), remove( line_unit_amount ), remove( line_percent_discount )
	, remove( line_amount_discount ), remove( line_vat_rate ), remove( line_vat_code ), remove( line_vat_amount )
	, remove( line_total_amount ), remove( line_quantity_uom_code ), remove( line_price_uom_code )
	, remove( line_charge_period_uom_code ), remove( line_charge_period_uom_descr ), remove( line_charge_period )

	, line_quantity( `1` )
	, line_descr( `Page Summary` )

	, q10( [ with( invoice, total_net, Net )
		, line_net_amount( Net )
		, set( summary_net_used )
	] )
	, q10( [ with( invoice, total_invoice, Gross )
		, line_total_amount( Gross )
		, set( summary_gross_used )
	] )
	, q10( [ with( invoice, total_vat, VAT )
		, line_vat_amount( VAT )
		, set( summary_vat_used )
	] )

	, or( [ test( summary_gross_used ), test( summary_net_used ), test( summary_vat_used ) ] )

	, trace( [ `Summary line Created`, line_descr, line_net_amount, line_total_amount ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DELAY FILES TOO CLOSE TO MIDNIGHT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_midnight_delay___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_midnight_delay___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	instance( Inst ),

	string_to_upper( Inst, INST ),

	not( q_sys_sub_string( INST, _, _, `DBG` ) ),
	
	time_get( now, time( Hour, Minute, Second ) ),

	(
		Hour = 23,

		Minute >= 30

		;

		Hour = 0,

		Minute < 15

	),

	trace( [ `Time now: `, Hour, Minute, Second, `Too close to midnight, delaying file to ensure correct time stamp.` ] ),

	sys_assertz( grammar_set( chain, `*delay*` ) ), sys_assertz( grammar_set( delay_mins, 15 ) ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PLANT CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_plant_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_plant_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( to, To ),

	q_sys_sub_string( To, _, _, `ksb_fr` ),
	
	result( _, invoice, order_number, Order_Number ),

	sys_string_number( Order_Number, _ ),

	plant_code_lookup( Plant_Code, Min, Max ),

	q_sys_comp_str_ge( Order_Number, Min ),
		
	q_sys_comp_str_le( Order_Number, Max ),

	sys_retractall( result( _, invoice, plant_code, _ ) ),

	assertz_derived_data( invoice, plant_code, Plant_Code, i_analyse_plant_code ),

	sys_assertz( grammar_set( service_invoice ) ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUYER PARTY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_party___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_party___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_party, Party ),

	(
		string_to_upper( Party, Party_U ),

		buyer_party_city_lookup( _, Party_Lookup, _ ),

		string_to_upper( Party_Lookup, Party_U )

		;

		sys_retractall( result( _, invoice, buyer_party, _ ) ),

		trace( [ `Buyer party invalid, removed`, Party ] )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUYER CITY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_city___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_city___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_city, City ),

	(
		string_to_upper( City, City_U ),

		buyer_party_city_lookup( _, _, City_Lookup ),

		string_to_upper( City_Lookup, City_U )

		;

		sys_retractall( result( _, invoice, buyer_city, _ ) ),

		trace( [ `Buyer city invalid, removed`, City ] )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% COMPANY CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_registration_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_registration_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( to, To ),

	result( _, invoice, buyer_party, _ ),

	result( _, invoice, buyer_city, _ ),
	
	!,

	sys_retractall( result( _, invoice, buyer_registration_number, _ ) ),
	
	(
		q_sys_sub_string( To, _, _, `ksb_de_1001` ),

		assertz_derived_data( invoice, buyer_registration_number, `1001`, i_analyse_buyer_registration_number )

		;

		q_sys_sub_string( To, _, _, `ksb_de_1009` ),

		assertz_derived_data( invoice, buyer_registration_number, `1009`, i_analyse_buyer_registration_number )

		;

		q_sys_sub_string( To, _, _, `ksb_at` ),

		assertz_derived_data( invoice, buyer_registration_number, `1017`, i_analyse_buyer_registration_number )

		;

		q_sys_sub_string( To, _, _, `ksb_ch` ),

		assertz_derived_data( invoice, buyer_registration_number, `1025`, i_analyse_buyer_registration_number )

		;

		q_sys_sub_string( To, _, _, `ksb_fr` ),

		assertz_derived_data( invoice, buyer_registration_number, `1011`, i_analyse_buyer_registration_number )

		;

		instance( I ),

		string_to_upper( I, I_U ),

		q_sys_sub_string( I_U, _, _, `DBG` ),

		assertz_derived_data( invoice, buyer_registration_number, `TEST`, i_analyse_buyer_registration_number )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NEGATIVE TOTALS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_negative_totals___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_negative_totals___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_error_negative_totals,

	sys_assertz( grammar_set( credit_note ) ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE CUSTOMER ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_customer_id___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_customer_id___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	qq_op_param( unique_id, Scan_ID ),

	sys_retractall( result( _, invoice, customer_id, _ ) ),

	assertz_derived_data( invoice, customer_id, Scan_ID, i_analyse_customer_id ),

	!
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
% VENDOR ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_vendor_id___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_vendor_id___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyers_code_for_supplier, BCFS ),

	sys_retractall( result( _, invoice, buyers_code_for_supplier, _ ) ),

	string_pad_left( BCFS, 10, `0`, BCFS_Padded ),

	assertz_derived_data( invoice, buyers_code_for_supplier, BCFS_Padded, i_analyse_vendor_id ),

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

		Credit_Note = `true`

		;

		Credit_Note = `false`

	),

	!,

	(
		grammar_set( debit_note ),

		Debit_Note = `true`

		;

		Debit_Note = `false`

	),

	!,

	(
		grammar_set( service_invoice ),

		Service_Invoice = `true`

		;

		Service_Invoice = `false`

	),

	!,

	(
		result( _, invoice, order_number, _ ),

		Order_Number = `true`

		;

		Order_Number = `false`

	),

	!,

	get_invoice_type( Credit_Note, Debit_Note, Service_Invoice, Order_Number, Type ),

	assertz_derived_data( invoice, invoice_type, Type, i_analyse_invoice_type ),

	!
.

% get_invoice_type( Credit_Note, Debit_Note, Service_Invoice, Order_Number, Type )
get_invoice_type( `false`, `false`, `false`, `false`, `INV` ).
get_invoice_type( `false`, `false`, `false`, `true`, `INVPO` ).
get_invoice_type( `true`, `false`, `false`, `false`, `CN` ).
get_invoice_type( `true`, `false`, `false`, `true`, `CNPO` ).
get_invoice_type( `false`, `true`, `false`, `false`, `DN` ).
get_invoice_type( `false`, `true`, `false`, `true`, `DNPO` ).
get_invoice_type( `false`, `false`, `true`, _, `SF` ).
get_invoice_type( `true`, `false`, `true`, _, `CNSF` ).

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
% REMOVE INVALID UNIT AMOUNT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_quantity_and_unit_amounts___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_quantity_and_unit_amounts___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_error_quantity_and_unit_and_net_amounts_inconsistent( LID, `0` ),

	sys_retractall( result( _, LID, line_unit_amount, _ ) ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINE ORDER LINE NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_order_line_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_order_line_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, LID, line_order_line_number, _ ) ),

	sys_calculate( Line_Number, LID * 10 ),

	assertz_derived_data( LID, line_order_line_number, Line_Number, i_analyse_line_order_line_number ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINE VAT CODES AND RATES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_vat_code_and_rate___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_vat_code_and_rate___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyers_code_for_supplier, BCFS ),
	
	(
		result( _, LID, line_vat_code, _ ),

		sys_retractall( result( _, LID, line_vat_code, _ ) )

		;

		true

	),

	(
		result( _, invoice, buyer_registration_number, `1001` ),

		tax_code_matrix( BCFS, Line_VAT_Rate, Line_VAT_Code, _, _, _, _ ),

		Line_VAT_Code \= `??`,

		assertz_derived_data( LID, line_vat_code, Line_VAT_Code, i_analyse_line_vat_code_and_rate ),

		sys_retractall( result( _, LID, line_vat_rate, _ ) ),

		assertz_derived_data( LID, line_vat_rate, Line_VAT_Rate, i_analyse_line_vat_code_and_rate )

		;

		result( _, invoice, buyer_registration_number, `1009` ),

		tax_code_matrix( BCFS, _, _, Line_VAT_Rate, Line_VAT_Code, _, _ ),

		Line_VAT_Code \= `??`,

		assertz_derived_data( LID, line_vat_code, Line_VAT_Code, i_analyse_line_vat_code_and_rate ),

		sys_retractall( result( _, LID, line_vat_rate, _ ) ),

		assertz_derived_data( LID, line_vat_rate, Line_VAT_Rate, i_analyse_line_vat_code_and_rate )

		;

		result( _, invoice, buyer_registration_number, `1011` ),

		tax_code_matrix( BCFS, _, _, _, _, Line_VAT_Rate, Line_VAT_Code ),

		Line_VAT_Code \= `??`,

		assertz_derived_data( LID, line_vat_code, Line_VAT_Code, i_analyse_line_vat_code_and_rate ),

		sys_retractall( result( _, LID, line_vat_rate, _ ) ),

		assertz_derived_data( LID, line_vat_rate, Line_VAT_Rate, i_analyse_line_vat_code_and_rate )

		;

		assertz_derived_data( LID, line_vat_code, `??`, i_analyse_line_vat_code_and_rate )
		
	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINE BUYERS ORDER NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_buyers_order_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_buyers_order_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		result( _, LID, line_buyers_order_number, LBON ),

		sys_retractall( result( _, LID, line_buyers_order_number, _ ) ),

		string_to_upper( LBON, LBON_U ),

		(
			i_user_check( gen_clean_and_extract_from_string, LBON_U, LBON_Final ),

			q_regexp_match( `^4\\d{9}$`, LBON_Final, _ ),

			assertz_derived_data( LID, line_buyers_order_number, LBON_Final, i_analyse_line_buyers_order_number )
			
			;
			
			(
				result( _, invoice, order_number, PO ),
			
				trace( [ `Line PO number invalid`, LBON ] ),
				trace( [ `Using header PO value instead`, PO ] ),

				assertz_derived_data( LID, line_buyers_order_number, PO, i_analyse_line_buyers_order_number )

				;

				trace( [ `Line PO number invalid, removed`, LBON ] )

			)

		)

		;
		
		not( result( _, LID, line_buyers_order_number, _ ) ),

		(
			result( _, invoice, order_number, PO ),
			
			trace( [ `Line PO number missing` ] ),
			trace( [ `Using header PO value instead`, PO ] ),

			assertz_derived_data( LID, line_buyers_order_number, PO, i_analyse_line_buyers_order_number )

			;

			true

		)

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINE BUYERS ORDER NUMBER FOR FREIGHT LINE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_buyers_order_number_for_freight___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_buyers_order_number_for_freight___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, LID, line_descr, Descr ),

	string_to_lower( Descr, Descr_L ),

	freight_description_lookup( Keyword ),

	string_to_lower( Keyword, Keyword_L ),

	q_sys_sub_string( Descr_L, _, _, Keyword_L ),

	sys_retractall( result( _, LID, line_buyers_order_number, _ ) ),

	assertz_derived_data( LID, line_buyers_order_number, `FC`, i_analyse_line_buyers_order_number_for_freight ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REMOVE DESCRIPTION FOR PO INVOICES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_description___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_description___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, order_number, _ ),

	sys_retractall( result( _, LID, line_descr, _ ) ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR MULTIPLE POS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_multiple_po_quoted___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_multiple_po_quoted___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, order_number, PO ),

	result( LID, invoice, line_buyers_order_number, Line_PO ),

	Line_PO \= PO,

	sys_string_number( LID_S, LID ),

	strcat_list( [ `Multiple POs Quoted - Header Level PO: `, PO, `, Line Level PO (Line `, LID_S, `): `, Line_PO ], Trace ),

	trace( [ Trace ] ),
	
	sys_assertz( grammar_set( i_anlyse_multiple_po_quoted ) ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OVERRIDE FORWARD EMAIL ADDRESS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_last:- i_analyse_forward_email___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_forward_email___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	grammar_set( i_analyse_forward_to_address ),
	
	result( _, invoice, forward_email, `email address based on lookup` ),

	i_mail( to, To ),

	forward_email_lookup( To, Forward_Email ),

	sys_retractall( result( _, invoice, forward_email, _ ) ),
	
	assertz_derived_data( invoice, forward_email, Forward_Email, i_analyse_forward_email ),
	
	!
.

forward_email_lookup( `ksb_de_1001@cloud-trade.com`, `AP_Queries_DE@ksb.com` ).
forward_email_lookup( `ksb_de_1001.test@cloud-trade.com`, `AP_Queries_DE@ksb.com` ).
forward_email_lookup( `ksb_de_1009@cloud-trade.com`, `AP_Queries_DE@ksb.com` ).
forward_email_lookup( `ksb_de_1009.test@cloud-trade.com`, `AP_Queries_DE@ksb.com` ).
forward_email_lookup( `ksb_at@cloud-trade.com`, `AP_Queries_AT@ksb.com` ).
forward_email_lookup( `ksb_at.test@cloud-trade.com`, `AP_Queries_AT@ksb.com` ).
forward_email_lookup( `ksb_ch@cloud-trade.com`, `AP_Queries_CH@ksb.com` ).
forward_email_lookup( `ksb_ch.test@cloud-trade.com`, `AP_Queries_CH@ksb.com` ).
forward_email_lookup( `ksb_fr@cloud-trade.com`, `AP_Queries_FR@ksb.com` ).
forward_email_lookup( `ksb_fr.test@cloud-trade.com`, `AP_Queries_FR@ksb.com` ).
