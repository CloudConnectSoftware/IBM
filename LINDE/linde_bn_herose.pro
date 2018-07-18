%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEROSE GMBH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_bn_herose, ` July, 11, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).


i_trace_lists.

i_user_field( line, line_net_1, `Line Net` ).

i_user_field( line, line_net_2, `Line Net 2` ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address  
  
    , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_payment_terms

    , get_delivery_note

    , get_order_number
    
    , get_total_invoices

    , get_total_invoices_1

    , get_currency

    , get_invoice_lines

    , get_invoice_lines_1

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

    sender_name( `HEROSE GMBH` )

    ,supplier_party( `HEROSE GMBH` )

   , supplier_vat_number(`DE118564125`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buyer ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bill_to_address, [
%=======================================================================

  q(0,30,line)

   , line_add_line


] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

    , or([
        read_ahead(`Linde`)
        
         ]) 

        , trace( [ `Found address`] )

        , or([

           generic_item( [ buyer_party, s1, or([ tab, newline ]) ] )

        
        ])


     , or([

         [ check(buyer_party = `Linde Gas Benelux B.V.`) ,generic_item( [ buyer_registration_number, `NL10` ] ) , supplier_id(`10038761`), supplier_party( `HEROSE GMBH` ), sender_name( `HEROSE GMBH` ), buyer_dept(`NL`)]

           ])

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  get_currency, [
%=======================================================================

      q(0,50,line)


      , invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

q0n(anything)

,`€`,  newline

,currency( `EUR` ) 

,trace( [ `currency found`] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

    q(0,100,line)

    ,generic_horizontal_details( [ [ `UniCredit`, `Bank`, `AG`, tab, generic_item( [ supplier_bank_code_raw, s1, tab ] ) , generic_item( [  supplier_bank_account_number_raw,s1, tab ] ) ], supplier_iban_raw, s1, [tab, generic_item( [ supplier_swift_code,  w, newline ] )] ] )
    
    , check( supplier_bank_account_number_raw = BankRaw )  , check(string_string_replace( BankRaw, ` `, ``, BankStrip )), supplier_bank_account_number(BankStrip), trace( [ `Bank account Number` , supplier_bank_account_number ] )
    
    , check( supplier_bank_code_raw = BankRaw2 ) , check(string_string_replace( BankRaw2, ` `, ``, BankStrip2 )), supplier_bank_code(BankStrip2) , trace( [ `Bank account Number2` , supplier_bank_code ] )

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
               
          generic_vertical_details( [ [ `Number`, `/`, `Date`,  newline ], `Number`, q(0,1), (end, 60,60), invoice_number, d, [`/`, generic_item( [ invoice_date, date, newline ] )]  ] )  

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
   

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_due_date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================
    
    q(0,135,line)

    ,or([
        
        
         generic_horizontal_details( [ [  `Sans`, `esc`, `.`, `jusqu`, `'`, `au` ], due_date, date, tab ] )

    ])

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

, or([

 generic_vertical_details( [ [ `Purchase`, `Order`, `no`, `.`, `/`, `Date`,  newline ], `Purchase`, q(0,2), (end,10,30), order_number,d, `/` ] )

])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delivery Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note, [
%=======================================================================

q(0,20,line)

, or([

  generic_vertical_details( [ [  `Delivery`, `note`, `no`, `.`, `/`, `Despatch`, `Date`,  newline ], `Delivery`, q(0,2), (end,10,30), delivery_note_number,d, `/` ] )


])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoices, [
%=======================================================================
    
    last_line

     , q(0,50,up)

    , generic_horizontal_details( [ [ `Total`, `items`, `value`, tab ], total_net, d, newline ] )

    , q(0,1,line)

    , generic_horizontal_details( [ [ `Tax`, tab, generic_item( [ default_vat_rate, d ] ), tab, dummy_net(d), tab ], total_vat, d, newline ] )

     , q(0,1,line)

    , generic_horizontal_details( [ [ `Final`, `amount`, tab,  generic_item( [ currency, w, tab ] ) ],  total_invoice, d, newline  ] )

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

            [ line_ref_line , q(0,1, line_descr_append), line_invoice_line_dummy, line_discount_line]

            , [ line_ref_line , q(0,2, line_descr_append), line_invoice_line]

            , [line_invoice_line2 , q10(line_descr_append), q10(line_descr_append)]

            , line_discount_line

            
             , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

or([

[`Item`, tab, `Material`, tab, `Description`,  newline]


])

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or([

    [`Item`, tab, `Material`, tab, `Description`,  newline]

    , [`Total`, `items`, `value`, tab]


])

  , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     generic_item( [ line_quantity,d ])

    , generic_item( [ line_quantity_uom_code, w, tab])

    , generic_item( [ line_unit_amount,d, tab ] )

    , generic_item( [ line_currency,w, tab])

    , generic_item( [ line_quantity_uom_code_dummy, w, tab])

    , generic_item( [ line_net_amount,d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_dummy, [
%=======================================================================

     generic_item( [ line_quantity_dummy,d ])

    , generic_item( [ line_quantity_uom_code, w, tab])

    , generic_item( [ line_unit_amount_dummy,d, tab ] )

    , generic_item( [ line_currency,w, tab])

    , generic_item( [ line_quantity_uom_code_dummy, w, tab])

    , generic_item( [ line_net_1,d, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_ref_line, [
%=======================================================================
	      
      generic_item([ line_reference , w, tab ])

    , generic_item([ line_descr , s1, tab ])

    , generic_append( [ line_descr,s1, newline, ` -  `, `` ] )
 
    
] ).


%=======================================================================
i_line_rule_cut( line_descr_append, [
%=======================================================================

generic_append( [ line_descr,s1, newline, ` -  `, `` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

     generic_item([ line_descr , s1, tab ])

    , generic_item( [ line_unit_amount_dummy,d, tab ] )

    , generic_item( [ line_net_amount,d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_discount_line, [
%=======================================================================

     generic_item([ line_descr_dummy , s1, tab ])

    , generic_item( [ line_unit_amount_dummy,d, [`-`, tab ] ] )

    , generic_item( [ line_unit_dummy,s1, [ tab, `-` ] ] )

    , generic_item( [ line_net_2,n, newline ] )

             
    , q10([ with( line, line_net_1 , Net1 )

    , with( line , line_net_2, Net2 )

    , trace( [ `Net line 1`, Net1 ] )

     , trace( [ `Net line 2`, Net2 ] )

     , check(sys_calculate_str_add( Net1, Net2, NetTot))

     , trace( [ `VAT Rate`, NetTot ] )
  
    ,  line_net_amount(NetTot)  ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 11,  2018
% Mapped by - Roopesh 


% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 



