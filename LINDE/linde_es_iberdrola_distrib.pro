%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IBERDROLA DISTRIB.ELECTR.SAU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_es_iberdrola_distrib, `12 July, 2019` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

    , get_bank_accountnumber

    , get_invoice_number
    
    , get_invoice_date

    , get_due_date
    
    , get_payment_terms

    , get_delivery_note

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
i_rule( get_supplier_detail,  [
%=======================================================================

      sender_name( `IBERDROLA DISTRIB.ELECTR.SAU` )

    , supplier_party( `IBERDROLA DISTRIB.ELECTR.SAU` )

    , supplier_vat_number(`A95075578`)

    , buyer_dept(`ES`)
    

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bill_to_address, [
%=======================================================================

    q(0,100,line)

   , line_add_line


] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

      q0n(anything)

    , or([
        read_ahead(`Abello`)

        , read_ahead(`LINDE`)
    ]) 

    , trace( [ `Found address`] )

    , or([

      generic_item( [ buyer_party, s1, newline ] )

     , generic_item( [ buyer_party, s1, tab ] )

    ])

     , or([

          [ check(buyer_party = `ABELLO LINDE SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE, S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE, S. A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `Linde Medicinal`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ] 

        , [ check(buyer_party = `INO THERAPEUTICS`) ,generic_item( [ buyer_registration_number, `ES30` ] ) ] 

        , [ check(buyer_party = `LINDE MÉDICA, S.L.U.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]

        , [ check(buyer_party = `LINDE MEDICINAL S.L`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA SL`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA, S.L. UNIPERSONAL`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]



        ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT DETIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================
    

     q0n(line)

    , generic_horizontal_details( [ [ `IBAN`, `:`],supplier_iban_raw, s, [`*`, `*`, `*`, `*`,  newline] ] )

    , check( supplier_iban_raw = IBANRaw )

    , trace( [ `supplier bank iban Raw` , IBANRaw ] )

    , check(string_string_replace( IBANRaw, ` `, ``,IBANstrip ))

    , trace( [ `Bank Iban Stripped ` , IBANstrip ] )

    , supplier_iban(IBANstrip)

    , q(0,4,line)

    , generic_horizontal_details( [ [ `BIC`, `:` ], supplier_bank_code, s1, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

    q(0,80,line)

   , generic_horizontal_details( [ [`Nº`, `factura` ], invoice_number, s1, newline ] )

 ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

    q(0,80,line)


   , generic_horizontal_details( [ [ `Fecha`, `factura` ], invoice_date_raw, s1, newline ] )
       
    , check( invoice_date_raw = INvDateRaw )

    , trace( [ `Inv date Raw` , INvDateRaw ] )

    , check(string_string_replace( INvDateRaw, `de`, ``,INvDatestrip ))

    , trace( [ `INV date Stripped ` , INvDatestrip ] )

    , invoice_date(INvDatestrip)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [`Fecha`, `prevista`, `de`, `cargo`, `:` ], due_date, date, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================
    
    q0n(line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [ `IMPORTE`, `TOTAL`, tab ],total_net, d, [`€`,  newline] ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================
    
    q0n(line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [`IVA`, tab, generic_item( [ default_vat_rate, d ] ), `%`, `s`, `/`, dummy(d), `,`, dummy(d), tab],total_vat, d, [`€`,  tab] ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================
    
    q0n(line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [   `TOTAL`, `IMPORTE`, `FACTURA`, tab],total_invoice, d, [`€`, tab] ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q(0,300,line)

  ,  currency_alternate

  
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================

    
    q0n(anything)
   
    , [ `€`,  newline]

    , generic_item( [ currency, `EUR` ] )

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
       
     line_invoice_line, line_invoice_line_1
          
       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[ dummy(w), tab, `CONOZCA`, `AL`, `DETALLE`, `SU`, `FACTURACIÓN`, `Y`, `CONSUMOS`, tab]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

   [ dummy(w), tab, `TOTAL`, `SERVICIOS`, `Y`, `OTROS`, `CONCEPTOS`, tab]

 ])

  , trace( [ `Found END line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
    
    
     generic_item( [ line_dummy,w, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , generic_append( [ line_descr, s1, tab, `-`, `` ] )
       
    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_net_amount ,d, [`€`,  newline] ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
    
    
     generic_item( [ line_dummy,w, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , generic_append( [ line_descr, s1, tab, `-`, `` ] )
       
    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_net_amount ,d, [`€`,  tab] ] )

    , generic_item( [ line_dummy_line ,s, [`%`,  newline] ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 12, 2019
% Mapped by - Rohini 

% Updated on   - 
% Updated by   -
% Changes made -

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%