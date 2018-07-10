%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linde - A.L.CRYO S.R.L.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_it_al_cryo_srl, `July 9, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

    , get_bank_accountnumber

    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number

    , get_buyer_contact

    , get_payment_terms

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

    sender_name( `A.L.CRYO S.R.L.` )

    ,supplier_party(`A.L.CRYO S.R.L.`)

   ,supplier_vat_number(`02682250598`)

   ,buyer_dept(`IT`)


   
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

          generic_item( [ buyer_party, s1, tab ] )

          , generic_item( [ buyer_party, s1, newline ] )
        
        ])

                
     , or([

     [ check(buyer_party = `Linde Medical`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = `Linde Medicale Srl`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = `LINDE MEDICALE SRL`) ,generic_item( [ buyer_registration_number, `LM` ] ) ] 

    , [ check(buyer_party = ` Linde Gas Italie`) ,generic_item( [ buyer_registration_number, `LCO` ] ) ] 

    , [ check(buyer_party = `LINDE GAS ITALIA SRL`) ,generic_item( [ buyer_registration_number, `LCO` ] ) ]

    , [ check(buyer_party = `LINDE GAS ITALIA S.r.l.`) ,generic_item( [ buyer_registration_number, `LCO` ] ) ]

          
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
 

    q(0,200,line)

    , generic_horizontal_details( [ [ `IBAN`, `:` ], supplier_iban_raw, s1, newline ] )

             
    , check( supplier_iban_raw = IBanRaw )

    , trace( [ `Bank_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, `-`, ``, IBANstrip ))

    , trace( [ `Bank_raw Stripped ` , IBANstrip ] )

    , supplier_iban_1(IBANstrip)

    
             
    , check( supplier_iban_1 = IBanRaw1 )

    , trace( [ `Bank_raw` , IBanRaw1 ] )

    , check(string_string_replace( IBanRaw1, ` `, ``, IBANstrip1 ))

    , trace( [ `Bank_raw Stripped space ` , IBANstrip1 ] )

    , supplier_iban(IBANstrip1)



   

    
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

   , generic_vertical_details( [ [`Numero`, tab ], `Numero`, q(0,1), (start, 20, 80), invoice_number, d, tab ] )
          
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,50,line)

   , generic_vertical_details( [ [ `Data`, tab], `Data`, q(0,1), (start, 30, 80), invoice_date, date, tab ] )
             
    

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Payment Term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

     q(0,50,line)

    , or([

    generic_vertical_details( [ [ `Tipo`, `Pagamento`, tab], `Pagamento`, q(0,1), (start, 10, 80), payment_terms, d, `GG` ] )

           

    ])

] ) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

  
    qn0(line)

    , or([

    %generic_vertical_details( [ [ `Valuta`,  newline ], `Valuta`, q(0,1), (end, 30, 100), currency, w, tab  ] )

    currency_alternate

    ])
  
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================


    
    q0n(anything)

    ,  [ `Importo`, `Euro`, tab]
    
    , generic_item( [ currency, `EUR` ] )

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

    , q(0,100,up)

      
    , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [ `Totale`, `Imponibile`,  newline], `Imponibile`, q(0,2), (start,50,250), total_net, d, newline ] )

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
 
    last_line

    , q(0,100,up)

    ,  set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [ `Totale`, `IVA`,  newline], `IVA`, q(0,2), (end,30,350), total_vat, d, newline ] )

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

    last_line

    , q(0,100,up)

    , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [  `Totale`, `Fattura`,  newline], `Fattura`, q(0,2), (end,30,350), total_invoice, d, newline ] )

    , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAT Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_vat_rate, [
%=======================================================================

   last_line

  , q(0,40,up )
      
  , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

  , generic_vertical_details( [ [   `Non`, `imponibile`, tab, `%`, tab], `%`, q(0,1), (start,80,100), default_vat_rate, d, tab ] )

  , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


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


      [line_invoice_line_1 ,q10(line_invoice_line_des_append)]

      ,[line_invoice_line_2, q10(line_invoice_line_des_append)]

     
        
    , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


   [`Codice`, tab, `Descrizione`, tab, `UdM`, `Quantità`, tab, `Prezzo`, `Euro`, tab]

   , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or([
    
    [`Codice`, tab, `Descrizione`, tab, `UdM`, `Quantità`, tab, `Prezzo`, `Euro`, tab]

    , [`Totale`, `Merce`, tab, `Sconto`, `sul`, `Totale`, `Merce`, tab]

    ] )
   
  , trace( [ `Found End line` ] )

 
] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
   
 
     q10( generic_item( [ line_reference, s, tab] ))
  
    , generic_item( [ line_descr, s1,  tab ] )

    , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

    , generic_item( [ line_quantity_uom_code, w, tab  ] )

    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_net_amount_dummy, d , tab ] )

    , generic_item( [ line_net_amount, d , tab ] )

    , generic_item( [ line_vat_code_dummy, d , newline ] )

    , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================
   
 
     
     generic_item( [ line_descr, s1,  tab ] )

    , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)
  
    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_net_amount_dummy, d , tab ] )

    , generic_item( [ line_net_amount, d , tab ] )

    , generic_item( [ line_vat_code_dummy, d , newline ] )

    , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)


] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_des_append, [
%=======================================================================

     generic_append( [ line_descr, s1, newline, `-`, ``  ] )

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 29, 2018
% Mapped by - Thejaswi

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%