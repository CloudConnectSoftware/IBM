
i_version( output_ibm_pepsico_rapid_xml, `23/04/2018 13:43:49` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_output( VAT_totals, Version )
%-------------------------------------------------------------------------------
:- d1( write_output___( VAT_totals, Version ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_output___( VAT_totals, Version )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `rapid` ),

		write_start_element( `import` ),

			write_start_element( `controlfile` ),

				write_control_file_preamble,

				write_start_element( `batchinfo` ),

					write_batchinfo_preamble,

					write_start_element( `documents` ),

						write_start_element( `document` ),

							write_document,

						write_end_element,

					write_end_element,

				write_end_element,

			write_end_element,

		write_end_element,

	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_control_file_preamble
%-------------------------------------------------------------------------------
:- d1( write_control_file_preamble___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_control_file_preamble___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_variable_as_tag( invoice, vendor_id, `vendorid` ),

	write_variable_as_tag( invoice, zip_file_name, `zipfilename` ),

	write_variable_as_tag( invoice, batch_name, `batchname` ),
	
	write_variable_as_tag( invoice, timestamp, `timestamp` ),

	write_start_element( `options` ),
		
		write_option( `processatbatchlevel`, `true` ),

		write_option( `maxnumdocs`, `20` ),

	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_option( Name, Value )
%-------------------------------------------------------------------------------
:- d1( write_option___( Name, Value ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_option___( Name, Value )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `option` ),

		write_attribute_string( `name`, Name ),

		write_string( Value ),

	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_batchinfo_preamble
%-------------------------------------------------------------------------------
:- d1( write_batchinfo_preamble___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_batchinfo_preamble___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_variable_as_tag( invoice, client_code, `clientcode` ),

	write_variable_as_tag( invoice, number_of_docs, `numdocs` )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_document
%-------------------------------------------------------------------------------
:- d1( write_document___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_document___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_variable_as_tag( invoice, file_name, `filename` ),

	write_variable_as_tag( invoice, mime_type, `mimetype` ),

	write_variable_as_tag( invoice, item_type, `itemtype` ),

	write_start_element( `fields` ),

		write_invoice_fields,

	write_end_element,

	write_start_element( `childcomponents` ),

		write_lines( write_line ),

	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_invoice_fields
%-------------------------------------------------------------------------------
:- d1( write_invoice_fields___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_invoice_fields___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_field( `C_CTID`, invoice, ct_id ),
	
	write_field( `C_CTCaptureTime`, invoice, ct_capture_time ),
	
	write_field( `C_CTEmailTo`, invoice, ct_email_to ),
	
	write_field( `C_CTEmailFrom`, invoice, ct_email_from ),
	
	write_field( `C_CTEmailSubject`, invoice, ct_email_subject ),
	
	write_field( `C_CTPages`, invoice, ct_pages ),

	write_field( `C_CTReason`, invoice, ct_reason ),

	write_field( `C_CaptureType`, invoice, capture_type ),

	write_field( `T_InvStatus`, invoice, invoice_status ),

	write_field( `T_InvStatusRsn`, invoice, invoice_status_reason_code ),

	write_field( `H_CompanyID`, invoice, buyer_id ),

	write_field( `H_CompanyCode`, invoice, buyer_registration_number ),

	write_field( `H_CompanyName`, invoice, company_name ),

	write_field( `H_ERP`, invoice, erp_id ),

	write_field( `H_Country`, invoice, buyer_dept ),

	write_field( `H_BusinessUnit`, invoice, business_unit ),

	write_field( `H_InvDate`, invoice, date ),

	write_field( `H_InvNumber`, invoice, invoice_number ),

	write_field( `H_InvAmount`, invoice, total_invoice ),

	write_field( `H_Curr`, invoice, currency ),

	write_field( `H_DocType`, invoice, invoice_type ),

	write_field( `H_PONo`, invoice, order_number ),

	write_field( `H_InvDueDate`, invoice, processed_due_date ),

	write_field( `H_InvPayterms`, invoice, payment_terms ),

	write_field( `H_InvTaxAmt`, invoice, total_vat ),

	write_field( `H_WHTaxAmt`, invoice, total_withholding_tax ),

	write_field( `H_Requestor`, invoice, requestor ),

	write_field( `H_DelivNo`, invoice, delivery_note_number ),

	write_field( `H_PreApp`, invoice, pre_approved ),

	write_field( `H_PepsiCoTaxID`, invoice, buyer_vat_number ),

	write_field( `H_PepsiCoEntity`, invoice, buyer_party ),

	write_field( `H_PepsiCoAdd1`, invoice, buyer_address_line ),

	write_field( `H_PepsiCoAdd2`, invoice, buyer_street ),

	write_field( `H_PepsiCoCity`, invoice, buyer_city ),

	write_field( `H_PepsiCoPostCode`, invoice, buyer_postcode ),

	write_field( `S_UniqueVendorID`, invoice, supplier_unique_id ),
	
	write_field( `S_VendorTaxNo`, invoice, supplier_vat_number ),
	
	write_field( `S_VendorName`, invoice, supplier_party ),
	
	write_field( `S_VendorNum`, invoice, buyers_code_for_supplier ),
	
	write_field( `S_VendorPayTerms`, invoice, supplier_payment_terms ),
	
	write_field( `S_VendorAdd1`, invoice, supplier_address_line ),
	
	write_field( `S_VendorAdd2`, invoice, supplier_street ),
	
	write_field( `S_VendorCity`, invoice, supplier_city ),
	
	write_field( `S_VendorPostCode`, invoice, supplier_postcode ),
	
	write_field( `S_RemVendorName`, invoice, remit_to_party ),
	
	write_field( `S_RemVendorAdd1`, invoice, remit_to_address_line ),
	
	write_field( `S_RemVendorAdd2`, invoice, remit_to_street ),

	write_field( `S_RemVendorCity`, invoice, remit_to_city ),

	write_field( `S_RemVendorPostCode`, invoice, remit_to_postcode ),

	write_field( `S_RemVendorBankAcc`, invoice, remit_to_bank_account_number ),

	write_field( `S_RemVendorBankCode`, invoice, remit_to_bank_code ),
	
	write_field( `S_RemVendorIBAN`, invoice, remit_to_iban ),
	
	write_field( `S_RemVendorSwift`, invoice, remit_to_swift_code )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_line( LID )
%-------------------------------------------------------------------------------
:- d1( write_line___( LID ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_line___( LID )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `childcomponent` ),

		(	result( _, invoice, client_code, Client_Code )

			;	Client_Code = ``

		),
		
		strcat_list( [ Client_Code, `_`, `L_APLine` ], LineType ),
		
		write_attribute_string( `type`, LineType ),

		write_start_element( `fields` ),

			write_field( `L_LineNumber`, LID, line_number ),

			write_field( `L_LineType`, LID, line_type_code ),

			write_field( `L_POLineNumber`, LID, line_order_line_number ),

			write_field( `L_LineAmount`, LID, line_total_amount ),
			
			write_field( `L_LineNet`, LID, line_net_amount ),
			
			write_field( `L_TaxRate`, LID, line_vat_rate ),
			
			write_field( `L_TaxAmount`, LID, line_vat_amount ),
			
			write_field( `L_PONumber`, LID, line_buyers_order_number ),
			
			write_field( `L_Description`, LID, line_descr ),

			write_field( `L_PartStockNumber`, LID, line_item ),

			write_field( `L_DelivNo`, LID, line_delivery_note_number ),

			write_field( `L_UnitPrice`, LID, line_unit_amount ),
			
			write_field( `L_UOM`, LID, line_quantity_uom_code ),

			write_field( `L_Quantity`, LID, line_quantity ),
			
		write_end_element,
		
	write_end_element
.	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_field( Name, Type, Var )
%-------------------------------------------------------------------------------
:- d1( write_field___( Name, Type, Var ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_field___( Name, Type, Var )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	(	result( _, Type, Var, Val )

		->	( input_field_is_date( Type, _, Var ) % assume it's the processed Var not the raw Var
			
				->	string_date( Val_date_s, Val ),
	
					write_field( Name, Val_date_s )
	
				;	write_field( Name, Val )

			)

		;	write_field( Name, `` )

	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_field( Name, Val )
%-------------------------------------------------------------------------------
:- d1( write_field___( Name, Val ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_field___( Name, Val )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	(	result( _, invoice, client_code, Client_Code )

		;	Client_Code = ``

	),
	
	strcat_list( [ Client_Code, `_`, Name ], Field_Name ),
	
	write_start_element( `field` ),

		write_element_string( `name`, Field_Name ),

		write_element_string( `value`, Val ),

	write_end_element
.

