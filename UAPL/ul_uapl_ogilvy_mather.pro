%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - OGILVY & MATHER (S) PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_ogilvy_mather, `2/11/2016` `9:30:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details
    
	
	, get_invoice_number

 	, get_invoice_date
    
    , get_due_date

    , get_order_number

    , get_invoice_totals

    ,get_bank_account_no

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
  
     
    sender_name(`OGILVY & MATHER (S) PTE LTD`)

    , supplier_vat_number(`M200030362`)
    
    , set(freight_vendor)

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

	q0n(line)

    , with( invoice, currency, Currency )

	, or([
        [check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Account`, `NO`, `:`, q10(tab)],  supplier_bank_account_number, w, [`(`, `SGD`] ] )]

        ,[check( Currency = `USD` ) ,generic_vertical_details( [ [ `Account`, `NO`, `:` ], `No`, q(0,1), (end,10,30), supplier_bank_account_number, w,  [`(`, `USD`]  ] )]

        ,[check( Currency = `EUR` ) ,generic_vertical_details( [ [ `Account`, `NO`, `:` ], `No`, q(1,2), (end,10,30), supplier_bank_account_number, w,  [`(`, `EUR`]  ] )]

    ])
	

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q0n(line)

   , or([ generic_horizontal_details( [ [ `Invoice`, `Number`, `:`, tab ],  invoice_number, s1, newline ] ) 

  , generic_horizontal_details( [ [ `credit` ,`note`, `Number`, `:`, tab ],  invoice_number, s1, newline ] ) 

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

 q0n(line)

    , generic_horizontal_details( [ [ `Date`, `:`, tab ], 100, invoice_date, date, newline ] )
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_due_date, [
%=======================================================================

 q0n(line)

    , generic_horizontal_details( [ [ `Due`, `date`, `:`, tab ], 100, due_date, date, newline ] )
	
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

    , or([generic_horizontal_details( [ [ `Client`, `Requisition`, `:`, tab  ], order_number,  s, `/` ] )

    , generic_horizontal_details( [ [ `Client`, `Requisition`, `:`, tab  ], order_number,  s1,  tab ]) 

    , generic_horizontal_details( [ [ `Client`, `Requisition`, `:`, tab  ], order_number,  s1,  newline ]) 

])

    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE HEADER ORDER Number` , line_buyers_order_number ])

    
    ] ).    
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_totals, [
%=======================================================================

    q0n(line)

          , or([
              [generic_horizontal_details( [ [ `Total`, `Excluding`, `tax`, tab ], total_net, d, newline ] )


         , q(0,1,line)

         , generic_horizontal_details( [ [ `GST`, tab, generic_item( [ default_vat_rate, d ] ), `%`, tab ], total_vat, d, newline ] )

         , q(0,15,line)

         , generic_horizontal_details( [ [ `Invoice`, `Total`, generic_item( [ currency, w ] ), tab ], total_invoice, d, newline ] ) ]
         

         ,[generic_horizontal_details( [ [ `Total`, `Excluding`, `tax`, tab , `(` ], total_net, d, [ `)` ,newline ] ] )


         , q(0,1,line)

         , generic_horizontal_details( [ [ `GST`, tab, generic_item( [ default_vat_rate, d ] ), `%`, tab , `(` ], total_vat, d, [ `)` ,newline ] ] )

         , q(0,15,line)

         , generic_horizontal_details( [ [`Credit`, `Note`, `Total`, generic_item( [ currency, w ] ), tab , `(` ], total_invoice, d, [ `)` ,newline ] ] ) ]



          ])
  
    
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
             [ generic_horizontal_details( [ [ `Total`, `Excluding`, `tax`, tab ], line_net_amount, d, newline ] )

         , q(0,1,line)

         , generic_horizontal_details( [ [ `GST`, tab, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab ], line_vat_amount, d, newline ] )

         , q(0,15,line)

         , generic_horizontal_details( [ [ `Invoice`, `Total`, generic_item( [ currency_dummy, w ] ), tab ], line_total_amount, d, newline ] )]


         
         ,[generic_horizontal_details( [ [ `Total`, `Excluding`, `tax`, tab , `(` ], line_net_amount, d, [ `)` ,newline ] ] )


         , q(0,1,line)

         , generic_horizontal_details( [ [ `GST`, tab, generic_item( [ default_vat_rate_1, d ] ), `%`, tab , `(` ], line_vat_amount, d, [ `)` ,newline ] ] )

         , q(0,15,line)

         , generic_horizontal_details( [ [`Credit`, `Note`, `Total`, generic_item( [ currency_dummy1, w ] ), tab , `(` ], line_total_amount, d, [ `)` ,newline ] ] ) ]

         ] )


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
    
    , line_descr( `Line Charges` )

]).



