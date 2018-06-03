%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA -WITPOL SP. Z O.O
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( pepc_witpol_sp_zoo , `23 May 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	  get_supplier_detail

    , get_supplier_address
	          		
	, get_supplier_bank_details
		
	, get_invoice_number
	
	, get_invoice_date

    , get_currency

    , get_invoice_due_date
	
	, get_order_number

    , get_total_invoices

    , get_vat_rate

    ,get_total_vat

    , get_invoice_lines

   , get_supplier_vat_code

    %, get_remit_supplier

    , get_payment_terms

    , get_buyer_party

    , get_total_net

    , get_freight_line

   , set_credit_note

	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER Detail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

	sender_name(`WITPOL SP. Z O.O`)

    ,supplier_party(`WITPOL SP. Z O.O`)

	,supplier_vat_number(``)

    ,buyer_dept(``)

    ,buyer_registration_number(``)

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER VAT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_vat_code, [
%=======================================================================

    q(0,50,line)

    ,generic_horizontal_details( [ [ `NIP`, `:`],supplier_vat_number, s1,  tab ] )
   



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Currency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q(0,50,line)


   , or([

   [generic_horizontal_details( [ [ `Invoice`, `Currency`, tab ],  currency, w,tab] )]

   

    
  ,currency_alternate


    ])


] ).


%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================

    q0n(anything)
    
    ,or([
    
     [`EU`]

    ,[`€`]

    ,[`EUR`]

    , generic_item( [ currency, `EUR` ] )

    ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================

    q(0,100,line)

   , line_suppadd_line

   , q(0,1,line)

   ,line_suppadd_line_1

   ,q(0,1,line)

   ,line_suppadd_line_2

   ,q(0,1,line)

   ,line_suppadd_line_3

   ,q(0,1,line)

   ,line_suppadd_line_4

   
   ,q(0,1,line)

   ,line_suppadd_line_5


    
] ).

%=======================================================================
i_line_rule( line_suppadd_line, [
%=======================================================================
   

     read_ahead( [`WITPOL`, `SP`] )

    ,trace( [ `Found SUPPLIER NAME`] )

    ,generic_item( [ supplier_party, s1, tab] )


] ).


%=======================================================================
i_line_rule( line_suppadd_line_1, [
%=======================================================================
    
    generic_item( [ supplier_address_line, s,[q10(tab), check(supplier_address_line(end) < -321)] ] )

   , generic_item( [ supplier_postcode, s,[q10(tab), check(supplier_postcode(end) < -237)] ] )

   ,q10( generic_item( [ supplier_city, s,[q10(tab), check(supplier_postcode(end) < -171)] ] ) )

   ,q10( generic_item( [ dummy_line_supp, s1, tab] ) )

      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_bank_details, [
%=======================================================================
	

    q(0,80,line)

   , generic_horizontal_details( [ [ `SWIFT`, `CODE`, `:`],  remit_to_swift_code, s1,newline] ) 


] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BUYER PARTY DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_party, [
%=======================================================================

    q(0,100,line)

   , line_add_line

   , q(0,1,line)

   ,line_add_line_1

   ,q(0,1,line)

   ,line_add_line_2

   ,q(0,1,line)

   ,line_add_line_3

   
   ,q(0,1,line)

   ,line_add_line_4

   
   ,q(0,1,line)

   ,line_add_line_5

   ,q(0,1,line)

   ,line_add_line_6     


    
] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    read_ahead( [`WITPOL`, `SP`] )

    ,trace( [ `Found BUYER line`] )

     ,generic_item( [ dummy_line_buy, s1, tab] )

     ,q10(generic_item( [ dummy_line_buy3, s1, tab] ) )

   ,generic_item( [ buyer_party, s1, newline ] )


] ).


%=======================================================================
i_line_rule( line_add_line_1, [
%=======================================================================

    q10(generic_item( [ dummy_line_buy1, s1, tab] ))

    , generic_item( [buyer_city, s1, newline  ] ) 


] ).


%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

 generic_item( [ dummy_line_buy2, s1, tab] )

, q10(generic_item( [ dummy_line_buy2, s1, tab] ))

, generic_item( [buyer_address_line, s1,newline] )

] ).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================
    
	q(0,30,line)
	,or([

	[generic_horizontal_details( [ [  `Invoice`, `No`, `:`, tab],  invoice_number, s1, newline ] ) ]

    ,[generic_horizontal_details( [ [  `Corrective`, `Invoice`, `No`, `:`, tab],  invoice_number, s1, tab ] ) ]

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

	q(0,30,line)
	
	,or([

     [generic_vertical_details( [ [  `Date`, tab ], `Date` , q(0,1), (start,10,10), invoice_date, date , tab ] ) ]

     ,[generic_horizontal_details( [ [  `Correction`, `Date`, `:`, tab],  invoice_date, date, newline ] ) ]

    ])
        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE Due date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_due_date, [
%=======================================================================

	q(0,60,line)
	
	

    , generic_horizontal_details( [ [ `Term`, `of`, `payment`, tab ],  due_date,  date, newline ] )

   
        
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoices, [
%=======================================================================
   
     q(0,100,line)

      , set(reverse_punctuation_in_numbers), set(regexp_cross_word_boundaries)
     , or([
	    
        generic_horizontal_details( [ [`Total`, `:`, tab ],  total_invoice, d, [ q10(`EUR`),newline] ] ) 

      
      ])

     , check( total_invoice = TotInv )

        , trace( [ `Total Inv v` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] )


        , clear(reverse_punctuation_in_numbers), clear(regexp_cross_word_boundaries)  

     
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,60,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)


    , [ `Corrective`, `Invoice`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

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

             
              [line_invoice_line]

             , [ line_invoice_credit_note_line, line_append_line ]
              
                   
              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
    or([
    
    
    [ `No`, tab, `Code`, tab, `Description`, tab ]

   , [`Difference`, `:`,  newline]
     
    ])
    
    , trace([`found the START line`])
] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
    or([
    
   
   [`VAT`, `RATE` ]

   ,[`Correction`, `Value`]

      
    ])
     , trace([`found the END line`])

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    set(reverse_punctuation_in_numbers), set(regexp_cross_word_boundaries)
  
  ,generic_item( [line_reference , d  ]  )

  , generic_item( [line_item , d, tab ]  )

  , generic_item( [line_descr , s1,tab ]  )

  , generic_item( [line_quantity , d ]  )

    ,generic_item( [line_quantity_uom_code , s1,tab ]  )
 
   ,generic_item( [line_unit_amount , d,  [q10(tab), check(line_unit_amount(end) < 403)] ] )
     
   ,generic_item( [line_net_amount , d ,  newline]  )

    , clear(reverse_punctuation_in_numbers), clear(regexp_cross_word_boundaries)
] ).



%=======================================================================
i_line_rule_cut( line_invoice_credit_note_line, [
%=======================================================================

   set(reverse_punctuation_in_numbers), set(regexp_cross_word_boundaries)

  , generic_item( [line_reference , s1,tab ]  )

  ,q10( generic_item( [line_item , s1, [q10(tab), check(line_item(end) < -310)] ] ) )

  , generic_item( [line_descr , s1,tab ]  )

  , generic_item( [line_quantity , d ]  )

  , generic_item( [ line_quantity_uom_code, w, tab ] )

  , generic_item( [line_unit_amount , d,  tab ]  )    
  
   ,generic_item( [line_net_amount , d  ]  )

  , generic_item( [line_dummy_1 , s1,  tab ]  )   

  , generic_item( [line_dummy_1 , d,  tab ]  ) 

  , generic_item( [line_total_amount , d,  newline ]  ) 

 
 ,clear(reverse_punctuation_in_numbers), clear(regexp_cross_word_boundaries)
   
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

 q10(generic_append( [ line_item, s1, tab, ` ` ,  ` `  ] ) )

, generic_append( [ line_descr, s1, newline, ` ` ,  ` `  ] )


] ).
