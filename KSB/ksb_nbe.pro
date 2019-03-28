%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NBE-Elektrische Maschinen und Geräte GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_nbe, `1 June 2018` ).

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

    sender_name( `NBE-Elektrische Maschinen und Geräte GmbH` )

    ,supplier_party( `NBE-Elektrische Maschinen und Geräte GmbH` )

    , supplier_vat_number(`DE139650565`)

    , supplier_bank_iban(`DE13860700000512226200`)
    
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,15,line)

   , line_add_line

   , q(1,5,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB`])

     , trace( [ `Found address`] )

     , or([
         
         generic_item( [buyer_party_raw , s1 ,  or([ tab, newline ])  ] )   
         
          ])

   
       , or([
         
         [check(buyer_party_raw = `KSB S.A.S`) ,generic_item( [ buyer_party, `KSB S.A.S.` ] ) ] 

        , [ check(buyer_party_raw = `KSB SE & Co. KGaG`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        , [ check(buyer_party_raw = `KSB SE & Co.KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        , [ check(buyer_party_raw = `KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        , [ check(buyer_party_raw = Buyer_raw) ,generic_item( [ buyer_party, Buyer_raw ] ) ] 

    
        ])
   
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      or([
          `67206` ,`67208`, `06110`, `67209`, `067206`, `67227`, `06227 ` ])
          

      ,generic_item( [ buyer_city_raw , s1 , or([tab, newline]) ])

      
      ,or([

         [ check(buyer_city_raw = buyer_city1) ,check(buyer_city1 = `Frabnkenthal`) ,generic_item( [ buyer_city, `FRANKENTHAL` ] ) ] 

       , [ check(buyer_city_raw = buyer_city1) ,check(buyer_city1 = `GENNEVILLIERS`) ,generic_item( [ buyer_city, `GENNEVILLIERS` ] ) ] 
 
        , [ check(buyer_city_raw = `Frankentha`) ,generic_item( [ buyer_city, `FRANKENTHAL` ] ) ] 


       ,[ check(buyer_city_raw = City_raw) ,generic_item( [ buyer_city, City_raw ] ) ] 

     ] )

] ).




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
        
        generic_horizontal_details( [ [`Nummer`, tab, `:` ],  invoice_number, d, newline ] )

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
        
        generic_horizontal_details( [ [ `Datum`, tab, `:` ], invoice_date, date, newline ] )

        ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

q(0,15,line)
	
   ,  or([
        
        generic_horizontal_details( [ [ `Rechnung`, `spätestens`, `bis`, `zum`], due_date, date, newline ] )

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
      
      generic_horizontal_details( [ [ `Bestellung`, `-`, `Nr`, `.` ], order_number, d,  newline ] )

      , generic_horizontal_details( [ [`Bestellung`, `-`, `Nr`, `.`], order_number, d,  `vom` ] )

      , generic_horizontal_details( [ [`Bestell`, `-`, `Nr`, `.`], order_number, d,  or([tab,newline]) ] )

       , find_order_number

      ])

] ).



%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,5,10) , end ] ] )

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
        
        generic_horizontal_details( [ [`LS`, `-`, `Nr`, `.`], delivery_note_number, d, `vom` ] )

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

    ,  generic_horizontal_details( [ [`Nettobetrag`, tab, `EUR`, tab ], total_net, d, newline ] )

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


    , generic_horizontal_details( [ [ `19`, `,`, `00`, `%`, `Mehrwertsteuer`, tab, `EUR`, tab ], total_vat, d, newline ] )

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

    ,   generic_horizontal_details( [ [ `Gesamtbetrag`, tab, `EUR`, tab ], total_invoice, d, newline ] )

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


    , generic_horizontal_details( [ [`Gesamtbetrag`, tab  ],currency, w, tab ] )

	
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

            		
			[line_invoice_line, q10(line_append_line),q10(line_append_line),q10(line_append_line), line_item_line, q10(line_append_line), q10(line_append_line) ]

            
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Pos`, `.`, `Menge`, `ME`, tab ]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [ `Nettobetrag`, tab, `EUR` ]


        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_number , d ,tab ])

       , generic_item([ line_quantity , d  ])

       , generic_item( [line_quantity_uom_code , s , [q10(tab), check(line_quantity_uom_code(end) < -166)] ] )

       , generic_item([ line_descr , s1, tab  ])

       , generic_item([ line_unit_amount , d, tab  ])

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

     generic_append( [ line_descr , s1, newline, `  `, ``  ] )
        
] ).

%=======================================================================
i_line_rule_cut( line_item_line, [
%=======================================================================

    or([
        
        [ `Material`, `-`, `Nr`, `.`]

        , [`Material`, `-`, `Nr`, `:`]

    ])

     ,generic_item( [ line_item, s1, newline ] )

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - February 12, 2018
% Updated by   - Rohini

% Updated on   - 3 July 2018
% Updated by   -  Thejaswi
% Changes made   -  Buyer party

% Updated on   - 1 March,  2019
% Updated by   -  Roopesh
% Changes made   -  Buyer party

% Updated on   - 28 March 2018
% Updated by   -  Thejaswi
% Changes made   -  Buyer City Frankatha


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
