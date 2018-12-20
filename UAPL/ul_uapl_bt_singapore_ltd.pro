%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - BT SINGAPORE PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_bt_singapore_ltd , `29/05/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( font_size, 40 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	get_supplier_details

    , get_credit_note

    , set_Invoice_tax

   	, get_invoice_number

    , get_invoice_date

	, get_due_date

    , get_order_number_alternative

   % , get_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    ,get_bank_account_no

    , get_line_total_amount

    , get_invoice_lines

    ,get_line_vat

    %, get_total_line_net

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
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

	q(0,250,line)

     , with( invoice, currency, Currency )

     , or( [
  
   [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `SGD`, `A`, `/`, `C`, `No`, `:`, tab ],  supplier_bank_account_number_raw, w, newline ] ) 

  , check(supplier_bank_account_number_raw=Sacc), check(Sacc=`041-578238-001`), generic_item( [ supplier_bank_account_number, `578238001` ] )

   ]


,   [ check( Currency = `USD` ), generic_horizontal_details( [ [`USD`, `A`, `/`, `C`, `No`, `:`, tab],  supplier_bank_account_number_raw, w, newline ] ) 

  , check(supplier_bank_account_number_raw=Sacc), check(Sacc=`260-387295-180`), generic_item( [ supplier_bank_account_number, `260387295180` ] )

 ] 
                
 ] )

	

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
% GET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_credit_note, [
%=======================================================================

    q0n(line)

    , credit_note_line

    
] ).

%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)

   , `Credit`, `Note`, `to`, `Offset`, `Invoice`

    , set(credit_note)

    , trace( [ `CREDIT NOTE FOUND` ] )

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

    without(order_number)

    , q0n(line)  
	
    , or([
         
    generic_horizontal_details( [ [ `Reimbursement`, `Statement`, `(`],  order_number, w, `)` ] )

    ,  [  
        
        set(regexp_allow_partial_matching) , generic_horizontal_details( [ [ `DO` ],  order_number_raw, d, [`-`, `V2`, `)`] ]  )

      , check( order_number_raw = OrdRaw ) ,trace( [ `Raw PO Number` , OrdRaw ] ) 

      , check(strcat_list( [ `DO`,OrdRaw ], OrdNew ))   , trace( [ `New PO Number` , OrdNew ] ) 
    
	  , order_number(OrdNew)  , trace( [ `Invoice PO Now` , order_number ] ) 
      
      , clear(regexp_allow_partial_matching) 
      
      ]

    ,  [  
        
        set(regexp_allow_partial_matching) , generic_horizontal_details( [ [ `DO` ],  order_number_raw, d, [`)`] ]  )

        , check( order_number_raw = OrdRaw ) ,trace( [ `Raw PO Number` , OrdRaw ] ) 

        , check(strcat_list( [ `DO`,OrdRaw ], OrdNew ))   , trace( [ `New PO Number` , OrdNew ] ) 
    
	    , order_number(OrdNew)  , trace( [ `Invoice PO Now` , order_number ] ) 
      
        , clear(regexp_allow_partial_matching) 
        
    ]
     
    , generic_horizontal_details( [ [ `usage`, `(` ],  order_number, w, [ `-`, `V2`, `)`, newline ] ]  )
    
    , generic_horizontal_details( [ [ `usage`, `(` ],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `Fixed`, `Voice`, `-`, `Baseline`, `(`],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `UAPL`, `(`],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `DASHBOARD`, `(`],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `Centres`, `(`],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `Centre`, `(`],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `2017`, `)`, `(` ],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `MMR`,  `(` ],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `30M`, `/`, `25M`, `(` ],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [  `17`, `(` ] ,  order_number, w, [ `-`, `V2`, `)`] ]  )

    , generic_horizontal_details( [ [ `16`, `(` ] ,  order_number, w, [ `)` , newline ] ]  )

    , generic_horizontal_details( [ [ `17`, `(` ] ,  order_number, w, [ `)` , newline ] ]  )

    , generic_horizontal_details( [ [ `Active`, `(` ] ,  order_number, w, [ `)` , newline ] ]  )

    , generic_horizontal_details( [ [`)`, `(` ] ,  order_number, w, [ `)` , newline ] ]  )

    , generic_horizontal_details( [ [ `charge`, `(` ],  order_number, w, [ `-`, `V2`, `)`, newline ] ]  )

    , generic_horizontal_details( [ [ `office`, `(` ],  order_number, w, [ `)` , newline ] ] )

    , generic_horizontal_details( [ [ `account`, `22570124`, `(` ],  order_number, w,  [ `)` , newline ]  ]  )

    , generic_horizontal_details( [ [ `charge`, `(` ],  order_number, w, [ `)` , newline ] ] )

    , generic_horizontal_details( [ [ `discount`, `(` ],  order_number, w, [ `)` , newline ] ] )

    , generic_horizontal_details( [ [ `centre`, `(`, generic_item( [ dummy_number1, w ] )],  order_number, w, [`)` , newline ] ]  )
     
    , generic_horizontal_details( [ [ `renewal`, `(` ],  order_number, w, [ `)` , newline ] ] ) 

    , generic_horizontal_details( [ [ `MBC`,  `(` ],  order_number, w, [`)` , newline ] ]  )

    , generic_horizontal_details( [ [ `Channel`, `(` ],  order_number, w, [ `)` , newline ] ] ) 
    
    , generic_horizontal_details( [ [ `Acres`, `(` ],  order_number, w, [ `)` , newline ] ] ) 

    , generic_horizontal_details( [ [ `Numbering`, `(` ],  order_number, w, [ `)` , `in` ] ] )
 
    ] )

    

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_order_number_alternative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number_alternative, [
%=======================================================================

    q(40,100,line)

    , find_order_header_line

    , q(0,5,line)

    , find_order_number

] ).

%=======================================================================
i_line_rule_cut( find_order_header_line, [
%=======================================================================

   q10(`Service`) , q10(`details`) 

] ).

%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([ check_text(`PO`), check_text(`DO`) ])

    , or([
        
        generic_item( [ order_number , [ begin, q(alpha("D"),1,1) , q(alpha("O"),1,1) , q(dec,5,15) , end ] ] )

        , generic_item( [ order_number , [ begin, q(alpha("P"),1,1) , q(alpha("O"),1,1) , q(dec,5,15) , end ] ] )

    ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [  
%=======================================================================

     with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    ,trace( [ `currency`, Currency ] )

    , q0n(line)

, or( [

    [ 
      check( Currency == `USD` ) , generic_horizontal_details( [ [`Total`, `Usage`, `Charges`, tab, `USD` ], 150,total_net_raw1, d, newline  ] ) 

    , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, total_net_raw2, d,  newline  ] ) 

    , check( total_net_raw1= TotNet1 ) , trace( [ `Total net Raw 1` ,TotNet1 ] )  
    
    , check( total_net_raw2= TotNet2 ) , trace( [ `Total net Raw 2` ,TotNet2 ] )

    , check(sys_calculate_str_add( TotNet1, TotNet2, TotNetNew))  ,total_net(TotNetNew) , trace( [ `Total net` , total_net ] )
  ]

  , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Recurring`, `Charges`, tab, `USD` ], 150,total_net, d, or([ `CR` , newline ])  ] ) ]

  , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Charges`, tab, `SGD`],150, total_net, d, or([ `CR` , newline ]) ] ) ]

  , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, total_net, d, or([ `CR` , newline ]) ] ) ]

  , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,total_net, d, or([ `CR` , newline ]) ] ) ]

 , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Usage`, `Charges`, tab, `USD` ],150, total_net, d, newline ] ) ]

 , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,total_net, d, `cr` ] ) ]

 , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `Charges`, tab, `SGD` ], 500, total_net, d, newline ] ) ]

 , [ check( Currency == `GBP` ) ,generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `GBP`],150, total_net, d, or([ `CR` , newline ]) ] )] 

 , [ check( Currency == `GBP` ) ,generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `GBP`,tab, `-`], total_net, d, or([ `CR` , newline ]) ] )]

 
] )

, currency( Currency )

, q10( [  
         check( q_sys_comp_str_le( total_net, `0` ) )   

       , set( credit_note )     
       
      , trace( [ `Document Value < 0 - CREDIT NOTE SET` ] )  
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

	   with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    ,trace( [ `currency`, Currency ] )

    , qn0(line)

    , or( [

     [ test( credit_note ),  check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `SGD`],150, total_vat, d, or([ `CR` , newline ]) ] ) ]

     ,[ test( credit_note ), check( Currency == `USD` )  , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `USD`],150, total_vat, d, or([ `CR` , newline ]) ] ) ]

    , [ check( Currency == `USD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `USD`],150, total_vat, d,  newline  ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `GST`, tab, `SGD`],100, total_vat, d, or([ `CR` , newline ]) ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `GST`, tab, `SGD`],150, total_vat, d , newline ] ) ]

    ,[ check( Currency == `SGD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `SGD`],150, total_vat, d, newline ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `Taxation`, tab, `SGD`],500, total_vat, d , newline ] ) ]

    ,[ check( Currency == `GBP` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `GBP`],150, total_vat, d,or([ `CR` , newline ]) ] ) ]

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

	   with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

     ,trace( [ `currency`, Currency ] )

    , qn0(line)

    , or( [

       [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `USD`],150, total_invoice, d, or([ `CR` , newline ]) ] ) ]

     , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD` ],150 , total_invoice, d, or([ `CR` , newline ]) ] ) ]

     , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD` ],150 , total_invoice, d, or([ `CR` , newline ]) ] ) ]

     , [ check( Currency == `GBP` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `GBP`,tab, `-` ], total_invoice, d,  or([ `CR` , newline ]) ] ) ]



     
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

       with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

     ,trace( [ `currency`, Currency ] )

    , q0n(line)

    , or( [

     [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `USD`], 150, line_total_amount, d, newline ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `SGD` ],150,  line_total_amount, d, newline ] ) ]

     , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD` ],150, line_total_amount, d, or([ `CR` , newline ]) ] ) ]

      , [ check( Currency == `USD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `USD`],150, line_total_amount, d, or([ `CR` , newline ]) ] ) ]

      , [ check( Currency == `GBP` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `GBP`, tab, `-` ],  line_total_amount, d, or([ `CR` , newline ])  ] ) ]  
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL Line NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_line_net, [  
%=======================================================================

	  with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , q0n(line)

, or( [

     [ 
      check( Currency == `USD` ) , generic_horizontal_details( [ [`Total`, `Usage`, `Charges`, tab, `USD` ], 150,line_net_raw1, d, newline  ] ) 

    , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, line_net_raw2, d,  newline  ] ) 

    , check( line_net_raw1= LineNet1 ) , trace( [ `Total net Raw 1` ,LineNet1 ] )  
    
    , check( line_net_raw2= LineNet2 ) , trace( [ `Total net Raw 2` ,LineNet2 ] )

    , check(sys_calculate_str_add( LineNet1, LineNet2, LineNetNew))  ,line_net_amount(LineNetNew) , trace( [ `Total Line net` , line_net_amount ] )
  ]

 , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Recurring`, `Charges`, tab, `USD` ], 150,line_net_amount, d, or([ `CR` , newline ])  ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Charges`, tab, `SGD`],150, line_net_amount, d, or([ `CR` , newline ]) ] ) ]

,[ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, line_net_amount, d, newline ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,line_net_amount, d, newline ] ) ]

, [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Usage`, `Charges`, tab, `USD` ],150, line_net_amount, d, or([ `CR` , newline ]) ] ) ]

 , [ check( Currency == `GBP` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `GBP` ],150, line_net_amount, d, or([ `CR` , newline ]) ] ) ]

] )



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_vat, [
%=======================================================================

	   with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , qn0(line)

    , or( [

     [ test( credit_note ),  check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `SGD`],150, line_vat_amount, d, or([ `CR` , newline ]) ] ) ]

     ,[ test( credit_note ), check( Currency == `USD` )  , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `USD`],150, line_vat_amount, d, or([ `CR` , newline ]) ] ) ]

    , [ check( Currency == `USD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `USD`],150, line_vat_amount, d,  newline  ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `GST`, tab, `SGD`],100, line_vat_amount, d, or([ `CR` , newline ]) ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `GST`, tab, `SGD`],150, line_vat_amount, d , newline ] ) ]

    ,[ check( Currency == `SGD` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `SGD`],150, line_vat_amount, d, newline ] ) ]

    ,[ check( Currency == `GBP` )   , generic_horizontal_details( [ [ `Total`, `Tax`, `@`, generic_item( [ default_vat_rate_dummy, d ] ), `%`, tab, `GBP`],150, line_vat_amount, d, or([ `CR` , newline ])  ] ) ]

   ] )

   ] ).