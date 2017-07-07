%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - BT SINGAPORE PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_bt_singapore_ltd , `29/05/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


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

    , get_total_line_net

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
  
[ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `SGD`, `A`, `/`, `C`, `No`, `:`, tab ],  supplier_bank_account_number, w, newline ] ) ]


, [ check( Currency = `USD` ), generic_horizontal_details( [ [`USD`, `A`, `/`, `C`, `No`, `:`, tab],  supplier_bank_account_number, w, newline ] ) ] 
                
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

    , generic_item( [ order_number , [ begin, q(alpha("D"),1,1) , q(alpha("O"),1,1) , q(dec,5,15) , end ] ] )

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

    , qn0(line)

, or( [

  [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Recurring`, `Charges`, tab, `USD` ], 150,total_net, d, or([ `CR` , newline ])  ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Charges`, tab, `SGD`],150, total_net, d, or([ `CR` , newline ]) ] ) ]

,[ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, total_net, d, or([ `CR` , newline ]) ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,total_net, d, or([ `CR` , newline ]) ] ) ]

 , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Usage`, `Charges`, tab, `USD` ],150, total_net, d, newline ] ) ]

 , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,total_net, d, `cr` ] ) ]

 
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

    , qn0(line)

    , or( [

     [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `USD`], 150, line_total_amount, d, newline ] ) ]

    , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `of`, `this`, `bill`, tab, `SGD` ],150,  line_total_amount, d, newline ] ) ]

     , [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `SGD` ],150, line_total_amount, d, or([ `CR` , newline ]) ] ) ]

      , [ check( Currency == `USD` ) , generic_horizontal_details( [ [`Total`, `of`, `this`, `bill`, tab, `USD`],150, line_total_amount, d, or([ `CR` , newline ]) ] ) ]

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

    , qn0(line)

, or( [

  [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Recurring`, `Charges`, tab, `USD` ], 150,line_net_amount, d, or([ `CR` , newline ])  ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `Charges`, tab, `SGD`],150, line_net_amount, d, or([ `CR` , newline ]) ] ) ]

,[ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `USD`],150, line_net_amount, d, newline ] ) ]

, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [ `Total`, `One`, `Off`, `Charges`, tab, `SGD`], 150,line_net_amount, d, newline ] ) ]

 , [ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Usage`, `Charges`, tab, `USD` ],150, line_net_amount, d, newline ] ) ]


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


   ] )

   ] ).