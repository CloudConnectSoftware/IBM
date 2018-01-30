%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - THE NIELSEN COMPANY (SINGAPORE) PTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_nielsen_singapore, `08/05/2016` `4:55:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   get_supplier_details

   ,get_bank_account_no

    , get_Invoice_tax

    , set_credit_note

    , get_invoice_number

    , get_order_number

    , get_invoice_date

    , get_due_date

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_line_total_amount
  
    , get_invoice_lines

    , get_line_net

    , get_line_vat

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
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,20,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)


    , [`Credit`, `Note`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET    ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================


 

      with( invoice, currency, Currency )

      ,q(0,250,line)

     , or( [
  
   [check( Currency = `USD` ) , set(regexp_allow_partial_matching),  generic_horizontal_details( [ [  `Account`, `No`, `.`, `:`,`260` ],  supplier_bank_account_number_raw, w, [`(`, `SGD`, `A`, `/`, `C`, `)`,  newline ] ] ), clear(regexp_allow_partial_matching) ]
  ,[ check( Currency = `SGD` ) , set(regexp_allow_partial_matching),  generic_horizontal_details( [ [ `SGD`, `A`, `/`, `C`, `No`, `:`, `143` ],  supplier_bank_account_number_raw, w, [`(`, `USD`, `A`, `/`, `C`, `)`,  newline ] ] ) , clear(regexp_allow_partial_matching) ]
  ,[ check( Currency = `USD` ) , set(regexp_allow_partial_matching),  generic_horizontal_details( [ [ `Bank`, `A`, `/`, `C`, `No`, `:`, `260` ],  supplier_bank_account_number_raw, w, [`(`, `USD`, `A`, `/`, `C`, `)`,  newline ] ] ) , clear(regexp_allow_partial_matching) ]
  ,[ check( Currency = `EUR` ) , set(regexp_allow_partial_matching), generic_horizontal_details( [ [  `Account`, `No`, `.`, `:` ],  supplier_bank_account_number_raw, w, [`(`, `EUR`, `A`, `/`, `C`, `)`,  newline ] ] ) , clear(regexp_allow_partial_matching) ]

     ])
  ,check(supplier_bank_account_number_raw=SupplierAccount)
  , check(strip_string2_from_string1( SupplierAccount, `-`, SupplierAccount1 ))
  ,supplier_bank_account_number(SupplierAccount1), trace( [ `New Bank`, supplier_bank_account_number ] )

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
 
     sender_name(`THE NIELSEN COMPANY (SINGAPORE) PTE`)

      , supplier_vat_number(`201217068G`)

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

    ,or([

       generic_horizontal_details( [ [ `Credit`, `Note`, tab ], invoice_number, d, newline ] )

     , generic_horizontal_details( [ [ `Invoice`, tab ], invoice_number, d, newline ] )

    ])

	
	] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,75,line)

  
      ,generic_horizontal_details( [ [  `PO`, `No`, `.`, `:` ], order_number,s1, newline ] )

   

       , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE LINE ORDER Number` , order_number ])


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

    , generic_horizontal_details( [ [ `Date`, tab ],  invoice_date, date , newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_due_date, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `Due`, `Date`,  tab ], due_date, date , newline ] )


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

    ,trace( [ `Currency`, Currency ] )

    , or( [
  
    [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Sub`, `Total`, `in`, `USD` ], 250, total_net, d, newline ] ) ]


   , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Sub`, `Total`, `in`, `SGD` ], 250, total_net, d, newline ] ) ]


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
  
  


     with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    ,trace( [ `Currency`, Currency ] )

    ,qn0(line)

    , or( [
  
[ check( Currency = `USD` ) , generic_horizontal_details( [ [ `GST`, `@`, generic_item( [ vat_percent_dummy , d , `%` ] ), `in`, `USD`  ], 250, total_vat, d, newline ] ) ]


, [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `GST`, `@`, generic_item( [ vat_percent_dummy , d , `%` ] ), `in`, `SGD`  ], 250, total_vat, d, newline ] ) ]
                
 ] )

, currency( Currency )
 

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

    ,trace( [ `Currency`, Currency ] )

    ,qn0(line)

    , or( [
  
[ check( Currency == `USD` ) , generic_horizontal_details( [ [ `Total`, `Amount`, `in`, `USD`  ], 250 , total_invoice, d, newline ] ) ]


, [ check( Currency == `SGD` ) , generic_horizontal_details( [ [`Total`, `Amount`, `in`, `SGD`, tab ], total_invoice, d, newline ] ) ]


                
 ] )

, currency( Currency )
 

] ). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_line_total_amount
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_total_amount, [
%=======================================================================
       q0n(line)


     , with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , or( [
  
[ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Total`, `Amount`, `in`, `USD`  ], 250 , line_total_amount, d, newline ] ) ]


, [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Total`, `Amount`, `in`, `SGD`, tab ], line_total_amount, d, newline ] ) ]
                
 ] )

, currency( Currency )
 

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
    
    , line_descr( `Goods Services` )

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL LINE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_net, [  
%=======================================================================

	  with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , qn0(line)

    , or( [
  
    [ check( Currency = `USD` ) , generic_horizontal_details( [ [ `Sub`, `Total`, `in`, `USD` ], 250, line_net_amount, d, newline ] ) ]


   , [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Sub`, `Total`, `in`, `SGD` ], 250, line_net_amount, d, newline ] ) ]


 ] )


] ). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL LINE VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_vat, [  
%=======================================================================

 q0n(line)


     , with( invoice, order_number, Order_Number )

    , check( i_user_check( check_po_currency, Order_Number, Currency ) )

    , or( [
  
[ check( Currency = `USD` ) , generic_horizontal_details( [ [ `GST`, `@`, generic_item( [ vat_percent_dummy , d , `%` ] ), `in`, `USD`  ], 250, line_vat_amount, d, newline ] ) ]


, [ check( Currency = `SGD` ) , generic_horizontal_details( [ [ `GST`, `@`, generic_item( [ vat_percent_dummy , d , `%` ] ), `in`, `SGD`  ], 250, line_vat_amount, d, newline ] ) ]
                
 ] )
 

] ). 


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Updated on   - December 12, 2017
% Updated by   - Rohini
% Changes made - Invoice total updated

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%