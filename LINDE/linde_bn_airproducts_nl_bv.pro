%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - Air Products Nederland B.V.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_bn_airproducts_nv, `11 June, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

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

     sender_name( `Air Products Nederland B.V.` )

    , supplier_party( `Air Products Nederland B.V.` )

    , supplier_vat_number(`NL806423638B01`)
   
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER REGISTRATION 
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

        ,  read_ahead(`Linde`)
       
        , generic_item( [ buyer_party, s1, newline ] )
     
        , or([

        [ [ check(buyer_party = `LINDE GAS BENELUX B.V.`), generic_item( [ buyer_registration_number, `NL10` ] ) ] 

        , generic_item( [ buyer_dept, `NL` ] )]

        , [ [ check(buyer_party = `LINDE GAS BENELUX`), generic_item( [ buyer_registration_number, `NL10` ] ) ] 

        , generic_item( [ buyer_dept, `NL` ] )]

        , [[ check(buyer_party = `Linde Gas Cryoservices BV`), generic_item( [ buyer_registration_number, `NL15` ] ) ] 

        , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Gas Therapeutics Benelux B.V.`), generic_item( [ buyer_registration_number, `NL20` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]

                
        , [[ check(buyer_party = `Linde Homecare Benelux B.V.`), generic_item( [ buyer_registration_number, `NL25` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `OCAP`), generic_item( [ buyer_registration_number, `NL80` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Electronics`), generic_item( [ buyer_registration_number, `NL95` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Gas Belgium`), generic_item( [ buyer_registration_number, `BE10` ] ) ] 

         , generic_item( [ buyer_dept, `BE` ] )]


        , [[ check(buyer_party = `LINDE HOMECARE BELGIUM`), generic_item( [ buyer_registration_number, `BE30` ] ) ] 

         , generic_item( [ buyer_dept, `BE` ] )]
      
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


   q(0,70,line)

  , generic_horizontal_details( [ [ `Account`, `:` ],  supplier_bank_account_number_raw, s1, tab ] )

  
  , check( supplier_bank_account_number_raw = ACCRaw )

  , trace( [ `Bank ACC_raw` , ACCRaw ] )

  , check(string_string_replace( ACCRaw, `.`, ``, ACCstrip ))

  , trace( [ `ACC  Stripped Space` , ACCstrip ] )

  , supplier_bank_account_number(ACCstrip)


  , q(0,1,line)

  , generic_horizontal_details( [ [  `Swift`, `Code` ],  supplier_swift_code, s1, tab ] )

  , q(0,1,line)

  , generic_horizontal_details( [ [  `IBAN`, `:`], supplier_iban_raw, s1, newline ] )

  , check( supplier_iban_raw = IBanRaw )

  , trace( [ `supplier_iban_raw` , IBanRaw ] )

  , check(string_string_replace( IBanRaw, ` `, ``, IBANstrip ))

  , trace( [ `IBAN  Stripped Space` , IBANstrip ] )

  , supplier_iban(IBANstrip)

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
       
       generic_horizontal_details( [ [  `Factuur`, `nr`, `.`, `:`, tab],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [  `Invoice`, `No`, `.`, `:`, tab],  invoice_number, s1, newline ] )

   ])

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
        generic_horizontal_details( [ [ `Datum`, `:`, tab],  invoice_date, date, newline ] )

        , generic_horizontal_details( [ [ `Date`, `:`, q10(tab)],  invoice_date, date, newline ] )

    ])
 
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,100,line)

    , or([
        generic_horizontal_details( [ [`Vervaldatum`, `:`], due_date,date, newline ] )

        , generic_horizontal_details( [ [`Payment`, `Terms`, `:`, tab ], due_date,date, newline ] )

    ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE PAYMENT TERMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

     q(0,100,line)

    , or([
         
         generic_horizontal_details( [ [`Betalingsvoorwaarden`, `:`], payment_terms,d ] )

        , generic_horizontal_details( [ [`Payment`, `Terms`, `:`, tab, `Net` ], payment_terms,d ] )

    ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,100,line)

    , or([
        generic_horizontal_details( [ [ `Bestelnummer`, `:`], order_number,d, newline ] )

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

]).  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q(0,50,line)

    , or([

     [generic_horizontal_details( [ [     `Totaal`, `te`, `betalen`, `(`],  currency,w,[  `)`, tab] ] )]

     , [generic_horizontal_details( [ [ `Total`, `to`, `be`, `Paid`, `(`],  currency,w,[  `)`, tab] ] )]

    % ,currency_alternate

    ])

  
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================

     q0n(anything)

    , `€`
    
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

    , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)
    
    , or([
        generic_horizontal_details( [ [`Nettowaarde`, tab,dummy_1(d),tab ], total_net, d,  newline  ] )

        , generic_horizontal_details( [ [`Net`, `value`, tab ], total_net, d,  tab  ] )

    ])  

    , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)
 
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

    q(0,100,line)

   , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries) 

   , or([
       generic_horizontal_details( [ [  `BTW`, tab, dummy_2(d), tab],  total_vat, d,  newline  ] )

       , generic_horizontal_details( [ [ `VAT`, tab],  total_vat, d,  tab  ] )

   ])

   , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

     q(0,100,line)

    , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)     

    , or([ generic_horizontal_details( [ [`Totaal`, `te`, `betalen`, `(`, dummy_cur(w), `)`, tab, dummy(d), tab],  total_invoice, d,  newline  ] )

    , generic_horizontal_details( [ [`Total`, `to`, `be`, `Paid`, `(`, `EUR`, `)`, tab],  total_invoice, d,  tab  ] )

    ])

    , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)
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

           ,[line_invoice_line_1,line_append_line]

           , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[`Item`, tab, `Productomschrijving`, tab, `Hoeveelheid`, tab, `Prijs`, tab]

, [`Samenvatting`, tab, `factuur`]

, [`Item`, tab, `Product`, `Detail`]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([   

      [`Item`, tab, `Productomschrijving`, tab, `Hoeveelheid`, tab, `Prijs`, tab]

      , [`Item`, tab, `Product`, `Detail`]

      , [`Net`, `value`, tab]

    , [`Totaal`, `te`, `betalen`, tab]
   
 ])
  , trace( [ `Found END line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


    generic_item( [ line_item, d, q10(tab) ] )

  , generic_item( [ line_reference, d, tab ] )

  , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

  , generic_item( [ line_quantitydummy, d ] )

  , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

  , generic_item( [ line_quantity_uom_code, s1, newline] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================


   generic_item( [ line_descr, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================


     generic_append( [ line_descr, s1, tab, `- ` ,  ` `  ] )

    , set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

    , generic_item( [ line_amount_dummy,d,[`EUR`, tab] ] )

    , generic_item( [ line_unit_amount_dummy, d] )

    , generic_item( [ line_price_uom_code, w,tab] )

    , generic_item( [ line_net_amount, d,newline ] )

    , q10([  % LINE VAT Rate Calculation

     with( invoice , total_vat , VAT )  , trace( [ `vat tot`, VAT ] )

    , with( invoice , total_net , Net ) , trace( [ `sub total`, Net ] )  

    , check(sys_calculate_str_divide( VAT, Net, VAT_RATE)) , trace( [ `VAT Rate`, VAT_RATE ] )

    , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) , generic_item( [ line_vat_rate , VAT_PERCENT ] )    

    , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

       ]) 
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_vat, [
%=======================================================================

       generic_item( [ line_vat_code, s1, tab ] )

     , generic_item( [ line_vat_rate, d, [`%`,  newline ] ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 11, 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%