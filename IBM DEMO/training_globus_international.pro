%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Globus International packing, shipp/credit note
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(training_globus_international, `23 Aug,2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( `d/m/y` ).

i_op_param( us_invoice, _, _, _, false ).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_user_field( invoice, dummy_rounding_amount, `dummy_rounding_amount` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_invoice_number

	, get_original_invoice_number
    
    , get_invoice_date
	
	, get_freight
	
	, get_po_line_number

    , get_order_number

	, get_order_number_1

	, get_order_number_alternative

	, get_order_number_2

	, get_invoice_lines
	
	, get_totals

	, get_totals_without_discount

	, get_totals_without_discount_1

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `Globus International packing, shipp` )

   % Supplier VAT number - 930913991 %

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [ 
%=======================================================================
	
	or([

		line_with_text(`הדועת רפסמ`)

	, line_with_text(`הדועתרפסמ`)

	])
	
	
	% , generic_horizontal_details( [ [ `Invoice`, `number`	], 100, invoice_number, s1, or( [ tab, newline ] ) ] )
	
	%, generic_vertical_details( [ [ `Invoice`, `Number` ], `Invoice`, q(0,0,line), (end, 20,20), invoice_number, s1, or( [ tab, newline ] ) ] )
	
	, line_invoice_number

] ).

%=======================================================================
i_line_rule( line_invoice_number, [ 
%=======================================================================
	
	generic_item( [ invoice_number, s, `:` ] ), q10(tab)
	
	, `הדועת`, `רפסמ`, gen_eof

	
	 
] ).


%=======================================================================
i_rule( get_original_invoice_number, [ 
%=======================================================================
	
	 or([

		line_with_text(`תינובשח ןיגב יקלח`)

	, line_with_text(`תינובשחןיגביקלח`)

	])
	
	, line_original_invoice_number

] ).
%=======================================================================
i_line_rule( line_original_invoice_number, [ 
%=======================================================================
	
	generic_item( [ original_invoice_number, s , `:` ] )
	
	,`תינובשח`,  `ןיגב`,  `יקלח`,  `יוכיז` , gen_eof

	
	 
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [ 
%=======================================================================
	
	 q(0,40,line)
	
	, or([
		
	  line_with_text(`תינובשחךיראת`)

	 , line_with_text(`יוכיזה ךיראת`)

	 , line_with_text(`יוכיזךיראת`)
	
	 , generic_vertical_details( [ [ `הדועת`,  `רפסמ`,  tab ],   `רפסמ` , q(0,1), (end, 100,900), invoice_date, date, [`:`, `יוכיזה`,  `ךיראת`,  tab ] ] )
	
	] )
	
	,or([
		
		  line_invoice_date

		, line_invoice_date_1

		, line_invoice_date_2

	] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_date, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date, `:` ] ), q10(tab)
	
	, `תינובשח`, `ךיראת`, gen_eof
	
] ).
%=======================================================================
i_line_rule_cut( line_invoice_date_1, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date, `:` ] ), q10(tab)
	
	,`יוכיזה`,  `ךיראת`, gen_eof

] ).

%=======================================================================
i_line_rule_cut( line_invoice_date_2, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date ] ) , q10(tab)
	
	,`:`, `יוכיזה`,  `ךיראת`, gen_eof


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_po_line_number, [
%=======================================================================

     or([
		 
		line_with_text(`הרוש'סמ`) 

	 , line_with_text(`הרוש 'סמ`) 
	 
] ) 

 % , generic_vertical_details( [ [ `ריחמ`,  `כ`, `"`, `הס`,  newline ],`ריחמ`, q(0,1), (start,100,400), order_number, d, `:` ] )
 
   , find_po_line_number

] ).
 
%=======================================================================
i_line_rule_cut( find_po_line_number, [
%=======================================================================

    q0n(anything)

    , generic_item( [ line_buyers_order_number, d, `-` ] )
	
	, `הרוש`, `'`, `סמ`, set(po_line)

]).

%=======================================================================
i_rule_cut( get_order_number, [
%=======================================================================

        or([
		 
		line_with_text(`הרוש'סמ`) 
		
	,  line_with_text(`'סמ`)
] ) 

 % , generic_vertical_details( [ [ `ריחמ`,  `כ`, `"`, `הס`,  newline ],`ריחמ`, q(0,1), (start,100,400), order_number, d, `:` ] )
 
   , find_order_number
   

] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([

           [ test_not(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_45), trace( [ `Order Number 45`] ) ]

          , [ test_not(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44), trace( [ `Order Number 44`] ) ]
	
		  , [ test(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

		  , [ test(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

		  , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44), trace( [ `Order Number 44`] ) ]

		  , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44), trace( [ `Order Number 45`] ) ]

    ])
	
	, q10(tab), `:`
	
	, or([
		
		 `הנמזה`, `'`, `סמ`

	,  `םכתנמזה`
])

]).

%=======================================================================
i_rule_cut( get_order_number_1, [
%=======================================================================

       
       q(0,50,line)

  ,  find_order_number_1

   

] ).
 
%=======================================================================
i_line_rule_cut( find_order_number_1, [
%=======================================================================

    q0n(anything)

    , or([

           [ test_not(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_45), trace( [ `Order Number 45`] ) ]

          , [ test_not(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44), trace( [ `Order Number 44`] ) ]
	
		  , [ test(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

		  , [ test(po_line), generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

    ])
	

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_order_number_alternative, [
%=======================================================================

  q(0,50,line)

, or([

  generic_horizontal_details( [ [ `Order`, `#` ], order_number, d, newline ] )

, generic_horizontal_details( [ [ `PO`, `#` ], order_number, d, newline ] )

] )

,  q(0,1,line)

, or([

  generic_horizontal_details( [ [`Line` ], line_buyers_order_number, d, newline ] )

, generic_horizontal_details( [ [`Line` ], line_buyers_order_number, d, [ `,`,  newline ] ] )

, generic_horizontal_details( [ [`LINE`, `:` ], line_buyers_order_number, d, newline ] )

] )
 
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER ALTERNATIVE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_order_number_2, [
%=======================================================================

   q0n(line)

   , in, set(regexp_allow_partial_matching) , `PO`,  clear(regexp_allow_partial_matching)

     
        , or([

         [generic_item( [ order_number, [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10), end ] ] )

        ,  check( strip_string2_from_string1( order_number, `NumberNew11`, ORDER_NUMBERNEW11 ) )

       , generic_item( [ order_number, ORDER_NUMBERNEW11 ] ), set(order_number_44)  ]

      ,  [generic_item( [ order_number, [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10), end ] ] )

        , check( strip_string2_from_string1( order_number, `NumberNew11`, ORDER_NUMBERNEW11 ) )

        , generic_item( [ order_number, ORDER_NUMBERNEW11 ] ), set(order_number_45) ]

      ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISCOUNT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_totals, [
%=======================================================================

    line_with_text(`ללוכריחמ`)
	
	, line_price_before
	
	%, q(0,1,line)
    
    %, line_rounding
	 
	, q(0,6,line)
	 
	, line_total_net
	 
	, q(0,1,line)
	 
	, line_total_vat
	 
	, q(0,1,line)
	 
	, line_total_invoice	 

] ).


%=======================================================================
i_line_rule_cut( line_price_before, [
%=======================================================================

	generic_item( [ dummy_price_before, d, tab ] )
   
   , `ללוכ`, `ריחמ`, gen_eof

  
] ).

%=======================================================================
i_line_rule_cut( line_rounding, [
%=======================================================================

	or( [ 
	 
		[ 
		
		`-`
    
		, generic_item( [ line_net_amount, d, tab ] )
		
		, line_vat_rate(`17`)
		
		, line_item(`FREIGHT`)
	
		, line_descr(`Rounding`)
	
		, line_type(`extra`)
	
		, check( q_sys_comp_str_gt( line_net_amount, `0` ) )	
		
		]
		
		, generic_item( [ line_amount_discount, d, tab ] )
		
	] )
	
	, `(`, generic_item( [ dummy_rate, d, `%` ] ), `)`
	
	, `תיללכ`, `החנה`

] ).

%=======================================================================
i_line_rule_cut( line_total_net, [
%=======================================================================

  generic_item( [ total_net, d, tab ] )
   
   , `החנה`, `ירחא`, `ריחמ`, gen_eof
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat, [
%=======================================================================

	generic_item( [ total_vat, d, tab ] ), `(`
	
	, generic_item( [ default_vat_rate, d, `%` ] ), `)`
   
   , `מ`, `"`, `עמ`, gen_eof
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice, [
%=======================================================================

   `חש`, currency(`ILS`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   , `ריחמ`, `כ`, `"`, `הס`, gen_eof
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL WIHTOUT DISCOUNT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_totals_without_discount, [
%=======================================================================

    line_with_text(`ללוכריחמ`)
		 
	, line_total_net_1
	 
	, q(0,2,line)
	 
	, line_total_vat_1
	 
	, q(0,3,line)
	 
	, line_total_invoice_1	 

] ).


%=======================================================================
i_line_rule_cut( line_total_net_1, [
%=======================================================================

  generic_item( [ total_net, d, tab ] )
   
   , `ללוכ`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_1, [
%=======================================================================

	generic_item( [ total_vat, d, tab ] ), `(`
	
	, generic_item( [ default_vat_rate, d, `%` ] ), `)`
   
   ,  `מ`, `"`, `עמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_1, [
%=======================================================================

   `חש`, currency(`ILS`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   , `ריחמ`,  `כ`, `"`, `הס`,  newline
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL WIHTOUT DISCOUNT AMOUNT ALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_totals_without_discount_1, [
%=======================================================================

    line_with_text(`ללוכריחמ`)
		 
	, line_total_net_new1
	 
	, q(0,2,line)
	 
	, line_total_vat_new1
	 
	, q(0,3,line)
	 
	, line_total_invoice_new1

] ).


%=======================================================================
i_line_rule_cut( line_total_net_new1, [
%=======================================================================

  generic_item( [ total_net, d, tab ] )
   
   , `ללוכ`,  `ריחמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_new1, [
%=======================================================================

	generic_item( [ total_vat, d, tab ] ), `(`
	
	, generic_item( [ default_vat_rate, d, `%` ] ), `)`
   
   ,  `מ`, `"`, `עמ`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_invoice_new1, [
%=======================================================================

   `חש`
   
   , currency(`ILS`)
   
   , generic_item( [ total_invoice, d, tab ] )

   , generic_item( [ dummy , s1, tab ] )

   , generic_item( [ dummy1 , s ] )
   
   ,  `:`, `דע`,  `םולשתל`,  newline
  
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

	or([
		
	  line_with_text(`תיללכהחנה`)

	, line_with_text(`ללוכ ריחמ`)

	, line_with_text(`ללוכריחמ`)
	
	] )
	
	, line_freight
	
] ).

%=======================================================================
i_line_rule_cut( line_freight, [ 
%=======================================================================
	
	generic_item( [ dummy_rounding_amount, d, q10(tab) ] )
	
	, `(`, generic_item( [ dummy_rate, d, `%` ] ), `)`
	
	, `תיללכ`, `החנה`	

	
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
              
                [line_invoice_line, q10(line_append_line) ]

			  , [line_invoice_line_1 , q10(line_append_line)]

			  , [line_descr_line, line_invoice_line_2 , q10(line_append_line)]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

   or([
	   
	   [ q10( [ `הקפסא .ת`, tab ] ), `ריחמ`, `כ`, `"`, `הס`, tab, `ךרע`, `ךיראת`, tab ]

	, [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `ךרע`,  `ךיראת`,  `הדיחיל`,  `ריחמ`,  tab, `תומכ`,  tab, `רצומ`,  `רואת`,  tab]

	, [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `הדיחיל`,  `ריחמ`,  tab  ]

   , [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `תומכ`,  tab, `רצומ`,  `רואת`,  tab]

  ] )
  
    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   [dummy(s1), tab, `ללוכ`, `ריחמ`,  newline ]

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

	q10( generic_item( [ dummy_date, date, tab ] ) )
	
	, or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

	, generic_item( [ dummy, date, q10(tab) ] )
  
	, `חש`

	, or( [ 
	
			[
			
			with( invoice, dummy_rounding_amount, DummyRounding )
			
			, generic_item( [ dummy_price, d, tab ] )
			
			]
			
			, generic_item( [ line_unit_amount, d, tab ] )
			
		] )

	, generic_item( [ dummy_uom, w ] )
  
	, generic_item( [ line_quantity, d, tab ] )

	, generic_item( [ line_descr, s1, tab ] )

	, generic_item( [ dummy_line, d, newline ] )

    , q10( 
	
			or( [ 
					
				[ test(order_number_45), general_count_rule_10 ]

				, [ test(order_number_44), general_count_rule_1 ]

			] )

		)
		
	, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================


	  q10( generic_item( [ dummy_date, date, tab ] ) )
	
	, or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

	, generic_item( [ dummy12, date, q10(tab) ] )
  
	, q10(generic_item( [ dummy_descr, s1, tab ] ))
  
	, generic_item( [ line_descr, s1, tab ] )

	, generic_item( [ dummy_line, d, newline ] )

    , q10( 
	
			or( [ 
					
				[ test(order_number_45), general_count_rule_10 ]

				, [ test(order_number_44), general_count_rule_1 ]

			] )

		)
		
	, remove(dummy_rounding_amount)

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================


	q10( generic_item( [ dummy_date, date, tab ] ) )
	
	, or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

	, generic_item( [ dummy12, date, q10(tab) ] )
  
	, generic_item( [ dummy_descr, s1, tab ] )
  
	, q10(generic_item( [ line_descr_dummy, s1, tab ] ))

	, generic_item( [ dummy_line, d, newline ] )

    , q10( 
	
			or( [ 
					
				[ test(order_number_45), general_count_rule_10 ]

				, [ test(order_number_44), general_count_rule_1 ]

			] )

		)
		
	, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr, s1, newline  ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 15 Sep, 2020
% Mapped by - Rohini 

% Updated on   - 24 Nov, 2020
% Updated by   - Rohini
% Changes made - Mapping rules updated by Taulia to capture the amount details correctly

% Updated on   - 26 Nov, 2020
% Updated by   - Rohini
% Changes made - Mapping rules updated by Taulia to capture the amount details correctly

% Updated on   - 25 Dec, 2020
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 04 Feb, 2021
% Updated by   - Rohini
% Changes made - Line details updated line_invoice_line_1

% Updated on   - 31 March, 2021
% Updated by   - Rohini
% Changes made - Negative Round off value captured as positive as per taulia 

% Updated on   - 06 April, 2021
% Updated by   - Rohini
% Changes made - Updated rules

% Updated on   - 08 April, 2021
% Updated by   - Rohini
% Changes made -   Order number updated for English format

% Updated on   - 23 June, 2021
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 19 July, 2021
% Updated by   - Rohini
% Changes made - Line details updated


% Updated on   - 22 July, 2021
% Updated by   - Rohini
% Changes made - PO # format updated


% Updated on   - 23 July, 2021
% Updated by   - Rohini
% Changes made - PO # format updated

% Updated on   - 10 Aug, 2021
% Updated by   - Rohini
% Changes made - Mapped total without discount value format

% Updated on   - 07 Oct, 2021
% Updated by   - Rohini
% Changes made - Invoice amount new format mapped.

% Updated on   - 26 Oct, 2021
% Updated by   - Rohini
% Changes made - Order number updated

% Updated on   - 27 April, 2022
% Updated by   - Rohini
% Changes made -  Date format updated

% Updated on   - 19 May, 2022
% Updated by   - Sushmitha
% Changes made -  Date format updated

% Updated on   - 17 Aug,2022
% Updated by   - Sushmitha
% Changes made - added get_original_invoice_number



% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
