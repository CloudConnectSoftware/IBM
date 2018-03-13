%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RITTAL GmbH & Co. KG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_rittal_gmbh, `12 March 2018` ).

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

     sender_name( `RITTAL GmbH & Co. KG` )

    , supplier_party( `RITTAL GmbH & Co. KG ` )

    , supplier_vat_number(`DE111796669 `) 

       
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(1,10,line)

   , line_add_line

   , q(1,3,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

      read_ahead([  `KSB` ])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party , s1, tab ] )

   
] ).


%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

     or([

          [`820`, `15`, tab  ]

          , [`92635`]

          , [`67206`]

      ] )

      ,generic_item( [ buyer_city , w, newline  ] )


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

   ,  generic_horizontal_details( [ [ `Commerzbank`, `Dillenburg` ],  supplier_bank_account_number, d, newline ] )

   , q(0,1,line)

   , [generic_horizontal_details( [ [`(`, `BLZ` ],  supplier_bank_account_code_raw, s,[`)`, `BIC`] ] )
     
     
      , check( supplier_bank_account_code_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_code(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_code ] )]  

    , q(0,1, line )

    , [generic_horizontal_details( [ [  tab, `IBAN` ], supplier_bank_iban_raw, s1, newline ] )

    , check( supplier_bank_iban_raw = BankRaw1 )

    , trace( [ `Bank number raw1` , BankRaw1 ] )

    , check(string_string_replace( BankRaw1, ` `, ``, BankStrip1 ))

    , trace( [ `Bank Stripped Space1` , BankStrip1 ] )

    , supplier_bank_iban(BankStrip1)

    , trace( [ `Bank account Number1` , supplier_bank_iban ] )  ]

    , q(0,1,line)
	
    ,  generic_horizontal_details( [ [`Deutsche`, `Bank`, `Arnsberg` ],  supplier_bank_account_number_2, s1, newline ] )
     
    , q(0,1,line)
	
    ,  [generic_horizontal_details( [ [`(`, `BLZ` ],  supplier_bank_account_code_raw_2, s,[`)`, `BIC`] ] )
       
    , check( supplier_bank_account_code_raw_2 = BankRaw2 )

    , trace( [ `Bank number raw2` , BankRaw2 ] )

    , check(string_string_replace( BankRaw2, ` `, ``, BankStrip2 ))

    , trace( [ `Bank Stripped Space2` , BankStrip2 ] )

    , supplier_bank_code_2(BankStrip2)

    , trace( [ `Bank account Number` , supplier_bank_code_2 ] )  ]

     , q(0,1, line )

    , [generic_horizontal_details( [ [  tab, `IBAN` ], supplier_bank_iban_raw1, s1, newline ] )

    , check( supplier_bank_iban_raw1 = BankRaw3 )

    , trace( [ `Bank number raw3` , BankRaw3 ] )

    , check(string_string_replace( BankRaw3, ` `, ``, BankStrip3 ))

    , trace( [ `Bank Stripped Space3` , BankStrip3 ] )

    , supplier_bank_iban_2(BankStrip3)

    , trace( [ `Bank account Number3` , supplier_bank_iban_2 ] )  ]

   

    ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

 q(0,20,line)
	
   ,  or([
           
        generic_horizontal_details( [ [ `Rechnung`, tab, `:` ], invoice_number, d, newline ] )

         ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

 q(0,20,line)
	
   ,  or([
           
          generic_horizontal_details( [ [ `Datum`, tab, `:` ], invoice_date, date, newline ] )


         ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DELIVERY NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

    q(0,50,line)

    , or([

    
    generic_horizontal_details( [ [`Lieferung`, `/`, `Datum`, tab, `:` ], delivery_note_number, d, `/`] )

        ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q(0,50,line)

    , or([
      
      generic_horizontal_details( [ [`Ref`, `.`, `-`, `Nr`, `.`, `/`, `Datum`, tab, `:` ], order_number, d, `/` ] )


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

      generic_horizontal_details( [ [ `Bemessungsgrundlage`, `USt`, `.`, `(`, `A1`, `)`, tab ], total_net, d, newline ] )


        ])


    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    
    


	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

qn0(line)



    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,or([

         generic_horizontal_details( [ [`Mehrwertsteuer`, `(`, `A1`, `)`, `aus`, tab, dummy_num(d), tab, generic_item( [ default_vat_rate, d ] ), `,`, `00`, `%`, tab ], total_vat, d, newline ] )

        
             ])



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

	q0n(line)

  

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,or([

         generic_horizontal_details( [ [ `Gesamtwert`, `in`, generic_item( [ currency, w ] ), tab ], total_invoice, d, newline ] )

        ])


    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
	
]).




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

            		
		 [line_invoice_line, line_invoice_line1,q10(line_append_line),q10(line_dummy_line),q10(line_dummy_line),q10(line_dummy_line), line_net_line ]
             
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Pos`, tab, `Art`, `.`, `Nr`, `.`, `Beschreibung`]
      
      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([

      [`Summe`, `Positionen`, `in`, `EUR` ]


        ])

        , trace([`found the end line`])
    
] ).


%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)

      , generic_item( [ line_reference, d, tab ] )
    
      , generic_item( [ line_item, d , tab ] )

      , generic_item( [ line_quantity, d ] )

      , generic_item( [ line_quantity_uom_code, w, tab ] )

      , generic_item( [ line_dummy, s1, newline ] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule( line_invoice_line1, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)

      , generic_item( [ line_descr, s1, tab ] )
    
      , generic_item( [ line_descr_dummy, s1 , tab ] )

      , generic_item( [ line_unit_dummy, d,  [`EUR`, tab ] ] )

      , generic_item( [ line_net_dummy, d, newline ] )

      , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_dummy_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)

      , q10(generic_item( [ line_descr_dummy1, s1, tab ] ))
    
      , generic_item( [ line_descr_dummy2, s1 , tab ] )

      , generic_item( [ line_unit_dummy1, s1,  tab ] )

      , generic_item( [ line_net_dummy2, s1, newline ] )

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_net_line, [
%=======================================================================
	
        or([
            
            
            [`Positionsnetto`, tab ]

            , [`Preis`, `netto`, tab ]

            ] )
        
        
      , set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)


      , generic_item( [ line_unit_amount_dummy, d,  [`EUR`, tab ] ] )

      , generic_item( [ line_net_amount, d, newline ] )

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================
	
        generic_append( [ line_descr, s1, newline, ` `, ` ` ] )

    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGING CHARGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_line, [
%=======================================================================

	qn0(line)

   

   , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


   , generic_horizontal_details( [ [ `Verpackungspauschale`, `(`, `A1`, `)`, tab, dummy_num(d), tab, dummy_num1(d), `%`, tab ], line_net_amount, d, newline ] )

    , generic_item( [ line_descr, `Verpackungspauschale` ] )



    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    
 
	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORT/SHIPPING CHARGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_line1, [
%=======================================================================

	qn0(line)

   

   , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


   , generic_horizontal_details( [ [ `Frachtpauschale`, `(`, `A1`, `)`, tab, dummy_num3(d), tab, dummy_num4(d), `%`, tab ],line_net_amount, d, newline ] )

    , generic_item( [ line_descr, `Frachtpauschale` ] )



    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    
 
	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - March 12, 2018
% Updated by   - Rohini

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
