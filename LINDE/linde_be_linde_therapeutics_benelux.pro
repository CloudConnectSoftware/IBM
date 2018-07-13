%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - Linde Gas Therapeutics Benelux B.V.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_be_linde_therapeutics_benelux, `June 12, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_date_language( french ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    get_supplier_detail

   , get_bill

   , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_delivery_note

    , get_order_number

    , get_total_net

   , get_total_vat

    , get_total_invoice

    , get_currency

    , get_invoice_lines

   ,get_payment_terms

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

    sender_name( `Linde Gas Therapeutics Benelux B.V.` )

    ,supplier_party( `Linde Gas Therapeutics Benelux B.V.` )

   ,supplier_vat_number(`NL813939501B01`)

   

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================
q(0,200,line)


 , [generic_horizontal_details( [ [ `IBAN`, `:`,  generic_item( [ supplier_iban_raw,s ] ),`-`, `Swift`, `/`, `BICcode` ],  supplier_bank_code,s1, newline ] )]


     , check( supplier_iban_raw = IBanRaw )

    , trace( [ `supplier_iban_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, ` `, ``, IBANstrip ))

    , trace( [ `IBAN  Stripped Space` , IBANstrip ] )

    , supplier_iban(IBANstrip)



] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buyer ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bill_to_address, [
%=======================================================================

  q(0,15,line)

   , line_add_line

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

    , or([
        read_ahead(`Ocap`)

        , read_ahead(`Linde`)
        
    ]) 

        , trace( [ `Found address`] )

        , or([

          generic_item( [ buyer_party, s1, tab ] )

        ])

     , or([

        [ check(buyer_party = `Linde Gas Benelux B.V.`), generic_item( [ buyer_registration_number, `NL10` ] ) ] 

        , [ check(buyer_party = `Linde Gas Cryoservices BV`), generic_item( [ buyer_registration_number, `NL15` ] ) ] 

        , [ check(buyer_party = `Linde Gas Therapautics`), generic_item( [ buyer_registration_number, `NL20` ] ) ] 
                
        , [ check(buyer_party = `Linde Home care Benelux`), generic_item( [ buyer_registration_number, `NL25` ] ) ] 

        , [ check(buyer_party = `OCAP`), generic_item( [ buyer_registration_number, `NL80` ] ) ] 

        , [ check(buyer_party = `Linde Electronics`), generic_item( [ buyer_registration_number, `NL95` ] ) ] 

        , [ check(buyer_party = `LINDE GAS BELGIUM`), generic_item( [ buyer_registration_number, `BE10` ] ) ] 

        , [ check(buyer_party = `Linde Homecare Belgium`), generic_item( [ buyer_registration_number, `BE30` ] ) ] 
        
      
        ])

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,40,line)

    ,or([

      [ generic_vertical_details( [ [  `Avoir`, `No`, tab],`Avoir` , q(0,1), (start,10,25), invoice_number_raw, s1, tab ] )]

    , [ generic_vertical_details( [ [   `Factuurnummer`],`Factuurnummer` , q(0,1), (start,10,45), invoice_number_raw, s1, tab ] )]

        ])

                
    , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `-`, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

    , trace( [ `Invoice Number` , invoice_number ] ) 

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,40,line)

   , or([
     [generic_horizontal_details( [ [ `Date`, tab, `:`],  invoice_date, date, newline ] )]

     ,[ generic_vertical_details( [ [  `Date`, `d`, `'`, `Avoir`, tab],`Date` , q(0,1), (start,10,25), invoice_date, date, tab ] )]

     ,[ generic_vertical_details( [ [`Factuurdatum`, tab ],`Factuurdatum` , q(0,1), (start,10,25), invoice_date, date, tab ] )]

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE due Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================
    last_line

    , q(0,100,up)

    , generic_horizontal_details( [ [ `Sans`, `esc`, `.`, `jusqu`, `'`, `au` ],  due_date, date , newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purchase Order
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================
     q(0,100,line)

    ,or([
    
     [generic_horizontal_details( [ [  `Ordernummer`, `:` ],  order_number, d, `VAN` ] )]

        
    ])


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================
last_line
    
    ,q(0,100,up)
    
    ,or([
    
    [generic_horizontal_details( [ [  `Factuur`, `bedrag`, tab, `(` ],  currency, w, [ `)`, tab] ] )]

 

 ,[currency_alternate]

    ])
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================


    
    q0n(anything)

    , `EURO`
    
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

   , set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

, or([

   [ generic_horizontal_details( [ [ `Netto`, `bedrag`, tab, `(`, `EUR`, `)`, tab],  total_net, d , newline ] )]

  ])

    ,clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)
  
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

,   q(0,80,up)

   , set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)
,or([
  
[ generic_horizontal_details( [ [  `BTW`, generic_item( [ default_vat_rate, d, tab ] ),  `(`, `EUR`, `)`, tab ],  total_vat, d , newline ] )]

  
])
    ,clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)
  
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

     ,  q(0,100,up)

    ,set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

    , or([
   
        [ generic_horizontal_details( [ [ `Factuur`, `bedrag`, tab, `(`, `EUR`, `)`, tab ],  total_invoice, d , newline ] )]



    ])
    ,clear(regexp_cross_word_boundaries)     , clear(reverse_punctuation_in_numbers)


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
              
        
           line_invoice_line_1


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

 [`Artikel`, tab, `BTW`, tab, `(`, `EUR`, `)`, tab, `(`, `EUR`, `)`]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([
    
    [`Artikel`, tab, `BTW`, tab, `(`, `EUR`, `)`, tab, `(`, `EUR`, `)`]

    ,[`Netto`, `Bedrag`]


 ])

  , trace( [ `Found END line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================


 generic_item( [ line_item, d, tab ] )

 , generic_item( [ line_vat_rate, d ] )

, generic_item( [ line_descr, s1, tab ] )

, set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

, generic_item( [ line_quantity_dummy, d, [a(w), tab] ] )

, generic_item( [ line_quantity, d ] )

, generic_item( [ line_quantity_uom_code, w,tab ] )

 , generic_item( [ line_unit_amount, d,tab ] )

, generic_item( [ line_net_amount, d, newline ] )

, clear(reverse_punctuation_in_numbers)   ,clear(regexp_cross_word_boundaries)

] ).


    
%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

 generic_append( [ line_descr, s1, tab, ` ` ,  ` `  ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 12, 2018
% Mapped by - Thejaswi

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%