
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linde -PROPAC S.R.L.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_it_propac_srl, `June 22, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

    , set_credit_note

    , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_payment_terms

    , get_order_number

    , get_delivery_note
    
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

     sender_name( `PROPAC S.R.L.` )

   , supplier_party(`PROPAC S.R.L.`)

   , supplier_vat_number(`IT02033401007`)

   , currency( `EUR` )


 
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buyer ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bill_to_address, [
%=======================================================================

  q(0,30,line)

   , line_add_line


] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

    , or([
        read_ahead(`OCAP`)

        , read_ahead(`Linde`)
        
    ]) 

        , trace( [ `Found address`] )

        , or([

          generic_item( [ buyer_party, s1, newline ] )

          , generic_item( [ buyer_party, s1, tab ] )
        
        ])

                
     , or([

     [ check(buyer_party = `Linde Medical`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = `Linde Medicale Srl`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = `LINDE MEDICALE S.R.L.`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = ` Linde Gas Italie`) ,generic_item( [ buyer_registration_number, `LCO` ] ) ] 

    , [ check(buyer_party = `LINDE GAS ITALIA SRL`) ,generic_item( [ buyer_registration_number, `LCO` ] ) ]

    
      
        ])

]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

    
     q(0,100,line)

   ,  generic_horizontal_details([ [ `IBAN` ], supplier_iban, s1, newline  ] )

    
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,50,line)

   , generic_vertical_details( [ [  `FATTURA`, `DIFFERITA`, tab ],`FATTURA` , q(0,1), (start,20, 50), invoice_numberraw, s1, newline ] )

   
    
    , check( invoice_numberraw = InvRaw )

    , trace( [ `Invoice number_raw` , InvRaw ] )

    , check(string_string_replace( InvRaw, ` `, ``, Invstrip ))

    , trace( [ `Invoice numebr Stripped Space` , Invstrip ] )

    , invoice_number_raw1(Invstrip)

    , check( invoice_number_raw1 = InvRaw1 )

     , check(string_string_replace( InvRaw1, `/`, ``, Invstrip1 ))

    , trace( [ `Invoice numebr Stripped Spl char.` , Invstrip1 ] )

    , invoice_number(Invstrip1)




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

   , generic_vertical_details( [ [  `FATTURA`, `DIFFERITA`, tab ],`DIFFERITA` , q(0,2), (start,20, 50), invoice_date, date, newline ] )

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

    , or([

     generic_horizontal_details( [ [ `Ordine`, `nr`, `:` ], order_number, d, tab ] )
        
    , find_order_number

    ])
] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([

         generic_item( [ order_number , [ begin, q(dec("8"),1,1) , q(dec("1"),1,1) , q(dec,8,10) , end ] ] )

       , generic_item( [ order_number , [ begin, q(dec("9"),1,1) , q(dec("1"),1,1) , q(dec,8,10) , end ] ] )

    ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    q(0,100, line )

      
   , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

   , or([

       generic_vertical_details( [ [ `NETTO`, `MERCE`,  newline], `NETTO`, q(0,1), (end,50,100), total_net, d, newline ] )

     ])

    ,clear(regexp_cross_word_boundaries),clear(reverse_punctuation_in_numbers)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================
 
    q(0,100, line )

    ,  set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

    , or([

     generic_vertical_details( [ [`IMPORTO`, `IVA`, tab ], `IMPORTO`, q(0,1), (end,50,100), total_vat, d, tab ] )

    ])

    , clear(regexp_cross_word_boundaries)   ,clear(reverse_punctuation_in_numbers)
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

    
   q(0,200, line )
      
  , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

  , generic_vertical_details( [ [ `TOTALE`, `FATTURA`,  newline], `TOTALE` , q(0,3), (end,70,300), total_invoice, d, newline ] )

  , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DELIVERY NOTE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note, [
%=======================================================================

     q(0,150,line)

  , generic_horizontal_details( [ [ `Riferimento`, `Ns`, `.`, `D`, `.`, `d`, `.`, `T`, `.`, `n`, `.`, tab], delivery_note_number, s , `-` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

    , or( [
              
    [ line_invoice_line,q10(line_invoice_line_append)]

    , line_delivery_line

    
        
    , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


   [ `CODICE`, tab, `DESCRIZIONE`, `ARTICOLO`, tab, `U`, `.`, `M`, `.`, `QUANTITA`, `'`, tab ]

   , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or([
    
    [ `IMPONIBILI`, tab, `AL`, `.`, `IVA`, tab, `DESCRIZIONE`, `IVA`, tab ]

    ] )
   
  , trace( [ `Found End line` ] )

 
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
  
 
    set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)
 
  , generic_item( [line_reference , s1 , tab ] )

  , generic_item( [line_descr , s1, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )

  , generic_item( [ line_quantity ,d, tab ] )

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

  , generic_item( [ line_net_amount, d  ] )

    , generic_item( [ line_vat_rate, d, newline  ] )

    , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


] ).


%=======================================================================
i_line_rule_cut( line_delivery_line, [
%=======================================================================

     [`Riferimento`, `Ns`, `.`, `D`, `.`, `d`, `.`, `T`, `.`, `n`, `.`, tab]

    , generic_item( [ line_delivery_note_number, d,  `-` ] )

    , generic_item( [ line_dummy, date,  newline ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_append, [
%=======================================================================
  
    generic_append( [ line_descr, s1, newline, `:-` , ``  ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 22, 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made -

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%