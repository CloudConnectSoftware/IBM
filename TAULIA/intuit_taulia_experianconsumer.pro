%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ConsumerInfo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( intuit_taulia_consumerinfo, `11 Feb, 2018` ).

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

    sender_name( `Experian` )

   , supplier_party( `Experian` )
    
   , buyer_dept(`N/A`)

   , buyer_registration_number(`N/A`)

 , supplier_country_code(`US`)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================
  
     q(0,6,line)

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

       read_ahead([`475`, `Anton`, `Blvd` ])


     , trace( [ `Found address`] )

     ,   generic_item( [ supplier_street, s1, tab ] )

    , generic_item( [ supplier_street_dummy, s1, tab ] )
    
    , generic_item( [ supplier_street_dummy1, s1, newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

        or([
            
            generic_item( [supplier_city , s , [q10(tab), check(supplier_city(end) < -374)] ] )

            , generic_item( [supplier_city , s , [q10(tab), check(supplier_city(end) < -304)] ] )

         ] )

    , or([

       generic_item( [supplier_dummy , s , [q10(tab), check(supplier_dummy(end) < -279)] ] )

     , generic_item( [supplier_dummy , s , [q10(tab), check(supplier_dummy(end) < -356)] ] )

       ] )

     , generic_item( [supplier_state , w ] )

     ,or([

          generic_item( [ supplier_postcode, d, newline ] )

     , generic_item( [ supplier_postcode, d, tab ] )

     ] )

     , q10(generic_item( [ supplier_postcode_dummy, s1, newline ] ))


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS  ALTERNATIVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address1, [
%=======================================================================
  
     q(0,6,line)

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

       read_ahead([`Document`, `date`, `:`, tab])


     , trace( [ `Found address`] )

     ,   generic_item( [ supplier_street_dummy, s1, tab ] )

    , generic_item( [ supplier_street_dummy1, s1, tab ] )
    
    , generic_item( [ supplier_street, s1, newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================


        generic_item( [ supplier_street_dummy2, s1, tab ] )

    , generic_item( [ supplier_street_dummy3, s1, tab ] )
    
    , generic_item( [ supplier_city, s1, newline ] )

] ).


%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================


        generic_item( [ supplier_street_dummy4, s1, tab ] )
    
    , generic_item( [ supplier_state, w, newline ] )

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


    , [`CREDIT`, `NOTE`]

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

      ,or([

          generic_horizontal_details( [ [ `Invoice`, `number`, `:`, tab ],invoice_number, s1, newline ] )

     , generic_horizontal_details( [ [ `INVOICE`, `:` ],invoice_number, d, newline ] )

     ,  [generic_horizontal_details( [ [  `Credit`, `note`, `number`, `:`, tab ],invoice_number_raw, s1, tab ] )

         , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, `_`, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

    , trace( [ `Invoice Number` , invoice_number ] )  ]


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

     ,or([
 
      generic_horizontal_details( [ [ `Invoice`, `date`, `:`, tab ], invoice_date, date, newline ] )

     , generic_horizontal_details( [ [  tab, `DATE`, `:` ], invoice_date, date, newline ] )

      , generic_horizontal_details( [ [  `Document`, `date`, `:`, tab ], invoice_date, date, tab ] )


     ] )

          , check( invoice_date = Deliverydate )

        , trace( [ `Delivery date` , Deliverydate] )

        , delivery_date(Deliverydate)

        , trace( [ `Delivery Date` , delivery_date ] )




] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DELIVERY DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_date, [
%=======================================================================

     q(0,25,line)

     ,or([
 
      generic_horizontal_details( [ [ `Invoice`, `date`, `:`, tab ], delivery_date, date, newline ] )

     , generic_horizontal_details( [ [  tab, `DATE`, `:` ], delivery_date, date, newline ] )


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

      ,or([

      
      generic_horizontal_details( [ [`Due`, `date`, `:`, tab ], due_date, date, newline ] )

     , generic_horizontal_details( [ [`DUE`, `DATE`, `:` ], due_date, date, tab ] )

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

     , generic_horizontal_details( [ [ tab, `PO`, `:` ], po_number, d, [`I`,  newline ] ] )
   

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================
 
   q(0,300,line)

  , or([
 
  generic_horizontal_details( [ [`Total`, `charge`, tab ],  total_net, d, newline ] )

 , generic_horizontal_details( [ [`Subtotal`, tab, `$` ],  total_net, d, newline ] )

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================
 
 
   q(0,200,line)
 
 , or([

  generic_horizontal_details( [ [ `TOTAL`, `TAXES`, tab, `$` ],  total_vat, d, newline ] )

 ,generic_horizontal_details( [ [ `Sales`, `Tax`, tab, `$` ],  total_vat, d, newline ] )

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


   q(0,200,line)

 , or([
 
  generic_horizontal_details( [ [`TOTAL`, `CHARGES`, tab, `$`],  total_invoice, d, newline ] )

 ,generic_horizontal_details( [ [ `TOTAL`, tab, `$`],  total_invoice, d, newline ] )

 , generic_horizontal_details( [ [`TOTAL`, `CHARGES`, tab, `$` ],  total_invoice, d, tab ] )

 ,generic_horizontal_details( [ [`Total`, `Payable`, `(`, `USD`, `)`, tab ],  total_invoice, d, newline ] )

 ] )

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

 , q(0,100,up)
 

,invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

q0n(anything)

,or([

 [`TOTAL`, `CHARGES`, tab, `$`]

,[`TOTAL`, tab, `$`]

] )

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

          , line_invoice_line2

          , line_invoice_line3

          , line_invoice_line1

          , line_credit_line

        


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

        
        or([
            
            [`UNITS`, tab, `REPORT`, `TYPES`, tab ]

            , [`QUANTITY`, tab, `CODE`, tab, `DESCRIPTION`]

            , [dummy_num(d), `TOTAL`, `CREDIT`, `PROFILES`]

            , [`OTHER`, `CHARGES`, `/`, `CREDITS`]

            , [`SUMMARY`, `OF`, `TAXES`]
            
            ,[`DESCRIPTIONS`, tab, `Price`, `/`, `Rate`, tab, `Quantity`]

            , [`Product`, `Description`, tab, `Quantity`, tab ]
] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

     or([

     [`Subtotal`, tab, `$` ]

    , [dummy_num(d), `TOTAL`, `CREDIT`, `PROFILES`]

    , [dummy_num2(d), tab, `TOTAL`, `CREDIT`, `PROFILES`]

    , [dummy_num1(d), `TOTAL`, `OPTIONAL`, `SERVICES`, tab ]

    , [`TOTAL`, `OTHER`, `CHARGES`, `/`, `CREDITS`]

    , [`TOTAL`, `CHARGES`, tab, `$`]

    , [`Total`, `charge`, `analysis`, tab, `Value`]

     ] )

     , trace( [ `Found End line` ] )

] ).



%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_unit_amount, d, [`/`] ] )

  , generic_item( [ line_amount_dummy, w, tab ] )

  , generic_item( [ line_quantity_dummy, d, tab ] )

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).




%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    or([

    generic_item( [ line_descr, s1, [tab, `$`] ] )

    , generic_item( [ line_descr, s1, tab ] )

    ] )

   , q10( generic_item( [ line_descr_dummy, s1, [tab, `$`] ] ))

  , generic_item( [ line_net_amount, d, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    generic_item( [ line_descr_dummy, d, tab ] )

  , generic_item( [ line_descr_dummy1, s1, tab ] )

    , generic_item( [ line_descr, s1, [tab, `$`] ] )

   , generic_item( [ line_net_amount, d, newline ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================


    generic_item( [ line_descr, s1, [tab, `$`] ] )

  , generic_item( [ line_net_amount, d, tab ] )

  , generic_item( [ line_dummy, d, newline ] )

  
] ).

%=======================================================================
i_line_rule_cut( line_credit_line, [
%=======================================================================

    
    generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity_dummy, d, tab ] )

  , generic_item( [ line_quantity_uom_code, w, [tab, `-`] ] )

  , generic_item( [ line_net_amount, d,  [tab, `-`] ] )

  , generic_item( [ line_total_amount, d, newline ] )

  
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