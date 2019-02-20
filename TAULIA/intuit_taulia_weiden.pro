%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wieden + Kennedy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_taulia_weiden, `7 Feb, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(`m/d/y` ).

i_trace_lists.

i_op_param( us_invoice, _, _, _, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_bank_accountnumber
 
    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number
    
    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_contact_person

    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

    sender_name( `Wieden + Kennedy` )
    
  % , buyer_dept(`N/A`)

  % , buyer_registration_number(`N/A`)

   , supplier_country_code(`US`)

   , currency(`USD`)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================
  
     q(2,5,line)

   , line_add_line


   , q(0,2,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

   , q(0,1,line)

   , line_add_line_4

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`Wieden`, `+`, `Kennedy`,  newline ])

     , trace( [ `Found address`] )

     , generic_item( [ supplier_party, s1, newline ] )



] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

       generic_item( [ supplier_street, s1, tab ] )

    , generic_append( [supplier_street, s1, newline, ` `, ` `  ] )


] ).

%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================
 
     generic_item( [supplier_city , s , [q10(tab), check(supplier_city(end) < -22)] ] )

     , generic_item( [supplier_dummy , s , [q10(tab), check(supplier_dummy(end) < 11)] ] )

     , generic_item( [ supplier_state, w ] )

     , generic_item( [ supplier_postcode, d, newline ] )

   
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


    , [`CREDIT`, `AMOUNT`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,10,line)

     , or([
  

        [generic_horizontal_details( [ [ `INVOICE`, tab ], invoice_number_raw, s1, tab ] )

    , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `-`, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

    , trace( [ `Invoice Number` , invoice_number ] )  ]


       ,  generic_vertical_details( [ [`Invoice`, `#`], `Invoice`, q(0,1), (start, 200,300), invoice_number, s1, tab ] )

       ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,15,line)

        , or([

     [generic_vertical_details( [ [`Date`, `of`, `Invoice` ], `Date`, q(0,1), (start, 200,300), invoice_date, date, newline ] )

   
      , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )]

     ,   [generic_horizontal_details( [ [ `BILL`, `DATE` ], invoice_date, date, tab ] )

   
      , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )]


] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,30,line)

   , or([

       generic_horizontal_details( [ [ `PO`, `NUMBER`, tab ],po_number, d, newline ] )

  , generic_vertical_details( [ [`PO`, `Number`, tab], `PO`, q(0,1), (start, 10,50), po_number, d, tab ] )

] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

  q(0,50,line)

  , generic_horizontal_details( [ [`ABA`, `#`], bank_number, d, newline ] )

  , q(0,2,line)

     , or([

   [generic_horizontal_details( [ [`Account`, `Number`, `:`], bank_account_number_raw, s1, newline ] )

      , check( bank_account_number_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, `-`, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , bank_account_number(BankStrip)

    , trace( [ `Bank account Number` , bank_account_number ] )  ]

      , [generic_horizontal_details( [ [`ACCOUNT`, `NUMBER`, `#`], bank_account_number_raw, s1, newline ] )

      , check( bank_account_number_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, `-`, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , bank_account_number(BankStrip)

    , trace( [ `Bank account Number` , bank_account_number ] )  ]

] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

q(0,30,line)

 , or([

    [generic_horizontal_details( [ [`Invoice`, `Totals`, `:`, tab, `$`, tab ],  total_invoice, d, newline ] )

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )]


     , generic_horizontal_details( [ [`TOTAL`, `AMOUNT`, `DUE`, tab, generic_item( [ total_net, d ] ), tab ],  total_invoice, d, newline ] )

     , [generic_horizontal_details( [ [`TOTAL`, `AMOUNT`, `DUE`, tab ],  total_invoice, d, [`-`, tab ] ] )

        , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )]

] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

q(0,50,line)

,invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

q0n(anything)

  ,  [`Invoice`, `Totals`, `:`, tab, `$`]


,currency( `USD` ) 

,trace( [ `currency found`] )

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
              
       line_invoice_line

       , line_invoice_line1

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    or([

    [`Description`, tab, `Amount`,  newline ]

    , [`WORK`, `CODE`, tab, `NET`, `AMOUNTS`]
    
] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
      or([
      
       [`Invoice`, `Totals`, `:`, tab, `$` ]

       , [`TOTAL`, `AMOUNT`, `DUE`, tab ]
 

      ])

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


    generic_item( [ line_descr, s1, [tab, `$`, tab ] ] )

  ,  generic_item( [ line_net_amount, d, newline ] )
 
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================


    generic_item( [ line_descr, s1, tab ] )

  ,  generic_item( [ line_net_amount, d, tab ] )

  ,  generic_item( [ line_total_amount, d, newline ] )
 
  
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - Feb 7, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   - 
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
