%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manpower Group US Inc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_manpower, `06 December 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_bank_accountnumber
 
    , set_credit_note
                     
    %, get_invoice_number
    
    , get_invoice_date

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

    sender_name( `Manpower Group US Inc` )

   % ,supplier_city(`Chicago`)
    
    ,supplier_country_code(`US`)

   % ,supplier_postcode(`60673`)
    
  %  ,supplier_state(`IL`)
    
  %  ,supplier_street(`29973 Network Place`)
   

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================
  
     q(0,10,line)

   , line_add_line

   , q(0,1,line)

   , line_add_line_2

   , q(0,1,line)

   , line_add_line_3

   , q(0,1,line)

   , line_add_line_4

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`ManpowerGroup`, `US`, `Inc`])

     , trace( [ `Found address`] )

     , generic_item( [ supplier_party, s1, tab ] )

     , generic_item( [ supplier_dummy, s1, tab ] )

     , generic_item( [ supplier_dummy1, s1, newline ] )


] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

       generic_item( [ supplier_street, s1, tab ] )

     , generic_item( [ supplier_dummy2, s1, tab ] )

     , generic_item( [ supplier_dummy3, s1, newline ] )


] ).

%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================
 
     generic_item( [supplier_city , s , [q10(tab), check(supplier_city(end) < -282)] ] )

     , generic_item( [ supplier_state, w ] )

     , generic_item( [ supplier_postcode, s1, newline ] )


   
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
  
  , generic_horizontal_details( [ [`Routing`, `Number`, `:` ], bank_number, d, newline ] )

  , q(0,1,line)
  
  , generic_horizontal_details( [ [ `Account`, `:`, tab ], bank_account_number, d, tab ] )

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

    , generic_horizontal_details( [ [`Invoice`, `Number`, tab ], invoice_number,d, newline ] )

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

   , generic_horizontal_details( [ [ `Invoice`, `Date`, tab ], invoice_date, date, newline ] )

   
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

     q(0,20,line)

  , generic_horizontal_details( [ [`Due`, `Date`, tab ], due_date, date, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

q(0,20,line)

,[generic_horizontal_details( [ [`Amount`, `Due`, tab, `$`],  total_invoice, d, newline ] )

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

]

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUFRRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     q(0,20,line)

  , generic_horizontal_details( [ [`Currency`, tab ], currency, w, newline ] )

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

  , generic_horizontal_details( [ [`Purchase`, `Order`, `Number`, `:`], po_number, d, newline ] )

  
     % , check( order_id = POnumber )

      %  , trace( [ `PO Number` , POnumber] )

       % , po_number(POnumber)

        %,order_number(POnumber)

        %, trace( [ `POnumber` , po_number] )
  

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

        , line_invoice_line2

        , line_invoice_line3

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
   or([

    [`Employee`, `Name`, tab, `Fee`, `Type`, tab ]

    , [`Fee`, `Type`, tab, `Fee`, `Description`, tab ]

    ] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 

   or([

       [`Sub`, `Total`, tab]

       , [`SubTotal`, tab ]
       
       ,[`ManpowerGroup`, `US`, `Inc`]

] )


     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

   

    generic_item( [ line_descr, s1, tab ] )

  , generic_append( [ line_descr, s1, q10(tab) , ` , `, ` `  ] )

  , generic_item( [ line_descr_type,s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  , q10( [ 
		 with( invoice, order_number, Item ) % This takes the first value of line_item (captured in rule 'get_line_item')

		, generic_item( [ line_buyers_order_number, Item ] ) % This stores the value in line_po for the current line
	
    ])

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

   

    generic_item( [ line_descr, s1, tab ] )

  , generic_append( [ line_descr, s1, q10(tab) , ` , `, ` `  ] )

  , generic_item( [ line_descr_type, s1, tab ] )

  , generic_item( [ line_billing, s1, tab ] )

  , generic_item( [ line_quantity, d, [ tab, `$`] ] )

  , generic_item( [ line_unit_amount, d, [ tab, `$`] ] )

  , generic_item( [ line_net_amount, d, newline ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

   

    generic_item( [ line_descr, s1, tab ] )

  , q10(generic_append( [ line_descr, s1, q10(tab) , ` , `, ` `  ] ))

  , generic_item( [ line_descr_type, s1, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

   

    generic_item( [ line_descr, s1, tab ] )

  , generic_append( [ line_descr, s1, q10(tab) , ` , `, ` `  ] )

  , generic_item( [ line_buyers_order_number, d, tab ] )

  , generic_item( [ line_dummy, s1, tab ] )

  
  , generic_item( [ line_unit_amount, d, tab ] )

  , generic_item( [ line_quantity, d, tab ] )

  , generic_item( [ line_billing, s1, [tab, `$`] ] )


  , generic_item( [ line_net_amount, d, newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - December 6, 2017
% Mapped by - Rohini 

% Updated on   - December 18, 2017
% Updated by   - Rohini
% Changes made - Supplier Address mapped 


% Updated on   - Feb 10, 2017
% Updated by   - Rohini
% Changes made - New Line format mapped


% Updated on   - 
% Updated by   -
% Changes made - 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
