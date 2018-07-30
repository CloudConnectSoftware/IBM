%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - Breas Medical GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_bn_breas_medical, `13 June, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

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

      sender_name( `Breas Medical GmbH` )

    , supplier_party( `Breas Medical GmbH` )

    , supplier_vat_number(`DE815481234`)

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

        ,  read_ahead(`LINDE`)
       
        , generic_item( [ buyer_party, s1, newline ] )
     
        , or([

        [ [ check(buyer_party = `LINDE GAS BENELUX BV`), generic_item( [ buyer_registration_number, `NL10` ] ) ] 

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


        , [[ check(buyer_party = `Linde Homecare Belgium Sprl-Bvba`), generic_item( [ buyer_registration_number, `BE30` ] ) ] 

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
        
      q(0,50,line)

    , [generic_horizontal_details( [ [`IBAN`, tab ],  supplier_iban_raw,s1, newline ] )

    , check( supplier_iban_raw = IBanRaw )

    , trace( [ `supplier_iban_raw` , IBanRaw ] )

    , check(string_string_replace( IBanRaw, ` `, ``, IBANstrip ))

    , trace( [ `IBAN  Stripped Space` , IBANstrip ] )

    , supplier_iban(IBANstrip)]

    , q(0,1,line)

    , [generic_horizontal_details( [ [ `BIC`, tab ],  supplier_swift_code,s1, newline ] )]

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

    , [generic_horizontal_details( [ [ `Doc`, `.`, `No`, `.`, tab ],  invoice_number_raw,s1 , newline ] )
   
    , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `-`, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

    , trace( [ `Invoice Number` , invoice_number ] ) ]
          
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
    
     [generic_horizontal_details( [ [`Date`, tab ],  invoice_date,date , newline ] )]

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,40,line)

   , or([
    
      [generic_horizontal_details( [ [ `Days`, tab, `(`, `until` ], due_date, date, [`)`, tab] ] )]

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PAYMENT TERMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

     q(0,40,line)

   , or([
    
      [generic_vertical_details( [ [ `Terms`, `of`, `payment`,  newline ], `Terms` , q(0,1), (end,15,20), payment_terms, d, [`Days`, tab ] ] ) ]

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================


     q(0,40,line)

   , or([
    
  [generic_horizontal_details( [ [`Your`, `Ref`, `.`, tab], order_number, s1, tab ] )]

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DELIVERY NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note, [
%=======================================================================


     q(0,50,line)

   , or([
    
  [generic_horizontal_details( [ [`Delivery`, `Note`], delivery_note_number, d, `,` ] )]

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

      last_line

    , q(0,100,up)
      
    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , or([

     [ generic_horizontal_details( [ [ `Total`, `goods`, dummy(w), tab ], total_net, d, [q10(dummy(w) ),  newline] ] )]

    ])

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

    , q(0,100,up)
      
    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , [ generic_horizontal_details( [ [ `add`, `.`, `VAT`, `with`, `SC`, tab, dummy(d), tab, dummy_1(d), `%`, `from`, tab, dummy_2(d), tab],  total_vat, d, newline  ] ) ]
    
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

    , q(0,100,up)
      
    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , or([

     [ generic_horizontal_details( [ [ `To`, `pay`, generic_item( [ currency, w ] ), tab ], total_invoice, d,  newline ] )]

    ])

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
              
        [line_invoice_line, q10(line_invoice_line_append),  q10(line_invoice_line_append)]
     
        ,line_invoice_line_disc

       , line_invoice_line_disc1

          
       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

   [`Pos`, `.`, tab, `P`, `/`, `N`, tab, `Description`, tab, `Qty`, `.`, `Qty`, `.`, tab ]

, [`Pos`, `.`, `P`, `/`, `N`, tab, `Description`, tab ]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [`Total`, `goods`, dummy(w), tab ]

 ])

  , trace( [ `Found END line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     generic_item( [ line_order_line_number, d, tab ] )

    , generic_item( [ line_item, d, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_quantity, d, q10(tab)] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [ line_net_amount, d, q10(tab) ] )

    , generic_item( [ line_dummy_rate, d, newline ] )
 
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
    
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_disc, [
%=======================================================================

      generic_item( [ line_dummy_disc,s1 , tab ] )

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_net_amount, n, [`%`,  newline ] ] )
 
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_disc1, [
%=======================================================================

      generic_item( [ line_dummy_disc,w , tab ] )

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_dummy_discount, s1, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )
 
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_append, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` ` , ``  ] )    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - June 13, 2018
% Mapped by - Roopesh 

% Updated on   - July 30, 2018
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%