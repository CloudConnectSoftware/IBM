%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - CHABAA BANGKOK CO., LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_chabba_bangkok , `12:03 01 June 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( x_tolerance_100, 100 ).

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	 get_supplier_details

    , set_credit_note
   
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

	, get_total_invoice

    , get_currency

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

    sender_name( `CHABAA BANGKOK CO LTD` )

    , supplier_vat_number(`0993000081137`)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,10,line)

    , debit_note_line
    
] ).

%=======================================================================
i_line_rule( debit_note_line, [
%=======================================================================

q0n(anything)


    ,`CREDIT`, `NOTE`, `/`, `TAX`, `INVOICE`

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

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
	
   ,  or([
             generic_horizontal_details( [[`No`, `.`], invoice_number, s1, newline ] )

            ,generic_horizontal_details( [[`INVOICE` , `NO`, `.` ], invoice_number, s1, tab ] )
	 
         , generic_horizontal_details( [[`No`, `.`, `:`, tab ], invoice_number, s1, tab ] )

         , generic_vertical_details( [ [ `Invoice`, `No`, `.`], `Invoice`, q(0,1), (start,10,10), invoice_number,  s1 , tab ] )

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

    , generic_horizontal_details( [ [ `REF`, `.`, `P`, `/`, `O`, `NO`, `.` ], 100, line_buyers_order_number_raw, w, q10(`,`) ] )


    , check( line_buyers_order_number_raw = OrderRaw )

    , trace( [ `Order No raw` , OrderRaw ] )

    , check(string_string_replace( OrderRaw, `,`, ``, OrdStrip ))

    , trace( [ `Order No Stripped Comma` , OrdStrip ] )

    , order_number(OrdStrip)

    , trace( [ `Order No` , order_number ] )

    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE Header ORDER Number` , line_buyers_order_number ])


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================
  
   q(0,15,line)
	
	 , or([ generic_horizontal_details( [ [ `DATE`, `:` ,q10(tab)],invoice_date, date,  or([ tab , newline ]) ] )

     , generic_horizontal_details( [ [ `Date`, `:`, tab ],invoice_date, s1, tab ] )

    , generic_vertical_details( [ [ `Date`, tab ], `date`, q(0,1), (start,20,20), invoice_date,  date , tab ] )

    , generic_vertical_details( [ [ `Debit`, `Note` ], `note`, q(0,2), (start,0,150), invoice_date,  date , newline ] )

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
        
        generic_horizontal_details( [ [ `Grand`,`total`, tab ], total_invoice, d, newline ] )

        , generic_vertical_details( [ [ `AMOUNT`, newline ], `AMOUNT`, q(7,20), (end,20,20), total_invoice, d , newline ] )

        , generic_vertical_details( [ [ `Account`, `&`, `Finance`, `Dept`, `.`, `Manager`,  newline ], `Manager`, q(1,2, up), (end,0,150), total_invoice, d , newline ] )

        , generic_vertical_details( [ [ `COUNTRY`, `OF`, `ORIGIN`, `:`, `THAILAND`,  newline ], `THAILAND`, q(0,1, up), (end,0,650), total_invoice, d , newline ] )

        , generic_vertical_details( [ [ `received`, `by`,  newline ], `by`, q(0,1, up), (end,0,100), total_invoice, d , newline ] )
    ])
        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q0n(line)

    , generic_vertical_details( [ [ `AMOUNT`, newline ], `AMOUNT`, q(0,1), (end,10,10), currency_raw,  w , `.` ] )


    , check( currency_raw = CurRaw )

    , trace( [ `Currencyraw` , CurRaw ] )

    , check(string_string_replace( CurRaw, `(`, ``, CurStrip ))

    , trace( [ `Currency Stripped (` , CurStrip ] )

    , currency(CurStrip)

    , trace( [ `Currency now` , currency ] )

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

   , or([

    
    generic_horizontal_details( [ [ `GST`  ], 150 , total_vat, d, newline ] )
    
    , gst_line
 
 ])

] ).

%=======================================================================
i_line_rule( gst_line, [
%=======================================================================

   
total_vat(`0`)

, trace( [ `FOUND VAT ZERO`] )

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
		
            
			line_invoice_line

            ,line_invoice_line2

            ,line_debitnote_line
        
            , [line_invoice_new_line, line_append_line, line_append_line2 ]

                        
			, line

		
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
    or([

        [`for`, `Malaysia`,  newline ]

        ,[`DESCRIPTION`, tab, `AMOUNT`, `USD`,  newline ]
	
     , [`DESCRIPTION`, `OF`, `GOODS`, tab, `QUANTITY`, tab, `BOTTLES`, tab, `AMOUNT`,  newline]

     , [`Item`, `Code`, `/`, `Description`, tab, `Quantity`, tab, `xUM`]

    ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([

           [`(`, `THB`, dummy_num(d), `/`, `Exchange`, `rate`, dummy_num2(d), `)`,  newline ]

         , [`Sub`, `Total`]

         , [`(`, `U`, `.`, `S`, `.`, `DOLLARS`]
          
		 , [ `TOTAL`, `FOB`, `BANGKOK` ]

         , [`TOTAL`, `FOB`, `LAEM`, `CHABANG`]

         , [`Issued`, `by`, tab, `Checked`, `by`, tab, `Approved`, `by`, tab, `Received`, `by`]

	 	 ])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
     

      generic_item([ line_item_dummy , w , tab ])


	 , generic_item([ line_descr , s1 , tab ]) 

         
	 , generic_item([ line_net_amount , d , newline ] ) 
     
    
    

] ).

%=======================================================================
i_line_rule( line_invoice_line2, [
%=======================================================================


     generic_item([ line_item , d , tab  ])

	 , generic_item([ line_descr , s1 , tab ]) 
 
     , generic_item([ line_quantity , d , tab  ] )

     , generic_item([ line_quantity_dummy , d , tab ] )
	 
	 , q10(generic_item([ line_quantity_uom_code_dummy , w , tab ] ))

     , generic_item([ line_unit_amount_dummy , d , tab] )

	 , generic_item([ line_net_amount , d , newline ] ) 
     
]).

%=======================================================================
i_line_rule( line_debitnote_line, [
%=======================================================================


     generic_item([ line_number , w , [tab, `x`, tab] ])

	 , generic_item([ line_descr , s1 , tab ]) 
 
     , generic_item([ line_quantity , d , [ `.` , tab ] ] )
	 
	 , q10(generic_item([ line_quantity_uom_code_dummy , w , tab ] ))

     , generic_item([ line_unit_amount_dummy , d , tab] )

	 , generic_item([ line_net_amount , d , newline ] ) 
     
]).


%=======================================================================
i_line_rule( line_invoice_new_line, [
%=======================================================================


     generic_item([ line_number , w , [tab, `x`, tab] ])

	 , generic_item([ line_descr , s1 , tab ]) 
 
     , generic_item([ line_quantity , d , [ `.` , tab ] ] )
	 
	 , q10(generic_item([ line_quantity_uom_code_dummy , w , tab ] ))

     , generic_item([ line_unit_amount_dummy , d , tab] )

	 , generic_item([ line_net_amount , d , newline ] ) 
     
]).


%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================


     generic_append([ line_descr , s1 , newline , `_` , ` `  ])
     
]).

%=======================================================================
i_line_rule( line_append_line2, [
%=======================================================================


     generic_append([ line_descr , s1 , newline , `_`, ` `  ])
     
]).

%=======================================================================
i_line_rule( line_debitnote_line, [
%=======================================================================


     generic_item([ line_descr , s1 , tab ]) 

     , generic_item([ line_net_amount , d , newline ] ) 
     
     
]).

