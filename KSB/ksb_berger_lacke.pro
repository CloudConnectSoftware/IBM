%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berger-Lacke GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_berger_lacke, `5 February 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

    ,set_credit_note

    , get_attention
  
    , get_bank_account_no
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

	, get_total_invoice

    , get_currency

    , get_net_amount

    , get_total_vat

    , get_invoice_lines

    , get_freight_line

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `Berger-Lacke GmbH` )

    ,supplier_party( `Berger-Lacke GmbH` )

    , supplier_vat_number(`DE149695428`)
    
    , set(reverse_punctuation_in_numbers)

          
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Attention Name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_attention, [
%=======================================================================

    q(0,50,line)

    , or([

      generic_horizontal_details( [ [ `Sachbearbeiter`, `:` ],  attention_of, s, [phone_dummy(s1),newline] ] )


        ])

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

    , `G`, `u`, `t`, `s`, `c`, `h`, `r`, `i`, `f`, `t`

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,9,line)

   , line_add_line

   , q(0,6,line)

   , line_add_line1

   , q(0,5,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

     ,  read_ahead([`Berger`])

     , trace( [ `Found address`] )

] ).

%=======================================================================
i_line_rule( line_add_line1, [
%=======================================================================

    q0n(anything)

     ,  read_ahead([`KSB`])

     , trace( [ `Found address Buyer`] )

     , generic_item( [buyer_party , s1, tab ])

] ).


%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================
      q0n(anything)

      , or([
          `67206`
          ,`92635`

      ])

      ,or([
          
          generic_item( [ buyer_city , w , `cedex` ] )

          , generic_item( [ buyer_city , w , or([newline,tab]) ] )

      ])


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================
last_line

 ,q(0,200,up)

 , or([

       generic_horizontal_details( [ [  `IBAN`], supplier_bank_iban, w, newline ] )
 
 ])

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,25,line)
	
   ,  or([
        
        generic_horizontal_details( [ [ `Rechnungs`, `-`, `Nr`, `.`, `:`, tab ], 100, invoice_number, d, newline] )

        ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q(0,50,line)

    , or([

      generic_horizontal_details( [ [ `Bestellung`, `Nr`, `.` ],  order_number, d, `V` ] )
     
     , find_order_number

    ])

] ).


%=======================================================================
i_line_rule( find_order_number, [
%=======================================================================

    q0n(anything)

    , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,5,15) , end ] ] )

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Delivery Note
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

    q(0,50,line)

    ,or([
        
        generic_horizontal_details( [ [`Lieferanten`, `-`, `Nr`, `.`, tab], delivery_note_number, d, `du` ] )

        ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

q(0,25,line)

, generic_horizontal_details( [ [ `Rechnungsdatum`, `:`, tab ], invoice_date, date, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

q0n(line)

,set(regexp_cross_word_boundaries)

    ,or([
    
    
    generic_vertical_details( [ [ `%`,`MWST` ], `MWST`, q(0,10), (end,60,60), total_vat, d, tab ] )

    ])
    
    ,clear(regexp_cross_word_boundaries)

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_net_amount, [
%=======================================================================

	q0n(line)


    ,set(regexp_cross_word_boundaries)

    ,or([
   
    generic_vertical_details( [ [ `Nettosumme` ], `Nettosumme`, q(0,1), (start,60,60), total_net, d, tab ] )

    ])
    
    ,clear(regexp_cross_word_boundaries)

   
  	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	q0n(line)

    , set(regexp_cross_word_boundaries)

    ,or([

    generic_vertical_details( [ [ `Rechnungssumme`, q10(`€`) ], `Rechnungssumme`, q(0,1), (end,100,100), total_invoice, d, newline ] )

    ])
    
    ,clear(regexp_cross_word_boundaries)

    
	
	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Currency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

	q0n(line)

    ,or([
 
    [generic_horizontal_details( [ [ `Rechnungssumme` ], currency_raw, w, newline ] )

    , check(currency_raw=Currency) , check(Currency=`€ uros`)    ,generic_item( [ currency, `EUR` ] )]

    , [generic_horizontal_details( [ [ `Rechnungssumme` ], currency_raw, w, newline ] )

    , check(currency_raw=Currency) , check(Currency=`€`)    ,generic_item( [ currency, `EUR` ] )]


    , currency_line

          ])
	
]).

%=======================================================================
i_line_rule( currency_line, [
%=======================================================================

    q0n(anything)

   , currency(`EUR`)

] ).


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
            		
			 
             [ test(credit_note), line_credit_line ]

             , line_invoice_line1 

             , line_invoice_line


			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [ `Pos`, `.`, `Artikel`, `-` ]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [`Zwischensumme` ]

         , [ `Pos`, `.`, `Artikel`, `-` ]

        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
        set(reverse_punctuation_in_numbers)

        , set(regexp_cross_word_boundaries)

        ,generic_item([ line_reference , d  ])

        ,or([
            generic_item([line_item , w ,  [q10(tab), check(line_item(end)< -295)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -299)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -301)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -397)]  ] )

        ])

        ,generic_item([line_descr , s1,tab ] )

        , q10(generic_item([line_quantity_dummy1, s1, tab  ] ))

        , q10(generic_item([line_quantity_dummy2, s1, tab ] ))

        , q10( generic_item([line_quantity, d, tab ] ) )

        , generic_item([line_unit_dummy, d ,[ q10([a(w) ] ), tab]  ] )
       
       , generic_item([ line_net_amount , d , newline ] )

       ,clear(regexp_cross_word_boundaries)

       ,clear(reverse_punctuation_in_numbers)

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
         
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================
	
        set(reverse_punctuation_in_numbers)

        , set(regexp_cross_word_boundaries)

        ,generic_item([ line_reference , d  ])

        ,or([
            generic_item([line_item , w ,  [q10(tab), check(line_item(end)< -295)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -299)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -301)]  ] )

            , generic_item([line_item , w , [ q10(tab), check(line_item(end)< -397)]  ] )

        ])

        ,generic_item([line_descr , s1,tab ] )

        , q10(generic_item([line_quantity_dummy2, s1, tab ] ))

        , q10( generic_item([line_quantity, d, tab ] ) )

        , generic_item([line_unit_dummy, d ,[ q10([a(w) ] ), tab]  ] )
       
       , generic_item([ line_net_amount , d , newline ] )

       ,clear(regexp_cross_word_boundaries)

       ,clear(reverse_punctuation_in_numbers)

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
         
] ).

%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================
	
        set(reverse_punctuation_in_numbers)

        , set(regexp_cross_word_boundaries)

        ,generic_item([ line_reference , d  ])

        , or( [ generic_item([line_item , w , [q10(tab), check(line_item(end) < -284)  ]  ] )

        , generic_item([line_item , w , [q10(tab), check(line_item(end) < -397)  ]  ] )

        ] )

        ,generic_item([line_descr , s1,tab ] )

        ,generic_item([line_quantity_dummy1, d, [a(w),tab]  ] )

        , generic_item([line_quantity, d , tab  ] )

        ,generic_item([line_quantity_dummy3, d  ] )

        ,generic_item([line_unit_dummy ,d, tab  ] )

       , generic_item([ line_net_amount , d , newline ] )


       ,clear(regexp_cross_word_boundaries)

       ,clear(reverse_punctuation_in_numbers)

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
         
] ).

%=======================================================================
i_line_rule_cut( line_descs_line, [
%=======================================================================
	
        generic_append( [ line_descr , s1, tab, ` , `, ``  ] )
        ,generic_append( [ line_descr , s1, newline, ` , `, ``  ] )
        
] ).

%=======================================================================
i_line_rule_cut( line_descs_append, [
%=======================================================================
	
        generic_append( [ line_descr , s1, newline, ` , `, ``  ] )
        
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLING/SHIPPING CHARGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_line, [
%=======================================================================
    
    set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)
     
     , q(0,100,line) 

     , check_text(`FRACHT`)

   , generic_vertical_details( [ [ `FRACHT` ], `FRACHT`, q(0,2), (end,500,50), line_net_amount, d, tab ] )

    , generic_item( [ line_descr, `FRACHT` ] )

    , clear(reverse_punctuation_in_numbers)  , clear(regexp_cross_word_boundaries)

   % , line_vat_rate(`19`)

    	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - Feb 5s, 2018
% Updated by   - Thejaswi

% Updated on   - Feb 23, 2018
% Updated by   - Thejaswi
% Updates     - Bank details

% Updated on   - Sep 20, 2018
% Updated by   - Rohini
% Updates     - Line quantity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
