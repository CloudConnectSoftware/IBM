%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TNT Express Worldwide (Spain) S.L.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( linde_es_tnt_express, `July 5, 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_bill_to_address

    , get_bank_accountnumber

    , set_credit_note
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_order_number

    , get_buyer_contact

    , get_payment_terms

    , get_delivery_note
    
    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_invoice_lines

    , get_freight_line


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_detail, [
%=======================================================================

     sender_name( `TNT Express Worldwide (Spain) S.L.` )

   , supplier_party(`TNT Express Worldwide (Spain) S.L.`)

   , supplier_vat_number(`B28905784`) 

   , buyer_dept(`ES`)

   , currency(`EUR`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER REGISTRATION 
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

        ,  read_ahead(`ABELLO`)
       
        , generic_item( [ buyer_party, s1, newline ] )
     
        , or([
         
          [ check(buyer_party = `ABELLO LINDE,S.A.`) ,generic_item( [ buyer_registration_number, `ES10` ] ) ] 

        , [ check(buyer_party = `LINDE MEDICINAL SL`) ,generic_item( [ buyer_registration_number, `ES20` ] ) ] 

        , [ check(buyer_party = `INO THERAPEUTICS`) ,generic_item( [ buyer_registration_number, `ES30` ] ) ] 

        , [ check(buyer_party = `Linde Electronics S.L`) ,generic_item( [ buyer_registration_number, `ES40` ] ) ]

        , [ check(buyer_party = `LINDE MEDICA ,S.L.U.`) ,generic_item( [ buyer_registration_number, `ES50` ] ) ]
    
    ])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

      q(0,50,line)

    , set(regexp_allow_partial_matching)

    , or([

      generic_vertical_details( [ [ `NºFactura`, tab, `Fecha` ], `Fecha`, q(0,1), (start,10,100), invoice_number , d, [ tab, generic_item( [ invoice_number, date ] ), tab ] ] )

    , generic_horizontal_details( [ [ `2018`, `/`, `TO` ], invoice_number, d, [ tab, generic_item( [ invoice_date ,date ] ), tab ] ] )
  
     ] )

    , clear(regexp_allow_partial_matching)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_due_date, [
%=======================================================================

      q(0,50,line)

    , generic_vertical_details( [ [ `Vencimiento`, `:` ], `Vencimiento` , q(0,1), (start,10,100), due_date, date , newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

       q(0,50,line)

    , generic_horizontal_details( [ [  `PEDIDO`, `:` ], order_number, d, tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

    q(0,200, line )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)
 
   , generic_vertical_details( [ [`Importe`, `Bruto` ], `Importe`, q(0,1), (start,10,100), total_net, d , tab ] )
 
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

    q(0,200, line )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)
 
   , generic_vertical_details( [ [`Importe`, `IVA` ], `Importe`, q(1,2), (start,10,100), total_vat, d , tab ] )
 
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
     
   , q(0,20, up )

   , set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries)

   , generic_vertical_details( [ [`TOTAL`, `FACTURA` ], `TOTAL`, q(1,2), (start,10,100), total_invoice, d , newline ] )
  
   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     q(0,50,line)

  , invoice_currency

] ).  

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

      q0n(anything)

   , [`€`,  newline ]

   , currency( `EUR` ) 

   , trace( [ `currency found`] )

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
         
         , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


      [`Referencia`, tab, `Denominación`, tab ]

     , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

      or([
          
       [ `Importe`, `Bruto`, tab, `%`, `Dto`, `.`, tab ]
   
     ] )

     , trace( [ `Found End line` ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

   , set(regexp_cross_word_boundaries) 

   , generic_item( [ line_descr, s1 , tab ] )
   
   , generic_item( [ line_descr_dummy, s1 , tab ] )
   
   , generic_item( [ line_quantity, d , q10(tab) ] )

   , generic_item( [ line_unit_amount_dummy, d , tab ] )
      
   , generic_item( [ line_net_amount, d , newline ] )

   , q10([	% LINE VAT Rate Calculation
  
     with( invoice , total_vat , VAT )

   , with( invoice , total_net , Net )

   , check(sys_calculate_str_divide( VAT, Net, VAT_RATE))

   , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) 

   , generic_item( [ line_vat_rate , VAT_PERCENT ] )

       ])

   , clear(regexp_cross_word_boundaries)
 
   , clear(reverse_punctuation_in_numbers)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - July 5, 2018
% Mapped by - Rohini 

% Updated on   - 
% Updated by   -
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%