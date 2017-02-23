%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM ARES MAPPING TEMPLATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ares_fedex , `16/02/2017 10:42:30` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	  get_supplier_detail
	          		
	, get_invoice_number
	
	, get_invoice_date
	
	, get_due_date

	, get_order_number

	, get_invoice_date

    , get_total_net

%	, get_total_vat

    , get_total_invoice

	, get_currency

    , get_invoice_lines
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER PARTY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

	sender_name(`FEDEX PASADENA`)

	,supplier_vat_number(`71-0427007`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

	q(0,20,line)
	
	, generic_vertical_details( [ [ `Invoice`, `Number`], `Invoice`, q(0,2), (end,10,10), invoice_number, w, tab ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

	q(0,20,line)
	
    , generic_vertical_details( [ [ `Invoice`, `Date`], `Invoice`, q(0,2), (end,10,10), invoice_date, date, newline ] )

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
	
	, generic_horizontal_details( [ [ `Your`, `payment`, `is`, `due`, `by` ] , 100 , due_date , date , newline ] ) 

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

	q(0,20,line)
	
    , generic_vertical_details( [ [ `Account`, `Number`], `Account`, q(0,1), (end,10,10), order_number, w, tab ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET NET TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

	q(0,100,line)
	
	, generic_horizontal_details( [ [ `TOTAL`, `THIS`, `INVOICE` , tab , generic_item( [ currency, w , tab ] )], total_net, d, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

	q(0,100,line)
	
    , generic_horizontal_details( [ [ `Total`, `VAT`, `Amount` ], total_vat, d, newline ] )

    ,generic_vertical_details( [ [ `Total`, `VAT`, `Amount`], `AMOUNT`, q(0,3), (end,10,10), total_vat, d, newline ] )
	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE TOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	q(0,100,line)
	
	, generic_horizontal_details( [ [ `TOTAL`, `THIS`, `INVOICE` , tab , generic_item( [ currency, w , tab ] )], total_invoice , d, newline ] )
    
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

	q(0,40,line)
	
	, generic_horizontal_details( [ [ `TOTAL`,  `THIS`  , `INVOICE` ], 100 , currency, w , newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [

              line_invoice_line_rule 

			  , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

	`FedEx`, `Express`, `Shipment`, `Detail`, `By`, `Payor`

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    `Total`, `FedEx`, `Ground`, tab, `USD`

     , trace([`found the end line`])

] ).

%=======================================================================
i_rule_cut( line_invoice_line_rule, [
%=======================================================================

	line_invoice_line

	, q(0,10,line)
	
	, line_tracking_line

	, q(0,15,line)

	, line_charges_line

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

		 [`Ship` , `Date` , `:`]
		
		, generic_item_cut( [ line_delivery_date , date , tab ] )

		, generic_item( [ line_refer_dummy , s, `:` ] )

		, generic_item_cut( [ line_reference, s1 , tab ] )

] ).


%=======================================================================
i_line_rule_cut( line_tracking_line, [
%=======================================================================
        
		 `Tracking` , `ID` , tab
        
        , generic_item_cut( [ line_item , d , tab ] )

		, generic_item_cut( [ line_descr , s1 , tab ])

		  ,  with( invoice, line_descr, Descr ) 

			, trace([`found the line descr line`])
		  

   	 ,or([
			
			[check( Descr =  `Ann Margaret Tudisco`  ) , generic_item( [ line_buyers_order_number, `90067A` ] ) ]

			,[check( Descr = `Laura Williams` ) , generic_item( [ line_buyers_order_number, `90067B` ] )]

			,[check( Descr = `Ashley Caines` ) , generic_item( [ line_buyers_order_number, `90067C` ] )]

			,[check( Descr = `Gerald Bongcaron` ) , generic_item( [ line_buyers_order_number, `90067D` ] )]

			,[check( Descr = `Angela Williams` ) , generic_item( [ line_buyers_order_number, `90067E` ] )]

			,[check( Descr = `Lauren Chun` ) , generic_item( [ line_buyers_order_number, `90067F` ] )]

			,[check( Descr = `SEAN SPRING` ) , generic_item( [ line_buyers_order_number, `90067G` ] )]

			,[check( Descr = `Nathalie Tolentino` ) , generic_item( [ line_buyers_order_number, `90067H` ] )]

			,[check( Descr = `Annie McIvor` ) , generic_item( [ line_buyers_order_number, `90067I ` ] )]

			,[check( Descr = `AARON SINGH` ) , generic_item( [ line_buyers_order_number, `90067J ` ] )]

			,[check( Descr = `Ann Kono` ) , generic_item( [ line_buyers_order_number , `90067K ` ] )]

			,[check( Descr = `Jorge Hernandez` ) , generic_item( [ line_buyers_order_number, `90067L ` ] )]

			,[check( Descr = `Gerald Bongcaron` ) , generic_item( [ line_buyers_order_number, `90067M ` ] )]

			,[check( Descr = `Jenny Anthony` ) , generic_item( [ line_buyers_order_number, `90067N ` ] )]

			,[check( Descr = `Matthew Keppley` ) , generic_item( [ line_buyers_order_number, `90067N ` ] )]

			,[check( Descr = `Stephanie Brock` ) , generic_item( [ line_buyers_order_number, `90067O ` ] )]

			,[check( Descr = `Annie McIvor` ) , generic_item( [ line_buyers_order_number, `90067P` ] )]

			,[check( Descr = `Stephanie Brock` ) , generic_item( [ line_buyers_order_number, `90067Q` ] )]

			,[check( Descr = `Edward Sur` ) , generic_item( [ line_buyers_order_number, `990067R` ] )]

			,[check( Descr = `Jorge Hernandez` ) , generic_item( [ line_buyers_order_number, `90067S ` ] )]

			,[check( Descr = `Kim Stites` ) , generic_item( [ line_buyers_order_number, `90067T ` ] )]

			,[check( Descr = `Frank Tanelli` ) , generic_item( [ line_buyers_order_number, `90067U ` ] )]

			,[check( Descr = `Sender` ) , generic_item( [ line_buyers_order_number, `90067V ` ] )]

					
		]) 

		, trace([`found the cost centre line`]) 
		  

] ).


%=======================================================================
i_line_rule_cut( line_charges_line, [
%=======================================================================

		q(0,5, [ dummy(s1) , tab ] )
        
        , `Total`, `Charge`, tab, `USD`, tab
		
		, generic_item_cut( [ line_net_amount, d , newline ] )
		
] ).



