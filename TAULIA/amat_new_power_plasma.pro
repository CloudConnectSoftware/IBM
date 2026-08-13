%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW POWER PLASMA CO, LTD #vendor 9000166319 #compcode 0050
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_new_power_plasma,  `2026-08-13 19:33:32` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_pdf_parameter( x_tolerance_100, 200 ).

i_user_field( invoice, einvoice_number, `KIDNO` ).  

i_user_field( invoice, einvoice_number, `KIDNO1` ).  

i_user_field( invoice, einvoice_number, `KIDNO2` ).  

i_user_field( invoice, einvoice_number, `KIDNO3` ).  

i_user_field( invoice, einvoice_number, `KIDNO4` ).  

i_user_field( invoice, einvoice_number, `KIDNO5` ).  

json_custom_field( `KIDNO`, einvoice_number ).

json_custom_field( `KIDNO1`, einvoice_number ).

json_custom_field( `KIDNO2`, einvoice_number ).

json_custom_field( `KIDNO3`, einvoice_number ).

json_custom_field( `KIDNO4`, einvoice_number ).

json_custom_field( `KIDNO5`, einvoice_number ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_invoice_number

    , get_invoice_number_1

    , get_einvoice_number
    
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

     sender_name( `NEW POWER PLASMA CO, LTD` )

   % Supplier VAT number - 212-81-44110 %

   , currency(`KRW`)

   , supplier_registration_number(`hkkim@newpower.co.kr`)

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

     , check_text(`승인번호` )

     , or([

      generic_horizontal_details( [ [`승인번호`,  q10(tab) ], invoice_number_raw, s, `관리번호` ] )

     , generic_horizontal_details( [ [`승인번호`,  q10(tab) ], invoice_number_raw, s1, newline ] )
          
] )

 , check( invoice_number_raw = InvRaw )

    , trace( [ `Invoice Number raw` , InvRaw ] )

    , check(string_string_replace( InvRaw, ` `, ``, Invstrip ))

    , trace( [ `Invoice Number raw` , Invstrip ] )

     , check(string_string_replace( Invstrip, `-`, ``, Invstrip1 ))

     , trace( [ `Invoice Number Stripped Space`, Invstrip1 ] )
     
     , invoice_number_raw1(Invstrip1)   

     , check( invoice_number_raw1 = Invstripnew )

     , check( q_sys_sub_string( Invstripnew, 9, 16, Inv_new ) )

     , invoice_number(Inv_new)     

     , trace( [ `Invoice Number` , invoice_number ] ) 

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number_1, [
%=======================================================================

     q(0,40,line)

    % , check_text(`승인번호` )

    , or([

      generic_horizontal_details( [ [`Approvalnumber` ], invoice_number_raw1, s, [`ControlNumber` ] ] )

    , generic_horizontal_details( [ [ `Approval`,  `number` ], invoice_number_raw1, s, [`Control` ] ] )
        
    
    ] )
    
    , check( invoice_number_raw1 = InvRaw1 )

    , trace( [ `Invoice Number raw` , InvRaw1 ] )

     , check(string_string_replace( InvRaw1, `-`, ``, Invstrip1 ))

     , trace( [ `Invoice Number Stripped Space`, Invstrip1 ] )
     
     , invoice_number_raw3(Invstrip1)   

     , check( invoice_number_raw3 = Invstripnew1 )

     , check( q_sys_sub_string( Invstripnew1, 9, 16, Inv_new1 ) )

     , invoice_number(Inv_new1)     

     , trace( [ `Invoice Number` , invoice_number ] ) 

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_einvoice_number, [
%=======================================================================

     q(0,40,line)

     , or([        

      generic_horizontal_details( [ [`승인번호`,  q10(tab) ], invoice_number_raw, s, `관리번호` ] )
     
    , generic_horizontal_details( [ [`승인번호`,  q10(tab) ], einvoice_number_raw, s1, newline ] )
    
    , generic_horizontal_details( [ [ `Approval`,  `number` ], einvoice_number_raw, s, [`Control` ] ] )
     
    , generic_horizontal_details( [ [`Approvalnumber` ], einvoice_number_raw, s, [`ControlNumber`,  dummy(s1),  newline ] ] )

  ] )  

    , check( einvoice_number_raw = EInvRaw )

     , trace( [ `e-Invoice number raw` , EInvRaw ] )

     , check(string_string_replace( EInvRaw, `-`, ``, EInvstrip ))

     , trace( [ `e-Invoice Stripped Space` , EInvstrip ] )

    , einvoice_number_raw1(EInvstrip)

    , trace( [ `E Invoice Number raw` , EInvstrip ] )

     , check(string_string_replace( EInvstrip, ` `, ``, EInvstrip1 ))

     , trace( [ `EInvoice Number Stripped Space`, EInvstrip1 ] )
     
     , einvoice_number(EInvstrip1) 
  
    
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

       generic_vertical_details( [ [`Date`,  `ofissue`,  `*`,  tab ], `ofissue`, q(0,1), (start,100,900), invoice_date, date, [tab, dummy(d),  tab, dummy(d),  newline ] ] )

     , generic_vertical_details( [ [`작`,  `성`,  `일`,  `자`,  tab ], `작`, q(0,1), (start,100,400), invoice_date, date, tab ] )

     , generic_vertical_details( [ [ `Date`,  `of`,  `issue` ], `Date`, q(0,1), (start,100,400), invoice_date, date, tab ] )

     , generic_vertical_details( [ [`작성일자`,  tab ], `작성일자`, q(0,1), (start,100,400), invoice_date, date, tab ] )
     
     , generic_vertical_details( [ [`작성일자`, `*`,  tab ], `작성일자`, q(0,1), (start,100,400), invoice_date, date, tab ] )

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

 ,  find_order_number


] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)


, or( [
            [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_45) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ), set(order_number_44) ]

          , [ generic_item( [ order_number , [ begin, q(alpha("P"),1,1) , q(alpha("O"),1,1) ,q(dec("4"),1,1) , q(dec("4"),1,1), q(dec,8,10) , end ] ] ), set(order_number_44) ]

          , [ generic_item( [ order_number , [ begin, q(alpha("P"),1,1) , q(alpha("O"),1,1) ,q(dec("4"),1,1) , q(dec("5"),1,1), q(dec,8,10) , end ] ] ), set(order_number_45) ]
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

  , or([

     generic_vertical_details( [ [ `SupplyPrice`,  `*`,  tab ], `SupplyPrice`, q(0,1), (start,100,900), total_net, d, [tab, dummy(d),  newline ] ] )

  , generic_vertical_details( [ [ `공`,  `급`,  `가`,  `액`,  tab ], `공`, q(0,1), (start,100,900), total_net, d , tab ] )

  , generic_vertical_details( [ [ `Supply`,  `Price`,  tab], `Supply`, q(0,1), (start,100,900), total_net, d , tab ] )

  , generic_vertical_details( [ [ `공급가액`, `*`,  tab ], `공급가액`, q(0,1), (start,100,900), total_net, d , tab ] )

] )

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

   , or([

    generic_vertical_details( [ [ `세`,  `액`,  tab ], `세`, q(0,1), (start,100,900), total_vat, d , newline ] )

  ,  generic_vertical_details( [ [ `세액`, tab ], `세액`, q(0,1), (start,100,900), total_vat, d , [ tab, `해당없음`, tab ] ] )

  , generic_vertical_details( [ [`세`,  `액`,  tab], `세`, q(0,1), (start,100,900), total_vat, d , [`계약의`,  `해제` ] ] )

  , generic_vertical_details( [ [ `Tax`, `*`,  newline ], `Tax`, q(0,1), (start,100,900), total_vat, d, newline ] )

  , generic_vertical_details( [ [ `Tax`,  tab, `Remarks` ], `Tax`, q(0,1), (start,100,900), total_vat, d, newline ] )

  , generic_vertical_details( [ [`세액`, `*`,  newline ], `세액`, q(0,1), (start,100,900), total_vat, d, newline ] )



] ) 

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

, or([

    generic_vertical_details( [ [  `Sum`,  tab, `cash`,  tab ], `Sum`, q(0,1), (start,100,900), total_invoice, d, [ tab, `0`,  tab, `0`,  tab, `0`,  tab, dummy(d),  newline ] ] )

  , generic_vertical_details( [ [  `합계금액`,  tab ], `합계금액`, q(0,2), (start,10,900), total_invoice, d , newline ] )

  , generic_vertical_details( [ [ `이`,  `금액을`,  tab], `이`, q(0,2), (start,10,900), total_invoice, d , [ tab, `[`] ] )

  , generic_vertical_details( [ [ `이`,  `금액을`,  tab ], `이`, q(0,1), (start,10,900), total_invoice, d , [ tab, `[`] ] )

  , generic_vertical_details( [ [ `이`, `금액을`, `(` ], `이`, q(0,1), (start,10,900), total_invoice, d , newline ] )

  , generic_vertical_details( [ [`Sum`,  tab, `cash`,  tab ], `Sum`, q(0,2), (start,10,900), total_invoice, d , tab ] )
  
  , generic_vertical_details( [ [ `이`,  `금액을`,  `청구` ], `이`, q(0,1), (start,10,900), total_invoice, d , tab ] )


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
              
                [line_invoice_line, q10(line_append_line) ]

              ,  [line_invoice_line_1, q10(line_append_line) ]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
      [`월`,  `일`,  tab, `품`,  `목`,  tab, `규`,  `격`,  tab ]

    , [`월`, tab, `일`, tab, `품목`, tab ]

    , [`month`,  `Work`,  tab, `Item`,  `name`,  tab ]

    , [`month`,  tab, `Work`,  tab, `Item`,  `name`,  tab ]

    , [  `월`,  tab, `일`,  tab, `품목명`,  tab, `규격`,  tab ]


] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     or([

            [`합계금액`, tab, `현금`, tab ]
  
          ,  [`합`,  `계`,  `금`,  `액`,  tab, `현`,  `금`,  tab ]

          ,  [`합계금액`,  tab, `현`,  `금`,  tab ]

          , [`Sum`,  tab, `cash`,  tab ]
     ])


     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_date_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_amount, d, newline ] )

  
  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

    generic_item( [ line_month_dummy, d, q10(tab) ] )

  , generic_item( [ line_date_dummy, d, q10(tab) ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_amount, d, newline ] )

  
  , or( [ 


    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

] )


] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 05 Sep, 2024
% Mapped by - Yamini 


% Updated on   - 16 Sep, 2024
% Updated by   -   Rohini
% Changes made -   Invoice number updated

% Updated on   - 22 Oct,2024
% Updated by   -  Rohini
% Changes made -  New Invoice format mapped

% Updated on   - 13 Mar, 2025
% Updated by   -   Rohini
% Changes made -  line_invoice_line_1 mapped


% Updated on   - 17 Mar, 2026
% Updated by   -   Rohini
% Changes made -   Invoice date updated


% Updated on   - 23 Mar, 2026
% Updated by   -   Rohini
% Changes made -   Invoice number updated

% Updated on   - 
% Updated by   -  
% Changes made -  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
