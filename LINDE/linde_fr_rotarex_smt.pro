%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotarex SMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_fr_rotarex_smt,`12/10/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bank_accountnumber

    , get_bank_code
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_delivery_note

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

    sender_name( `Rotarex SMT` )

    ,supplier_party( `Rotarex SMT` )

   ,supplier_vat_number(`FR20712047547`)

   , buyer_registration_number(`FR10`)

   , buyer_dept(`FR`)

     , set(reverse_punctuation_in_numbers)
   

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

     qn0(line)
    

    ,generic_horizontal_details( [ [`code`, `banque`,generic_item( [ supplier_bank_code, d ] ),`,`, `code`, `guichet`,generic_item( [ supplier_bank_number_dummy, d ] ),`,`, `n`, `°`, `de`, `compte` ], supplier_bank_no, s,
    
      [`,`, `n`, `°`, `swift` ,generic_item( [ supplier_swift, s ] ), `,`, `n`, `°`, `IBAN`,generic_item( [ supplier_iban_raw, s ] ), newline ] ] )



    , [ check(supplier_iban_raw = Siban)  , check(strip_string2_from_string1( Siban, ` `, SibanNew ))

    , supplier_iban(SibanNew)    , trace( [ `Bank IBAN new FORMAT`, supplier_iban ] )]

    , [check(supplier_swift = Swift)  , check(strip_string2_from_string1( Swift, ` `, SwiftNew ))

    , supplier_swift_code(SwiftNew)    , trace( [ `SWIFT new FORMAT`, supplier_swift_code ] )] 

    , [check(supplier_bank_no = Sban)  , check(strip_string2_from_string1( Sban, ` `, SbanNew ))

    , supplier_bank_account_number(SbanNew)    , trace( [ `Bank account new FORMAT`, supplier_bank_account_number ] )]
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
    
    , generic_vertical_details( [ [ `Facture` ], `Facture`, q(0,1), (start,10 ,10), invoice_number, d , `/` ] )

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


    ,or([
        generic_horizontal_details( [ [ `Genlis`, `,`, `le` ], invoice_date, date, tab ] )

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

   q(0,35,line)


    ,generic_horizontal_details( [ [ `Votre`, `commande`, `:`, tab],  order_number, w,  tab ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NET  AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    last_line
    
   , q(0,100,up)

    , set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Total`, `HTVA`, tab, `=` ], 150, total_net, d,  newline ] )
    
   , clear(regexp_cross_word_boundaries)

  
   
] ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

    last_line
    
    , q(0,100,up)

     , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [ `Total`, `facture`, tab, `=`, generic_item( [ currency, w ] ) ], 150, total_invoice, d,  newline ] )

   , clear(regexp_cross_word_boundaries)

   ,clear(reverse_punctuation_in_numbers)

  
   
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

    , set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [ `TVA`, generic_item( [ default_vat_rate, d ] ), tab, `=` ], 150, total_vat, d,  newline ] )

    , clear(regexp_cross_word_boundaries)

    ,clear(reverse_punctuation_in_numbers)




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
              
              [line_invoice_line, q10(line_descr_append),q10(line_descr_append) ,q10(line_descr_append)]

              ,[line_invoice_line2, line_descr_line]

              , [ line_invoice_line3 ,q10(line_descr_append),q10(line_descr_append),q10(line_descr_append)]

             , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

or([

[`Séq`, `.`, `Numéro`, `article`, tab, `Anc` ]


])

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or([

    [`Total`, `HTVA`]

    
    ])
  , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
 

  generic_item( [ line_sequesnce, d, q10(tab) ] )

 , generic_item( [ line_item, d, tab ])

 , q10([
      check(line_item=Line_Item)

     , generic_item( [ line_descr,Line_Item ] )
 
      ] )

, generic_item( [ line_reference, s1, tab ])

, set(reverse_punctuation_in_numbers)

, set(regexp_cross_word_boundaries)

, generic_item( [ line_quantity, d, tab ])

, generic_item( [ line_unit_amount, d, tab] )

, generic_item( [ line_quantity_dummy, d])

, generic_item( [ line_quantity_uom_code, w, tab ])

, set(reverse_punctuation_in_numbers)

, set(regexp_cross_word_boundaries)

, generic_item( [ line_net_amount,d, newline ] )

, set(reverse_punctuation_in_numbers)

, set(regexp_cross_word_boundaries)


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

 generic_item( [ line_sequesnce, d, q10(tab) ] )

, set(reverse_punctuation_in_numbers)

, set(regexp_cross_word_boundaries)

, generic_item( [ line_item, w, tab ])

, generic_item( [ line_quantity, d, tab ])

, generic_item( [ line_unit_amount, d, newline] )

, set(reverse_punctuation_in_numbers)

, set(regexp_cross_word_boundaries)

] ).


%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

generic_item( [ line_descr, s1, newline] )

] ).

%=======================================================================
i_line_rule_cut( line_descr_append, [
%=======================================================================

generic_append( [ line_descr,s1, newline, ` - `, `` ] )

] ).

%=======================================================================
i_line_rule_cut( line_po_line, [
%=======================================================================

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - October 12, 2017
% Mapped by - Thejaswi K

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 



