%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FISHER SCIENTIFIC COMPANY LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_fisher_scientific, `12 May, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( `m/d/y` ).

i_trace_lists.

i_op_param( us_invoice, _, _, _, true ).

i_format_postcode( X, X ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , set_credit_note

    , get_original_invoice_number

    , get_shipto_details

    , get_shipto_details_1

    , get_invoice_date

    , get_order_number
	 
	  , get_total_invoice
	
	  %, get_total_net

    , get_total_vat
	
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

     sender_name( `FISHER SCIENTIFIC COMPANY LLC` )

   % Supplier VAT number - D-U-N-S-00-432-1519 % 


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

     q(0,100,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

      q0n(anything)

    , [`TOTAL`, `INVOICE`, `AMOUNT`, tab, dummy(d), `-`,  newline ]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_shipto_details, [
%=======================================================================
  
     q(0,25,line)

   , line_add_line

   , q(0,1,line)

   , line_add_line_1
   
   , q(0,1,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

   , q(0,1,line)

   , line_add_line_4


] ).

%=======================================================================
i_line_rule_cut( line_add_line, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`ACCOUNTS`, `PAYABLE`])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, tab ] )

] ).


%=======================================================================
i_line_rule_cut( line_add_line_1, [
%=======================================================================

        generic_item( [ delivery_dummy2, s1, tab ] )
      
      , generic_item( [ delivery_party, s1, tab ] )
      
] ).

%=======================================================================
i_line_rule_cut( line_add_line_2, [
%=======================================================================

        generic_item( [ delivery_dummy4, s1, tab ] )
          
      , generic_item( [ delivery_street, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_add_line_3, [
%=======================================================================
 
       generic_item( [ delivery_dummy6, s1, tab ] )
      
      , generic_item( [ delivery_city, w ] )
      
      , generic_append( [ delivery_city, w, q10(tab), ` `, `` ] )

      , generic_item( [ delivery_country_dummy, w, q10(tab) ] )
      
      , generic_item( [ delivery_postcode, d, tab ] )
  
  ,or([

      
        [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `TX`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

    ,  [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `CA`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

      
     ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO DETAILS ALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_shipto_details_1, [
%=======================================================================
  
     q(0,25,line)

   , line_add_linenew

   , q(0,1,line)

   , line_add_linenew_1
   
   , q(2,3,line)

   , line_add_linenew_2

   , q(0,1,line)

   , line_add_linenew_3


] ).

%=======================================================================
i_line_rule_cut( line_add_linenew, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`ACCOUNTS`, `PAYABLE`])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, tab ] )

] ).


%=======================================================================
i_line_rule_cut( line_add_linenew_1, [
%=======================================================================

        generic_item( [ delivery_dummy1, s1, tab ] )

      , generic_item( [ delivery_dummy2, s1, tab ] )
      
      , generic_item( [ delivery_party, s1, newline ] )
      
] ).

%=======================================================================
i_line_rule_cut( line_add_linenew_2, [
%=======================================================================

        generic_item( [ delivery_dummy4, s1, tab ] )

      , generic_item( [ delivery_dummy5, s1, tab ] )
          
      , generic_item( [ delivery_street, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_add_linenew_3, [
%=======================================================================
 
       generic_item( [ delivery_dummy6, s1, tab ] )
      
      , generic_item( [ delivery_city, w ] )
      
      , generic_append( [ delivery_city, w, q10(tab), ` `, `` ] )

      , generic_item( [ delivery_country_dummy, w, q10(tab) ] )
      
      , generic_item( [ delivery_postcode, d, tab ] )
  
  ,or([

      
        [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `TX`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

    ,  [ check(delivery_country_dummy = Ship_raw) ,check(Ship_raw = `CA`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

      
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

    q(0,50,line)

    , or([

      generic_vertical_details( [ [ `INV`, `DATE` ], `INV`, q(0,1), (start,100,100), invoice_date, date, [ tab, generic_item( [ invoice_number, d ] ),  newline ] ] )

    , generic_vertical_details( [ [ `INV`, `.`, `DATE` ], `INV`, q(0,1), (start,100,100), invoice_date, date, [ tab, generic_item( [ invoice_number, d ] ),  newline ] ] )

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

  , test(credit_note)

  , generic_horizontal_details( [ [`ORIGINAL`, `INVOICE`, `#`, `:`], original_invoice_number, d, newline ] )

	
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
          [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_45) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44) ]
    ] )

 
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_net, [ 
%=======================================================================
	
	q0n(line)

   , or([
       
      generic_horizontal_details( [ [`MERCHANDISE`, `SUBTOTAL`, tab ], total_net, d, newline ] )

    , generic_horizontal_details( [ [`TOTAL`, `INVOICE`, `AMOUNT`, tab ], total_net, d, newline ] )


  ] )
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_vat, [ 
%=======================================================================
	
	q0n(line)

  , generic_horizontal_details( [ [`SALES`, `TAX`, tab ], total_vat, d, newline ] )

	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_invoice, [ 
%=======================================================================
	
	q0n(line)

  , generic_horizontal_details( [ [`TOTAL`, `INVOICE`, `AMOUNT`, tab ], total_invoice, d, newline ] )

  , generic_item( [ currency, `USD` ] )

	
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
              
                [ line_item_line,line_invoice_line, q10(line_append_line) , q10(line_append_line) ]

                , [line_invoice_line, q10(line_append_line)]

                , line_additional_line

                , line_shipping_line

                , line_non_standard_line

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
     [`DESCRIPTION`, tab, `CATALOG`, tab, `QUANTITY`, tab ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
    or([
    
      [`See`, `reverse`, `side`, `for`, `complete`, `terms`, `and`]
    
    % , [`MERCHANDISE`, `SUBTOTAL`, tab ]

    , [ `TOTAL`, `INVOICE`, `AMOUNT`, tab ]

] )
     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

	
	  generic_item( [ line_descr, s1, tab ] )

	, generic_item( [ line_descr_dummy, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy1, s1, tab ] ))

  , q10(generic_item( [ line_descr_dummy1, s1, tab ] ))

  , generic_item( [ line_quantity, d, q10(tab) ] )

	, generic_item( [ line_quantity_uom_code, w, tab ] ) 

    , generic_item( [ line_unit_amount, d , tab ] ) 

    , generic_item( [ line_net_amount, d, newline ] ) 


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )

] ).
%=======================================================================
i_line_rule_cut( line_item_line, [
%=======================================================================

     generic_item( [ line_dummy,s,  `#` ] )
  
	, generic_item( [ line_item, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_additional_line, [
%=======================================================================

  `DIRECT`, `SHIP`
  
  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline] )

  , line_item(`FREIGHT`)

  , line_type( `extra`)

  , check(q_sys_comp_str_gt( line_net_amount, `0` ))

] ).

%=======================================================================
i_line_rule_cut( line_shipping_line, [
%=======================================================================

  `SHIPPING`
  
  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline] )

  , line_item(`FREIGHT`)

  , line_type( `extra`)

  , check(q_sys_comp_str_gt( line_net_amount, `0` ))

] ).

%=======================================================================
i_line_rule_cut( line_non_standard_line, [
%=======================================================================

  `NON`, `STANDARD`
  
  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline] )

  , line_item(`FREIGHT`)

  , line_type( `extra`)

  , check(q_sys_comp_str_gt( line_net_amount, `0` ))

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 10 Feb, 2021
% Mapped by - Rohini 

% Updated on   - 11 Feb, 2021
% Updated by   - Rohini
% Changes made -  Line details updated

% Updated on   - 24 Feb, 2021
% Updated by   - Rohini
% Changes made - Line details updated, Invoice number and date updated

% Updated on   - 01 March, 2021
% Updated by   - Rohini
% Changes made - Line details updated


% Updated on   - 07 March, 2021
% Updated by   - Rohini
% Changes made - Line details updated with additional line

% Updated on   - 09 March, 2021
% Updated by   - Rohini
% Changes made - Credit note mapped

% Updated on   - 10 March, 2021
% Updated by   - Rohini
% Changes made - Shipping line mapped

% Updated on   - 12 May, 2022
% Updated by   - Rohini
% Changes made - Non Standard additional line updated

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
