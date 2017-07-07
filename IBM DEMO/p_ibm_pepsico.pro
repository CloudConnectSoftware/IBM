%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_PEPSICO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_pepsico, `09:20 07 July 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_pepsico.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).

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
i_user_field( invoice, ct_email_subject, `ct_email_subject` ).
i_user_field( invoice, ct_pages, `ct_pages` ).
i_user_field( invoice, supplier_bank_code, `supplier_bank_code` ).
i_user_field( invoice, supplier_iban, `supplier_iban` ).
i_user_field( invoice, supplier_swift_code, `supplier_swift_code` ).
i_user_field( invoice, requestor, `requestor` ).
i_user_field( invoice, vendor_terms, `vendor_terms` ).

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
i_op_param( rules_intervention_role, _, _, _, `CloudTrade (PepsiCo)` ). % This will be the role for rules intervention
i_op_param( customer_name, _, _, _, `PepsiCo` ). % This will be the role for customer intervention (this field is mandatory)

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
% HARD-CODED VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( vendor_id ), vendor_id( `PEPC` )
	, remove( client_code ), client_code( `PEPC` )
	, remove( number_of_docs ), number_of_docs( `1` )
	, remove( process_name ), process_name( `PEPC_InvoiceProcess` )
	, remove( process_priority ), process_priority( `100` )
	, remove( mime_type ), mime_type( `application/pdf` )
	, remove( item_type ), item_type( `PEPC_Invoices` )
	, remove( capture_type ), capture_type( `CLOUDTRADE` )
	, remove( invoice_type ), invoice_type( `INVOICE` )
	, remove( payment_terms ), payment_terms( `30` )
	, remove( requestor ), requestor( `Bill King` )
	, remove( buyers_code_for_supplier ), buyers_code_for_supplier( `S12345678` )
	, remove( vendor_terms ), vendor_terms( `30` )

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
	i_mail( time_stamp, Timestamp ),
	strip_string2_from_string1( Timestamp, `.`, Timestamp_Stripped ),
	q_sys_sub_string( Timestamp_Stripped, 1, 8, Timestamp_Final ),
	i_mail( unique_id, ID ),
	sys_string_number( IDS, ID ),
	string_pad_left( IDS, 8, `0`, IDPad ),
	strcat_list( [ `PEPC_CT_`, Timestamp_Final, `_`, IDPad, `.zip` ], Zip_File_Name ),
	strcat_list( [ `PEPC_CT_`, Timestamp_Final, `_`, IDPad, `.pdf` ], PDF_File_Name )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TIMESTAMP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( timestamp ), timestamp( Timestamp_Stripped )
	
	, remove( ct_capture_time ), ct_capture_time( Timestamp_Formatted )

] )
:-
	i_mail( time_stamp, Timestamp ),
	strip_string2_from_string1( Timestamp, `.`, Timestamp_Stripped ),
	q_sys_sub_string( Timestamp, 1, 13, Timestamp_Beginning ),
	string_string_replace( Timestamp_Beginning, `.`, `-`, Timestamp_Replaced ),
	q_sys_sub_string( Timestamp, 14, 6, Timestamp_End ),
	strcat_list( [ Timestamp_Replaced, Timestamp_End ], Timestamp_Formatted )
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

	remove( ct_id ), ct_id( UniqueID )

] ):- i_mail( unique_id, UniqueID ).

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

] ):- i_mail( to, To ), i_mail( from, From ), i_mail( subject, Subject ).

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

] ):- i_working_pages( Page_List, _ ), sys_reverse( Page_List, [ page( _, Number_of_Pages ) | _ ] ).
