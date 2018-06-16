%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE -  Gascontrol Systems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_bn_gascontrol_systems, `15 June, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_pdf_parameter( newline, 10 ).

i_pdf_parameter( x_tolerance_100, 100 ).

i_date_language( dutch ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    get_supplier_detail

    ,get_bill_to_address

   , get_supplier_vat_number 

   , get_currency

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

    , get_vat_rate

    , get_invoice_lines

    , get_freight_line

    , get_freight_line_1

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

    sender_name( `Gascontrol Systems` )

    ,supplier_party( `Gascontrol Systems` )

    , supplier_vat_number(`NL807125945B01`)

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

    , [ check(buyer_party = `Linde Gas Benelux BV`) ,generic_item( [ buyer_registration_number, `NL10` ] ) ] 

    , [ check(buyer_party = `Linde Gas Therapautics`) ,generic_item( [ buyer_registration_number, `NL20` ] ) ] 

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
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,15,line)

    , generic_horizontal_details( [ [`Factuurnummer`, `:`], invoice_number, s1, newline ] )
          
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

   , generic_horizontal_details( [ [ `Factuurdatum`, `:`, tab], invoice_date, date, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE PO NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,20,line)

    , generic_horizontal_details( [ [`Uw`, `referentie`, `:`, tab ], order_number, s1, newline ] )
          
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,20,line)

   , generic_horizontal_details( [ [ `Te`, `betalen`, `voor`, `:`, tab], due_date, date, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Currecny
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     q(0,40,line)

    , or([

    %generic_horizontal_details( [ [ `Totaal`, `door`, `u`, `te`, `betalen` ], currency, w ] )

    currency_alternate

    ])

] ).
%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================
    
    q0n(anything)

    , or([

    [`€`]

    , [ `Euro`, `'`, `s`]
    
    ])

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

   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
    
   ,[ generic_horizontal_details( [ [`Totaal`, `exclusief`, `BTW`, `inclusief`, `korting`, tab], total_netRaw, d, newline ] )

    
   ,q(0,1,line)

   , generic_horizontal_details( [ [  `Bijdrage`, `in`, `de`, `verzendkosten`, tab ],  total_freightRaw, d, newline  ] )



    
      , check( total_netRaw= TotNet1 ) , trace( [ `Total NET Raw` ,TotNet1 ] )  
    
      , check( total_freightRaw= TotNet2 ) , trace( [ `Total Freigth Raw` ,TotNet2 ] )

      , check(sys_calculate_str_add( TotNet1, TotNet2, TotNetNew))  ,total_net(TotNetNew) , trace( [ `Total VAT` , total_net ] )

          ]
    

    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
       
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL Shipping Cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_freight_line, [
%=======================================================================

   q(0,100,line)

   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
    
    , generic_horizontal_details( [ [  `Bijdrage`, `in`, `de`, `verzendkosten`, tab ], line_net_amount, d, newline  ] )

    , generic_item( [ line_descr, `Bijdrage in de verzendkosten` ] )
  
   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

   ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL Vat AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

   q(0,100,line)

   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
    
    , generic_horizontal_details( [ [`Totaal`, `BTW`, generic_item( [ default_vat_rate, d ] ), `%`, tab], total_vat, d, newline ] )
  
   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

   ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

   q(0,100,line)

   , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
  
    , generic_horizontal_details( [ [ `Totaal`, `te`, `betalen`, tab], total_invoice, d, newline ] )

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
              
        line_invoice_line

       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

or([

[ `Aantal`, tab, `Artikel`, `nr`, `.`, `Artikel`, tab, `Prijs`]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [`Totaal`, `exclusief`, `BTW`, tab]

 ])

  , trace( [ `Found END line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
 
    
     set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)
 
    , generic_item( [ line_quantity, d, tab ] )  

    , generic_item( [ line_descr, s1, tab ] )  

   , generic_item( [ line_unit_amount, d, tab ] ) 

   , generic_item( [ line_percent_discount, d, tab ] )

    , generic_item( [ line_net_amount, d , newline ] ) 
     
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
     
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 15, 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%