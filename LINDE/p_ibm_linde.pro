%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_LINDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_linde, `27/02/2018 12:34:57` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_linde.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_numerical_validation.pro` ).
i_rules_file( `p_duplicate_new.pro` ).

i_user_field( invoice, vendor_id, `vendor_id` ).
i_user_field( invoice, zip_file_name, `zip_file_name` ).
i_user_field( invoice, batch_name, `batch_name` ).
i_user_field( invoice, timestamp, `timestamp` ).
i_user_field( invoice, client_code, `client_code` ).
i_user_field( invoice, number_of_docs, `number_of_docs` ).
i_user_field( invoice, process_name, `process_name` ).
i_user_field( invoice, process_priority, `process_priority` ).
i_user_field( invoice, file_name, `file_name` ).
i_user_field( invoice, mime_type, `mime_type` ).
i_user_field( invoice, item_type, `item_type` ).
i_user_field( invoice, capture_type, `capture_type` ).
i_user_field( invoice, ct_id, `ct_id` ).
i_user_field( invoice, ct_capture_time, `ct_capture_time` ).
i_user_field( invoice, ct_email_to, `ct_email_to` ).
i_user_field( invoice, ct_email_from, `ct_email_from` ).
i_user_field( invoice, email_from, `email_from` ).
i_user_field( invoice, ct_email_subject, `ct_email_subject` ).
i_user_field( invoice, ct_pages, `ct_pages` ).
i_user_field( invoice, ct_reason, `ct_reason` ).
i_user_field( invoice, supplier_id, `supplier_id` ).
i_user_field( invoice, supplier_bank_code, `supplier_bank_code` ).
i_user_field( invoice, supplier_iban, `supplier_iban` ).
i_user_field( invoice, supplier_swift_code, `supplier_swift_code` ).
i_user_field( invoice, total_withheld_tax, `total_withheld_tax` ).
i_user_field( invoice, fiscal_year, `fiscal_year` ).

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
i_op_param( rules_intervention_role, _, _, _, `Linde (Technical)` ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `Linde` ). % This will be the role for customer intervention (this field is mandatory)

%-----------------------------------------------------------------------
% Duplicate Table to Use
%-----------------------------------------------------------------------
i_op_param( duplicate_table_to_use, _, _, _, `ibm_linde` ).

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

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( client_code ), client_code( `LND1` )
	, remove( number_of_docs ), number_of_docs( `1` )
	, remove( process_name ), process_name( `LND1_APInvoice01_Process` )
	, remove( process_priority ), process_priority( `100` )
	, remove( mime_type ), mime_type( `application/pdf` )
	, remove( item_type ), item_type( `LND1_APInvoice01` )
	, remove( capture_type ), capture_type( `CLOUDTRADE` )
	, remove( buyer_dept )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ZIP FILE NAME & BATCH NAME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( zip_file_name ), zip_file_name( Zip_File_Name )
	
	, remove( batch_name ), batch_name( Zip_File_Name )
	
	, remove( file_name ), file_name( PDF_File_Name )

] )
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
	strcat_list( [ `LND1_CT_`, IDPad, `.zip` ], Zip_File_Name ),
	strcat_list( [ `LND1_CT_`, IDPad, `.pdf` ], PDF_File_Name )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TIMESTAMP, CT CAPTURE TIME AND FISCAL YEAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( timestamp ), timestamp( Timestamp )
	
	, remove( ct_capture_time ), ct_capture_time( Timestamp_Formatted )

	, remove( fiscal_year ), fiscal_year( YPad )

] )
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

	strcat_list( [ YPad, `-`, MPad, `-`, DPad, `-`, HPad, `.`, MinPad, `.`, SPad ], Timestamp_Formatted )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT ID
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( ct_id ), ct_id( CT_ID )

] )
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
	
	strcat_list( [ YPad, MPad, DPad, `_CT`, IDPad ], CT_ID )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT EMAIL DETAILS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( ct_email_to ), ct_email_to( To )
	
	, remove( ct_email_from ), ct_email_from( From )

	, remove( ct_email_subject ), ct_email_subject( Subject )

] )
:-
	i_mail( to, To ),
	i_mail( from, From ),
	i_mail( subject, Subject )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EMAIL FROM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( email_from ), email_from( Email_From )
	
] )
:-
	i_mail( subject, Subject ),

	sys_string_split( Subject, `-`, [ Email_From, _ ] )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CT PAGES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( ct_pages ), ct_pages( Number_of_Pages )

] )
:-
	i_working_pages( Page_List, _ ),

	sys_reverse( Page_List, [ page( _, Number_of_Pages ) | _ ] )
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

		(
			result( _, invoice, order_number, _ ),

			assertz_derived_data( invoice, invoice_type, `POC`, i_analyse_invoice_type )

			;

			not( result( _, invoice, order_number, _ ) ),

			assertz_derived_data( invoice, invoice_type, `NPOC`, i_analyse_invoice_type )

		)

		;

		not( grammar_set( credit_note ) ),

		(
			result( _, invoice, order_number, _ ),

			assertz_derived_data( invoice, invoice_type, `PO`, i_analyse_invoice_type )

			;

			not( result( _, invoice, order_number, _ ) ),

			assertz_derived_data( invoice, invoice_type, `NPO`, i_analyse_invoice_type )

		)


	),

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
% LINE QUANTITY UOM CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_last( LID ):- i_analyse_line_quantity_uom_code___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_quantity_uom_code___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, LID, line_quantity_uom_code, _ ) ),

	assertz_derived_data( LID, line_quantity_uom_code, `EACH`, i_analyse_line_quantity_uom_code ),

	!
.
