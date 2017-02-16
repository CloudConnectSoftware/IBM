%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - BT SINGAPORE PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_bt_singapore_ltd , `5/12/2016` `6:55:05`).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	get_supplier_details

    ,set_Invoice_tax

   	, get_invoice_number

    , get_invoice_date

	, get_due_date

    , get_order_number

    , get_total_net

    , get_total_vat

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

    sender_name( `BT SINGAPORE PTE LTD` )

    , supplier_vat_number(`M2-0001715-3`)

    , set(freight_vendor)

    ] ).

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TAX INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_Invoice_tax, [
%=======================================================================

    q(0, 100, line)
    
        , invoice_tax_line

] ).

%=======================================================================
i_line_rule( invoice_tax_line, [
%=======================================================================

q0n(anything)

	,`Tax`, `Invoice`

	, set(tax_invoice)

	, trace( [ `Found Tax Invoice` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

   q0n(line)
	
   	, generic_horizontal_details( [ [ `Invoice`, `Number`, `:`, tab ], invoice_number, d, newline ] )
  

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

   q0n(line)
	
	 , generic_horizontal_details( [ [ `Date`, `:`, tab ],  invoice_date, date, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

q0n(line)
	
    , generic_horizontal_details( [ [ `Payment`, `Due`, `By`, `:`, tab ], due_date, date, newline ] )

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
	
    , or([
    generic_horizontal_details( [ [ `Reimbursement`, `Statement`, `(`],  order_number, w, `)` ] )
    
    ,generic_horizontal_details( [ [ `usage`, `(` ],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `Fixed`, `Voice`, `-`, `Baseline`, `(`],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `UAPL`, `(`],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `DASHBOARD`, `(`],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `Centres`, `(`],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `Centre`, `(`],  order_number, w, [`)` , newline ] ]  )

    ,generic_horizontal_details( [ [ `2017`, `)`, `(` ],  order_number, w, [`)` , newline ] ]  )

    
    
    ])

    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE LINE ORDER Number` , order_number ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [  
%=======================================================================

	q0n(line)


    , with( invoice, order_number, Order_Number )

, check( i_user_check( check_po_currency, Order_Number, Currency ) )

, or( [

  [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `Recurring`, `Charges`, tab, `USD`, tab ], total_net, d, or([ `CR` , newline ])  ] ) ]

, [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Total`, `Charges`, tab, `SGD`, tab ], total_net, d, or([ `CR` , newline ]) ] ) ]

,[ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`, tab ], total_net, d, newline ] ) ]

, [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`, tab ], total_net, d, newline ] ) ]

 , [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `Usage`, `Charges`, tab, `USD`, tab ], total_net, d, newline ] ) ]


] )

, currency( Currency )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

	q0n(line)

    , with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , or( [

    
    [ check( Currency = `USD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate, d ] ), `%`, tab, `USD`],150, total_vat, d, or([ `CR` , newline ]) ] ) ]

    , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Total`, `GST`, tab, `SGD`],100, total_vat, d, or([ `CR` , newline ]) ] ) ]

    ,[ check( Currency = `SGD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate, d ] ), `%`, tab, `SGD`],150, total_vat, d, newline ] ) ]

    , generic_item( [ default_vat_rate, `7` ] )

   ] )

  
  
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

    , with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , or( [

       [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `USD`, tab ], total_invoice, d, or([ `CR` , newline ]) ] ) ]

     , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD`, tab ], total_invoice, d, or([ `CR` , newline ]) ] ) ]

     
     ] )

     , currency( Currency )
  
] ).

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_total_amount, [
%=======================================================================

     qn0(line)

     , with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , or( [

     [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `USD`, tab ], line_total_amount, d, newline ] ) ]

    , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `SGD`,  tab ], line_total_amount, d, newline ] ) ]

     , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD`, tab ], line_total_amount, d, or([ `CR` , newline ]) ] ) ]

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
    
    , line_descr( `Goods Charges` )

]).