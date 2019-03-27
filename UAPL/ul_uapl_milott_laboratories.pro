%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - MILOTT LABORATORIES CO,LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_milott_laboratories, `8/11/2016` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


invoice_or_credit_note

	, get_supplier_details
	
    , get_invoice_number
	
	, get_invoice_date

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_bank_acct

    , get_order_number

    , get_invoice_lines
    
    ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE OR CREDIT NOTE or DEBIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( invoice_or_credit_note, [
%=======================================================================

	q(0,10,line)
	
	, or([
        invoice_or_credit_note_line

        , debit_note_line

    ])

] ).

%=======================================================================
i_line_rule( invoice_or_credit_note_line, [
%=======================================================================
 q0n(anything)
	
    ,[ `CREDIT`, `NOTE`]
	
	, set(credit_note)
	
	, trace( [ `This is a credit note` ] )

] ).

%=======================================================================
i_line_rule( debit_note_line, [
%=======================================================================
 q0n(anything)
	
    ,[ `DEBIT`, `NOTE`]
	
	, set(debit_note)
	
	, trace( [ `This is a Debit note` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
   
     sender_name(`MILOTT LABORATORIES CO LTD`)

     , supplier_vat_number(`0105532080312`)
   
  ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================
     
     q(0,20,line)

            , or([
                
                 generic_vertical_details( [ [ `Unilever`, `Asia`, `Private`, `Limited` ], `Limited`, q(0,3,up), (end,300,300), invoice_number , d , tab ] )

                , generic_vertical_details( [ [ `UNILEVER`, `(`, `M`, `)`, `HOLDINGS`, `SDN`, `.`, `BHD`, `.`,  newline ], `BHD`, q(0,3,up), (end,300,300), invoice_number , d , tab ] ) 

                , generic_horizontal_details( [ [ `NO`, `.`, tab],invoice_number, d , newline ] )


            ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_bank_acct, [
%=======================================================================
     
     q(0,100,line)

    , or([
                
     [ generic_horizontal_details( [ [ `A`, `/`, `C`, `NO`, `.`],supplier_bank_account_number_raw, s1 , newline ] )]

     ,[ generic_horizontal_details( [ [ `A`, `/`, `C`],supplier_bank_account_number_raw, s1 , newline ] )]

        ])
                     
     ,check(supplier_bank_account_number_raw=SupplierAccount)
    
   , check(strip_string2_from_string1( SupplierAccount, `-`, SupplierAccount1 ))

    ,supplier_bank_account_number(SupplierAccount1), trace( [ `New Bank`, supplier_bank_account_number ] )

] ).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

    q(0,20,line)

   , or([
        
        generic_horizontal_details( [ [`DATE`, tab],invoice_date, date , newline ] )

       , generic_vertical_details( [ [ `Unilever`, `Asia`, `Private`, `Limited` ], `Limited`, q(0,2,up), (end , 300 , 300), invoice_date , date , newline ] )

        , generic_vertical_details( [ [ `UNILEVER`, `(`, `M`, `)`, `HOLDINGS`, `SDN`, `.`, `BHD`, `.`,  newline ], `BHD`, q(0,3,up), (end,300,300), invoice_date , date , newline ] ) 

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

             generic_horizontal_details( [ [ q10(`1`), q10(`CS`), q10(tab) , `TOTAL`, tab ] , total_net , d , newline ] )

            , generic_horizontal_details( [ [ `GRAND` , `TOTAL`, tab ] , total_net , d , newline ] )

            , generic_horizontal_details( [ [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, tab, `LAEM`, tab, `CHABANG`, tab ] , total_net , d , newline ] )
            
        ])    

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

, [generic_horizontal_details( [ [ `VAT7`, `.`, `00`, `%`, tab ] , total_vat , d , newline ] )

, generic_item( [ default_vat_rate, `7` ] ) ]



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     qn0(line)

     , or([ 

                  

        [generic_horizontal_details( [ [ `GRAND` , `TOTAL`, tab ] , total_invoice , d , newline ] )

        ]


        , [generic_horizontal_details( [ [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, `SADAO`], 400, total_invoice, d, newline ] ) 
          
        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

        
        , [generic_horizontal_details( [ [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, tab, `BANGKOK`, tab ], total_invoice, d, newline ] ) 
          
        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

        , [generic_horizontal_details( [ [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, tab, `LAEM`, tab, `CHABANG`, tab],total_invoice, d, newline ] ) 

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

        , [generic_horizontal_details( [ [ `TOTAL`, `EX`, `-`, `FACTORY` ], 150 , total_invoice , d , newline ] )

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

        , [generic_horizontal_details( [ [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, `LAEM`, `CHABANG`], 400, total_invoice, d, newline ] ) 

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

        , [generic_horizontal_details( [ [`TOTAL`, `EX`, `-`, `FACTORY`], 500, total_invoice, d, newline ] ) 

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] ) ]

       , [line_before_total,q(0,1,line),line_total_rule,q(0,1,line), line_after_total]

       % , [ generic_vertical_details( [ [ `Amount` ], `Amount`, q(5,7), (end,30,30), total_invoice , d , newline ] )
        
       % , check( total_invoice = TotInv )

       % , trace( [ `Total Inv v` , TotInv] )

        %, total_net(TotInv)

       % , trace( [ `Total net` , total_net] ) ]

       % , [ generic_vertical_details( [ [ `say`, `total` ], `total`, q(1,2,up), (end,100,900), total_invoice , d , newline ] )
        
      %  , check( total_invoice = TotInv )

       % , trace( [ `Total Inv Say` , TotInv] )

       % , total_net(TotInv)

       % , trace( [ `Total net` , total_net] ) ]


         ])        

] ).

%=======================================================================
i_line_rule( line_before_total, [
%=======================================================================
 q0n(anything)

 , `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`,  newline

 
] ).

%=======================================================================
i_line_rule( line_total_rule, [
%=======================================================================
 q0n(anything)

 
 , generic_item( [ total_invoice, d, newline] )

 , check( total_invoice = TotInv )

        , trace( [ `Total Inv v` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net] )

] ).

%=======================================================================
i_line_rule( line_after_total, [
%=======================================================================
 q0n(anything)
 

 , `=`, `=`, `=`, `=`, `=`, `=`, `=`, `=`, `=`, `=`, `=`,  newline

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

    , generic_horizontal_details( [ [ or([ `CS`, `SET`]) , tab , currency_dummy(w) , tab ] , currency, w, newline ] )

    , trace([ `Dummy Currency`, currency_dummy ])

    , trace([ `Currency`, currency ])  

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

    , generic_horizontal_details( [ [ `PO` , `.` ], order_number , d , or([ `-` , tab ]) ] )

    , trace([ `PO Number`, order_number ])  

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

             [line_invoice_line2, q10( line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line )]

            , [ line_credit_line , q10( line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line )]
                     
            , [line_invoice_line , q10( line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line ) , q10(line_desr_line )]

            , line_invoice_line3

            , line_invoice_line_4
     
            

            , line

        ] )

    ] )

] ).
    
%=======================================================================
i_line_rule_cut( line_header_line, [    
%=======================================================================

    or([ 

        [`CS`, tab , `USD` , tab , `USD`]

        , [`PCS`, tab , `USD` , tab , `USD`]

        , [`SET`, tab , `USD` , tab , `USD`]

        , [`,`, `(`, `SAY`, `TOTAL`, `:`]

    ])    
 
    , trace( [ `FOUND LINE HEADER LINE`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

   or([ 
   
         [`TI`, `NO`, `.`]

         ,[`MLC`,`No`, `.`]

         ,[`sAY` ,`total`]

        ,[`GRAND`, `TOTAL`, tab ]

        , [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, `BANGKOK`, tab ]

        , [`TOTAL`, `EX`, `-`, `FACTORY`]

        , [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, `LAEM`, `CHABANG`]

        , [`TOTAL`, `F`, `.`, `O`, `.`, `B`, `.`, `SADAO`]

    ])


   , trace( [ `FOUND LINE END LINE`] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
          
       generic_item( [ line_quantity, d, tab ] ) 

     , q10(generic_item( [ line_item, s1, tab ] ))

     , or([
         
         generic_item( [ line_descr, s, [check(line_descr(end) < -154)] ] )
         , generic_item( [ line_descr, s1, tab ] )

     ])

     , generic_item( [ line_unit_price_dummy, d, tab ] )

     , generic_item( [ line_net_amount , d , newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================
          
     generic_item( [ line_quantity_dummy, d, q10(tab) ] )

     , or([
         
         generic_item( [ line_descr, s, [check(line_descr(end) < -154)] ] )

         , generic_item( [ line_descr, s1, tab ] )

     ])

     , q10(generic_item( [ line_unit_price_dummy, d, tab ] ))

     , generic_item( [ line_net_amount , d , newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_desr_line, [
%=======================================================================

     generic_append( [ line_descr, s1, newline, ` , `, `` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================
          
       q10(generic_item( [ line_item, w, tab ] ))

     , generic_item( [ line_quantity, d, q10(tab) ] ) 

     , or([
         
      generic_item( [ line_descr, s, [check(line_descr(end) < -154)] ] ) 

     , generic_item( [ line_descr, s1, tab ] )

     ])

     , generic_item( [ line_unit_price, d, tab ] )

     , generic_item( [ line_net_amount , d , newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================
          
    generic_item( [ line_item_dummy, w, tab ] )

     , generic_item( [ line_descr, s1, [ tab, `*`] ] )

     , generic_item( [ line_unit_price, d, tab ] )

     , generic_item( [ line_net_amount , d , newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_4, [
%=======================================================================
          
       generic_item( [ line_quantity, d, tab ] ) 

     , generic_item( [ line_descr, s1, tab ] )

     , generic_append( [ line_descr, s, [q10(tab), check(line_descr(end) < 154)], ` `, `` ] )

     , generic_item( [ line_unit_price_dummy, d, tab ] )

     , generic_item( [ line_net_amount , d , newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL



% Updated on   - march 7, 2018
% Updated by   - Thejaswi
% Changes made - New Format

% Updated on   - Jan 23, 2019
% Updated by   - Thejaswi
% Changes made - Total Invoice

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%