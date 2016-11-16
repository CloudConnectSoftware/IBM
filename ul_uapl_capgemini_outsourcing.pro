%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - CAPGEMINI OUTSOURCING SERVICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_capgemini_outsourcing, `08/11/2016` `4:30:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details
	
	, get_invoice_number

    , get_invoice_date

    , get_line_buyers_order_number

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
   
  
   sender_name(`CAPGEMINI OUTSOURCING SERVICES`)

  , supplier_vat_number(`20 479 766 982`)

  , currency(`EUR`)

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

    
    q0n(line)

   , generic_horizontal_details( [ [ `FACTURE`, `:`  ], 30,  invoice_number, d, newline] )
	
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

    , generic_horizontal_details( [ [ `Date`, `:` ], 30, invoice_date, date, newline ] )
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE BUYERS ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_line_buyers_order_number, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `PO`, `:` ], line_buyers_order_number, s1, newline ] )

    , check(line_buyers_order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , order_number(OrdNo)

    , trace( [ `THIS IS NOW THE Header ORDER Number` , OrdNo ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

	qn0(line) 

	, generic_horizontal_details( [ [ `Montant`, `HT`, tab ], total_net_raw, s, [`EUR`,  newline] ] )

    , check( total_net_raw = NetRaw )

    , trace( [ `Total Net raw1` , NetRaw ] )

    , check(string_string_replace( NetRaw, `,`, `.`, NetStrip ))

    , trace( [ `Total Net Stripped Comma`, NetStrip ] )
    
    , trace( [ `Total Net raw2` , NetStrip] )

    , check(string_string_replace( NetStrip, ` `, ``, NetStrip1 ))

    , trace( [ `Total Net Stripped Space` , NetStrip1 ] )

    , total_net(NetStrip1)

    , trace( [ `Total Net` , total_net ] )  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_total_vat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `Montant`, `TVA`, tab ], total_vat_raw, s, [`EUR`,  newline] ] )
    
    , check( total_vat_raw = VatRaw )

    , trace( [ `Total Vat raw` , VatRaw ] )

    , check(string_string_replace( VatRaw, `,`, `.`, VatStrip ))

    , trace( [ `Total Vat Stripped Comma`, VatStrip ] )
    
    , total_vat(VatStrip)

    , trace( [ `Total Vat` , total_vat ] )  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_total_invoice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     q0n(line)

    , generic_horizontal_details( [ [ `Montant`, `TTC`, tab ], total_invoice_raw, s, [`EUR`,  newline] ] ) 

    , check( total_invoice_raw = InvoiceRaw )

    , trace( [ `Total Invoice raw1` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `,`, `.`, InvoiceStrip ))

    , trace( [ `Total Invoice Stripped Comma`, InvoiceStrip ] )
    
    , trace( [ `Total Invoice raw2` , InvoiceStrip] )

    , check(string_string_replace( InvoiceStrip, ` `, ``, InvoiceStrip1 ))

    , trace( [ `Total Invoice Stripped Space` , InvoiceStrip1 ] )

    , total_invoice(InvoiceStrip1)

    , trace( [ `Total Invoice` , total_invoice ] )  


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

     , generic_horizontal_details( [ [ `Montant`, `TTC`, tab ], line_total_amount_raw, s, [`EUR`,  newline] ] ) 

    , check( line_total_amount_raw = TotalRaw )

    , trace( [ `Line Total Amount raw1` , TotalRaw ] )

    , check(string_string_replace( TotalRaw, `,`, `.`, TotalStrip ))

    , trace( [ `Line Total Amount Stripped Comma`, TotalStrip ] )
    
    , trace( [ `Line Total Amount raw2` , TotalStrip] )

    , check(string_string_replace( TotalStrip, ` `, ``, TotalStrip1 ))

    , trace( [ `Line Total Amount Stripped Space` , TotalStrip1 ] )

    , line_total_amount(TotalStrip1)

    , trace( [ `Line Total Amount` , line_total_amount ] )

]).

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


