%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bardusch GmbH & Co.KG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_bardusch_gmbh, `14 June 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
      get_supplier_details

    , get_buyer_address 
   
    , set_credit_note   

    , get_bank_account_code

    , get_bank_account_no
  
    , get_bank_account_no1
	
	, get_invoice_number

    , get_order_number

    , get_set_consolidated_npo
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

    , get_contact_person

    , get_currency

    , get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    %,  get_freight_line 

    , get_line_net

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

     sender_name( `bardusch GmbH & Co.KG` )

    , supplier_party( `bardusch GmbH & Co.KG` )

    , supplier_vat_number(`DE811440472`) 

    , set(consolidate_lines_non_po)

       
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,30,line)

   , line_add_line

   , q(1,6,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       q0n(anything)
    
    , read_ahead([ `KSB` ])

     , trace( [ `Found address`] )

        , generic_item( [buyer_party_raw , s1, or([tab,newline]) ] )

      , or([
         
        [ check(buyer_party_raw = `KSB S.A.S`) ,generic_item( [ buyer_party, `KSB S.A.S.` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & CO KGAA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ]

        ,[ check(buyer_party_raw = `KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

         ,[ check(buyer_party_raw = Buyer_raw) ,generic_item( [ buyer_party, Buyer_raw ] ) ] 

    
        ])

   
] ).


%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

     or([

          [`76250`]

        , [`67206`]

        , [`67227`]

        , [`67206`, tab ]

        , [`91257`]

        , [ `92635`, `-`]

        , [`D`, `-`, `67206`]

        , [  `D`, `67206`]

        , [`A`, `-`, `1140`, tab ]

        , [`_`, tab, `67225`]

        , [`SK`, `82015`]

        , [`06110`]

        ,[`81249`]

        ,[`_`, tab, `81249`]

        , [`_`, `_`, tab, `67227`]

      ] )

      ,generic_item( [ buyer_city , w ,or([tab, newline]) ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

    last_line
   
   , q(0,100,up)

   ,[ generic_horizontal_details( [ [`(`, `BLZ`, generic_item( [ supplier_bank_code_raw, s, `)` ] ), generic_item( [ supplier_account_raw, s1, tab ] ), `(`, `BLZ`, generic_item( [ supplier_bank_code_raw1, s , `)` ] ), generic_item( [ supplier_account_raw1, s1, tab] ), `(`, generic_item( [ supplier_bank_code_raw2, s ,`)`] ) ], supplier_account_raw2, s1, newline ] )

         
   , check( supplier_bank_code_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_code(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_code ] ) 


    
    , check( supplier_account_raw = BankRaw1 )

    , trace( [ `Bank number raw1` , BankRaw1 ] )

    , check(string_string_replace( BankRaw1, ` `, ``, BankStrip1 ))

    , trace( [ `Bank Stripped Space1` , BankStrip1 ] )

    , supplier_bank_account_number(BankStrip1)

    , trace( [ `Bank account Number1` , supplier_bank_account_number ] ) 
    
    
    , check( supplier_bank_code_raw1 = BankRaw2 )

    , trace( [ `Bank number raw2` , BankRaw2 ] )

    , check(string_string_replace( BankRaw2, ` `, ``, BankStrip2 ))

    , trace( [ `Bank Stripped Space2` , BankStrip2] )

    , supplier_bank_code_2(BankStrip2)

    , trace( [ `Bank account Number2` , supplier_bank_code_2 ] ) 

    
    , check( supplier_account_raw1 = BankRaw3 )

    , trace( [ `Bank number raw3` , BankRaw3 ] )

    , check(string_string_replace( BankRaw3, ` `, ``, BankStrip3 ))

    , trace( [ `Bank Stripped Space3` , BankStrip3] )

    , supplier_bank_account_number_2(BankStrip3)

    , trace( [ `Bank account Number3` , supplier_bank_account_number_2 ] )
    
    
    , check( supplier_bank_code_raw2 = BankRaw4 )

    , trace( [ `Bank number raw4` , BankRaw4 ] )

    , check(string_string_replace( BankRaw4, ` `, ``, BankStrip4 ))

    , trace( [ `Bank Stripped Space4` , BankStrip4] )

    , supplier_bank_code_3(BankStrip4)

    , trace( [ `Bank account Number4` , supplier_bank_code_3 ] )
    
    
    , check( supplier_account_raw2 = BankRaw5 )

    , trace( [ `Bank number raw5` , BankRaw5 ] )

    , check(string_string_replace( BankRaw5, ` `, ``, BankStrip5 ))

    , trace( [ `Bank Stripped Space5` , BankStrip5] )

    , supplier_bank_account_raw4(BankStrip5)

    , trace( [ `Bank account Number5` , supplier_bank_account_raw4 ] )



    , check( supplier_bank_account_raw4 = BankRaw9 )

    , trace( [ `Bank number raw9` , BankRaw9 ] )

    , check(string_string_replace( BankRaw9, `-`, ``, BankStrip9 ))

    , trace( [ `Bank Stripped Space9` , BankStrip9] )

    , supplier_bank_account_number_3(BankStrip9)

    , trace( [ `Bank account Number9` , supplier_bank_account_number_3 ] )
    
    
    
    ]

    , q(0,1,line)

    , [generic_horizontal_details( [ [ `IBAN`, `:`, generic_item( [ supplier_iban_raw, s1 ] ), tab, `IBAN`, `:`, generic_item( [ supplier_iban_raw1, s1 ] ), tab, `IBAN`, `:` ], supplier_iban_raw2, s1, newline ] )

        
    , check( supplier_iban_raw = BankRaw6 )

    , trace( [ `Bank number raw6` , BankRaw6 ] )

    , check(string_string_replace( BankRaw6, ` `, ``, BankStrip6 ))

    , trace( [ `Bank Stripped Space6` , BankStrip6] )

    , supplier_bank_iban(BankStrip6)

    , trace( [ `Bank account Number6` , supplier_bank_iban ] )
    
    
    , check( supplier_iban_raw1 = BankRaw7 )

    , trace( [ `Bank number raw7` , BankRaw7 ] )

    , check(string_string_replace( BankRaw7, ` `, ``, BankStrip7 ))

    , trace( [ `Bank Stripped Space7` , BankStrip7] )

    , supplier_bank_iban_1(BankStrip7)

    , trace( [ `Bank account Number7` , supplier_bank_iban_1 ] )
    
    
    , check( supplier_iban_raw2 = BankRaw8 )

    , trace( [ `Bank number raw8` , BankRaw8 ] )

    , check(string_string_replace( BankRaw8, ` `, ``, BankStrip8 ))

    , trace( [ `Bank Stripped Space8` , BankStrip8] )

    , supplier_bank_iban_2(BankStrip8)

    , trace( [ `Bank account Number8` , supplier_bank_iban_2 ] )]

    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q(0,100,line)

    , or([
      
           find_order_number

      ])

] ).



%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,5,10) , end ] ] )

] ).


%=======================================================================
i_rule( get_set_consolidated_npo, [
%=======================================================================

     or([
         with( invoice, order_number, Po )

       , [ set(consolidate_lines_non_po)   , trace( [ `PO line not FOUND` ] )]

    ])
        
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
           
   generic_horizontal_details( [ [ `Rechnungsnummer`, `:`, tab ], invoice_number, d, newline ] )

   , [generic_horizontal_details( [ [ `Gutschriftsnummer`, `:`, tab ], invoice_number, d, newline ] ) , set(credit_note)  ]

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

 q(0,50,line)
	
   ,  or([
           
        generic_horizontal_details( [ [ `Rechnungsdatum`, `:`, tab ], invoice_date, date, newline ] )

        , generic_horizontal_details( [ [ `Gutschriftsdatum`, `:`, tab ], invoice_date, date, newline ] )

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

      generic_horizontal_details( [ [ `LIEFERORT`, `:` ], delivery_note_number, d ] )


        ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DELIVERY NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_net, [
%=======================================================================

    last_line, q(0,100,up)

    , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    , or([

      generic_horizontal_details( [ [ `Energiekostenzuschlag`, tab, a(s1), tab ], line_net_amount, d , [`EUR`,  newline] ] )




        ])

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

    ,line_descr(`Energiekostenzuschlag - 2,8  % `)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_net_amount, [
%=======================================================================

	last_line, q(0,500,up)
  
    ,check_text(`Nettobetrag`)

    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,or([

         generic_horizontal_details( [ [gen_beof,`Nettobetrag`, tab ], total_net, d, [q10(tab),generic_item( [ currency, w ] ),  newline ] ] )


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
i_rule_cut( get_total_vat, [
%=======================================================================

    last_line, q(0,500,up)

    , check_text(`+`)
  
   , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,or([

        generic_horizontal_details( [ [ `Mehrwertsteuer`, generic_item( [ default_vat_rate, d , `%` ] ), q10(tab), `(`, a(d), `EUR`, `)`, tab ], total_vat, d, [q10(tab),`EUR`,  newline ] ] )

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

    last_line, q(0,500,up)
  
    ,check_text(`Bruttobetrag`)
  
    , [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

     ,or([

       generic_horizontal_details( [ [gen_beof,`Bruttobetrag`, tab ], total_invoice, d, [q10(tab),`EUR`,  newline ] ] )

    , generic_horizontal_details( [ [`Gutschriftsbetrag`, `(`, `brutto`, `)` ], total_invoice, d, [q10(tab),`EUR`,  newline ] ] )


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

           %line_invoice_rule

           line_skip_line

           , [test(credit_note), line_credit_line1, line_descr_line]

           , line_invoice_line_Tragernr

           , line_invoice_line_new

            , or([line_invoice_line3(1,-430,500), gen_line_nothing_here( [ -430, 10, 10 ] ) ] )

            
           , line_invoice_line4

           
                 
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	

        or([

        [`Artikel`, `Bezeichnung`]

        , [a(s1), tab, `Artikel`, `Bezeichnung`, tab]

        ,[`Artikel`, `-`, `Nummer`, `Bezeichnung`]


       ] )

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================
    
    or([

       [`Sparkasse`, `Karlsruhe`, `Ettlingen`, tab ]

       , [`Summe`, `Kostenstelle`]

       , [ `Nettobetrag`, tab ]

       , [`Artikel`, `Bezeichnung`]


] )
        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule_cut( line_skip_line,[
%=======================================================================

	or( [

        [ a(s1), tab, a(s1), newline ]

       
    ] )
    
] ).


%=======================================================================
i_rule_cut( line_invoice_rule,[
%=======================================================================

    
    or( [

            line_invoice_line3(1,-430,500)

            , [line_invoice_line(1,-430,500), line_invoice_line1]

           , line_invoice_line2(1,-430,500)  
             
	] )
    
] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)


      , generic_item( [ line_item, d ] )

       , generic_item( [ line_descr, s1, tab ] )

       , generic_item( [ line_descr_dummy, s1, newline ] )

              , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================
	
	
set(regexp_cross_word_boundaries)

, set(reverse_punctuation_in_numbers)

, generic_append( [ line_descr, s1, tab, ` `, ` `  ] )

, generic_item( [ line_dummy, d, tab ] )

, generic_item( [ line_dummy1, d, tab ] )

, generic_item( [ line_dummy2, d, tab ] )

, generic_item( [ line_dummy3, d, tab ] )

, generic_item( [ line_quantity, d, [a(w), tab] ] )
    
, generic_item( [ line_unit_amount, d, [`EUR`, tab ] ] )

, generic_item( [ line_net_amount, d, [ `EUR`,  newline ] ] )

, clear(reverse_punctuation_in_numbers)

 , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_new, [
%=======================================================================
		
set(regexp_cross_word_boundaries)

, set(reverse_punctuation_in_numbers)

, a(d), tab 

, generic_item( [ line_descr, s1, tab ] )

, generic_item( [ line_quantity, d, [a(w), tab] ] )
    
, generic_item( [ line_unit_amount, d, [`EUR`, tab ] ] )

, generic_item( [ line_net_amount, d, [ q10(tab), `EUR`,  newline ] ] )

, clear(reverse_punctuation_in_numbers)

 , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_credit_line1, [
%=======================================================================
	
	
set(regexp_cross_word_boundaries)

, set(reverse_punctuation_in_numbers)


, generic_item( [ line_dummy, d, tab ] )

, generic_item( [ line_dummy1, d, tab ] )

, generic_item( [ line_item, w, tab ] )

, generic_item( [ line_quantity_dummy, d, tab ] )
    
, generic_item( [ line_net_amount, d, [ `EUR`,  newline ] ] )

, clear(reverse_punctuation_in_numbers)

 , clear(regexp_cross_word_boundaries)

    
] ).



%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================
	
set(regexp_cross_word_boundaries)

, set(reverse_punctuation_in_numbers)

, generic_item( [ line_dummy5, d, tab ] )

, generic_item( [ line_descr, d, tab ] )

, generic_item( [ line_item, s1, tab ] )

, generic_item( [ line_date, date, tab ] )

, generic_item( [ line_dummy6, d, tab ] )

, generic_item( [ line_net_amount, d, [`EUR`, newline ] ] )

, clear(reverse_punctuation_in_numbers)

, clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================
	

      set(regexp_cross_word_boundaries)

    , set(reverse_punctuation_in_numbers)

    , or([

        read_ahead([ `Garnitur`])

        , read_ahead([ `Anzahl`])

    ])

    , generic_item( [ line_descr, w, tab ] )

    , generic_item( [ line_dummy, d, tab ] )

    , generic_item( [ line_dummy2, d, tab ] )

    , generic_item( [ line_dummy3, d, tab ] )

    , generic_item( [ line_dummy4, d, tab ] )

    , q10( generic_item( [ line_dummy5, d, tab ] ) )
    
    , generic_item( [ line_quantity, d, [a(w), tab] ] )
    
    , generic_item( [ line_unit_amount_dummy, d, [`EUR`, tab ] ] )

    , generic_item( [ line_net_amount, d, [ q10(tab), `EUR`,  newline ] ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_Tragernr, [
%=======================================================================
	

      set(regexp_cross_word_boundaries)

    , set(reverse_punctuation_in_numbers)
   
    , generic_item( [ line_descr, d, tab ] )

    , generic_append( [ line_descr, d, tab, `Barcode - `, ` `  ] )

    , generic_item( [ line_item, w, tab ] )

    , generic_item( [ line_date, date, tab ] )

    , generic_item( [ line_dummy3, d, tab ] )
    
    , generic_item( [ line_net_amount, d, [ q10(tab), `EUR`,  newline ] ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================
	
	
        set(regexp_cross_word_boundaries)

       , set(reverse_punctuation_in_numbers)

      , generic_item( [ line_descr, w, tab ] )

      , set(regexp_allow_partial_matching)

      , generic_item( [ line_quantity_dummy, d ,[ a(w),tab ]] )

       , clear(regexp_allow_partial_matching)
    
      , generic_item( [ line_unit_amount, d, [`EUR`, tab ] ] )

            , generic_item( [ line_net_amount, d, [ `EUR`,  newline] ] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

 generic_append( [ line_descr, s1, newline, ` `, ` `  ] )

    
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - March 9, 2018
% Updated by   - Rohini


% Updated on   - 30 may 2018
% Updated by   - Thejaswi
% Changes made   - Line level

% Updated on   - 14 June 2018
% Updated by   - THejaswi K
% Changes made   - line level capture


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
