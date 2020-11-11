
i_version( output_ibm_amat_xml, `21 March 2016` ).

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

	write_element_string( `vendorid`, `AMT1` ),
	
	write_element_string( `application`, `AMT1.Scanner.Release.Module` ),

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

	write_element_string( `scannerinitials`, `AMAT` ),
	
	write_element_string( `prepid`, `AMAT` ),
	
	write_element_string( `clientcode`, `AMT1` ),

	write_element_string( `clientapp`, `AP` ),
	
	write_element_string( `stationid`, `AMAT` ),
	
	write_element_string( `location`, `AMAT` ),

	write_element_string( `numdocs`, `1` ),
			
	write_start_element( `process` ),
	
		write_element_string( `name`, `AMT1_APv2_Process` ),
		
		write_element_string( `priority`, `100` ),
		
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
	
	write_element_string( `mimetype`, `application/pdf` ),

	write_element_string( `itemtype`, `AMT1_APDocs_02` ),

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

	write_field( `AMT1_S_CaptID2`, `AMAT` ),
	
	write_field( `AMT1_D_ItemTpT2`, `AMT1_APDOCS_02` ),
	
%	write_field( `AMT1_S_DocCategory`, `APINVOICE` ),
%	write_field( `AMT1_S_DocType`, invoice, invoice_type ),
%	write_field( `AMT1_S_Priority`, `STANDARD` ),
%	write_field( `AMT1_S_CaptureType`, `EMAIL` ),
%	write_field( `AMT1_S_Pages`, `1` ),
%	write_field( `AMT1_D_BusinessUnit`, invoice, buyer_dept ),
%	write_field( `AMT1_D_CompanyCode`, invoice, buyer_registration_number ),

	write_field( `AMT1_I_VendName`, `UMS PTE LTD` ),
	
	write_field( `AMT1_D_SysDocT2`, `2WAYMATCH` ),
	
	write_field( `AMT1_D_ProcType`, `2WM` ),
	
%	write_field( `AMT1_D_BillName`, invoice, buyer_party ),
	write_field( `AMT1_D_BillName`, `APPLIED MATERIALS SOUTH EAST ASIA, PTE LTD(0095)-AMAT` ),
	
	write_field( `AMT1_D_BillCode`, `0095` ),
	
	write_field( `AMT1_D_IBMDeliv`, `DALIAN` ),
	
%	write_field( `AMT1_D_IBMDeliv`, invoice, buyer_state),
	
%	write_field( `AMT1_D_Country`, invoice, buyer_country_code ),
	write_field( `AMT1_D_Country`, `TAIWAN` ),
	
%	write_field( `AMT1_I_Currency`, invoice, currency ),
	write_field( `AMT1_I_Currency`, `USD` ),
	
	write_field( `AMT1_I_InvNo`, invoice, invoice_number ),
	
	write_field( `AMT1_I_InvDate`, invoice, date ),
	
	write_field( `AMT1_I_PONo`, invoice, order_number ),
	
	write_field( `AMT1_I_TaxAmt`, invoice, total_vat ),
	
	write_field( `AMT1_I_InvAmt`, invoice, total_invoice ),
	
%	write_field( `AMT1_D_ERPSystemID`, invoice, agent_code_2),
%	write_field( `AMT1_D_EntityName`, invoice, buyer_contact),
%	write_field( `AMT1_I_NetAmt`, invoice, total_net ),
%	write_field( `AMT1_D_VendorNum`, invoice, buyers_code_for_supplier ),
%	write_field( `AMT1_D_VendorName`, invoice, supplier_party ),
%	write_field( `AMT1_D_VendorEmail`, invoice, supplier_email ),
%	write_field( `AMT1_D_VendorUIN`, invoice, supplier_registration_number ),
%	write_field( `AMT1_S_CaptureLocation`, `CLOUDTRADE` ),

	i_mail( subject, EMAIL_SUBJECT ),
	write_field( `AMT1_S_Subject`, EMAIL_SUBJECT ),

	i_mail( to, TO ),
	write_field( `AMT1_S_To`, TO ),

	i_mail( from, FROM ),
	write_field( `AMT1_S_From`, FROM ),

	i_mail( attachment, ATTACHMENT ),
	write_field( `AMT1_S_AttName`, ATTACHMENT )
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
	
		write_attribute_string( `type`, `AMT1_L_APLine` ),

		write_start_element( `fields` ),

			sys_string_number( LIDS, LID ),

			write_field( `AMT1_L_LineNo`, LIDS ),

			write_field( `AMT1_L_LineDescr`, LID, line_descr ),

			write_field( `AMT1_L_LineAmt`, LID, line_net_amount ),

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

