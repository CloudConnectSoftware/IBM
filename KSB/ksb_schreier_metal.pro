%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Schreier Metall GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_schreier_metal, `21 March 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
      get_supplier_details

    , get_buyer_address 

    , get_buyer_address1

    , set_credit_note   

    , get_bank_account_code

    , get_bank_account_no
  
    , get_bank_account_no1
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

    , get_contact_person

    , get_currency

    , get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    ,  get_freight_line

    , get_freight_line1

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

     sender_name( `Schreier Metall GmbH` )

    , supplier_party( `Schreier Metall GmbH` )

    , supplier_vat_number(`DE121308375`) 

       
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(1,20,line)

   , line_add_line

   , q(1,4,line)

    ,line_add_line2

] ).


%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       q0n(anything)
       
       ,read_ahead([ `KSB` ])

     , trace( [ `Found address`] )

     , or([

       generic_item( [buyer_party , s1 , newline ] )

    ] )

] ).


%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

    
     q0n(anything)
     
     ,or([

          [`D`, `-`, `67206`]

          , [`820`, `15`, tab  ]

          , [`92635`]

          , [`67206`]

          , [`67227` ]

          , [`DE`, `-`, `06110`]

          , [`92635`]

          , [`66424`]

          , [`DE`, `-`, `67206`]

          , [`F`, `59482`]

         , [`F`, `-`, `92635`]

      ] )

      ,or([

          generic_item( [ buyer_city , w, newline  ] )

             ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

      q(0,100,line)

    ,[ generic_horizontal_details( [ [`IBAN`, `:` ],  supplier_bank_iban_raw, s, [ `/`, `BIC` ] ] )

         
     , check( supplier_bank_iban_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_iban(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_iban ] )  ]

     


    ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

 q(0,30,line)
	
   ,  or([
           
        generic_horizontal_details( [ [ `R`, `E`, `C`, `H`, `N`, `U`, `N`, `G`, `-`, `Nr`, `.`, `:` ], invoice_number, d, tab ] )
       
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

     q(0,50,line)

    ,or([

       generic_horizontal_details( [ [ `Datum`, tab, `:` ], invoice_date, date, newline ] )

 
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

     q(0,50,line)

    ,or([

       generic_horizontal_details( [ [`Bestellnr`, `.`], order_number, d, `vom` ] )
    

 
    ])


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_net_amount, [
%=======================================================================

	qn0(line)

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


     ,or([

       generic_horizontal_details( [ [ `Netto`, `-`, `Summe`, tab, `€`, tab ], total_net, d, newline ] )


        ])
    
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
	

	
]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

	qn0(line)

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


     ,or([

       generic_horizontal_details( [ [ `19`, `,`, `00`, `%`, `MwSt`, `.`, tab, `€`, tab  ], total_vat, d, newline ] )



        ])

        
       , generic_item( [ default_vat_rate, `19` ] )
    
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
	

	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	qn0(line)

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


     ,or([

        generic_horizontal_details( [ [ `Gesamt`, `-`, `Betrag`, tab, `€`, tab ], total_invoice, d, newline ] )

        ])
    
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

q(0,50,line)

,invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

q0n(anything)

,[`€`, tab ]

,currency( `EUR` ) 

,trace( [ `currency found`] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

	line_start_line
	
	,qn0( [ peek_fails(line_end_line)
		
		,or( [

 
    
           [line_invoice_line, q10(line_append_line), q10(line_append_line), q10(line_append_line), q10(line_append_line)
           ,q10(line_append_line),q10(line_append_line),q10(line_append_line), line_invoice_line2]

           , line_invoice_line1
 

       
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Position`, tab, `Menge`, `Einheit`, `-`, `Bezeichnung`, tab ]
      
      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([

          [`BANKVERBINDUNG`, `:`, `RV` ]

        ,  [`Netto`, `-`, `Summe`, tab ]


        ])

        , trace([`found the end line`])
    
] ).




%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================

      
                   
       set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)


      ,  generic_item( [ line_reference,d, tab ] )


      , generic_item( [ line_quantity, d, q10(tab) ] )
      
      , generic_item( [ line_descr, s1, newline ] )

   
                 , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       ])
       



       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule( line_invoice_line1, [
%=======================================================================

      
                   
       set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)

       
      ,  generic_item( [ line_reference,d, tab ] )


      , generic_item( [ line_quantity, d, q10(tab) ] )
      
      , generic_item( [ line_descr, s1, tab ] )
      
      , generic_item( [ line_unit_amount, d, tab ] )

      , generic_item( [ line_net_amount, d, newline ] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_invoice_line2, [
%=======================================================================

      
                   
       set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)


      ,  generic_append( [ line_descr, s1, tab, ` `, ` `  ] )


      , q10(generic_append( [ line_descr, s1, tab, ` `, ` `  ] ))
      
      , generic_item( [ line_unit_amount, d, tab ] )

      , generic_item( [ line_net_amount, d, newline ] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================

      q10(generic_item( [ line_dummy, s1, tab ] ))

     ,generic_append( [ line_descr, s1, newline, ` `, ` `  ] )

] ).

%=======================================================================
i_line_rule( line_po_line, [
%=======================================================================

      or([

           [`VS`, `.`, `ORD`, `.`, dummy_num(d), `/`]
          
         ,[ `VS`, `.`, `ORD`, `.`]

    
        ] )

    , generic_item( [ line_buyers_order_number, d ] )

    , generic_item( [ line_buyers_order_date, date, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - March 21, 2018
% Updated by   - Rohini

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
