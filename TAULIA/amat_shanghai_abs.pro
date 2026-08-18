%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shanghai ABS Safety Equipment Co.,Ltd 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_shanghai_abs, `2026-08-06 11:44:32` ).

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

    , get_invoice_date_2

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

     sender_name( `Shanghai ABS Safety Equipment Co.,Ltd` )

   % Supplier VAT number - 91310114778504947G % 

   , supplier_registration_number(`sunling@absehs.com`)

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

     , or([

          generic_horizontal_details( [ [`发票号码`, dummy(s) ], invoice_number_dummy, s1, newline ] )

        , generic_horizontal_details( [ [`发票号`,  `码`,  `：` ], invoice_number_dummy, s1, newline ] )

        , generic_horizontal_details( [ [`发票号码`,  `：` ], invoice_number_dummy, s1, newline ] )

        , generic_horizontal_details( [ [ `发`,  `票`,  `号`,  `码`,  `：`], invoice_number_dummy, s1, newline ] )

        , generic_vertical_details( [ [ `电子发票`, `（`, `增值税专用发票`, `）`,  tab ], `电子发票`, q(0,1,up), (start,100,900), invoice_number_dummy, s1, newline ] )
 
        , generic_vertical_details( [ [ `电`,  `子`,  `发`,  `票`,  `（`,  `增`,  `值`,  `税`,  `专`], `电`, q(0,1,up), (start,100,900), invoice_number_dummy, s1, newline ] )

        , generic_vertical_details( [ [ `发`,  `票`,  `号`,  `码`, `：`,  newline ], `票`, q(0,1,up), (start,100,900), invoice_number_dummy, s1, newline ] )

        , generic_vertical_details( [ [`发`,  `票`,  `号码`, `：`,  newline ], `发`, q(0,1,up), (start,100,900), invoice_number_dummy, s1, newline ] )

     ])

     

     , check( invoice_number_dummy = Invstripnew )

     , check( q_sys_sub_string( Invstripnew, 5, 16, Inv_new ) )

     , invoice_number(Inv_new)  

     , trace( [ `INV Number:`, invoice_number ] )   

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

    , generic_vertical_details( [ [ `电`,  `子`,  `发`,  `票`,  `（`,  `增`,  `值`,  `税`,  `专`], `电`, q(0,1,up), (start,100,900), einvoice_number, d, newline ] )

    , generic_vertical_details( [ [ `发`,  `票`,  `号`,  `码`, `：`,  newline ], `票`, q(0,1,up), (start,100,900), einvoice_number, s1, newline ] )
     
    , generic_vertical_details( [ [`发`,  `票`,  `号码`, `：`,  newline ], `发`, q(0,1,up), (start,100,900), einvoice_number, s1, newline ] )
     
    , generic_horizontal_details( [ [`发票号码`, dummy(s) ], einvoice_number, d, newline ] )

    , generic_horizontal_details( [ [`发票号`,  `码`,  `：` ], einvoice_number, s1, newline ] )

    , generic_horizontal_details( [ [ `发`,  `票`,  `号`,  `码`,  `：`], einvoice_number, s1, newline ] )

    , generic_horizontal_details( [ [`发票号码`,  `：` ], einvoice_number, s1, newline ] )

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
  
 
     q(0,50,line)

   , line_date_line

   , q(0,1,line)

   , line_date_line_1
   
] ).

%=======================================================================
i_line_rule_cut( line_date_line, [
%=======================================================================

       read_ahead([`开票日期`])

     , trace( [ `Found address`] )

     , generic_item( [ dummy_value, s1, tab ] )

] ).


%=======================================================================
i_line_rule_cut( line_date_line_1, [
%=======================================================================

      generic_item( [ date_raw_1, d, [`年` ] ] )

    ,  generic_item( [ date_raw_2, d, [`月` ] ] )

    ,  generic_item( [ date_raw_3, d, [`日`,  newline ] ] )
     
    , check( date_raw_1 = DateRaw )   

    , check( date_raw_2 = DateRaw1 )   

    , check( date_raw_3 = DateRaw2 )   


    , check(strcat_list( [ DateRaw,` ` , DateRaw1,` `, DateRaw2 ], DateNew ))   , trace( [ `New Date Format` , DateNew ] ) 
    
	, invoice_date(DateNew)  , trace( [ `Invoice Date Now` , invoice_date ] )
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_1, [ 
%=======================================================================
  
 
     q(0,50,line)

   , line_date_line1
   
] ).

%=======================================================================
i_line_rule_cut( line_date_line1, [
%=======================================================================

     or([
      
        read_ahead([`开票日期`])

      , read_ahead([ `开`,  `票日`,  `期` ])

      , read_ahead([ `开`,  `票`,  `日`,  `期` ])

      , read_ahead([ `开票日期` ])

      ])

     , trace( [ `Found address`] )

     , generic_item( [ dummy_value1, s, `：` ] )

     , set(regexp_allow_partial_matching)
     
    ,  generic_item( [ date_raw_11, d, [`年` ] ] )

    ,  generic_item( [ date_raw_21, d, [`月` ] ] )

    ,  generic_item( [ date_raw_31, d, [`日`,  newline ] ] )

    , clear(regexp_allow_partial_matching)
     
    , check( date_raw_11 = DateRaw1 )   

    , check( date_raw_21 = DateRaw11 )   

    , check( date_raw_31 = DateRaw21 )   


    , check(strcat_list( [ DateRaw1,` ` , DateRaw11,` `, DateRaw21 ], DateNew1 ))   , trace( [ `New Date Format` , DateNew1 ] ) 
    
	, invoice_date(DateNew1)  , trace( [ `Invoice Date Now` , invoice_date ] )
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE  NEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_2, [
%=======================================================================

   
     q(0,25,line)

   , line_add_line_date_new

   , q(0,1,line)

   , line_add_line_date_new1
   
 ] ).

%=======================================================================
i_line_rule_cut( line_add_line_date_new, [
%=======================================================================

       q0n(anything)   

     , or([

       read_ahead([ `开票日期`, `：` ])
     
     , read_ahead([  `开票`,  `日期`, `：` ])

   ] )
   
     , trace( [ `Found address`] )

     , generic_item( [ dummy_date, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_add_line_date_new1, [
%=======================================================================

    set(regexp_allow_partial_matching)
      
  , generic_item( [ date_11, w, `年` ] )

  , generic_item( [ date_21, w, `月` ] )
  
  , generic_item( [ date_31, w, [ `日`,  newline ] ] )

  , clear(regexp_allow_partial_matching)

  , check(strcat_list( [ date_11,` ` , date_21,` `, date_31 ], DateNew11 )) 

  , invoice_date(DateNew11)  
  
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

     q0n(line)

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
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_total_net, [
%=======================================================================
  

   qn0(line)

, or([  

      [generic_horizontal_details( [ [ `合`,  tab, `计`,  tab, `¥`, generic_item( [ total_net, d ] ),  tab, `¥` ],  total_vat, d, newline ] )

        , generic_item( [ currency, `RMB` ] )]

    , [generic_horizontal_details( [ [ `¥`, generic_item( [ total_net, d ] ),  tab, `¥` ],  total_vat, d, newline ] )

        , generic_item( [ currency, `RMB` ] )]

    
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
  

   qn0(line)

, or([  

      [generic_horizontal_details( [ [ `¥`, dummy(d),  tab, `¥`],  total_vat, d, newline ] )

        , generic_item( [ currency, `RMB` ] )]

    
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

    ,or([         

             generic_horizontal_details( [ [ `（`, `小写`, `）`, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `玖佰肆拾叁圆叁角陆分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `玖佰陆拾玖圆捌角捌分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `伍佰陆拾圆壹角陆分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `伍仟伍佰柒拾贰圆壹角贰分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `捌佰肆拾圆整`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `捌佰圆零肆分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `叁佰叁拾伍圆玖角玖分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `叁佰贰拾玖圆玖角陆分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `壹佰壹拾贰圆零叁分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `壹万肆仟贰佰壹拾柒圆整`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `壹佰零肆圆玖角玖分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `壹佰圆零壹分`,  tab, `¥` ], total_invoice, d, newline ] )
    
           , generic_horizontal_details( [ [ `肆佰肆拾肆圆叁角贰分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `肆仟捌佰贰拾玖圆零捌分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `肆仟叁佰捌拾伍圆零叁分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `肆佰零伍圆陆角柒分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `陆万捌仟壹佰肆拾玖圆玖角陆分`,  tab, `¥` ], total_invoice, d, newline ] )
           
           , generic_horizontal_details( [ [ `陆仟叁佰伍拾圆整`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `贰仟柒佰贰拾伍圆零陆分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `贰仟叁佰柒拾壹圆陆角肆分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `贰佰伍拾贰圆零柒分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `贰仟玖佰玖拾壹圆柒角捌分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `贰仟贰佰叁拾圆玖角柒分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `贰仟陆佰玖拾伍圆伍角伍分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `贰仟陆佰零伍圆玖角玖分`,  tab, `¥` ], total_invoice, d, newline ] )

            , generic_horizontal_details( [ [ `贰佰圆零壹分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `柒佰捌拾圆整`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `伍仟捌佰肆拾圆零壹分`,  tab, `¥` ], total_invoice, d, newline ] )

           , generic_horizontal_details( [ [ `柒万肆仟柒佰捌拾圆整`,  tab, `（`, `小写`, `）`,  `¥` ], total_invoice, d, newline ] )
    
    ])          


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

                 [line_invoice_line_1, q10(line_invoice_append)]

               , [line_invoice_line, q10(line_invoice_append)]

               , [line_invoice_line_2, q10(line_invoice_append)]  

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

         
       or([
         
          [`项目名称`, tab, `规格型号`, tab ]

      , [`项目名称`,  tab, `规`,  `格型号`,  tab, `单`,  `位`,  tab ]

      , [ `项`,  `目名称`,  tab, `规格型号`,  tab, `单`,  tab, `位`,  tab ]

      , [ `项目名`,  `称`,  tab, `规格型号`,  tab, `单`,  `位`,  tab ]

      , [  `品名`,  tab, `數量`,  tab, `單價`,  tab ]

      , [ `项目名称`,  tab, `规格型`,  `号`,  tab, `单`,  `位`,  tab ]

      , [ `项目名`,  `称`,  tab, `规格`,  `型`,  `号`,  tab, `单`,  tab ]

      , [ `项目`,  `名称`,  tab, `规格型号`,  tab, `单`,  `位`,  tab ]

      , [  `项目`,  `名称`,  tab, `规格型号`,  tab, `单`,  tab, `位`,  tab ]

      , [ `项目名`,  `称`,  tab, `规格型号`,  tab, `单`,  tab, `位`,  tab ]

  ] )
    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   or( [ 

        [ `合`,  tab, `计`,  tab ]
       
    %  , [ `¥`, dummy(d), tab, `¥`, dummy(d),  newline ] 

 %   , [ `合`, tab, `计`,  newline ]    % any line can take

 
       
    ] )

     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )                     

  , generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_dummy1, w, tab ] )

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

  , generic_item( [ line_dummy, w, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

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

  , generic_item( [ line_dummy, w, tab ] )

  , generic_item( [ line_quantity, d ] )

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
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )                     

  , generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_dummy, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_vat_rate, d, [`%`,  tab ] ] )

  , generic_item( [ line_vat_amount, d, newline ] )

  , or( [ 
		
		[ test(order_number_45), general_count_rule_10 ]

		, [ test(order_number_44), general_count_rule_1 ]

	] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_append, [
%=======================================================================

     generic_append( [ line_descr, s1, newline, ` `, ``] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 11 AUG, 2023
% Mapped by - Yamini 
% Merged - Vendor no- 9000175368  for company codes:0059,0069,0065

% Updated on   - 16 Aug,2023
% Updated by   - sushmitha
% Changes made - Added get_total_net1

% Updated on   - 17 Aug,2023
% Updated by   - Sushmitha
% Changes made - Updated get_invoice_number, tot_amount,line_invoice_line

% Updated on   - 21 Aug 2023
% Updated by   - Rohini
% Changes made - Invoice amount and Invoice date updated

% Updated on   - 22 Aug 2023
% Updated by   - Rohini
% Changes made - Invoice date updated

% Updated on   - 06 Sep,2023
% Updated by   - Sushmitha
% Changes made - updated get_total_net

% Updated on   - 13 Oct,2023
% Updated by   - Yamini
% Changes made - added line_invoice_line_1 and updated get_total_invoice

% Updated on   - 16 Oct,2023
% Updated by   - Yamini
% Changes made - updated line_invoice_line and get_total_invoice rules and added line_invoice_line_2 rule

% Updated on   - 24 July, 2024
% Updated by   - Rohini
% Changes made - EInvoice number details updated

% Updated on   - 12 Mar, 2025
% Updated by   - Rohini
% Changes made - Invoice date updated
 
 % Updated on   - 27 May, 2025
% Updated by   - Rohini
% Changes made - Start line updated

% Updated on   - 16 July, 2025
% Updated by   - Rohini
% Changes made -  Invoice number updated
 
% Updated on   - 05 Nov, 2025
% Updated by   - Rohini
% Changes made - Mapped line_invoice_line_3
  
% Updated on   - 27 Jan, 2026
% Updated by   - Rohini
% Changes made - New format mapped

% Updated on   - 
% Updated by   -
% Changes made -


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
