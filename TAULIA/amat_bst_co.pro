%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BST CO.,LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_bst_co, `05 May, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , set_credit_note

    , get_invoice_number
    
   % , get_shipto_details

    , get_invoice_date

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
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `BST CO.,LTD` )

   % Supplier VAT number -124-86-32423 %

   , currency(`KRW`)

   , supplier_registration_number(`SYJEON@BST-TECH.CO.KR`)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( set_credit_note, [
%=======================================================================

     q(0,50,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule_cut( credit_note_line, [
%=======================================================================

     q0n(anything)

     , or([

       [dummy(date), tab, `-`, dummy(s), tab, `-` ]

    , [`-`, dummy(s), tab, `[`, `청구`, `]`,  newline ]

    ] )
    
    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,40,line)

     , check_text(`승인번호` )

     , generic_horizontal_details( [ [`승인번호`,  q10(tab) ], invoice_number_raw, s1, newline ] )

     , check( invoice_number_raw = InvRaw )

     , check( q_sys_sub_string( InvRaw, 9, 16, Inv_new ) )

     , invoice_number(Inv_new)     

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,50,line)

     , check_text(`작성일자` )

     , generic_vertical_details( [ [`작성일자`,  tab], `작성일자`, q(0,1), (start,100,400), invoice_date, date, tab ] )
        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,50,line)

 % , check_text(`비` )

 , or( [

 % , generic_horizontal_details( [ [ `비`,  `고`,  `1`,  tab], order_number, d, `(` ] )

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
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    q0n(line)

  , generic_vertical_details( [ [ `공`,  `급`,  `가`,  `액`,  tab ], `공`, q(0,1), (start,100,900), total_net, d , tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

    q0n(line)

  , generic_vertical_details( [ [ `세`,  `액`,  tab ], `세`, q(0,1), (start,100,900), total_vat, d , q10(tab) ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

    q0n(line)

, generic_vertical_details( [ [ `이`,  `금액을`,  tab ], `이`, q(0,1), (start,10,900), total_invoice, d , [ tab, `[`] ] )


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
              
              
                  
                  [line_descr_line, line_invoice_line_3 , q10(line_append_line) ]
                  
                , [line_descr_line, line_invoice_line_5 ,q10(line_append_line) ]
                
                , [line_descr_line , line_invoice_line_1, q10(line_append_line) ]

                , [line_descr_line, line_invoice_line_2 ,q10(line_append_line) ]               
                
                , [line_item_line, line_invoice_line_3 , line_itemappend_line]

                , [ line_invoice_line_4 , q10(line_append_line) ]

                , [line_invoice_line, q10(line_append_line) ]   


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [`월`,  `일`,  tab, `품`,  `목`,  tab, `규`,  `격`,  tab ]


] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   [`합계금액`,  tab, `현`,  `금`,  tab ]

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_net_amount, d,tab ] )

  , generic_item( [ line_vat_amount, d, q10(tab) ] )

  , generic_item( [ line_reference, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, q10(tab) ] )

  , generic_item( [ line_vat_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

     q10(generic_append( [ line_descr, s1, tab, ` `, ` `  ] ))
   
   , generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).
%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

 % , generic_item( [ line_descr, s1, tab ] )
  
  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_item_line, [
%=======================================================================

    generic_item( [ line_item, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_itemappend_line, [
%=======================================================================

    generic_append( [ line_item, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_append( [line_descr, s1, tab, ` `, ` `  ] )

  , generic_item( [ line_item_dummy, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_4, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )
  
  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, q10(tab) ] )

  , generic_item( [ line_vat_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_5, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_append( [line_descr, s1, tab, ` `, ` `  ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d,tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 17 Nov, 2020
% Mapped by - Rohini 


% Updated on   - 08 March, 2022
% Updated by   - Rohini
% Changes made - line_invoice_line_2 mapped

% Updated on   - 25 March, 2022
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 05 May, 2022
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 
% Updated by   -
% Changes made -

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
