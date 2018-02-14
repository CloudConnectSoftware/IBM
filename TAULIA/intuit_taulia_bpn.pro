%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRAND PROGRAMMING NETWORK LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_taulia_bpn, `11 Feb, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


i_op_param( us_invoice, _, _, _, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_shipto_address

    , get_bank_accountnumber
 
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

    , get_invoice_total

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

    sender_name( `BRAND PROGRAMMING NETWORK LLC` )

   , supplier_party( `BRAND PROGRAMMING NETWORK LLC` )
    
   , buyer_dept(`N/A`)

   , buyer_registration_number(`N/A`)

   , supplier_country_code(`US`)



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

      last_line
      
      ,q(0,50,up)


    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)


    , [`*`, `*`, `CREDIT`, `AMOUNT`, `*`, `*`]

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

     q(0,20,line)

     , or([

      [generic_horizontal_details( [ [`Invoice`, `#` ],invoice_number_raw, s1, newline ] )

    , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `-`, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

    , trace( [ `Invoice Number` , invoice_number ] )  ]

    , generic_horizontal_details( [ [ `Invoice`, `:`, tab ], invoice_number, d, newline ] )

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

     q(0,25,line)

, or([

    generic_horizontal_details( [ [ `Invoice`, `Date`, `:`, tab ],  invoice_date, date, newline ] )


     , [generic_horizontal_details( [ [`Inv`, `Date` ], invoice_date_raw, s1, tab ] )

   

         ,check(invoice_date_raw= DateRaw) , trace( [ `Date Raw`, DateRaw] )

    ,check(q_sys_sub_string( DateRaw, 1, 3, Substring1 )), trace( [ `Date RawSubstring 1`, Substring1 ] )

    ,check(q_sys_sub_string( DateRaw, 4, 2, Substring2 )), trace( [ `Date RawSubstring 2`, Substring2] )

    ,check(q_sys_sub_string( DateRaw, 7, 2, Substring3 )), trace( [ `Date RawSubstring 3`, Substring3] )

    ,check(strcat_list( [ Substring1, ` ` , Substring2 , ` `, Substring3 ], DateNew ))

    ,invoice_date(DateNew) ,  trace( [ `New Date format`, invoice_date ] )]

  ] )
          , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )




] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,60,line)


, or([

    generic_horizontal_details( [ [ `Due`, `Date` ], due_date, date, newline ] )

     , [generic_horizontal_details( [ [`Payment`, `Due`, `Date`, `:` ], due_date_raw, s1, newline ] )

              ,check(due_date_raw= DueRaw) , trace( [ `Due Raw`, DateRaw] )

    ,check(q_sys_sub_string( DueRaw, 1, 3, Substring1 )), trace( [ `Due RawSubstring 1`, Substring1 ] )

    ,check(q_sys_sub_string( DueRaw, 4, 2, Substring2 )), trace( [ `Due RawSubstring 2`, Substring2] )

    ,check(q_sys_sub_string( DueRaw, 7, 2, Substring3 )), trace( [ `Due RawSubstring 3`, Substring3] )

    ,check(strcat_list( [ Substring1, ` ` , Substring2 , ` `, Substring3 ], DueNew ))

    ,due_date(DueNew) ,  trace( [ `New Due Date format`, due_date ] )]

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

     ,or([

    [ generic_horizontal_details( [ [`Client`, `PO`, `Number`, `:`, tab ], po_number_raw, s1, newline ] )

         , check( po_number_raw = PoRaw )

    , trace( [ `PO number raw` , PoRaw ] )

    , check(string_string_replace( PoRaw, ` `, ``, PoStrip ))

    , trace( [ `PO Stripped Space` , PoStrip ] )

    , po_number(PoStrip)

    , trace( [ `PO Number` , po_number ] )  ]


     , generic_horizontal_details( [ [ `Client`, `Ref`, `PO`, `#` ], po_number, d, newline ] )
   
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

last_line

,q(0,100,up)



,set(regexp_allow_partial_matching) 

,or([

    generic_horizontal_details( [ [`*`, `*`, `TOTAL`, `AMOUNT`, `*`, `*`, tab, `$` ], total_invoice, d, newline ] )


 , generic_horizontal_details( [ [`CREDIT`, `AMOUNT`, `*`, `*`, tab, `$`],  total_invoice, d, [`CR`] ] )

] )

,clear(regexp_allow_partial_matching) 

    , trace( [ `Invoice Total` , total_invoice ] )  

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_total, [
%=======================================================================

  

   q(0,100,line)


   , generic_horizontal_details( [ [ `Invoice`, `Total`, tab ], total_invoice, d, newline ] )

    , trace( [ `Invoice Total` , total_invoice ] )  

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )



] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
              
           line_invoice_line2
         
         , line_invoice_line1

         , line_invoice_line
       
        % ,  line_invoice_line4


          , [q10(line_descr_line),q10(line_append_line), q10(line_append_line), q10(line_append_line), q10(line_append_line), line_amount_line ]


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

        or([

            [`Description`, `of`, `Services`, tab ]

        ,[`Station`, tab, `Spots`, tab, `Ordered`, tab ]

        , [`Market`, `:` ]

] )
    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

     or([
       
         [`*`, `Market`, `*`, `NATC` ]


     , [`*`, `Market`, `*` ]

     , [ `Please`, `Remit`, `Payment`, `To`]

     ] )

     , trace( [ `Found End line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_spots, s1, tab ] ))

  , generic_item( [ line_quantity, d, tab ] )

  ,set(regexp_allow_partial_matching)


    ,  generic_item( [ line_net_amount, n, [`CR`, tab ] ] )

  ,clear(regexp_allow_partial_matching)


  , generic_item( [ line_amount_dummy, d, tab ] )


  ,  generic_item( [ line_net_amount_dummy, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_spots, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_net_amount, d, tab ] )


  , generic_item( [ line_amount_dummy, d, tab ] )

  , generic_item( [ line_net_amount_dummy, s1, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_spots, s1, tab ] ))

  , generic_item( [ line_quantity, d, tab ] )

  ,set(regexp_allow_partial_matching)

    , generic_item( [ line_net_amount, n, [`CR`] ] )

  ,clear(regexp_allow_partial_matching)


  , generic_item( [ line_amount_dummy, d, tab ] )


  ,  generic_item( [ line_net_amount_dummy, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_spots, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_net_amount, n, tab ] )


  , generic_item( [ line_amount_dummy, d, tab ] )

  , generic_item( [ line_net_amount_dummy, s1, newline ] )

  
] ).



%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    
    generic_item( [ line_descr, s1, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    
    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_amount_line, [
%=======================================================================

    
    generic_item( [ line_net_amount, d, newline ] )
  
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


