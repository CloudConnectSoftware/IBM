
i_version( output_ibm_amat_rapid_xml, `25/09/2019 11:30:22` ).

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

	write_field( `S_DocID`, invoice, ct_id ),
	write_field( `S_BatchID`, invoice, batch_id ),
	write_field( `S_RecDate`, invoice, receipt_date ),
	write_field( `S_ScanDate`, invoice, scan_date ),
	write_field( `S_IndexNo`, invoice, barcode ),
	write_field( `D_SysDocT2`, invoice, system_doc_type ),
	write_field( `D_ProcType`, invoice, document_sub_type ),
	write_field( `D_BillName`, invoice, buyer_party ),
	write_field( `D_BillCode`, invoice, buyer_dept ),
	write_field( `D_IBMDeliv`, invoice, ibm_delivery_centre ),
	write_field( `D_Country`, invoice, country ),
	write_field( `D_ERPSysT2`, invoice, erp_system_id ),
	write_field( `D_SendIXOS`, invoice, send_posted_to_ixos ),
	write_field( `D_RTVPost`, invoice, rtv_post ),
	write_field( `I_InvLang`, invoice, invoice_language ),
	write_field( `I_Currency`, invoice, currency ),
	write_field( `S_CaptID2`, invoice, scan_service_center ),
	write_field( `I_InvNo`, invoice, invoice_number ),
	write_field( `I_InvDate`, invoice, date ),
	write_field( `D_ERPFisca`, invoice, fiscal_year ),
	write_field( `I_DueDate`, invoice, processed_due_date ),
	write_field( `I_PONo`, invoice, order_number ),
	write_field( `I_TaxAmt`, invoice, total_vat ),
	write_field( `I_InvAmt`, invoice, total_invoice ),
	write_field( `I_VendIBAN`, invoice, supplier_iban ),
	write_field( `I_VendTaxID`, invoice, supplier_vat_number ),
	write_field( `I_VendSwift`, invoice, supplier_swift_code ),
	write_field( `I_VendNo`, invoice, buyers_code_for_supplier ),
	write_field( `S_ScanDate`, invoice, ct_capture_time ),
	write_field( `S_To`, invoice, ct_email_to ),
	write_field( `S_From`, invoice, ct_email_from ),
	write_field( `S_Subject`, invoice, ct_email_subject ),
	write_field( `S_IndexNo`, invoice, ct_pages ),
	write_field( `S_ArchID`, invoice, ct_reason )
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

			write_field( `F_LineTyp`, LID, line_type_code ),

			write_field( `F_POLineNo`, LID, line_order_line_number ),

			write_field( `F_PartNo`, LID, line_item ),

			write_field( `F_PartDescription`, LID, line_descr ),

			write_field( `F_AddText`, LID, line_additional_text ),

			write_field( `F_DeliveryNo`, LID, line_delivery_note_number ),
			
			write_field( `F_Quantity`, LID, line_quantity ),
			
			write_field( `F_UOM`, LID, line_quantity_uom_code ),
			
			write_field( `F_CostCentre`, LID, line_cost_centre ),
			
			write_field( `F_UnitPrice`, LID, line_unit_amount ),
			
			write_field( `F_LineTax`, LID, line_vat_amount ),
			
			write_field( `F_TaxRate`, LID, line_vat_rate ),
			
			write_field( `F_LineNet`, LID, line_net_amount ),
			
			write_field( `F_LineAmount`, LID, line_total_amount ),
			
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

