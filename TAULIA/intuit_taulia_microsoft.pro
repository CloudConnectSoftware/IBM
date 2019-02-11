%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Microsoft Corporation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_taulia_microsoft, `11 Feb, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(`m/d/y` ).

i_trace_lists.


i_op_param( us_invoice, _, _, _, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_shipto_address

    , get_bank_accountnumber

    , get_bank_accountnumber1
 
    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number

    , get_delivery_number

    , get_delivery_date
    
    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_contact_person

    , get_invoice_lines

    , get_shipping_charges


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

    sender_name( `Microsoft Corporation` )

   , supplier_party( `Microsoft Corporation` )
    
   , buyer_dept(`N/A`)

   , buyer_registration_number(`N/A`)

   , supplier_country_code(`US`)

   , supplier_street(`1950 N Stemmons Fwy Ste 5010`)

   , supplier_city(`DALLAS`)

   ,  supplier_state(`TX`)

   , supplier_postcode(`75207`)

   , delivery_country_code(`US`)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_shipto_address, [
%=======================================================================
  
     q(0,25,line)

   , line_add_line

   , q(0,1,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

   , q(0,1,line)

   , line_add_line_4

      , q(0,1,line)

   , line_add_line_5

      , q(0,1,line)

   , line_add_line_6

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`SHIP`, `TO`,  newline ])

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, newline ] )


] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

       generic_item( [ delivery_street_dummy, s1, tab ] )

      , generic_item( [ delivery_street_dummy1, s1, tab ] )

      , generic_item( [ supplier_street_dummy2, s1, tab ] )

     , generic_item( [ delivery_party, s1, newline ] )


] ).


%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================

       generic_item( [ delivery_street_dummy3, s1, tab ] )

      , generic_item( [ delivery_street_dummy4, s1, tab ] )

     , generic_item( [ delivery_party_dummy5, s1, newline ] )



] ).


%=======================================================================
i_line_rule( line_add_line_4, [
%=======================================================================

       generic_item( [ delivery_street_dummy6, s1, tab ] )

      , generic_item( [ delivery_street_dummy7, s1, tab ] )

       , generic_item( [ delivery_street, s1, tab ] )

     , generic_item( [ delivery_party_dummy8, s1, newline ] )



] ).


%=======================================================================
i_line_rule( line_add_line_5, [
%=======================================================================

       generic_item( [ delivery_street_dummy8, s1, tab ] )

      , generic_item( [ delivery_street_dummy9, s1, tab ] )

     , generic_item( [ delivery_party_dummy10, s1, newline ] )



] ).

%=======================================================================
i_line_rule( line_add_line_6, [
%=======================================================================


       generic_item( [ delivery_street_dummy11, s1, tab ] )

      , generic_item( [ delivery_street_dummy12, s1, tab ] )

     , generic_item( [delivery_city , s , [q10(tab), check(delivery_city(end) < 293)] ] )

     , generic_item( [ delivery_state, s, [q10(tab), check(delivery_state(end) < 321)] ] )

     , generic_item( [ delivery_postcode, s1, newline ] )

   
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,20,line)

     , or([

        generic_horizontal_details( [ [`Invoice`, `No`, `:` ],invoice_number, d, newline ] )

     , generic_horizontal_details( [ [`Document`, `No`, `:`, tab ],invoice_number, d, newline ] )

] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

    last_line
    
    , q(0,200,up)

     , generic_horizontal_details( [ [`Rt`, `:`, generic_item( [ bank_number, d ] ), `/`, `acct`, `:`],bank_account_number, d, [`(`, `ACH`, `)`,  newline ] ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT NUMBER ALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber1, [
%=======================================================================

    
    
     q(0,20,line)

     , generic_horizontal_details( [ [`Acct`, `#` ], bank_account_number, d, newline ] )

      ,    q(0,2,line)

     ,[generic_horizontal_details( [ [`Aba`, `#`], bank_number_raw, s, [`(`, `ACH`, `)`] ] )

      , check( bank_number_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, `-`, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , bank_number(BankStrip)

    , trace( [ `Bank account Number` , bank_number ] )  ]



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,25,line)

  , or([

    [generic_horizontal_details( [ [ `Invoice`, `Date`, `:`, dummy_num(w), `,` ], invoice_date, date, newline ] )

          , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )]


     , [generic_horizontal_details( [ [ `Document`, `Date`, `:`, tab ], invoice_date, date, newline ] )

          , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )]


] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,25,line)


     , generic_horizontal_details( [ [`Payment`, `Due`, `Date`, `:` ], due_date, date, newline ] )


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

      generic_horizontal_details( [ [ tab, `PO`, `:` ], po_number, d, newline ] )

     , generic_horizontal_details( [ [ `PO`, `Number`, `:` ], po_number, d, newline ] )
   
] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================
 
 last_line

 , q(0,100,up)
 
 ,generic_horizontal_details( [ [`Total`, `Sale`, tab, `USD`, tab ],  total_net, d, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================
 
 
 last_line

 , q(0,100,up)
 
 
 ,generic_horizontal_details( [ [`Tax`, `Amount`, tab, `USD`, tab ],  total_vat, d, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

 
  last_line

 , q(0,100,up)
 
 ,or([

  generic_horizontal_details( [ [ `Total`, `Amount`, tab, generic_item( [ currency, w ] ), tab ],  total_invoice, d, newline ] )

 , generic_horizontal_details( [ [`Total`, `for`, `Invoice`, `(`, generic_item( [ currency, w ] ), `)`, tab ],  total_invoice, d, newline ] )


] )

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
              
          [line_invoice_line, q10(line_append_line)]

          , line_invoice_line1

          , line_invoice_line2

         % , line_invoice_line3

          , line_invoice_line4

          , line_invoice_line5


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

        or([

            [`Name`, tab, `Week`, `Starting`]

            ,  [`Name`, tab, `Date`, tab, `Category`]


        , [`Line`, `No`, `.`, tab, `Usage`, `Country`]
        

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

     or([

         [`Page`]

         , [`MCS`, `_`, `uiInvoiceCDN`, tab, `Page`]

         
         , [`Page`, `2`, `of`, `16`,  newline ]

         , [`Name`, tab, `Date`, tab, `Category`]

         , [`Sub`, `-`, `total`, `for`, `Services`]


         , [`Remit`, `To`, `:`, tab ]

         , [`https`, `:`, `/`, `/`, `cp`, `/`, `Core`, `/`, `Report`, `/`]

         , [`Total`, `for`, `Invoice`, `(`]


    , [`We`, `hereby`, `certify`, `that`, `the`, `information`]

     ] )

     , trace( [ `Found End line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    
    generic_item( [ line_number, d, tab ] )

  , generic_item( [ line_usage_country, s1, tab ] )

  , generic_item( [ line_item, s1, tab ] )

  , generic_item( [ line_item_dummy, s1, tab ] )
    
  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_descr_dummy, s1, tab ] )

  , generic_item( [ line_descr_dummy1, s1, tab ] )


  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    
    generic_append( [ line_descr, s1, tab, ` `, ` `  ] )

  , generic_item( [ line_descr_dummy2, s1, tab ] )

  , generic_item( [ line_descr_dummy3, s1, tab ] )

  , generic_item( [ line_amount, d, newline ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    generic_item( [ line_descr_dummy4, s1, tab ] )

  , generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy5, s1, tab ] ))

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    q10(generic_item( [ line_descr_dummy5, s1, tab ] ))

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_descr_dummy5, s1, tab ] )

 , q10(generic_item( [ line_descr_dummy6, s1, tab ] ))

  , q10(generic_item( [ line_descr_dummy7, s1, tab ] ))

  , q10(generic_item( [ line_descr_dummy8, s1, tab ] ))

 , q10(generic_item( [ line_descr_dummy9, s1, tab ] ))

  , q10(generic_item( [ line_descr_dummy10, s1, tab ] ))

  , generic_item( [ line_quantity_dummy, d, tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

    generic_item( [ line_descr_dummy6, s1, tab ] )

  , generic_item( [ line_descr_dummy8, s1, tab ] )

  , generic_item( [ line_descr_dummy7, s1, tab ] )

   , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line5, [
%=======================================================================

  
    generic_item( [ line_start_date, date, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )

   , generic_item( [ line_descr, s1, [tab, `(`] ] )

  , generic_item( [ line_net_amount, n, [`)`,  newline ] ] )

  
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - Feb 11, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   - 
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

