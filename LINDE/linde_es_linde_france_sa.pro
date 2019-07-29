%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - LINDE FRANCE S,A, - SPAIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_es_linde_france_sa, `04 July, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_pdf_parameter( newline, 15) .

i_pdf_parameter( x_tolerance_100, 100 ).

i_date_language( spanish ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    get_supplier_detail

    , get_bill_to_address

   , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_delivery_note

    , set_credit_note

    , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_invoice_lines

    , get_payment_terms

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

    sender_name( ` Linde France S.A.` )

    ,supplier_party( `Linde France S.A.` )

   ,supplier_vat_number(`FR58392631248`)

   , buyer_dept(`ES`)
  


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
        read_ahead(`Abello`)

       ,read_ahead(`ABELLÓ`) 

        , read_ahead(`Linde`)
    ]) 

    , trace( [ `Found address`] )

    , or([

      generic_item( [ buyer_party, s1, newline ] )

     , generic_item( [ buyer_party, s1, tab ] )

     , generic_item( [ buyer_party, s, [ `.`, dummy(s)] ] )

    ])

     , or([

          [ check(buyer_party = `ABELLO LINDE SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLÓ LINDE, S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE, SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE JEREZ`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `Linde Medicinal`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ] 

        , [ check(buyer_party = `INO THERAPEUTICS`) ,generic_item( [ buyer_registration_number, `ES30` ] ) ] 

        , [ check(buyer_party = `LINDE MÉDICA, S.L.U.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]

        , [ check(buyer_party = `LINDE MEDICINAL S.L`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA SL`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA, S.L.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]


        ])



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================
last_line

,q(0,50,up)

, generic_horizontal_details( [ [ `IBAN`, `:` ],  supplier_iban_raw,s1, newline ] )


     , check( supplier_iban_raw = IBanRaw )

    , trace( [ `supplier_iban_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, ` `, ``, IBANstrip ))

    , trace( [ `IBAN  Stripped Space` , IBANstrip ] )

    , supplier_iban(IBANstrip)


,generic_horizontal_details( [ [ `BIC`, `:` ], supplier_bank_code, s1, newline ] ) 



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

    , generic_horizontal_details( [ [ `INVOICE`, tab, `:`], invoice_number, d, newline ] )

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

    , generic_horizontal_details( [ [ `Date`, tab, `:`],  invoice_date, date, newline ] )

  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE PAYMENT due date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,100,line)

   
    , generic_horizontal_details( [ [ `Due`, `date`, tab, `:`], due_date,date, newline ] )



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

    , generic_horizontal_details( [ [ `Purchase`, `Orders`, `:` ],  order_number, d, newline] )

    ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q(0,100,line)
    
    ,or([
    
    [generic_horizontal_details( [ [ `Total`, `incl`, `.`, `T`, `.`, `V`, `.`, `A`, `.`, `(` ],  currency, w , [`)`,  newline] ] )]

   %,[currency_alternate]

    ])
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================


    
    q0n(anything)

    , `EURO`
    
    , [`EURO`, tab]
    
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


   q(0,100,line)

   , set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

   , generic_vertical_details( [ [ `TOTAL`, `Net`, `Amount`, tab], `Net`, q(0,1), (end,10,40), total_net, d, tab ] )

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
  
    , [generic_vertical_details( [ [   `VAT`, `Amount`],`VAT` , q(0,1), (start,15,100), total_vat, d, tab ] )]
    
    , clear(regexp_cross_word_boundaries) , clear(reverse_punctuation_in_numbers)
  
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

    ,   q(0,80,up)

    ,set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

    , [generic_vertical_details( [ [ `TOTAL`, `DUE`, `incl`, `.`, `VAT`,  newline ],`Total` , q(0,1), (end,15,60), total_invoice, d, newline ] )]

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
              
          

           line_invoice_line          


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[`Item`, `n`,dummy(s), tab, `Designation`, tab, `Quantity`, `Unit`, `Price`, tab]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [ `currency`, tab, `TOTAL`, `Net`, `Amount`, tab, `VAT`, `rate`, tab]

 ])

  , trace( [ `Found END line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


     generic_item( [ line_descr, s1, tab ] )

    , set(reverse_punctuation_in_numbers)   ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_net_amount, d, newline ] )

    , clear(reverse_punctuation_in_numbers)   ,clear(regexp_cross_word_boundaries)

] ).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 04 , 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made -

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%