%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTINUOUS LINE TECHNOLOGY LTD  - ENGLISH Version -Vendor # new -9000202538  Old vendor # 9000158304 / CoCd 0003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_continuous_line_english, `28 June, 2023` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).


i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_invoice_number

    , get_invoice_date

	, get_order_number
		
	, get_totals_1

	, get_totals_2
			
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

     sender_name( `CONTINUOUS LINE TECHNOLOGY LTD ` )

   % Supplier VAT number -512107533 %

    , currency(`ILS`)

    , buyer_vat_number(`DE811381130` ) % Hardcoded as per AMAT Team

    , buyer_tax_type( `VAT` )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [ 
%=======================================================================
	

   q(11,30,line)

 , or([

   generic_horizontal_details( [ [`Invoice` ], invoice_number , s , [ `-`] ] )

 , generic_horizontal_details( [ [`Invoice` ], invoice_number , s , [ `-`, `Copy`,  newline ] ] )
   
 , generic_horizontal_details( [ [ `Invoice`], invoice_number , s1 , newline ] )
	
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

   generic_horizontal_details( [ [`Invoice`, `Date`, `:` ], invoice_date , date , newline ] )
   

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
 
   q0n(line)

 , or([

   generic_horizontal_details( [ [ `TOTAL`, tab, generic_item( [ currency, w ] )], total_net , d , newline ] ) 

] )
    , check( total_net = TotNet)

    , generic_item( [ total_invoice , TotNet ] )

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
              
              
			 line_invoice_line_2

          ,  line_invoice_line_3

          ,  line_invoice_line_1

          ,  line_invoice_line
        
           , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

	or( [
      
		[`Document`, `Your`, `Order`, `Ln`, `Number`, `Bar` ]

      , [`Number`, tab, `No`, `.`, tab, `Description`, `Revision`, tab ]

      , [`Document`, `Your`, `Order`, `Ln`, `Number`, tab, `Bar` ]

      , [`Document`, `Your`, `Order`, `Number`, `Bar`]

      , [`Document`, `Your`, `Order`, `Ln`, tab, `Part`, tab ]
	
	] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
	
	or( [   
	  
		[ `TOTAL`, tab, `USD` ]
	
		
	] )
   
    , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
  
           generic_item( [ line_item_dummy, s, q10(tab) ] )

		 , generic_item( [ line_PO, d ] )

		 , generic_item( [ line_buyers_order_number, d  ] )

         , generic_item( [ line_dummy, s1 , tab ] )

         , generic_item( [ line_item, s1 , tab ] )

         , generic_item( [ line_dummy, s1 , tab ] )

         , generic_item( [ line_dummy, s , q10(tab) ] )
         
		 , generic_item( [ line_quantity, d , q10(tab)  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

		 , generic_item( [ line_descr_dummy, s , `USD` ] )
         
		 , generic_item( [ line_unit_amount, d, tab ] )

		 , generic_item( [ line_net_amount, d , newline ] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
        
           generic_item( [ line_item_dummy, s, q10(tab) ] )

		 , generic_item( [ line_PO, d ] )

		 , generic_item( [ line_buyers_order_number, d  ] )

         , generic_item( [ line_item, s1 , tab ] )

         , generic_item( [ line_descr, s1 , tab ] )
         
		 , generic_item( [ line_quantity, d , q10(tab)  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

		 , generic_item( [ line_descr_dummy, s , `USD` ] )
         
		 , generic_item( [ line_unit_amount, d, tab ] )

		 , generic_item( [ line_net_amount, d , newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================
        
           generic_item( [ line_item_dummy, w, q10(tab) ] )

		 , generic_item( [ line_PO, d ] )

		 , generic_item( [ line_buyers_order_number, d  ] )

         , generic_item( [ line_descr, s1 , tab ] )

         , generic_item( [ line_item, s1 , tab ] )

         , q10(generic_item( [ line_dummy1, w , q10(tab) ] ))

         , q10(generic_item( [ line_dummy2, w , q10(tab) ] ))
         
		 , generic_item( [ line_quantity_dummy, d , q10(tab)  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

       %  ,  q10(generic_item( [ line_dummy3, d, q10(tab) ] ))

		 , generic_item( [ line_descr_dummy, s , `USD` ] )
         
		 , generic_item( [ line_unit_amount, d, q10(tab) ] )

		 , generic_item( [ line_net_amount, d , newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================
        
           generic_item( [ line_item_dummy, s, q10(tab) ] )

		 , generic_item( [ line_PO, d ] )

		 , generic_item( [ line_buyers_order_number, d  ] )

         , generic_item( [ line_descr, s1 , tab ] )

         , generic_item( [ line_item, s1 , tab ] )

         , generic_item( [ line_dummy1, w , q10(tab) ] )

        % , q10(generic_item( [ line_dummy2, w , q10(tab) ] ))
         
		 , generic_item( [ line_quantity, d , q10(tab)  ] )

		 , generic_item( [ line_quantity_uom_code, w , q10(tab) ]  )

       %  ,  q10(generic_item( [ line_dummy3, d, q10(tab) ] ))

		 , generic_item( [ line_descr_dummy, s , `USD` ] )
         
		 , generic_item( [ line_unit_amount, d, tab ] )

		 , generic_item( [ line_net_amount, d , newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 26 March 2022
% Mapped by - Rohini 

% Updated on   - 25 May, 2022
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 31 May, 2022
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 13 June, 2023
% Updated by   - Rohini
% Changes made - Line details updated - Start line, line_invoice_line_1 mapped

% Updated on   - 15 June, 2023
% Updated by   - Sushmitha
% Changes made - Updated start line

% Updated on   - 16 June,2023
% Updated by   - Sushmitha
% Changes made - Added line_invoice_line_2 and line_invoice_line_3

% Updated on   - 28 June, 2023
% Updated by   -  Rohini
% Changes made -  Invoice number updated

% Updated on   - 
% Updated by   - 
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
