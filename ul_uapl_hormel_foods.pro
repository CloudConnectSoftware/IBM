%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - HORMEL FOODS INTERNATIONAL CORPORAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_hormel_foods, `10/11/2016` `7:55:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

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

    
    q0n(line)

   , generic_horizontal_details( [ [ `Invoice`, `Reprinted`, `On`, tab ], invoice_number_raw, s1, newline ] )

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

          , generic_vertical_details( [ [ `Amount` ], `Amount`, q(0,30), (start,20,20), total_invoice_raw, s1, newline ] )

           , check( total_invoice_raw = InvoiceRaw )

    , trace( [ `Total Invoice raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `,`, ``, InvoiceStrip ))

    , trace( [ `Total Invoice Stripped Comma`, InvoiceStrip ] )

    , trace( [ `Total invoice raw2` , InvoiceStrip] )

    , check(string_string_replace( InvoiceStrip, ` `, ``, InvoiceStrip1 ))
     
    , trace( [ `Total Invoice Stripped Space` , InvoiceStrip1 ] )

    , total_invoice(InvoiceStrip1)

    , trace( [ `Total Invoice` , total_invoice] ) 


    , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] )


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

    , generic_vertical_details( [ [ `Amount` ], `Amount`, q(0,30), (start,20,20), line_total_amount_raw, s1, newline ] )

      , check( line_total_amount_raw = TotalRaw )

    , trace( [ `Line Total Amount raw` , TotalRaw ] )

    , check(string_string_replace( TotalRaw, `,`, ``, TotalStrip ))

    , trace( [ `Line Total Amount Stripped Comma`, TotalStrip ] )

    , trace( [ `Line Total Amount raw2` , TotalStrip] )

    , check(string_string_replace( TotalStrip, ` `, ``, TotalStrip1 ))
     
     , trace( [ `Line Total Amount Stripped Space` , TotalStrip1 ] )

      , line_total_amount(TotalStrip1)

       , trace( [ `Line Total Amount` , line_total_amount] ) 

        
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



