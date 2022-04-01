%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIH HER TECHNOLOGIES INC  - For Invoice with USD Value -  V# 9000183990
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_shih_her_usd, `28th March 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_buyer_tax

    %, set_credit_note

    , get_invoice_number
  
    , get_invoice_date

    , get_order_number

    , get_total_net_usd

    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `SHIH HER TECHNOLOGIES INC` )

   % Supplier VAT number -16044341 % 

   , supplier_registration_number(`FINANCIAL@SHT.COM.TW`)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( set_credit_note, [
%=======================================================================

     q(0,50,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule_cut( credit_note_line, [
%=======================================================================

     q0n(anything)

     , or([

       [dummy(date), tab, `-`, dummy(s), tab, `-` ]

    , [`-`, dummy(s), tab, `[`, `청구`, `]`,  newline ]

    ] )
    
    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER TAX DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_tax, [
%=======================================================================

     q(0,40,line)

     , check_text(`統一編號` )

     , or([

       generic_horizontal_details( [ [`統一編號`,  `:`], buyer_vat_number, d, tab ] )

     , generic_horizontal_details( [ [`統一編號`,  `:`], buyer_vat_number, d, newline ] )

     ] )
      

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,40,line)

     , check_text(`發票號碼` )

     , generic_horizontal_details( [ [`發票號碼`, `:` ], invoice_number, s1, gen_eof ] )
 

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,50,line)

     , check_text(`發票號碼` )

     , generic_vertical_details( [ [`發票號碼`, `:` ], `發票號碼`, q(0,1,up), (start,100,400), invoice_date, date, newline ] )
        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,50,line)

 , or( [

      find_order_number

   ])


] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)


, or( [
            [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_45) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44) ]
    ] )

 
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT USD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net_usd, [ without(total_net), 
%=======================================================================

    q0n(line)

   
  , or([
    
     generic_horizontal_details( [ [ `PO`, `.`, dummy(d),  `USD`, `$` ], total_net, d, [ `匯率`, generic_item( [ currency_exchange_rate, d ] ),  newline ] ] )

  ,  [set(regexp_allow_partial_matching)
  
  , generic_horizontal_details( [ [ `PO`, `.`, dummy(d),  `USD`, `$` ], total_net, d, [ `匯率`, generic_item( [ currency_exchange_rate, d ] ),  newline ] ] )
   
  , clear(regexp_allow_partial_matching) ]

  , generic_horizontal_details( [ [`PO`, `.`,dummy(d),  `USD`, `$` ], total_net, d, [  `匯率`, generic_item( [ currency_exchange_rate, d ] ),  newline ] ] )

  , generic_horizontal_details( [ [`PO`, `.`, dummy(d),  `USD`, `$` ], total_net, d, [ `匯率`,  newline ] ] )
 

  ] )
  
  , check( total_net = TotNet1)

  , generic_item( [ line_net_amount , TotNet1 ] )  

  , generic_item( [ buyer_tax_type, `VAT` ] )

  , generic_item( [ default_vat_rate, `5` ] )

  , generic_item( [ currency, `USD` ] )
  
	, check( sys_calculate_str_multiply( TotNet1, `1.05`, TotalGrossAmount ) )
  
	, total_invoice(TotalGrossAmount)
  
	, check( sys_calculate_str_multiply( TotNet1, `0.05`, TotalVatAmount ) )
   
	, line_vat_amout(TotalVatAmount)
   
	, total_vat(TotalVatAmount)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [
              
                 
                 line_invoice_line

              , [line_descr_line, line_invoice_line_1]
          
              , [line_descr_line ,line_invoice_line_3 ]

              , line_invoice_line_2

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [  `品`,  tab, `名`,  tab, `數`,  `量`,  tab ]


] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   or( [ [`銷`, tab, `售`, tab, `額`, tab ], check_text(`匯率`) ] )

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_descr, s1,tab ] )

  , generic_item( [ line_quantity, d,tab ] )

  , generic_item( [ line_unit_amount_dummy, d, tab ] )

  , generic_item( [ line_net_amount_dummy, d ] )

  , generic_item( [ line_dummy, s1, newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 
		
		[ test(order_number_45), general_count_rule_10 ]

		, [ test(order_number_44), general_count_rule_1 ]

	] )


] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr_dummy, d, tab ] )

  ,  generic_item( [ line_descr, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================



    generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )

  , generic_item( [ line_unit_amount_dummy, d , [tab, `$` ]] )

  , generic_item( [ line_net_amount_dummy, d, newline ] )

  ,q10( generic_item( [ line_vat_type, `VAT` ] )) % When tax is 5 %

  , or( [ 
		
		[ test(order_number_45), general_count_rule_10 ]

		, [ test(order_number_44), general_count_rule_1 ]

	] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================


     generic_item( [ line_quantity, d,tab ] )

  , generic_item( [ line_descr, s1, newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 
		
		[ test(order_number_45), general_count_rule_10 ]

		, [ test(order_number_44), general_count_rule_1 ]

	] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================

    generic_item( [ line_quantity , d , q10(tab) ] )
  
  , generic_item( [ line_quantity_uom_code, w , tab ] )

  , generic_item( [ line_unit_amount, d , [tab, `$`] ] )

  , generic_item( [ line_net_amount, d , newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 05 Oct, 2021
% Mapped by - Rohini 

% Merged  9000183990 and 9000171994 due to USD and NTD Currency

% Updated on   - 06 Jan, 2022
% Updated by   - Rohini
% Changes made - Line details updated


% Updated on   - 10 March, 2022
% Updated by   - Rohini
% Changes made - Freezed NTD value has this vendor needs only USD

% Updated on   - 15 March, 2022
% Updated by   - Rohini
% Changes made - USD Value mapped


% Updated on   - 28th March 2022
% Updated by   - Sushmitha
% Changes made - added line_invoice_line_3

% Updated on   - 
% Updated by   -
% Changes made - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
