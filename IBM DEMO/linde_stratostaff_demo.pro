%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STRATOSTAFF(PTY) LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_stratostaff_demo, `1 August 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.
 
i_pdf_parameter( dont_tokenise_on_font_change, 1 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_bank_accountnumber
                     
    , get_invoice_number
    
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

    sender_name( `STRATOSTAFF(PTY) LTD` )

   ,supplier_vat_number(`4290116112`)

   ,supplier_party(`STRATOSTAFF(PTY) LTD`)

   ,currency( `ZAR` )

   ,buyer_registration_number(`ZA02`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [
%=======================================================================

   q(0,1,line)

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

      read_ahead(`FIRST`)

    , trace( [ `Found address`] )

    ,  generic_item( [ supplier_address_line, s1 , newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================

     generic_item( [ supplier_address_line, s1 , tab ] )

   , generic_item( [ supplier_party_dummy, s1, newline ] )

] ).     

%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================

    generic_item( [ supplier_party_dummy, s1, newline ] )

] ).   

%=======================================================================
i_line_rule( line_add_line_4, [
%=======================================================================

     generic_item( [ supplier_address_line, s1 , tab ] )

   , generic_item( [ supplier_party_dummy, s1, newline ] )

] ).   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_bank_accountnumber, [
%=======================================================================

    q(0,30,line)
    
    , generic_horizontal_details( [ [ `Remit`, `payment`, `to`, `Nedbank`, `,`, `Account` ], supplier_bank_account_number_raw, w, newline ] )

    ,check(supplier_bank_account_number_raw=AccRaw)

    ,check(strip_string2_from_string1( AccRaw, `-`, AccNew ))

    ,supplier_bank_account_number(AccNew), trace( [ `Supplier account number without special characters`, supplier_bank_account_number] )
   
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,15,line)

    ,generic_horizontal_details( [ [ `Invoice`, `Number`, `:`, tab ],  invoice_number, w, newline ] )

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

    ,generic_horizontal_details( [ [ `Date`, `:`, tab ],  invoice_date, date, newline ] )

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

    ,generic_horizontal_details( [ [ `Reference`, `:` ], order_number, w, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

   q(0,30,line)

  ,[generic_horizontal_details( [ [ `Subtotal`, `before`, `Vat`, tab ],  total_net_raw, s1, newline ] )
  
    , check( total_net_raw = NetRaw )

    , trace( [ `invoice_net_raw1`, NetRaw ] )

    , check(string_string_replace( NetRaw, ` `, ``,Netstrip ))

    , trace( [ `Net_stripped`, Netstrip ] )

    , total_net(Netstrip)

    , trace( [ `Invoice net captured`, total_net ] )]

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================

   last_line

   ,q(0,10,up)

   ,[generic_horizontal_details( [ [`Vat`, tab ],  total_vat_raw, s1, newline ] )

    , check( total_vat_raw = VatRaw )

    , trace( [ `invoice_vat_raw1`, VatRaw ] )

    , check(string_string_replace( VatRaw, ` `, ``,Vatstrip ))

    , trace( [ `Vat_stripped`, Vatstrip ] )

    , total_vat(Vatstrip)

    , trace( [ `Invoice Vat captured`, total_vat ] )]

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

   q(0,30,line)

   ,[generic_horizontal_details( [ [`Total`, `Amount`, tab ],  total_invoice_raw, s1, newline ] )
    
    , check( total_invoice_raw = TotalRaw )

    , trace( [ `invoice_total_raw1`, TotalRaw ] )

    , check(string_string_replace( TotalRaw, ` `, ``,Totalstrip ))

    , trace( [ `Total_stripped`, Totalstrip ] )

    , total_invoice(Totalstrip)

    , trace( [ `Invoice total captured`, total_invoice ] )]

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [
              
              line_invoice_line

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

[`Name`, `&`, `Employee`, `Number`]

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

  
    [`Remit`, `payment`, `to`, `Nedbank` ]

  , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item( [ line_name_number, s1, tab ] )

    , generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )



    , [ generic_item( [ line_net_raw, s1, tab ] )

    , check( line_net_raw = LineNetRaw )

    , trace( [ `line_net_raw1`, LineNetRaw ] )

    , check(string_string_replace( LineNetRaw, ` `, ``,LineNetstrip ))

    , trace( [ `LineNet_stripped`, LineNetstrip ] )

    , line_net_amount(LineNetstrip)

    , trace( [ `Line net captured`, line_net_amount ] )]



    , [ generic_item( [ line_vat_raw, s1, tab ] )

    , check( line_vat_raw = LineVatRaw )

    , trace( [ `line_vat_raw1`, LineVatRaw ] )

    , check(string_string_replace( LineVatRaw, ` `, ``,LineVatstrip ))

    , trace( [ `LineVat_stripped`, LineVatstrip ] )

    , line_vat_amount(LineVatstrip)

    , trace( [ `Line Vat captured`, line_vat_amount] )]



    , [ generic_item( [ line_invoice_raw, s1, newline ] )

    , check( line_invoice_raw = LineTotalRaw )

    , trace( [ `Lineinvoice_total_raw1`, LineTotalRaw ] )

    , check(string_string_replace( LineTotalRaw, ` `, ``,LineTotalstrip ))

    , trace( [ `LineTotal_stripped`, LineTotalstrip ] )

    , line_total_amount(LineTotalstrip)

    , trace( [ `Line total captured`, line_total_amount ] )]


] ).




