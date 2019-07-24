%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Version Control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%		-	13th April 2016
%
%			--	First Version
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( output_ibm_dc_xml, `24/07/2019 07:25:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_op_param( xml_encoding, _, _, _, `ISO-8859-1` ).

i_op_param( xml_transform( buyer_registration_number, In ), _, _, _, Out ) :- size_restrict_text( In, 4, Out ).

i_op_param( xml_transform( plant_code, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_empty_tags( invoice_number ), _, _, _, `0` ).
i_op_param( xml_transform( invoice_number, In ), _, _, _, Out ) :- size_restrict_text( In, 16, Out ).

i_op_param( xml_transform( buyers_code_for_supplier, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Restricted ), string_pad_left( Restricted, 10, `0`, Out ).

i_op_param( xml_transform( supplier_vat_number, In ), _, _, _, Out ) :- size_restrict_text( In, 20, Out ).

i_op_param( xml_transform( supplier_bank_account_number, In ), _, _, _, Out ) :- size_restrict_text( In, 18, Out ).
i_op_param( xml_transform( supplier_bank_code, In ), _, _, _, Out ) :- size_restrict_text( In, 15, Out ).
i_op_param( xml_transform( supplier_bank_ogm, In ), _, _, _, Out ) :- size_restrict_text( In, 50, Out ).
i_op_param( xml_transform( payment_terms, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_transform( narrative, In ), _, _, _, Out ) :- size_restrict_text( In, 50, Out ).

i_op_param( xml_transform( customer_comments, In ), _, _, _, Out ) :- size_restrict_text( In, 250, Out ).


i_op_param( xml_transform( line_buyers_order_number, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_transform( line_delivery_note_number, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_transform( line_item, In ), _, _, _, Out ) :- size_restrict_text( In, 18, Out ).

i_op_param( xml_transform( line_cost_centre, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_transform( line_internal_order_number, In ), _, _, _, Out ) :- size_restrict_text( In, 12, Out ).

i_op_param( xml_transform( line_gl, In ), _, _, _, Out ) :- size_restrict_text( In, 10, Out ).

i_op_param( xml_transform( line_descr, In ), _, _, _, Out ) :- size_restrict_text( In, 240, Out ).

i_op_param( xml_empty_tags( _ ), _, _, _, `` ).

i_override_2dp_amount( total_net ).
i_override_2dp_amount( total_vat ).
i_override_2dp_amount( total_invoice ).

i_override_4dp_amount( line_quantity ).
i_override_2dp_amount( line_unit_amount ).
i_override_2dp_amount( line_net_amount ).
i_override_2dp_amount( line_vat_amount ).
i_override_2dp_amount( line_total_amount ).


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

	write_start_element( `DCDocumentData`, `http://tempuri.org/DCDocumentData.xsd` ),
	
		write_header,
		
		write_dc_swiss_header, 
	
		write_lines( write_line ),

	write_end_element
.	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_header
%-------------------------------------------------------------------------------
:- d1( write_header___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_header___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `DC_Header` ),
	
		write_variable_as_tag( invoice, invoice_type, `Inv_Type` ),
		
		write_variable_as_date_with_ibm_timestamp( invoice, date, `Doc_Date` ),
		
		%%	Date of transmission
		write_variable_as_date_with_ibm_timestamp( system, today, `Scan_Date` ),

		write_variable_as_tag( invoice, buyer_registration_number, `Company_Code` ), %% Should be 1747 or 1779

		( result( _, invoice, plant_code, PlantCode )
			->	true
			;	PlantCode = `0000`
		),
		write_element_string( `Plant_Code`, PlantCode ), %Four characters

		write_variable_as_tag( invoice, invoice_number, `Invoice_Num` ),

		% write_variable_as_tag( invoice, bol_number, `BOL_Number` ),

		write_ibm_number_variable_as_tag( invoice, total_invoice, `Total_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, total_vat, `Tax_Amount`, '2dp_' ),
		
		write_variable_as_tag( invoice, currency, `Currency_Code` ), % Needs to be in ISO format
		
		write_variable_as_date_with_ibm_timestamp( invoice, processed_due_date, `Due_Date` ),
		
		write_variable_as_tag( invoice, buyers_code_for_supplier, `Vendor_ID` ),
		
		write_variable_as_tag( invoice, supplier_vat_number, `Vendor_VAT_Code` ),
		write_variable_as_tag( invoice, buyer_vat_number, `Buyer_VAT_Code` ),
		
		( qq_op_param( unique_id, ScanID )
		
			% Below is what the unique_id op_param should do
			
			% i_mail( unique_id, ID ),
			% sys_string_number( IDS, ID ),
			
			% date_get( today, Today ),
			% sys_date_string( Today, 'y-m-d', TodayWithHyphen ),
			% strip_string2_from_string1( TodayWithHyphen, `-`, TodayString ),
			% strcat_list( [ TodayWithHyphen, `_CT`, IDS ], Scan_ID ),
			
			->	write_element_string( `Scan_ID`, ScanID ) % ScanID - needs to be YYMMDD_CT* Sequential ID
			
			;	instance( Instance ),
				q_sys_sub_string( Instance, _, _, `DBG` )
		),
		
		( qq_op_param( split_input_transfer_name( _ ), ImageFile )
			->	true
			
			;	i_mail( image_file_name, ImageFile )
			
			;	instance( Instance ),
				q_sys_sub_string( Instance, _, _, `DBG` ),
				ImageFile = `Test file`
		),
		write_element_string( `Image_File`, ImageFile ), %ImageFile - needs to be the same as the tif
		
		write_variable_as_date_with_ibm_timestamp( default, default, `Discount_Date` ),

		( result( _, invoice, total_percent_discount, _ )
			->	write_ibm_number_variable_as_tag( invoice, total_percent_discount, `Discount_Percent`, '2dp_' )
			;	write_element_string( `Discount_Percent`, `0` )
		),
		write_element_string( `Invoice_Exception`, `` ),
		
		write_variable_as_date_with_ibm_timestamp( system, today, `Import_Date` ),
		write_element_string( `Import_Status`, `READY TO IMPORT` ),
		
		write_variable_as_tag( invoice, supplier_bank_account_number, `Bank_Account` ), % Needs to be validated
		write_variable_as_tag( invoice, supplier_bank_code, `Bank_Code` ),
		write_variable_as_tag( invoice, supplier_bank_ogm, `Bank_OGM` ),
		write_variable_as_tag( invoice, payment_terms, `Payment_Term` ),
		
		write_variable_as_tag( invoice, narrative, `Description` ),
		
		write_element_string( `IRPF_Value`, `0` ),
		
		write_variable_as_tag( invoice, customer_comments, `Other_Information` ),
		
		write_element_string( `Nr_Of_Images`, `1` ),
		write_variable_as_tag( invoice, exchange_rate, `Exch_Rate` ),
		
		write_element_string( `Indexer_Id`, `CLTR` ), % Our Identifier
		
		write_variable_as_tag( invoice, erp_ref_number, `ERP_Ref_Number` ),
		
		( result( _, invoice, total_local_vat, _ )
			->	write_ibm_number_variable_as_tag( invoice, total_local_vat, `VAT_Local_Amount`, '4dp_' ) % Only for foreign invoices with UK VAT
			;	write_element_string( `VAT_Local_Amount`, `0` )
		),
		write_ibm_number_variable_as_tag( invoice, total_discount, `Discount_Amount`, '4dp_' ),
		
		write_variable_as_tag( invoice, por_reference, `POR_Reference` ),
		write_variable_as_tag( invoice, tax_reporting_country, `TaxReportingCountry` ),
		write_variable_as_tag( invoice, vat_region, `VATRegion` ),
		write_variable_as_tag( invoice, attention_of, `AttentionOf` ),
		write_variable_as_tag( invoice, ob10_link, `OB10_Link` ),
		write_variable_as_tag( invoice, payment_reference, `Payment_Reference` ),
		
		write_variable_as_tag( invoice, ship_from_dummy, `ShipFrom` ),
		write_variable_as_tag( invoice, ship_to_dummy, `ShipTo` ),
		write_variable_as_tag( invoice, bill_from_dummy, `BillFrom` ),
		write_variable_as_tag( invoice, bill_to_dummy, `BillTo` ),

	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_dc_swiss_header
%-------------------------------------------------------------------------------
:- d1( write_dc_swiss_header___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_dc_swiss_header___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `DC_Swiss_Header` ),
	
		write_variable_as_date_with_ibm_timestamp( invoice, processed_swiss_date_of_supply, `Date_Of_Supply` ),
		write_variable_as_tag( invoice, swiss_supplier_name, `Supplier_Name` ),
		write_variable_as_tag( invoice, swiss_supplier_address_1, `Supplier_Address1` ),
		write_variable_as_tag( invoice, swiss_supplier_address_2, `Supplier_Address2` ),
		write_variable_as_tag( invoice, swiss_supplier_address_3, `Supplier_Address3` ),
		write_variable_as_tag( invoice, swiss_supplier_address_4, `Supplier_Address4` ),
		write_variable_as_tag( invoice, swiss_supplier_address_5, `Supplier_Address5` ),
		write_variable_as_tag( invoice, swiss_supplier_address_6, `Supplier_Address6` ),
		write_variable_as_tag( invoice, swiss_supplier_address_7, `Supplier_Address7` ),
		write_variable_as_tag( invoice, swiss_supplier_address_8, `Supplier_Address8` ),
		write_variable_as_tag( invoice, swiss_supplier_address_9, `Supplier_Address9` ),
		write_variable_as_tag( invoice, swiss_supplier_address_10, `Supplier_Address10` ),
		write_variable_as_tag( invoice, swiss_fiscal_name, `Supplier_Fiscal_Name` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_1, `Supplier_Fiscal_Address1` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_2, `Supplier_Fiscal_Address2` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_3, `Supplier_Fiscal_Address3` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_4, `Supplier_Fiscal_Address4` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_5, `Supplier_Fiscal_Address5` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_6, `Supplier_Fiscal_Address6` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_7, `Supplier_Fiscal_Address7` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_8, `Supplier_Fiscal_Address8` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_9, `Supplier_Fiscal_Address9` ),
		write_variable_as_tag( invoice, swiss_fiscal_address_10, `Supplier_Fiscal_Address10` ),
		write_variable_as_tag( invoice, swiss_buyer_name, `Buyer_Name` ),
		write_variable_as_tag( invoice, swiss_buyer_address_1, `Buyer_Address1` ),
		write_variable_as_tag( invoice, swiss_buyer_address_2, `Buyer_Address2` ),
		write_variable_as_tag( invoice, swiss_buyer_address_3, `Buyer_Address3` ),
		write_variable_as_tag( invoice, swiss_buyer_address_4, `Buyer_Address4` ),
		write_variable_as_tag( invoice, swiss_buyer_address_5, `Buyer_Address5` ),
		write_variable_as_tag( invoice, swiss_buyer_address_6, `Buyer_Address6` ),
		write_variable_as_tag( invoice, swiss_buyer_address_7, `Buyer_Address7` ),
		write_variable_as_tag( invoice, swiss_buyer_address_8, `Buyer_Address8` ),
		write_variable_as_tag( invoice, swiss_buyer_address_9, `Buyer_Address9` ),
		write_variable_as_tag( invoice, swiss_buyer_address_10, `Buyer_Address10` ),
		
		write_ibm_number_variable_as_tag( invoice, total_net, `Total_Net`, '2dp_' ),
		
	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

	write_start_element( `DC_Lines` ),

		sys_string_number( LIDS, LID ),
		sys_calculate_str_multiply( LIDS, `10`, LID10 ),
	
		( qq_op_param( unique_id, ScanID )
		
			% Below is what the unique_id op_param should do
			
			% i_mail( unique_id, ID ),
			% sys_string_number( IDS, ID ),
			
			% date_get( today, Today ),
			% sys_date_string( Today, 'y-m-d', TodayWithHyphen ),
			% strip_string2_from_string1( TodayWithHyphen, `-`, TodayString ),
			% strcat_list( [ TodayWithHyphen, `_CT`, IDS ], Scan_ID ),
			
			->	write_element_string( `Scan_ID`, ScanID ) % ScanID - needs to be YYMMDD_CT* Sequential ID
			
			;	instance( Instance ),
				q_sys_sub_string( Instance, _, _, `DBG` )
		),

		( result( _, LID, line_order_line_number, _ )
			->	write_variable_as_tag( LID, line_order_line_number, `Invoice_Line` )
			
			;	write_element_string( `Invoice_Line`, LID10 )
		),

		write_ibm_number_variable_as_tag( LID, line_total_amount, `Amount`, '2dp_' ),
		
		write_ibm_number_variable_as_tag( LID, line_vat_rate, `Tax_Percent`, '4dp_' ),
	
		write_ibm_number_variable_as_tag( LID, line_vat_amount, `Tax_Amount`, '2dp_' ),

		write_variable_as_tag( LID, line_vat_code, `Tax_Code` ),
		
		write_variable_as_tag( LID, line_buyers_order_number, `PO_Number` ),
		
		write_element_string( `PO_Release`, `0` ),
		
		write_variable_as_tag( LID, line_delivery_note_number, `Delivery_Note` ),

		write_ibm_number_variable_as_tag( LID, line_unit_amount, `Unit_Price`, '2dp_' ),

		write_ibm_number_variable_as_tag( LID, line_quantity, `Quantity`, '4dp_' ),

		write_variable_as_tag( LID, line_item, `MAT_NUMBER` ),
		
		write_variable_as_tag( LID, line_cost_centre, `CostCenter` ),
		write_variable_as_tag( LID, line_internal_order_number, `InternalOrder` ),
		write_variable_as_tag( LID, line_gl, `GLAccount` ),
		write_variable_as_tag( LID, line_descr, `Description` ),

	write_end_element,
	
	write_dc_swiss_line
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_dc_swiss_line
%-------------------------------------------------------------------------------
:- d1( write_dc_swiss_line___ ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_dc_swiss_line___
%-------------------------------------------------------------------------------
:-
%===============================================================================

	write_start_element( `DC_Swiss_Line` ),
	
		write_variable_as_tag( invoice, swiss_line_var, `Description_Of_Supply` ),
		
	write_end_element
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_variable_as_date_with_ibm_timestamp( Location, Variable, Tag )
%-------------------------------------------------------------------------------
:- d1( write_variable_as_date_with_ibm_timestamp___( Location, Variable, Tag ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_variable_as_date_with_ibm_timestamp___( default, default, Tag )
%-------------------------------------------------------------------------------
:-
%===============================================================================
	write_element_string( Tag, `1900-01-01T00:00:00.0000000-00:00` )	
.

%===============================================================================
write_variable_as_date_with_ibm_timestamp___( Location, Variable, Tag )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	( Location = system
		->	date_get( Variable, Date )
		
		;	result( _, Location, Variable, Date )
	)
		->	sys_date_string( Date, 'yyyy-mm-dd', DateS ),
			strcat_list( [ DateS, `T00:00:00.0000000-00:00` ], DateWithT ),
			
			write_element_string( Tag, DateWithT )
	
	;	write_element_string( Tag, `1900-01-01T00:00:00.0000000-00:00` )	
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_ibm_number_variable_as_tag( Location, Variable, Tag, DP )
%-------------------------------------------------------------------------------
:- d1( write_ibm_number_variable_as_tag___( Location, Variable, Tag, DP ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_ibm_number_variable_as_tag___( Location, Variable, Tag, DP )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	( result( _, Location, Variable, ResultRaw )
		->	true			
		;	ResultRaw = `0`
	),
	atomlist_concat( [ normalise_, DP, in_string ], RoundPred ),
	RoundValue =.. [ RoundPred, ResultRaw, Result ],
	sys_call( RoundValue ),
	
	write_element_string( Tag, Result )
.
