%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEUSOFT CLOUD TECHNOLOGY CO LTD / V # 9000175461 / Compcode: 0059, 0065, 0069
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_neusoft_cloud_technology, `31 July, 2024` ).

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

     sender_name( `NEUSOFT CLOUD TECHNOLOGY CO LTD` )

   % Supplier VAT number - 91210231788726543L % 

   , supplier_registration_number(`ding.xiaoyan@neusoft.com`)

  
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

            generic_vertical_details( [ [`发票号码`, `：`,  newline ], `发票号码`, q(0,1,up), (start,100,900), invoice_number_dummy, d, newline ] )

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

        generic_vertical_details( [ [ `电子发票`, `（`, `增值税专用发票`, `）`,  tab ], `电子发票`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )
            
      , generic_vertical_details( [ [`发票号码`, `：`,  newline ], `发票号码`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )
      
      , generic_horizontal_details( [ [`发票号码`, `：` ], einvoice_number, d, newline ] )    

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

   
     q(0,25,line)

   , line_add_line_date

   , q(0,1,line)

   , line_add_line_date_1
   
 ] ).

%=======================================================================
i_line_rule_cut( line_add_line_date, [
%=======================================================================

       q0n(anything)   
     
     , read_ahead([ `开票日期`, `：` ])

     , trace( [ `Found address`] )

     , generic_item( [ dummy_date, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_add_line_date_1, [
%=======================================================================

    generic_item( [ date_1, w, `年` ] )

  , generic_item( [ date_2, w, `月` ] )
  
  , generic_item( [ date_3, w, [ `日`,  newline ] ] )

  , check(strcat_list( [ date_1,` ` , date_2,` `, date_3 ], DateNew )) 

  , invoice_date(DateNew)  
  
  , trace( [ `Invoice Date Now` , invoice_date ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_1, [
%=======================================================================

   
     q(0,25,line)

   , line_add_line_date_new

   
 ] ).

%=======================================================================
i_line_rule_cut( line_add_line_date_new, [
%=======================================================================

       q0n(anything)

      , or([
       
      read_ahead([ `开`,  `票`,  `日`,  `期`])
       
     , read_ahead([`开票日期`])

           
      ])  
      
      , trace( [ `Found address`] )

     , generic_item( [ dummy_date1, s,  `：` ] )

  , generic_item( [ date_11, w, `年` ] )

  , generic_item( [ date_21, w, `月` ] )
  
  , generic_item( [ date_31, w, [ `日`,  newline ] ] )

  , check(strcat_list( [ date_11,` ` , date_21,` `, date_31 ], DateNew1 )) 

  , invoice_date(DateNew1)  
  
  , trace( [ `Invoice Date Now` , invoice_date ] )


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
        
    ] )
          
    , generic_item( [ currency, `RMB` ] )

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

 , generic_horizontal_details( [ [ `合`,  tab, `计`,  tab, dummy(s1),  tab, `¥` ], total_vat, d, newline ] )


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

          [generic_horizontal_details( [ [ `肆万贰仟叁佰柒拾伍圆整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        , [generic_horizontal_details( [ [ `肆万壹仟壹佰叁拾玖圆玖角捌分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

         , [generic_horizontal_details( [ [ `肆仟贰佰玖拾肆圆整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        , [generic_horizontal_details( [ [ `肆万零陆佰叁拾叁圆叁角叁分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        , [generic_horizontal_details( [ [ `贰拾伍万陆仟玖佰陆拾圆零捌分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

        , [generic_horizontal_details( [ [ `贰万玖仟陆佰圆壹角捌分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]

         , [generic_horizontal_details( [ [ `壹仟叁佰伍拾圆整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]  

        , [generic_horizontal_details( [ [ `壹万柒仟陆佰壹拾肆圆伍角伍分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ] 

        , [generic_horizontal_details( [ [ `壹万陆仟伍佰贰拾捌圆零伍分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ] 

        , [generic_horizontal_details( [ [ `壹万零柒佰贰拾陆圆玖角整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_item( [ currency, `RMB` ] ) ]  
        
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
              
                 [line_invoice_line, q10(line_desc_append)]

                , [line_invoice_line_1, q10(line_desc_append) ]

                , [line_invoice_line_2, q10(line_desc_append) ]

               
                , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
      
          or([
         
       [`项目名称`,  tab]


    ] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     or( [  

            [`合`,  tab, `计`,  tab ]

     ] )

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
  
  
    generic_item( [ line_descr, s1, tab ] )

  ,  generic_item( [ line_descr_dummy, s1, tab ] )

  , generic_item( [ line_dummy,w, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d , tab ] )

  , generic_item( [ line_vat_rate, d, [ `%`,  tab ] ] ) 

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

  , generic_item( [ line_net_amount, d , tab ] )

  , generic_item( [ line_vat_rate, d, [ `%`,  tab ] ] ) 

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

  , q10(generic_item( [ line_descr_dummy, w, q10(tab) ] ))

  , generic_item( [ line_descr_dummy, s1, tab ] )

  , generic_item( [ line_net_amount, d , tab ] )

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

      generic_append( [ line_descr, s1, newline, ` `, `` ] )
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 31 May, 2024
% Mapped by - Rohini


% Updated on   - 31 July, 2024
% Updated by   - Rohini
% Changes made - EInvoice number details updated

% Updated on   - 
% Updated by   -
% Changes made -

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%