%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE -Samson Regeltechniek B.V.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_bn_samson_regeltechniek, `20 June, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_date_language( spanish ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
     get_supplier_detail

    , get_bill_to_address

    , get_supplier_vat_number 

    , get_bank_accountnumber

    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_delivery_note

    , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_freight

    , get_currency

    , get_vat_rate

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

    sender_name( `Samson Regeltechniek B.V.` )

    ,supplier_party( `Samson Regeltechniek B.V.` )

    , supplier_vat_number(`NL003167148B01`)

    , buyer_dept(`NL`)


    

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

     [ check(buyer_party = `Linde Gas Benelux`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `Linde Gas Benelux B.V.`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `LINDE GAS BENELUX B.V.`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `Linde Gas Benelux B.V. t.a.v. Accounts`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `Linde Gas Benelux BV`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `Linde Gas Therapautics`) ,generic_item( [ buyer_registration_number, `NL20` ] ) ] 

    , [ check(buyer_party = `Linde Gas Therapeutics B.V.`) ,generic_item( [ buyer_registration_number, `NL20` ] ) ] 

    , [ check(buyer_party = `Linde Home care Benelux`) ,generic_item( [ buyer_registration_number, `NL25` ] ) ] 

    , [ check(buyer_party = `LINDE HOMECARE BENELUX B.V.`) ,generic_item( [ buyer_registration_number, `NL25` ] ) ] 

    , [ check(buyer_party = `LINDE HOMECARE BENELUX BV.`) ,generic_item( [ buyer_registration_number, `NL25` ] ) ] 

    , [ check(buyer_party = `LINDE HOMECARE BENELUX BV`) ,generic_item( [ buyer_registration_number, `NL25` ] ) ] 

    , [ check(buyer_party = `LINDE HOMECARE BENELUX B.V`) ,generic_item( [ buyer_registration_number, `NL25` ] ) ] 

    , [ check(buyer_party = `Linde Gas Cryoservice`) ,generic_item( [ buyer_registration_number, `NL15` ] ) ] 

    , [ check(buyer_party = `OCAP`) ,generic_item( [ buyer_registration_number, `NL80` ] ) ] 

    , [ check(buyer_party = `OCAP CO2 b.v.`) ,generic_item( [ buyer_registration_number, `NL80` ] ) ] 

    , [ check(buyer_party = `Linde Electronics`) ,generic_item( [ buyer_registration_number, `NL95` ] ) ] 

    , [ check(buyer_party = `Linde Gas Belgium`) ,generic_item( [ buyer_registration_number, `BE10` ] ) ] 

    , [ check(buyer_party = `Linde Homecare Belgium`) ,generic_item( [ buyer_registration_number, `BE30` ] ) ] 

    , [ check(buyer_party = `LINDE HOMECARE BELGIUM N.V.`) ,generic_item( [ buyer_registration_number, `BE30` ] ) ] 
        
      
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
    last_line

    ,q(0,50,up)

    
    ,generic_horizontal_details( [ [`IBAN`, `nr`, `.`, tab ],  supplier_iban_raw,s1, newline ] )

     , check( supplier_iban_raw = IBanRaw )

    , trace( [ `supplier_iban_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, ` `, ``, IBANstrip ))

    , trace( [ `IBAN  Stripped Space` , IBANstrip ] )

    , supplier_iban(IBANstrip)

    , q(0,1,line)

    ,generic_horizontal_details( [ [ `BIC`, `(`, `SWIFT`, `code`, `)`, tab ],  supplier_bank_code,s1, newline ] )


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

    , generic_vertical_details( [ [ `Invoice`, `no`, `.`, tab ], `Invoice`, q(0,2), (start,10,25), invoice_number, s1, tab ] )

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

    , generic_vertical_details( [ [ `Date`, tab ], `Date`, q(0,2), (start,10,25), invoice_date, date, tab ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE Due Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

    last_line

     ,q(0,40,up)

    , generic_vertical_details( [ [ `Expiry`, `Date`, `:`, tab ], `Expiry`, q(0,2), (start,10,25), due_date, date, tab ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE  PO Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,40,line)

    , generic_vertical_details( [ [ `Your`, `order`, `no`, `.`, tab ], `Your`, q(0,1), (start,10,25), order_number_raw, s1, tab ] )

    
     , check( order_number_raw = OrdRaw )

    , trace( [ `Order_raw` , OrdRaw ] )

    , check(string_string_replace( OrdRaw, `PO`, ``, Ordstrip ))

    , trace( [ `order  Stripped PO` , Ordstrip ] )

    , order_number(Ordstrip)

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE  Vat Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_vat_rate, [
%=======================================================================

    last_line

    , q(0,40,up)

    , generic_horizontal_details( [ [  `Vat`, tab ], default_vat_rate, d, [`%`, `Vat`, tab] ] )
 
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

    , q(0,50,up)

    , or([

     generic_horizontal_details( [ [  `Total`, tab ], currency, w , newline ] )

    %,currency_alternate

    ])
  
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================


    
    q0n(anything)

    ,  `€`
    
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

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
    
    , generic_vertical_details( [ [ `Total`, `Net`, `Price`, `excl`, `.`, `Vat`, tab ],`Total` , q(0,1), (start,15, 30), total_net, d, tab ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

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

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [  `21`, `%`, `Vat`, tab ],`Vat` , q(0,1), (start,30, 30), total_vat, d, tab ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
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

    , q(0,80,up)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [   `Total`, tab, `EUR`,  newline ],`Total` , q(0,1), (end,30, 30), total_invoice, d, newline ] )

    , cler(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

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
              
           [line_invoice_line, line_invoice_line_append]


       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[`Item`, tab, `Product`, tab, `Quantity`, tab, `Unit`, `price`, tab]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [`Item`, tab, `Product`, tab, `Quantity`, tab, `Unit`, `price`, tab]

    , [`SAMSON`, `REGELTECHNIEK`, `B`, `.`, `V`, `.`, tab, `Total`, `Net`, `Price`, `excl`, `.`, `Vat`, tab]
   
 ])

  , trace( [ `Found END line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

      generic_item( [ line_item, s, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [ line_net_amount, d,newline ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_append, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `,  ``  ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 20, 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%