%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - HORMEL FOODS INTERNATIONAL CORPORAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_hormel_foods, `16/1/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( `m/d/y` ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details
	
	, get_invoice_number

 	, get_invoice_date
    
    , get_order_number

    , get_total_invoice

    , get_line_total_amount

    , get_invoice_lines

    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
  
     
    sender_name(`HORMEL FOODS INTERNATIONAL CORPORAT`)

     , currency( `USD` )

     , buyer_registration_number(`MY00`)

     , supplier_registration_number(`50281268`)
   
     , set(freight_vendor)

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q( 0,20 , line)

   , or([ 
       
       
     generic_horizontal_details( [ [`1`, `HORMEL`, `PL`, `,`, `AUSTIN`, `,`, `MN`, `55912`, `-`, `3673`, tab ], invoice_number_raw, s1, newline ] )

   , generic_horizontal_details( [ [ `Invoice`, `Reprinted`, `On`, tab ], invoice_number_raw, s1, newline ] )

   , generic_vertical_details( [ [ `Invoice`, `Number` ], `Invoice`, q(0,3), (start,100,400), invoice_number_raw, d, newline ] )


   ])

      , check( invoice_number_raw = NumberRaw )

      , trace( [ `Invoice Number raw` , NumberRaw ] )

      , check(string_string_replace( NumberRaw, ` `, ``, NumberStrip ))

      , trace( [ `Invoice Number Stripped Space`, NumberStrip ] )
    
      , invoice_number(NumberStrip)

      , trace( [ `Invoice Number` , invoice_number ] ) 



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

 q0n(line)

    , generic_vertical_details( [ [ `Ship`, `&`, `Invoice`, `Date` ], `Invoice`, q(0,1), (start,70,70), invoice_date_raw, s1, tab ] )

    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice Date raw` , DateRaw  ] )

    , check(string_string_replace( DateRaw, ` `, ``, DateStrip  ))

    , trace( [ `Invoice Date Stripped Space`, DateStrip ] )
    
    , invoice_date(DateStrip )

    , trace( [ `Invoice Date` , invoice_date ] )  


	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_order_number, [
%=======================================================================

 q0n(line)

    , generic_vertical_details( [ [ `Purchase`, `Order`, `No` ], `Purchase`, q(0,1), (start,20,20), order_number, d ] )

   
    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE HEADER ORDER Number` , line_buyers_order_number ])

    
    ] ).    
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

    qn0(line)

          , or([
              
              generic_horizontal_details( [ [ `TOTAL`, `GROSS`, `WEIGHT`, dummy_num1(d) , tab, dummy_num2(s1), tab, dummy_num3(s1) , tab, set( regexp_cross_word_boundaries ) ], total_invoice  , d, newline ] )

              ,generic_horizontal_details( [ [ `TOTAL`, `GROSS`, `WGT`, tab, dummy_num1(d) , tab, dummy_num2(s1), tab, dummy_num3(s1) , tab, set( regexp_cross_word_boundaries ) ], total_invoice  , d , newline ] )

              , generic_horizontal_details( [ [  `TOTAL`, `GROSS`, `WGT`, tab, dummy(d), `LBS`, tab, dummy(d), tab, dummy(d), tab ], total_invoice, d, newline ] ) 

          ])
          

           , clear( regexp_cross_word_boundaries )
  


        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )


] ).
   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_total_amount, [
%=======================================================================
                  
     q0n(line)

    , or([

        generic_horizontal_details( [ [ `TOTAL`, `GROSS`, `WEIGHT`, dummy_num4(d) , tab, dummy_num5(s1), tab, dummy_num6(s1) , tab ], line_total_amount_raw  , s1 , newline ] )

       , generic_horizontal_details( [ [ `TOTAL`, `GROSS`, `WGT`, tab , dummy_num4(d) , tab, dummy_num5(s1), tab, dummy_num6(s1) , tab ], line_total_amount_raw  , s1 , newline ] )

       , generic_horizontal_details( [ [  `TOTAL`, `GROSS`, `WGT`, tab, dummy(d), `LBS`, tab, dummy(d), tab, dummy(d), tab ], line_total_amount_raw, d, newline ] ) 

    ])

    , check( line_total_amount_raw = TotalRaw )

    , trace( [ `Line Total Amount raw` , TotalRaw ] )

    , check(string_string_replace( TotalRaw, `,`, ``, TotalStrip ))

    , trace( [ `Line Total Amount Stripped Comma`, TotalStrip ] )

    , trace( [ `Line Total Amount raw2` , TotalStrip] )

    , check(string_string_replace( TotalStrip, ` `, ``, TotalStrip1 ))
     
    , trace( [ `Line Total Amount Stripped Space` , TotalStrip1 ] )

    , line_total_amount(TotalStrip1)

    , trace( [ `Line Total Amount` , line_total_amount ] ) 

        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_lines, [
%=======================================================================
   
   q0n(line)
    
    , line_descr( `Goods & Services` )

]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - December 1, 2017
% Updated by   - Rohini 
% Changes made - Invoice number

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%