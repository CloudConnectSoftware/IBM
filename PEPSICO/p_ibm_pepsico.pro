%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_IBM_PEPSICO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_pepsico, `18/04/2018 10:39:36` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_pepsico.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_numerical_validation.pro` ).
i_rules_file( `u_invoice_date_validation.pro` ).
i_rules_file( `p_duplicate_new.pro` ).

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
% i_op_param( duplicate_table_to_use, _, _, _, `` ).

%-----------------------------------------------------------------------
% Document Date Check
%-----------------------------------------------------------------------
% i_op_param( old_date_check_number_of_days, _, _, _, `` ).
% i_op_param( future_date_check_number_of_days, _, _, _, `` ).

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
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
% i_final_rule( [
%=======================================================================

	

% ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% i_analyse_invoice_fields_first:- i_analyse____.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% i_analyse____
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :-
	
% .
