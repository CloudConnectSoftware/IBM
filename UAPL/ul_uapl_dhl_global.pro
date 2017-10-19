%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - DHL GLOBAL FORWARDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_dhl_global, `8/8/2016` `4:00:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details
	
	, get_invoice_number

 	, get_invoice_date

    %, get_invoice_date_alternative

    , get_order_number

	, get_total_invoice

    , get_currency

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
  
      sender_name(`DHL GLOBAL FORWARDING`)

	   , supplier_vat_number(`M2-0010793-4`)

        , set(freight_vendor)

   ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================
    
    q(0,50,line)

    , or([

      generic_horizontal_details( [ [  `TAX`,  `INVOICE` , `NO`, tab ], 100, invoice_number, s1, newline ] ) 

      , generic_vertical_details( [ [ `Please`, `Quote` ], `Quote`, q(0,2), (start,10,10), invoice_number, s1, newline ] )

      , generic_horizontal_details( [ [ `TAX`, `INVOICE` ], invoice_number, s1, tab ] ) 

        ])

    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

 q(0,30,line)

 , or([

     generic_horizontal_details( [ [`Date`, tab ],  invoice_date, date, newline ] )

     , generic_horizontal_details( [ [`DATE` ],  invoice_date, date, newline ] )

     , generic_vertical_details( [ [`Invoice`], `Invoice`, q(0,1), (start,100,500), invoice_date, date, newline ] )

     
     
        ])
	
] ).


%=======================================================================
i_rule( get_invoice_date_alternative, [
%=======================================================================

 q(0,50,line)

 , before_date_line

 , q(0,1,line)

 , capture_date_line

 , q(0,1,line)

 , after_date_line
	
] ).

%=======================================================================
i_line_rule( before_date_line, [
%=======================================================================

   `Invoice`,  newline

] ).

%=======================================================================
i_line_rule( capture_date_line, [
%=======================================================================
    
    q10(generic_item( [ date_raw, w, tab ] ))

   ,generic_item( [ invoice_date_raw, w,  newline ] )

   , check( invoice_date_raw = DateRaw )    , trace( [ `Date raw` , DateRaw ] )

    , check(q_sys_sub_string( DateRaw, 1,2 , Substring1 ))    , trace( [ `Date raw1` , Substring1 ] )

    , check(q_sys_sub_string( DateRaw, 3,3 , Substring2 ))    , trace( [ `Date raw2` , Substring2 ] )

    , check(q_sys_sub_string( DateRaw, 6, 2 , Substring3 ))   , trace( [ `Date raw3` , Substring3 ] )

    , check(strcat_list( [ Substring1,` ` , Substring2,` `, Substring3 ], DateNew ))   , trace( [ `New Date Format` , DateNew ] ) 
    
	, invoice_date(DateNew)  , trace( [ `Invoice Date Now` , invoice_date ] )

] ).

%=======================================================================
i_line_rule( after_date_line, [
%=======================================================================

  q10( `Date`),  q10(newline)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================    
i_rule( get_order_number, [
%=======================================================================

    q0n(line)

      , generic_horizontal_details( [ [ `FXL`, `/`, `3PB`, `-`, `PO`, `#` ], order_number, d, newline ] )

      , check(order_number = OrdNo)

      , trace([`Order Number Capital Varaible` , OrdNo])

      , line_buyers_order_number(OrdNo)

      , trace( [ `THIS IS NOW THE LINE ORDER Number` , order_number ])

       
      ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     q0n(line)

     , or([

       generic_horizontal_details( [ [ `AMOUNT`, `DUE`, `TO`, `US`, tab, `DEBIT`, tab, or([ `USD`, `SGD` ]), tab  ],  total_invoice, d, newline ] )

       , generic_horizontal_details( [ [`TOTAL`, `DUE`, tab,dummy_num1(d), tab ], total_invoice, d, [tab, `USD`,  newline ] ] )

        , generic_horizontal_details( [ [ `TOTAL`, dummy_num(d), tab ], total_invoice, d, newline ] )

        , generic_horizontal_details( [ [ `TOTAL`, dummy_num(w), tab ], total_invoice, d, newline ] )

        , generic_horizontal_details( [ [ `TOTAL`, `DUE`, tab ], total_invoice, d, tab ] )

        ])

    , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_currency, [
%=======================================================================
   
   q0n(line)

   , or([

       generic_horizontal_details( [ [`AMOUNT`, `DUE`, `TO`, `US`, tab, `DEBIT`, tab], currency, w, tab ] )

       , generic_horizontal_details( [ [ `TOTAL`, `DUE`, tab, dummy(d), tab ], currency, w, newline ] )

        , generic_horizontal_details( [ [ `TOTAL` ], currency, w, tab ] )


         ])

] ).

