%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ridder Lastechniek
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_ridder_lastechniek, `July 6, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    , get_freight_line


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `Ridder Lastechniek` )

   , supplier_party(`Ridder Lastechniek`)

   , supplier_vat_number(`NL002762547B01`) 

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
       
        , generic_item( [ buyer_party, s1, tab ] )
     
        , or([

        [ [ check(buyer_party = `Linde Gas Benelux B.V. Att. Account Payable`), generic_item( [ buyer_registration_number, `NL10` ] ) ] 

        , generic_item( [ buyer_dept, `NL` ] )]

        , [[ check(buyer_party = `Linde Gas Cryoservices B.V.`), generic_item( [ buyer_registration_number, `NL15` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Gas Therapeutics Benelux B.V.`), generic_item( [ buyer_registration_number, `NL20` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]

                
        , [[ check(buyer_party = `Linde Home care Benelux`), generic_item( [ buyer_registration_number, `NL25` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `OCAP`), generic_item( [ buyer_registration_number, `NL80` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Electronics`), generic_item( [ buyer_registration_number, `NL95` ] ) ] 

         , generic_item( [ buyer_dept, `NL` ] )]


        , [[ check(buyer_party = `Linde Gas Belgium`), generic_item( [ buyer_registration_number, `BE10` ] ) ] 

         , generic_item( [ buyer_dept, `BE` ] )]


        , [[ check(buyer_party = `Linde Homecare Belgium Bvba`), generic_item( [ buyer_registration_number, `BE30` ] ) ] 

         , generic_item( [ buyer_dept, `BE` ] )]

      
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

      q(0,50,line)

    , generic_horizontal_details( [ [ `Factuurnummer`, `:`, tab  ], invoice_number, d, tab ] )

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

    , generic_horizontal_details( [ [  `Factuurdatum`, `:`, tab ], invoice_date, date, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

      q(0,50,line)

    , generic_horizontal_details( [ [ `Vervaldatum`, `:`, tab ], due_date, date, newline ] )

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

    , generic_horizontal_details( [ [`Betaling`, `binnen`  ], payment_terms ,d, `dagen` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

      q(0,20,line)

    , generic_horizontal_details( [ [`Uw`, `referentie`, `:`, dummy_num(s1), tab  ], order_number ,d, newline ] )

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
    
   , q(0,50, up )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)
 
   , generic_horizontal_details( [ [`Totaal`, `exclusief`, `BTW`, `:`, tab ], total_net, d, newline ] )
 
   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers) 

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
    
   , q(0,50, up )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)
 
   , generic_horizontal_details( [ [`21`, `,`, `00`, `%`, `BTW`, `over`, dummy_num(d), tab ], total_vat, d, newline ] )
 
   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers) 

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
    
   , q(0,50, up )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)
 
   , generic_horizontal_details( [ [`Te`, `betalen`, `in`, `EUR`, `:`, tab  ], total_invoice, d, newline ] )
 
   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers) 

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_currency, [
%=======================================================================

  
    last_line
    
   , q(0,50, up )
 
   , generic_horizontal_details( [ [`Te`, `betalen`, `in`  ], currency, w, [`:`, tab ] ] )

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

        line_invoice_line
         
         , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


      [`Code`, tab, `Omschrijving`, tab, `Aantal` ]

     , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

      or([

        [`Totalen`, `:`,  newline ]
   
     ] )

     , trace( [ `Found End line` ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries) 

   , generic_item( [ line_item, d , tab ] )

   , generic_item( [ line_descr, s1 , tab ] )

   , generic_item( [ line_quantity, d , q10(tab) ] )

   , generic_item( [ line_quantity_uom_code, w , tab ] )
      
   , generic_item( [ line_unit_amount, d , q10(tab) ] )

   , generic_item( [ line_net_amount, d , newline ] )

   , q10([	% LINE VAT Rate Calculation
  
      with( invoice , total_vat , VAT )

   , with( invoice , total_net , Net )

   , trace( [ `vat tot`, VAT ] )

   , trace( [ `sub total`, Net ] )

   , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

   , trace( [ `VAT Rate`, VAT_RATE ] )
  
   , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

   , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])

   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 6, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%