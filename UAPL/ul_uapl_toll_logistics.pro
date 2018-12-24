%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - TOLL LOGISTICS (ASIA) LIMITED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_toll_logistics, `19 April 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

   % ,get_currency

    ,get_bank_account_no

    , get_credit_note

    , get_Invoice_tax 

	, get_invoice_number

    , get_invoice_date

    , get_line_buyers_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice


       
    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
   
  
   sender_name(`TOLL LOGISTICS (ASIA) LIMITED`)

   , supplier_vat_number(`M20129625X`)

    , set(freight_vendor)

    , currency( `SGD` )

  ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_credit_note, [
%=======================================================================

    q(0,50,line)

    , credit_note_line

    
] ).

%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)

    , `CREDIT`, `NOTE`

    , set(credit_note)

    , trace( [ `CREDIT NOTE FOUND` ] )

] ).

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

	q(0,250,line)

     , with( invoice, currency, Currency )

     , or( [
  
     [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `A`, `/`, `C`, `No`, `.`,q10(tab) ],  supplier_bank_account_number, w, [`(`, `SGD`, `)`,  newline] ] ) ]

    ,[ check( Currency = `USD` ), generic_horizontal_details( [ [ `A`, `/`, `C`, `No`, `.`, q10(tab)],  supplier_bank_account_number, w, `(`, `USD`, `)`,  newline ] ) ]

    ,[ check( Currency = `SGD` ), generic_horizontal_details( [ [  `Account`, q10(tab)],  supplier_bank_account_raw, s1,  tab ] ) 

     , check(supplier_bank_account_raw  =SupNo)

    ,check(strip_string2_from_string1( SupNo, `-`, SupNoNew ))

     ,supplier_bank_account_number(SupNoNew)]
                

          ] )
	

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TAX INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_Invoice_tax, [
%=======================================================================


    q(0, 10, line)
    
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
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q0n(line)

  ,  or( [

     
     generic_horizontal_details( [ [ `Invoice`, q10(`No`), q10(tab), `:` , q10(tab) ], invoice_number , w, newline ] )

     ,generic_horizontal_details( [ [ `Credit`,`Note` ,`Number`, `:` , tab ], invoice_number , w, newline ] )

     ,generic_horizontal_details( [ [ q10(`TAX`), `INVOICE` ],  invoice_number, s1, tab ] )

   

   ] )
	
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

     ,  or( [

      generic_horizontal_details( [ [ q10(`Invoice`), `Date`,q10(tab), `:`, q10(tab) ],  invoice_date, date, newline ] )

    ,  generic_horizontal_details( [ [ q10(`Credit`), `Date`,tab, `:` ], 100, invoice_date, date, newline ] )  

    , generic_horizontal_details( [ [ `INVOICE`, `DATE` ],  invoice_date,date , newline ] )

     ] )
    	
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

     ,  or( [

          generic_horizontal_details( [ [ `PO`, `Ref`, tab, `:` ],100,  order_number, d, newline ] )

      ,  generic_horizontal_details( [ [ `Account`, `No`, tab, `:`, tab ], 100, order_number, w, newline ] )

      ,  generic_horizontal_details( [ [ `PO`, `No`, tab, `:`, tab ], 100, order_number, w, newline ] )

       ] )

       , check(line_buyers_order_number = OrdNo)

       , trace([`Order Number Capital Varaible` , OrdNo])

       , order_number(OrdNo)

       , trace( [ `THIS IS NOW THE Header ORDER Number` , OrdNo ])

    ] ). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

      qn0(line)

      ,  or( [


          generic_horizontal_details( [ [ `Subtotal` ],350, total_net,d, newline ] )

          ,generic_horizontal_details( [ [ `Amount`, `EXCLUDING`, `GST` ],500, total_net,d, newline ] )

     
   ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================
 
     qn0(line)

     ,  or( [

      

    generic_horizontal_details( [ [ `GST`, `at`, `7`, `%`, `on`, `SGD`, dummy_num(d) ], 250, total_vat, d, newline  ] )


    ,generic_horizontal_details( [ [ `GST`, `of`, `7`, `%`, tab, dummy_num(d) ], 250, total_vat, d, newline  ] )


    ,generic_horizontal_details( [ [ `ADD`, `GST`, tab ],  total_vat, d, newline ] )

   

 ] )

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     qn0(line)

    , or([ 
        
       generic_horizontal_details( [ [ `Amount`, `DUE`],350, total_invoice, d, newline] )

       ,generic_horizontal_details( [ [ `Grand`, `Total`],800, total_invoice, d, newline] )

       ,generic_horizontal_details( [ [ `Balance`, `Due`,tab, `SGD`], total_invoice, d, newline] )

      ])
                
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Currency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     q0n(line)

    , or([ 
        generic_horizontal_details( [ [ `Balance`, `Due`], currency, w] )

       , generic_horizontal_details( [ [`7`, `%`, `On`], currency, w, dummy_net(d)] )

       , generic_vertical_details( [ [ `Amount`], `Amount`, q(0,1), (end,40,40), currency,w,   newline ] )

       , [generic_vertical_details( [ [ `Amount`], `Amount`, q(0,1), (end,40,40), currency_raw,w, [`)`,  newline] ] )

        , check( currency_raw = CurrencyRaw )

    , trace( [ `Curency raw` , CurrencyRaw ] )

    , check(string_string_replace( CurrencyRaw , `(`,`` , Currency ))

    , trace( [ `Bracket stripped Currency` , Currency ] )

	, currency( Currency )

    , trace( [ `New Currency` , currency ] )]


    , generic_vertical_details( [ [ `Amount`], `Amount`, q(1,0), (end,40,40), currency,w,newline ] )


    , invoice_currency

    ])

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

    q0n(anything)

    , `SGD`

,currency( `SGD` )

,trace( [ `currency found` ] )


] ).