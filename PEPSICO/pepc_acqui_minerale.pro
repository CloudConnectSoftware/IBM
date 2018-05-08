%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acqua Minerale San Benedetto S.p.A.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( pepc_acqui_minerale, `08 November 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_buyer_address

    , get_buyer_vat

    , get_bank_accountnumber

    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_payment_terms

    , get_due_date

    , get_order_number

    , get_total_net_alternative
    
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

     sender_name( `Acqua Minerale San Benedetto S.p.A.` )

   , supplier_vat_number(`01527840274`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================
  
     q(0,10,line)

   , line_add_line

   , q(1,2,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead(`Acqua`)

     , trace( [ `Found address`] )

     , generic_item( [ supplier_party, s1, tab ] )

     , generic_item( [ supplier_party_dummy, s1, newline ] )



] ).


%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

       generic_item( [ supplier_dummy, s, `:` ] )

     , generic_item( [ supplier_postcode, d ] )

     , generic_item( [ supplier_city, s1, newline ] )



] ).
%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================

     or([

      [generic_item( [ supplier_address_line, s1, tab ] ) 

    , generic_item( [ supplier_dummy, s1, newline ] )]

    , [generic_item( [ supplier_address_line, s1, newline ] )]

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,20,line)

   , line_add_line1

    , q(0,1,line)

    ,line_add_line2

    , q(0,1,line)

    ,line_add_line3



] ).

%=======================================================================
i_line_rule( line_add_line1, [
%=======================================================================

       q0n(anything)
       
    , read_ahead(`PEPSICO`)

     , trace( [ `Found address`] )

    ,  generic_item( [buyer_party , s1, newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================
  
     generic_item( [ buyer_address_line,s1, newline ] )


] ).
%=======================================================================
i_line_rule( line_add_line3, [
%=======================================================================
       
        generic_item( [buyer_postcode , d ] )

      , generic_item( [ buyer_city, w  ] )

      , generic_item( [ buyer_city_dummy1, w, tab ] )

       , generic_item( [ buyer_city_dummy2, s1, newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_vat, [
%=======================================================================

     q(0,50,line)

     
    ,generic_vertical_details( [ [`CLIENTE`, tab, `PARTITA`, `IVA`], `PARTITA`, q(0,1), (start,10,100), buyer_vat_number, s1, tab ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

      q(0,10,line)

    , credit_note_line

    
] ).


%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

      q0n(anything)

    , [`ACCREDITO`]

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

      q(0,20,line)

    , or( [

      generic_vertical_details( [ [ `Nr`, `Fattura`, `/`, `Nr` ], `Fattura`, q(0,1), (end,10,10), invoice_number, s1, tab ] )

    , generic_vertical_details( [ [ `NUMERO`, `FATTURA`], `NUMERO`, q(0,1), (end,10,10), invoice_number, s1, tab ] )

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

        q(0,20,line)

      , or( [ 

        generic_vertical_details( [ [`Data`, `documento`, tab ], `Data`, q(0,1), (end,10,50), invoice_date, date, tab ] )

     ,  generic_vertical_details( [ [`DATA`, `FATTURA` ], `DATA`, q(0,1), (end,10,50), invoice_date, date, tab ] )

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PAYMENT TERMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

     q(0,20,line)

      ,   set(regexp_allow_partial_matching)

   ,generic_horizontal_details( [ [`RIMESSA`, `DIRETTA`], payment_terms, d, [`GG`, `.`, `D`, `.`, `F`] ] )

      , clear(regexp_allow_partial_matching)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net_alternative, [
%=======================================================================

        last_line

      , q(0,20,up)

      ,  set(reverse_punctuation_in_numbers)

      , set(regexp_cross_word_boundaries)

      , or( [ 

        generic_horizontal_details( [ [ `subtotale`, tab ],  total_net_raw1, d, [q10(tab),check( total_net_raw1,(start) < 190)] ] )

      , generic_horizontal_details( [ [ `subtotale`, tab ], total_net_raw1, d ,tab ] )

     ] )

     
 

      , q(0,2,line)
    
      , generic_horizontal_details( [ [ `cauzione`, tab ], total_net_raw2, d , tab ] )

      , check( total_net_raw1= TotNet1 ) , trace( [ `Total net Raw 1` ,TotNet1 ] )  
    
      , check( total_net_raw2= TotNet2 ) , trace( [ `Total net Raw 2` ,TotNet2 ] )

      , check(sys_calculate_str_add( TotNet1, TotNet2, TotNetNew))  ,total_net(TotNetNew) , trace( [ `Total net` , total_net ] )

          
      , clear(regexp_cross_word_boundaries)

      , clear(reverse_punctuation_in_numbers)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

       last_line

     , q(0,20,up)

   

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    , or( [ 

       generic_vertical_details( [ [ `Totale`, `(`, `IVA`, `esclusa`], `Totale`, q(0,1), (start,100,100), total_net, d, tab ] )

      

  ] )
    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)]


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

      last_line

    , q(0,20,up)


    , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    , or( [ 

      generic_vertical_details( [ [ `Importo`, `IVA`, tab], `Importo`, q(0,1), (start,100,100), total_vat, d, tab ] )

    , generic_horizontal_details( [ [ `subtotale`, tab, dummy_num3(d), tab ],  total_vat, d, tab ] )

    ,  generic_horizontal_details( [ [ `subtotale`, tab,dummy_num1(d) ], total_vat, d, [q10(tab),check(total_vat(start)< 290)] ] )

    , generic_horizontal_details( [ [ `subtotale`, tab, dummy_num(d) ], 10, total_vat, d, tab ] )

     
] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

      last_line

    , q(0,20,up)

    
    , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    , or( [ 

      generic_vertical_details( [ [ `Totale`, `documento`], `Totale`,  q(0,1), (start,100,100), total_invoice, d, newline ] )
     
    , generic_horizontal_details( [ [`TOTALE`, `FATTURA`, tab, `EUR`, tab ],  total_invoice, d, [`-`,  newline ] ] )

    , generic_horizontal_details( [ [`TOTALE`, `FATTURA`, tab, `EUR`, tab ],  total_invoice, d, newline  ] )

] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_currency, [
%=======================================================================

      last_line

    , q(0,20,up)

    , or( [ 

      generic_vertical_details( [ [ `Totale`, `documento`], `Totale`,  q(0,1), (start,100,100), currency, w , tab ] )

    , generic_horizontal_details( [ [ `TOTALE`, `FATTURA`, tab ], currency, w, tab ] )

] )

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
              
          [line_invoice_line, q10(line_append_line), q10(line_append_line), q10(line_append_line),q10(line_append_line),q10(line_append_line),q10(line_append_line)]

             ,[line_invoice_line1, q10(line_dummy_line),line_item_line, line_invoice_line2,q10(line_dummy_line)]
            
            , line_invoice_line3

              , line

        ] )

    ] )

] ).


%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

     or( [

        [`Descrizione`, tab, `Codice` ]

     
       , [`COD`, `PROD`, tab, `DESCRIZIONE`]

       ] )

        , trace( [ `Found Start line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
  or( [

   

      [ `Dettaglio`, `IVA`]

    , [`IN`, `CASO`, `DI`, `RITARDATO`]

    , [`SITUAZIONE`, `IMBALLI`, `CON`, `OBBLIGO`]

     ] )

  , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

       q10(generic_item( [ line_descr, s1, tab ] ))

     , q10([read_ahead([`V7`]), generic_item( [ line_vat_rate, `22`] ) ])

     , generic_item( [ line_vat_code_dummy, s1, tab ] )

     , set(reverse_punctuation_in_numbers)

     , set(regexp_cross_word_boundaries)

     , generic_item( [ line_net_amount, d, newline ] )

     , clear(regexp_cross_word_boundaries)

     , clear(reverse_punctuation_in_numbers)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

       generic_item( [ line_item_dummy, d ] )

     , generic_item( [ line_descr, s1, tab ] )

     , set(reverse_punctuation_in_numbers)

     , set(regexp_cross_word_boundaries)

     , generic_item( [ line_weight, d, tab ] )

     , generic_item( [ line_quantity_cases, d, tab ] )

     , generic_item( [ line_quantity, d, tab ] )

     , generic_item( [ line_price_list, d, tab ] )   

     , generic_item( [ line_price_dummy, d, tab ] )   

     , generic_item( [ line_vat_rate, d, newline ] )   


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    

       generic_item( [ line_descr_dummy, s1, tab ] )

     , generic_item( [ line_price_dummy1, d, tab ] )  

     , generic_item( [ line_unit_amount_dummy, d, tab ] )   

     , generic_item( [ line_net_amount, d, newline ] )  

    

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================


       q10([read_ahead([`Contributo`]), generic_item( [ line_vat_rate, `22`] ) ])

     , generic_item( [ line_descr, s1, tab ] )

     , generic_item( [ line_quantity, d, tab ] )  

     , generic_item( [ line_unit_amount_dummy, d, tab ] )  

     , generic_item( [ line_net_amount, d, newline ] )   

     
     , set(regexp_cross_word_boundaries)

] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, `, `, ` `  ] )

] ).


%=======================================================================
i_line_rule_cut( line_item_line, [
%=======================================================================

    generic_item( [ line_item, d, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_dummy_line, [
%=======================================================================

    generic_item( [ line_dummy_line, s1, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - November 8, 2017
% Mapped by - Rohini 

% Updated on   - November 24, 2017
% Updated by   - Rohini 
% Changes made - Supplier Party

% Updated on   - November 30, 2017
% Updated by   - Rohini 
% Changes made - Supplier Address

% Updated on   - April 23, 2018
% Updated by   - Rohini
% Changes made - New format mapped



% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

