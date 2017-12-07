%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - TEPAK MARKETING SDN.BHD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_tepak_marketing, `29/5/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

    ,get_buyer_reg_no

    , invoice_or_credit_note

    , get_bank_account_no
	
    , get_invoice_number
	
	, get_invoice_date

    , get_line_buyers_order_number

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_rounding_amount

    , get_currency

     , get_currency_alternative

    , get_line_delivery_note_number

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
  
   sender_name(`TEPAK MARKETING SDN.BHD`)

   , supplier_vat_number(`000760807424`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BUYER REG DETAILS
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

       [`C`, `/`, `O`, `UNILEVER`]
       ,[`20`, `PASIR`, `PANJANG`]

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
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

	q(0,250,line)


     ,  generic_horizontal_details( [ [  `BANK`, `ACCOUNT`,`NO`, `:`],  supplier_bank_account_number, w, newline ] )
                
	

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE OR CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( invoice_or_credit_note, [
%=======================================================================

	q(0,10,line)
	
	, invoice_or_credit_note_line

] ).

%=======================================================================
i_line_rule( invoice_or_credit_note_line, [
%=======================================================================

	`CREDIT`, `NOTE`
	
	, set(credit_note)
	
	, trace( [ `This is a credit note` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================
    
    q(0,10,line)

    , or( [ 

        generic_horizontal_details( [ [ `Credit`, `Note`, `No`, tab, `:` ], invoice_number , s1 , newline ] ) 

        , generic_horizontal_details( [ [ `LEVEL`, `33`, `-`, `35`, `,`, `MENARA`, `TELEKOM`, `,`, tab, `NO`, `.` ], 100, invoice_number, s1, newline ] )

        , generic_horizontal_details( [ [ `REF` , `NO` , `:` ], 100 , invoice_number , s1 , newline ] )

        , generic_vertical_details( [ [ `Date` ], 'Date', q(0,1,up), (start,10,10), invoice_number , s1 , newline ] )

       ,  generic_horizontal_details( [ [ `Debit`, `Note`, `No`, tab, `:` ], invoice_number , s1 , newline ] ) 

    ])
	
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

    , generic_horizontal_details( [ [ `DATE` , q01(tab) , q01(`:`) ], 100, invoice_date, date, newline ] )    
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE BUYERS ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut(get_line_buyers_order_number, [
%=======================================================================

    q(0,15,line)

    , generic_horizontal_details( [ [`P`, `.`, `O`, `.`, `NO`, `.` ] , 100,  line_buyers_order_number , s1 , newline ] )

    , check(line_buyers_order_number = OrdNo)

    , trace([`Order Number Capital Variable` , OrdNo])

    , order_number(OrdNo)

    , trace( [ `THIS IS NOW THE Header Order Number` , OrdNo ])
	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

    qn0(line)

    , or( [ 
            
        generic_horizontal_details( [ [ `TOTAL`, `EXCL`, `.`, `GST` ], 230 , total_net , d , newline ] )

        ,generic_horizontal_details( [ [ `ZR`, tab, `@`, `0`, `%` ], 230 , total_net , d , tab ] )

        , generic_horizontal_details( [ [ `TOTAL`, tab ],  total_net, d , newline ] )

    ])
  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TAX AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

    qn0(line)

    , or( [   

        generic_horizontal_details( [ [ `Add` , `GST` ], 100, total_vat , d, newline ] )

        , generic_horizontal_details( [ [ `GST` , `@` , line_vat_rate_dummy(d) , `%` , `:` ], 100 , total_vat , d , newline ] )

        , generic_item( [ default_vat_rate, `0` ] )

     ])
    
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     qn0(line)

     , or([ 

     generic_horizontal_details( [ [ `TOTAL`, `PAYABLE` , `INCL` , `.` , `GST` ], 300 , total_invoice , d , newline ] )

      , generic_horizontal_details( [ [ `GRAND` , `TOTAL` , `:` ], 100 , total_invoice , d , newline ] )

     , [test(credit_note) , generic_horizontal_details( [ [ `TOTAL` ], 200, total_invoice, d , newline ] )]

     ,generic_horizontal_details( [ [ `ZR`, tab, `@`, `0`, `%`], 230 , total_invoice , d , tab ] )

      , generic_horizontal_details( [ [ `TOTAL`, tab ],  total_invoice, d , newline ] )

     ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ROUNDING AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_rounding_amount, [
%=======================================================================

     qn0(line)

     , generic_horizontal_details( [ [ `ROUNDING` , `ADJUSTMENT`], 200 , rounding_amount , d , newline ] )

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

    , or( [

         [test(credit_note) , generic_horizontal_details( [ [ `DESCRIPTION`, tab , `Amount` , `(` ] , currency , w , [`)`, newline ] ] ) ]  

        , generic_vertical_details( [ [ `SUB` , `TOTAL` ], `SUB`, q(0,1,up), (start , 400 , 400 ), currency , w , newline ] )

        , ([ generic_vertical_details( [ [ `TOTAL` , `AMT` ], `TOTAL` , q(0,2), (start , 20 , 20 ), currency_raw , w , newline ] )

        , check( currency_raw = CurrencyRaw )

        , trace( [ `Invoice Currency raw` , CurrencyRaw ] )

        , check(strip_string2_from_string1( CurrencyRaw , `(` , CurrencyNew1 ))

        , check(strip_string2_from_string1( CurrencyNew1 , `)` , CurrencyNew2 ))

        , trace( [ `Bracket stripped currency` , CurrencyNew2 ] )

	    , currency(CurrencyNew2)

        , trace( [ `Currency` , currency ] )


        ])

        ])
     
]).
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Currency Alternative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency_alternative, [
%=======================================================================

       q0n(line)

    , generic_horizontal_details( [ [ `Amount`, `(` ], currency, w, [`)`,  newline ] ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE DELIVERY NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_delivery_note_number, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `D`, `.`, `O`, `.`, `NO` ], 150 , line_delivery_note_number , d,  newline ] )

    

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [    
%=======================================================================

    or( [ 
    
       [ test(credit_note), `DESCRIPTION` , tab , `Amount` , `(` ] 

       ,[`DESCRIPTION`, tab, `QTY`, tab ]
      
        
       , [`ITEM`, `NO`, `.`, tab, `DESCRIPTION`, tab, `QUANTITY`]

       , [`MATERIAL`, tab, `MATERIAL`, tab, `QTY`, tab, `UNIT`, `PRICE`, tab, `TOTAL`, `AMT`,  newline]

       , [`DESCRIPTION`, tab, `Amount`]

       ,[`BALANCE`, `B`, `/`, `F`]

    ])
 
    , trace( [ `FOUND LINE HEADER LINE`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

     or( [

     [ test(credit_note), `TOTAL` ] 

      ,`TOTAL` 
     
     , [`RINGGIT`, `MALAYSIA`]
     
     , [ `GST`, `Summary`, tab, `Amount`, tab, `GST`, `Amt`]

     ,[`GST`, `Summary`, tab, `Amount`, tab, `GST`, `Amt`]

     , [`GRAND` , `TOTAL`]

     , [`TOTAL`, tab ]

     ,[`BALANCE`, `B`, `/`, `F`]

     ])

    , trace( [ `FOUND LINE END LINE`] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
      
      generic_item( [ line_item_dummy, d ] )
    
    , generic_item( [ line_item, s1, tab ] )

    , or([

        generic_item( [ line_descr, s1, [ check(line_descr(end) < -55) , tab ] ] )

        , generic_item( [ line_descr, s, [ check(line_descr(end) < -55)  ] ] )

        ])

    , generic_item( [ line_quantity , d ] )

    , generic_item( [ line_price_uom_code, w, tab ] )

    , generic_item( [ line_unit_price, d, tab ] )

    , generic_item( [ line_net_amount, d, tab ] )

    , q10(generic_item( [ line_vat_amount, d, tab ] ))

    , or( [ 

        [    
        
        generic_item( [ line_total_amount , d , tab ] )

        , generic_item( [ line_vat_code_dummy, w, newline ] )

        ]

        , generic_item( [ line_total_amount , d , newline ] )

    ])
   
] ).

%=======================================================================
i_line_rule_cut( line_desr_line, [
%=======================================================================

    generic_append( [ line_descr , s1 , newline , ` ` , `` ] )

    , trace( [`Appended Line Description`])

] ).

%=======================================================================
i_line_rule_cut( line_invoice_oneline, [
%=======================================================================
      
      generic_item( [ line_item_dummy , d , tab ] )
    
    , generic_item( [ line_item, w , tab ] )

    , generic_item( [ line_descr, s1 , [ check(line_descr(end) < -40) , tab ] ])

    , generic_item( [ line_buyers_order_number , d , tab ])

    , q10(generic_item( [ line_delivery_note_number, d , tab ] ))

    , generic_item( [ line_quantity , d , tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_desr_firstline, [
%=======================================================================

      generic_item( [ line_descr , s1 , newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_twoline, [
%=======================================================================
      
      generic_item( [ line_dummy, d , tab ] )
    
    , generic_item( [ line_item, w, tab ] )

    , generic_item( [ line_buyers_order_number , d , tab ])

    , q10(generic_item( [ line_delivery_note_number, d , tab ] ))

    , generic_item( [ line_quantity , d , tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_desr_line2, [
%=======================================================================

    generic_append( [ line_descr , s1 , newline , ` ` , `` ] )

    , trace( [`Appended Line Description`])

]).   

%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================

        test(credit_note)

        ,generic_item( [ line_descr, s1 , tab ] )        
        
        , generic_item( [ line_total_amount, d, newline ] )] 
        
        
).

%=======================================================================
i_line_rule_cut( line_credit_line2, [
%=======================================================================

        test(credit_note)

        , generic_item( [ line_item, w, tab ] )

        ,generic_item( [ line_descr, s1 , tab ] )        

        , generic_item( [ line_quantity, d, tab ] )

        , generic_item( [ line_unit_amount, d, tab ] )
        
        , generic_item( [ line_total_amount, d, newline ] )
        
        
]).   

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

        test(credit_note)

        , generic_item( [ line_item, w, tab ] )

        ,generic_item( [ line_descr, s1 , tab ] )        

        , generic_item( [ line_quantity, d, tab ] )

        , generic_item( [ line_unit_amount, d, tab ] )
        
        , generic_item( [ line_total_amount, d, newline ] )
        
        
]).   

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

         generic_item( [ line_descr, s1 , tab ] )        
        
        , generic_item( [ line_net_amount, d, newline ] )
        
        
]).   


%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

          generic_item( [ line_number, w, tab ] )

        , generic_item( [ line_item, w, tab ] )

        ,generic_item( [ line_descr, s1 , tab ] )        
    
        , generic_item( [ line_total_amount, d, newline ] )
        
        
]).   

%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================

         generic_item( [ line_buyers_order_number, d, tab ] )

        ,q10(generic_item( [ line_do, d, tab ] ))

        , generic_item( [ line_quantity, d, tab ] )

        , generic_item( [ line_unit_amount, d, newline ] )
        
]).   

%=======================================================================
i_line_rule_cut( line_invoice_line5, [
%=======================================================================

          generic_item( [ line_number, w  ] )

        , generic_item( [ line_item, d, tab ] )

        ,generic_item( [ line_descr, s1 ] )       

         ,generic_item( [ line_quantity, d  ] ) 

       ,generic_item( [ line_quantity_uom_code, w, tab  ] ) 

      , generic_item( [ line_unit_amount, d, tab ] )

       , generic_item( [ line_net_amount, d, tab ] )
    
        , generic_item( [ line_total_amount, d, tab ] )

         , generic_item( [ line_vat_code, w, newline ] )
    
        
        
]).   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - October 17, 2017
% Updated by   - Rohini
% Changes made - New line format added [ line_invoice_line3, q10(line_desr_line2),line_invoice_line4, q10(line_desr_line2)]

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

