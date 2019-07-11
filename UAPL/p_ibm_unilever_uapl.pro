%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_UNILEVER_UAPL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_unilever_uapl, `11/07/2019 10:23:59` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_unilever_uapl.pro` ).
i_rules_file( `d_iso_currency_codes.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_numerical_validation.pro` ).
i_rules_file( `u_invoice_date_validation.pro` ).


i_op_param( unique_id, _, To, _, Scan_ID )
:-
	not( q_sys_member( To, [ `unilever.uapl@cloud-trade.com`, `unilever.uapl.test@cloud-trade.com` ] ) ),
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
% Intervention Stuff
%-----------------------------------------------------------------------
i_op_param( rules_intervention_role, _, _, _, `Unilever UAPL (Technical)` ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `Unilever UAPL` ). % This will be the role for customer intervention
i_op_param( default_rts_email_subject, _, _, _, `UAPL Invoice Processing Error` ).
i_op_param( default_forward_email_subject, _, _, _, `UAPL Invoice Processing Error` ).

%-----------------------------------------------------------------------
% Customer Forward Address List
%-----------------------------------------------------------------------
% i_op_param( customer_forward_address_list, _, _, _, `` ).

%-----------------------------------------------------------------------
% Custom Scenario
%-----------------------------------------------------------------------
document_reason_lookup( `Invoice quotes tax but is not a tax invoice`, `failed`, `i_analyse_tax_without_tax_invoice`, _, _ ).
document_reason_lookup( `Multiple Invoice Document`, `failed`, `i_analyse_multiple_invoice_document`, _, _ ).

%-----------------------------------------------------------------------
% Email Template Beginning Text
%-----------------------------------------------------------------------
beginning_text( Text )
:-
	Text = `<span style="font-family:times new roman,times,serif;">
<span style="font-size:13px;">Dear Business Partner,</span><br>
<br>
<span style="font-size:15px;"><span style="color:#0000FF;"><strong>
We regret to inform you that we are unable to process your Invoice/Credit Note for the reason/s mentioned below. In order to receive timely payment, we request you to do the needful corrections and re-submit the invoice via the appropriate invoicing mode as agreed.</span></span></strong><br>
<br>
<span style="font-size:13px;">`
.

%-----------------------------------------------------------------------
% Email Template Remaining Rejection Text
%-----------------------------------------------------------------------
remaining_rejection_text( Text )
:-
	(
		result( _, invoice, sender_name, Sender_Name ),

		strcat_list( [ `Vendor Name: `, Sender_Name, `<br>` ], Sender_Name_Text )

		;

		Sender_Name_Text = ``

	),

	!,

	(
		result( _, invoice, invoice_number, Invoice_Number ),

		strcat_list( [ `Invoice Number: `, Invoice_Number, `<br>` ], Invoice_Number_Text )

		;

		Invoice_Number_Text = ``

	),

	!,

	(
		result( _, invoice, invoice_date, Invoice_Date ),

		strcat_list( [ `Invoice Date: `, Invoice_Date, `<br>` ], Invoice_Date_Text )

		;

		Invoice_Date_Text = ``

	),

	!,

	(
		result( _, invoice, total_invoice, Invoice_Amount ),

		strcat_list( [ `Invoice Amount: `, Invoice_Amount, `<br>` ], Invoice_Amount_Text )

		;

		Invoice_Amount_Text = ``

	),

	!,

	(
		result( _, invoice, currency, Currency ),

		strcat_list( [ `Invoice Currency: `, Currency, `<br>` ], Currency_Text )

		;

		Currency_Text = ``

	),

	!,

	(
		qq_op_param( unique_id, Scan_ID ),

		strcat_list( [ `Scan ID: `, Scan_ID, `<br>` ], Scan_ID_Text )

		;

		Scan_ID_Text = ``

	),

	!,

	strcat_list( [ `<br>See below the invoice details for your easy reference.<br><br>`, Sender_Name_Text, Invoice_Number_Text, Invoice_Date_Text, Invoice_Amount_Text, Currency_Text, Scan_ID_Text, `<br>You can check the status of your Unilever Invoice/Payment by logging into Tungsten Network<br><a href="http://www.tungsten-network.com/unileveriss"><span style="color:#0000CD;">http://www.tungsten-network.com/unileveriss</a></span><br>If you don�t already have access to Tungsten, please register on the above link.<br><br>For other purchase order, Invoice and payment related queries, please contact the Unilever Helpdesk using the contact details available on our Supplier Page<br><a href="http://www.unilever.com/aboutus/supplier/invoiceus"><span style="color:#0000CD;">http://www.unilever.com/aboutus/supplier/invoiceus</a></span><br><br><br><p align="center"><span style="color:#FF0000;">--This is a system generated email. Please do not reply to this email&mdash;</span></p><br>Regards,<br>Accounts Payable<br>IBM Team on behalf of Unilever</span></span>` ], Text )
.

%-----------------------------------------------------------------------
% Email Template Remaining Forward Text
%-----------------------------------------------------------------------
remaining_forward_text( Text )
:-
	(
		result( _, invoice, sender_name, Sender_Name ),

		strcat_list( [ `Vendor Name: `, Sender_Name, `<br>` ], Sender_Name_Text )

		;

		Sender_Name_Text = ``

	),

	!,

	(
		result( _, invoice, invoice_number, Invoice_Number ),

		strcat_list( [ `Invoice Number: `, Invoice_Number, `<br>` ], Invoice_Number_Text )

		;

		Invoice_Number_Text = ``

	),

	!,

	(
		result( _, invoice, invoice_date, Invoice_Date ),

		strcat_list( [ `Invoice Date: `, Invoice_Date, `<br>` ], Invoice_Date_Text )

		;

		Invoice_Date_Text = ``

	),

	!,

	(
		result( _, invoice, total_invoice, Invoice_Amount ),

		strcat_list( [ `Invoice Amount: `, Invoice_Amount, `<br>` ], Invoice_Amount_Text )

		;

		Invoice_Amount_Text = ``

	),

	!,

	(
		result( _, invoice, currency, Currency ),

		strcat_list( [ `Invoice Currency: `, Currency, `<br>` ], Currency_Text )

		;

		Currency_Text = ``

	),

	!,

	(
		qq_op_param( unique_id, Scan_ID ),

		strcat_list( [ `Scan ID: `, Scan_ID, `<br>` ], Scan_ID_Text )

		;

		Scan_ID_Text = ``

	),

	!,

	strcat_list( [ `<br>See below the invoice details for your easy reference.<br><br>`, Sender_Name_Text, Invoice_Number_Text, Invoice_Date_Text, Invoice_Amount_Text, Currency_Text, Scan_ID_Text, `<br>You can check the status of your Unilever Invoice/Payment by logging into Tungsten Network<br><a href="http://www.tungsten-network.com/unileveriss"><span style="color:#0000CD;">http://www.tungsten-network.com/unileveriss</a></span><br>If you don�t already have access to Tungsten, please register on the above link.<br><br>For other purchase order, Invoice and payment related queries, please contact the Unilever Helpdesk using the contact details available on our Supplier Page<br><a href="http://www.unilever.com/aboutus/supplier/invoiceus"><span style="color:#0000CD;">http://www.unilever.com/aboutus/supplier/invoiceus</a></span><br><br><br><p align="center"><span style="color:#FF0000;">--This is a system generated email. Please do not reply to this email&mdash;</span></p><br>Regards,<br>Accounts Payable<br>IBM Team on behalf of Unilever</span></span>` ], Text )
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
% PLANT CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	plant_code( `0000` )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EXCHANGE RATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( exchange_rate ), exchange_rate( `0` )

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
	, remove( supplier_bank_code )
	, remove( supplier_bank_ogm )
	, remove( payment_terms )
	, remove( narrative )
	, remove( customer_comments )
	, remove( total_discount )
	, remove( line_order_line_number )
	, remove( line_cost_centre )
	, remove( line_internal_order_number )
	, remove( line_gl )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR TAX INVOICE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	peek_fails( test( tax_invoice ) )

	, q(0,20,line)

	, generic_horizontal_details( [ [ gen_beof, `Tax`, `Invoice`, q10( `:` ), gen_eof ] ] )

	, set( tax_invoice )

	, trace( [ `Tax invoice detected` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ADD A SINGLE SUMMARY LINE IF NO LINES ARE PRESENT FOR FREIGHT VENDORS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	test( freight_vendor )

	, peek_fails( with( 1, line_quantity, _ ) )
	, peek_fails( with( 1, line_descr, _ ) )
	, peek_fails( with( 1, line_net_amount, _ ) )

	, line_quantity( `1` )
	, line_descr( `Freight Charges` )

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
% REMOVE INVALID INVOICE DATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, invoice_date, Date )
	
	, or( [
	
		check( date_string( date( Y, M, D ), _, Date ) )
		
		, [ remove( invoice_date ), trace( [ `Invoice Date is not a date - removing`, Date ] ) ]
	
	] )
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REMOVE INVALID TAX POINT DATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, tax_point_date, Date )
	
	, or( [
	
		check( date_string( date( Y, M, D ), _, Date ) )
		
		, [ remove( tax_point_date ), trace( [ `Invoice Date is not a date - removing`, Date ] ) ]
	
	] )
	
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
% CHECK FOR FUTURE INVOICE DATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_future_invoice_date___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_future_invoice_date___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, invoice_date, Invoice_Date ),

	(
		i_date_format( Date_Format )

		;

		true

	),
	
	!,

	date_string( Date_Invoice, Date_Format, Invoice_Date ),
	sys_date_1900_days( Date_Invoice, Invoice_Date_Count ),

	date_get( today, Today ),
	sys_date_1900_days( Today, Today_Count ),

	sys_calculate( Day_Diff, Today_Count - Invoice_Date_Count ),

	Day_Diff < 0,

	sys_assertz( grammar_set( future_dated ) ),

	trace( [ `Date is in the future` ] ),

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

		assertz_derived_data( invoice, invoice_type, `CN`, i_analyse_invoice_type )

		;

		not( result( _, invoice, order_number, _ ) ),

		npnp_vendor,

		assertz_derived_data( invoice, invoice_type, `INV`, i_analyse_invoice_type )

		;

		grammar_set( debit_note ),

		assertz_derived_data( invoice, invoice_type, `CO`, i_analyse_invoice_type )

		;

		assertz_derived_data( invoice, invoice_type, `INVPO`, i_analyse_invoice_type )

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
i_analyse_invoice_fields_first:- i_analyse_company_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_company_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, invoice, buyer_registration_number, _ ) ),

	(
		result( _, invoice, order_number, Order_Number ),

		q_gratabase_lookup( `ibm_po_list`,
			[ Order_Number, _, _, _, _ ],
			[ Order_Number, Company_Code, _, _, _ ],
			Available
		),

		(
			Available = false

			-> trace( [ `Unable to access ibm po list table` ] ), fail

			;

			trace( [ `Header Order Number Found` ] )

		)

		;

		sys_retractall( result( _, invoice, order_number, _ ) ),

		trace( [ `order_number missing/invalid - value removed` ] ),

		Company_Code = `3009`

	),

	assertz_derived_data( invoice, buyer_registration_number, Company_Code, i_analyse_company_code ),

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
	(
		result( _, invoice, currency, Currency )

		->	sys_retractall( result( _, invoice, currency, _ ) ),

		string_to_upper( Currency, Currency_U ),

		(
			iso_currency_code( Currency_U ),

			assertz_derived_data( invoice, currency, Currency_U, i_analyse_currency )

			;

			trace( [ `currency invalid - value removed` ] )

		)

		;

		assertz_derived_data( invoice, currency, `USD`, i_analyse_currency )

	),

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

		trace( [ `Looking up line_buyers_order_number in ibm po list table`, LBON ] ),
		
		(
			q_gratabase_lookup( `ibm_po_list`,
				[ LBON, _, _, _, _ ],
				[ LBON, _, _, _, _ ],
				Available
			),

			(
				Available = false

				-> trace( [ `Unable to access ibm po list table` ] ), fail

				;

				trace( [ `Line Order Number Found` ] )

			)
			
			;
			
			sys_retractall( result( _, LID, line_buyers_order_number, _ ) ),

			trace( [ `line_buyers_order_number not found in table - value removed` ] ),
			
			(
				result( _, invoice, order_number, PO ),
			
				trace( [ `Using order_number value instead` ] ),

				assertz_derived_data( LID, line_buyers_order_number, PO, i_analyse_line_buyers_order_number )

				;

				trace( [ `order_number has not been mapped, so cannot use this` ] )

			)

		)

		;
		
		not( result( _, LID, line_buyers_order_number, LBON ) ),

		trace( [ `line_buyers_order_number has not been mapped for line`, LID ] ),
		
		(
			result( _, invoice, order_number, PO ),
			
			trace( [ `Using order_number value instead` ] ),

			assertz_derived_data( LID, line_buyers_order_number, PO, i_analyse_line_buyers_order_number )

			;

			trace( [ `order_number has not been mapped either, so cannot use this` ] )

		)
	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DUPLICATE INVOICE ANALYSIS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_duplicate_invoice.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_duplicate_invoice
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( receive_type, `imap` ),

	instance( Inst ),

	string_to_upper( Inst, INST ),

	not( q_sys_sub_string( INST, _, _, `DBG` ) ),

	create_basic_invoice_table_if_necessary,

	grammar_set( table_exists ),

	(
		result( _, invoice, buyer_registration_number, Company_Code ),

		result( _, invoice, buyers_code_for_supplier, BCFS ),

		result( _, invoice, invoice_number, Invoice_Number ),

		result( _, invoice, date, Invoice_Date_Raw ),

		string_date( Invoice_Date, Invoice_Date_Raw ),

		i_mail( file, FILE ),

		(
			q_gratabase_lookup_one( `ibm_unilever_uapl_invoice_table`, [ `general`, Company_Code, BCFS, Invoice_Number, _, _ ], [ _, _, _, _, DATE_LOOKUP, ORIGINAL ], Available ),

			trace( Available )

			-> ( q_sys_comp( Available = false )

				-> trace( [ `basic_invoice check, database disappeared` ] )

				;

				(
					q_allow_duplicate_emails,
					strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, FILE ], Alert ),
					alert( Alert, 0, `hours` )

					;

					FILE = ORIGINAL,
					trace( [ `ALERT: Duplicate file - Duplicate Processed` ] )

					;

					%	To compare dates regardless of format - needs to be adjusted if US dates are used
					date_string( DATE_LOOKUP_RAW, _, DATE_LOOKUP ),
					date_compare( Invoice_Date_Raw, =, DATE_LOOKUP_RAW ),

					wordcat( [ `Duplicate invoice rejected:`, Company_Code, BCFS, Invoice_Number, Invoice_Date ], E_MSG ),

					sys_assertz( grammar_set( i_analyse_duplicate ) ),

					trace( E_MSG )

				)

			)

			;

			sys_assertz( i_user_data( new_invoice_detected, Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE ) )

		)

 		;

		trace( [ `analyse for duplicate fields ignored because of lack of fields: ` ] ),

		( result( _, invoice, buyer_registration_number, _ ) ; trace( [ `missing buyer_registration_number` ] ) ),

		( result( _, invoice, buyers_code_for_supplier, _ ) ; trace( [ `missing buyers_code_for_supplier` ] ) ),

		( result( _, invoice, invoice_number, _ ) ; trace( [ `missing invoice_number` ] ) ),

		( result( _, invoice, date, _ ) ; trace( [ `missing date` ] ) ),

		( i_mail( file, _ ) ; trace( [ `missing file name` ] ) )

	),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_basic_invoice_table_if_necessary
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		q_gratabase_check_table_exists( `ibm_unilever_uapl_invoice_table`, Available )

		-> (
			q_sys_comp( Available = false )
			->	trace( [ `Cannot access database` ] )

			;

			true, trace( `Table exists` ), sys_assertz( grammar_set( table_exists ) )
		)

		;

		% fail, % Don't want this to EVER happen

		(
			q_gratabase_create_table( 6, GUID )

			-> (
				q_gratabase_allocate( GUID, `ibm_unilever_uapl_invoice_table` ),

				trace( `Created and allocated table` ),

				sys_assertz( grammar_set( table_exists ) )

				;

				trace( [ `failed to allocate on creation ibm_unilever_uapl_invoice_table` ] )
			)

			;

			trace( [ `failed to create ibm_unilever_uapl_invoice_table` ] )

		)

	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_final_process( Enq )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	i_user_data( new_invoice_detected, Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE ),

	(
		Enq = true
		->	trace( [ `Document destined for enquire, not written to database` ] )

		;

		(
			process_status( defect, _, E_MSG )

			;

			result( _, invoice, force_result, `defect` )

		)

		-> trace( [ `Document has defected, not written to database` ] )

		;

		(
			process_status( failed, _, E_MSG )

			;

			result( _, invoice, force_result, `failed` )

		)

		-> trace( [ `Document has failed, not written to database` ] )

		;

		Enq = false,
		add_to_basic_invoice_table( Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE ),
		trace( [ `Document processed - Database populated`, Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE ] )
	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
add_to_basic_invoice_table( Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		q_gratabase_clone_table( `ibm_unilever_uapl_invoice_table`, GUID )

		-> (
			q_gratabase_add( GUID, [ `general`, Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE ] )

			->	trace( [ `added`, Company_Code, BCFS, Invoice_Number, Invoice_Date, FILE , `to ibm_unilever_uapl_invoice_table` ] ),

			( q_gratabase_allocate( GUID, `ibm_unilever_uapl_invoice_table` ) ; trace( [ `failed to allocate ibm_unilever_uapl_invoice_table` ] ) )

			;

			trace( [ `failed to add row to ibm_unilever_uapl_invoice_table` ] )

		)

		;

		trace( [ `failed to clone ibm_unilever_uapl_invoice_table` ] )

	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USER CHECKS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
i_user_check( check_po_currency, Order_Number, Currency )
%-----------------------------------------------------------------------
:-
	q_gratabase_lookup( `ibm_po_list`,
		[ Order_Number, _, _, _, _ ],
		[ Order_Number, _, _, _, Currency ],
		Available
	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PREDICATES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% NPNP Vendor
%-----------------------------------------------------------------------
npnp_vendor
:-
	result( _, invoice, buyers_code_for_supplier, BCFS ),

	q_gratabase_lookup( `ibm_npnp_list`,
		[ BCFS, _ ],
		[ BCFS, _ ],
		Available
	),

	(
		Available = false

		-> trace( [ `Unable to access ibm npnp list table` ] ), fail

		;

		true

	)
.

%-----------------------------------------------------------------------
% I Error Invoice Integer Totals Inconsistent
%-----------------------------------------------------------------------
i_error_invoice_integer_totals_inconsistent
:-
	result( _, invoice, total_net, Net ),
	result( _, invoice, total_vat, VAT ),
	result( _, invoice, total_invoice, Total ),
	(
		result( _, invoice, rounding_amount, Sub_3 )
		;
		not( result( _, invoice, rounding_amount, _ ) ),
		Sub_3 = `0`
	),
	!,
	sys_calculate_str_add( Net, VAT, Sum ),
	sys_calculate_str_add( Sum, Sub_3, Sum_Final ),
	sys_calculate_str_subtract( Total, Sum_Final, Diff ),
	sys_calculate_str_round_0( Diff, Diff_0 ),
	not( q_sys_comp_str_eq( Diff_0, `0` ) ),
	!
.

%-----------------------------------------------------------------------
% I Error Sum Net Integer Discrepancy
%-----------------------------------------------------------------------
i_error_sum_net_integer_discrepancy
:-
	sys_findall( Net, result( _, LID, line_net_amount, Net ), List_of_nets_Raw ),
	i_force_list( List_of_nets_Raw, List_of_nets ),
	i_user_check( sum_string_list, List_of_nets, Sum_of_nets ),
	result( _, invoice, total_net, Total_net ),
	!,
	sys_calculate_str_subtract( Total_net, Sum_of_nets, Diff ),
	sys_calculate_str_round_0( Diff, Diff_0 ),
	not( q_sys_comp_str_eq( Diff_0, `0` ) ),
	!
.

%-----------------------------------------------------------------------
% I Error Sum Total Integer Discrepancy
%-----------------------------------------------------------------------
i_error_sum_total_integer_discrepancy
:-
	sys_findall( Total, result( _, LID, line_total_amount, Total ), List_of_totals_Raw ),
	i_force_list( List_of_totals_Raw, List_of_totals ),
	i_user_check( sum_string_list, List_of_totals, Sum_of_totals ),
	result( _, invoice, total_invoice, Total_invoice ),
	(
		result( _, invoice, rounding_amount, Sub_3 )
		;
		not( result( _, invoice, rounding_amount, _ ) ),
		Sub_3 = `0`
	),
	sys_calculate_str_subtract( Total_invoice, Sub_3, Sub_Diff ),
	!,
	sys_calculate_str_subtract( Sub_Diff, Sum_of_totals, Diff ),
	sys_calculate_str_round_0( Diff, Diff_0 ),
	not( q_sys_comp_str_eq( Diff_0, `0` ) ),
	!
.
