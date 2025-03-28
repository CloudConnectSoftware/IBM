%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PINK GmbH Vakuumtechnik with amount WITHOUT reverse punctuations

% There are two mappings for two different amount
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_pink_gmbh_format, `2025-03-28 18:14:32` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_op_param( us_invoice, _, _, _, false).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail
    
    , set_credit_note

    , get_invoice_number

    , get_original_invoice_number

    , get_invoice_date

    , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_exchange_rate

    , get_currency

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

     sender_name( `PINK GMBH` ) % PINK GmbH Vakuumtechnik 


   % Supplier VAT number - DE146581368`   %

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

     q(0,20,line)

    , credit_note_line

    
] ).

%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

      q0n(anything)

    , or([

       [`Credit`,  `note`,  `no` ]

    , [`Rechnungskorrektur`, `Nr` ]

    ] )
    
    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

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

     , or([

       [test(credit_note), generic_horizontal_details( [ [`Credit`,  `note`,  `no`, `.`, `:` ], invoice_number, s1, newline ] )]

     ,  generic_horizontal_details( [ [ `Invoice`, `no`, `.`, `:`], invoice_number, s1, newline ] )

     , generic_horizontal_details( [ [`Rechnung`, `Nr`, `.`, `:` ], invoice_number, s1, newline ] )

     , generic_horizontal_details( [ [`Rechnungskorrektur`, `Nr`, `.`, `:` ], invoice_number, s1, newline ] )

] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIGINAL INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_original_invoice_number, [
%=======================================================================

     q(0,40,line)

     , or([

       [test(credit_note), generic_horizontal_details( [ [`Invoice`,  `no`, `.`, `:`,  tab ], original_invoice_number, s1, tab ] )]

] )

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

     , or([

      
       generic_vertical_details( [ [ `Rechnung`, `Nr`], `Rechnung` , q(0,1,up ), (start,900,900), invoice_date_raw,s1, newline ] ) 

     , generic_vertical_details( [ [`Credit`,  `note`,  `no` ], `Credit` , q(0,1,up ), (start,900,900), invoice_date_raw,s1, newline ] ) 

     , generic_vertical_details( [ [  `Invoice`, `no`, `.`, `:` ], `Invoice` , q(0,1,up ), (start,900,900), invoice_date_raw,s1, newline ] ) 

     , generic_vertical_details( [ [ `Rechnungskorrektur`, `Nr`], `Rechnungskorrektur` , q(0,1,up ), (start,900,900), invoice_date_raw, s1, newline ] )

] )

    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice Date Raw` , DateRaw ] )

    , check(string_string_replace( DateRaw, `.`, ` `, DateStrip ))

    , trace( [ `Date Stripped Coma` , DateStrip ] )

    , invoice_date(DateStrip)

    , trace( [ `Invoice Date` , invoice_date ] )

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

  %, check_text(`Bestell` )

  , or([

  %  generic_horizontal_details( [ [ `Bestell`, `Nr`, `.`, `:`, tab ], order_number, d, tab ] )


  % , generic_horizontal_details( [ [`Order`, `no`, `.`, `:`, tab ], order_number, d, tab ] )

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

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("2"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_42) ]
    ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    q0n(line)

  %, check_text(`Summe` )

  , or([

     generic_horizontal_details( [ [`Summe`, `netto`, tab ], total_net, d , [ `€`,  newline ] ] )
     
   , generic_horizontal_details( [ [ `amount`, `net`, tab  ], total_net, d , [ `€`,  newline ] ] )

   , generic_horizontal_details( [ [ `total`,  `amount`,  `net`,  tab ], total_net, d , [ `€`,  newline ] ] )

  ] )
  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

    q0n(line)

  , or([

     generic_horizontal_details( [ [ `USt`, generic_item( [ default_vat_rate, d ] ), `,`, `0`, `%`, tab ], total_vat, d , [ `€`,  newline ] ] )
  
  , generic_horizontal_details( [ [ `USt`, generic_item( [ default_vat_rate, d ] ), `,`, `00`, `%`, tab ], total_vat, d , [ `€`,  newline ] ] )

  , generic_horizontal_details( [ [ `STx`, `(`,  generic_item( [ default_vat_rate, d ] ), `.`, `00`, `%`, `)`,  tab ], total_vat, d , [ `€`,  newline ] ] )

  , generic_horizontal_details( [ [  `VAT`,  generic_item( [ default_vat_rate, d ] ),  `%`,  tab ], total_vat, d , [ `€`,  newline ] ] )


] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

    q0n(line)

  

  , or([

    generic_horizontal_details( [ [ `Summe`, `Brutto`, tab ], total_invoice, d , [ `€`,  newline ] ] )
  
  , generic_horizontal_details( [ [ `total`, `amount`, `gross`, tab ], total_invoice, d , [ `€`,  newline ] ] )

 ] )
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

      q0n(line)
    
    , invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

    q0n(anything)

    , [`€`,  newline  ]

    , currency( `EUR` ) 

    , trace( [ `currency found`] )

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
              
               [test(credit_note),line_credit_line , line_descr_line,q10(line_append_line)]

              , [test(credit_note),line_credit_line_1 , line_descr_line,q10(line_append_line)]

              , line_additional_line

              , [ line_invoice_line_1 , line_rebate_line ,line_append_line , line_amount_with_discount ]

              ,  [line_invoice_line, line_descr_line,q10(line_append_line)  ]


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [`USt`, `IdNr`, `.`, `:`, tab ]

      , [`Vat`, `no`, `.`, `:`, tab ]

      , [`VAT`,  `no`, `.`, `:`,  newline ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     or([

         [ `Warenwert`, `netto`, tab ]
         
       ,   [ `Original`, `Invoice`, `No`, `.`, tab ]

       , [ `total`,  `amount`,  `net`,  tab ]

    ] )
    
     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
    
     generic_item( [ line_buyers_dummy, d, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )
  
  , generic_item( [ line_item, s1, tab ] )

  , generic_item( [ line_unit_amount, d,q10(tab) ] )

  , generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_net_amount, d, [`€`,  newline ] ] )

    , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  , [ test(order_number_42), general_count_rule_10 ]

] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
 
   generic_item( [ line_buyers_dummy, d, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )
  
  , generic_item( [ line_item, s1, tab ] )

  , generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_net_amount_dummy, d, [`€`,  newline ] ] )

    , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  , [ test(order_number_42), general_count_rule_10 ]

] )
] ).


%=======================================================================
i_line_rule_cut( line_rebate_line, [
%=======================================================================
 

    generic_item( [ line_descr, s1 , [tab, `-`] ] )

  , generic_item( [ dummy_rebate, s1, tab ] )

  , generic_item( [ dummy_net, s1, newline ] )

 

] ).

%=======================================================================
i_line_rule_cut( line_amount_with_discount, [
%=======================================================================
 
     generic_item( [ line_net_amount, d , [`€`,  newline ] ] )


] ).
%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

     generic_item( [ line_descr, s1, newline ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================
     generic_item( [ line_buyers_dummmy, d, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )
  
  , generic_item( [ line_item, s1, [tab, `-` ] ] )

  , generic_item( [ line_unit_amount, d,q10(tab) ] )

  , generic_item( [ line_dummy, s1, [tab, `-` ] ] )

  , generic_item( [ line_net_amount, d, [`€`,  newline ] ] )

    , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  , [ test(order_number_42), general_count_rule_10 ]

] )
] ).

%=======================================================================
i_line_rule_cut( line_credit_line_1, [
%=======================================================================
   
      generic_item( [ line_buyers_dummmy, d, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )
  
  , generic_item( [ line_item, s1, [tab, `-` ] ] )

  , generic_item( [ line_unit_amount, d,[ `€`,  `/`] ] )

  , generic_item( [ line_dummy, s1, [tab, `-` ] ] )

  , generic_item( [ line_net_amount, d, [`€`,  newline ] ] )

    , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  , [ test(order_number_42), general_count_rule_10 ]

] )

] ).

%=======================================================================
i_line_rule_cut( line_additional_line, [
%=======================================================================


   q0n(anything) 

   , or([

       read_ahead([`Packaging`])

      , read_ahead([`Freight`])
 
   ])

   , generic_item( [ line_descr, s1, tab ] )
 
  , generic_item( [ line_net_amount, d, [ `€`,  newline ] ] )
     
  ,  generic_item( [ line_item, `FREIGHT` ] )

  ,  generic_item( [ line_type, `extra` ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 23 Sep, 2020
% Mapped by - Rohini 

% Updated on   - 14 Oct, 2020
% Updated by   - Rohini
% Changes made - English format Invoice mapped

% Updated on   - 27 Oct, 2020
% Updated by   - Rohini
% Changes made - Mapped Po Line item number to be captured based on PO series (as per email from Marcin -RE: [EXTERNAL] Re: PINK ,  22-10-2020 16:27 )


% Updated on   - 06 July, 2022
% Updated by   - Sushmitha
% Changes made - Added  line_invoice_line_1 , line_rebate_line ,line_append_line , line_amount_with_discount 

% Updated on   - 26 Sep,2023
% Updated by   - Sushmitha
% Changes made - Added line_additional_line & freezed get_total_net

% Updated on   - 11 Apr, 2024
% Updated by   - Rohini
% Changes made - Credit note format mapped

% Updated on   - 16 Apr, 2024
% Updated by   - Rohini
% Changes made - PO # format for 42 series mapped


% Updated on   - 09 Jan, 2025
% Updated by   - Rohini
% Changes made -  Total net an total vat updated

% Updated on   - 20 Jan, 2025
% Updated by   - Rohini
% Changes made -  Total vat updated

% Updated on   - 28 March,2025
% Updated by   - Rohini
% Changes made - Mappings updated for two different amount formats

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
