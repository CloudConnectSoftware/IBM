%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAT, Inc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(test_amat_vat_n, `2025-11-14 16:44:00` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(`m/d/y`).

i_trace_lists.

i_format_postcode( X, X ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    %, get_shipto_address %

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

     sender_name( `VAT, Inc` )

   % Supplier VAT number -  % 


] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================
  
  q(0,20,line)

% %11: `INVOICE`,  `1137765`,  tab, `4521376069`,  newline

, generic_horizontal_details([[ `INVOICE`], invoice_number ,d,tab ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

  q(0,20,line)

% `Invoice`,  `Date`,  tab, `11`, `/`, `12`, `/`, `2025`,  newline
 
%generic_horizontal_details( [ [ Before Text ],  Variable, Data Type, After ] )

%, generic_horizontal_details([[`Invoice`,  `Date`, tab ], date , newline ])

, generic_horizontal_details([[`Invoice`,  `Date`, tab ],invoice_date, date , newline ])

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_order_number, [
%=======================================================================

    q0n(line)

  , check_text(`Cust` )

  , or([ 
    
    generic_horizontal_details( [ [`Cust`, `.`, `P`, `.`, `O`, `.`, tab ], order_number, d, newline ] )

  , generic_horizontal_details( [ [ `Cust`, `.`,  `P`, `.`, `O`, `.`,  tab ], order_number, d, [a(w),  newline ] ] )

  , generic_vertical_details( [ [  `Cust`, `.`,  `P`, `.`, `O` ], `Cust`, q(0,1,up), (start,100,300), order_number, d, newline ] )

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
              
                 line_shipping_line

              , [line_invoice_line, q10(line_append_line), q10(line_item_line)]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
        [`Part`, tab, `Unit`, `Price`, tab ]

      %  , [`Item`, `Order`,  newline ]

    ] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
    or([
    
      [`VAT`, `,`, `Inc`, `.`, tab, `Please`]
    
    , [`Sales`,  `Tax`,  tab, `$` ]

    , [`Sub`,  `Total`, `:`,  tab ]

    ] )
    
     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
   
    generic_item( [ line_buyers_order_number_dummy, d, tab ] )

  , generic_item( [ line_quantity, d,q10(tab)  ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_unit_amount, d, [ tab, `$`] ] )

  , generic_item( [ line_net_amount, d, newline ] )

     , with( line , line_buyers_order_number_dummy , ORDLINE )
  
     , check(sys_calculate_str_multiply( ORDLINE, `10`, PO_ITEM )) 

     , generic_item( [ line_buyers_order_number , PO_ITEM ] )


] ).

%=======================================================================
i_line_rule_cut( line_item_line, [
%=======================================================================
   
       `Cust`, `.`, `Part`

    , generic_item( [ line_descr_dummy, s1, tab ] )
     
    , generic_item( [ line_item, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================
   
     generic_append( [ line_descr, s1, newline, ` `, ` ` ] )

] ).

%=======================================================================
i_line_rule_cut( line_shipping_line, [
%=======================================================================

    q0n(anything)
   
  , read_ahead([`Freight`, `:` ])
   
  , generic_item( [ line_descr, s1, [tab, `$`] ] )
  
  , generic_item( [ line_net_amount, d, newline ] )

  , line_item(`FREIGHT`)

  , line_type( `extra`)

  , check(q_sys_comp_str_gt( line_net_amount, `0` ))

  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 16 Sep, 2021
% Mapped by - Rohini 

% Updated on   - 12 Oct, 2021
% Updated by   - Rohini
% Changes made - Line details format updated with end line updation


% Updated on   - 07 Nov,2022
% Updated by   - Sushmitha
% Changes made - updated end line

% Updated on   - 30 Nov,2022
% Updated by   - Sushmitha
% Changes made - Updated total_amount

% Updated on   - 07 Dec,2022
% Updated by   - Sushmitha
% Changes made - Updated invoice number , updated header line

% Updated on   - 19 Jan,2023
% Updated by   - Sushmitha
% Changes made - Freezed extra start and end lines

% Updated on   - 23 Jan,2023
% Updated by   - Sushmitha
% Changes made - unfreezed start line

% Updated on   - 03 Jan, 2024
% Updated by   - Rohini
% Changes made - Invoice number and order number updated

% Updated on   - 19 Jul, 2024
% Updated by   - Yamini
% Changes made - Updated end line, currency, total net and invoice details   

% Updated on   - 20 Aug, 2025
% Updated by   - Rohini
% Changes made -  Invoice number and PO # updated

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
