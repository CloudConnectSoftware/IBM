%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HIPER_GLOBAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_hiper_global, `25 Sep,2023` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_op_param( us_invoice, _, _, _, false ).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_user_field( invoice, dummy_rounding_amount, `dummy_rounding_amount` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement  

    , set_credit_note

    , get_original_invoice_number

    , get_buyer_vat

    , get_invoice_number
    
    , get_invoice_date
	
    , get_order_number

    , get_freight
      
    , get_invoice_totals

    , get_invoice_totals_1

    , get_invoice_totals_2
      
    , get_invoice_totals_3

    , get_invoice_totals_4  

    , get_invoice_totals_5 

    , get_invoice_totals_6
    
    , get_amount_details

	, get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `HIPER GLOBAL` )

   % Supplier VAT number - 516476835  %

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

    , [`Credit`, `Memo` ]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER VAT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_vat, [
%=======================================================================

      q0n(line)

     , check_text(`VAT` )

     , [ generic_horizontal_details( [ [`VAT`, `Registration`, `number`  ], buyer_vat_number, s, [`for`, `services`,  newline ] ] )

     , generic_item( [ buyer_tax_type, `VAT` ] )]
  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [ 
%=======================================================================
	
	q0n(line)

  , or([

       generic_horizontal_details( [ [ `אטויט`,  `-`  ],  invoice_number, s, [ `תזכרמ`,  `סמ`,  `תינובשח`,  newline ]] )

    ,  generic_horizontal_details( [ [ `קתעה`,  `-` ],  invoice_number, s, [ `תזכרמ`,  `סמ`,  `תינובשח`,  newline ]] )

    ,  generic_horizontal_details( [ [ `קתעה`,  `-` ],  invoice_number, s, [  `תזכרמ`,  `סמ`,  `תינובשח`,  newline ]] )

    , generic_horizontal_details( [ [`(`, `בשחוממ`,  `ךמסמ`, `)`,  `רוקמ`,  `-` ],  invoice_number, s, [`תזכרמ`,  `סמ`,  `תינובשח`,  newline ]] )

    , generic_horizontal_details( [ [ `(`, `בשחוממ`,  `ךמסמ`, `)`,  `רוקמ`,  `-`  ],  invoice_number, s, [`תזכרמ`,  `יוכיז`,  `תינובשח`,  newline ]] )

     , generic_horizontal_details( [ [`Export`, `Invoice` ],  invoice_number, s, [ `Orig`, `.` ]] )

    ,  generic_horizontal_details( [ [`Export`,  `Invoice`],  invoice_number, s, [`-`,  `Copy` ]] )

    ,  generic_horizontal_details( [ [`Export`, `Credit`, `Memo` ],  invoice_number, s, [ `Orig`, `.` ]] )
	
] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIGINAL INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_original_invoice_number, [ 
%=======================================================================
	
	q0n(line)

  , or([

       generic_horizontal_details( [ [`CERDIT`,  `FOR`,  `INVICE`,  `NO`, `#`],  original_invoice_number, s1, newline ] )
] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [ 
%=======================================================================
	
      q0n(line)

    , or([

      generic_horizontal_details( [ [`INVOICE`, `DATE`, `:` ], invoice_date, date, newline ] )

    , generic_horizontal_details( [ [`RECEIPT`, `DATE`, `:` ], invoice_date, date, newline ] )

    ,  generic_vertical_details( [ [`חוקל`,  `רפסמ`,  tab ], `חוקל`, q(0,1,up), (start, 500,500), invoice_date, date ,  `:` ] )
   

   ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_order_number, [
%=======================================================================

     q(0,50,line)

 , or( [

      find_order_number

   ])


] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)


, or( [
             [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("2"),1,1) , q(dec,8,10) , end ] ] ) ]
    ] )

 
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE AMOUNT ENGLISH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_amount_details, [ 
%=======================================================================
	
      q0n(line)

    , or([

        generic_horizontal_details( [ [ `TOTAL`,  tab, `USD` ], total_net, d, newline ] )

        , generic_horizontal_details( [ [`TOTAL`, tab, `US`, `$` ], total_net, d, newline ] )
    ])    

    ,  check( total_net = TotNet)

    , generic_item( [ total_invoice , TotNet ] )

    , generic_item( [ currency , `USD` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals, [
%=======================================================================

or([

    line_with_text(`תיללכ החנה`)

    , line_with_text(`החנהירחאריחמ`)
])
    
	 , line_total_net
	 
	 , q(0,2,line)
	 
	 , line_total_vat
	 
	  , q(0,2,line)
	 
	 , line_total_invoice	 

] ).


%=======================================================================
i_line_rule_cut( line_total_net, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   ,`החנה`,  `ירחא`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, `%` ] )  

    , generic_item( [ dummy_detail, s1, tab ] )
   
    , generic_item( [ currency_exchange_rate, d, `:` ] )

    , `ןיפילח`,  `רעש`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   ,`ריחמ`,  `כ`, `"`, `הס`, gen_eof
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_1, [
%=======================================================================

    or([

        line_with_text(`ללוכריחמ`)

        , line_with_text(`ללוכ ריחמ`)

    ])

    
	
	 , line_total_net_1
	 
	 , q(0,2,line)
	 
	 , line_total_vat_1
	 
	  , q(0,2,line)
	 
	 , line_total_invoice_1 

     , q(0,3,line)

     , line_exchange_rate

] ).


%=======================================================================
i_line_rule_cut( line_total_net_1, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   ,`ללוכ`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_1, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, tab ] ), `(`

   , or([
        
         generic_item( [ default_vat_rate, d, [`)`] ] )

        , generic_item( [ default_vat_rate, d, `%` ] )

    ])
	
	
    , q10(generic_item( [ dummy_detail1, s1, tab ] ))

    , generic_item( [ dummy_detail2, s1, newline ] )
 
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_1, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   , `ריחמ`,  `כ`, `"`, `הס`,  gen_eof
   
  
] ).

%=======================================================================
i_line_rule_cut( line_exchange_rate, [
%=======================================================================

     generic_item( [ currency_exchange_rate, d,  `:` ] )
   
   , `ןיפילח`,  `רעש`,  newline

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_2, [
%=======================================================================


   or([
       
     line_with_text(`החנה ירחא ריחמ`)

   ,  line_with_text( `החנהירחאריחמ`)
	
	] )
     , line_total_net_11
	 
	 , q(0,2,line)
	 
	 , line_total_vat_11
	 
	  , q(0,1,line)
	 
	 , line_total_invoice_11


] ).


%=======================================================================
i_line_rule_cut( line_total_net_11, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   , `החנה`,  `ירחא`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_11, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d,[`%`, `)`] ] )

    ,  `מ`, `"`, `עמ`,  newline
 
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_11, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   ,`ריחמ`,  `כ`, `"`, `הס`,  newline

   
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_3, [
%=======================================================================


    or([
        
    
     line_with_text(`ללוכריחמ`)

	
   ] )

     , line_total_net_3
	 
	 , q(0,2,line)
	 
	 , line_total_vat_3
	 
	 , q(0,2,line)
	 
	 , line_total_invoice_3	 

     , q(0,2,line)

     , line_exchange_rate_3

] ).


%=======================================================================
i_line_rule_cut( line_total_net_3, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   , `ללוכ`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_3, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)`] ] )  

    ,  `מ`, `"`, `עמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_3, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   , `ריחמ`,  `כ`, `"`, `הס`,  gen_eof

  
] ).
%=======================================================================
i_line_rule_cut( line_exchange_rate_3, [
%=======================================================================

     generic_item( [ currency_exchange_rate, d ] )
   
   ,`:`, `ןיפילח`,  `רעש`,  newline
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_4, [
%=======================================================================


    or([
        
       line_with_text(`החנה ירחא ריחמ`)

    , line_with_text(`החנהירחאריחמ`)

	
   ] )

     , line_total_net_4
	 
	 , q(0,2,line)
	 
	 , line_total_vat_4
	 
	 , q(0,2,line)
	 
     , line_exchange_rate_4

     , q(0,2,line)

     , line_total_invoice_4

] ).


%=======================================================================
i_line_rule_cut( line_total_net_4, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   , `החנה`,  `ירחא`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_4, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)`] ] )  

    , generic_item( [ dummy, s1, tab ] )

    , generic_item( [ dummy, s, `:` ] )

    ,  `דע`,  `םולשתל`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_exchange_rate_4, [
%=======================================================================

     generic_item( [ currency_exchange_rate, d ] )
   
   ,`:`, `ןיפילח`,  `רעש`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_4, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )

   , generic_item( [ dummy1, s1, tab ] )

   , generic_item( [ dummy2, s1, newline ] )

  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_5, [
%=======================================================================


    or([
        
    
     line_with_text(`ללוכריחמ`)

        	
   ] )

     , line_total_net_5
	 
	 , q(0,2,line)
	 
	 , line_total_vat_5
	 
	 , q(0,2,line)
	 
	 , line_total_invoice_5	 

  
] ).


%=======================================================================
i_line_rule_cut( line_total_net_5, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   , `ללוכ`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_5, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)`] ] )  

    ,  `מ`, `"`, `עמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_5, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   , `ריחמ`,  `כ`, `"`, `הס`,  tab

   ,  generic_item( [ currency_exchange_rate, d ] )
   
   , `:`, `ןיפילח`,  `רעש`,  newline

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals_6, [
%=======================================================================

    or([
        
    
     line_with_text(`החנה ירחא ריחמ`)

    , line_with_text(`החנהירחאריחמ`)

        	
   ] )

     , line_total_net_6
	 
	 , q(0,1,line)
	 
	 , line_exchange_rate_6

  	 , q(0,1,line)
	 
	 , line_total_vat_6
	 
	 , q(0,1,line)
	 
	 , line_total_invoice_6	 

  
] ).


%=======================================================================
i_line_rule_cut( line_total_net_6, [
%=======================================================================

    `$`
    
   , generic_item( [ total_net, d, tab ] )
   
   , `החנה`,  `ירחא`,  `ריחמ`,  gen_eof
  
] ).
%=======================================================================
i_line_rule_cut( line_exchange_rate_6, [
%=======================================================================

	 generic_item( [ currency_exchange_rate, d ] )
	
   , `:`, `ןיפילח`,  `רעש`,  gen_eof

] ).

%=======================================================================
i_line_rule_cut( line_total_vat_6, [
%=======================================================================

	`$`
    
    , generic_item( [ total_vat, d, [ tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)`] ] )  

    ,  `מ`, `"`, `עמ`,  gen_eof
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_6, [
%=======================================================================

   `$`
   
   , currency(`USD`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   ,  `ריחמ`,  `כ`, `"`, `הס`,  gen_eof
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET FREIGHT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Invoice Totals Capture
%=======================================================================

%=======================================================================
i_rule_cut( get_freight, [
%=======================================================================

	line_with_text(`תיללכהחנה`)
	
	, line_freight
	
] ).

%=======================================================================
i_line_rule( line_freight, [ 
%=======================================================================
	
	`$`
    
    , generic_item( [ dummy_rounding_amount, d, tab ] )
	
	, `(`, generic_item( [ dummy_rate, d, `%` ] ), `)`
	
	,  `תיללכ`,  `החנה`
	
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [
                           

                line_invoice_english_8

               , line_invoice_line_1

                , line_invoice_english_3
                
                , line_invoice_english_4
                
                , line_invoice_english_5
                 
                , line_invoice_english_1                

                , line_invoice_english      

                , [ line_invoice_line, q10(line_append_line) ]

                , [line_invoice_line_2, q10(line_append_line)]

                , [line_english_descr_line, line_invoice_english_4, q10(line_append_line) ]

                , line_invoice_english_6

                , line_invoice_english_7

                , [line_english_descr_line,line_invoice_english_9]

                , line_invoice_english_10
                
              
                , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
       [  `ריחמ`, `כ`, `"`, `הס`, tab ]       

       , [`Document`, tab, `Order`, tab, `Your`, `Order` ]

     %  , [ `הדיחיל`, tab, `םכתנמזהב`,  newline ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   or([

        [ `Your`,  `Part`,  tab, `Part`,  tab, `Balance`,  newline ]

    , [`$`,  dummy(d),  tab, `(`, dummy(d), `%`, `)`,  `תיללכ`,  `החנה`,  newline ]
    
   % , [`$`, dummy(d),  tab, `ללוכ`,  `ריחמ`,  newline  ]

    ] )
    
     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


	`$`
    
    	, or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d,[ q10(tab), q10(`$`)] ] )
		
	] )
	
	, or( [ 
	
			[
			
			with( invoice, dummy_rounding_amount, DummyRounding )
			
			, generic_item( [ dummy_price, d, q10(tab) ] )
			
			]
			
			, generic_item( [ line_unit_amount, d, q10(tab) ] )
			
		] )
  
    , generic_item( [ line_quantity, d, q10(tab) ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_item, s1, tab ] )

    , q10(generic_item( [ line_dummy, s1, tab ] ))

    , generic_item( [ line_buyers_order_number, d, tab ] )

    , generic_item( [ line_dummy1, s1, tab ] )

   	, generic_item( [ dummy_line, d, newline ] )

	, remove(dummy_rounding_amount)
    
] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
    [`$`, dummy(d),  tab, `ללוכ`,  `ריחמ`,  newline  ]

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================


	`$`
    
    	, or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d,[ q10(tab), q10(`$`)] ] )
		
	] )
	
	, or( [ 
	
			[
			
			with( invoice, dummy_rounding_amount, DummyRounding )
			
			, generic_item( [ dummy_price, d, q10(tab) ] )
			
			]
			
			, generic_item( [ line_unit_amount, d, q10(tab) ] )
			
		] )

     , generic_item( [ line_quantity, d, q10(tab) ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_item, s1, tab ] )

    , q10(generic_item( [ line_dummy_po, s1, tab ] ))

    , q10(generic_item( [ line_dummy, s1, tab ] ))

    , q10(generic_item( [ line_dummy, s1, tab ] ))

    , generic_item( [ line_buyers_order_number, d, newline ] )

	, remove(dummy_rounding_amount)
    
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_english, [
%=======================================================================

       generic_item( [ line_descr_dummy, s, q10(tab) ] )
        
     , generic_item( [ po_number, d ] )

     , generic_item( [ line_buyers_order_number, d ] )
    
	 , generic_item( [ line_item, s1, tab ] )

     , generic_item( [ line_descr, s1, tab ] )
      
     , generic_item( [ line_quantity, d ] )

     , generic_item( [ line_quantity_uom_code, w, tab ] )

     , generic_item( [ line_dummy, s, [`US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_english_1, [
%=======================================================================

       generic_item( [ line_descr_dummy,w, q10(tab) ] )

     , generic_item( [ line_descr_dummy1,w, q10(tab) ] )

     , generic_item( [ po_number,d, q10(tab) ] )

     , generic_item( [ line_buyers_order_number, d ] )
     
	 , generic_item( [ line_item, s1, tab ] )

     , generic_item( [ line_descr, s1, tab ] )
      
     , generic_item( [ line_quantity, d ] )

     , generic_item( [ line_quantity_uom_code, w, tab ] )

     , generic_item( [ line_dummy, s, [`US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_english_4, [
%=======================================================================

        generic_item( [ line_descr_dummy, w , q10(tab) ] )

     ,  generic_item( [ line_descr_dummy1, w, q10(tab) ] )

     , generic_item( [ po_number, d , q10(tab) ] )
  
     , generic_item( [ line_buyers_order_number, d ] )
     
	 , q10(generic_item( [ line_item, s1, tab ] ))

     , generic_append( [ line_descr, s1, tab, ``, ` `  ] )

     , generic_item( [ line_dummy, s, [ q10(tab), `US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_english_descr_line, [
%=======================================================================

   q10(generic_item( [ line_dummy, s1, tab ] ))

  , generic_item( [ line_descr, s1, newline ] )
  
  
] ).



%=======================================================================
i_line_rule_cut( line_invoice_english_3, [
%=======================================================================

       generic_item( [ line_descr_dummy,w , q10(tab)] )

     , generic_item( [ line_descr_dummy1,w, q10(tab) ] )
 
     , generic_item( [ po_number, d, q10(tab)  ] )
     
     , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

     , q10(generic_item( [ line_item, s1, tab ] ))
     
     , generic_item( [ line_descr, s1, tab ] )

     , generic_item( [ line_descr_dummy, s1, tab ] )
     
     , generic_item( [ line_descr_dummy, s, [  `US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_english_5, [
%=======================================================================

       generic_item( [ line_descr_dummy,w, q10(tab) ] )

     , generic_item( [ line_descr_dummy1,w , q10(tab)] )

     , generic_item( [ po_number, d, q10(tab)  ] )
 
     , generic_item( [ line_buyers_order_number, d ] )

     , generic_item( [ line_descr, s, [  `US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_english_6, [
%=======================================================================


       generic_item( [ line_descr_dummy,w , q10(tab)] )

     , generic_item( [ line_descr_dummy1,w, q10(tab) ] )
 
     , generic_item( [ po_number, d, q10(tab)  ] )
     
     , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

     , generic_item( [ line_item, s1, tab ] )

     , generic_item( [ line_item_dummy, s1, tab ] )
     
     , generic_item( [ line_descr, s1, tab ] )

     , generic_item( [ line_quantity, d, [`ea`, tab ] ] )
     
     , generic_item( [ line_quantity_dummy, s, [  `US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_english_7, [
%=======================================================================

        generic_item( [ line_dummy,d , q10(tab)] )

     , generic_item( [ line_descr_dummy,w , q10(tab)] )

     , generic_item( [ line_descr_dummy1,w, q10(tab) ] )
 
     , generic_item( [ po_number, d, q10(tab)  ] )
     
     , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

     , generic_item( [ line_item, s1, tab ] )

     , generic_item( [ line_descr, s1, tab ] )
     
     , generic_item( [ line_descr_dummy, s, q10(tab) ] )

     , generic_item( [ line_quantity_dummy, d, [`ea`, q10(tab) ] ] )
     
     , generic_item( [ line_quantity_dummy, s, [  `US`, `$` ] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================


	`$`
    
    , generic_item( [ line_net_amount, d,[ tab, `$`] ] )

	, generic_item( [ line_unit_amount, d, q10(tab) ] )
	  
    , generic_item( [ line_quantity, d, q10(tab) ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_item, s1, tab ] )

    , q10(generic_item( [ line_dummy, s1, tab ] ))

    , generic_item( [ line_buyers_order_number, d, tab ] )

    , generic_item( [ line_dummy, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_english_8, [
%=======================================================================

        generic_item( [ line_dummy,d ] )

     , generic_item( [ line_descr_dummy,w ] )

     , generic_item( [ line_descr_dummy1,w  ] )
 
     , generic_item( [ po_number, d   ] )
     
     , generic_item( [ line_buyers_order_number, d ] )

     , generic_item( [ line_item, s1, tab ] )
     
     , generic_item( [ line_descr, s, q10(tab) ] )

     , generic_item( [ line_quantity_dummy, d, [`ea`, q10(tab) ] ] )
     
     , generic_item( [ line_quantity_dummy, s, [ `ea`,  `US`, `$`] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_english_9, [
%=======================================================================
  

        generic_item( [ line_dummy,d ] )

     , generic_item( [ line_descr_dummy,w ] )

     , generic_item( [ line_descr_dummy1,w  ] )
 
     , generic_item( [ po_number, d   ] )
     
     , generic_item( [ line_buyers_order_number, d ] )

     , generic_item( [ line_item, s1, tab ] )

     , q10(generic_item( [ line_item_dummy, w ] ))

     , generic_item( [ line_quantity_dummy, d, [`ea`, q10(tab) ] ] )
     
     , generic_item( [ line_quantity_dummy, s, [ `ea`,  `USD`] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_english_10, [
%=======================================================================

        generic_item( [ line_dummy,d ] )

     , generic_item( [ line_descr_dummy,w ] )

     , generic_item( [ line_descr_dummy1,w  ] )
 
     , generic_item( [ po_number, d   ] )
     
     , generic_item( [ line_buyers_order_number, d ] )

     , generic_item( [ line_item, s, q10(tab) ] )
     
     , generic_item( [ line_descr, s, q10(tab) ] )

     , q10(generic_item( [ line_item_dummy, w ] ))

     , generic_item( [ line_quantity_dummy, d, [`ea` ] ] )
     
     , generic_item( [ line_quantity_dummy, s, [ `ea`,  `US`] ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )
  
] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 19 April, 2022
% Mapped by - Rohini 

% It’s former E&M Computing. New Supplier code for 0026 and 0109 is: 9000195727


% Updated on   - 19 July,2022
% Updated by   - Sushmitha
% Changes made - updated line_invoice_line_1

% Updated on   - 22 Aug,2022
% Updated by   - Sushmitha
% Changes made - updated get_invoice_totals_1

% Updated on   - 16 march,2023
% Updated by   - Sushmitha
% Changes made - Added line_invoice_english_6

% Updated on   - 05 Sep, 2023
% Updated by   - Rohini
% Changes made - Mapped line_invoice_english_7

% Updated on   - 06 Sep, 2023
% Updated by   - Rohini
% Changes made - line_invoice_english_8 mapped

% Updated on   - 25 Sep,2023
% Updated by   - Sushmitha
% Changes made - Re-arranged rules set to capture the format. Ex: Inv: EXF231100660

% Updated on   - 25 Sep,2023
% Updated by   - Sushmitha
% Changes made - Added line_invoice_english_9, updated get_amount_details & added line_invoice_english_10

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
