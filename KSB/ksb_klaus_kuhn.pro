%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Klaus Kuhn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_klaus_kuhn, ` 24 Feb 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

    ,set_credit_note

   % ,  get_buyer_address2

    , get_bank_account_no

    , get_iban_no
	
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
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `KLAUS KUHN` )

    ,supplier_party( `KLAUS KUHN` )

    , supplier_vat_number(`DE 811216379`)
    
    , set(reverse_punctuation_in_numbers)

      
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


    , [`Gutschrift`]

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
  
     q(0,20,line)

   , line_add_line

   , q(1,7,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB`])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party_raw , s1 , or([tab, newline]) ] )

     , or([
         
        [ check(buyer_party_raw = `KSB S.A.S`) ,generic_item( [ buyer_party, `KSB S.A.S.` ] ) ] 

        ,[ check(buyer_party_raw = `KSB DIVISION SERVICES`) ,generic_item( [ buyer_party, `KSB SAS` ] ) ]

        ,[ check(buyer_party_raw = `KSB SE & Co.KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

         ,[ check(buyer_party_raw = Buyer_raw) ,generic_item( [ buyer_party, Buyer_raw ] ) ] 

    
        ])
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      generic_item( [ buyer_postcode , [ begin, q(dec,5,6) , end ]  ] )

      ,or([
          generic_item( [ buyer_city , w , or([tab,newline]) ] )

          ,generic_item( [ buyer_city , w , dummy_city(w) ] )

      ])


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

  last_line

  ,q(0,50,up)

 , generic_horizontal_details( [ [`(`, `BLZ`, generic_item( [ code_1,s ] ), `)`, generic_item( [ bank_1,s1 ] ), tab, `(`, `BLZ`, generic_item( [ code_2,s ] ), `)`, generic_item( [ bank_2,s1 ] ), tab, `(`, `BLZ` ],  code_3, s, [`)`,generic_item( [ bank_3,s1 ] ),newline] ] )
 
, check(bank_1  =SupbNo) ,check(strip_string2_from_string1( SupbNo, ` `, SupNobNew )) ,supplier_bank_account_number(SupNobNew) , trace( [ `New Bank acc`, supplier_bank_account_number ] )

    , check(code_1  =SupNo) ,check(strip_string2_from_string1( SupNo, ` `, SupNoNew ))  ,supplier_bank_code(SupNoNew) , trace( [ `New Bank acc code `, supplier_bank_code ] )
     
    , check(bank_2  =SupbNo2) ,check(strip_string2_from_string1( SupbNo2, ` `, SupNobNew2 )) ,supplier_bank_account_number_2(SupNobNew2) , trace( [ `Ne Bank acc 2`, supplier_bank_account_2 ] )

    , check(code_2  =SupNo2) ,check(strip_string2_from_string1( SupNo2, ` `, SupNoNew2 ))  ,supplier_bank_code_2(SupNoNew2) , trace( [ ` New Bank acc code 2`, supplier_bank_code_2 ] )
     
    , check(bank_3  =SupbNo3) ,check(strip_string2_from_string1( SupbNo3, ` `, SupNobNew3 )) ,supplier_bank_account_number_3(SupNobNew3) , trace( [ `New Bank acc 3`, supplier_bank_account_number_3 ] )

    , check(code_3  =SupNo3) ,check(strip_string2_from_string1( SupNo3, ` `, SupNoNew3 ))  ,supplier_bank_code_3(SupNoNew3) , trace( [ `New Bank acc code 3`, supplier_bank_code_3 ] )
     

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_iban_no, [
%=======================================================================

 last_line

  ,q(0,50,up)

 , generic_horizontal_details( [ [`IBAN`, `:`,  generic_item( [ iban_1,s1 ] ), tab, `IBAN`, `:`, generic_item( [ iban_2,s1 ] ),tab, `IBAN`, `:` ],  iban_3, s1, newline ] )
 
 
   , check(iban_1  =SupibNo) ,check(strip_string2_from_string1( SupibNo, ` `, SupiNobNew )) ,supplier_bank_iban(SupiNobNew) , trace( [ `New iban acc`, supplier_iban ] )

  
    , check(iban_2  =SupibNo2) ,check(strip_string2_from_string1( SupibNo2, ` `, SupiNobNew2 )) ,supplier_bank_iban_2(SupiNobNew2) , trace( [ `Ne iban acc 2`, supplier_iban_2 ] )

       
    , check(iban_3  =SupibNo3) ,check(strip_string2_from_string1( SupibNo3, ` `, SupiNobNew3 )) ,supplier_bank_iban_3(SupiNobNew3) , trace( [ `New iban acc 3`, supplier_iban_3 ] )

   
     

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,30,line)
	
   ,  or([

       generic_horizontal_details( [[`Rechnung` ], invoice_number, s1,  newline ] )

       ,generic_horizontal_details( [[`Gutschrift` ], invoice_number, s1, newline ] )

       ,generic_horizontal_details( [[`Gutschrift` ], invoice_number, s1,  newline ] )
       

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
        generic_horizontal_details( [ [ `Ihre`, `Bestell`, `-`, `Nr`, `.`, `:`, tab ], order_number, d,or([ `/` ,newline]) ] )

         ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Delivery Note
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

    q(0,100,line)

    ,or([
        generic_horizontal_details( [ [`Lieferschein`, `-`, `Nr`, `.`, `:`, tab ], delivery_note_number, w ] )

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
q(0,50,line)
	
	, generic_horizontal_details( [ [ `datum`, `:`, q10(tab)], invoice_date, date, newline ] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL VAT & NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================



	qn0(line)

    ,or([

        [set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Mehrwertsteuer`,  dummy_vat_rate(d), `%`],200, total_vat, d,  newline ] )

    ,clear(regexp_cross_word_boundaries)]

    ])
	
	
]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Net
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_net_amount, [
%=======================================================================

qn0(line)

,or([

    [set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Gesamtwert`,`netto`],200, total_net, d,  newline ] )

    ,clear(regexp_cross_word_boundaries)]

    ,[set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Warenwert`],200, net_subtotal_1, d,  newline ] )

    ,q(0,1,line)

    , generic_horizontal_details( [ [ `Verpackung`],200, net_subtotal_2, d,  newline ] )

    ,clear(regexp_cross_word_boundaries)]


])
	
	
]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================



	qn0(line)

    ,or([

        [set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Endsumme`],200, total_invoice, d, newline ] )

    ,clear(regexp_cross_word_boundaries)]

        ])

	
	
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================



	q0n(line)

    ,or([

       
    generic_vertical_details( [ [ `netto` ], `netto`, q(0,1), (end,10, 20), currency_raw, w, [`]`,newline] ] )

    

        ])

        ,check(currency_raw=CurrencyRaw)
    
    , check(strip_string2_from_string1( CurrencyRaw, `[]`, CurrencyNew ))

    ,currency(CurrencyNew), trace( [ `New Curency`, currency ] )

	
	
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
		
			[line_invoice_line, q10(line_invoice_item), q10(line_invoice_descr),q10(line_invoice_descr),q10(line_invoice_descr) ]

            ,line_invoice_line2
  
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([
        [`Pos`, `.`, tab, `Artikel`,tab, `Menge`]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [`Warenwert`]

         ,[`Klaus`, `Kuhn`, `Edelstahlgießerei`, `GmbH`]

        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
     

        generic_item([ line_reference , w , tab ])

      , generic_item([ line_descr , s1 , tab ])
      
       , set(regexp_cross_word_boundaries)

       ,generic_item([ line_quantity , d ,q10(tab) ])

       , generic_item([ line_quantity_uom_code ,w, q10(tab) ] )

      , generic_item([ line_unit_amount ,d,  `/` ] )

      , generic_item([ line_unit_amount_dummy ,w,  tab ] )
  
      , generic_item([ line_net_amount ,d,  newline ] )
      
       , clear(regexp_cross_word_boundaries)

        
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

       , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       
       ])
     
    
] ).


%=======================================================================
i_line_rule( line_invoice_descr, [
%=======================================================================

    q10(generic_append( [ line_descr, w, tab, ` `, ``  ] ))
	
     ,generic_append( [ line_descr, s1, newline, ` `, ``  ] )
        
] ).

%=======================================================================
i_line_rule( line_invoice_item, [
%=======================================================================
	    
     generic_append( [ line_descr, s, `:`, ` `, ``  ] )
     , [
      generic_item( [line_item_raw,w, tab ] ), 

      check(line_item_raw=Line_Item), line_item(Line_Item),

      generic_append( [ line_descr,Line_Item, ` `, ``  ] )
 
      ]

      , generic_append( [ line_descr_dummy, s1, newline, ` `, ``  ] )
    
    
] ).

%=======================================================================
i_line_rule( line_invoice_line2, [
%=======================================================================
	
     
        read_ahead([ `Attestkosten`])

      , generic_item([ line_descr , s1 , tab ])
      
       , set(regexp_cross_word_boundaries)
 
      , generic_item([ line_net_amount ,d,  newline ] )
      
       , clear(regexp_cross_word_boundaries)

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

       , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       
       ])
     
    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Freight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_line, [
%=======================================================================

    q(0,200,line)

    , freight_line

    , q(0,1,line)

    , shipping_line

    
] ).
%=======================================================================
i_line_rule( freight_line, [
%=======================================================================

q0n(anything)

    ,read_ahead([ `Verpackung`])

    , generic_item([ line_descr , s1 , tab ])
      
     , set(regexp_cross_word_boundaries)
 
     , generic_item([ line_net_amount ,d,  newline ] )
      
     , clear(regexp_cross_word_boundaries)

    , trace( [ `Freight Note Found` ] )

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

       , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       
       ])

       , generic_item( [ line_buyers_order_number, `FC` ] )

] ).


%=======================================================================
i_line_rule( shipping_line, [
%=======================================================================

q0n(anything)

    ,read_ahead([ `Versand`])

    , generic_item([ line_descr , s1 , tab ])
      
     , set(regexp_cross_word_boundaries)
 
     , generic_item([ line_net_amount ,d,  newline ] )
      
     , clear(regexp_cross_word_boundaries)

    , trace( [ `Freight Note Found` ] )

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

       , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       
       ])

       , generic_item( [ line_buyers_order_number, `FC` ] )

] ).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - January 30, 2018
% Updated by   - Thejaswi

% Updated on   - Feb 24, 2018
% Updated by   - Thejaswi
% Updates      - Bank details

% Updated on   - march , 2018
% Updated by   - Thejaswi
% Changes made - Line capture

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
