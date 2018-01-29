%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_KSB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_ksb, `29/01/2018 13:30:55` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_ksb.pro` ).
i_rules_file( `d_iso_currency_codes.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
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
i_user_field( invoice, exchange_rate, `Exchange Rate` ).
i_user_field( invoice, rounding_amount, `Rounding Amount` ).
i_user_field( invoice, por_reference, `POR Reference` ).
i_user_field( invoice, customer_id, `Customer ID` ).
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
i_op_param( rules_intervention_role, _, _, _, `KSB (Technical)` ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `KSB` ). % This will be the role for customer intervention (this field is mandatory)
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

] ).

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
% ORDER NUMBER VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_order_number___.
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
% REMOVE DESCRIPTION FOR PO INVOICES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_description___( LID ).
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
% LINE VAT CODES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_vat_code___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_vat_code___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		result( _, LID, line_vat_code, _ ),

		sys_retractall( result( _, LID, line_vat_code, _ ) )

		;

		true

	),

	assertz_derived_data( LID, line_vat_code, `??`, i_analyse_line_vat_code ),

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

			assertz_derived_data( invoice, line_buyers_order_number, LBON_Final, i_analyse_line_buyers_order_number )
			
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
