%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - ALTRATEC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( altratec, `28 June 2017 ` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	 get_supplier_details

     ,get_buyer_reg_no

    , get_bankdetails
	
	, get_invoice_number

	, get_invoice_date

    , get_order_number

    , get_total_net

	, get_total_vat

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

      sender_name(`ALTRATEC SDN BHD`)

    , supplier_vat_number(`001668337664`)

    
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bankdetails, [
%=======================================================================

	q(0,50,line)



     , generic_horizontal_details( [ [`Bank`, `Account`, `Number`, tab, `:` ],100, supplier_bank_account_number_raw, w, newline ] )

    ,check(supplier_bank_account_number_raw=AccRaw)

    ,check(strip_string2_from_string1( AccRaw, `-`, AccNew ))

    ,supplier_bank_account_number(AccNew), trace( [ `Supplier account number without special characters`, supplier_bank_account_number ] )


    
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BUYER REG DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_reg_no, [
%=======================================================================

q(0,100,line)

    , bill_to_line1

    ,q(0,1,line)

    , bill_to_line2

    

]).


%=======================================================================
i_line_rule( bill_to_line1, [
%=======================================================================

    q0n(anything)

   ,or([

       [`BUSINESS`, `CITY`]
       ,[`-`, `35`, `MENARA`, `TM`, `,`, `JLN`, `PANTAI`, `BARU` ]

   ])

] ).

%=======================================================================
i_line_rule( bill_to_line2, [
%=======================================================================

    q0n(anything)

    , or([
    
    [[q10(`,`), `117439`]  ,buyer_registration_number(`3009`)]

    ,[[q10(`,`), `59200`],buyer_registration_number(`MY00`) ]

    ])
   
    ,trace( [ `Company code set to`, buyer_registration_number ] )
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

    , or( [
        
        generic_horizontal_details( [ [ `Invoice` , `No` , `.` , `:` ] , 100 , invoice_number , s1, newline ] )

        , find_Invoice_number
	    
        , generic_horizontal_details( [ [  `No`,`:`, tab ] , invoice_number , s1, newline ] )

        , generic_horizontal_details( [ [ `Invoice` , `No` ,tab,  `:` ] , 100 , invoice_number , s1, newline ] )
	
    ])
] ).


%=======================================================================
i_line_rule( find_Invoice_number, [
%=======================================================================

    q0n(anything)

     , generic_item( [ invoice_number , [ begin, q(alpha("D"),1,1) , q(alpha("N"),1,1) , q(any,5,7) , end ] ] )

     , set(debit_note)

     ,  trace( [ `Debit Note found` ] )
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

    q0n(line)

    , or([

         generic_horizontal_details( [ [ `Invoice` , `Date` ,  q10(tab) , `:` ],100, invoice_date, date, newline ] )

        
       , [  
           
           generic_horizontal_details( [ [ `Invoice` , `Date` ,  q10(tab) , `:` ],100, invoice_date_raw, s1, newline ] )

        , check( invoice_date_raw = DateRaw )

        , trace( [ `Invoice date raw` , DateRaw ] )

        , check(string_string_replace( DateRaw, `.`, ``, DateStrip ))

        , trace( [ `Date Stripped Dot` , DateStrip ] )

        , invoice_date(DateStrip)

        , trace( [ `Invoice Date` , invoice_date ] )  
    
    ]

	
    , generic_horizontal_details([ [  `Date` , `:`  ], invoice_date, date, newline ] )
   

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

    , or([generic_horizontal_details( [ [`PO`, `:` ], 50, order_number, w, [`-`, `MY`] ] )

    ,generic_horizontal_details( [ [`PO`, `:` ], 50, order_number, w, newline ] ) ])

   
] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

    q0n(line)
   
    
    , or([ 
        
        generic_horizontal_details( [ [  `Add` , `GST` , `@` , generic_item( [ default_vat_rate, d ] ) , `%` ], 150 , total_vat , d, newline ] )

    , generic_horizontal_details( [ [  `GST` , generic_item( [ default_vat_rate, d ] ) , `%` , tab ],  total_vat , d, newline ] )

     
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

              [test(debit_note), generic_horizontal_details( [ [ `Total`, `:`, tab ] , total_invoice, d, newline ] )]
          

        
             , generic_vertical_details( [ [ `E`, `&`, `O`, `.`, `E`, tab, `for`, `ALTRATEC`, `SDN`, `.`, `BHD`], `BHD`, q(0,3,up),(end,25,25), total_invoice, d, newline ] )
     
             
             ,  generic_horizontal_details( [ [ `Total`, `:`, tab ] , total_invoice, d, newline ] )


             , [ generic_horizontal_details( [ [ `Total`, `Financial`, `uplift`, `(`, `RM`, `)`, tab ] , total_invoice, d, newline ] )
             ,  check(total_invoice = TotInv), trace([`Total Capital Varaible` , TotInv])
             , line_total_amount(TotInv) , trace( [ `THIS IS NOW THE LINE TOTAL` , TotInv ]) ]

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

     q0n(line)

    , or([
        
        generic_horizontal_details( [ [ `sub`, `Total` ], 150 , total_net, d, newline ] )

          , generic_horizontal_details( [ [ `Total`, `Financial`, `uplift`, `(`, `RM`, `)`, tab ] , total_net, d, newline ] )


    ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     currency( `MYR` )

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

           [ line_invoice_line, q10(line_descr_line) , q10(line_po_line) , q10(line_descr_line)  , q10(line_po_line) ]

           ,[ line_invoice_line2 , q10(line_descr_line) , q10(line_po_line) , q10(line_descr_line)  , q10(line_po_line) ]

           ,line_debit_line

            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([
    [`PARTICULARS`, tab, `AMOUNT`,  newline]
    
    ,[`Product` , `Code` , tab]

])
    , trace( [ `FOUND LINE HEADER LINE`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or([ 

        [`GST`, `6`, `%`, tab ]

        , [`TOTal`]

        ,[`Sub` , `Total`]

        ,[`Place`, `Of`, `Delivery`]

    ])

    ,trace( [ `FOUND LINE END LINE`] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_invoice_line_dummy , d , tab] )

    , or([generic_item( [ line_item, s, [q10(tab),check(line_item(end) < -250 )]])

    , generic_item( [ line_item, s1, tab ]) ])

    , q10(generic_item( [ line_descr , s1 , tab ] ))

     ,q10(  
         
     [ set(regexp_allow_partial_matching)

    , generic_item( [ line_quantity_dummy , d ])
    
    , generic_item( [ line_quantity_uom_code , w , tab ] )

    , clear(regexp_allow_partial_matching) ]
    
    )

    , generic_item( [ line_unit_amount , d , tab ] )

    , generic_item( [ line_net_amount, d , newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================
   
    generic_append( [ line_descr, s1 , newline, ` `, ` `  ] )

] ).


%=======================================================================
i_line_rule_cut( line_po_line, [
%=======================================================================

    `PO`, `:` ,  q10(tab)
    
    , or([
            generic_item( [ line_buyers_order_number , w1 , `=` ] )

            , generic_item( [ line_buyers_order_number , w , newline ] )

    ])

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    generic_item( [ line_invoice_line_dummy , d , [or([`.` , `)`]), q10(tab) ] ] )

    
    , generic_item( [ line_descr , s1, tab ] )
     
    , generic_item( [ line_quantity , d, q10(tab) ])
    
    , q10(generic_item( [ line_quantity_uom_code , w , tab ] ))

     , generic_item( [ line_unit_amount , d , tab ] )

    , generic_item( [ line_net_amount, d , newline ] )

   

] ).

%=======================================================================
i_line_rule_cut( line_debit_line, [
%=======================================================================

    q10(generic_item( [ line_invoice_line_dummy , d , [or([`.` , `)`]), q10(tab) ] ] ))
    
    , generic_item( [ line_descr , s1, tab ] )

    , generic_item( [ line_net_amount, d , newline ] )
 
] ).

%=======================================================================
i_line_rule_cut( line_gst_line, [
%=======================================================================

   
    read_ahead([`GST`])
          
     ,generic_item( [ line_descr, s1, tab ] )
   
    , generic_item( [ line_net_amount , d , newline ] )
   

] ).

