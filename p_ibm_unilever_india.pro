%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - PROCESS RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm_unilever_india, `12:32 18 October 2016` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_ibm_unilever_india.pro` ).
i_rules_file( `u_json_forms_beta.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` ).
i_rules_file( `u_date_validation.pro` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER FIELDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
%   Other User Fields
%-----------------------------------------------------------------------
i_user_field( invoice, barcode, `Barcode` ).
i_user_field( invoice, vendor_vat_code, `Vendor VAT Code` ).
i_user_field( invoice, vendor_cst_code, `Vendor CST Code` ).
i_user_field( invoice, vendor_service_tax_number, `Vendor Service Tax Number` ).
i_user_field( invoice, buyer_cst_code, `Buyer CST Code` ).
i_user_field( invoice, buyer_vat_tin_number, `Buyer VAT Tin Number` ).
i_user_field( invoice, vendor_vat_tin_number, `Vendor VAT Tin Number` ).
i_user_field( invoice, unilever_entity_name, `Unilever Entity Name` ).
i_user_field( invoice, total_in_words, `Total In Words` ).

i_user_field( line, line_cost_centre, `line_cost_centre` ).
i_user_field( line, line_gl, `line_gl` ).

%-----------------------------------------------------------------------
%   Required Tax Fields
%-----------------------------------------------------------------------
%   Header
%-----------------------------------------------------------------------
i_user_field( invoice, i_cess_tax_amount, `Cess_Tax_Amount` ).
i_user_field( invoice, i_excise_tax_amount, `Excise_Tax_Amount` ).
i_user_field( invoice, i_h_cess_tax_amount, `H_Cess_Tax_Amount` ).
i_user_field( invoice, i_vat_lst_tax_amount, `VAT_LST_Tax_Amount` ).
i_user_field( invoice, i_c_sales_tax_amount, `C_Sales_Tax_Amount` ).
i_user_field( invoice, i_wct_tax_amount, `WCT_Tax_Amount` ).
i_user_field( invoice, i_entry_tax_amount, `Entry_Tax_Amount` ).
i_user_field( invoice, i_freight_insurance_tax_amount, `Freight_Insurance_Tax_Amount` ).
i_user_field( invoice, i_discount_amount, `Discount_Amount` ).
i_user_field( invoice, i_luxury_tax_amount, `Luxury_Tax_Amount` ).
i_user_field( invoice, i_agri_tax_amount, `Agri_Tax_Amount` ).
i_user_field( invoice, i_octroi_tax_amount, `Octroi_Tax_Amount` ).
i_user_field( invoice, i_lbt_tax_amount, `LBT_Tax_Amount` ).
i_user_field( invoice, i_mandi_tax_amount, `Mandi_Tax_Amount` ).
i_user_field( invoice, i_other_tax_amount, `Other_Tax_Amount` ).
i_user_field( invoice, i_service_tax_amount, `Service_Tax_Amount` ).
i_user_field( invoice, i_gst_amount, `GST_Amount` ).
i_user_field( invoice, i_additional_excise_tax_amount, `Additional_Excise_Tax_Amount` ).
i_user_field( invoice, i_cust_sacd_tax_amount, `CUST_SACD_Tax_Amount` ).
i_user_field( invoice, i_cust_cvd_tax_amount, `CUST_CVD_Tax_Amount` ).
i_user_field( invoice, i_cust_basic_tax_amount, `CUST_Basic_Tax_Amount` ).
i_user_field( invoice, i_insurance_tax_amount, `Insurance_Tax_Amount` ).
i_user_field( invoice, i_green_field_cess_tax_amount, `Green_Field_Cess_Tax_Amount` ).
i_user_field( invoice, i_adi_tax_amount, `ADI_Tax_Amount` ).
i_user_field( invoice, i_additional_vat_tax_amount, `Additional_VAT_Tax_Amount` ).
%-----------------------------------------------------------------------
%   Line
%-----------------------------------------------------------------------
i_user_field( line, line_cess_tax_amount, `Cess_Tax_Amount` ).
i_user_field( line, line_excise_tax_amount, `Excise_Tax_Amount` ).
i_user_field( line, line_h_cess_tax_amount, `H_Cess_Tax_Amount` ).
i_user_field( line, line_vat_lst_tax_amount, `VAT_LST_Tax_Amount` ).
i_user_field( line, line_c_sales_tax_amount, `C_Sales_Tax_Amount` ).
i_user_field( line, line_wct_tax_amount, `WCT_Tax_Amount` ).
i_user_field( line, line_entry_tax_amount, `Entry_Tax_Amount` ).
i_user_field( line, line_freight_insurance_tax_amount, `Freight_Insurance_Tax_Amount` ).
i_user_field( line, line_discount_amount, `Discount_Amount` ).
i_user_field( line, line_luxury_tax_amount, `Luxury_Tax_Amount` ).
i_user_field( line, line_agri_tax_amount, `Agri_Tax_Amount` ).
i_user_field( line, line_octroi_tax_amount, `Octroi_Tax_Amount` ).
i_user_field( line, line_lbt_tax_amount, `LBT_Tax_Amount` ).
i_user_field( line, line_mandi_tax_amount, `Mandi_Tax_Amount` ).
i_user_field( line, line_other_tax_amount, `Other_Tax_Amount` ).
i_user_field( line, line_service_tax_amount, `Service_Tax_Amount` ).
i_user_field( line, line_gst_amount, `GST_Amount` ).
i_user_field( line, line_additional_excise_tax_amount, `Additional_Excise_Tax_Amount` ).
i_user_field( line, line_cust_sacd_tax_amount, `CUST_SACD_Tax_Amount` ).
i_user_field( line, line_cust_cvd_tax_amount, `CUST_CVD_Tax_Amount` ).
i_user_field( line, line_cust_basic_tax_amount, `CUST_Basic_Tax_Amount` ).
i_user_field( line, line_insurance_tax_amount, `Insurance_Tax_Amount` ).
i_user_field( line, line_green_field_cess_tax_amount, `Green_Field_Cess_Tax_Amount` ).
i_user_field( line, line_adi_tax_amount, `ADI_Tax_Amount` ).
i_user_field( line, line_additional_vat_tax_amount, `Additional_VAT_Tax_Amount` ).

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
i_op_param( customer_name, _, _, _, `Unilever Inida POC` ).

%-----------------------------------------------------------------------
% Customer Forward Address List
%-----------------------------------------------------------------------
% i_op_param( customer_forward_address_list, _, _, _, `` ).

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
% CALCULATE TOTAL VAT FROM ALL AVAILABLE TAX VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without( currency ), currency( `INR` )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CALCULATE TOTAL VAT FROM ALL AVAILABLE TAX VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without( total_vat )

    , or( [ with( invoice, i_cess_tax_amount, Cess_Tax_Amount ), check( Cess_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_excise_tax_amount, Excise_Tax_Amount ), check( Excise_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_h_cess_tax_amount, H_Cess_Tax_Amount ), check( H_Cess_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_vat_lst_tax_amount, VAT_LST_Tax_Amount ), check( VAT_LST_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_c_sales_tax_amount, C_Sales_Tax_Amount ), check( C_Sales_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_wct_tax_amount, WCT_Tax_Amount ), check( WCT_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_entry_tax_amount, Entry_Tax_Amount ), check( Entry_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_freight_insurance_tax_amount, Freight_Insurance_Tax_Amount ), check( Freight_Insurance_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_discount_amount, Discount_Amount ), check( Discount_Amount = `0` ) ] )
    , or( [ with( invoice, i_luxury_tax_amount, Luxury_Tax_Amount ), check( Luxury_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_agri_tax_amount, Agri_Tax_Amount ), check( Agri_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_octroi_tax_amount, Octroi_Tax_Amount ), check( Octroi_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_lbt_tax_amount, LBT_Tax_Amount ), check( LBT_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_mandi_tax_amount, Mandi_Tax_Amount ), check( Mandi_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_other_tax_amount, Other_Tax_Amount ), check( Other_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_service_tax_amount, Service_Tax_Amount ), check( Service_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_gst_amount, GST_Amount ), check( GST_Amount = `0` ) ] )
    , or( [ with( invoice, i_additional_excise_tax_amount, Additional_Excise_Tax_Amount ), check( Additional_Excise_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_cust_sacd_tax_amount, CUST_SACD_Tax_Amount ), check( CUST_SACD_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_cust_cvd_tax_amount, CUST_CVD_Tax_Amount ), check( CUST_CVD_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_cust_basic_tax_amount, CUST_Basic_Tax_Amount ), check( CUST_Basic_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_insurance_tax_amount, Insurance_Tax_Amount ), check( Insurance_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_green_field_cess_tax_amount, Green_Field_Cess_Tax_Amount ), check( Green_Field_Cess_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_adi_tax_amount, ADI_Tax_Amount ), check( ADI_Tax_Amount = `0` ) ] )
    , or( [ with( invoice, i_additional_vat_tax_amount, Additional_VAT_Tax_Amount ), check( Additional_VAT_Tax_Amount = `0` ) ] )

    , check(
        i_user_check( sum_string_list
            , [ Cess_Tax_Amount
				, Excise_Tax_Amount
                , H_Cess_Tax_Amount
                , VAT_LST_Tax_Amount
                , C_Sales_Tax_Amount
                , WCT_Tax_Amount
                , Entry_Tax_Amount
                , Freight_Insurance_Tax_Amount
                , Discount_Amount
                , Luxury_Tax_Amount
                , Agri_Tax_Amount
                , Octroi_Tax_Amount
                , LBT_Tax_Amount
                , Mandi_Tax_Amount
                , Other_Tax_Amount
                , Service_Tax_Amount
                , GST_Amount
                , Additional_Excise_Tax_Amount
                , CUST_SACD_Tax_Amount
                , CUST_CVD_Tax_Amount
                , CUST_Basic_Tax_Amount
                , Insurance_Tax_Amount
                , Green_Field_Cess_Tax_Amount
                , ADI_Tax_Amount
                , Additional_VAT_Tax_Amount
            ], TotalVAT
        )
    )
    , generic_item( [ total_vat, TotalVAT ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CALCULATE TOTAL INVOICE FROM VAT AND NET
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without( total_invoice )

	, with( invoice, total_net, Net )
	, with( invoice, total_vat, VAT )

	, check( sys_calculate_str_add( Net, VAT, Gross ) )

	, generic_item( [ total_invoice, Gross ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% COMPARE WRITTEN TOTAL TO TOTAL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	trace( [ `Analysing the total in words` ] )
	, with( invoice, total_in_words, TotalWords )
    , check( i_user_check( split_and_convert_words_into_numbers, TotalWords, Number ) )

    , or( [ [ with( invoice, total_invoice, Total )
   			, or( [ [ check( q_sys_comp_str_eq( Number, Total ) )
   		 			, trace( [ `Totals Match`, Total ] )
			   ]
			   , [ trace( [ `Totals don't equate`, Total, Number ] )
			   		, trace( [ `Words used`, TotalWords ] )
				]
			] )
		]
		, [ without( total_invoice )
			, trace( [ `No Total Invoice to compare` ] )
		]
	] )

] ).

%=======================================================================
i_user_check( split_and_convert_words_into_numbers, WordsIn, NumberOut )
%-----------------------------------------------------------------------
:-
    string_to_lower( WordsIn, WordsL ),
	string_string_replace( WordsL, `-`, ` `, WordsRep1 ),
	string_string_replace( WordsRep1, `(s)`, ``, WordsRep2 ),
    sys_string_split( WordsRep2, ` `, SplitWords ),
    take_the_words_and_spit_out_a_value( SplitWords, NumberOut ),
    trace( [ `Completed Number`, NumberOut ] ),
    !
.
%=======================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVOICE NUMBER CLEAN UP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_invoice_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, invoice_number, Invoice_Number ),

	sys_retractall( result( _, invoice, invoice_number, _ ) ),

	turn_specials_to_dashes( Invoice_Number, Invoice_Number_Final, [ ` `, `.`, `,`, `;`, `:`, `_`, `/`, `\\`, `*`, `(`, `)`, `[`, `]`, `{`, `}`, `#`, `~`, `@`, `'`, `?`, `>`, `<`, `&`, `^`, `%`, `$`, `�`, `�`, `"`, `!`, `�`, `|`, `+`, `=` ] ),

	assertz_derived_data( invoice, invoice_number, Invoice_Number_Final, i_analyse_invoice_number ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
turn_specials_to_dashes( String_in, String_out, [ H | T ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	string_string_replace( String_in, H, `-`, String_replaced ),
	(
		T = [ ] -> !, String_replaced = String_out
		;
		turn_specials_to_dashes( String_replaced, String_out, T )
	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% KIND ATTENTION TO CLEAN UP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_kind_attention_to___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_kind_attention_to___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_contact, Kind_Attention_To ),

	sys_retractall( result( _, invoice, buyer_contact, _ ) ),

	sys_string_length( Kind_Attention_To, Length ),

	(
		Length > 40,

		sys_calculate( Start_Pos, Length - 39 ),

		q_sys_sub_string( Kind_Attention_To, Start_Pos, _, Kind_Attention_To_Final )

		;

		Length =< 40,

		Kind_Attention_To = Kind_Attention_To_Final

	),

	assertz_derived_data( invoice, buyer_contact, Kind_Attention_To_Final, i_analyse_kind_attention_to ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UNILEVER ENTITY NAME VALIDATION & COMPANY CODE LOOKUP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_unilever_entity_name_and_company_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_unilever_entity_name_and_company_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, unilever_entity_name, Unilever_Entity_Name ),

	sys_retractall( result( _, invoice, unilever_entity_name, _ ) ),

	string_to_lower( Unilever_Entity_Name, Unilever_Entity_Name_L ),
	
	strip_string2_from_string1( Unilever_Entity_Name_L, ` \\|,<.>/?;:'@#~[{]}=+-_)(*&^%$£"!`, Unilever_Entity_Name_Test ),
	
	(
		unilever_entity_lookup( Name_From_Lookup, Company_Code ),

		string_to_lower( Name_From_Lookup, Name_From_Lookup_L ),
	
		strip_string2_from_string1( Name_From_Lookup_L, ` \\|,<.>/?;:'@#~[{]}=+-_)(*&^%$£"!`, Name_From_Lookup_Final ),
		
		Unilever_Entity_Name_Test = Name_From_Lookup_Final,

		assertz_derived_data( invoice, buyer_registration_number, Company_Code, i_analyse_company_code ),

		assertz_derived_data( invoice, unilever_entity_name, Unilever_Entity_Name, i_analyse_unilever_entity_name )

		;

		sys_assertz( grammar_set( i_analyse_unilever_entity_scenario ) ),

		trace( [ `Unilever Entity does not match one from lookup`, Unilever_Entity_Name ] )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUYER NAME LOOKUP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_name___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_name___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_party, Buyer_Party ),

	sys_retractall( result( _, invoice, buyer_party, _ ) ),

	string_to_lower( Buyer_Party, Buyer_Party_L ),

	(
		compare_the_factory_and_return_best_match( Buyer_Party_L, _, _ ),

		assertz_derived_data( invoice, buyer_party, Buyer_Party, i_analyse_buyer_party )

		;

		sys_assertz( grammar_set( i_analyse_unilever_factory_name_scenario ) ),

		trace( [ `Buyer party does not match one from lookup`, Buyer_Party ] )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BARCODE DERIVATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_barcode___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_barcode___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_party, Buyer_Party ),

	string_to_lower( Buyer_Party, Buyer_Party_L ),

	compare_the_factory_and_return_best_match( Buyer_Party_L, Business_Area_Code, P2P_Type ),

	date_get( today, date( Year_Raw, _, _ ) ),

	sys_string_number( Year, Year_Raw ),

	(
		(
			P2P_Type = `non_p2p`

			;

			P2P_Type = `p2p`,

			result( _, invoice, order_number, Order_Number ),

			q_regexp_match( `^DO.+$`, Order_Number, _ )

		),

		(
			result( _, invoice, currency, Currency ),

			Currency = `INR`,

			(
				result( _, invoice, order_number, Order_Number ),

				(
					not( q_regexp_match( `^7\\d{9}$`, Order_Number, _ ) ),

					(
						not( grammar_set( proforma_invoice ) ),

						result( _, invoice, buyer_registration_number, Company_Code ),

						(
							Company_Code \= `I`,

							result( _, invoice, buyers_code_for_supplier, BCFS ),

							(
								not( q_regexp_match( `^X.+$`, BCFS, _ ) ),

								(
									(
										not( q_regexp_match( `^B.+$`, Business_Area_Code, _ ) )

										;

										not( q_regexp_match( `^6(4|5|7)\\d{8}$`, Order_Number, _ ) )

									),

									(
										not( result( _, invoice, i_service_tax_amount, _ ),

										(
											not( result( _, invoice, i_c_sales_tax_amount, _ ) )

											;

											not( result( _, invoice, i_additional_vat_tax_amount, _ ) )

										),

										(
											not( result( _, invoice, i_additional_vat_tax_amount, _ ) ),

											(
												result( _, invoice, i_c_sales_tax_amount, _ ),

												Barcode_Type = `IC`,

												trace( [ `Barcode_Type (invoice with CST):`, Barcode_Type ] )

												;

												not( result( _, invoice, i_c_sales_tax_amount, _ ) ),

												trace( [ `Unable to determine barcoe type` ] ),

												fail

											)

											;

											result( _, invoice, i_additional_vat_tax_amount, _ ),

											Barcode_Type = `IV`,

											trace( [ `Barcode_Type (invoice with VAT):`, Barcode_Type ] )

										)

										;

										(
											result( _, invoice, i_service_tax_amount, _ )

											;

											result( _, invoice, i_c_sales_tax_amount, _ ),

											result( _, invoice, i_additional_vat_tax_amount, _ )

										),

										Barcode_Type = `IN`,

										trace( [ `Barcode_Type (non-subcon PO list):`, Barcode_Type ] )

									)

									;

									q_regexp_match( `^B.+$`, Business_Area_Code, _ ),

									q_regexp_match( `^6(4|5|7)\\d{8}$`, Order_Number, _ ),

									Barcode_Type = `AD`,

									trace( [ `Barcode_Type (for business area code and PO number format rule):`, Barcode_Type ] )

								)

								;

								q_regexp_match( `^X.+$`, BCFS, _ ),

								Barcode_Type = `PF`,

								trace( [ `Barcode_Type (for vendor code beginning with 'X'):`, Barcode_Type ] )

							)

							;

							Company_Code = `I`,

							Barcode_Type = `OF`,

							trace( [ `Barcode_Type (for Unilever India Exports Ltd.):`, Barcode_Type ] )

						)

						;

						grammar_set( proforma_invoice ),

						Barcode_Type = `AD`,

						trace( [ `Barcode_Type (for proforma invoice):`, Barcode_Type ] )

					)

					;

					q_regexp_match( `^7\\d{9}$`, Order_Number, _ ),

					Barcode_Type = `TF`,

					trace( [ `Barcode_Type (for 10 digit PO number beginning with '7'):`, Barcode_Type ] )

				)

				;

				not( result( _, invoice, order_number, _ ) ),

				Barcode_Type = `OH`,

				trace( [ `Barcode_Type (for missing PO number):`, Barcode_Type ] )

			)

			;

			Barcode_Type = `IM`,

			trace( [ `Barcode_Type (for foreign currency):`, Barcode_Type ] )

		),

		q_sys_sub_string( Year, 4, 1, Barcode_Year ),

		(
			i_mail( unique_id, ID )

			;

			instance( Inst ),

			string_to_lower( Inst, Inst_L ),

			q_sys_sub_string( Inst_L, _, _, `dbg` ),

			ID = 0001

		),

		sys_string_number( IDS, ID ),

		string_pad_left( IDS, 5, `0`, Serial_Number )

		;

		P2P_Type = `p2p`,

		(
			result( _, invoice, order_number, Order_Number ),

			not( q_regexp_match( `^DO.+$`, Order_Number, _ ) )

			;

			true

		),

		q_sys_sub_string( Year, 3, 2, Barcode_Type ),

		trace( [ `Barcode_Type (last two digits of year):`, Barcode_Type ] ),

		(
			i_mail( unique_id, ID )

			;

			instance( Inst ),

			string_to_lower( Inst, Inst_L ),

			q_sys_sub_string( Inst_L, _, _, `dbg` ),

			ID = 0001

		),

		sys_string_number( IDS, ID ),

		Barcode_Year = ``,

		string_pad_left( IDS, 6, `0`, Serial_Number )

	),

	strcat_list( [ Business_Area_Code, Barcode_Type, Barcode_Year, Serial_Number ], Barcode ),

	trace( [ `Derived barcode`, Barcode ] ),

	assertz_derived_data( invoice, barcode, Barcode, i_analyse_barcode ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK FOR OLD DATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_old_invoice_date___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_old_invoice_date___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, invoice_date, Invoice_Date ),
	i_mail( received_date, Date_Raw ),
	q_sys_sub_string( Date_Raw, 1, 2, M ),
	q_sys_sub_string( Date_Raw, 4, 2, D ),
	q_sys_sub_string( Date_Raw, 7, 4, Y ),
	strcat_list( [ D, `/`, M, `/`, Y ], Received_Date ),

	(
		i_date_format( Date_Format )

		;

		true

	),

	date_string( Date_Invoice, Date_Format, Invoice_Date ),
	sys_date_1900_days( Date_Invoice, Invoice_Date_Count ),

	date_string( Date_Tax_Point, _, Received_Date ),
	sys_date_1900_days( Date_Tax_Point, Received_Date_Count ),

	sys_calculate( Day_Diff, Received_Date_Count - Invoice_Date_Count ),

	Day_Diff > 365,

	sys_assertz( grammar_set( over_x_days_old ) ),

	trace( [ `Date is older than 365 days` ] ),

	!
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
% ORDER NUMBER VALIDATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_order_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_order_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		result( _, invoice, order_number, Order_Number ),

		sys_retractall( result( _, invoice, order_number, _ ) )

		;

		result( _, LID, line_buyers_order_number, Order_Number )

	),

	(
		i_user_check( gen_clean_and_extract_from_string, Order_Number, Order_Number_Final ),

		q_gratabase_lookup( `ibm unilever india po header file`,
			[ Order_Number_Final ],
			[ Order_Number_Final ],
			Available
		),

		(
			Available = false

			-> trace( [ `Unable to access ibm unilever india po header file table` ] ), fail

			;

			true

		),

		assertz_derived_data( invoice, order_number, Order_Number_Final, i_analyse_order_number )

		;

		trace( [ `Order number does not match one from lookup`, Order_Number ] )

	),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE VENDOR VAT CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_vendor_vat_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_vendor_vat_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, vendor_vat_code, Vendor_VAT_Code ),

	sys_retractall( result( _, invoice, vendor_vat_code, _ ) ),
	
	string_to_upper( Vendor_VAT_Code, Vendor_VAT_Code_U ),
	
	strip_string2_from_string1( Vendor_VAT_Code_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_VAT_Code_Final ),

	(
		result( _, invoice, buyers_code_for_supplier, Code ),
		
		vedor_vat_number_lookup( Code, Vendor_VAT_Code_Lookup ),
	
		string_to_upper( Vendor_VAT_Code, Vendor_VAT_Code_Lookup_U ),
	
		strip_string2_from_string1( Vendor_VAT_Code_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_VAT_Code_Lookup_Final ),
		
		Vendor_VAT_Code_Final = Vendor_VAT_Code_Lookup_Final,

		assertz_derived_data( invoice, vendor_vat_code, Vendor_VAT_Code_Final, i_analyse_vendor_vat_code )

		;

		trace( [ `Vendor VAT Code invalid`, Vendor_VAT_Code ] ),

		sys_assertz( grammar_set( i_analyse_vendor_vat_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE VENDOR SERVICE TAX NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_vendor_service_tax_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_vendor_service_tax_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, vendor_service_tax_number, Vendor_Service_Tax_Number ),

	sys_retractall( result( _, invoice, vendor_service_tax_number, _ ) ),
	
	string_to_upper( Vendor_Service_Tax_Number, Vendor_Service_Tax_Number_U ),
	
	strip_string2_from_string1( Vendor_Service_Tax_Number_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_Service_Tax_Number_Final ),

	(
		result( _, invoice, buyers_code_for_supplier, Code ),
		
		vedor_tax_lookup( Code, _, _, Vendor_Service_Tax_Number_Lookup ),
	
		string_to_upper( Vendor_Service_Tax_Number_Lookup, Vendor_Service_Tax_Number_Lookup_U ),
	
		strip_string2_from_string1( Vendor_Service_Tax_Number_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_Service_Tax_Number_Lookup_Final ),

		Vendor_Service_Tax_Number_Final = Vendor_Service_Tax_Number_Lookup_Final,

		assertz_derived_data( invoice, vendor_service_tax_number, Vendor_Service_Tax_Number_Final, i_analyse_vendor_service_tax_number )

		;

		trace( [ `Vendor Sevice Tax Number invalid`, Vendor_Service_Tax_Number ] ),

		sys_assertz( grammar_set( i_analyse_vendor_service_tax_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE VENDOR CST CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_vendor_cst_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_vendor_cst_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, vendor_cst_code, Vendor_CST_Code ),

	sys_retractall( result( _, invoice, vendor_cst_code, _ ) ),
	
	string_to_upper( Vendor_CST_Code, Vendor_CST_Code_U ),
	
	strip_string2_from_string1( Vendor_CST_Code_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_CST_Code_Final ),

	(
		result( _, invoice, buyers_code_for_supplier, Code ),
		
		vedor_tax_lookup( Code, Vendor_CST_Code_Lookup, _, _ ),

		string_to_upper( Vendor_CST_Code_Lookup, Vendor_CST_Code_Lookup_U ),
	
		strip_string2_from_string1( Vendor_CST_Code_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_CST_Code_Lookup_Final ),

		Vendor_CST_Code_Final = Vendor_CST_Code_Lookup_Final,
		
		assertz_derived_data( invoice, vendor_cst_code, Vendor_CST_Code_Final, i_analyse_vendor_cst_code )

		;

		trace( [ `Vendor CST Code invalid`, Vendor_CST_Code ] ),

		sys_assertz( grammar_set( i_analyse_vendor_cst_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE VENDOR VAT TIN NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_vat_tin_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_vat_tin_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, vendor_vat_tin_number, Vendor_VAT_Tin_Number ),

	sys_retractall( result( _, invoice, vendor_vat_tin_number, _ ) ),
	
	string_to_upper( Vendor_VAT_Tin_Number, Vendor_VAT_Tin_Number_U ),
	
	strip_string2_from_string1( Vendor_VAT_Tin_Number_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_VAT_Tin_Number_Final ),

	(
		result( _, invoice, buyers_code_for_supplier, Code ),
		
		vedor_tax_lookup( Code, _, Vendor_VAT_Tin_Number_Lookup, _ ),

		string_to_upper( Vendor_VAT_Tin_Number_Lookup, Vendor_VAT_Tin_Number_Lookup_U ),
	
		strip_string2_from_string1( Vendor_VAT_Tin_Number_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Vendor_VAT_Tin_Number_Lookup_Final ),

		Vendor_VAT_Tin_Number_Final = Vendor_VAT_Tin_Number_Lookup_Final,

		assertz_derived_data( invoice, vendor_vat_tin_number, Vendor_VAT_Tin_Number_Final, i_analyse_vendor_vat_tin_number )

		;

		trace( [ `Vendor VAT Tin Number invalid`, Vendor_VAT_Tin_Number ] ),

		sys_assertz( grammar_set( i_analyse_vendor_vat_tin_number_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE BUYER CST NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_cst_code___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_cst_code___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_cst_code, Buyer_CST_Code ),

	sys_retractall( result( _, invoice, buyer_cst_code, _ ) ),
	
	string_to_upper( Buyer_CST_Code, Buyer_CST_Code_U ),
	
	strip_string2_from_string1( Buyer_CST_Code_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Buyer_CST_Code_Final ),

	(
		result( _, invoice, buyer_party, Party ),
		
		string_to_upper( Party, Party_U ),

		compare_the_factory_and_return_best_match( Party_U, Code, _ ),

		buyer_tax_lookup( Code, Buyer_CST_Code_Lookup, _ ),

		string_to_upper( Buyer_CST_Code_Lookup, Buyer_CST_Code_Lookup_U ),
	
		strip_string2_from_string1( Buyer_CST_Code_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Buyer_CST_Code_Lookup_Final ),

		Buyer_CST_Code_Final = Buyer_CST_Code_Lookup_Final,
		
		assertz_derived_data( invoice, buyer_cst_code, Buyer_CST_Code_Final, i_analyse_buyer_cst_code )

		;

		trace( [ `Buyer CST Code invalid`, Buyer_CST_Code ] ),

		sys_assertz( grammar_set( i_analyse_buyer_cst_code_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE BUYER VAT TIN NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_buyer_vat_tin_number___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_buyer_vat_tin_number___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_vat_tin_number, Buyer_VAT_Tin_Number ),

	sys_retractall( result( _, invoice, buyer_vat_tin_number, _ ) ),
	
	string_to_upper( Buyer_VAT_Tin_Number, Buyer_VAT_Tin_Number_U ),
	
	strip_string2_from_string1( Buyer_VAT_Tin_Number_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Buyer_VAT_Tin_Number_Final ),

	(
		result( _, invoice, buyer_party, Party ),
		
		string_to_upper( Party, Party_U ),

		compare_the_factory_and_return_best_match( Party_U, Code, _ ),

		buyer_tax_lookup( Code, _, Buyer_VAT_Tin_Number_Lookup ),

		string_to_upper( Buyer_VAT_Tin_Number_Lookup, Buyer_VAT_Tin_Number_Lookup_U ),
	
		strip_string2_from_string1( Buyer_VAT_Tin_Number_Lookup_U, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Buyer_VAT_Tin_Number_Lookup_Final ),

		Buyer_VAT_Tin_Number_Final = Buyer_VAT_Tin_Number_Lookup_Final,

		assertz_derived_data( invoice, buyer_vat_tin_number, Buyer_VAT_Tin_Number_Final, i_analyse_buyer_vat_tin_number )

		;

		trace( [ `Buyer VAT Tin Number invalid`, Buyer_VAT_Tin_Number ] ),

		sys_assertz( grammar_set( i_analyse_buyer_vat_tin_number_scenario ) )

	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT LINE NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, LID, line_order_line_number, _ ) ),

	sys_string_number( LID_String, LID ),

	assertz_derived_data( LID, line_order_line_number, LID_String, i_analyse_line_number ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT LINE PO NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_buyers_order_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_buyers_order_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, LID, line_buyers_order_number, _ ) ),

	result( _, invoice, order_number, Order_Number ),

	assertz_derived_data( LID, line_buyers_order_number, Order_Number, i_analyse_line_buyers_order_number ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% STRIP SPECIAL CHARACTERS FROM LINE DELIVERY NOTE NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_delivery_note_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_delivery_note_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, LID, line_delivery_note_number, Line_Delivery_Note_Number ),
	
	sys_retractall( result( _, LID, line_delivery_note_number, _ ) ),
	
	turn_specials_to_dashes( Line_Delivery_Note_Number, Line_Delivery_Note_Number_Stripped, [ ` `, `.`, `,`, `;`, `:`, `_`, `/`, `\\`, `*`, `(`, `)`, `[`, `]`, `{`, `}`, `#`, `~`, `@`, `'`, `?`, `>`, `<`, `&`, `^`, `%`, `$`, `�`, `�`, `"`, `!`, `�`, `|`, `+`, `=` ] ),
	
	assertz_derived_data( LID, line_delivery_note_number, Line_Delivery_Note_Number_Stripped, i_analyse_line_delivery_note_number ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT LINE DELIVERY NOTE NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_missing_line_delivery_note_number___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_missing_line_delivery_note_number___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, LID, line_delivery_note_number, _ ) ),

	result( _, invoice, invoice_number, Invoice_Number ),

	assertz_derived_data( LID, line_delivery_note_number, Invoice_Number, i_analyse_line_delivery_note_number ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT LINE TAX AMOUNTS FOR SINGLE LINE INVOICE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_analyse_line_tax_amounts___( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_tax_amounts___( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, 2, _, _ ) ),

	insert_header_taxes_into_line_level( LID, [
		( total_vat, line_vat_amount ),
		( i_cess_tax_amount, line_cess_tax_amount ),
		( i_excise_tax_amount, line_excise_tax_amount ),
		( i_h_cess_tax_amount, line_h_cess_tax_amount ),
		( i_vat_lst_tax_amount, line_vat_lst_tax_amount ),
		( i_c_sales_tax_amount, line_c_sales_tax_amount ),
		( i_wct_tax_amount, line_wct_tax_amount ),
		( i_entry_tax_amount, line_entry_tax_amount ),
		( i_freight_insurance_tax_amount, line_freight_insurance_tax_amount ),
		( i_discount_amount, line_discount_amount ),
		( i_luxury_tax_amount, line_luxury_tax_amount ),
		( i_agri_tax_amount, line_agri_tax_amount ),
		( i_octroi_tax_amount, line_octroi_tax_amount ),
		( i_lbt_tax_amount, line_lbt_tax_amount ),
		( i_mandi_tax_amount, line_mandi_tax_amount ),
		( i_other_tax_amount, line_other_tax_amount ),
		( i_service_tax_amount, line_service_tax_amount ),
		( i_gst_amount, line_gst_amount ),
		( i_additional_excise_tax_amount, line_additional_excise_tax_amount ),
		( i_cust_sacd_tax_amount, line_cust_sacd_tax_amount ),
		( i_cust_cvd_tax_amount, line_cust_cvd_tax_amount ),
		( i_cust_basic_tax_amount, line_cust_basic_tax_amount ),
		( i_insurance_tax_amount, line_insurance_tax_amount ),
		( i_green_field_cess_tax_amount, line_green_field_cess_tax_amount ),
		( i_adi_tax_amount, line_adi_tax_amount ),
		( i_additional_vat_tax_amount, line_additional_vat_tax_amount )
	] ),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
insert_header_taxes_into_line_level( LID, [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
insert_header_taxes_into_line_level( LID, [ ( Header_Tax_Variable, Line_Tax_Variable ) | Remaining_Taxes ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	not( result( _, LID, Line_Tax_Variable, _ ) ),

	result( _, invoice, Header_Tax_Variable, Header_Tax_Value ),

	assertz_derived_data( LID, Line_Tax_Variable, Header_Tax_Value, i_analyse_line_tax_amount )

	-> insert_header_taxes_into_line_level( LID, Remaining_Taxes )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DUPLICATE INVOICE ANALYSIS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_duplicate_invoice.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_duplicate_invoice
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( receive_type, `imap` ),

	instance( Inst ),

	string_to_upper( Inst, INST ),

	not( q_sys_sub_string( INST, _, _, `DBG` ) ),

	create_basic_invoice_table_if_necessary,

	grammar_set( table_exists ),

	(
		result( _, invoice, buyers_code_for_supplier, BCFS ),

		result( _, invoice, invoice_number, Invoice_Number ),

		result( _, invoice, date, Invoice_Date_Raw ),

		string_date( Invoice_Date, Invoice_Date_Raw ),

		i_mail( file, FILE ),

		(
			q_gratabase_lookup_one( `ibm_unilever_india_invoice_table`, [ `general`, BCFS, Invoice_Number, _, _ ], [ _, _, _, DATE_LOOKUP, ORIGINAL ], Available ),

			trace( Available )

			-> ( q_sys_comp( Available = false )

				-> trace( [ `basic_invoice check, database disappeared` ] )

				;

				(
					q_allow_duplicate_emails
					, strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, FILE ], Alert )
					, alert( Alert, 0, `hours` )

					;

					FILE = ORIGINAL,
					trace( [ `ALERT: Duplicate file - Duplicate Processed` ] )

					;

					%	To compare dates regardless of format - needs to be adjusted if US dates are used
					date_string( DATE_LOOKUP_RAW, _, DATE_LOOKUP ),
					date_compare( Invoice_Date_Raw, =, DATE_LOOKUP_RAW ),

					wordcat( [ `Duplicate invoice rejected:`, BCFS, Invoice_Number, Invoice_Date ], E_MSG ),

					sys_assertz( grammar_set( i_analyse_duplicate ) ),

					trace( E_MSG )

				)

			)

			;

			sys_assertz( i_user_data( new_invoice_detected, BCFS, Invoice_Number, Invoice_Date, FILE ) )

		)

 		;

		trace( [ `analyse for duplicate fields ignored because of lack of fields: ` ] ),

		( result( _, invoice, buyers_code_for_supplier, _ ) ; trace( [ `missing buyers_code_for_supplier` ] ) ),

		( result( _, invoice, invoice_number, _ ) ; trace( [ `missing invoice_number` ] ) ),

		( result( _, invoice, date, _ ) ; trace( [ `missing date` ] ) ),

		( i_mail( file, _ ) ; trace( [ `missing file name` ] ) )

	),

	!
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_basic_invoice_table_if_necessary
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		q_gratabase_check_table_exists( `ibm_unilever_india_invoice_table`, Available )

		-> (
			q_sys_comp( Available = false )
			->	trace( [ `Cannot access database` ] )

			;

			true, trace( `Table exists` ), sys_assertz( grammar_set( table_exists ) )
		)

		;

		% fail, % Don't want this to EVER happen

		(
			q_gratabase_create_table( 5, GUID )

			-> (
				q_gratabase_allocate( GUID, `ibm_unilever_india_invoice_table` ),

				trace( `Created and allocated table` ),

				sys_assertz( grammar_set( table_exists ) )

				;

				trace( [ `failed to allocate on creation basic_invoice table` ] )
			)

			;

			trace( [ `failed to create basic_invoice table` ] )

		)

	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_final_process( Enq )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	i_user_data( new_invoice_detected, BCFS, Invoice_Number, Invoice_Date, FILE ),

	(
		Enq = true
		->	trace( [ `Document destined for enquire, not written to database` ] )

		;

		(
			process_status( defect, _, E_MSG )

			;

			result( _, invoice, force_result, `defect` )

		)

		-> trace( [ `Document has defected, not written to database` ] )

		;

		(
			process_status( failed, _, E_MSG )

			;

			result( _, invoice, force_result, `failed` )

		)

		-> trace( [ `Document has failed, not written to database` ] )

		;

		Enq = false,
		add_to_basic_invoice_table( BCFS, Invoice_Number, Invoice_Date, FILE ),
		trace( [ `Document processed - Database populated`, BCFS, Invoice_Number, Invoice_Date, FILE ] )
	)
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
add_to_basic_invoice_table( BCFS, Invoice_Number, Invoice_Date, FILE )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	(
		q_gratabase_clone_table( `ibm_unilever_india_invoice_table`, GUID )

		-> (
			q_gratabase_add( GUID, [ `general`, BCFS, Invoice_Number, Invoice_Date, FILE ] )

			->	trace( [ `added`, BCFS, Invoice_Number, Invoice_Date, FILE , `to basic_invoice table` ] ),

			( q_gratabase_allocate( GUID, `ibm_unilever_india_invoice_table` ) ; trace( [ `failed to allocate basic_invoice table` ] ) )

			;

			trace( [ `failed to add row to basic_invoice table` ] )

		)

		;

		trace( [ `failed to clone basic_invoice table` ] )

	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PREDICATES AND LOOKUPS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% PO Number Mandatory Condition
%-----------------------------------------------------------------------
po_number_mandatory_condition
:-
	result( _, invoice, buyer_party, Buyer_Party ),
	
	string_to_lower( Buyer_Party, Buyer_Party_L ),

	compare_the_factory_and_return_best_match( Buyer_Party_L, _, P2P_Type ),
	P2P_Type = `p2p`,
	
	result( _, invoice, buyers_code_for_supplier, Code ),

	result( _, invoice, currency, Currency ),

	(
		not( npnp_vendor( Code ) ),

		(
			Currency = `INR`,

			result( _, invoice, total_invoice, Total ),

			q_sys_comp_str_gt( Total, `10000` )

			;

			Currency \= `INR`

		)

		;

		Currency = `INR`,

		result( _, invoice, total_invoice, Total ),

		q_sys_comp_str_le( Total, `10000` ),

		not( result( _, invoice, buyer_contact, _ ) )

	)
.

%-----------------------------------------------------------------------
% Kind Attention To Scenario
%-----------------------------------------------------------------------
kind_attention_to_scenario
:-
	result( _, invoice, buyers_code_for_supplier, Code ),

	not( npnp_vendor( Code ) ),

	result( _, invoice, currency, Currency ),

	Currency = `INR`,

	result( _, invoice, total_invoice, Total ),

	q_sys_comp_str_le( Total, `10000` ),

	not( result( _, invoice, buyer_contact, _ ) )
.

%-----------------------------------------------------------------------
% NPNP Vendor
%-----------------------------------------------------------------------
npnp_vendor( Code )
:-
	q_gratabase_lookup( `ibm unilever india npnp list`,
		[ _, _, _, Code, _, _, _, _, _, _, _, _, _, _ ],
		[ _, _, _, Code, _, _, _, _, _, _, _, _, _, _ ],
		Available
	),

	(
		Available = false

		-> trace( [ `Unable to access ibm unilever india npnp list table` ] ), fail

		;

		true

	)
.

%-----------------------------------------------------------------------
% Words to number conversion predicates
%-----------------------------------------------------------------------

%=======================================================================
take_the_words_and_spit_out_a_value( ListIn, NumberOut )
%-----------------------------------------------------------------------
:-
    take_the_words_and_spit_out_a_value( ListIn, `0`, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ ], NumberOut, NumberOut ):- !.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_skippable_word( H1 ),

    ( i_debug_analysis
        ->  trace( [ `First Element is Skippable`, H1 ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberIn, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2, H3, H4, H5 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number( H1, H1Num ),
    is_a_known_number_modifier( H2, H2Mod ),
    is_a_known_number_with_unit_spaces( H3, H3Num ),
    is_a_known_number( H4, H4Num ),
	is_a_known_significant_number_modifier( H5, H5Mod ),
	q_sys_comp_str_lt( H2Mod, H5Mod ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Number`, H1, H1Num ] ),
            trace( [ `Second Element Known Modifier`, H2, H2Mod ] ),
            trace( [ `Third Element Known Number With Unit`, H3, H3Num ] ),
            trace( [ `Fourth Element Known Number`, H4, H4Num ] ),
			trace( [ `Fifth Element Known Modifier`, H5, H5Mod ] )

        ;   true
    ),

	sys_calculate_str_multiply( H1Num, H2Mod, H12Mul ),
    sys_calculate_str_add( H3Num, H4Num, H34Add ),
	sys_calculate_str_add( H12Mul, H34Add, H1234Add ),
    sys_calculate_str_multiply( H1234Add, H5Mod, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2, H3, H4 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number( H1, H1Num ),
    is_a_known_number_modifier( H2, H2Mod ),
    is_a_known_number( H3, H3Num ),
	is_a_known_significant_number_modifier( H4, H4Mod ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Number With Unit`, H1, H1Num ] ),
            trace( [ `Second Element Known Modifier`, H2, H2Mod ] ),
            trace( [ `Third Element Known Number`, H3, H3Num ] ),
			trace( [ `Fourth Element Known Modifier`, H4, H4Mod ] )

        ;   true
    ),

	sys_calculate_str_multiply( H1Num, H2Mod, H12Mul ),
    sys_calculate_str_add( H12Mul, H3Num, M123Add ),
    sys_calculate_str_multiply( H123Add, H4Mod, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2, H3 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number_with_unit_spaces( H1, H1Num ),
    is_a_known_number( H2, H2Num ),
    is_a_known_number_modifier( H3, H3Mod ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Number With Unit`, H1, H1Num ] ),
            trace( [ `Second Element Known Number`, H2, H2Num ] ),
            trace( [ `Third Element Known Modifier`, H3, H3Mod ] )
        ;   true
    ),

    sys_calculate_str_add( H1Num, H2Num, H12Add ),
    sys_calculate_str_multiply( H12Add, H3Mod, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number_with_unit_spaces( H1, H1Num ),
    is_a_known_number_modifier( H2, H2Mod ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Number`, H1, H1Num ] ),
            trace( [ `Second Element Known Modifier`, H2, H2Mod ] )
        ;   true
    ),

    sys_calculate_str_multiply( H1Num, H2Mod, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number( H1, H1Num ),
    is_a_known_number_modifier( H2, H2Mod ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Number`, H1, H1Num ] ),
            trace( [ `Second Element Known Modifier`, H2, H2Mod ] )
        ;   true
    ),

    sys_calculate_str_multiply( H1Num, H2Mod, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2, H3 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number_modifier_appears_in_reverse( H1, H1Mod ),
	is_a_known_number_with_unit_spaces( H2, H2Num ),
    is_a_known_number( H3, H3Num ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Modifier - Appearing in Reverse`, H1, H1Mod ] ),
            trace( [ `Second Element Known Number with Unit Spaces`, H2, H2Num ] ),
            trace( [ `Third Element Known Number`, H3, H3Num ] )
        ;   true
    ),

	sys_calculate_str_add( H2Num, H3Num, H12Add ),
    sys_calculate_str_multiply( H1Mod, H12Add, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1, H2 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number_modifier_appears_in_reverse( H1, H1Mod ),
    is_a_known_number( H2, H2Num ),

    ( i_debug_analysis
        ->  trace( [ `First Element Known Modifier - Appearing in Reverse`, H1, H1Mod ] ),
            trace( [ `Second Element Known Number`, H2, H2Num ] )
        ;   true
    ),

    sys_calculate_str_multiply( H1Mod, H2Num, HModified ),
    sys_calculate_str_add( NumberIn, HModified, NumberNext ),

    ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    is_a_known_number( H1, FoundNumber ),

	( i_debug_analysis
        ->  trace( [ `Single Element Analysis - Number`, FoundNumber ] )
        ;   true
    ),

    sys_calculate_str_add( NumberIn, FoundNumber, NumberNext ),

     ( i_debug_analysis
        ->  trace( [ `Next Number to Use`, NumberNext ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberNext, NumberOut )
.
%=======================================================================
take_the_words_and_spit_out_a_value( [ H1 | T ], NumberIn, NumberOut )
%-----------------------------------------------------------------------
:-
    ( i_debug_analysis
        ->  trace( [ `First Element is Unknown`, H1 ] )
        ;   true
    ),

    take_the_words_and_spit_out_a_value( T, NumberIn, NumberOut )
.
%=======================================================================

% Conversion Lookups
%-----------------------------------------------------------------------
is_a_known_number( `one`, `1` ).
is_a_known_number( `two`, `2` ).
is_a_known_number( `three`, `3` ).
is_a_known_number( `four`, `4` ).
is_a_known_number( `five`, `5` ).
is_a_known_number( `six`, `6` ).
is_a_known_number( `seven`, `7` ).
is_a_known_number( `eight`, `8` ).
is_a_known_number( `nine`, `9` ).
is_a_known_number( `ten`, `10` ).
is_a_known_number( `eleven`, `11` ).
is_a_known_number( `twelve`, `12` ).
is_a_known_number( `thirteen`, `13` ).
is_a_known_number( `fourteen`, `14` ).
is_a_known_number( `fifteen`, `15` ).
is_a_known_number( `sixteen`, `16` ).
is_a_known_number( `seventeen`, `17` ).
is_a_known_number( `eighteen`, `18` ).
is_a_known_number( `nineteen`, `19` ).
is_a_known_number( `twenty`, `20` ).
is_a_known_number( `thirty`, `30` ).
is_a_known_number( `forty`, `40` ).
is_a_known_number( `fifty`, `50` ).
is_a_known_number( `sixty`, `60` ).
is_a_known_number( `seventy`, `70` ).
is_a_known_number( `eighty`, `80` ).
is_a_known_number( `ninty`, `90` ).
is_a_known_number( `ninety`, `90` ).
%-----------------------------------------------------------------------
is_a_known_number_with_unit_spaces( `twenty`, `20` ).
is_a_known_number_with_unit_spaces( `thirty`, `30` ).
is_a_known_number_with_unit_spaces( `forty`, `40` ).
is_a_known_number_with_unit_spaces( `fifty`, `50` ).
is_a_known_number_with_unit_spaces( `sixty`, `60` ).
is_a_known_number_with_unit_spaces( `seventy`, `70` ).
is_a_known_number_with_unit_spaces( `eighty`, `80` ).
is_a_known_number_with_unit_spaces( `ninety`, `90` ).
%-----------------------------------------------------------------------
is_a_known_number_modifier( `hundred`, `100` ).
is_a_known_number_modifier( `thousand`, `1000` ).
is_a_known_number_modifier( `lakh`, `100000` ).
is_a_known_number_modifier( `million`, `1000000` ).
is_a_known_number_modifier( `crore`, `10000000` ).
is_a_known_number_modifier( `paise`, `0.01` ).
%-----------------------------------------------------------------------
is_a_known_number_modifier_appears_in_reverse( `paise`, `0.01` ).
%-----------------------------------------------------------------------
is_a_known_significant_number_modifier( `thousand`, `1000` ).
is_a_known_significant_number_modifier( `lakh`, `100000` ).
is_a_known_significant_number_modifier( `million`, `1000000` ).
is_a_known_significant_number_modifier( `crore`, `10000000` ).
%-----------------------------------------------------------------------
is_a_skippable_word( `rupee` ).
is_a_skippable_word( `rupees` ).
is_a_skippable_word( `indian` ).
is_a_skippable_word( `only` ).
is_a_skippable_word( `and` ).
%-----------------------------------------------------------------------

%=======================================================================
compare_the_factory_and_return_best_match( _, Business_Area_Code, P2P_Type )
%-----------------------------------------------------------------------
:-
	i_user_data( factory_data( Business_Area_Code, P2P_Type ) )
.
%=======================================================================
%=======================================================================
compare_the_factory_and_return_best_match( Buyer_Party_In, Business_Area_Code, P2P_Type )
%-----------------------------------------------------------------------
:-
	not( i_user_data( factory_data( _, _ ) ) ),
	string_to_lower( Buyer_Party_In, Buyer_Party_In_L ),
	sys_string_tokens( Buyer_Party_In_L, Buyer_Party_In_Split ),

	(
		strip_string2_from_string1( Buyer_Party_In_L, ` ~,<.>/?;:'"\\|]}[{=+-_)(*&^%$£@!`, Buyer_Party_Stripped ),
		
		business_area_factory_name_lookup( Business_Area_Code, Buyer_Party_Lookup, P2P_Type, _ ),
		string_to_lower( Buyer_Party_Lookup, Buyer_Party_Lookup_L ),
		strip_string2_from_string1( Buyer_Party_Lookup_L, ` \\|,<.>/?;:'@#~[{]}=+-_)(*&^%$£"!`, Buyer_Party_Lookup_Test ),
		Buyer_Party_Stripped = Buyer_Party_Lookup_Test
		->	trace( [ `Exact Match Found` ] )

		;	business_area_factory_name_lookup( _, _, _, Keyword ),
			q_sys_member( Keyword, Buyer_Party_In_Split )
			->
				sys_findall( 
					( Address_To_Compare, Business_Area_Code_Raw, P2P_Type_Raw ),
					(
						business_area_factory_name_lookup( Business_Area_Code_Raw, Address_To_Compare_Raw, P2P_Type_Raw, Keyword ),
						sys_string_tokens( Address_To_Compare_Raw, Address_To_Compare )
					),
					Matches
				),
	
				( Matches = [ ( _, Business_Area_Code, P2P_Type ) ] 
					->	trace( [ `Only one hit in the table` ] ),
						trace( [ Business_Area_Code, `Chosen based off of keyword -`, Keyword ] ) 
					
					;	trace( [ `Matches`, Matches ] ),
						Matches = [ FirstMatch | _ ],
						trace( [ `FirstMatch`, FirstMatch ] ),
						factory_best_match( Buyer_Party_In_L, Matches, Business_Area_Code, P2P_Type ) 
				)

	),

	sys_assertz( i_user_data( factory_data( Business_Area_Code, P2P_Type ) ) ),
	! % Don't want it retracting - too much variation Available
.
%=======================================================================

%===============================================================================
factory_best_match( Address, Matches, Best_Match, P2P_Type )
%-------------------------------------------------------------------------------
:-

	sys_string_tokens( Address, AT1 ),

	%	Generic Words to skip
	best_address_match_ignore_words( IW ),
	compare_lists( AT1, IW, AT ),

	%	Stored to carry through
	sys_asserta( i_user_data( factory_best_fit_pattern( AT ) ) ),

	transform_list( factory_best_match_fit_analysis, Matches, Analysed_matches ),

	%	Removed in case another lookup is performed
	sys_retractall( i_user_data( factory_best_fit_pattern( AT ) ) ),

	sys_sort( Analysed_matches, [ ( Match_Score, Best_Match, P2P_Type, Final_Address ) | _ ] ),
	trace( [ `List of Matches`, Analysed_matches ] ),
	trace( [ `Chosen Match: `, Best_Match, `- With score: `, Match_Score ] )
.
%===============================================================================

best_address_match_ignore_words( [ `,`, `.`, `street`, `road` ] ).

%===============================================================================
factory_best_match_fit_analysis( ( In, In_code, P2P ), ( Match_Score, In_code, P2P, Out ) )
%-------------------------------------------------------------------------------
:-

	i_user_data( factory_best_fit_pattern( AT ) ),

	best_address_match_ignore_words( IW ),	%	Unreasonable to remove them from lookup
	compare_lists( In, IW, In_x ),			%	and not the address on the doc

	compare_lists( AT, In_x, Left ),
	compare_lists( In_x, AT, Remainder ),

	length( Left, Result ),
	length( Remainder, Rem_Result ),	%	Need to know what is left

	sys_calculate( Result_Coefficient, 10 * Result ),	%	Worse to miss a token
	sys_calculate( Match_Score, Result_Coefficient + Rem_Result ),	%	Than to have excess in the string

	sys_stringlist_concat( In, ` `, Out ),
	trace( match( Match_Score ) )	%	Perfect match will score zero
.
%===============================================================================