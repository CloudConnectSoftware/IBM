%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAPID MANUFACTURING LCR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(training_amat_r_manufacturing, `13 June, 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_buyer_tax

    %, set_credit_note

    , get_invoice_number
  
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

     sender_name( `RAPID MANUFACTURING LCR` )

   % Supplier VAT number -27289758 % 

   , supplier_registration_number(`admin@win-tt.com.tw`)

   

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
% BUYER TAX DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_tax, [
%=======================================================================

     q(0,40,line)

     , check_text(`統一編號` )

     , or([

       generic_horizontal_details( [ [`統一編號`,  `:`], buyer_vat_number, d, tab ] )

     , generic_horizontal_details( [ [`統一編號`,  `:`], buyer_vat_number, d, newline ] )
     

     ] )
      

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

     , or([

        generic_horizontal_details( [ [`發票號碼`, `:` ], invoice_number, s1, tab ] )
       
       , generic_horizontal_details( [ [`發票號碼`, `：`], invoice_number, s1, tab ] )

       , generic_horizontal_details( [ [`發票號碼`, dummy(s)], invoice_number, s1, tab ] )
 
 
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

   %  , check_text(`發票號碼` )

     , or([

       generic_vertical_details( [ [`發票號碼`, `:` ], `發票號碼`, q(0,1,up), (start,100,400), invoice_date, date, newline ] )

     , generic_vertical_details( [ [`發票號碼`, `：` ], `發票號碼`, q(0,1,up), (start,100,400), invoice_date, date, newline ] )

     , generic_vertical_details( [ [`發票號碼` ], `發票號碼`, q(0,1,up), (start,100,400), invoice_date, date, newline ] )

     ,  generic_vertical_details( [ [`電子發票證明聯`,  newline ], `電子發票證明聯`, q(0,1), (start,100,400), invoice_date, date, newline ] )

 ] )

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

  , or([

    generic_horizontal_details( [ [ `合`, tab, `計`, tab, `$` ], total_net, d, tab ] )

  , generic_horizontal_details( [ [ `銷售額合計`,  tab ], total_net, d, newline ] )

] )

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

   , or([

       generic_horizontal_details( [ [`零稅率`, tab, `免稅`, tab, `$` ], total_vat, d, q10(tab) ] ) 
     
     , generic_horizontal_details( [ [`免稅`,  tab ], total_vat, d, newline ] ) 

  ] )
  
  , check( total_vat = TotVat)

  , generic_item( [ line_vat_amount , TotVat ] )  

  , generic_item( [ buyer_tax_type, `VAT` ] )
  

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


  , or([

       generic_horizontal_details( [ [ `總`, tab, `計`, tab, `$` ], total_invoice, d, q10(tab) ] )
    
     , generic_horizontal_details( [ [`總計`,  tab ], total_invoice, d, q10(tab) ] )

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
              
                    line_invoice_line_3
                  
                  , [line_descr_line_1, line_invoice_line]

                  , [line_descr_line_1, line_invoice_line_1]

                  , [line_descr_line_1, line_invoice_line_2]

                  , [line_descr_line_1, line_invoice_line_4]
                  

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
        [`品`, tab, `名`, tab, `數`, `量`, tab ]

      , [`品名`,  tab, `數量`,  tab, `單價`,  tab ]


] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   [`銷`, tab, `售`, tab, `額`, tab ]

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_descr_line_1, [
%=======================================================================

      generic_item( [ line_no_dummy, d, tab ] )

  ,  generic_item( [ line_descr, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_quantity, d, [tab, `-`,  tab ] ] )

  , generic_item( [ line_unit_amount, d, [tab, `$` ] ] )

  , generic_item( [ line_net_amount, d,newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

    generic_item( [ line_serial_number, s1, tab ] )
  
  , generic_item( [ line_quantity, d, [tab, `-`,  tab ] ] )

  , generic_item( [ line_unit_amount, d, [tab, `$` ] ] )

  , generic_item( [ line_net_amount, d,newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).
%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================

    generic_item( [ po_dummy, s1, tab ] )
  
  , generic_item( [ line_quantity, d  ] )

  , generic_item( [ line_dummy, s1, tab  ] )

  , generic_item( [ line_unit_amount, d, [tab, `$` ] ] )

  , generic_item( [ line_net_amount, d,newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).
%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy, d, tab ] ))
  
  , generic_item( [ line_quantity, d, tab  ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d  ] )

  , generic_item( [ po_dummy, s1, newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).
%=======================================================================
i_line_rule_cut( line_invoice_line_4, [
%=======================================================================

    generic_item( [ line_quantity, d  ] )

  , generic_item( [ line_quantity_uom_code, w, tab  ] )

  , generic_item( [ line_unit_amount, d, [tab, `$` ] ] )

  , generic_item( [ line_net_amount, d,newline ] )

  , generic_item( [ line_vat_type, `VAT` ] ) % When tax is 5 %

  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on -13 June, 2022
% Mapped by - Sushmitha 



% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
