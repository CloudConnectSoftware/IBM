%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINDE - FERRETERIA XEREZ S.L. `°`
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(linde_es_ferreteria_xerez, `04 July, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( same_line, 7 ).

i_pdf_parameter( newline, 15) .

i_pdf_parameter( x_tolerance_100, 100 ).

i_date_language( spanish ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    get_supplier_detail

    , get_bill_to_address

    , get_supplier_vat_number 

    , get_bank_accountnumber

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

    , get_currency

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

    sender_name( `FERRETERIA XEREZ S.L.` )

    ,supplier_party( `FERRETERIA XEREZ S.L.` )

    ,supplier_vat_number(`B11668878`)

    , buyer_dept(`ES`)

     

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

     , generic_item( [ buyer_party, s, [ `.`, dummy(s)] ] )

    ])

     , or([

          [ check(buyer_party = `ABELLO LINDE SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE, S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLÓ LINDE, S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE, SA`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `ABELLO LINDE JEREZ`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `Linde Medicinal`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ] 

        , [ check(buyer_party = `INO THERAPEUTICS`) ,generic_item( [ buyer_registration_number, `ES30` ] ) ] 

        , [ check(buyer_party = `LINDE MÉDICA, S.L.U.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]

        , [ check(buyer_party = `LINDE MEDICINAL S.L`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA SL`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA, S.L.`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ]


        ])



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q(0,300,line)

    , or([

    % generic_horizontal_details( [ [`Divisa`, `:`], currency, w, tab ] )

    currency_alternate

    ])
  
] ).

%=======================================================================
i_line_rule( currency_alternate, [
%=======================================================================


    
    q0n(anything)

    ,or([

    [ `€`]

    , [ `€`,  newline]

    ,[ `EUR`, newline]

    , [`TOTAL`, `EUROS`,  newline]

    ])
    
    , generic_item( [ currency, `EUR` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Invoice Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

    q(0,80,line)


   , generic_vertical_details( [ [dummy(s), `Albarán`, tab ], `Albarán`, q(0,2), (start, 50, 400), invoice_number, d,  [tab, generic_item( [ invoice_date, date ] ), tab] ] )



 ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================
    

     q(0,150,line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [ `BRUTO`, tab ], `BRUTO`, q(0,2), (end, 20, 80), total_net, d, tab ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_vat, [
%=======================================================================
   

     q(0,150,line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_vertical_details( [ [ `CUOTA`, tab ], `CUOTA`, q(0,2), (end, 70, 140), total_vat, d,[q10(tab), check(total_vat(end) < 290)] ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL Invocie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================
    
    q(0,150,line)

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_horizontal_details( [ [ `TOTAL`, `FACTURA`, tab ], total_invoice, d, [ `EUR`,  newline] ] )
    
    , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)
      
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
       
     
       
     line_invoice_line_ref, line_invoice_line
    
          
       , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================
or([

[ dummy(s), `ALB`, `.`, tab, `CODIGO`, tab, `DESCRIPCION`, tab, `UNID`, `.`, tab, `PRECIO`, tab]


])
, trace( [ `Found START line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

   [`BRUTO`, tab, `%`, `DTO`, `.`, tab, `P`, `.`, `P`, `.`, `IMP`, `.`, tab, `PORTES`, tab]

 ])

  , trace( [ `Found END line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_ref, [
%=======================================================================
    
     generic_item( [ line_reference,s, tab ] )

    , generic_item( [ line_dummy_order_number , s1, newline ] ) 

   
] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
    
     generic_item( [ line_item,d, tab ] )

    , generic_item( [ line_descr,s1, tab ] ) 

    , set(reverse_punctuation_in_numbers) ,set(regexp_cross_word_boundaries)

    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_net_amount , d, newline ] ) 

    
    , q10([  % LINE VAT Rate Calculation

        with( invoice , total_vat , VAT )  , trace( [ `vat tot`, VAT ] )

    , with( invoice , total_net , Net ) , trace( [ `sub total`, Net ] )  

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE)) , trace( [ `VAT Rate`, VAT_RATE ] )

     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) , generic_item( [ line_vat_rate , VAT_PERCENT ] )    

       ]) 

   , clear(reverse_punctuation_in_numbers) ,clear(regexp_cross_word_boundaries)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 04 , 2018
% Mapped by - Roopesh 

% Updated on   - 
% Updated by   -
% Changes made -

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%