%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EGENCIA FRANCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( pepc_italy_egencia, `24 May 2018 ` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_detail

    , get_supplier_address

    , get_buyer_address

    % , get_remit_address

    , get_bank_no

    , get_bank_accountnumber

    , get_bank_swif_no
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

    , get_payment_terms

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

    sender_name( `EGENCIA FRANCE` )

    , supplier_vat_number(`FR21380610543`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_address, [

   
    last_line

    , q(0,50 ,up)

    , line_add_line

    , q(2,3,line)

    , line_add_line_2

    , q(0,1,line)

    , line_add_line_3

    , q(0,1,line)

    , line_add_line_4
   
] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

    q0n(anything)

    , read_ahead([`EGENCIA`])
    
    , trace( [ `Found address`] )

    , generic_item( [ supplier_party, s1, tab ] )

] ).

%=======================================================================
i_line_rule( line_add_line_2, [
%=======================================================================
    q0n(anything)

    , generic_item( [ supplier_address_line, s1, tab ] )

] ).

%=======================================================================
i_line_rule( line_add_line_3, [
%=======================================================================
   
    q0n(anything)

    , generic_item( [ supplier_postcode, w, newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line_4, [
%=======================================================================
   
    q0n(anything)

    , generic_item( [ supplier_city, s1, newline ] )


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,20,line)

   , line_add_line1

   , q(0,1,line)

    ,line_add_line2

  , q(0,1,line)

    ,line_add_line3


] ).

%=======================================================================
i_line_rule( line_add_line1, [
%=======================================================================

        or([
            
         read_ahead(`PEPSI`)

       ,read_ahead(`FRITO`)

       ] )


     , trace( [ `Found address`] )

     

    ,  generic_item( [buyer_party , s1, newline ] )



] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================
  
    generic_item( [ buyer_address_line , s1 , newline ] )

] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================
  
    generic_item( [ buyer_postcode , d ])
    , generic_item( [ buyer_city , w , newline ] )

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

    ,generic_horizontal_details( [[ `INVOICE`, `N`, `°`, `:`], invoice_number, w, newline ] )


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

  ,generic_horizontal_details( [ [ `Delivery`, `Note`, `Date`, `:` ], invoice_date, date, newline ] )


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL  NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_net, [
%=======================================================================

   q(0,50,line)

   , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

  ,generic_horizontal_details( [ [`Total`, `Amount`, `Without`, `VAT`, tab ], total_net, d, [`EUR`,  newline ] ] )

  
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)


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
   
   , q(0,50,up)

   , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

  ,generic_horizontal_details( [ [`Total`, `VAT` `Amount` , tab  ], total_vat, d,  [`EUR`,  newline ]] )


    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_total_invoice, [
%=======================================================================

   last_line
   
   ,q(0,50,up)

   , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

  ,generic_horizontal_details( [ [`Total`, `Amount`, `With`, `VAT`, tab  ],  total_invoice, d, [ generic_item( [ currency, w ] ),  newline ] ] )


    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

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

,invoice_currency

] ).

%=======================================================================
i_line_rule( invoice_currency, [
%=======================================================================

q0n(anything)

,[ `TL`,  newline ]

,currency( `TRY` ) 

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
              
              line_invoice_line,q10(line_append_line)

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

[ `exc`, `.`, `VAT`, tab, `incl`, `.`, `VAT`,  newline ]

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
 or([

    [ `exc`, `.`, `VAT`, tab, `incl`, `.`, `VAT`,  newline ]

    , [ `Passenger`, `'`, `s`, `Name`, `:`]

    , [`Due`, `Date`, `:`]

 ])

  , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)
    
      , generic_item( [ line_descr, s1, tab ] )

   , generic_item( [ line_quantity, d, tab ] )

   , generic_item( [ line_unit_amount,d, tab ] )

   , generic_item( [ line_vat_rate, d, tab ] )

   , generic_item( [ line_vat_amount,d, [ `%`,tab ]] )

   , generic_item( [ line_net_amount, d, newline ] )

   
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)


] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )


] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

    generic_item( [ line_descr, s1, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)
    
    , generic_item( [ line_reference, d, tab ] )

   , q10(generic_item( [ line_item, s1, tab ] ))

   , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

  , generic_append( [ line_descr, s1, tab, ` `,` `  ] )

   , generic_item( [ line_quantity, d, tab ] )

   , generic_item( [ line_unit_amount,d, [`TL`, tab ]] )

   , generic_item( [ line_vat_dummy, s1, tab ] )

   , or([

       generic_item( [ line_vat_dummy1, s, `%` ] )

   , generic_item( [ line_vat_dummy1, s1, tab ] )

   ] )

   , generic_item( [ line_vat_rate, d, tab ] )

   , generic_item( [ line_vat_amount, s1, [`TL`, tab ]] )

   , q10(generic_append( [ line_descr, s1, tab, ` `,` `  ] ))

   , generic_item( [ line_net_amount, d, [`TL`,  newline ] ] )

   
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

    set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)
    
    , generic_item( [ line_reference, d, tab ] )

   , q10(generic_item( [ line_item, s1, tab ] ))

   , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

   , generic_append( [ line_descr, s1, tab, ` `,` `  ] )

   , generic_item( [ line_quantity, d, tab ] )

   , generic_item( [ line_unit_amount,d, [`TL`, tab ]] )

   , generic_item( [ line_vat_dummy, s1, tab ] )

   , generic_item( [ line_vat_dummy1, s, `%` ] )

   ,  generic_item( [line_vat_rate , d , [q10(tab), check(line_vat_rate(end) < 52)] ] )

   , generic_item( [ line_vat_amount, d, q10(tab) ] )

  , generic_item( [ line_currency_dummy, w, tab ] )

   , generic_item( [ line_net_amount, d, [`TL`,  newline ] ] )

   
    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - May 22, 2018
% Mapped by - Thejaswi K 

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%