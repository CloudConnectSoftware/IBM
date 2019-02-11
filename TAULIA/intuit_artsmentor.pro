%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Artsmentor, LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_artsmentor, `15 December 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(`m/d/y`).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_invoice_date
     
    , set_credit_note
                     
  %  , get_invoice_number
    
    , get_due_date

    , get_order_number
    
    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

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

    sender_name( `Artsmentor, LLC` )

   ,supplier_party( `Artsmentor, LLC` )

    %, supplier_id(`TEST01SUP`)

    , supplier_street(`1950 Spyglass Court`)

    ,supplier_city(`Tillamook`)

    ,supplier_state(`OR`)

    ,supplier_postcode(`97141`)

    ,supplier_country_code(`US`)

   ,currency( `USD` )

   , invoice_number(`Test00112192017`)
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

    , generic_horizontal_details( [ [`Date`, `:` ], invoice_date_raw, s1, newline ] )

    ,check(invoice_date_raw = DateRaw)

   ,trace( [ `Inv Date`, DateRaw ] )

   ,with( invoice, supplier_id, VendID )

   ,trace( [ `Vendor ID`, VendID ] )

  ,  check(string_string_replace( DateRaw, `DECEMBER` , `12` , DateMonthRepl ))

   , check(string_string_replace( DateMonthRepl, `,`, ``, DateStrip ))

    , trace( [ `Replaced - with / ` , DateStrip ] )
   
    , trace( [ `Replaced Month` , DateStrip])

    ,  check(strcat_list( [ VendID,`` , DateStrip,`` ], InvNew ))   

    ,  check(string_string_replace( InvNew, ` ` , `` , InvNew1 )) 

    , invoice_number(InvNew1)

    , trace( [ `Invoice Number` , invoice_number ] )  

] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

    
     q(0,20,line)

    , generic_horizontal_details( [ [`Date`, `:` ], invoice_date, date, newline ] )



      , check( invoice_date = DeliveryDate )

        , trace( [ `Delivery Date` , DeliveryDate] )

        , delivery_date(DeliveryDate)

        , trace( [ `DeliveryDate` , delivery_date ] )



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,20,line)

  , generic_horizontal_details( [ [`P`, `.`, `O`, `.`, `#` ], order_id, d, newline ] )


      , check( order_id = POnumber )

        , trace( [ `PO Number` , POnumber] )

        , po_number(POnumber)

        ,order_number(POnumber)

        , trace( [ `POnumber` , po_number] )
  


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

q(0,50,line)

,[generic_horizontal_details( [ [`Total`,  tab ],  total_invoice, d,   newline ] )

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

]

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
              
       [q10(line_descr_line), line_invoice_line ,line_descr_append_line]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


   [`DESCRIPTION`, tab, `AMOUNT` ]


   , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================


       [`Total`]


  , trace( [ `Found End line` ] )

 

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

   
    q10(generic_item( [ line_descr, s1,q10(tab) ] ))

   , generic_item( [ line_net_amount, d, newline ] )

  , q10( [ 
		 with( invoice, order_number, Item ) % This takes the first value of line_item (captured in rule 'get_line_item')

		, generic_item( [ line_buyers_order_number, Item ] ) % This stores the value in line_po for the current line
	
    ])


] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================
 
 generic_item( [ line_descr, s1, newline ] )

 
] ).

%=======================================================================
i_line_rule_cut( line_descr_append_line, [
%=======================================================================

 generic_append( [ line_descr, s1, newline ,` _ `, ``  ] )

 
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - December 7, 2017
% Mapped by - Rohini 


% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%