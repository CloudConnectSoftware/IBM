%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interactions LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(intuit_taulia_interactions, `30 January, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( `m/d/y`). 

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_shipto_address
 
    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number
    
    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency
    
    , get_bank_accountnumber

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

    sender_name( `Interactions LLC` )

   , supplier_party( `Interactions LLC` )

   , supplier_country_code(`US`)

   , delivery_code(`US`)

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


] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`Suite`, `E`])

     , trace( [ `Found address`] )

    ,  generic_item( [ supplier_street, s1, newline ] )

] ).


%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

     generic_item( [supplier_city , s , [q10(tab), check(supplier_city(end) < -357)] ] )

     , generic_item( [supplier_city_dummy , s , [q10(tab), check(supplier_city_dummy(end) < -320)] ] )

     , generic_item( [ supplier_state, w ] )

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



] ).

%=======================================================================
i_line_rule(line_shipto_line, [
%=======================================================================

       or([
           
           read_ahead([`Bill`, `To`, tab, `Ship`, `To`])

           , read_ahead([`Bill`, `To`, `:`, tab, `Ship`, `To`])

           ] )

     , trace( [ `Found address`] )

     , generic_item( [ delivery_dummy, s1, tab ] )

     , generic_item( [ delivery_dummy1, s1, newline ] )

 

] ).

%=======================================================================
i_line_rule(line_shipto_line1, [
%=======================================================================

      generic_item( [ delivery_party_dummy, s1, tab ] )

     , generic_item( [ delivery_party, s1, newline ] )

 

] ).


%=======================================================================
i_line_rule(line_shipto_line2, [
%=======================================================================


      generic_item( [ street_dummy, s1, tab ] )

    , generic_item( [ delivery_street, s1, newline ] )
    

 

] ).


%=======================================================================
i_line_rule( line_shipto_line3, [
%=======================================================================

       generic_item( [ delivery_dummy3, s1, tab ] )
     
     , generic_item( [delivery_city , s , [q10(tab), check(delivery_city(end) < 302)] ] )

     , generic_item( [delivery_city_dummy , s , [q10(tab), check(delivery_city_dummy(end) < 326)] ] )

     , generic_item( [ delivery_state, s , [q10(tab), check(delivery_state(end) < 362)]] )

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

     q(0,10,line)

    ,  or([

      generic_horizontal_details( [ [`Invoice`, `#`, tab ], invoice_number, d, newline ] )

    , [generic_horizontal_details( [ [`Invoice`, `#`, tab ], invoice_number_raw, s1, newline ] )

        , check( invoice_number_raw = InvRaw )

    , trace( [ `Invoice Number Raw` , InvRaw ] )

    , check(string_string_replace( InvRaw, `-`, ``,NumberStrip ))
    

    , trace( [ `Stripped ` , NumberStrip ] )

    , invoice_number(NumberStrip)]

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

   , generic_horizontal_details( [ [`Invoice`, `Date`, tab ], invoice_date, date, newline ] )

   
      , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )


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

  , generic_horizontal_details( [ [`P`, `.`, `O`, `.`, `No`, `.`, tab ], po_number, d ,newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================
 
 
 q(0,50,line)

 
 ,generic_horizontal_details( [ [ `Net`, `Invoice`, tab, generic_item( [ currency, w ] ) ],  total_net, d, newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================
 
 
 q(0,50,line)

 
 ,generic_horizontal_details( [ [ `Tax`, tab, `USD` ],  total_vat, d, newline ] )


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

 ,  or([

   generic_horizontal_details( [ [ `Total`, `Invoice`, tab, `USD`],  total_invoice, d, newline ] )

 , [generic_horizontal_details( [ [ `Total`, tab, generic_item( [ currency, w ] )],  total_invoice, d, newline ] )

   , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )]

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
              
           [q10(line_descr_line), q10( line_append_line),q10( line_append_line),line_invoice_line]

           ,   [q10(line_descr_line), q10( line_append_line),q10( line_append_line),line_invoice_line1]

           ,   [q10(line_descr_line), q10( line_append_line),line_invoice_line2]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    or([


    [`Description`, tab, `Qty`, tab, `Rate`]

    , [`Description`, tab, `Amount`,  newline ]

    ] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
       [`Remit`, `Payments`, `to`]

     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     generic_append( [ line_descr, s1, tab, ` `, ` ` ] )

  , q10(generic_item( [ line_quantity, d, tab ] ))

  , or([

     generic_item( [ line_unit_amount,d, tab ] )

  , generic_item( [ line_unit_amount,d, [`%`, tab ] ] )

  ] )
 , or([

    [generic_item( [ line_net_amount_dummy, s1, newline ] )

      , check( line_net_amount_dummy = TotalRaw )

    , trace( [ `invoice_total_raw1`, TotalRaw ] )

    , check(string_string_replace( TotalRaw, `T`, ``,Totalstrip ))

    , trace( [ `Total_stripped`, Totalstrip ] )

    , line_net_amount(Totalstrip)

    , trace( [ `Invoice total captured`, line_net_amount ] )]

    ,generic_item( [ line_net_amount,d, newline ] )

    ] )
  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    generic_append( [ line_descr, s1, tab, ` `, ` ` ] )

   ,generic_item( [ line_net_amount,d, newline ] )

 
  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    generic_append( [ line_descr, s1, tab, ` `, ` ` ] )

    , [generic_item( [ line_net_amount_dummy, s1, newline ] )

      , check( line_net_amount_dummy = TotalRaw )

    , trace( [ `invoice_total_raw1`, TotalRaw ] )

    , check(string_string_replace( TotalRaw, `T`, ``,Totalstrip ))

    , trace( [ `Total_stripped`, Totalstrip ] )

    , line_net_amount(Totalstrip)

    , trace( [ `Invoice total captured`, line_net_amount ] )]

 
  
] ).


%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr, s1, newline ] )

 
  
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` ` ] )
 
  
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - January 30, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   - 
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
