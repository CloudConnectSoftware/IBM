%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_PEPSICO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_pepsico, `29/08/2018 09:38:17` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_include_partner_attachments_image_only
:-
	i_mail( subject, Subject ),
	q_sys_sub_string( Subject, 1, _, `PreApprovalforPOExemptInvoice-` ),
	chained_to( Chain ),
	Chain \= `unrecognised_document`,
	not( missed_data_items_condition )
.

i_rules_file( `d_ibm_pepsico.pro` ).
i_rules_file( `d_iso_currency_codes.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_numerical_validation.pro` ).
i_rules_file( `u_invoice_date_validation.pro` ).

i_user_field( invoice, vendor_id, `vendor_id` ).
i_user_field( invoice, zip_file_name, `zip_file_name` ).
i_user_field( invoice, batch_name, `batch_name` ).
i_user_field( invoice, timestamp, `timestamp` ).
i_user_field( invoice, client_code, `client_code` ).
i_user_field( invoice, number_of_docs, `number_of_docs` ).
i_user_field( invoice, file_name, `file_name` ).
i_user_field( invoice, mime_type, `mime_type` ).
i_user_field( invoice, item_type, `item_type` ).
i_user_field( invoice, ct_id, `ct_id` ).
i_user_field( invoice, ct_capture_time, `ct_capture_time` ).
i_user_field( invoice, ct_email_to, `ct_email_to` ).
i_user_field( invoice, ct_email_from, `ct_email_from` ).
i_user_field( invoice, ct_email_subject, `ct_email_subject` ).
i_user_field( invoice, ct_pages, `ct_pages` ).
i_user_field( invoice, ct_reason, `ct_reason` ).
i_user_field( invoice, capture_type, `capture_type` ).
i_user_field( invoice, invoice_status, `invoice_status` ).
i_user_field( invoice, invoice_status_reason_code, `invoice_status_reason_code` ).
i_user_field( invoice, buyer_id, `buyer_id` ).
i_user_field( invoice, company_name, `company_name` ).
i_user_field( invoice, erp_id, `erp_id` ).
i_user_field( invoice, business_unit, `business_unit` ).
i_user_field( invoice, total_withholding_tax, `total_withholding_tax` ).
i_user_field( invoice, requestor, `requestor` ).
i_user_field( invoice, pre_approved, `pre_approved` ).
i_user_field( invoice, supplier_unique_id, `supplier_unique_id` ).
i_user_field( invoice, supplier_payment_terms, `supplier_payment_terms` ).
i_user_field( invoice, remit_to_party, `remit_to_party` ).
i_user_field( invoice, remit_to_address_line, `remit_to_address_line` ).
i_user_field( invoice, remit_to_street, `remit_to_street` ).
i_user_field( invoice, remit_to_city, `remit_to_city` ).
i_user_field( invoice, remit_to_postcode, `remit_to_postcode` ).
i_user_field( invoice, remit_to_bank_account_number, `remit_to_bank_account_number` ).
i_user_field( invoice, remit_to_bank_code, `remit_to_bank_code` ).
i_user_field( invoice, remit_to_iban, `remit_to_iban` ).
i_user_field( invoice, remit_to_swift_code, `remit_to_swift_code` ).

i_user_field( line, line_number, `line_number` ).
i_user_field( line, line_type_code, `line_type_code` ).


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
i_op_param( rules_intervention_role, _, _, _, `PepsiCo (Technical)` ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `PepsiCo` ). % This will be the role for customer intervention (this field is mandatory)

%-----------------------------------------------------------------------
% Duplicate Table to Use
%-----------------------------------------------------------------------
i_op_param( duplicate_table_to_use, _, _, _, `ibm_pepsico` ).

%-----------------------------------------------------------------------
% Document Date Check
%-----------------------------------------------------------------------
% i_op_param( old_date_check_number_of_days, _, _, _, `` ).
i_op_param( future_date_check_number_of_days, _, _, _, `0` ).

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
% HARD-CODED VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_hard_coded_values___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_hard_coded_values___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, invoice, vendor_id, _ ) ),
	sys_retractall( result( _, invoice, client_code, _ ) ),
	sys_retractall( result( _, invoice, number_of_docs, _ ) ),
	sys_retractall( result( _, invoice, mime_type, _ ) ),
	sys_retractall( result( _, invoice, item_type, _ ) ),
	sys_retractall( result( _, invoice, capture_type, _ ) ),
	sys_retractall( result( _, invoice, ct_reason, _ ) ),
	sys_retractall( result( _, invoice, invoice_status, _ ) ),
	sys_retractall( result( _, invoice, invoice_status_reason_code, _ ) ),

	assertz_derived_data( invoice, vendor_id, `PEPC`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, client_code, `PEPC`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, number_of_docs, `1`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, mime_type, `application/pdf`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, item_type, `PEPC_APDocuments`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, capture_type, `CLOUDTRADE`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, ct_reason, `SUCCESS`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, invoice_status, `RECEIVED`, i_analyse_hard_coded_values ),
	assertz_derived_data( invoice, invoice_status_reason_code, `SUCCESS`, i_analyse_hard_coded_values ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ZIP FILE NAME & BATCH NAME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_file_names___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_file_names___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	instance( Instance ),
	string_to_upper( Instance, Instance_U ),
	(
		not( q_sys_sub_string( Instance_U, _, _, `DBG` ) ),
		i_mail( unique_id, ID )
		;
		q_sys_sub_string( Instance_U, _, _, `DBG` ),
		ID = 0
	),
	sys_string_number( IDS, ID ),
	string_pad_left( IDS, 8, `0`, IDPad ),
	strcat_list( [ `PEPC_CT_`, IDPad, `.zip` ], Zip_File_Name ),
	strcat_list( [ `PEPC_CT_`, IDPad, `.pdf` ], PDF_File_Name ),
	strcat_list( [ `PEPC_CT_`, IDPad ], Customer_ID ),

	sys_retractall( result( _, invoice, zip_file_name, _ ) ),
	sys_retractall( result( _, invoice, batch_name, _ ) ),
	sys_retractall( result( _, invoice, file_name, _ ) ),

	assertz_derived_data( invoice, zip_file_name, Zip_File_Name, i_analyse_file_names ),
	assertz_derived_data( invoice, batch_name, Zip_File_Name, i_analyse_file_names ),
	assertz_derived_data( invoice, file_name, PDF_File_Name, i_analyse_file_names ),
	assertz_derived_data( invoice, customer_id, Customer_ID, i_analyse_file_names ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_ct_id___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_ct_id___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	instance( Instance ),
	string_to_upper( Instance, Instance_U ),
	(
		not( q_sys_sub_string( Instance_U, _, _, `DBG` ) ),
		i_mail( unique_id, ID )
		;
		q_sys_sub_string( Instance_U, _, _, `DBG` ),
		ID = 0
	),
	sys_string_number( IDS, ID ),
	string_pad_left( IDS, 8, `0`, IDPad ),

	date_get( today, date( Y, M, D ) ),

	sys_string_number( YPad, Y ),
	
	sys_string_number( MS, M ),
	string_pad_left( MS, 2, `0`, MPad ),
	
	sys_string_number( DS, D ),
	string_pad_left( DS, 2, `0`, DPad ),
	
	strcat_list( [ YPad, MPad, DPad, `_CT`, IDPad ], CT_ID ),

	sys_retractall( result( _, invoice, ct_id, _ ) ),

	assertz_derived_data( invoice, ct_id, CT_ID, i_analyse_ct_id ),

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
% TIMESTAMP, CT CAPTURE TIME AND FISCAL YEAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_ct_timestamps___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_ct_timestamps___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	datetime_get( now, datetime( Y, M, D, H, Min, S ) ),

	sys_string_number( YPad, Y ),
	
	sys_string_number( MS, M ),
	string_pad_left( MS, 2, `0`, MPad ),
	
	sys_string_number( DS, D ),
	string_pad_left( DS, 2, `0`, DPad ),
	
	sys_string_number( HS, H ),
	string_pad_left( HS, 2, `0`, HPad ),
	
	sys_string_number( MinS, Min ),
	string_pad_left( MinS, 2, `0`, MinPad ),

	sys_string_number( SS, S ),
	string_pad_left( SS, 2, `0`, SPad ),

	strcat_list( [ YPad, MPad, DPad, HPad, MinPad, SPad ], Timestamp ),

	strcat_list( [ YPad, `-`, MPad, `-`, DPad, `-`, HPad, `.`, MinPad, `.`, SPad ], Timestamp_Formatted ),

	sys_retractall( result( _, invoice, timestamp, _ ) ),
	sys_retractall( result( _, invoice, ct_capture_time, _ ) ),
	sys_retractall( result( _, invoice, fiscal_year, _ ) ),

	assertz_derived_data( invoice, timestamp, Timestamp, i_analyse_ct_timestamps ),
	assertz_derived_data( invoice, ct_capture_time, Timestamp_Formatted, i_analyse_ct_timestamps ),
	assertz_derived_data( invoice, fiscal_year, YPad, i_analyse_ct_timestamps ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT EMAIL DETAILS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_ct_email___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_ct_email___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( to, To ),
	i_mail( from, From ),
	i_mail( subject, Subject ),

	sys_retractall( result( _, invoice, ct_email_to, _ ) ),
	sys_retractall( result( _, invoice, ct_email_from, _ ) ),
	sys_retractall( result( _, invoice, ct_email_subject, _ ) ),

	assertz_derived_data( invoice, ct_email_to, To, i_analyse_ct_email ),
	assertz_derived_data( invoice, ct_email_from, From, i_analyse_ct_email ),
	assertz_derived_data( invoice, ct_email_subject, Subject, i_analyse_ct_email ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT PAGES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_ct_pages___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_ct_pages___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_working_pages( Page_List, _ ),

	sys_reverse( Page_List, [ page( _, Number_of_Pages ) | _ ] ),

	sys_retractall( result( _, invoice, ct_pages, _ ) ),

	assertz_derived_data( invoice, ct_pages, Number_of_Pages, i_analyse_ct_pages ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% COMPANY INFORMATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_company_information___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_company_information___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( to, To ),

	string_to_lower( To, To_L ),

	company_code_lookup( Email, Company_ID, Company_Code, Company_Name, ERP_System_ID, Business_Unit, Country ),

	string_to_lower( Email, To_L ),
	
	sys_retractall( result( _, invoice, buyer_id, _ ) ),
	sys_retractall( result( _, invoice, buyer_registration_number, _ ) ),
	sys_retractall( result( _, invoice, company_name, _ ) ),
	sys_retractall( result( _, invoice, erp_id, _ ) ),
	sys_retractall( result( _, invoice, business_unit, _ ) ),
	sys_retractall( result( _, invoice, buyer_dept, _ ) ),

	assertz_derived_data( invoice, buyer_id, Company_ID, i_analyse_company_information ),
	assertz_derived_data( invoice, buyer_registration_number, Company_Code, i_analyse_company_information ),
	assertz_derived_data( invoice, company_name, Company_Name, i_analyse_company_information ),
	assertz_derived_data( invoice, erp_id, ERP_System_ID, i_analyse_company_information ),
	assertz_derived_data( invoice, business_unit, Business_Unit, i_analyse_company_information ),
	assertz_derived_data( invoice, buyer_dept, Country, i_analyse_company_information ),

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

		assertz_derived_data( invoice, invoice_type, `CREDIT`, i_analyse_invoice_type )

		;

		result( _, invoice, order_number, _ ),

		assertz_derived_data( invoice, invoice_type, `PO`, i_analyse_invoice_type )

		;

		assertz_derived_data( invoice, invoice_type, `NONPO`, i_analyse_invoice_type )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PRE APPROVAL INDICATOR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_pre_approval_indicator___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_pre_approval_indicator___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, invoice, pre_approved, _ ) ),

	(
		i_include_partner_attachments_image_only,
		
		result( _, invoice, buyer_id, Company_ID ),

		q_sys_member( Company_ID, [ `CAFRITO`, `CAQUAKER` ] ),

		i_mail( subject, Subject ),

		q_sys_sub_string( Subject, 1, _, `PreApprovalforPOExemptInvoice-` ),

		(
			i_mail( num_attachments, 1 ),

			assertz_derived_data( invoice, pre_approved, `E`, i_analyse_pre_approval_indicator )

			;

			not( i_mail( num_attachments, 1 ) ),

			assertz_derived_data( invoice, pre_approved, `Y`, i_analyse_pre_approval_indicator )

		)

		;

		assertz_derived_data( invoice, pre_approved, `N`, i_analyse_pre_approval_indicator )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SUPPLIER UNIQUE ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_supplier_unique_id___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_supplier_unique_id___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, invoice, supplier_unique_id, _ ) ),
	
	result( _, invoice, buyers_code_for_supplier, BCFS ),

	result( _, invoice, buyer_id, Company_ID ),

	strcat_list( [ BCFS, `-`, Company_ID ], Supplier_Unique_ID ),

	assertz_derived_data( invoice, supplier_unique_id, Supplier_Unique_ID, i_analyse_supplier_unique_id ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SUPPLIER PAYMENT TERMS AND ADDRESS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_supplier_payment_terms_and_address___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_supplier_payment_terms_and_address___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, supplier_unique_id, Supplier_Unique_ID ),

	q_gratabase_lookup( `ibm_pepsico_vendor_master_list`,
		[ Supplier_Unique_ID, _, _, _, _, _, _, _, _, _ ],
		[ Supplier_Unique_ID, _, _, _, _, Supplier_Payment_Terms, Supplier_Address_Line_1, Supplier_Address_Line_2, Supplier_City, Supplier_Postcode ],
		Available
	),

	(
		Available = false

		-> trace( [ `Unable to access IBM PepsiCo Vendor Master List table` ] ), fail

		;

		trace( [ `Got values from IBM PepsiCo Vendor Master List table` ] )

	),

	(
		not( result( _, invoice, supplier_payment_terms, _ ) ),

		assertz_derived_data( invoice, supplier_payment_terms, Supplier_Payment_Terms, i_analyse_supplier_payment_terms_and_address )

		;

		true

	),

	(
		not( result( _, invoice, supplier_address_line, _ ) ),

		assertz_derived_data( invoice, supplier_address_line, Supplier_Address_Line_1, i_analyse_supplier_payment_terms_and_address )

		;

		true

	),

	(
		not( result( _, invoice, supplier_street, _ ) ),

		assertz_derived_data( invoice, supplier_street, Supplier_Address_Line_2, i_analyse_supplier_payment_terms_and_address )

		;

		true

	),

	(
		not( result( _, invoice, supplier_city, _ ) ),

		assertz_derived_data( invoice, supplier_city, Supplier_City, i_analyse_supplier_payment_terms_and_address )

		;

		true

	),

	(
		not( result( _, invoice, supplier_postcode, _ ) ),

		assertz_derived_data( invoice, supplier_postcode, Supplier_Postcode, i_analyse_supplier_payment_terms_and_address )

		;

		true

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE LINE NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, LID, line_number, _ ) ),

	sys_string_number( LID_S, LID ),

	sys_calculate_str_multiply( LID_S, `10`, Line_Number ),

	assertz_derived_data( LID, line_number, Line_Number, i_analyse_line_number ),

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

	instance( Inst )

	, string_to_upper( Inst, INST )

	, not( q_sys_sub_string( INST, _, _, `DBG` ) )

	, (
		qq_op_param( duplicate_table_to_use, Table )
			->	true
			;	trace( [ `Duplicates not checked as table not specified` ] ),
				!, fail
	)

	, create_basic_invoice_table_if_necessary( Table )

	, grammar_set( table_exists )

	, (
		result( _, invoice, sending_organisation, SENDER )

		, (
			result( _, invoice, receiving_organisation, RECEIVER )

			;

			qq_op_param( receiving_organisation, RECEIVER )

		)

		, result( _, invoice, invoice_number, INVOICE )

		, result( _, invoice, total_invoice, TOTAL )

		, result( _, invoice, date, RAW_DATE )

		, date_string( RAW_DATE, 'd/m/y', DATE )

		, i_mail( file, FILE )

		, trace( `Got data` )

		, (	q_gratabase_lookup_one( Table, [ `general`, SENDER, RECEIVER, INVOICE, _, _, _ ], [ _, _, _, _, TOTAL_OR_DATE_LOOKUP, DATE_OR_TOTAL_LOOKUP_2, ORIGINAL ], Available )
			, trace( Available )

			->	( q_sys_comp( Available = false )

					-> trace( [ Table, `check, database disappeared` ] )

					;

					(	q_allow_duplicate_emails
						, strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, FILE ], Alert )
						, alert( Alert, 0, `hours` )

						;

						FILE = ORIGINAL
						, trace( [ `ALERT: Duplicate file - Duplicate Processed` ] )

						;

						(
							q_regexp_match( `^\\d+\\/\\d+\\/\\d+$`, TOTAL_OR_DATE_LOOKUP, _ )
							->	DATE_LOOKUP = TOTAL_OR_DATE_LOOKUP,
								TOTAL_LOOKUP = DATE_OR_TOTAL_LOOKUP_2

							;	DATE_LOOKUP = DATE_OR_TOTAL_LOOKUP_2,
								TOTAL_LOOKUP = TOTAL_OR_DATE_LOOKUP
						)

						%	To compare totals regardless of leading or trailing zeroes
						, q_sys_comp_str_eq( TOTAL, TOTAL_LOOKUP )

						%	To compare dates regardless of format - needs to be adjusted if US dates are used
						, date_string( DATE_LOOKUP_RAW, 'd/m/y', DATE_LOOKUP )
						, date_compare( RAW_DATE, =, DATE_LOOKUP_RAW )

						, wordcat( [ `Duplicate invoice rejected:`, SENDER, RECEIVER, INVOICE, TOTAL, DATE_LOOKUP ], E_MSG )

						, sys_assertz( grammar_set( i_analyse_duplicate ) )

						, trace( E_MSG )
					)

				)

			; sys_assertz( i_user_data( new_invoice_detected, Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ) )
		)

 		;

		trace( [ `analyse for duplicate fields ignored because of lack of fields: ` ] )

		, ( result( _, invoice, sending_organisation, _ ) ; trace( [ `missing sending_organisation` ] ) )

		, ( ( result( _, invoice, receiving_organisation, _ ) ; qq_op_param( receiving_organisation, _ ) ) ; trace( [ `missing receiving_organisation` ] ) )

		, ( result( _, invoice, invoice_number, _ ) ; trace( [ `missing invoice_number` ] ) )

		, ( result( _, invoice, total_invoice, _ ) ; trace( [ `missing total_invoice` ] ) )

		, ( result( _, invoice, date, _ ) ; trace( [ `missing date` ] ) )

		, ( i_mail( file, _ ) ; trace( [ `missing file name` ] ) )

	)

	, !
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_basic_invoice_table_if_necessary( Table )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-

	( q_gratabase_check_table_exists( Table, Available )

		->	( q_sys_comp( Available = false )
				->	trace( [ `Cannot access database` ] )
				;	true, trace( `Table exists` ), sys_assertz( grammar_set( table_exists ) )
			)

		;	( q_gratabase_create_table( 7, GUID )

				-> ( q_gratabase_allocate( GUID, Table ),  trace( `Created and allocated table` ), sys_assertz( grammar_set( table_exists ) )

						; trace( [ `failed to allocate on creation`, Table ] )
					)

				; trace( [ `failed to create`, Table ] )
			)

	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_final_process( Enq )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	i_user_data( new_invoice_detected, Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ),

	(	Enq = true
		->	trace( [ `Document destined for enquire, not written to database` ] )

		;	instance( Inst )
			, string_to_upper( Inst, INST )
			, q_sys_sub_string( INST, _, _, `DBG` )
			, trace( [ `DBG Instance Found - Not Writing to DB`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] )
			, set_imail_data( `completed_processing`, `true` )

		;	(	process_status( defect, _, E_MSG )

				;	result( _, invoice, force_result, `defect` )
			)

			->	trace( [ `Document has defected, not written to database`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
				set_imail_data( `completed_processing`, `true` )

		;	(	process_status( failed, _, E_MSG )

				;	result( _, invoice, force_result, `failed` )
			)

			->	trace( [ `Document has failed, not written to database`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
				set_imail_data( `completed_processing`, `true` )

		;	Enq = false,
			add_to_basic_invoice_table( Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ),
			trace( [ `Document processed - Database populated`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
			set_imail_data( `completed_processing`, `true` )
	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
add_to_basic_invoice_table( Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	( q_gratabase_clone_table( Table, GUID )

		-> ( q_gratabase_add( GUID, [ `general`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] )

			->	trace( [ `added`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE , `to`, Table ] )

				, ( q_gratabase_allocate( GUID, Table ) ; trace( [ `failed to allocate`, Table ] ) )

			;	trace( [ `failed to add row to`, Table ] )
		)

		; trace( [ `failed to clone`, Table ] )
	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PREVENT NORMAL INTERVENTION ANALYSIS FROM RUNNING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_intervention_forms___:- !.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_document_errors___:- !.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_flag_as_fail_and_posts___:- !.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ANALYSE DOCUMENT ERRORS BEFORE CREATING XML
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_intervention_forms_alternate___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_intervention_forms_alternate___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		q_enquire_form( `customer_intervention_form`, Form ),
		
		i_check_answered_rules_intervention_form,
		
		i_check_answered_customer_intervention_form
		
		;
		
		i_check_answered_rules_intervention_form,
		
		i_generate_initial_customer_intervention_form
		
		;
		
		i_check_answered_customer_intervention_form,
		
		i_generate_initial_rules_intervention_form
		
		;
		
		i_generate_initial_rules_intervention_form,
		
		i_generate_initial_customer_intervention_form
	
	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ACTION REJECTIONS, FORWARDS & DELETIONS BEFORE SENDING TO INTERVENTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_document_errors_alternate___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_document_errors_alternate___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( ignore_enquire ) ),

	get_header_level_data_item_failures( List_of_Header_Level_Data_Item_Failures ),

	get_line_level_data_item_failures( List_of_Line_Level_Data_Item_Failures ),

	get_document_scenario_failures( List_Of_Document_Scenario_Failures ),

	sys_append( List_of_Header_Level_Data_Item_Failures, List_of_Line_Level_Data_Item_Failures, List_of_Data_Item_Failures ),

	sys_append( List_of_Data_Item_Failures, List_Of_Document_Scenario_Failures, List_of_Failures ),

	List_of_Failures \= [ ],

	!,
	
	beginning_text( Beginning_Text ),

	sys_findall(
		Error_Text,
		(
			q_sys_member( ( _, _, _, _, _, Error_Description_Text ), List_of_Failures ),
			strcat_list( [ Error_Description_Text, `<br><br>` ], Error_Text )
		),
		List_of_Error_Texts
	),
	
	sys_stringlist_concat( List_of_Error_Texts, ``, Document_Error_Text_No_Breaks ),
	
	string_string_replace( Document_Error_Text_No_Breaks, `
`, `<br>`, Document_Error_Text ),

	q_sys_member( ( Action, Email_Address, Result, Sub_Result, Error_Header_Text, _ ), List_of_Failures ),
	
	strcat_list( [ `Document Not Processed - `, Error_Header_Text ], Subject ),

	(
		Action = `Reject to Supplier`,
		trace( `***Result: Failed - Reject to Supplier***` ),

		sys_assertz( grammar_set( i_analyse_return_to_sender ) ),
		
		remaining_rejection_text( Remaining_Rejection_Text ),
		
		strcat_list( [ Beginning_Text, Document_Error_Text, Remaining_Rejection_Text ], Return_Email_Body ),
		
		assertz_derived_data( invoice, return_email_body, Return_Email_Body, i_insert_return_email_body ),
		
		assertz_derived_data( invoice, return_email_subject, Subject, i_insert_return_email_subject )

		;

		Action = `Forward to Email Address`,
		trace( `***Result: Failed - Forward to Email Address***` ),

		sys_assertz( grammar_set( i_analyse_forward_to_address ) ),
		
		remaining_forward_text( Remaining_Forward_Text ),
		
		strcat_list( [ Beginning_Text, Document_Error_Text, Remaining_Forward_Text ], Forward_Email_Body ),
		
		assertz_derived_data( invoice, forward_email_body, Forward_Email_Body, i_insert_forward_email_body ),

		assertz_derived_data( invoice, forward_email, Email_Address, i_insert_forward_email ),
		
		assertz_derived_data( invoice, forward_email_subject, Subject, i_insert_forward_email_subject )

		;

		Action = `Delete`,
		trace( `***Result: Failed - Delete Document***` ),

		sys_assertz( grammar_set( i_analyse_junk_flag ) )

	),

	assertz_derived_data( invoice, force_result, Result, i_force_result ),

	assertz_derived_data( invoice, force_sub_result, Sub_Result, i_force_sub_result ),

	sys_assertz( grammar_set( ignore_enquire ) ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ACTION FLAG AS FAIL AND POSTS BEFORE SENDING TO INTERVENTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_flag_as_fail_and_posts_alternate___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_flag_as_fail_and_posts_alternate___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( ignore_enquire ) ),

	get_header_level_data_item_flag_as_fail_and_posts( Header_Level_Data_Item_List ),

	get_line_level_data_item_flag_as_fail_and_posts( Line_Level_Data_Item_List ),

	get_document_scenario_flag_as_fail_and_posts( Document_Scenario_List ),

	(
		(
			q_sys_member( Sub_Result, Header_Level_Data_Item_List )

			;

			q_sys_member( Sub_Result, Line_Level_Data_Item_List )

			;

			q_sys_member( Sub_Result, Document_Scenario_List )

		),

		assertz_derived_data( invoice, force_result, `failed`, i_force_failed ),

		assertz_derived_data( invoice, force_sub_result, Sub_Result, i_force_sub_result ),

		sys_assertz( grammar_set( i_analyse_flag_as_fail_and_post ) ),

		trace( `***Result: Flag As Fail and Post***` )

		;

		Header_Level_Data_Item_List = [ ],
		
		Line_Level_Data_Item_List = [ ],

		Document_Scenario_List = [ ]

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REASON CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_reason_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_reason_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	sys_retractall( result( _, invoice, ct_reason, _ ) ),
	sys_retractall( result( _, invoice, invoice_status_reason_code, _ ) ),
	
	(
		i_user_data( customer_intervention_form( Customer_Form ) ),

		json_get_list_values( Customer_Form, `ignored_customer_intervention_questions`, Ignored_Customer_Intervention_Quesntions )

		;

		Ignored_Customer_Intervention_Quesntions = [ ]

	),

	!,

	(
		i_user_data( rules_intervention_form( Rules_Form ) ),

		json_get_list_values( Rules_Form, `ignored_rules_intervention_questions`, Ignored_Rules_Intervention_Quesntions )

		;

		Ignored_Rules_Intervention_Quesntions = [ ]

	),

	!,
	
	sys_findall(
		Failure_Reason,
		(
			required_data_item( Data_Item_Name, _, _, _, _, `Flag As Fail and Post`, _, _, _, Variable, Dependency ),
			sys_call( Dependency ),
			any_lines_present,
			not( q_sys_sub_string( Variable, 1, _, `line_` ) ),
			sys_string_atom( Variable, Var ),
			not( result( _, invoice, Var, _ ) ),
			strcat_list( [ `Missing `, Data_Item_Name ], Failure_Reason ),
			not( q_sys_member( Data_Item_Name, Ignored_Rules_Intervention_Quesntions ) ),
			not( q_sys_member( Data_Item_Name, Ignored_Customer_Intervention_Quesntions ) )
		),
		Header_Level_Data_Item_Failure_Reason_List_Raw
	),

	i_force_list( Header_Level_Data_Item_Failure_Reason_List_Raw, Header_Level_Data_Item_Failure_Reason_List ),

	!,

	sys_findall(
		Failure_Reason,
		(
			required_data_item( Data_Item_Name, _, _, _, _, `Flag As Fail and Post`, _, _, _, Variable, Dependency ),
			sys_call( Dependency ),
			any_lines_present,
			q_sys_sub_string( Variable, 1, _, `line_` ),
			sys_string_atom( Variable, Var ),
			sys_findall(
				LID_String,
				(
					result( _, LID, _, _ ),
					sys_string_number( LID_String, LID ),
					not( result( _, LID, line_type, _ ) ),
					not( result( _, LID, Var, _ ) )
				),
				List_of_Line_Numbers_Raw
			),
			i_force_list( List_of_Line_Numbers_Raw, List_of_Line_Numbers ),
			List_of_Line_Numbers \= [ ],
			strcat_list( [ `Missing `, Data_Item_Name ], Failure_Reason ),
			not( q_sys_member( Data_Item_Name, Ignored_Rules_Intervention_Quesntions ) ),
			not( q_sys_member( Data_Item_Name, Ignored_Customer_Intervention_Quesntions ) )
		),
		Line_Level_Data_Item_Failure_Reason_List_Raw
	),

	i_force_list( Line_Level_Data_Item_Failure_Reason_List_Raw, Line_Level_Data_Item_Failure_Reason_List ),

	!,

	sys_findall(
		Failure_Reason,
		(
			document_scenario( Scenario, _, _, `Flag As Fail and Post`, _, _, _, _, _, _, _, Dependency ),
			sys_call( Dependency ),
			Scenario = Failure_Reason,
			not( q_sys_member( Data_Item_Name, Ignored_Rules_Intervention_Quesntions ) ),
			not( q_sys_member( Data_Item_Name, Ignored_Customer_Intervention_Quesntions ) )
		),
		Document_Scenario_Failure_Reason_List_Raw
	),

	i_force_list( Document_Scenario_Failure_Reason_List_Raw, Document_Scenario_Failure_Reason_List ),

	!,

	sys_append( Header_Level_Data_Item_Failure_Reason_List, Line_Level_Data_Item_Failure_Reason_List, Data_Item_Failure_Reason_List ),

	sys_append( Data_Item_Failure_Reason_List, Document_Scenario_Failure_Reason_List, Failure_Reason_List ),

	(
		Failure_Reason_List = [ ],
	
		assertz_derived_data( invoice, ct_reason, `SUCCESS`, i_analyse_reason_code ),
		assertz_derived_data( invoice, invoice_status_reason_code, `SUCCESS`, i_analyse_reason_code )

		;

		Failure_Reason_List = [ Document_Failure_Reason ],

		reason_code_lookup( Document_Failure_Reason, Reason_Code ),
	
		assertz_derived_data( invoice, ct_reason, Reason_Code, i_analyse_reason_code ),
		assertz_derived_data( invoice, invoice_status_reason_code, Reason_Code, i_analyse_reason_code )

		;

		Failure_Reason_List = [ Reason_1 | Remaining_Reasons ],
	
		assertz_derived_data( invoice, ct_reason, `MULTIPLE_REASONCODES`, i_analyse_reason_code ),
		assertz_derived_data( invoice, invoice_status_reason_code, `MULTIPLE_REASONCODES`, i_analyse_reason_code )

	),
	
	!
.
