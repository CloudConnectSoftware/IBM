%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - Mediterranean Shipping Company 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_mediterranean, `17/08/2018 11:51:47` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.


 i_pdf_parameter( dont_tokenise_on_font_change, 1 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

  	, get_invoice_number

    , get_invoice_date

   , import_or_elsewhere_inv

    , get_currency

    , get_total_invoice
   
    , get_credit_note

    ,get_bank_account_no

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE OR CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_credit_note, [
%=======================================================================

	q(0,10,line)
	
	, invoice_or_credit_note_line

] ).

%=======================================================================
i_line_rule( invoice_or_credit_note_line, [
%=======================================================================

	or([
        
    [`ELSEWHERE` , `CREDIT`, `NOTE`]

   , [`IMPORT`, `CREDIT`, `NOTE`]

   ] )
	
	, set(credit_note), set(credit)
	
	, trace( [ `This is a credit note` ] )

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

     with( invoice, currency, Currency )

    , trace( [ `currency is`, Currency ] )

    , q0n(line) 

	, or([
        [check( Currency = `USD` ) , generic_horizontal_details( [ [ `Account`, `No`,q10(tab), `:`,q10(tab)],  supplier_bank_raw, s, [`(`, `USD`, `)`, `/`] ] )]

        , [check( Currency = `SGD` ) , generic_horizontal_details( [ [ `Account`, `NO`,q10(tab), `:`,q10(tab), dummy_account(w), `(`, `USD`, `)`, `/` ],  supplier_bank_raw, w, [`(`, `SGD`, `)`,  newline ] ] )]
       
    ])

    ,check(supplier_bank_raw=SupplierAccount)
    
   , check(strip_string2_from_string1( SupplierAccount, `-`, SupplierAccount1 ))

    ,supplier_bank_account_number(SupplierAccount1), trace( [ `New Bank`, supplier_bank_account_number ] )
	

] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================


 q0n(line)
    
    , supplier_vat_number(`20-0009291-Z`)
     
    , sender_name(`MEDITERRANEAN SHIPPING COMPANY`)

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

    , or([ check_text(`Invoice`) , check_text(`Document`) ])

    , or([
        generic_horizontal_details( [ [ `INVOICE`, `NO`, `.`, tab,  `:` ] , 100 , invoice_number, w , newline ] )
   
    , generic_horizontal_details( [ [ `Document`, `Number`,  q10(tab),  `:` , q10(tab) ] , invoice_number, w , newline ] )

    , generic_vertical_details( [ [ `Invoice`, `No`], `No`, q(0,3), (end,10,10), invoice_number, w, tab ] )

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

    ,or([ check_text(`Invoice`), check_text(`Date`), check_text(`Unilever`)])

    , or( [ 
    
          generic_horizontal_details( [ [ `Date`, tab, q10( `:`) ] , invoice_date_raw, s1 , newline ] )

          , generic_vertical_details( [ [ `Invoice`, `date`], `date`, q(0,3), (end,10,10), invoice_date_raw, date, tab ] )

        , generic_horizontal_details( [ [ `P`, `.`, `O`, `.`, `Box`, `:`, tab, `1`, tab, `:` ], invoice_date_raw, s1 , newline ] )

        , generic_horizontal_details( [ [ `UNILEVER`, `ASIA`, `PTE`, `LTD`, tab, `:` ], invoice_date_raw , s1 , newline ] )

        , generic_horizontal_details( [ [ `UNILEVER`, `ASIA`, `PRIVATE`, `LIMITED`, tab, `:` ], invoice_date_raw , s1 , newline ] )


        ] )

    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice date raw` , DateRaw ] )

    , check(string_string_replace( DateRaw, `-`, `/`, DateStrip ))

    , trace( [ `Replaced - with / ` , DateStrip ] )

    , or( [

                check(string_string_replace( DateStrip, `SEP` , `09` , DateMonthRepl ))

            ,   check(string_string_replace( DateStrip, `OCT` , `10` , DateMonthRepl ))

    ])

    , trace( [ `Replaced Month` , DateMonthRepl])

    , invoice_date(DateMonthRepl)

    , trace( [ `Invoice Date` , invoice_date ] )  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORT OR ELSEWHERE INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( import_or_elsewhere_inv, [
%=======================================================================

	q(0,20,line)
	
	, import_or_elsewhere_inv_line

] ).

%=======================================================================
i_line_rule( import_or_elsewhere_inv_line, [
%=======================================================================

	or([
        [[`IMPORT`, `TAX` , `INVOICE`] , set(importinv_found)  	, trace( [ `This is an Import Invoice` ] )]

       ,[[`IMPORT`, `Credit` , `Note`] , set(importinv_found)  	, trace( [ `This is an Import Credit` ] )] 

       ,[[`Export`, `TAX` , `INVOICE`] , set(exportinv_found)  	, trace( [ `This is an Export Invoice` ] )]
       
       
       ])

] ). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================
    
     with( invoice, currency, Currency )

    ,trace( [ `currency is`, Currency ] )

    ,q(0,50,line)

     ,or([ check_text(`Amount`), check_text(`Total`), check_text(`Grand`) ])
  
    ,or( [
                         

         [ test(importinv_found),  or([ generic_horizontal_details( [ [ `Amount` , `Due` , `:` , tab , dummy_number(d) ] , 300 , total_invoice, d , newline ] )
                                        ,generic_horizontal_details( [ [ `Amount` , `Due` , `:`  ] , 500 , total_invoice, d , newline ] )
                                       
                                      ]) 
         ]
               
        ,[ test(exportinv_found),  or([generic_horizontal_details( [ [ `Amount` , `Due` , `:` , tab , dummy_number(d) ] , 200 , total_invoice, d , newline ] ) 
                                        ,generic_horizontal_details( [ [ `Total`, `Amount`, `:`  ], 200, total_invoice,d, newline ] )
                                        ,generic_horizontal_details( [ [ `Total`, `Amount`, `:`  ], 200, total_invoice,d, tab ] )
            ] )

        ]
         ,[ peek_fails(test(importinv_found)),check( Currency = `USD` ),  generic_horizontal_details( [ [ `Amount` , `Due` , `:` ], 800, total_invoice, d , or([ tab , newline ]) ] )]

         ,[ peek_fails(test(exportinv_found)),check( Currency = `USD` ),  generic_horizontal_details( [ [ `Grand` ,  `Total`, `:` ], 800, total_invoice, d , `USD`] )]
         
       % ,[ peek_fails(test(exportinv_found)) ,check( Currency = `SGD` ),  generic_vertical_details( [ [  `TOTAL`, `(`, `SGD`, `)`,  newline ], `TOTAL`, q(0,3), (end,30,30), total_invoice, d, newline ] )  ]
		
     
     ])

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )
         

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_currency, [
%=======================================================================

    q(0,50,line)

    ,currency_line

]).
    
    %=======================================================================
    i_line_rule_cut( currency_line, [
    %=======================================================================
    
     
    q0n(anything)

    , or([
        [[ `Total`, `In`, `Words`, `:`, tab, `SINGAPORE`, `DOLLAR`] , currency( `SGD` ), trace( [ `Currency is SGD` ] )]
    
    , [[ `Total`, `In`, `Words`, `:`, tab, `USD`] , currency( `USD` ), trace( [ `Currency is USD` ] )]
   
    ,  [ [`Total`, `In`, `Words`, `:`, tab, `USD`, `DOLLAR` ] , currency( `USD` ) ,trace( [ `Currency is USD` ] )]

    ,  [ [ `US`, `DOLLAR`, dummy_amount_words(s1) ] , currency( `USD` ) ,trace( [ `Currency is USD` ] )]

    ,  [ [ `Singapore`, `DOLLAR`, dummy_amount_words(s1) ] , currency( `SGD` ) ,trace( [ `Currency is SGD` ] )]

    , [[ `Total`, `In`, `Words`, `:`, tab, `SGD`] , currency( `SGD` ), trace( [ `Currency is SGD` ] )]
   

    ])

 
	
	] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - October 17, 2017
% Updated by   - Thejaswi K
% Changes made - Invoice date


% Updated on   - June 13, 2018
% Updated by   - Rohini
% Changes made - Import Credit note - currency


% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








