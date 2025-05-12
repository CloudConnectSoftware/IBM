%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHANGHAI BOAN INDUSTRY CO LTD / V # 9000175432 / Compcode: 0059, 0069, 0065
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_shanghai_boan_industry, `2025-05-12 20:27:51` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

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

    , get_einvoice_number
  
    , get_invoice_date

    , get_invoice_date_1

   % , get_invoice_date_2 -= Do not use this format

   , get_invoice_date_3

    , get_order_number

    , get_total_net

    , get_total_net1

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

     sender_name( `SHANGHAI BOAN INDUSTRY CO LTD` )

   % Supplier VAT number - 91310101679386906G % 

   , supplier_registration_number(`wanlinlin@boanchina.net`)

  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,5,line)

     , or([        

            generic_horizontal_details( [ [ `发票号码`, `：` ], invoice_number_dummy, d, newline ] )
      
          , generic_vertical_details( [ [`发票号码`, `：`,  newline ], `发票号码`, q(0,1,up), (start,100,900), invoice_number_dummy, d, newline ] )

          , generic_vertical_details( [ [`发`,  `票`,  `号`,  `码`, `：`,  newline ], `发`, q(0,1,up), (start,100,900), invoice_number_dummy, d, newline ] )
     ])
    
     , check( invoice_number_dummy = Invstripnew )

     , check( q_sys_sub_string( Invstripnew, 5, 16, Inv_new ) )

     , invoice_number(Inv_new)     

     , trace( [ `Invoice Number: ` , invoice_number ] ) 
    
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

          generic_vertical_details( [ [`发票号码`, `：`,  newline ], `发票号码`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )
        
      ,  generic_vertical_details( [ [ `电子发票`, `（`, `增值税专用发票`, `）`,  tab ], `电子发票`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )

      , generic_vertical_details( [ [`发`,  `票`,  `号`,  `码`, `：`,  newline ], `发`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )
            
      ,  generic_horizontal_details( [ [`发票号码`, `：` ], einvoice_number, d, newline ] )    

     ])
    
    
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================
   
     q(0,10,line)

   , line_add_line_date
   
 ] ).

%=======================================================================
i_line_rule_cut( line_add_line_date, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([ `开票日期` ])

     , trace( [ `Found address`] )

    , generic_item( [ dummy_date, w, [`：`] ] )

    , generic_item( [ date_1, w, `年` ] )

    , generic_item( [ date_2, w, `月` ] )
    
    , generic_item( [ date_3, w, [ `日`,  newline] ] )

    , check(strcat_list( [ date_1,` ` , date_2,` `, date_3 ], DateNew )) 

    , invoice_date(DateNew)  
    
    , trace( [ `Invoice Date Now` , invoice_date ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE  NEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_1, [
%=======================================================================

   
     q(0,25,line)

   , line_add_date_new

   , q(0,1,line)

   , line_add_date_new1
   
 ] ).

%=======================================================================
i_line_rule_cut( line_add_date_new, [
%=======================================================================

       q0n(anything) 

     , or([ 

       read_ahead([ `开票日期`, `：` ]) 

      , read_ahead([  `开票`,  `日期`, `：` ]) 
     
    ] )
    
     , trace( [ `Found address`] )

     , generic_item( [ dummy_date_new, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_add_date_new1, [
%=======================================================================

    set(regexp_allow_partial_matching)
      
  , generic_item( [ date_111, w, `年` ] )

  , generic_item( [ date_211, w, `月` ] )
  
  , generic_item( [ date_311, w, [ `日`,  newline ] ] )

  , clear(regexp_allow_partial_matching)

  , check(strcat_list( [ date_111,` ` , date_211,` `, date_311 ], DateNew11 )) 

  , invoice_date(DateNew11)  
  
  , trace( [ `Invoice Date Now` , invoice_date ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE  NEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_3, [
%=======================================================================

   
     q(0,25,line)

   , line_add_date_1

 ] ).

%=======================================================================
i_line_rule_cut( line_add_date_1, [
%=======================================================================

       q0n(anything) 

     , or([ 

       read_ahead([ `开票日期`]) 

      , read_ahead([  `开票`,  `日期` ]) 
     
    ] )
    
     , trace( [ `Found address`] )

     , generic_item( [ dummy_date_new, s, `：` ] )

  ,  set(regexp_allow_partial_matching)
      
  , generic_item( [ date_new1, w, `年` ] )

  , generic_item( [ date_new11, w, `月` ] )
  
  , generic_item( [ date_new12, w, [ `日`,  newline ] ] )

  , clear(regexp_allow_partial_matching)

  , check(strcat_list( [ date_new1,` ` , date_new11,` `, date_new12 ], DateNew113 )) 

  , invoice_date(DateNew113)  
  
  , trace( [ `Invoice Date Now` , invoice_date ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_invoice_date_2, [
%=======================================================================

   q0n(line)

   , or( [                             

        generic_horizontal_details( [ [ `开票日期`, `：`,  q10(tab) ], invoice_date_raw, s1, newline ] )

      , generic_vertical_details( [ [ `开票日期`, `：`,  tab ], `开票日期`, q(0,1), (start,500,500),  invoice_date_raw, s1, newline ] )

      , generic_vertical_details( [ [ `开票日期`, `：`,  newline ], `开票日期`, q(0,1), (start,500,500),  invoice_date_raw, s1, newline ] )

    ] )

    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice Date raw` , DateRaw  ] )

    , check(string_string_replace( DateRaw, `年`, ` `, DateStrip  ))
    
    , invoice_date_1(DateStrip )

    , check(string_string_replace( DateStrip, `月`, ` `, DateStrip1  ))

    , invoice_date_2(DateStrip1 )

    , check(string_string_replace( DateStrip1, `日`, ``, DateStrip2  ))

    , invoice_date(DateStrip2 )

    , trace( [ `Invoice Date` , invoice_date ] )  

     
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

    , find_order_number

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
% TOTAL NET And VAT AMOUNTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================

   q0n(line)

   , or( [                           

        generic_horizontal_details( [ [ `合`,  tab, `计`,  tab, `¥` ], total_net, d, [tab, `¥`, generic_item( [ total_vat, d ] ), newline ] ] )

      , generic_vertical_details( [ [ `合`,  tab, `计`,  newline ], `合`, q(0,1,up), (start,100,900), total_net, s1, [ tab, `¥`] ] )
     
    ] )
          
    , generic_item( [ currency, `RMB` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net1, [
%=======================================================================

   q0n(line)

   , or( [   

      generic_horizontal_details( [ [ `合`,  tab, `计`,  tab, `¥` ], total_net, d, [tab, dummy(s1), newline ] ] )

    , generic_horizontal_details( [ [ `¥` ], total_net, d, [tab, `¥`, generic_item( [ total_vat, d ] ),  newline ] ] )

   ])
 
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

   , or( [ 

        generic_horizontal_details( [ [ `合`,  tab, `计`,  tab, dummy(s1),  tab, `¥` ], total_vat, d, newline ] )

      , generic_vertical_details( [ [ `合`,  tab, `计`,  newline ], `合`, q(0,1,up), (start,100,900), total_vat, d, newline ] )

    ])

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

    , or( [                         

          [generic_horizontal_details( [ [ `陆佰贰拾玖圆玖角玖分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        , [generic_horizontal_details( [ [ `（`, `小写`, `）`,  `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        
        , [generic_horizontal_details( [ [ `贰佰肆拾圆整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]  % the RMB is new currency code for CHINA vendor.
        
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
              
                 [line_invoice_line, q10(line_desc_append), q10(line_desc_append_1)]

                , [line_invoice_line_1, q10(line_desc_append), q10(line_desc_append_1)]

                , [line_invoice_line_2, q10(line_desc_append), q10(line_desc_append_1)]

               , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
      
        [`项目名称`,  tab, `规格型号`,  tab ]

    , trace( [ `Found Start line` ] )

] ).    

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     or( [

            [`合`,  tab, `计`,  tab ]

          , [`合`,  tab, `计`,  newline ]

     ] )

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_desc_dummy1, s1, tab ] )  )
  
  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_rate, d, tab ] ) 

  , generic_item( [ line_vat_amount, d, newline ] )


  , or( [ 

    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  ] )
  

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================
 
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_dummy1, s1, tab ] )

  , generic_item( [ line_dummy2, s1, tab ] )  
  
  , generic_item( [ line_quantity, d  ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_rate, d, tab ] ) 

  , generic_item( [ line_vat_amount, d, newline ] )


  , or( [ 

    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  ] )
  

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================
 
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_dummy1, s1, tab ] )

  , q10(generic_item( [ line_dummy2, s1, tab ] )  )
  
  , generic_item( [ line_quantity, d, q10(tab) ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_rate, d, [ `%`,  tab ] ] ) 

  , generic_item( [ line_vat_amount, d, newline ] )


  , or( [ 

    [ test(order_number_45), general_count_rule_10 ]

  , [ test(order_number_44), general_count_rule_1 ]

  ] )
  

] ).

%=======================================================================
i_line_rule_cut( line_desc_append, [
%=======================================================================

      generic_append( [ line_descr, s1, tab, ` `, `` ] )

      , generic_item( [ line_dummy1, s1, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_desc_append_1, [
%=======================================================================

      generic_append( [ line_descr, s1, newline, ` `, `` ] )
  
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 02 Jul, 2024
% Mapped by - Yamini M 


% Updated on   - 19 Jul, 2024
% Updated by   - Yamini M
% Changes made - updated invoice date, total net, vat, invoice & end line functions

% Updated on   - 24 July, 2024
% Updated by   - Rohini
% Changes made - EInvoice number details updated


% Updated on   - 20 Jan, 2025
% Updated by   - Rohini
% Changes made - Line details mapped line_invoice_line_2


% Updated on   - 01 Apr, 2025
% Updated by   - Rohini
% Changes made - Invoice date updated


% Updated on   - 23 Apr, 2025
% Updated by   - Rohini
% Changes made - Invoice date and Invoice number updated

% Updated on   - 12 May, 2025
% Updated by   - Rohini
% Changes made - Invoice date

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%