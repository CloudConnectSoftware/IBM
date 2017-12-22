%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unilever Europe BV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_unilever_europe, `December 21,2017 ` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

    ,get_Invoice_tax

    ,get_bank_account_no
	
	, get_invoice_number

    , get_invoice_date

    , get_due_date

    , get_order_number
	
	, get_invoice_totals

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    , get_freight_charges


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

     sender_name(`Unilever Europe BV`)
	
	, supplier_vat_number(`NL856960007B01`)

	, buyer_registration_number(`3009`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

  q(0,50,line)

 , generic_horizontal_details( [ [ `IBAN`, `:` ],  supplier_bank_account_number, s1, newline ] ) 

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q0n(line)

    , generic_horizontal_details( [ [`Invoice`, `number`, `:` ], invoice_number, d, tab ] )
	
	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

    
    q0n(line)

    , generic_horizontal_details( [ [ `Invoice`, `date`, `:` ], invoice_date, date, newline ] )
	
	
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `PO`, `/`, `SO`, `number`, `:` ], order_number, d, tab ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

    q0n(line)

   %, set(reverse_punctuation_in_numbers)

   %, set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Net`, `Amount`, `in`, generic_item( [ currency, w ] ), tab, `:`, tab ],  total_net, d, newline ] )

     
   % , clear(regexp_cross_word_boundaries)

  %  , clear(reverse_punctuation_in_numbers)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
    i_rule(get_total_vat, [
%=======================================================================
    

     q0n(line)

     
  % , set(reverse_punctuation_in_numbers)

  % , set(regexp_cross_word_boundaries)
  , or([
      
   generic_horizontal_details( [ [ `Total`, `VAT`, `amount`, tab, `:`, tab, `0`, `.`, `00`, `%`, `on`, dummy_num(d), tab ],  total_vat, d, newline ] )

 , generic_horizontal_details( [ [ `Total`, `VAT`, `amount`, tab, `:`, tab, `0`, `,`, `00`, `%`, `on`, dummy_num(d), tab ],  total_vat, d, newline ] )


  ])
 
   % , clear(regexp_cross_word_boundaries)

  %  , clear(reverse_punctuation_in_numbers)


] ).

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
    i_rule(get_total_invoice, [
%=======================================================================
    
      q0n(line)

      
  % , set(reverse_punctuation_in_numbers)

  % , set(regexp_cross_word_boundaries)

   , generic_horizontal_details( [ [`Total`, `amount`, `in`, `EUR`, tab, `:`, tab ],  total_invoice, d, newline ] )

  %  , clear(regexp_cross_word_boundaries)

    %, clear(reverse_punctuation_in_numbers)


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

    , or([
              
    line_invoice_line, line_invoice_line1, line_add_line

            , line

        ])

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


      [`Item`, tab, `Material`, tab, `Description`, tab ]

      , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
    or([

        [`Bank`, `Details`, `:`,  newline]

        ,[`Total`, `amount`, `in`, `EUR`, tab, `:`, tab ]

          
      ])
  
  , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================


     generic_item( [ line_reference, w, tab ] )
    
    , generic_item( [ line_item, d, q10(tab) ] )
  
  ,or([

      generic_item( [ line_descr, s1, tab ]  )

    , generic_item( [line_descr , s , [q10(tab), check(line_descr(end) < 48)] ] )

    ] )

    , generic_item( [ line_commodity_code, d, tab ] )

    , generic_item( [ line_country, s1, tab ] )

 
    , generic_item( [ line_ean_code, s1, tab ] )


    , generic_item( [ line_gross_weight,s1, tab ] )

    , generic_item( [ line_net_weight, s1, newline ] )



] ).

%=======================================================================
i_line_rule( line_invoice_line1, [
%=======================================================================


     generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, tab ] )


    , generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_gross_amount_dummy, d, tab ] )


    %, set(reverse_punctuation_in_numbers)

    % , set(regexp_cross_word_boundaries)
    
    , generic_item( [ line_amount_discount, d, tab ] )

    , generic_item( [ line_unit_amount, d ] )

    , generic_item( [ line_dummy, s1, tab ] )

    , generic_item( [ line_net_amount, d, tab ] )

    , generic_item( [ line_vat_rate, d, [`%`, tab ] ] )

    , generic_item( [ line_vat_amount, d, newline ] )

 %   , clear(regexp_cross_word_boundaries)

   % , clear(reverse_punctuation_in_numbers)



] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FREIGHT CHARGES LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_charges, [
%=======================================================================
  
     q0n(line)

   , line_add_line

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`Trucking`, `to`, `port`])

     , trace( [ `Found address`] )

     , generic_item( [ line_descr, s1, tab ] )

     , generic_item( [ line_dummy, s1, tab ] )

     , generic_item( [ line_total_amount, d, [`EUR`,  newline ] ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - December 21, 2017
% Mapped by - Rohini

% Updated on   - December 21, 2017
% Updated by   - Rohini
% Changes made - Amount format changed hence removed reg expression. New line format mapped.

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%