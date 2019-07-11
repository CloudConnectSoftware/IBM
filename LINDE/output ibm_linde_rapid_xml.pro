
i_version( output_ibm_linde_rapid_xml, `11/07/2019 14:40:10` ).

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

	write_variable_as_tag( invoice, number_of_docs, `numdocs` ),

	write_start_element( `process` ),
	
		write_variable_as_tag( invoice, process_name, `name` ),
		
		write_variable_as_tag( invoice, process_priority, `priority` ),
		
	write_end_element
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

	write_variable_as_tag( invoice, notelog, `notelog` ),

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

	write_field( `S_CaptureType`, invoice, capture_type ),
	
	write_field( `D_Country`, invoice, buyer_dept ),
	
	write_field( `D_CompanyCode`, invoice, buyer_registration_number ),
	
	write_field( `S_CTID`, invoice, ct_id ),
	
	write_field( `S_CTCaptureTime`, invoice, ct_capture_time ),
	
	write_field( `S_CTEmailTo`, invoice, ct_email_to ),
	
	write_field( `S_CTEmailFrom`, invoice, ct_email_from ),

	write_field( `S_EmailFrom`, invoice, email_from ),
	
	write_field( `S_CTEmailSubject`, invoice, ct_email_subject ),
	
	write_field( `S_CTPages`, invoice, ct_pages ),

	write_field( `S_CTReason`, invoice, ct_reason ),
	
	write_field( `D_SuppName`, invoice, supplier_party ),
	
	write_field( `D_SuppNum`, invoice, supplier_id ),
	
	write_field( `D_VATNo`, invoice, supplier_vat_number ),
	
	write_field( `D_VendorBankAcc`, invoice, supplier_bank_account_number ),
	
	write_field( `D_VendorBankCode`, invoice, supplier_bank_code ),
	
	write_field( `D_VendorIBAN`, invoice, supplier_iban ),
	
	write_field( `D_VendorSwift`, invoice, supplier_swift_code ),
	
	write_field( `D_DocType`, invoice, invoice_type ),
	
	write_field( `D_InvDate`, invoice, date ),
	
	write_field( `D_InvDueDate`, invoice, processed_due_date ),
	
	write_field( `D_InvPayterms`, invoice, payment_terms ),

	write_field( `D_InvNumber`, invoice, invoice_number ),

	write_field( `D_InvAmount`, invoice, total_invoice ),

	write_field( `D_InvTaxCode`, invoice, default_vat_code ),

	write_field( `D_InvTax`, invoice, total_vat ),

	write_field( `D_WithHoldTax`, invoice, total_withheld_tax ),

	write_field( `D_Curr`, invoice, currency ),
	
	write_field( `D_PONo`, invoice, order_number ),
	
	write_field( `D_DelivNo`, invoice, delivery_note_number ),

	write_field( `D_FiscalYear`, invoice, fiscal_year )
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
		
		strcat_list( [ Client_Code, `_`, `LINE01` ], LineType ),
		
		write_attribute_string( `type`, LineType ),

		write_start_element( `fields` ),

			sys_string_number( LIDS, LID ),

			write_field( `L_LineType`, LID, line_type_code ),

			write_field( `L_LineNumber`, LIDS ),

			write_field( `L_POLineNumber`, LID, line_order_line_number ),

			write_field( `L_LineAmount`, LID, line_total_amount ),
			
			write_field( `L_LineNet`, LID, line_net_amount ),
			
			write_field( `L_TaxRate`, LID, line_vat_rate ),
			
			write_field( `L_TaxAmount`, LID, line_vat_amount ),
			
			write_field( `L_PONumber`, LID, line_buyers_order_number ),
			
			write_field( `L_Description`, LID, line_descr ),

			write_field( `L_PartNumber`, LID, line_item ),

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
	
				;    ( qq_op_param( xml_transform( Var, Val ), ValAdjusted ) -> true ; ValAdjusted = Val ),
                write_field( Name, ValAdjusted )

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

