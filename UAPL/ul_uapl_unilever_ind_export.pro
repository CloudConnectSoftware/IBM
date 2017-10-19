%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - Unilever India Exports Ltd,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_Unilever_ind_export , `20/10/2016` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	get_supplier_details
   
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
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `Unilever India Export` )

    , supplier_vat_number(`24AAACI0991D1ZY`)

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
	
    , or( [

        generic_horizontal_details( [ [ `Inv`, `No`, `.`, tab ], invoice_number, w, tab ] )

	, generic_vertical_details( [ [ `Invoice`, `No`], `Invoice`, q(0,1),(end,20,20), invoice_number, d ] )

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


q0n(line)
	
   , or( [

       generic_vertical_details( [ [`Buyer`, `'`, `s`, `Order`, `No`], `buyer`, q(0,1),(end,10,10), order_number, d,[`,`, check(order_number(end) < 56)] ] )

	  , generic_vertical_details( [ [`Buyer`, `'`, `s`, `Order`, `No`], `buyer`, q(0,1),(end,10,10), order_number, d,  newline  ] )

    , generic_horizontal_details( [ [`Customer`, tab ], order_number, w, [`,`, dummy_num(w), tab ] ] )

   ])

    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE LINE ORDER NUMBER` , line_buyers_order_number ])

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

     , or( [
	
   	    generic_horizontal_details( [ [ `Dt`, `.` ],  invoice_date, date, tab ] )

       
      , generic_horizontal_details( [ [ `Invoice`, `Date`, `:`, tab ], invoice_date, date, newline ] )

       ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	qn0(line)
	
    , or([
        generic_vertical_details( [ [ `For`, `Unilever`, `India`, `Exports`, `Ltd` ], `Ltd`, q(0,10,up), (end,10,100), total_invoice,  d , newline ] )

        ,generic_vertical_details( [ [ `Authorised`, `Signatory` ], `signatory`, q(0,15,up), (end,250,250), total_invoice,  d , newline ] )

        , generic_horizontal_details( [ [ `Total`, `Amount`, `:`, tab ], total_invoice, d, [ `USD`,  newline ] ] )

    ])

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] )   

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================
 
  currency( `USD` )

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
	
	, qn0( [ peek_fails(line_end_line)
		
		, or( [
		
			[line_invoice_line , q10(description_line)     , q10(description_line_append) ]

            , line_invoice_line1
         
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	 or([ 

         [`Item`, tab, `Description`, tab, `Quantity`]

        , [`Exporter`, `'`, `s`, `ref`]

])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

     or([ 

        [`Commercial`, `Invoice`, tab, `Page`, `2`, `of`, `2`]
         
         , [`Amount`, `Chargeable`, `(`, `in`, `words`, `)`]

         , [`Amount`, `in`, tab, `USD`]

        

     ])

      , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
     
q10(generic_item([ line_description_dummy , w , tab ]))
     
     , generic_item([ line_quantity , d , tab ])

	 , generic_item([ line_description_dummy1 , s1 , tab ]) 
 
     , or([
          generic_item([ line_quantity_dummy , d, tab ] )

         , generic_item([ line_quantity_dummy , d ] )
     ])



     , q10(generic_item([ line_quantity_uom_cod , w , tab ] ))

	 , generic_item([ line_unit_amount_dumy , d , [`/`, tab ] ] )

     , q10( [ with( 1, line_net_amount, _ ) % This q10 will only run if the first line_total_amount has been captured
	
	 , with( 1, line_buyers_order_number, Order ) % This takes the first value of PO Number (captured in rule 'get_order_number')

	 , generic_item( [ line_buyers_order_number, Order] ) % This stores the value in Line_buer Number for the current line

])

	 , generic_item([ line_net_amount , d , newline ] ) 
     

] ).

%========================================================
i_line_rule( description_line, [
%=======================================================================

q10(generic_item( [ dummy2, w, [ tab , check(dummy2(end) < -330 ) ]] ) )

    , generic_item( [ line_descr_dummy2 , s1 , tab ])

    , or([ generic_item( [ line_descr , s1 , tab ])

    , generic_item( [ line_descr , w , newline ])

    ])

    , q10( generic_item( [ line_UOM_dummy1 , w , tab ]))

    , q10( generic_item( [ line_UOM_dummy2 , s1 , newline ]))

] ).


%========================================================
i_line_rule( description_line_append, [
%=======================================================================

generic_append( [ line_descr, s1, newline, ` `, ` ` ] )
 

] ).


%========================================================
i_line_rule( line_invoice_line1, [
%=======================================================================

   generic_item( [ line_number , w , tab ])

   ,generic_item( [ line_descr , s1 , tab ])

   ,generic_item( [ line_quantity , d  ])

   ,generic_item( [ line_quantity_uom_code , w , tab ])

   ,generic_item( [ line_unit_amount , d , tab ])

    ,generic_item( [ line_currency , w , tab ])

    ,generic_item( [ line_net_amount , d , tab ])

   ,generic_item( [ line_vat , d , tab ])

      ,generic_item( [ line_vat_amount , d , tab ])

       ,generic_item( [ line_total_amount , d , newline ])



] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - 13 Oct 2017
% Updated by   - Rohini
% Changes made - New format Invoice received, mapped for new format

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
