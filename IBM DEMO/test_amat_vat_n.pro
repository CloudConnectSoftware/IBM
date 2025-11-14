%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE-TECH PRECISION ENGINEERING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_ace_tech_precision, `28 Oct, 2025` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_format_postcode( X, X ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , get_shipto_address

    , get_invoice_number
    
    , get_invoice_date

    , get_order_number

    , get_currency

    , get_total_net

    , get_total_vat

    , get_total_invoice

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

     sender_name( `ACE TECH PRECISION ENGINEERING` )
   
    % Supplier VAT number - 52-842916-K `   %


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_shipto_address, [
%=======================================================================

     q(0,25,line)

    , line_delivery_party

   , q(0,1,line)

   , line_delivery_street

   , q(0,1,line)

   , line_delivery_city

] ).


%=======================================================================
i_line_rule( line_delivery_party, [
%=======================================================================
    
     q0n(anything)
     
    , read_ahead([`APPLIED`, `MATERIALS`])

    , trace( [ `Found address`] )
 
    , generic_item( [ delivery_party , s1, tab ] )   
       
] ).

%=======================================================================
i_line_rule( line_delivery_street, [
%=======================================================================
     
       generic_item( [ delivery_street, s1, tab ] )   

    
] ).
%=======================================================================
i_line_rule( line_delivery_city, [
%=======================================================================
     
      generic_item( [ delivery_city, w , q10(tab) ] )

    ,  generic_item( [ delivery_postcode, d , tab ] )   
     
   ,or([

      
       [ check(delivery_city = Ship_raw) ,check(Ship_raw = `BANGALORE`) ,generic_item( [ delivery_country_code, `IN` ] ) ] 

	   , [ check(delivery_city = Ship_raw) ,check(Ship_raw = `SINGAPORE`) ,generic_item( [ delivery_country_code, `SG` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `ISRAEL`) ,generic_item( [ delivery_country_code, `IL` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `United States`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `Greece`) ,generic_item( [ delivery_country_code, `GRC` ] ) ] 

      
     ] )  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

     q(0,40,line)

     , check_text(`Invoice` )

     , generic_horizontal_details( [ [`Invoice`, `No`, `:` ], invoice_number, s1, newline ] )

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

     
     , generic_horizontal_details( [ [ `Date`, `:` ], invoice_date , date , newline ] )

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

  ,  find_order_number

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
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_currency, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `Currency`, `:` ], currency , w , tab ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================

    q0n(line)


  , generic_horizontal_details( [ [`Sub`, `Total`, tab ], total_net, d , newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_vat, [
%=======================================================================

    q0n(line)

 
  , generic_horizontal_details( [ [`GST`, `@`, generic_item( [ default_vat_rate, d ] ), `%`, tab ], total_vat, d , newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_invoice, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `Total`, `Payable`, tab ], total_invoice, d , [`*`, `*`,  newline ] ] )


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

               [ line_invoice_line_3, line_descr_append]
              
              , [line_invoice_line_2,line_descr_append]
              
              , [line_invoice_line,line_descr_append]

              , [line_invoice_line_1,line_descr_append]

              

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [ `Item`, tab, `DO`, `No`, tab ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     [`Sub`, `Total`, tab ]

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
   

    generic_item( [ line_buyers_order_number, d, tab ] )

  , generic_item( [ line_descr, s , q10(tab) ] )

  , q10(generic_item( [ line_descr_dummy, s1 , tab  ] ))

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d , q10(tab) ] )

  , generic_item( [ line_net_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
 

    generic_item( [ line_buyers_order_number, d , tab ] )

    , generic_item( [ line_descr, s , [`&`] ] )

   , generic_item( [ line_quantity, d ] )

  , generic_item( [ line_unit_amount, d  ] )

  , generic_item( [ line_net_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================
   

    generic_item( [ line_buyers_order_number, d, tab ] )

  , generic_item( [ line_descr, s , q10(tab) ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d ,  q10(tab) ] )

  , generic_item( [ line_net_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================
  
    generic_item( [ line_buyers_order_number, d, tab ] )

  , generic_item( [ line_item_dummy, w ] )

  , generic_item( [ line_descr, s, q10(tab)] )

  , generic_item( [ line_quantity, d ] )

  , generic_item( [ line_unit_amount, d ] )

  , generic_item( [ line_net_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_descr_append, [
%=======================================================================
  
     generic_item( [ line_descr_dummy, s, [`:`,  tab ] ] )

  , generic_append( [ line_descr, s1, newline, ` `, ` ` ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 18 April 2022
% Mapped by - Sushmitha 



% Updated on   - 09 May 2022
% Updated by   -Sushmitha
% Changes made - updated line_invoice_line

% Updated on   - 09 June 2022
% Updated by   - Sushmitha
% Changes made - added line_invoice_line_1

% Updated on   - 17 July, 2023
% Updated by   - Rohini
% Changes made -  line_invoice_line_2 mapped


% Updated on   - 26 Sep,2023
% Updated by   - Sushmitha
% Changes made - Updated line_invoice_line_2

% Updated on   - 06 Jan,2024
% Updated by   - ROhini
% Changes made - Updated line_invoice_line_3 and mapped line_descr_append

% Updated on   - 
% Updated by   -
% Changes made -



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
