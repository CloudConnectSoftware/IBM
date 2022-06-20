%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNIROM ELECTRONICS LTD / UNIROM  - HEBREW for CoCd 0109 and for 0026 (9000024687) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_unirom_hebrew, `20 June 2022` ). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

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

    , get_invoice_date

	, get_order_number

    , get_freight

	, get_totals
		
	, get_totals_1
			
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

     sender_name( `UNIROM` )

   % Supplier VAT number / Unique reference- 512371451 `   
 
   , currency(`ILS`)

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
		
  generic_horizontal_details( [ [`רוקמ`,  `-` ], invoice_number , s , [`תזכרמ`,  `סמ`,  `תינובשח`,  newline ] ] )

 , generic_horizontal_details( [ [ `קתעה`, `-` ], invoice_number , s , [ `תזכרמ`, `סמ`, `תינובשח`,  newline ] ] )

 , generic_horizontal_details( [ [`(`, `בשחוממ`,  `ךמסמ`, `)`,  `רוקמ`,  `-` ], invoice_number , s , [`תזכרמ`,  `יוכיז`,  `תינובשח`,  newline ] ] )

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
	
	or([
		
	   line_with_text(`תינובשח ךיראת`)

	,  line_with_text(`תינובשחךיראת`)

	,  line_with_text(`יוכיזהךיראת`)

	,  line_with_text(`יוכיזה ךיראת`)
	
	

] )
     
	, or([
 
	  line_invoice_date

	, line_invoice_date_1

	] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_date, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date, `:` ] ), q10(tab)
	
	,  `תינובשח`,  `ךיראת`, gen_eof
	
] ).

%=======================================================================
i_line_rule_cut( line_invoice_date_1, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date, `:` ] ), q10(tab)
	
	, `יוכיזה`,  `ךיראת`, gen_eof
	
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
i_line_rule( find_order_number, [
%=======================================================================

      q0n(anything)
    
      , or([
        
             [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("2"),1,1) , q(dec,8,10) , end ] ] ) ]

      
    ])
    
     
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE AMOUNTALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_totals_1, [
%=======================================================================

    line_with_text(`ללוכריחמ`)
	
	, line_price_before_1
		 
	 , q(0,2,line)
	 
	 , line_total_net_1
	 
	  , q(0,2,line)
	 
	 , line_total_vat_1

] ).


%=======================================================================
i_line_rule_cut( line_price_before_1, [
%=======================================================================

	generic_item( [ dummy_price_before, d, tab ] )
   
   , `ללוכ`, `ריחמ`, gen_eof
   
  
] ).

%=======================================================================
i_line_rule_cut( line_total_net_1, [
%=======================================================================
   
      generic_item( [ total_net, d, tab ] )
   
    , `החנה`, `ירחא`, `ריחמ`, gen_eof 

] ).
%=======================================================================
i_line_rule_cut( line_total_vat_1, [
%=======================================================================

	 generic_item( [ total_vat, d, [tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)` ]  ] )

	, `מ`, `"`, `עמ`, gen_eof
	
	 , currency(`ILS`)
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE AMOUNTALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_totals_1, [
%=======================================================================

    line_with_text(`ללוכריחמ`)
		 
	 , line_total_net_11
	 
	  , q(0,2,line)
	 
	 , line_total_vat_11

] ).


%=======================================================================
i_line_rule_cut( line_total_net_11, [
%=======================================================================

	generic_item( [ total_net, d, tab ] )
   
   , `ללוכ`, `ריחמ`, gen_eof
   
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat_11, [
%=======================================================================

	 generic_item( [ total_vat, d, [tab, `(` ] ] )
	
	, generic_item( [ default_vat_rate, d, [ `%`, `)` ]  ] )

	, `מ`, `"`, `עמ`, gen_eof
	
	 , currency(`ILS`)
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET FREIGHT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Invoice Totals Capture
%=======================================================================

%=======================================================================
i_rule( get_freight, [
%=======================================================================

	line_with_text(`תיללכהחנה`)
	
	, line_freight
	
] ).

%=======================================================================
i_line_rule( line_freight, [ 
%=======================================================================
	
	 generic_item( [ dummy_rounding_amount, d, tab ] )
	
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
              
              
			 [ line_invoice_line_ils, q10(line_append_line), q10(line_append_line)]

			,[ line_invoice_line_ils_1, q10(line_append_line), q10(line_append_line)]

			,[ line_invoice_line_ils_2, q10(line_append_line), q10(line_append_line)]

			,[ line_invoice_line_ils_3, q10(line_append_line), q10(line_append_line)]

			,[ line_invoice_line_ils_4, q10(line_append_line), q10(line_append_line)]

			
              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

	or( [
      
		[ `ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `הדיחיל`,  `ריחמ`,  tab ]

	] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
	
	or( [   
	  
		[ `תינובשח`,  `רפסמ`,  `דוקרב`,  newline ]
	
		
	] )
   
    , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_ils, [
%=======================================================================

		
		or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

		 , generic_item( [ currency_exchange_rate, d ,[q10(tab), `$`] ] )

		 , generic_item( [ line_unit_amount_dummy, d ,  `EA` ] )

		 , generic_item( [ line_unit_dummy1, d  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

		 , generic_item( [ line_quantity_dummy, d , tab  ] )

		 , generic_item( [ line_descr, s1 , tab ] )
         
		 , generic_item( [ line_descr_dummy, s , q10(tab) ] )

		 , generic_item( [ line_buyers_order_number, d ] )

		 , generic_item( [ line_PO, d ] )

		 , generic_item( [ line_dummy, s1 , newline ] )

, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_ils_1, [
%=======================================================================

		
		or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

		 , generic_item( [ currency_exchange_rate, d , [q10(tab), `$`]  ] )

		 , generic_item( [ line_unit_amount_dummy, d ,  `EA` ] )

		 , generic_item( [ line_unit_dummy1, d  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

		 , generic_item( [ line_quantity_dummy, d , tab  ] )

		 , q10(generic_item( [ line_descr_dummy, s1 , tab ] ))
         
		 , generic_item( [ line_descr, s , q10(tab) ] )

		 , generic_item( [ line_buyers_order_number, d ] )

	 	 , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

		 , generic_item( [ line_dummy, s1 , newline ] )


, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

   	  q10(generic_item( [ line_descr_dummy, s1 , tab ] ))
        
    , generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_ils_2, [
%=======================================================================

		
		or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

		 , generic_item( [ currency_exchange_rate, d , [q10(tab), `$`]  ] )

		 , generic_item( [ line_unit_amount_dummy, s1 ,  tab ] )

		 , q10(generic_item( [ line_descr_dummy, s1 , tab ] ))
         
		 , generic_item( [ line_descr, s1 , tab] )

		 , generic_item( [ line_descr_dummy, s , q10(tab)] )

		 , generic_item( [ line_buyers_order_number, d ] )

	 	 , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

		 , generic_item( [ line_dummy, s1 , newline ] )


, remove(dummy_rounding_amount)

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_ils_3, [
%=======================================================================

		
		or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

		 , generic_item( [ currency_exchange_rate, d , [q10(tab), `$`]  ] )

		 , generic_item( [ line_unit_amount_dummy, s1 ,  tab ] )

		 , q10(generic_item( [ line_descr_dummy, s1 , tab ] ))
         
		 , generic_item( [ line_descr, s , q10(tab) ] )
        
		 , generic_item( [ line_buyers_order_number, d ] )

	 	 , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

		 , generic_item( [ line_dummy, s1 , newline ] )


, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_ils_4, [
%=======================================================================

		
		or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, q10(tab) ] )
		
	] )

		 , generic_item( [ currency_exchange_rate, d , [q10(tab), `$`]  ] )

		 , generic_item( [ line_unit_amount_dummy, s1 ,  tab ] )

		 , generic_item( [ line_descr_dummy, s1 , tab ] )
         
		 , generic_item( [ line_descr, s1 , tab ] )

		 , generic_item( [ line_descr_dummy, s , q10(tab) ] )
        
		 , generic_item( [ line_buyers_order_number, d ] )

	 	 , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

		 , generic_item( [ line_dummy, s1 , newline ] )


, remove(dummy_rounding_amount)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 29 March, 2022
% Mapped by - Rohini 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
