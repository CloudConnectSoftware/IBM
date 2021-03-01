%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ARES GREEN TECHNOLOGY CORP.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_ares_green, `28 Jan, 2021` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    %, set_credit_note

    , get_invoice_number
  
   % , get_invoice_date

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

     sender_name( `ARES GREEN TECHNOLOGY CORP.` )

   % Supplier VAT number -16834160 %

   , currency(`USD`)

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

     , check_text(`發票號碼` )

     , generic_horizontal_details( [ [`發票號碼`, `：` ], invoice_number, s1, [ tab,generic_item( [ invoice_date, date ] ),  tab ] ] )
 

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

     , check_text(`統一編號` )

     , generic_vertical_details( [ [`統一編號`, `：` ], `統一編號`, q(0,1,up), (start,100,400), invoice_date, date, newline ] )
        
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
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================

    q0n(line)

  , generic_horizontal_details( [ [ `銷售合計`, tab ], total_net, d, tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_vat, [
%=======================================================================

    q0n(line)

  , generic_horizontal_details( [ [`零稅率`, tab, `免稅`, tab], total_vat, d, tab ] )

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


  , generic_horizontal_details( [ [ `總計`, tab ], total_invoice, d, newline ] )

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
              
                 
                    [line_descr_line, line_invoice_line , q10(line_append_line) ]

                    , [[line_descr_line_1, line_invoice_line , q10(line_append_line) ] ]

                    , [line_invoice_line_1, q10(line_append_line) ]

                    , [line_invoice_line_2 , q10(line_append_line) ]


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [ `品名`, tab, `數量`, tab, `單價`, tab ]


] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   [ `銷售合計`, tab ]

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_append( [ line_descr, s1, tab, ` `, ` `  ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w,tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d,newline ] )



  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

     q10(generic_append( [ line_descr, s1, tab, ` `, ` `  ] ))
   
   , generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

    generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_quantity_uom_code, w,tab ] )

  , generic_item( [ line_unit_amount, d, [tab, `$` ] ] )

  , generic_item( [ line_net_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
] ).


%=======================================================================
i_line_rule_cut( line_descr_line_1, [
%=======================================================================

    generic_item( [ line_no_dummy, d, tab ] )

  ,  generic_item( [ line_descr, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================

    generic_item( [ line_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d,newline ] )


  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )

        ,q10([	% LINE VAT Rate Calculation
  
       with( invoice , total_vat , VAT )

      , with( invoice , total_net , Net )

      , trace( [ `vat tot`, VAT ] )

     , trace( [ `sub total`, Net ] )

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

     , trace( [ `VAT Rate`, VAT_RATE ] )
  
     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

     , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 15 Jan, 2021
% Mapped by - Rohini 



% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
