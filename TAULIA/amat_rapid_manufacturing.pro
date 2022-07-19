%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAPID MANUFACTURING LCR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_rapid_manufacturing, `19 July, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(`m/d/y`).

i_trace_lists.

i_format_postcode( X, X ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , get_shipto_details

    , get_invoice_number
  
    , get_invoice_date

    , get_order_number

    , get_currency

    , get_total_net

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

     sender_name( `RAPID MANUFACTURING LCR` )

   % Supplier PHone number -7149741782 % For our reference only

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
   
   , q(1,2,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

] ).

%=======================================================================
i_line_rule_cut( line_add_line, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`Applied`, `Materials` ])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_party_dummy, s1, tab ] )

     , generic_item( [ delivery_dummy, s1, tab ] )

     , generic_item( [ delivery_party, s1, newline ] )


] ).


%=======================================================================
i_line_rule_cut( line_add_line_1, [
%=======================================================================

    generic_item( [ delivery_party_dummy, s1, tab ] )

  , generic_item( [ delivery_dummy, s1, tab ] )
     
  , generic_item( [ delivery_dummy1, s1, tab ] )
  
  , generic_item( [ delivery_street, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_add_line_2, [
%=======================================================================
 
     generic_item( [ delivery_dummy2, s1, tab ] )
   
  ,  generic_append( [ delivery_street, s1, newline, ` `, ` ` ] )

   
] ).

%=======================================================================
i_line_rule_cut( line_add_line_3, [
%=======================================================================
 
    generic_item( [ delivery_street_dummy, s1, tab ] )

  , generic_item( [ delivery_street_dummy, s1, tab ] )

  , generic_item( [ delivery_street_dummy, s1, tab ] )

  , generic_item( [ delivery_dummy, w ] )

  , generic_item( [ delivery_postcode, d, q10(tab) ] )

  , generic_item( [ delivery_city, w , newline ] )
   
   ,or([

      
       [ check(delivery_city = Ship_raw) ,check(Ship_raw = `BANGALORE`) ,generic_item( [ delivery_country_code, `IN` ] ) ] 

	   , [ check(delivery_city = Ship_raw) ,check(Ship_raw = `SINGAPORE`) ,generic_item( [ delivery_country_code, `SG` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `ISRAEL`) ,generic_item( [ delivery_country_code, `IL` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `United States`) ,generic_item( [ delivery_country_code, `US` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `Greece`) ,generic_item( [ delivery_country_code, `GRC` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `Tainan`) ,generic_item( [ delivery_country_code, `TW` ] ) ] 

    ,  [ check(delivery_city = Ship_raw) ,check(Ship_raw = `TAINAN`) ,generic_item( [ delivery_country_code, `TW` ] ) ] 

      
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

     , or([

       generic_horizontal_details( [ [`Invoice`, `Number`, tab ], invoice_number, d, newline ] )

     , generic_horizontal_details( [ [`Invoice`, `#`, tab ], invoice_number, d, newline ] )
 
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

        generic_horizontal_details( [ [ `Invoice`, `Date`, tab ], invoice_date, date, newline ] )

      , generic_horizontal_details( [ [ `Date`, tab ], invoice_date, date, newline ] )

   ] )
  %  , check( invoice_date_raw = DateRaw )

 %   , check(string_string_replace( DateRaw, `-`, ` `, DateStrip  ))
    
 %   , invoice_date_raw1(DateStrip )

 %   , trace( [ `Invoice Date` , invoice_date_raw1 ] )  

  %  , check( invoice_date_raw1 = DateRaw1 )    , trace( [ `Date raw1` , DateRaw1 ] )

   %  , check(q_sys_sub_string( DateRaw1, 1,2 , Substring1 ))    , trace( [ `Date raw1` , Substring1 ] )

   %  , check(q_sys_sub_string( DateRaw1, 4,2 , Substring2 ))    , trace( [ `Date raw2` , Substring2 ] )

   % , check(q_sys_sub_string( DateRaw1, 7, 2 , Substring3 ))   , trace( [ `Date raw3` , Substring3 ] )

   % , check(strcat_list( [ Substring1, ` ` , Substring2,` 20`, Substring3 ], DateNew ))   , trace( [ `New Date Format` , DateNew ] ) 
    
%	, invoice_date(DateNew)  , trace( [ `Invoice Date Now` , invoice_date ] )

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

 , generic_horizontal_details( [ [ `P`, `.`, `O`, `.`, `Number`, tab ], order_number , d , newline ] )


] ).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_currency, [
%=======================================================================

     q(0,50,line)

     , or([

         generic_horizontal_details( [ [ `Total` ], currency , w , newline ] )

        , generic_horizontal_details( [ [ `CURRENCY`, `:`], currency , w , [`$`, tab ] ] )

         
    ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================


    q(0,50,line)

    , or([
        
        generic_horizontal_details( [ [ `USD`, tab ],total_invoice, d, newline ] )

    ,  generic_horizontal_details( [ [  `CURRENCY`, `:`, `USD`, `$`, tab ],total_invoice, d, newline ] )

   ] )
   
   , check( total_invoice = TotNet)

   , generic_item( [ total_net , TotNet ] )

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
              
               [ line_invoice_line, q10(line_descr_append), q10(line_descr_append)]
                
              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [`Li`, tab, `Part`, `/`, `Description`, tab ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   [`Total`, `USD`,  newline ]

     , trace( [ `Found End line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_buyers_order_number, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , q10(generic_append( [ line_descr, s1, tab, ` `, ` ` ] ))

  , q10(generic_item( [ line_date_dummy, date ,tab ] ))

  , generic_item( [ line_quantity , d , tab ] )

  , generic_item( [ line_unit_amount, d , tab ] )

  , generic_item( [ line_net_amount, d , newline ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_descr_append, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` ` ] )
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 22 June 2022
% Mapped by - Sushmitha 


% Updated on   - 19 July, 2022
% Updated by   - Rohini
% Changes made - New format updated, mapping rules corrected for the older format, remvoed LEGAL Invoice, mapped date and line level for older and new

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
