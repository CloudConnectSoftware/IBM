%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNILEVER AUSTRALIA LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_unilever_aus_trading , `26/09/2017`).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	get_supplier_details

    , get_bank_accountnumber

   	, get_invoice_number

    , get_invoice_date

    , get_order_no

	, get_due_date

    , get_totals

    , get_total_invoice

    , get_total_invoice

    , get_currency

    , get_invoice_lines

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `Unilever Australia Trading Ltd` )

    , supplier_vat_number(`65136885651`)

    , buyer_registration_number(`3009`)

    ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

   q0n(line)
	
   	, or([
           generic_vertical_details( [ [ `Number`, tab, `Date`], `Number`, q(0,1), (start,100,200), invoice_number, d, tab ] )

           ,generic_horizontal_details( [ [ `Invoice`, `:`, tab ], invoice_number, d, newline ] )

       ])  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

   qn0(line)

   	
   ,generic_horizontal_details( [ [ `Account`, `No`, `:` ], supplier_bank_account_number_raw, s1, newline ] )

   , check(supplier_bank_account_number_raw=Sacc), check(Sacc=`032802-002`), generic_item( [ supplier_bank_account_number, `032802002` ] )

 
 

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

   q0n(line)
	
    ,or([

       generic_vertical_details( [ [  `Number`, tab, `Date`], `Date`, q(0,1), (start,100,200), invoice_date, date, tab ] )

      ,generic_horizontal_details( [ [ `Invoice`, `Date`, `:`, tab ], invoice_date, date, tab ] )

       ])  

]).
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE PO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_no, [
%=======================================================================

   q0n(line)
	
    ,or([

       
      generic_horizontal_details( [ [`Cust`, `.`, `Order`, `.`, `No`, `.`, `:`, tab ], order_number, d, newline ] )

       ])  

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Invoice amounts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_totals, [
%=======================================================================

	qn0(line)
	
    , or([
        generic_horizontal_details( [ [ `Subtotal`, `$`, tab, generic_item( [ total_net, d] ), tab, `$`, tab, generic_item( [ total_vat,d ] ), tab, `$`, tab ], total_invoice, d, newline ] )
       
        , generic_horizontal_details( [ [ `Sub`, `-`, `Totals`, `:`, tab, generic_item( [ total_quantity, d] ), tab, generic_item( [ total_net,d ] ), q10(tab) ], total_vat, d, newline ] )
        
        , generic_horizontal_details( [ [ `Sub`, `-`, `Totals`, `:`, dummy_num(d), tab, generic_item( [ total_net, d ] ), tab ],  total_vat, d, newline ] )
        
        , generic_horizontal_details( [ [`Sub`, `-`, `Totals`, `:`, dummy_num1(d), tab, generic_item( [ total_net, d ] )],  total_vat, d, newline ] )


         ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Invoice Total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	qn0(line)
	
    
      ,  generic_horizontal_details( [ [ `Total`, `including`, `GST`, `:`, tab, `$`, `A`],  total_invoice, d, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	qn0(line)
	
    , or([
        
         generic_horizontal_details( [ [`Total`, `including`, `GST`, `:`, tab, `$`, `A`, tab ] ,  total_invoice, d, newline ] )
         ])
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

	qn0(line)
	
    , or([
        
        generic_horizontal_details( [ [ `Payment`, `Currency`, `:`, tab ],  currency, w, newline ] )

        , currency_line

    ])
  
] ).

%=======================================================================
i_line_rule_cut( currency_line, [
%=======================================================================
    q0n(anything)

    , [`$`, `A`]

    , generic_item( [ currency, `AUD` ] )



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [

            line_invoice_line4
           
           , line_invoice_line

           , line_invoice_line2

           , line_invoice_line3
           
           , line_invoice_foramt2

           


       

              
            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

   or([
       
       [`Delivered`, tab, `Product`, `Description`]

       , [`Line`, tab, `WFF`, `Code`, tab, `Cust`, `.`, `Code`, `Product`]

   ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

     [`Subtotal`, `$`, tab ]

     ,[`Sub`, `-`, `Totals`, `:`]
     
     ])

     , trace([`found the end line`])

 

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


    generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_product_code, s, tab ] )

    , generic_item( [ line_quantity_dummy, w, tab ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

     , generic_item( [ line_unit_amount_dummy, d, tab ] )

     , generic_item( [ line_allowance_dummy, w, tab ] )

      , generic_item( [ line_discount_dummy, w, tab ] )

       , generic_item( [ line_net_amount, d, tab ] )

        , generic_item( [ line_vat_amount, d, tab ] )

        ,   generic_item( [ line_total_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_foramt2, [
%=======================================================================

    generic_item( [ line_reference, d, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , generic_append( [ line_descr, s1, tab, ` Cust code -`, ` ` ] )

    , generic_append( [ line_descr, s1, tab, `Product - `, ` ` ] )

    , generic_item( [ line_quantity, d ] )

     , generic_item( [ line_unit_amount_dummy2, d, tab ] )

     , generic_item( [ line_discount, d, tab ] )

     , generic_item( [ line_other_dedu, d ] )

     , generic_item( [ line_vat_rate, d, [`%`,tab] ] )

       , generic_item( [ line_net_amount, d, tab ] )

        , generic_item( [ line_vat_amount, d, tab ] )

        ,   generic_item( [ line_total_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

      generic_item( [ line_number, d ] )

    , generic_item( [ line_item, s1, tab ] )

    , generic_item( [ line_customer_code, d ] )

    , or([

     generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_descr, s1,  [q10(tab),check(line_descr(end)< -172)] ] )


    ])
      
    , q10(generic_item( [ line_quantity, d,  [q10(tab),check(line_quantity(end)< -129)] ] ))

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [ line_discount, d, tab ] )

    , generic_item( [ line_other_dedu, d ] )

    , generic_item( [ line_vat_rate, d, [`%`,q10(tab) ] ] )

    , generic_item( [ line_net_amount, d, tab ] )

    , generic_item( [ line_vat_amount, d, q10(tab) ] )

    , generic_item( [ line_total_amount, d, newline ] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

      generic_item( [ line_number, d ] )

    , generic_item( [ line_item, s1, tab ] )

    , generic_item( [ line_customer_code, d ] )

    , or([
        generic_item( [ line_descr, s1,  [q10(tab),check(line_descr(end)< -172)] ] )

        ,generic_item( [ line_descr, s,  [q10(tab),check(line_descr(end)< -190) ] ] )
        
        ])

    , generic_item( [ line_quantity, d,  [q10(tab),check(line_quantity(end)< -144)] ] )

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [ line_discount, d, tab ] )

    , generic_item( [ line_other_dedu, d ] )

    , generic_item( [ line_vat_rate, d, [`%`,q10(tab) ] ] )

    , generic_item( [ line_net_amount, d, tab ] )

    , generic_item( [ line_vat_amount, d, q10(tab) ] )

    , generic_item( [ line_total_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================


      generic_item( [ line_reference, d , tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , q10(generic_item( [ line_quantity, d, q10(tab) ] ))

    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [ line_discount_dummy, d, tab ] )

    , generic_item( [ line_deduct_dummy, d, q10(tab) ] )

    , generic_item( [ line_vat_dummy, d, [`%`, tab ] ] )

    , generic_item( [ line_net_amount, d, tab ] )

    , generic_item( [ line_vat_amount, d, tab ] )

    ,   generic_item( [ line_total_amount, d, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - November 29, 2017
% Updated by   - Rohini
% Changes made - Invoice line format mapped


% Updated on   - December 12, 2017
% Updated by   - Rohini
% Changes made - Invoice Amount

% Updated on   - December 15, 2017
% Updated by   - Rohini
% Changes made - Invoice Amount

% Updated on   - June 4, 2018
% Updated by   - Rohini
% Changes made - Line details

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%