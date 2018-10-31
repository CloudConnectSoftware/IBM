%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - JALCO GROUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_jalco_cosmetics , `14:01 01 June 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_Invoice_tax

    ,get_bank_account_no

    , get_vat_code
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

	, get_total_invoice

    , get_currency

    , get_total_vat

    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TAX INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_Invoice_tax, [
%=======================================================================

    q(0, 50, line)
    
        , invoice_tax_line

] ).

%=======================================================================
i_line_rule( invoice_tax_line, [
%=======================================================================

q0n(anything)

	,`Tax`, `Invoice`

	, set(tax_invoice)

	, trace( [ `Found Tax Invoice TAX` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `Jalco  Cosmetics  Pty.  Limited` )

    , supplier_vat_number(`53  084  809  450`)

    , buyer_registration_number(`AU00`)

    ,currency(`AUD`)

   
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

q(0,50,line)

 , generic_horizontal_details( [ [  `Account`, `No`, `:` ],  supplier_bank_account_number, w, newline ] ) 

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q0n(line)
	
   ,  or([
       
	  generic_horizontal_details( [[`Number`, `:`],100, invoice_number, s1, newline ] )

   

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

    q(0,100,line)

    , generic_horizontal_details( [ [ `PO` , `:` ], 100, order_number, d, newline ] )

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
	
	, generic_horizontal_details( [ [ `Date`,`:`], 100,invoice_date, date, newline ] )
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	q0n(line)
	
	, generic_horizontal_details( [ [ `Total`, `:`, `(`, `AUD`, `)`, tab  ,generic_item( [ total_net, d ] ), q10(tab),  q10( generic_item( [ total_vat, d ] )), tab ],total_invoice, d, newline ] )
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

	line_start_line
	
	,qn0( [ peek_fails(line_end_line)
		
		,or( [
		
			line_invoice_line_rule
                      
			, line

			

			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	[`description`, tab, `material`, tab, `order`, `num`]

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
		  [`Total`, `:`, `(`, `AUD`, `)` ]

          ,[`Total`, `:`, tab, `Carried`, tab, `Forward`]

               ])

               , trace([`found the end line`])
    
] ).

%=======================================================================
i_rule( line_invoice_line_rule, [
%=======================================================================

or([
 
     % [line_invoice_line3, line_invoice_append]

     [line_invoice_line4, q10(line_item_append)]
    
    , line_invoice_line2

   

    % , line_invoice_line

   ])

]).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
     

       q10(generic_item([ line_material , w , tab ]))


       , generic_item([ line_descr , s , [ q10(tab), check( line_descr(end) < -209 ) ] ])

        , q10(generic_item([ line_customer_dummy , w , [ q10(tab), check( line_customer_dummy(end) < -142 ) ] ]))

	    , generic_item([ line_buyers_order_number , w, [ q10(tab), check( line_buyers_order_number(end) < -75 ) ] ]) 

         , generic_item([ line_sales_order_number , w, q10(tab)  ])

        , generic_item([ line_quantity_dummy1 , d ] )

         , generic_item([ line_quantity_uom_code , w , q10(tab) ] )

	    , generic_item([ line_unit_amount_dummy ,d, [`AUD`, `/`] ] )

         , generic_item( [ line_dummy, s1, tab ] )

        , generic_item([ line_net_amount , d  ] )

        , q10(generic_item([ line_vat_rate_dummy, d , [ `%` ,q10(tab) ] ] ))

        , q10(generic_item([ line_vat_amount , d , tab ] ))

	 , generic_item([ line_total_amount , d , newline ] ) 
     
    
] ).
    

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================
	
     

     generic_item([ line_item , w , tab ])

     , generic_item([ line_descr , s1 , tab ])

     , generic_item([ line_buyers_order_number , d ])

     , q10(generic_item([ line_customer_dummy , s1 , tab])) 

     , generic_item([ line_quantity_dummy , d ] )

     , generic_item([ line_quantity_uom_code , w , q10(tab) ] )

	 , generic_item([ line_unit_amount_dummy ,d, [`AUD`, `/`, line_num(w), q10(tab)] ] )

        , generic_item([ line_net_amount , d , q10(tab) ] )

        , q10(generic_item([ line_vat_rate_dummy, d , [ `%` ,q10(tab) ] ] ))

        , generic_item([ line_vat_amount , d , tab ] )

	 , generic_item([ line_total_amount , d , newline ] ) 
     
    
] ).



%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================
	
     

      q10(generic_item([ line_item , w , tab ]))


     , generic_item([ line_descr , s1 , tab ])

     , generic_item([ line_buyers_order_number , d ])

     , q10(generic_item([ line_customer_dummy , s1 , tab])) 

     , generic_item([ line_quantity , d ] )

     , generic_item([ line_quantity_uom_code , w , q10(tab) ] )

	 , generic_item([ line_unit_amount ,d ] )

     , q10(generic_item( [ line_UOM_dummy, s1, tab ] ))

     , generic_item([ line_net_amount , d , q10(tab) ] )

     , q10(generic_item([ line_vat_rate_dummy, d , [ `%` ,q10(tab) ] ] ))

     , generic_item([ line_vat_amount , d ] )

	 , generic_item([ line_total_amount , d , newline ] ) 
     
    
] ).

%=======================================================================
i_line_rule( line_invoice_descr, [
%=======================================================================
	
     generic_append( [ line_descr, s1, newline, ` `, ``  ] )


     
    
] ).



%=======================================================================
i_line_rule( line_invoice_append, [
%=======================================================================
	
     generic_append( [ line_descr, w, tab, ` `, ``  ] )

   , generic_item( [ line_dummy, s1, newline ] )
     
    
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================
	
     

      generic_item([ line_item , s1 , tab ])

     , generic_item([ line_descr , s1 , tab ])

     , q10(generic_item([ line_customer_dummy2 , s1 , tab])) 

     , generic_item([ line_quantity_dummy , d ] )

     , generic_item([ line_quantity_uom_code , w , q10(tab) ] )

	 , generic_item([ line_unit_amount_dummy ,s1, tab ] )

     , generic_item([ line_net_amount , d , q10(tab) ] )

     ,generic_item([ line_vat_rate_dummy, s1 ,  tab ] )

	 , generic_item([ line_total_amount , d , newline ] ) 
     
    
] ).

%=======================================================================
i_line_rule( line_item_append, [
%=======================================================================
	
     generic_append( [ line_item, w, tab, ` `, ``  ] )

   , q10(generic_item( [ line_dummy, s1, tab ] ))

   , generic_item([ line_dummy1 , s1 , newline ] ) 
     
    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Updated on   - May 23, 2018
% Updated by   - Rohini
% Changes made - Line format 

% Updated on   - Oct 31, 2018
% Updated by   - Rohini
% Changes made - Line level data

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%