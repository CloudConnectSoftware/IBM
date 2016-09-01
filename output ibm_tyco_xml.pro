
i_version( output_ibm_rapid_xml, `08/08/2016 14:45:12` ).

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

	write_element_string( `vendorid`, `TYAP` ),

	( result( _, invoice, agent_code_1, FILE ) -> true ; FILE = `null` ),

	strcat_list( [ FILE, `.zip` ], ZIP_FILE ),

	write_element_string( `zipfilename`, ZIP_FILE ),

	write_element_string( `batchname`, ZIP_FILE ),

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

	write_element_string( `clientcode`, `TYAP` ),

	write_element_string( `numdocs`, `1` ),
			
	write_start_element( `process` ),
	
		write_element_string( `name`, `TYAP_AP_Process` ),
		
		write_element_string( `priority`, `1` ),
		
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

	( result( _, invoice, agent_code_1, FILE ) -> true ; FILE = `null` ),

	strcat_list( [ FILE, `.pdf` ], PDF_FILE ),

	write_element_string( `filename`, PDF_FILE ),

	(	i_mail_raw_paragraph( ParaRaw )
		->	string_string_replace( ParaRaw, `
`, `[nl]`, Para ),
			write_element_string( `notelog`, Para )

		;	write_field( `notelog`, invoice, narrative )
	),

	write_element_string( `mimetype`, `application/pdf` ),

	write_element_string( `itemtype`, `TYAP_AP` ),

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

	write_field( `TYAP_O_DocCategory`, `APINVOICE` ),
	write_field( `TYAP_O_DocType`, invoice, invoice_type ),
	write_field( `TYAP_O_Priority`, `STANDARD` ),
	write_field( `TYAP_C_CaptureType`, `EMAIL` ),
	write_field( `TYAP_C_Pages`, `1` ),
	write_field( `TYAP_O_BusinessUnit`, invoice, buyer_dept ),
	write_field( `TYAP_O_CompanyCode`, invoice, buyer_registration_number ),
	write_field( `TYAP_O_CompanyName`, invoice, buyer_party ),
	write_field( `TYAP_O_TradingName`, invoice, buyer_state),
	write_field( `TYAP_O_ERPSystemID`, invoice, agent_code_2),
	write_field( `TYAP_O_EntityName`, invoice, buyer_contact),
	write_field( `TYAP_O_Location`, invoice, buyer_country_code ),

	write_field( `TYAP_D_PONumber`, invoice, order_number ),

	write_field( `TYAP_D_InvoiceDate`, invoice, date ),

	write_field( `TYAP_D_InvoiceNumber`, invoice, invoice_number ),

	write_field( `TYAP_S_NetAmount`, invoice, total_net ),

	write_field( `TYAP_D_TaxAmount`, invoice, total_vat ),

	write_field( `TYAP_D_InvoiceAmount`, invoice, total_invoice ),

	write_field( `TYAP_D_Currency`, invoice, currency ),

	write_field( `TYAP_D_VendorNum`, invoice, buyers_code_for_supplier ),
	write_field( `TYAP_D_VendorName`, invoice, supplier_party ),
	write_field( `TYAP_D_VendorEmail`, invoice, supplier_email ),
	write_field( `TYAP_D_VendorUIN`, invoice, supplier_registration_number ),
	write_field( `TYAP_C_CaptureLocation`, `CLOUDTRADE` ),

	i_mail( subject, EMAIL_SUBJECT ),
	write_field( `TYAP_C_EmailSubject`, EMAIL_SUBJECT ),

	i_mail( to, TO ),
	write_field( `TYAP_C_EmailTo`, TO ),

	i_mail( from, FROM ),
	write_field( `TYAP_C_EmailFrom`, FROM ),

	i_mail( attachment, ATTACHMENT ),
	write_field( `TYAP_C_EmailAttachmentName`, ATTACHMENT )
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
	
		write_attribute_string( `type`, `TYAP_L_APLine` ),

		write_start_element( `fields` ),

			sys_string_number( LIDS, LID ),

			write_field( `TYAP_L_LineNumber`, LIDS ),

			write_field( `TYAP_L_LineDescription`, LID, line_descr ),

			write_field( `TYAP_L_LineAmount`, LID, line_net_amount ),

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

	( result( _, Type, Var, Val )

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

	write_start_element( `field` ),

		write_element_string( `name`, Name ),

		write_element_string( `value`, Val ),

	write_end_element
.

