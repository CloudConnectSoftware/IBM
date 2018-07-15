%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linde AG, Linde Gas Division
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_fr_lindegas, `11 Oct 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

    , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number

    , get_delivery_note_number
    
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

    sender_name( `Linde AG, Linde Gas Division` )

   , supplier_party( `Linde AG, Linde Gas Division` )

   , supplier_vat_number(`DE113822613`)

   , set(reverse_punctuation_in_numbers)

   , buyer_dept(`FR`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
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
        
        , read_ahead(`LINDE`)       
    ] ) 

    , trace( [ `Found address`] )

    , or([

          generic_item( [ buyer_party, s1, newline ] )

          , generic_item( [ buyer_party, s1, tab ] )
        
    ])


    , or([

        [ check(buyer_party = `Linde France SA`) ,generic_item( [ buyer_registration_number, `FR10` ] ) ] 

        , [ check(buyer_party = `LINDE HOMECARE FRANCE SAS`) ,generic_item( [ buyer_registration_number, `FR30` ] ) ]

        , [ check(buyer_party = `Linde Gas Benelux B.V.`), generic_item( [ buyer_registration_number, `NL10` ] ), supplier_id(`21002223`), buyer_dept(`NL`)  ] 

   

     
    ])

]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

     q(0,150,line)

    , generic_horizontal_details( [ [`Bank`, `Code`, generic_item( [ supplier_bank_cod, s ] ), `Account` ],  supplier_bank_account_no, s1, newline ] )

    , [check(supplier_bank_cod = Scode)  , check(strip_string2_from_string1( Scode, ` `, ScodeNew ))

    , supplier_bank_code(ScodeNew) , trace( [ `Bank code new FORMAT`, supplier_bank_code ] )]

    , [check(supplier_bank_account_no = Sban)  , check(strip_string2_from_string1( Sban, ` `, SbanNew ))

    , supplier_bank_account_number(SbanNew)    , trace( [ `Bank account new FORMAT`, supplier_bank_account_number ] )]

    , q(0,1,line)

    , generic_horizontal_details( [ [`IBAN` ],  supplier_iban, s1, newline ] )

    , q(0,1,line)

    , generic_horizontal_details( [ [`SWIFT`, `-`, `BIC` ],  swift_raw, s1, tab ] )

    , [check(swift_raw = Swcode)  , check(strip_string2_from_string1( Swcode, ` `, SwcodeNew ))

    , supplier_swift_code(SwcodeNew) , trace( [ `Bank swift new FORMAT`, supplier_swift_code ] )]

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

    , generic_vertical_details( [ [`Rechnungsnr`, `.`, `/`, `Invoice`, `No`], `Rechnungsnr`, q(0,1), (start,10,50), invoice_number_raw, s1, tab ] )

    , check( invoice_number_raw = InvRaw )

    , trace( [ `Invoice Number Raw` , InvRaw ] )

    , check(string_string_replace( InvRaw, ` `, ``,NumberStrip1 ))
    
    , trace( [ `Stripped1 ` , NumberStrip1 ] )

    , invoice_number(NumberStrip1)

    , trace( [ `Invoice Number New` , invoice_number ] )

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

    , generic_vertical_details( [ [`Datum`, `/`, `Date`, tab ], `Date`, q(0,1), (start,100,300), invoice_date, date, tab ] )



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

     q(0,150,line)

    , generic_horizontal_details( [ [ `Up`, `to` ],  due_date, date, [`without`, `deduction`] ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

     q(0,100,line)

    ,or([
        generic_horizontal_details( [ [`Ihre`, `Bestellnummer`, `:`, tab ], order_number, d, `vom` ] )

        , find_order_number
    
   ])

] ).
 

%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([

        generic_item( [ order_number , [ begin, q(dec("8"),1,1) , q(dec("1"),1,1) , q(dec,8,8) , end ] ] )

        , generic_item( [ order_number , [ begin, q(dec("9"),1,1) , q(dec("1"),1,1) , q(dec,8,8) , end ] ] )

        , generic_item( [ order_number , [ begin, q(dec("9"),1,1) , q(dec("0"),1,1) , q(dec,8,10) , end ] ] )

    ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delivery Note Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_number, [
%=======================================================================

     q(0,100,line)

    ,generic_horizontal_details( [ [`Delivery`, `Note`, `No`, `.`, `:` ], delivery_note_number, d, dummy_word(w) ] )



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    last_line

   , q(0,100,up)

    , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [`Nettobetrag`, `/`, `Net`, `Amount`, tab, `(`, dummy_num(w), `)`, tab ],  total_net, d, newline ] )

   , clear(regexp_cross_word_boundaries)

     , clear(reverse_punctuation_in_numbers)

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
    
   , q(0,100,up)

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)

   , generic_horizontal_details( [ [`MwSt`, `/`, `VAT`, `0`, `%`, tab, `(`, dummy_num1(w), `)`, tab ],  total_vat, d, [`*`,  newline ] ] )

   , clear(regexp_cross_word_boundaries)

   , clear(reverse_punctuation_in_numbers)
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

    last_line
   , q(0,100,up)

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)

   , generic_horizontal_details( [ [`Rechnungsbetrag`, `/`, `Invoice`, `Amount`, `(`,generic_item( [ currency, w ] ), `)`, tab ],  total_invoice, d, newline ] )

   , clear(regexp_cross_word_boundaries)

   , clear(reverse_punctuation_in_numbers)

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
              
            line_invoice_line, line_po_line,  line_delivery_line, line_invoice_line_3

            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


 [`Material`, `No`, `.`, tab, `Description`, tab, `Volume`, tab, `Cylinders`, `/`, `Qty`, `.`, tab ]

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
    or( [


   [`For`, `calls`, `outside`, `Germany`]

   , [`Material`, `No`, `.`, tab, `Description`, tab, `Volume`, tab, `Cylinders`, `/`, `Qty`, `.`, tab ]

    ,[`Deutsche`, `Bank`, `,`, `München`, tab, `Nettobetrag`]

     ] )

  
  , trace( [ `Found End line` ] )

  
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_3, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)
 
    ,  generic_item( [ line_descr, s1, tab ] )
  
    , generic_item( [ line_net_amount, d, newline ] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)
  
    ,  q10(generic_item( [ line_item, d, tab ] ))
    
    ,  generic_item( [ line_descr, s1, tab ] )
  
    , q10(generic_item( [ line_volume, s1, tab ]  ))

    , generic_item( [ line_quantity, d ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )
 
    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_2, [
%=======================================================================

   set(reverse_punctuation_in_numbers)

 , set(regexp_cross_word_boundaries)

  ,  generic_item( [ line_descr_dummy, s1, tab ] )

 , generic_item( [ line_net_amount_dummy, d, newline ] )

, clear(regexp_cross_word_boundaries)

, clear(reverse_punctuation_in_numbers)

] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    q10(generic_item( [ line_dummy, s1, tab ] ))

   ,  q10(generic_item( [ line_dummy1, s1, tab ] ))

   , generic_append( [ line_descr, s1, newline, ` `, ` `  ] )

] ).

%=======================================================================
i_line_rule_cut( line_delivery_line, [
%=======================================================================

    `Lieferbeleg`, `Nr`, `.`, `/`, `Delivery`, `Note`, `No`, `.`, `:`

    , generic_item( [ line_delivery_note_number , d  ] )

    , generic_item( [ line_del_dummy1, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_po_line, [
%=======================================================================

     or([
         [`Your`, `Purchase`, `Order`, `:`, tab]

         , [ `Ihre`, `Bestelldaten`, `:`]

     ])

     , generic_item( [ line_buyers_order_number , w , newline ] )
         

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - October 11, 2017
% Mapped by - Rohini 

% Updated on   - 21 June 2018
% Updated by   - Thejaswi
% Changes made - Comapny code and line level rule updated


% Updated on   - 25 June 2018
% Updated by   - Rohini
% Changes made - Line details udpated

% Updated on   - 15 July 2018
% Updated by   - Thejaswi
% Changes made - Line and bill to


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%