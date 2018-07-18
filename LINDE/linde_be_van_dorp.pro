%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Van Dorp installaties B.V.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_be_van_dorp, `July 5, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_date_language( dutch ).

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

    , get_payment_terms

    , get_delivery_note

    , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_freight

    , get_currency

    , get_vat_rate

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

      sender_name( `Van Dorp installaties B.V.` )

    , supplier_party( `Van Dorp installaties B.V.` )

    , supplier_vat_number(`NL003276211B01`)  

    , currency(`EUR`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
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
        
         read_ahead(`Linde`)
        
    ]) 

        , trace( [ `Found address`] )

        ,  or([

            generic_item( [ buyer_party, s1, newline ] )

          , generic_item( [ buyer_party, s1, tab ] )
        
        ])

                
     , or([


     [ check(buyer_party = `Linde Gas Benelux`) ,generic_item( [ buyer_registration_number, `NL10` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Benelux B.V.`) ,generic_item( [ buyer_registration_number, `NL10` ] ) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `LINDE GAS BENELUX B.V.`) ,generic_item( [ buyer_registration_number, `NL10` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Benelux BV`) ,generic_item( [ buyer_registration_number, `NL10` ] ) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Therapautics`) ,generic_item( [ buyer_registration_number, `NL20` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Home care Benelux`) ,generic_item( [ buyer_registration_number, `NL25` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Therapeutics Benelux B.V.`) ,generic_item( [ buyer_registration_number, `NL20` ] ) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `LINDE HOMECARE BENELUX B.V.`) ,generic_item( [ buyer_registration_number, `NL25` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `LINDE HOMECARE BENELUX BV.`) ,generic_item( [ buyer_registration_number, `NL25` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `LINDE HOMECARE BENELUX BV`) ,generic_item( [ buyer_registration_number, `NL25` ] ) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `LINDE HOMECARE BENELUX B.V`) ,generic_item( [ buyer_registration_number, `NL25` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Cryoservices B.V.`) ,generic_item( [ buyer_registration_number, `NL15` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `OCAP`) ,generic_item( [ buyer_registration_number, `NL80` ] ), buyer_dept(`NL`) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `OCAP CO2 b.v.`) ,generic_item( [ buyer_registration_number, `NL80` ] ) , buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Electronics`) ,generic_item( [ buyer_registration_number, `NL95` ] ), buyer_dept(`NL`) ]  

    , [ check(buyer_party = `Linde Gas Belgium`) ,generic_item( [ buyer_registration_number, `BE10` ] ) , buyer_dept(`BE`) ]  

    , [ check(buyer_party = `Linde Homecare Belgium`) ,generic_item( [ buyer_registration_number, `BE30` ] ) , buyer_dept(`BE`) ]  

    , [ check(buyer_party = `LINDE HOMECARE BELGIUM N.V.`) ,generic_item( [ buyer_registration_number, `BE30` ] ) , buyer_dept(`BE`) ]  

    , [ check(buyer_party = `Linde Homecare Belgium bvba`) ,generic_item( [ buyer_registration_number, `BE30` ] ) , buyer_dept(`BE`) ]  
        
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

    , [ generic_horizontal_details( [ [  `BIC`, `:` ], supplier_swift_code, s, [ `Bank`, `:`, generic_item( [ supplier_iban_raw, s1 ] ), tab, `G`, `-`, `rek`, `.`, `:`,generic_item( [ supplier_iban_raw_1, s1 ] ),  newline] ] )

             
    , check( supplier_iban_raw = IBanRaw )

    , trace( [ `Bank_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, `.`, ``, IBANstrip ))

    , trace( [ `Bank_raw Stripped ` , IBANstrip ] )

    , supplier_iban(IBANstrip)

    , check( supplier_iban_raw_1 = IBanRaw2 )

    , trace( [ `supplier_iban_raw` , IBanRaw2 ] )

    , check(string_string_replace( IBanRaw2, `.`, ``, IBANstrip2 ))

    , trace( [ `IBAN  Stripped Space` , IBANstrip2 ] )

    , supplier_iban_1(IBANstrip2)]

    
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

    ,generic_horizontal_details( [ [ `Factuurnummer`, tab, `:`], invoice_number, s1,  newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE  DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,40,line)

     ,generic_horizontal_details( [ [ `Datum`, tab, `:`], invoice_date, date,  newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE PAYMENT TERMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

     q(0,40,line)

    , generic_horizontal_details( [ [  `Betaling`, `binnen` ],payment_terms, d ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,50,line)

    , or([

      generic_horizontal_details( [ [ `Ordernummer`, `:`, `PO` ], order_number, d, newline ] )

    , generic_horizontal_details( [ [ `Referentie`, `:`, tab ], order_number, d ] )

     ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

       last_line

    , q(0,80,up)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [`Totaal`, `excl`, `.`, `BTW`, tab ], total_net, d, newline ] )


    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================
  
     last_line

    , q(0,80,up)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [generic_item( [ default_vat_rate, d ] ), `%`, `over`, tab, dummy(d), tab], total_vat, d, newline ] )

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

    , generic_horizontal_details( [ [ `Door`, `u`, `te`, `betalen`, tab ], total_invoice, d, newline ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

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
              
        line_invoice_line_order,  [line_invoice_line, q10(line_invoice_line_append ) ]
        
        

       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[`aantal`, `ehd`, `omschrijving`, tab]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [ `Totaal`, `excl`, `.`, `BTW`, tab ]
   
 ])

  , trace( [ `Found END line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_order, [
%=======================================================================

    `Ordernummer`, `:`, `PO`
    , generic_item( [ line_order_line_number, d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_quantity, d, [dummy(w), tab] ] ) 

    , generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_unit_amount_dummy,d, tab] )

    , generic_item( [ line_net_amount, d, newline ] )

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_append, [
%=======================================================================

     generic_append( [ line_descr, s1, newline, ` `, `` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 5, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%