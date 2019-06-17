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

    ,get_currency
	
	, get_invoice_number

    , get_invoice_date

    , get_due_date

    , get_order_number

    , get_delivery_number
	
	, get_invoice_totals

    , get_total_net

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    , get_port_charges

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

    ,currency( `EUR` )

    ,set(tax_invoice)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

  qn0(line)

 , generic_horizontal_details( [ [ `IBAN`, `:` ],  supplier_bank_account_raw, s1, newline ] ) 

 , check(supplier_bank_account_raw= `NL41DEUT0265240816`)  

 ,generic_item( [ supplier_bank_account_number, `265240816` ] )

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

    , generic_horizontal_details( [ [`Invoice`, q10(tab) , `number`  ,q10(tab), `:` ,q10(tab)], invoice_number, d, tab ] )
	
	
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

    , generic_horizontal_details( [ [ `Invoice`, `date` , q10(tab) , `:`  ,q10(tab) ], invoice_date, date, newline ] )
	
	
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    last_line

    , q(0,150,up)

    , or([
        generic_horizontal_details( [ [  `consignee`, `number`, q10(tab), `:`, q10(tab) ], order_number, d,  newline ] )

        , generic_horizontal_details( [ [  `Consignee`, `Number`, tab, `:`, tab, dummy_word(w), `;` ], order_number, d,  newline ] )

        , generic_horizontal_details( [ [  `Consignee`, `Numbe`, `r`, q10(tab), `:`, q10(tab), dummy_word(w),q10(dummy_word1(w)), q10(`;`) ], order_number, d,  newline ] )

        , generic_horizontal_details( [ [  `Consignee`, `Numbe`, `r`, q10(tab), `:`, q10(tab) ], order_number, d,  newline ] )

        , find_order_number
        ])

] ).

%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,5,15) , end ] ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_number, [
%=======================================================================

    q0n(line)

    , generic_horizontal_details( [ [ `Delivery`, `Number` , q10(tab) , `:`  ,q10(tab) ], delivery_note_number, d, or([ tab, newline]) ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

    qn0(line)


    ,or([
        
        
     generic_horizontal_details( [ [ `Net`, `Amount`, `in`, generic_item( [ currency, w ] ), q10(tab), q10(`:`), q10(tab) ],  total_net, d, newline ] )
        
    ,generic_horizontal_details( [ [ `Net`, `Amount`, `in`, generic_item( [ currency, w ] ), q10(tab), q10(`:`), tab ],  total_net, d, newline ] )
    

       
     ,[set(reverse_punctuation_in_numbers)   , set(regexp_cross_word_boundaries)

    ,generic_horizontal_details( [ [ `Net`, `Amount`, `in`, generic_item( [ currency, w ] ), q10(tab), q10(`:`), tab ],  total_net, d, newline ] )

    , clear(regexp_cross_word_boundaries)  , clear(reverse_punctuation_in_numbers)]

    ])
     


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

     last_line

    ,q(0,100,up)

,or([
    generic_horizontal_details( [ [ `Net`, `Amount`, `in` ],  currency, w, tab ] )

       
   ]) 


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
    i_rule(get_total_vat, [
%=======================================================================
    
 last_line

    ,q(0,100,up)

  , or([
      
   
   generic_horizontal_details( [ [ `Total`, `VAT`, `amount`, tab, `:`, tab, `0`, `,`, `00`, `%`, `on`, dummy_num(d), tab ],  total_vat, d, newline ] )
    
   , [ set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)
  ,   generic_horizontal_details( [ [ `Total`, `VAT`, `amount`, tab, `:`, tab, `0`, `.`, `00`, `%`, `on`, dummy_num(d), tab ],  total_vat, d, newline ] )

   , clear(regexp_cross_word_boundaries)   , clear(reverse_punctuation_in_numbers)]

   ,generic_horizontal_details( [ [ `Total`, `VAT`, `amount`, tab, `:`, tab, `0`, `.`, `00`, `%`, `on`, dummy_num(d), tab ],  total_vat, d, newline ] )


  ])
 

] ).

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
    i_rule(get_total_invoice, [
%=======================================================================
    
       last_line

    ,q(0,100,up)
 

   ,or([
       
       generic_horizontal_details( [ [`Total`, `amount`, `in`, `EUR`, q10(tab),q10(`:`), q10(tab) ],  total_invoice, d, newline ] )
     
     ,[ set(reverse_punctuation_in_numbers) , set(regexp_cross_word_boundaries)

   , generic_horizontal_details( [ [`Total`, `amount`, `in`, `EUR`, q10(tab),q10(`:`), tab ],  total_invoice, d, newline ] )

   , clear(regexp_cross_word_boundaries)  , clear(reverse_punctuation_in_numbers)]

   

    
   ])
  

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

        [line_invoice_line_new1, q10(line_desc_line_dummy), line_invoice_line_new]
        , [line_newinvoice_ref, line_desc_commodity_line ,q10(line_desc_line_dummy) , line_ean_line ,line_net_line, line_qty_line, line_zun_qty_line, line_vat_line  ]

      ,[line_invoice_line, q10(line_desc_line_dummy), line_invoice_line1]
    
       ,[line_invoice_line, q10(line_desc_line_dummy), line_invoice_line2]

        ,[line_invoice_line,q10(line_desc_line_dummy),q10(line_desc_line_dummy), q10( line_invoice_crossword)]
    
         ,line_invoice_line1

         ,[line_invoice_line_new1, q10(line_desc_line_dummy), line_invoice_line_new]

        , line

        ])

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    or([
      [`Item`, tab, `Material`, tab, `Description`, tab ]

      ,[`VAT`, tab, `Rate`]

      ])

      , trace( [ `Found Start line` ] )



] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
 
    or([

        [`Bank`, `Details`, `:` ]

        ,[`Sending`, `Fiscal`, `Representative`]

        ,[`Total`, `amount`, `in`, `EUR`, tab, `:`, tab ]
          
      ])
  
  , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


     generic_item( [ line_reference, w, tab ] )
    
    , generic_item( [ line_item, d, q10(tab) ] )
  
  ,or([

      generic_item( [ line_descr, s1, tab ]  )

    , generic_item( [line_descr , s , [q10(tab), check(line_descr(end) < 48)] ] )

    ] )

    , generic_item( [ line_commodity_code, d, tab ] )

    , generic_item( [ line_country, s1, tab ] )
 
    , generic_item( [ line_ean_code, d, q10(tab) ] )

    , generic_item( [ line_gross_weight,s1, tab ] )

    , generic_item( [ line_net_weight, s1, or([tab,newline]) ] )

    , q10(generic_item( [ line_vat_amount_dummy, w, newline ] ))

    , trace( [ `line_invoice_line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================


     generic_item( [ line_quantity, d, q10(tab) ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, tab ] )

    , q10(generic_item( [ line_gross_amount_dummy, d, tab ] ))
  
    , generic_item( [ line_amount_discount, d, tab ] )

    , generic_item( [ line_unit_amount_dummy, d ] )

    , generic_item( [ line_dummy, s1, tab ] )

    ,generic_item( [ line_net_amount, d,tab ] )

    , generic_item( [ line_vat_rate, d, [`%`, or([tab,newline]) ] ] )

    , q10(generic_item( [ line_vat_amount_dummy, d, newline ] ))

    , trace( [ `line_invoice_line1` ] )

    
 
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_new1, [
%=======================================================================

    set(regexp_cross_word_boundaries)

      ,set(reverse_punctuation_in_numbers)

    , generic_item( [ line_reference, w, tab ] )
    
    , generic_item( [ line_item, d, tab ] )
  
     , generic_item( [ line_descr, s1, tab ]  )

    , generic_item( [ line_commodity_code, d, tab ] )

    , generic_item( [ line_country, s1, tab ] )
 
    , generic_item( [ line_gross_weight, s1, newline] )

    , trace( [ `line_invoice_line` ] )

    , clear(regexp_cross_word_boundaries)

      ,clear(reverse_punctuation_in_numbers)

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_new, [
%=======================================================================

     set(regexp_cross_word_boundaries)

      ,set(reverse_punctuation_in_numbers)

    , generic_item( [ line_quantity, d ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, tab ] )
  
    , generic_item( [ line_amount_discount, d, tab ] )

    , generic_item( [ line_dummy, s1, tab ] )

    ,generic_item( [ line_net_amount, d,tab ] )

    , generic_item( [ line_vat_rate, d, [`%`,tab ] ] )

    , q10(generic_item( [ line_vat_amount_dummy, d, newline ] ))

    , trace( [ `line_invoice_line new` ] )

    , clear(regexp_cross_word_boundaries)

      ,clear(reverse_punctuation_in_numbers)

    
 
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

       set(regexp_allow_partial_matching)

    , generic_item( [ line_quantity , d ])
    
    , generic_item( [ line_quantity_uom_code , w , tab ] )

    , clear(regexp_allow_partial_matching) 

    , generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, tab ] )

    , generic_item( [ line_gross_amount_dummy, d, tab ] )
     
    , generic_item( [ line_amount_discount, d, tab ] )

    , generic_item( [ line_unit_amount_dummy, d ] )

    , generic_item( [ line_dummy, s1, tab ] )

    , generic_item( [ line_net_amount,d,tab ] )

    , generic_item( [ line_vat_rate, d, [`%`, tab ] ] )

    , generic_item( [ line_vat_amount, d, newline ] )
        
    , trace( [ `line_invoice_line2` ] )

 

] ).




%=======================================================================
i_line_rule_cut( line_invoice_crossword, [
%=======================================================================

      set(regexp_cross_word_boundaries)

      ,set(reverse_punctuation_in_numbers)

      ,generic_item( [ line_quantity, d, q10(tab) ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_quantity_dummy, d ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, tab ] )

    , q10(generic_item( [ line_gross_amount_dummy, d, tab ] ))
    
    , generic_item( [ line_amount_discount, d, tab ] )

    , generic_item( [ line_unit_amount_dummy, d ] )

    , generic_item( [ line_dummy, s1, tab ] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

      ,set(reverse_punctuation_in_numbers)

    , generic_item( [ line_net_amount, d, tab ] )
    
    , generic_item( [ line_vat_rate, d, [`%`, or([tab,newline]) ] ] )

    , q10(generic_item( [ line_vat_amount_dummy, d, newline ] ))

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)

    , trace( [ `line_invoice_line cross` ] )

]).

%=======================================================================
i_line_rule_cut( line_desc_line_dummy, [
%=======================================================================


     generic_item( [ line_reference_dummy, s1, newline ] )

]).   

%=======================================================================
i_line_rule_cut( line_newinvoice_ref, [
%=======================================================================


     generic_item( [ line_reference, d ] )
    
    , generic_item( [ line_item, d, newline ] )
  
  
] ).

%=======================================================================
i_line_rule_cut( line_desc_commodity_line, [
%=======================================================================


      generic_item( [ line_commodity_code, d, or([tab,newline]) ] )

      ,q10(generic_item( [ line_descr, s1, newline ]  ))


] ).

%=======================================================================
i_line_rule_cut( line_ean_line, [
%=======================================================================

     generic_item( [ line_ean_code, d, tab ] )

    , generic_item( [ line_gross_weight,s1, tab ] )

    , generic_item( [ line_net_weight, s1, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_net_line, [
%=======================================================================


     generic_item( [ line_gross_amount_dummy, d, tab ] )
  
    , generic_item( [ line_amount_discount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )

     
] ).


%=======================================================================
i_line_rule_cut( line_qty_line, [
%=======================================================================

       set(reverse_punctuation_in_numbers)

     , set(regexp_cross_word_boundaries)
      ,
      generic_item( [ line_quantity, d ] )

    , generic_item( [ line_quantity_uom_code, w, tab ] )

    , generic_item( [ line_unit_amount_dummy, d,tab ] )

    , generic_item( [ line__curency, w, tab ] )

    , generic_item( [ line_dummy, s1, newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)

 ] ).

 
%=======================================================================
i_line_rule( line_zun_qty_line, [
%=======================================================================


     generic_item( [ line_quantity_dummy, d,tab ] )

    , generic_item( [ line_quantity_uom_code_dummy, w, newline ] )

 
] ).


%=======================================================================
i_line_rule_cut( line_vat_line, [
%=======================================================================

     `vat`, tab

    , generic_item( [ line_vat_rate, d,  [tab, `%`,  newline] ] )

 
] ).


             

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORT/SEAFREIGHT CHARGES LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_port_charges, [
%=======================================================================
  
     q0n(line)

   , line_add_line

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       
   or([
       
       read_ahead([`Trucking`, `to`, `port`])

      ,read_ahead([`Frt`, `&`, `handling`, `chrgs`])

      ] ) 

     , trace( [ `Found address`] )

     , generic_item( [ line_descr, s1, tab ] )

     , generic_item( [ line_dummy, s1, tab ] )

     , generic_item( [ line_total_amount, d, [`EUR`,  newline ] ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FREIGHT CHARGES LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_freight_charges, [
%=======================================================================
  last_line

     , q(0,100,up)

    % , set(reverse_punctuation_in_numbers)  , set(regexp_cross_word_boundaries)

   , or([
       line_add_line1

       , line_add_line2

       ,line_add_line3

   ])

   %,clear(reverse_punctuation_in_numbers)  , clear(regexp_cross_word_boundaries)
] ).

%=======================================================================
i_line_rule_cut( line_add_line1, [
%=======================================================================


      or([
           read_ahead([`Freight`, `Charges`, `in`, `EUR`])

           , read_ahead([`Seafreight`])

      ])

 

     , trace( [ `Found Freight`] )

     , or([
         generic_item( [ line_descr, s, [q10(`in`),q10(`EUR`), q10(tab) ] ] )

         ,generic_item( [ line_descr, s1, tab ] )

     ])

     , generic_item( [ line_dummy, s1, tab ] )

     , generic_item( [ line_total_amount, d, [newline ]  ] )

] ).

%=======================================================================
i_line_rule_cut( line_add_line2, [
%=======================================================================


    or([
        read_ahead([`Freight`, `Charges`])

    ])

    , trace( [ `Found Freight`] )

    ,generic_item( [ line_descr, s1, tab ] )
    
    , generic_item( [ line_dummy, s1, tab ] )

    , set(regexp_cross_word_boundaries)

    , set(reverse_punctuation_in_numbers)

    , generic_item( [ line_total_amount, d, [`EUR`,newline ]  ] )

    , clear(regexp_cross_word_boundaries)

    , clear(reverse_punctuation_in_numbers)

] ).

%=======================================================================
i_line_rule_cut( line_add_line3, [
%=======================================================================


    or([
        read_ahead([`Freight`, q10(`Charges`), q10(`in`), q10(`EUR`)])

    ])

    , trace( [ `Found Freight`] )

    ,generic_item( [ line_descr, s1, tab ] )
    
    , generic_item( [ line_dummy, s1, tab ] )

    , generic_item( [ line_total_amount, d, [q10(`EUR`),newline ]  ] )


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - December 21, 2017
% Mapped by - Rohini

% Updated on   - December 21, 2017
% Updated by   - Rohini
% Changes made - Amount format changed hence removed reg expression. New line format mapped.

% Updated on   - January 22, 2018
% Updated by   - Thejaswi
% Changes made - Line format changed

% Updated on   - January 29, 2018
% Updated by   - Thejaswi
% Changes made - Line format changed

% Updated on   - January 31, 2018
% Updated by   - Thejaswi
% Changes made - Line format changed

% Updated on   - Feb 13, 2018
% Updated by   - Thejaswi
% Changes made - Line format changed

% Updated on   - Feb 14, 2018
% Updated by   - Thejaswi
% Changes made - Line format changed


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%