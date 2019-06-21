%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DIMENSION DATA NORTH AMERICA, INC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_taulia_dimensiondata, `9 Feb, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_op_param( us_invoice, _, _, _, _).

i_format_postcode( X, X ).

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

  sender_name( `DIMENSION DATA NORTH AMERICA INC` )

  , supplier_party(`DIMENSION DATA NORTH AMERICA INC`)
    
  , supplier_country_code(`US`)

  , supplier_registration_number(`jacqueline.moore@dimensiondata.com`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================
    
    last_line
  
  , q(0,5,up)

   , line_adddress_line

] ).

%=======================================================================
i_line_rule( line_adddress_line, [
%=======================================================================

       read_ahead([ `DIMENSION` ])

     , trace( [ `Found address`] )

     , generic_item( [ supplier_party_dummy, s, `;` ] )

     , generic_item( [ supplier_street, s, `;` ] )

     , generic_item( [ supplier_address_line, s, `;` ] )

     , generic_item( [supplier_city , s , `,` ] )

     , generic_item( [supplier_state , w  ] )

     , generic_item( [ supplier_postcode, d, newline ] )

   
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHIP TO ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_shipto_address, [
%=======================================================================
  
     q(0,20,line)

   , line_shipto_line

   , q(0,1,line)

   , line_shipto_line1

   , q(0,1,line)

   , line_shipto_line2

   , q(0,1,line)

   , line_shipto_line3

   , q(0,1,line)

   , line_shipto_line4


] ).

%=======================================================================
i_line_rule( line_shipto_line, [
%=======================================================================

       read_ahead([`BILL`, `TO`, `:`, tab, `SHIP`, `TO` ])

     , trace( [ `Found address`] )

     , generic_item( [ shipto_dummy, s1, tab ] )

     , generic_item( [ shipto_dummy1, s1, tab ] )

] ).

%=======================================================================
i_line_rule( line_shipto_line1, [
%=======================================================================

      generic_item( [ shipto__dummy, s1, tab ] )

     , generic_item( [ buyer_contact, s1, tab ] )

] ).

%=======================================================================
i_line_rule( line_shipto_line2, [
%=======================================================================

       generic_item( [ shipto__dummy1, s1, tab ] )
       
     , generic_item( [ delivery_party, s1, newline ] )

] ).

%=======================================================================
i_line_rule( line_shipto_line3, [
%=======================================================================

       generic_item( [ shipto__dummy1, s1, tab ] )
     
     , generic_item( [ delivery_street, s1, newline ] )

] ).


%=======================================================================
i_line_rule( line_shipto_line4, [
%=======================================================================

     or([
               
      generic_item( [delivery_city , w   ] )
   
    ,  generic_item( [delivery_city , s , [q10(tab), check(delivery_city(end) < 123)] ] )

     ] )

      , generic_item( [ delivery_state, w ] )

     , generic_item( [ delivery_country_code, d, tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================
  
   last_line

  , q(0,50,up)

  , generic_horizontal_details( [ [`Wire`, `Transfers`, `:`, `HSBC`, `BANK`, `USA`, `,`, `ACCT`, generic_item( [ bank_account_number, s] ), `,`, `ABA`, generic_item( [ bank_number, s ] ), `(`, `Domestic`, `)`, `,`, `SWIFT`], swift_bic_number, s, [`(`, `International`, `)`,  newline ] ] )

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
       
       % generic_vertical_details( [ [ `Invoice`,  newline ], `Invoice`, q(0,2), (start,100,100 ), invoice_number, d, newline ] )

        generic_horizontal_details( [ [`Invoice`, tab], invoice_number, d, tab ] )

     ])

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
       
       generic_horizontal_details( [ [`Invoice`, `DATE`, tab ],  invoice_date, date, tab ] )

       , generic_vertical_details( [ [`DATE`, tab ], `DATE`, q(0,1), (start,100,300 ), invoice_date, date, tab ] )

     ])  
   
      , check( invoice_date = Deliverydate )

      , trace( [ `Delivery date` , Deliverydate] )

      , delivery_date(Deliverydate)

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

     , generic_vertical_details( [ [`DUE`, `DATE`, tab ], `DATE`, q(0,1), (start,100,300 ), due_date, date, tab ] )

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

     , generic_vertical_details( [ [`PURCHASE`, `ORDER` ], `PURCHASE`, q(0,1), (start,100,300 ), po_number,d, newline ] )
   
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
 
 ,q(0,50,up)
 
 , or([

   generic_horizontal_details( [ [ `Total`, `Excl`, `.`, tab ], total_net, d, newline ] )
   
  ,  generic_vertical_details( [ [ `UNIT`, `TOTAL` ], `TOTAL`, q(0,1), (start,10,50), total_net, d, tab ] )

 ])

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
 
 ,q(0,50,up)
 
 ,generic_vertical_details( [ [ `TAX`, `TOTAL` ], `TOTAL`, q(0,1), (start,100,200), total_vat, d, tab ] )

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
 
 ,q(0,50,up)

 , or([

   generic_horizontal_details( [ [ `Total` ,tab	,	`USD` 	], total_invoice, d, newline ] )
   
 ,generic_vertical_details( [ [ `GRAND`, `TOTAL` ], `TOTAL`, q(0,1), (start,300,400), total_invoice, d, newline ] )

 ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

 last_line
 
 ,q(0,50,up)

, or([

 generic_horizontal_details( [ [ `Total`, `:` ], currency, w, tab ] )

  , generic_horizontal_details( [ [ `Currency`, `:` ], currency, w, newline ] )

])

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
              
          [line_invoice_line,q10(line_append_line), q10(line_append_line), q10(line_append_line),q10(line_append_line)]

        , [ line_invoice_line_1, line_descr_line1]


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

  or([      
        [`DESCRIPTION`, tab, `PO`, tab, `Back`]

        , [`Item`,  `code`, tab, `Qty`]

    ])


    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

     or([

     [ `SPECIAL`, `INSTRUCTIONS`, tab ]

     , [`Tax`, `Summary`, `by`, `Tax`, `Name`]

     ,   [`Item`,  `code`, tab, `Qty`]

     ] )

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity_dummy, d, tab ] )

  , generic_item( [ line_quantity_dummy1, d, tab ] )

  , generic_item( [ line_quantity_dummy2, d, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
    , q10([	% LINE VAT Rate Calculation
  
     with( invoice , total_vat , VAT )

    , with( invoice , total_net , Net )

    , trace( [ `vat tot`, VAT ] )

    , trace( [ `sub total`, Net ] )

    , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

    , trace( [ `VAT Rate`, VAT_RATE ] )
  
    , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

    , generic_item( [ line_vat_rate , VAT_PERCENT ] )

    ])

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

    generic_item( [ line_order_line_number, d, tab ] )

  , generic_item( [ line_item, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_quantity_uom_code, w, tab ] )

  , generic_item( [ line_period, s1, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
    , q10([	% LINE VAT Rate Calculation
  
     with( invoice , total_vat , VAT )

    , with( invoice , total_net , Net )

    , trace( [ `vat tot`, VAT ] )

    , trace( [ `sub total`, Net ] )

    , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

    , trace( [ `VAT Rate`, VAT_RATE ] )
  
    , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

    , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])
       
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_vat_amount, d, newline ] )
  
] ).

%=======================================================================
i_line_rule_cut( line_descr_line1, [
%=======================================================================

    generic_item( [ line_descr, s1, newline ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ``, ` `  ] )

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - Feb 9, 2018
% Mapped by - Rohini 

% Updated on   - Feb 18, 2019
% Updated by   - Rohini
% Changes made - Ship to


% Updated on   - March 11, 2019
% Updated by   - Rohini
% Changes made - Supplier Registration number and  pdf parameter for Postcode

% Updated on   - June 21, 2019
% Updated by   - Thejaswi
% Changes made - Supplier Name updated as per Oracle (Data provided by Gajanan)

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%