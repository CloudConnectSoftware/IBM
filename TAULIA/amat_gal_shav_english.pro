%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GAL SHVAV MECHANICA LTD. - English Version - -	900192598 and 9000158309 - 003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_gal_shav_english, `16 June, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_op_param( us_invoice, _, _, _, false ).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_user_field( invoice, dummy_rounding_amount, `dummy_rounding_amount` ).

i_format_postcode( X, X ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_shipto_details

    , get_buyer_vat

    , get_invoice_number_english

    , get_invoice_date_english

    , get_order_number

    , get_total_discount

	, get_total_vat % Always 0
	
	, get_total_invoice
	
	, get_invoice_lines


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_supplier_detail, [
%=======================================================================

     sender_name( `GAL SHVAV MECHANICA LTD.` )

   % Supplier VAT number - 511398760% 

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER VAT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_vat, [ 
%=======================================================================
	
	q(11,20,line)

    , [generic_horizontal_details( [ [ `Company`,  `Number`, `:` ], buyer_vat_number_raw, s1, tab ] )
    
    , check( buyer_vat_number_raw = NumRaw )

    , check(string_string_replace( NumRaw, ` `, ``, NumRawStrip ))

    , buyer_vat_number(NumRawStrip)

    , trace( [ `Buyer Vat` , buyer_vat_number ] )]

    , generic_item( [ buyer_tax_type, `VAT` ] )
   
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number_english, [ 
%=======================================================================
	
	q0n(line)

    , or([

      generic_horizontal_details( [ [ `Export`, `Invoice` ], invoice_number, s, `-` ] )


] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_english, [ 
%=======================================================================
	
	q0n(line)

    , or([

      generic_horizontal_details( [ [`Invoice`, `Date`, `:`], invoice_date, date, newline ] )

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

     q(0,60,line)

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
% TOTAL DISCOUNT(English Lang)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_discount, [
%=======================================================================

     q(0,40,line)

     , or([
 
   generic_horizontal_details( [ [`Overall`,  `Disc`, `.`,  `(`, `-`, generic_item( [  dummy_rate, d ] ), `%`, `)`,  tab ,`-` ],dummy_rounding_amount, n, newline ] )
    
 , generic_horizontal_details( [ [`Overall`,  `Disc`, `.`,  `(`, `-`, generic_item( [  dummy_rate, d ] ), `%`, `)`,  tab ],dummy_rounding_amount, d, newline ] )

 , generic_horizontal_details( [ [`Overall`, `Disc`, `.`, `(`, `-`,  generic_item( [  dummy_rate, d ] ), `%`, `)`, tab, `-` ],dummy_rounding_amount, n, newline ] )
    
    
] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_invoice, [ 
%=======================================================================
	
	q0n(line)

  ,  generic_horizontal_details( [ [`TOTAL`, tab, `USD`  ], total_invoice, d, newline ] )

   , generic_item( [ currency, `USD` ] )

   , generic_item( [ total_vat, `0` ] )

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
                
               
             [line_invoice_line_english_rounding, q10(line_append_line)]
             
             , [line_invoice_line_english , q10(line_append_line)]

            , [line_invoice_line_english_1 , q10(line_append_line)]

            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
          [ `Description`, tab, `Price`,  newline ]

        , [`Description`,  newline ]

        , [ `Number`, tab, `Description`, tab, `Price` ]

        , [`Ln`,  `P`, `.`, `LIST`,  tab, `Your`,  `Order` ]

      , [`Number`, tab, `Number`, tab, `Description`,  newline ]
      
] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   or([
       
        [`TOTAL`, tab, `USD` ]

] )

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_english, [
%=======================================================================

	
		
	  generic_item( [ line_reference, d, q10(tab) ] )

    , generic_item( [ line_item_dummy, s , q10(tab)] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

    , generic_item( [ line_buyers_order_number_dummy, d ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_descr_dummy, s1, tab ] ) 

	, generic_item( [ line_quantity, d, q10(tab) ] )
  
	, generic_item( [ line_quantity_uom_code, w, [ q10(tab), `USD` ] ] )

	, generic_item( [ line_unit_amount_dummy, d , tab ] )

    , generic_item( [ line_net_amount, d, newline   ] )

    , with( line , line_buyers_order_number_dummy , ORDLINE )

    , check(sys_calculate_str_multiply( ORDLINE, `10`, PO_ITEM ))

    , generic_item( [ line_buyers_order_number , PO_ITEM ] )
   

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_english_1, [
%=======================================================================

	
		
	  generic_item( [ line_reference, d, q10(tab) ] )

    , generic_item( [ line_item_dummy, s , q10(tab)] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], `-` ] )

    , generic_item( [ line_buyers_order_number_dummy, d ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_descr_dummy, s1, tab ] ) 

	, generic_item( [ line_quantity, d, q10(tab) ] )
  
	, generic_item( [ line_quantity_uom_code, w, [ q10(tab), `USD` ] ] )

	, generic_item( [ line_unit_amount_dummy, d , tab ] )

    , generic_item( [ line_net_amount, d, newline   ] )

    , with( line , line_buyers_order_number_dummy , ORDLINE )

    , check(sys_calculate_str_multiply( ORDLINE, `10`, PO_ITEM ))

    , generic_item( [ line_buyers_order_number , PO_ITEM ] )
   

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_english_rounding, [
%=======================================================================

	
		
	  generic_item( [ line_reference, d, q10(tab) ] )

    , generic_item( [ line_item_dummy, s , q10(tab)] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], `-` ] )

    , generic_item( [ line_buyers_order_number_dummy, d ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_descr_dummy, s1, tab ] ) 

	, generic_item( [ line_quantity, d, q10(tab) ] )
  
	, generic_item( [ line_quantity_uom_code, w, [ q10(tab), `USD` ] ] )

	, generic_item( [ line_unit_amount_dummy, d , tab ] )

    
	  ,	or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, q10(tab) ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, newline ] )
		
	] )

    , with( line , line_buyers_order_number_dummy , ORDLINE )

    , check(sys_calculate_str_multiply( ORDLINE, `10`, PO_ITEM ))

    , generic_item( [ line_buyers_order_number , PO_ITEM ] )
   

	, remove(dummy_rounding_amount)

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================
         
     generic_append( [ line_descr, s1, newline, ``,  ` `  ] )
   
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Updated on   - 06 May, 2022
% Updated by   - Rohini
% Changes made - English language format mapped


% Updated on   - 16 June, 2022
% Updated by   - Rohini
% Changes made - Line details updated with start line

% Updated on   - 
% Updated by   -
% Changes made -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%