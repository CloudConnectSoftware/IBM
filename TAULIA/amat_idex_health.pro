%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  IDEX HEALTH AND SCIENCE, LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_idex_health, `28 March, 2021` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( `m/d/y` ).

i_trace_lists.

i_format_postcode( X, X ).

i_pdf_parameter( same_line, 7 ).

i_op_param( us_invoice, _, _, _, true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , get_shipto_details

    , set_credit_note

    , get_invoice_number

    , get_invoice_date

    , get_original_invoice

    , get_order_number

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
i_rule_cut( get_supplier_detail, [
%=======================================================================

     sender_name( `IDEX HEALTH AND SCIENCE, LLC` )

   % Supplier VAT number -  01-0736657 % 


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

   , q(1,2,line)

   , line_add_line_3

   , q(0,1,line)

   , line_add_line_4

   , q(0,1,line)

   , line_add_line_5

] ).

%=======================================================================
i_line_rule_cut( line_add_line, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`APPLIED`, `MATERIALS`])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, tab ] )

     , generic_item( [ delivery_party, s1, newline ] )
      

] ).


%=======================================================================
i_line_rule_cut( line_add_line_1, [
%=======================================================================

        generic_item( [ delivery_dummy2, s1, [tab, `Ship`, `To` ] ] )
      
      , generic_item( [ delivery_street, s1, newline ] )
      
] ).

%=======================================================================
i_line_rule_cut( line_add_line_2, [
%=======================================================================

        generic_item( [ delivery_dummy4, s1, [ tab, `#` ] ] )

      , generic_item( [ delivery_dummy5, d , q10(tab)] )
          
      , generic_append( [ delivery_street, s1, newline, ` `, `` ] )

] ).

%=======================================================================
i_line_rule_cut( line_add_line_3, [
%=======================================================================
 
       generic_item( [ delivery_dummy6,s1, tab ] )
          
      , generic_append( [ delivery_street, s1, newline, ` `, `` ] )
      

] ).
%=======================================================================
i_line_rule_cut( line_add_line_4, [
%=======================================================================
 
        generic_item( [ delivery_city,s1, tab ] )
          
      , generic_item( [ delivery_postcode, s1, newline ] )
 

] ).

%=======================================================================
i_line_rule_cut( line_add_line_5, [
%=======================================================================
 
        generic_item( [ delivery_dummy, s1, tab ] )
      
      , generic_item( [ delivery_country, w, newline ] )
  
  ,or([

  

       [ check(delivery_country = Ship_raw) ,check(Ship_raw = `Germany`) ,generic_item( [ delivery_country_code, `DE` ] ) ] 

    ,  [ check(delivery_country = Ship_raw) ,check(Ship_raw = `SINGAPORE`) ,generic_item( [ delivery_country_code, `SG` ] ) ] 

    ,  [ check(delivery_country = Ship_raw) ,check(Ship_raw = `Rehovot`) ,generic_item( [ delivery_country_code, `IL` ] ) ]

    ,  [ check(delivery_country = Ship_raw) ,check(Ship_raw = `Kanot`) ,generic_item( [ delivery_country_code, `IL` ] ) ]

    ,  [ check(delivery_country = Ship_raw) ,check(Ship_raw = `ISRAEL`) ,generic_item( [ delivery_country_code, `IL` ] ) ]

      
     ] )
       

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


    , [`Credit`, `Memo`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    q(0,50,line)

    , or([

      generic_vertical_details( [ [ `Invoice`, `No`, `:` ], `Invoice`, q(0,1), (start,100,100), invoice_number, d, [ tab, generic_item( [ invoice_date, date ] ),  newline ] ] )

    , generic_vertical_details( [ [ `Invoice`, `No`, `:` ], `Invoice` , q(0,1), (start,100,100), invoice_number, d , newline  ] )
    
    , generic_horizontal_details( [ [ `Credit`, `Memo`, tab ], invoice_number, d , tab ] )

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

       generic_vertical_details( [ [`Invoice`, `Date`  ], `Invoice`, q(0,1), (start,100,100), invoice_date, date, newline ] )

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIGINAL INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_original_invoice, [
%=======================================================================

    q(0,50,line)

   , test(credit_note)
   
   , or([

       generic_horizontal_details( [ [ `INV` ], original_invoice_number, d , `RMA` ] )

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

 , generic_vertical_details( [ [`Customer`, `PO`, `No`, `.`, tab ], `Customer`, q(0,1), (start,100,100), order_number, d, tab ] )
 
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

    generic_horizontal_details( [ [`Subtotal`, `:`, tab ], total_net, d, newline ] )

  , generic_horizontal_details( [ [`Subtotal`, `:`, tab ], total_net, d, [`-`,  newline ] ] )
	

] )

  , generic_item( [ currency, `USD` ] )

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

  , or([

      generic_horizontal_details( [ [`Total`, `Sales`, `Tax`, `:`, tab ], total_vat, d, newline ] )
      
    , generic_horizontal_details( [ [`Total`, `Sales`, `Tax`, `:`, tab ], total_vat, d, [`-`,  newline ] ] )

] )

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

  , or([

    [ generic_horizontal_details( [ [`Total`, `Amount`, `Due`, `:`, `$` ], total_invoice, d, newline ] )

  , generic_item( [ currency, `USD` ] )]
      
   ,[ generic_horizontal_details( [ [`Total`, `Amount`, `Due`, `:`, `$` ], total_invoice, d, [`-`,  newline ] ] )

  , generic_item( [ currency, `USD` ] )]

  , [generic_vertical_details( [ [ `Total`, `Amount`, `Due`, `:` ], `Total`, q(0,1), (start,100,200), total_invoice, d, newline ] )
  
  , generic_item( [ currency, `USD` ] )]

] )
	
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
              
                [ line_invoice_line, q10(line_append_line) , q10(line_append_line) ]

              , [line_credit_line ,q10(line_append_line) ]

              , line_additional_charge

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
       [`Line`, tab, `Qty`, `UM`, tab ]

    , [`Line`, tab, `Qty`, tab, `UM`, tab ]

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
    [`To`, `assure`, `proper`, `credit`, `,`, `please` ]

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

	
	  generic_item( [ line_buyers_order_number, d, tab ] )

    , generic_item( [ line_quantity, d, q10(tab) ] )

	, generic_item( [ line_quantity_uom_code, w, tab ] ) 

	, generic_item( [ line_item, s1, tab ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_unit_amount, d , tab ] ) 

    , generic_item( [ line_net_amount, d, newline ] ) 


] ).

%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================

	
	  generic_item( [ line_buyers_order_number, d, tab ] )

    , generic_item( [ line_quantity, d, `-` ] )

	, generic_item( [ line_quantity_uom_code, w, tab ] ) 

	, generic_item( [ line_item, s1, tab ] )

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_unit_amount, d , tab ] ) 

    , generic_item( [ line_net_amount, d, [`-`,  newline ] ] ) 


] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_additional_charge, [
%=======================================================================

  `UPS`, `Tracking`, `#`
  
  , generic_item( [ line_descr, s1, tab ] )

  , generic_append( [ line_descr, s1, tab , ``, ` `] )

  , generic_item( [ line_unit_amount_dumy, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  , line_item(`FREIGHT`)

  , line_type( `extra`)

  , check(q_sys_comp_str_gt( line_net_amount, `0` ))

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 10 Feb, 2021
% Mapped by - Rohini 


% Updated on   - 28 March, 2021
% Updated by   - Rohini
% Changes made - Line details updated with additional charges

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
