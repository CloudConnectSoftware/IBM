%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KTR Systems GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_ktr_systems, `12 February 2018` ).

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

    , get_delivery_note_nr

	, get_total_invoice

    , get_currency

    ,get_net_amount

    , get_total_vat

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

    sender_name( `KTR Systems GmbH` )

    ,supplier_party( `KTR Systems GmbH` )

    , supplier_vat_number(`DE811295751`)
    
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,10,line)

   , line_add_line

   , q(1,3,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB`])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party , s1, tab ] )
   
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      `67206`

      ,generic_item( [ buyer_city , s1 , tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK Details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

   q(0,50,line)
	

   ,  [generic_horizontal_details( [ [ `Commerzbank`, `AG`, `Rheine`, tab, generic_item( [ supplier_bank_code, s1 ] ), tab, `DE70` ],  supplier_bank_account_number_raw, s1, newline ] )
     
     
      , check( supplier_bank_account_number_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_account_number(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_account_number ] )  ]

    ,   q(0,1,line)
	

   ,  [generic_horizontal_details( [ [ `Deutsche`, `Bank`, `AG`, `Rheine`, tab, generic_item( [ supplier_bank_code_2, s1 ] ), tab, `DE93` ],  supplier_bank_account_number_raw1, s1, newline ] )
     
     
      , check( supplier_bank_account_number_raw1 = BankRaw1 )

    , trace( [ `Bank number raw1` , BankRaw1 ] )

    , check(string_string_replace( BankRaw1, ` `, ``, BankStrip1 ))

    , trace( [ `Bank Stripped Space1` , BankStrip1 ] )

    , supplier_bank_account_number_2(BankStrip1)

    , trace( [ `Bank account Number1` , supplier_bank_account_number_2 ] )  ]

   , q(0,1,line)
	

   ,  [generic_horizontal_details( [ [ `Stadtsparkasse`, `Rheine`, tab, generic_item( [ supplier_bank_code_3, s1 ] ), tab, `DE49` ],  supplier_bank_account_number_raw2, s1, newline ] )
     
     
      , check( supplier_bank_account_number_raw2 = BankRaw2 )

    , trace( [ `Bank number raw2` , BankRaw2 ] )

    , check(string_string_replace( BankRaw2, ` `, ``, BankStrip2 ))

    , trace( [ `Bank Stripped Space2` , BankStrip2 ] )

    , supplier_bank_account_number_3(BankStrip2)

    , trace( [ `Bank account Number2` , supplier_bank_account_number_3 ] )  ]


]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,15,line)
	
   ,  or([
        
        generic_horizontal_details( [ [`Rechnungsnummer`, tab ],  invoice_number, d, [`vom`] ] )

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

q(0,15,line)
	
   ,  or([
        
        generic_horizontal_details( [ [ `Rechnungsnummer`, tab, dummy_num(d), `vom` ], invoice_date, date, newline ] )

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

    q(0,20,line)

    , or([
      
      generic_horizontal_details( [ [ `Bestellnummer`, tab ], order_number, d, tab ] )

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

    q(0,20,line)

    ,or([
        
        generic_horizontal_details( [ [ `Lieferschein`, `/`, `Lieferdatum` ], delivery_note_number, d, `/` ] )

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

    ,  generic_horizontal_details( [ [ `Nettowarenwert`, tab ], total_net, d, newline ] )

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


    , generic_horizontal_details( [ [ `MwSt`, tab, `19`, `,`, `00`, `%`, tab ], total_vat, d, newline ] )

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

    ,   generic_horizontal_details( [ [ `Endbetrag`, tab ], total_invoice, d, [`EUR`,  newline ] ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
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

	q0n(line)


    , generic_horizontal_details( [ [ `Währung`, `:`, tab ],currency, w, newline ] )

	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

	line_start_line
	
	,qn0( [ peek_fails(line_end_line)
		
		,or( [

            		
			[line_invoice_line, q10(line_append_line)]

            
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Pos`, `.`, tab, `Kundenmaterial`, tab ]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [ `KTR`, `Systems`, `GmbH`, tab  ]


        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_number , d ,tab ])

       , generic_item([ line_item , d ,tab ])

       , generic_item([ line_descr ,s1, tab ])

       , generic_item([ line_quantity , d  ])

       , generic_item([ line_quantity_uom_code , w, tab  ])

       , generic_item([ line_unit_amount , d, tab  ])

        , generic_item([ line_quantity_dummy , s1, tab  ])

        , generic_item([ line_net_amount ,d , newline ] )

              
      , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================

     generic_item([ line_number_dummy , d ,tab ])

    , generic_append( [ line_descr , s1, newline, `  `, ``  ] )
        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - February 12, 2018
% Updated by   - Rohini

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
