%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CRYTUR, SPOL. S R.O.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(training_amat_crytur, `24 Aug, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , set_credit_note

    , get_invoice_number

    , get_original_invoice_number
    
    , get_shipto_details

    , get_invoice_date

    , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

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

     sender_name( `CRYTUR, SPOL. S R.O.` )


   % Supplier VAT number - CZ25296558`   %

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

    , [ `Credit`, `note` ]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_shipto_details, [
%=======================================================================
  
     q(0,25,line)

   , line_add_line

   , q(0,1,line)

   , line_add_line_1
   
   , q(2,3,line)

   , line_add_line_2

   , q(1,2,line)

   , line_add_line_3

   , q(1,2,line)

   , line_add_line_4



] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`Delivered`, `to` ])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, tab ] )

     , generic_item( [ delivery_dummy, s1, newline ] )

] ).


%=======================================================================
i_line_rule( line_add_line_1, [
%=======================================================================

     generic_item( [ delivery_party, s1, tab ] )
   
   , generic_item( [ delivery_party_dummy, s1, tab ] )

   , generic_item( [ delivery_party_dummy1, s1, newline ] )

] ).
%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

     generic_item( [ delivery_dummy11, s1, tab ] )
   
   ,generic_item( [ delivery_street, s1, newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================
 
    generic_item( [ delivery_dummy2, s1, tab ] )

  , generic_append( [ delivery_street, s1, newline, ` `, ` ` ] )
    
] ).
%=======================================================================
i_line_rule( line_add_line_4, [
%=======================================================================
 
    generic_item( [ delivery_dummy4, s1, tab ] )

  , generic_item( [ delivery_country_dummy, s1, newline ] )
  
  ,or([

      
       [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `Germany`) ,generic_item( [ delivery_country_code, `DE` ] ) ] 

    ,  [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `SINGAPORE`) ,generic_item( [ delivery_country_code, `SG` ] ) ] 

      
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

     %, check_text(`Invoice` )

     , or([

       generic_horizontal_details( [ [`Invoice`, `No`, `.`, tab ], invoice_number, s1, newline ] )

     , generic_horizontal_details( [ [`Invoice`, `No`, `.`, `:`, tab ], invoice_number, s1, newline ] )

     , generic_horizontal_details( [ [ `Faktura`, `ev`, `.`, `č`, `.`, `:`, tab ], invoice_number, s1, newline ] )

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

     , check_text(`Credit` )

     , generic_horizontal_details( [ [`Credit`,  `note`,  `to`,  `invoice`, `,`,  `ref`, `.`,  `No`, `.`, `:` ], original_invoice_number, s1, newline ] )


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
        
         generic_horizontal_details( [ [`Invoice`, `Date`, tab ], invoice_date, date, newline ] )

      ,  generic_horizontal_details( [ [`Date`, `of`, `issue`, `:`, tab ], invoice_date, date, newline ] )

      ,  generic_horizontal_details( [ [`Datum`, `vystavení`, `:`, tab ], invoice_date, date, newline ] )
    
] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(25,50,line)

  %, check_text(`PO` )

  , or( [
   
   % , generic_horizontal_details( [ [`PO`, `Number`, tab], order_number, d, newline ] )
 
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
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================

  or([
    
    line_with_text(`Total`)

  , line_with_text(`Celkem`)

  , line_with_text(`excl`)

    ])
    
     , read_ahead([
      in, *
      , or([
          `Total before Tax`
          , `Total:`
          , `Celkem:`

          , `excl.`
          , `excl`
      ]), tab
      , set(regexp_cross_word_boundaries)
      , or([
          [
            generic_item( [ dummy_net_total, [ begin, q([ dec, other_skip ],1,10), q(other(","),1,1), q(dec,2,2), end ] ] )
            , set(reverse_punctuation_in_numbers)
          ]
          , [ trace( [ `Numbers are NOT in reverse punctuation` ] ) ]
      ])
      , clear(regexp_cross_word_boundaries), out
  ])

  , or([

    generic_horizontal_details( [ [ `Total`, `before`, `Tax`, tab ], total_net, d , newline ] )

    , generic_horizontal_details( [ [ `Celkem`, `:`, tab ], total_net, d , tab ] )

    , generic_horizontal_details( [ [`excl`, `.`, `VAT`, tab ], total_net, d , tab ] )

    , [ set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [ `Total`, `:`, tab ], total_net, d , tab ] )
      , clear(regexp_cross_word_boundaries) ]

    , [ set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [ `Celkem`, `:`, tab ], total_net, d , tab ] )
      , clear(regexp_cross_word_boundaries) ]

      , [ set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [`excl`, `.`, `VAT`, tab ], total_net, d , tab ] )
      , clear(regexp_cross_word_boundaries) ]

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

  line_with_text(`Tax`)

  , read_ahead([
      in, *, `Tax`, tab
      , set(regexp_cross_word_boundaries)
      , or([
          [
            generic_item( [ dummy_tax_total, [ begin, q([ dec, other_skip ],1,10), q(other(","),1,1), q(dec,2,2), end ] ] )
            , set(reverse_punctuation_in_numbers)
          ]
          , [ trace( [ `Numbers are NOT in reverse punctuation` ] ) ]
      ])
      , clear(regexp_cross_word_boundaries), out
  ])

  , generic_horizontal_details( [ [ `Tax`, tab ], total_vat, d, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_invoice, [
%=======================================================================


  or([
    
    line_with_text(`Total`)

  , line_with_text(`Celkem`)

  , line_with_text(`Celkem`)

    ])

  , read_ahead([ 
      in, *
      , or([
          `Total with Tax`
          , `Total:`
          , `Celkem:`
          , `Total`
      ]), tab
      , set(regexp_cross_word_boundaries)
      , or([
          [
            generic_item( [ dummy_invoice_total, [ begin, q([ dec, other_skip ],1,10), q(other(","),1,1), q(dec,2,2), end ] ] )
            , set(reverse_punctuation_in_numbers)
          ]
          , [ trace( [ `Numbers are NOT in reverse punctuation` ] ) ]
      ])
      , clear(regexp_cross_word_boundaries), out
  ])

  , or([

    generic_horizontal_details( [ [ `Total`, `with`, `Tax`, tab ], total_invoice, d , newline ] )
    
     , generic_horizontal_details( [ [ `Total`, `:`, tab,dummy(s1), tab, `0`, `,`, `00`, tab  ], total_invoice, d , `EUR` ] )

    , generic_horizontal_details( [ [  `Celkem`, `:`, tab, dummy(s1), tab, `0`, `,`, `00`, tab ], total_invoice, d ,  `EUR` ] )

    , [  set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [ `Total`, `:`, tab, dummy(s1), tab, `0`, `,`, `00`, tab ], total_invoice, d , `EUR` ] )
      , clear(regexp_cross_word_boundaries) ]

  
    , [  set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [  `Celkem`, `:`, tab, dummy(s1), tab, `0`, `,`, `00`, tab  ], total_invoice, d , `EUR` ] )
      , clear(regexp_cross_word_boundaries) ]

    , [  set(regexp_cross_word_boundaries)
      , generic_horizontal_details( [ [ `Total`, `:`, tab,dummy(s1), tab, `0`, `,`, `00`, tab  ], total_invoice, d , `EUR` ] )
      , clear(regexp_cross_word_boundaries) ]

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

    ,or([

     [`Currency`, tab, `Euro`,  newline ]

    , [`EUR`,  newline ]

      
    ])
    
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
              
              
                [line_credit_line , line_descr_line, q10(line_append_line)]
              
              , [line_invoice_line_2  , line_order_line]
                            
              , [line_invoice_line, q10(line_append_line),q10(line_append_line), q10(line_append_line_1)  ]

              , [line_invoice_line_1 , line_descr_line, q10(line_append_line)]


              , line_invoice_line_3 

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [ `Line`, tab, `Item`, `Description`, tab ]

    , [`Item`, `Article`, tab, `Quantity`, tab ]

    , [`Pol`, `.`, `Zboží`, tab, `Množství`, tab ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   
    or([
      
       [ `Invoice`,  newline ]  
   
   , [`Tax`, `Type`, tab, `VAT`, `Reverse`, `Charge`,  newline ]

 ] )
 
     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
   
    generic_item( [ line_buyers_order_number, d, tab ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_quantity_uom_code_dummy_dummy, w, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_rate, d, tab ] )

  , generic_item( [ line_vat_amount, d, newline ] )

  , generic_item( [ line_quantity_uom_code, `EA` ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================
   
    generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code_dummy_dummy_dummy, w, tab ] )

  , generic_item( [ line_unit_amount_dummy, s1,tab ] )

  , generic_item( [ line_vat_rate, d, tab ] )

  , generic_item( [ line_net_amount_dummy, s1, tab ] )

  , generic_item( [ line_vat_amount_dummy, s1, tab ] )

  , set(regexp_cross_word_boundaries)
   
  , generic_item( [ line_total_amount, d, `EUR /n`  ] )

  , clear(regexp_cross_word_boundaries)

  , generic_item( [ line_quantity_uom_code, `EA` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================
   
    generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code_dummy_dummy_dummy, s1, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , set(regexp_cross_word_boundaries)
     
  , generic_item( [ line_net_amount, d, tab ] )
 
  , generic_item( [ line_vat_rate, d , tab ] )
  
  , generic_item( [ line_vat_amount_dummy, s1, newline ] )

  , clear(regexp_cross_word_boundaries)

  , generic_item( [ line_quantity_uom_code, `EA` ] )
  
  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).
%=======================================================================
i_line_rule_cut( line_order_line, [
%=======================================================================
   
     generic_item( [ line_buyers_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, newline ] )
    
   ,  check(line_buyers_dummy = Buyer1)

   , trace( [ `Buyer1`, Buyer1] )

   , check(sys_calculate_str_multiply( Buyer1, `10`, Poitem )) 

   , line_buyers_order_number(Poitem)

   , trace( [ `Buyer1`, Buyer] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
   
     generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code_dummy_dummy_dummy, w, tab ] )

  , generic_item( [ line_unit_amount_dummy, s1,tab ] )

  , generic_item( [ line_vat_rate, d, tab ] )

  
  , set(regexp_cross_word_boundaries)

  , generic_item( [ line_net_amount, d, tab ] )

  
  , clear(regexp_cross_word_boundaries)

  , generic_item( [ line_vat_amount, d, tab ] )

  , generic_item( [ line_vat_amoun_dummyt, s, [`EUR`,  newline ] ] )

  , generic_item( [ line_quantity_uom_code, `EA` ] )

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )



] ).
%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

   generic_item( [ line_descr, s1, newline  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line_1, [
%=======================================================================

    generic_append( [ line_descr, s1, tab, ` `, ` `  ] )

, generic_item( [ line_descr_dummy, s1, tab  ] )

, q10(generic_item( [ line_descr_dummy, s1, tab  ] ) )

, q10(generic_item( [ line_descr_dummy, s1, tab  ] ))

, generic_item( [ line_descr_dummy, s1, newline  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line_2, [
%=======================================================================

    generic_item( [ line_descr, s1, tab  ] )

, generic_item( [ line_descr_dummy, s1, tab  ] )

, q10(generic_item( [ line_descr_dummy, s1, tab  ] ) )

, q10(generic_item( [ line_descr_dummy, s1, tab  ] ))

, generic_item( [ line_descr_dummy, s1, newline  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================
   
     generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code_dummy_dummy, w, tab ] )

  , generic_item( [ line_unit_amount_dummy, s1,tab ] )

  , generic_item( [ line_vat_rate, d, [ tab, `-`] ] )

  
  , set(regexp_cross_word_boundaries)

  , generic_item( [ line_net_amount, d, tab ] )

  
  , clear(regexp_cross_word_boundaries)

  , generic_item( [ line_vat_amount, d, [tab, `-` ] ] )

  , generic_item( [ line_vat_amoun_dummyt, s, [`EUR`,  newline ] ] )

  , generic_item( [ line_quantity_uom_code, `EA` ] )

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 25 Sep, 2020
% Mapped by - Rohini 

% Updated on   - 01 October, 2020
% Updated by   - Rohini
% Changes made - Invoice format updated

% Updated on   - 01 Feb, 2021
% Updated by   - Rohini
% Changes made - Credit note mapped

% Updated on   - 26 March, 2021
% Updated by   - Rohii
% Changes made  - AMount capture updated by CT support team to append


% Updated on   -01 June, 2021
% Updated by   - Rohii
% Changes made  - Invoice new format mapped with German language

% Updated on   - 01 June, 2021
% Updated by   - Rohini
% Changes made - Qunatity UOM hardcoded to EA  -Each as per email from AMAT

% Updated on   - 20 Sep, 2021
% Updated by   - Rohini
% Changes made -  Total net and Total Invoice updated

% Updated on   - 02 June, 2022
% Updated by   - Rohini
% Changes made -  Line details updated - End line updated

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%