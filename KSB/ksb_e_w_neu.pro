%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EagleBurgmann Germany
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_e_w_neu, ` 30 January 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

     , get_iban_no

    , get_supplier_bank_account_no

    ,set_credit_note
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_delivery_note_nr

	, get_total_invoice

    , get_currency

    , get_total_vat

    , get_invoice_lines

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `E.W. NEU GmbH` )

    ,supplier_party( `E.W. NEU GmbH` )

    , supplier_vat_number(`DE811239368`)
    
    , set(reverse_punctuation_in_numbers)

      
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

   , q(1,2,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB`])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party , s1 , [q10(tab),q10(`*`), newline] ] )
   

] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

       generic_item( [ buyer_address_dummy, d ] )

     , generic_item( [ buyer_city, w, tab ] )


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

    , [ `Rechnungskorrektur`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_supplier_bank_account_no, [
%=======================================================================

q(0,100,line)

 ,  [generic_horizontal_details( [ [  `Volksbank`, `Alzey`, `-`, `Worms`, `eG`, `Nr`, `.` ],  bank_raw, s, [`,`, `BLZ`, generic_item( [ code_raw, s1 ] ), newline ] ] )
  
    , check(bank_raw  =SupbNo) ,check(strip_string2_from_string1( SupbNo, ` `, SupNobNew )) ,supplier_bank_account_number(SupNobNew) , trace( [ `New Bank acc`, supplier_bank_account_number ] )

    , check(code_raw  =SupNo) ,check(strip_string2_from_string1( SupNo, ` `, SupNoNew ))  ,supplier_bank_code(SupNoNew) , trace( [ `New Bank acc code `, supplier_bank_code ] )]
     
    , q(0,1,line)

    ,[generic_horizontal_details( [ [  `Postbank`, `Ludwigshafen`, `Nr`, `.` ],  bank_raw2, s, [`,`, `BLZ`, generic_item( [ code_raw2, s1 ] ), newline ] ] )
  
    , check(bank_raw2  =SupbNo2) ,check(strip_string2_from_string1( SupbNo2, ` `, SupNobNew2 )) ,supplier_bank_account_number_2(SupNobNew2) , trace( [ `Ne Bank acc 2`, supplier_bank_account_2 ] )

    , check(code_raw2  =SupNo2) ,check(strip_string2_from_string1( SupNo2, ` `, SupNoNew2 ))  ,supplier_bank_code_2(SupNoNew2) , trace( [ ` New Bank acc code 2`, supplier_bank_code_2 ] )]
     
      , q(0,1,line)

    ,[generic_horizontal_details( [ [  `Deutsche`, `Bank`, `AG`, `,`, `Worms`, `Nr`, `.` ],  bank_raw3, s, [`,`, `BLZ`, generic_item( [ code_raw3, s1 ] ), newline ] ] )
  
    , check(bank_raw3  =SupbNo3) ,check(strip_string2_from_string1( SupbNo3, ` `, SupNobNew3 )) ,supplier_bank_account_number_3(SupNobNew3) , trace( [ `New Bank acc 3`, supplier_bank_account_number_3 ] )

    , check(code_raw3  =SupNo3) ,check(strip_string2_from_string1( SupNo3, ` `, SupNoNew3 ))  ,supplier_bank_code_3(SupNoNew3) , trace( [ `New Bank acc code 3`, supplier_bank_code_3 ] )]
     
     
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK IBAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_iban_no, [
%=======================================================================

qn0(line)

 
    , generic_horizontal_details( [ [ `IBAN`, q10(`:`), q10(tab) ], bank_iban_raw, s1, newline ] )

    , check(bank_iban_raw  =SupibNo)

    ,check(strip_string2_from_string1( SupibNo, ` `, SupiNobNew ))

    , supplier_bank_iban(SupiNobNew)

    , trace( [ `Bank acc`, supplier_bank_iban ] )

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,20,line)
	
   ,  or([

        generic_horizontal_details( [[`Belegnummer`, `:`, q10(tab) ], invoice_number, w,  or([tab,newline]) ] )
       
        , find_order_number

        ])
    
] ).


%=======================================================================
i_line_rule( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([
          generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,8) , end ] ] )

        , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("1"),1,1) , q(dec,8,8) , end ] ] )

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
        generic_horizontal_details( [ [ `Ihre`, `Referenz`, `:`, q10(tab), q10(`Bestellung`) ], order_number, d, dummy_word(w) ] )

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

    q(0,200,line)

    ,or([
        generic_horizontal_details( [ [`Anlieferung`, `LS`, `.`, `-`, `Nr`, `.`, `-`, q10(`Strecke`), `:`], delivery_note_number, s, [`Lieferdatum`] ] )

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
	
	, generic_horizontal_details( [ [ `Belegdatum`, `:`, q10(tab)], invoice_date, date, newline ] )
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

    ,generic_horizontal_details( [ [ `summe` ,  `:`, tab, generic_item( [ total_net, d] )], 150, total_vat, d,  tab ] )

    ,clear(regexp_cross_word_boundaries)]

    ])
	
	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET currency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

q(0,100,line)

,or([
    generic_horizontal_details( [ [ `Gutschriftssumme` ], currency, w, [`:`, tab] ] )

    ,generic_horizontal_details( [ [ `Rechnungssumme` ], currency, w, [`:`, tab] ] )

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

    ,generic_horizontal_details( [ [ `Gutschriftssumme`, currency_dummy(w), `:`], 350, total_invoice, d,  newline ] )

    ,clear(regexp_cross_word_boundaries)]
        
        ,[set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Rechnungssumme`, currency_dummy(w), `:`], 350, total_invoice, d,  newline ] )

    ,clear(regexp_cross_word_boundaries)]

    ])

	
	
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

            
		
			  [line_invoice_line, q10(line_invoice_descr), q10(line_invoice_descr), line_invoice_net_line,  q10(line_invoice_material)  ]

             , [line_invoice_line, q10(line_invoice_descr), q10(line_invoice_descr), q10(line_invoice_material) ]

             , line_invoice_line

             , [ line_invoice_net_line,line_invoice_material]

  
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([
        [`Pos`, tab, `Artikelnr`, `.`, `Beschreibung`]

        ,[`Pos`, tab, `Ihre`, `Art`, `.`, `-`, `Nr`, `.`, `Beschreibung`]

    ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
		   [`Summe`, `:`]

           , [`E`, `.`, `W`, `.`, `NEU`, `GmbH`]


        ])

     , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
     

      generic_item([ line_reference , d , tab ])

      ,generic_item([ line_item , d  ])

      , generic_item([ line_descr , s1 , tab ])

      , generic_item([ line_quantity , d, q10(tab) ] )

      , generic_item([ line_quantity_uom_code , w , tab ] )

      , set(regexp_cross_word_boundaries)

      , generic_item([ line_unit_amount_dummy ,d,  tab ] )

      , generic_item([ line_dummy_line ,d,  tab ] )

      , q10(generic_item([ line_net_amount ,d,  tab ] ))

      , generic_item([ line_vat_rate , d , newline ] ) 
      
       , clear(regexp_cross_word_boundaries)

       , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
       ])
     
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_net_line, [
%=======================================================================

    q10(generic_append( [ line_descr, s1, tab, ` , `, ``  ] ))

    , generic_append( [ line_descr, s1, tab, ` , `, ``  ] )

    , generic_append( [ line_descr, s1, tab, ` , `, ``  ] )
	
     , q10(generic_item([ line_net_amount ,d,  newline ] ))

        
] ).


%=======================================================================
i_line_rule( line_invoice_descr, [
%=======================================================================

    q10(generic_item([ line_dummy_line ,s1,  tab ] ))
	
     ,generic_append( [ line_descr, s1, newline, ` `, ``  ] )

        
] ).

%=======================================================================
i_line_rule( line_invoice_item, [
%=======================================================================
	    
     generic_append( [ line_descr, s, `:`, ` `, ``  ] )
     , [
      generic_item( [line_item_raw,w, newline ] ), 

      check(line_item_raw=Line_Item), line_item_new(Line_Item),

      generic_append( [ line_descr,Line_Item, ` `, ``  ] )
 
      ]
    
    
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Created on   - January 30, 2018
% Updated by   - Thejaswi

% Updated on   - March 8, 2018
% Updated by   - Thejaswi
% Changes made - Line capture


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
