%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - BPR Medical Ltd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_es_bpr_medical, `06 July, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


i_pdf_parameter( newline, 15) .

i_pdf_parameter( x_tolerance_100, 100 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    get_supplier_detail

    , get_bill_to_address

    , get_supplier_vat_number

    , get_currency 

    , get_bank_accountnumber

    , get_bank_accountnumber_1

    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date
    
    , get_payment_terms

    , get_delivery_note

    , get_order_number

    , get_total_net

    , get_total_vat
    
    , get_invoice_discount

    , get_total_invoice

    , get_vat_rate

    , get_freight_lne

    , get_invoice_lines

    , get_discount_line

   



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail,  [
%=======================================================================

    sender_name( `BPR Medical Ltd` )

    ,supplier_party( `BPR Medical Ltd` )

    ,supplier_vat_number(`737511631`)

    , buyer_dept(`ES`)

    , currency( `EUR` )

           

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buyer ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bill_to_address, [
%=======================================================================

  q(0,15,line)

   , line_add_line


] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

    , or([
        read_ahead(`Abello`)

       ,read_ahead(`ABELLÓ`) 

        , read_ahead(`Linde`)
    ]) 

    , trace( [ `Found address`] )

    , or([

      generic_item( [ buyer_party, s1, newline ] )

     , generic_item( [ buyer_party, s1, tab ] )

     , generic_item( [ buyer_party, s, [q10(tab), check(buyer_party(end) < -257)] ] )

    ])

     , or([

          [ check(buyer_party = `ABELLO LINDE SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE,S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `Abello Linde, S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `LINDE SPAIN`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `Linde Medicinal`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ] 

        , [ check(buyer_party = `INO THERAPEUTICS`) ,generic_item( [ buyer_registration_number, `ES30` ] ) ] 

        , [ check(buyer_party = `LINDE MEDICA S.L.U.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]

        , [ check(buyer_party = `LINDE MEDICINAL S.L`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MÉDICA S.L.U.`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA, S.L. UNIPERSONAL`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]


        ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================
   
   last_line

    , q(0,100,up)

    , generic_vertical_details( [ [  `HSBC`, `MANSFIELD`,  newline ], `HSBC`, q(0,1), (start,20, 100), supplier_bank_account_number_raw, s, newline ] )

    
    , check( supplier_bank_account_number_raw = ACCRaw )

    , trace( [ `ACC number raw` , ACCRaw ] )

    , check(string_string_replace( ACCRaw, ` `, ``, ACCStrip ))

    , trace( [ `ACc Stripped Space` , ACCStrip ] )

    , supplier_bank_account_number(ACCStrip)

    , q(0,1,line)

    , generic_horizontal_details( [ [ `IBAN`], supplier_iban_raw, s1, newline ] )

    , check( supplier_iban_raw = BankRaw )

    , trace( [ `IBANnumber raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `IBAN Stripped Space` , BankStrip ] )

    , supplier_iban(BankStrip)

    , q(0,1,line)

    , generic_horizontal_details( [ [ `BIC` ], supplier_bank_code, s, newline] )

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Invoice Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

    q(0,80,line)

    , generic_horizontal_details( [ [ `INVOICE`, `NO`, `:` ], invoice_number_raw, s, newline ] )

     , check( invoice_number_raw = INVRaw )

    , trace( [ `IN V number raw` , INVRaw ] )

    , check(string_string_replace( INVRaw, `,`, ``, INVStrip ))

    , trace( [ `IBAN Stripped / ` , INVStrip ] )

    , invoice_number(INVStrip)

 ] ).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get inv Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

    q(0,80,line)

    , generic_horizontal_details( [ [ `INVOICE`, `DATE`, `:`], invoice_date, date, newline ] )

 ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Order no
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q(0,80,line)

    , generic_horizontal_details( [ [`CUSTOMER`, `ORDER`, `NO`, `:` ], order_number, d, newline ] )

 ] ).


 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get payment_term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_payment_terms, [
%=======================================================================

    q(0,80,line)

    , generic_horizontal_details( [ [`PAYMENT`, `TERMS`], payment_terms, d  ] )

 ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL Invocie NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================
    
    last_line
    
    , q(0,150,up)

    , generic_horizontal_details( [ [  `Total`, `Net`, `Amount`, tab ], total_net_1, d, newline] )

    , q(0,1,line)
    
    , or([

     generic_horizontal_details( [ [  `Carriage`, `Net`, tab ], line_carriage, d, newline] )

    , generic_vertical_details( [ [ `Carriage`, `Net`,  newline ], `Net`, q(0,2, up), (end, 5, 450), line_carriage, d, newline ] )

    ])

    
    , check( total_net_1 = NET1 )

    , check( line_carriage = NET2 )

    , check(sys_calculate_str_add( NET1, NET2 , NetTot))

    , total_net(NetTot)

    , trace( [ `Total net` , total_net] )

] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL Invocie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================
    
    last_line
    
    , q(0,150,up)
    
    , generic_horizontal_details( [ [ `Total`, `in`, currency_dummy(w), tab ],total_invoice, d, newline] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carriage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_freight_lne, [
%=======================================================================
    
    last_line
    
    , q(0,150,up)

    , or([

     generic_horizontal_details( [ [  `Carriage`, `Net`, tab ], line_net_amount, d, newline] )

    , generic_vertical_details( [ [ `Carriage`, `Net`,  newline ], `Net`, q(0,2, up), (end, 5, 450), line_net_amount, d, newline ] )

    ])
    
    , generic_item( [ line_descr, `Carriage Net` ] )

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
       
     
    
      line_invoice_line, line_invoice_append
       
    

          
       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[ `Part`, `No`, tab, `Quantity`, tab, `Details`, tab, `Unit`, `Price`, tab ]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

   [ `Total`, `Net`, `Amount`, tab ]

 ])

  , trace( [ `Found END line` ] )

] ).





%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     generic_item( [ line_item, s, tab ] )
    
    , generic_item( [ line_quantity_dummy, d, tab ] )

    , generic_item( [ line_descr, s1, tab ] )
    
    , generic_item( [ line_unit_amount_dummy, d, tab ] )

    , generic_item( [line_net_amount, d,  newline  ] )

    ] ).


%=======================================================================
i_line_rule_cut( line_invoice_append, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` ` ] ), ``
    
    ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 06 , 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made -

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%