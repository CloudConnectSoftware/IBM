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

i_version( ibm_india_xml_output, `21/09/2016 11:20:40` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_op_param( xml_encoding, _, _, _, `UTF-8` ).

%	Size validations not completed

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

		write_variable_as_date_with_ibm_timestamp( invoice, date, `Doc_Date` ),

		%%	Date of transmission
		write_variable_as_date_with_ibm_timestamp( system, today, `Scan_Date` ),

        %% Will be BACN, H, HUVF, I, LLPL, or UIPL depending on Entity
		write_variable_as_tag( invoice, buyer_registration_number, `Company_Code` ),

		write_variable_as_tag( invoice, invoice_number, `Invoice_Num` ),

        write_variable_as_tag( invoice, buyer_contact, `Kind_Attention_To` ),

		write_ibm_number_variable_as_tag( invoice, total_invoice, `Total_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, total_net, `Invoice_Net_Amount`, '2dp_' ),

        %%  Tax Section

		write_ibm_number_variable_as_tag( invoice, i_cess_tax_amount, `Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_excise_tax_amount, `Excise_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_h_cess_tax_amount, `H_Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_vat_lst_tax_amount, `VAT_LST_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_c_sales_tax_amount, `C_Sales_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_wct_tax_amount, `WCT_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_entry_tax_amount, `Entry_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_freight_insurance_tax_amount, `Freight_Insurance_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_discount_amount, `Discount_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_luxury_tax_amount, `Luxury_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_agri_tax_amount, `Agri_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_octroi_tax_amount, `Octroi_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_lbt_tax_amount, `LBT_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_mandi_tax_amount, `Mandi_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_other_tax_amount, `Other_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_service_tax_amount, `Service_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_gst_amount, `GST_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_additional_excise_tax_amount, `Additional_Excise_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_cust_sacd_tax_amount, `CUST_SACD_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_cust_cvd_tax_amount, `CUST_CVD_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_cust_basic_tax_amount, `CUST_Basic_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_insurance_tax_amount, `Insurance_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_green_field_cess_tax_amount, `Green_Field_Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_adi_tax_amount, `ADI_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( invoice, i_additional_vat_tax_amount, `Additional_VAT_Tax_Amount`, '2dp_' ),

		write_ibm_number_variable_as_tag( invoice, total_vat, `Total_Tax_Amount`, '2dp_' ),

		write_variable_as_tag( invoice, buyers_code_for_supplier, `Vendor_ID` ),

		write_variable_as_tag( invoice, currency, `Currency_Code` ), % Needs to be in ISO format

		write_variable_as_tag( invoice, supplier_vat_number, `Vendor_PAN_NO` ),
		write_variable_as_tag( invoice, buyer_vat_number, `Buyer_PAN_NO` ),

		write_variable_as_tag( invoice, barcode, `Barcode` ),

		%	Likely this will be linked via the barcode
		( qq_op_param( image_transfer_name( _ ), ImageFile )
			->	true

			;	i_mail( image_file_name, ImageFile )

			;	instance( Instance ),
				q_sys_sub_string( Instance, _, _, `DBG` ),
				ImageFile = `Test file`
		),
		write_element_string( `Image_File`, ImageFile ), %ImageFile - needs to be the same as the tif

		write_ibm_number_variable_as_tag( invoice, total_discount, `Discount_Amount`, '4dp_' ),

		write_variable_as_tag( invoice, supplier_party, `Supplier_Name` ),

		write_all_available_address_segments( [ supplier_street, supplier_address_line, supplier_city, supplier_state, supplier_postcode, supplier_country_code ], `Supplier_Address`, `1` ),

		write_variable_as_tag( invoice, buyer_party, `Buyer_Name`),

		write_all_available_address_segments( [ buyer_street, buyer_address_line, buyer_city, buyer_state, buyer_postcode, buyer_country_code ], `Buyer_Address`, `1` ),

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

		%%	Use LOLN if it exists, otherwise default to the line number
		( result( _, LID, line_order_line_number, _ )
			->	write_variable_as_tag( LID, line_order_line_number, `Invoice_Line` )

			;	write_element_string( `Invoice_Line`, LIDS )
		),

		write_ibm_number_variable_as_tag( LID, line_total_amount, `Gross_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_net_amount, `Net_Amount`, '2dp_' ),

		% Tax Segments
		write_ibm_number_variable_as_tag( LID, line_cess_tax_amount, `Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_excise_tax_amount, `Excise_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_h_cess_tax_amount, `H_Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_vat_lst_tax_amount, `VAT_LST_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_c_sales_tax_amount, `C_Sales_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_wct_tax_amount, `WCT_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_entry_tax_amount, `Entry_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_freight_insurance_tax_amount, `Freight_Insurance_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_discount_amount, `Discount_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_luxury_tax_amount, `Luxury_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_agri_tax_amount, `Agri_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_octroi_tax_amount, `Octroi_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_lbt_tax_amount, `LBT_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_mandi_tax_amount, `Mandi_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_other_tax_amount, `Other_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_service_tax_amount, `Service_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_gst_amount, `GST_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_additional_excise_tax_amount, `Additional_Excise_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_cust_sacd_tax_amount, `CUST_SACD_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_cust_cvd_tax_amount, `CUST_CVD_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_cust_basic_tax_amount, `CUST_Basic_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_insurance_tax_amount, `Insurance_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_green_field_cess_tax_amount, `Green_Field_Cess_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_adi_tax_amount, `ADI_Tax_Amount`, '2dp_' ),
		write_ibm_number_variable_as_tag( LID, line_additional_vat_tax_amount, `Additional_VAT_Tax_Amount`, '2dp_' ),

		write_ibm_number_variable_as_tag( LID, line_vat_amount, `Tax_Amount`, '2dp_' ),

		( result( _, LID, line_buyers_order_number, _ )
			->	write_variable_as_tag( LID, line_buyers_order_number, `PO_Number` )
			;	write_variable_as_tag( invoice, order_number, `PO_Number` )
		),

		write_variable_as_tag( LID, line_delivery_note_number, `Delivery_Note` ),

		write_ibm_number_variable_as_tag( LID, line_unit_amount, `Unit_Price`, '2dp_' ),

		write_variable_as_tag( LID, line_quantity_uom_code, `Unit_Of_Measure` ),

		write_ibm_number_variable_as_tag( LID, line_quantity, `Quantity`, '4dp_' ),

		write_variable_as_tag( LID, line_item, `MAT_NUMBER` ),

		write_variable_as_tag( LID, line_cost_centre, `CostCenter` ),
		write_variable_as_tag( LID, line_gl, `GLAccount` ),
		write_variable_as_tag( LID, line_descr, `Description` ),

	write_end_element
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_all_available_address_segments( VariableList, TagName, Count )
%-------------------------------------------------------------------------------
:- d1( write_all_available_address_segments___( VariableList, TagName, Count ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_all_available_address_segments___( _, _, `11` ):- !. % Should end at 11
%===============================================================================
write_all_available_address_segments___( [ ], TagName, Count )
%-------------------------------------------------------------------------------
:-
%===============================================================================
	write_available_address_values( [ null ], TagName, Count, CountOut ),
	write_all_available_address_segments___( [ ], TagName, CountOut )
.
%===============================================================================
write_all_available_address_segments___( [ H | T ], TagName, Count )
%-------------------------------------------------------------------------------
:-
%===============================================================================
	sys_findall( Value, result( _, invoice, H, Value ), Results ),

	( Results = [ ]
		->	write_all_available_address_segments___( T, TagName, Count )

		;	write_available_address_values( Results, TagName, Count, CountOut ),
			write_all_available_address_segments___( T, TagName, CountOut )
	)
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_available_address_values( ValueList, TagName, CountIn, CountOut )
%-------------------------------------------------------------------------------
:- d1( write_available_address_values___( ValueList, TagName, CountIn, CountOut ) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===============================================================================
write_available_address_values___( [ ], _, Count, Count ):- !.
%===============================================================================
write_available_address_values___( _, _, `11`, `11` ):- !. % Can't go beyond - catch anything that tries
%===============================================================================
write_available_address_values___( [ null | T ], TagName, CountIn, CountOut )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	strcat_list( [ TagName, CountIn ], FullTag ),
	write_start_element( FullTag ),
		write_string( `` ),
	write_end_element,

	sys_calculate_str_add( CountIn, `1`, CountNext ),
	write_available_address_values___( T, TagName, CountNext, CountOut )
.
%===============================================================================
write_available_address_values___( [ H | T ], TagName, CountIn, CountOut )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	strcat_list( [ TagName, CountIn ], FullTag ),
	write_element_string( FullTag, H ),

	sys_calculate_str_add( CountIn, `1`, CountNext ),
	write_available_address_values___( T, TagName, CountNext, CountOut )
.


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
	write_element_string( Tag, `1900-01-01` )
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

			write_element_string( Tag, DateS )

	;	write_element_string( Tag, `1900-01-01` )
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
