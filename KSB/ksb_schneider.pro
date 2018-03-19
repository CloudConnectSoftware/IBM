%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCHNEIDER ELECTRIC GMBH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_schneider, `14 February 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( x_tolerance_100, 100 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

    ,set_credit_note

    , get_bank_account_code
  
    , get_bank_account_no
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr


    , get_currency

    ,get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    ,  get_freight_line

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `SCHNEIDER ELECTRIC GMBH` )

    ,supplier_party( `SCHNEIDER ELECTRIC GMBH` )

    , supplier_vat_number(`DE 225 673 854`)
    
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,20,line)

   , line_add_line

   , q(1,3,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB` ])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party , s1, tab ] )
   
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      `D-67206`

      ,generic_item( [ buyer_city , s1 , tab ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,20,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)


    , [`Rechnungskorrektur`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

   q(0,50,line)
	

   ,  [generic_horizontal_details( [ [ `Deutsche`, `Bank`, `AG`, generic_item( [ supplier_bank_account_number, s ] ), `(`, `BLZ` ], supplier_bank_code_raw, s, [`)`,  newline ] ] )
     
     
      , check( supplier_bank_code_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_code(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_code ] )  ]
   

  ] ).  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,25,line)
	
   ,  or([
        
        generic_vertical_details( [ [  `Nummer`, tab ], `Nummer`, q(0,1), (start,100,100), invoice_number, d, tab ] )

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

q(0,25,line)
	
   ,  or([
        
         generic_vertical_details( [ [  `Datum`, tab ], `Datum`, q(0,1), (start,50,100), invoice_date, date, tab ] )

        ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DELIVERY NOTE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

    q(0,30,line)

    , or([
      
      generic_horizontal_details( [ [`Lieferschein`, `:` ], delivery_note_number, d, `/` ] )

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

    q(0,30,line)

    , or([
      
      generic_horizontal_details( [ [`Ihre`, `Bestellnummer`, `:` ], order_number, d, `/` ] )

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

     ,or([

    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [ `Netto`, `Warenwert`, tab  ], total_net, d, newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    
    
    ])

	
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

     ,or([

         [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


      ,  generic_horizontal_details( [ [ `MWST`, `-`, `Betrag`, tab, `19`, `,`, `00`, tab, `%`, tab, dummy_num(d), tab ], total_vat, d, newline ] )

    , generic_item( [ default_vat_rate, `19` ] )
    

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    ])

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

     ,or([
  
    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,  generic_horizontal_details( [ [`Rechnungsbetrag`, tab ], total_invoice, d, [tab, generic_item( [ currency, w ] ),  newline ] ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
        ])
	
	
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

            		
			[line_invoice_line1,q10(line_descr_line),line_invoice_line]

           , [line_invoice_line1,q10(line_descr_line),line_credit_note_line, line_credit_net_line]
           

			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`R`, `.`, `Pos`, `.`, tab, `A`, `.`, `Pos`, `.`, tab, `Material`]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [`Netto`, `Warenwert`, tab ]


        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_dummy, s1 , tab ])

      , generic_item([ line_unit_amount, d ,[`EUR`, tab ] ])

      , generic_item([ line_quantity_dummy, d , tab ])

       , generic_item([ line_quantity_uom, w , tab ])

       , generic_item([ line_net_amount , d , tab ] )

        , generic_item([ line_dummy_1 , w , newline ] )

            
      , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )
       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_invoice_line1, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_number, d  ])

      , generic_item([ line_number1, d , tab ])

      , generic_item([ line_item, d ,tab ])

      , generic_item([ line_quantity, d , tab ])

       , generic_item([ line_quantity_uom_code , w, newline  ] )

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_descr_line, [
%=======================================================================

        generic_item([ line_descr,s1 ,tab ])

     ,  generic_append( [ line_descr , s1, newline, `  `, ``  ] )
        
] ).



%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================

     generic_append( [ line_descr , s1, newline, `  `, ``  ] )
        
] ).

%=======================================================================
i_line_rule( line_credit_note_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_dummy, s1 , tab ])

      , generic_item([ line_unit_amount_dummy1, d ,[`-`, `%`, tab ] ])

       , generic_item([ line_discount_amount_dummy , d , [`-`,newline] ] )

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_credit_net_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_dummy1, s1 , tab ])

      , generic_item([ line_net_amount, d ,newline ])

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - February 14, 2018
% Updated by   - Rohini

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
