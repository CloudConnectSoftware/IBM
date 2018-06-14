
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KSB HALLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_halle, `21 May 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
      get_supplier_details

    , get_buyer_address 

    , get_buyer_address1

    , set_credit_note   

    , get_bank_account_code

    , get_bank_account_number
  
    , get_bank_account_no1
	
	, get_invoice_number

    , get_order_number

    , get_set_consolidated_npo
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

    , get_contact_person

    , get_currency

    , get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    ,  get_freight_line

    , get_freight_line1

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

     sender_name( `KSB HALLE ` )

    , supplier_party( `KSB HALLE ` )

    , supplier_vat_number(`FR20569801897`) 

    , currency( `EUR` )

       
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ADDRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_address, [
%=======================================================================
  
     q(0,10,line)

   , line_add_line

   , q(0,2,line)

    ,line_add_line2

] ).


%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       q0n(anything)
       
       ,or([
           
           
           read_ahead([ `Werksverrechnung` ])

           , read_ahead([ `KSB` ])


       ])

     , trace( [ `Found BUYER address`] )

    , or([
        generic_item( [buyer_party_raw , s , `GMBH` ] )

        , generic_item( [buyer_party_raw , s1 , or([tab, newline ]) ] )

    ])

    , or([
         
        [ check(buyer_party_raw = `KSB S.A.S`) ,generic_item( [ buyer_party, `KSB S.A.S.` ] ) ] 

        ,[ check(buyer_party_raw = `Werksverrechnung KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & Co.KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

         ,[ check(buyer_party_raw = Buyer_raw) ,generic_item( [ buyer_party, Buyer_raw ] ) ] 

    
        ])
   

] ).


%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

    
     q0n(anything)
     
       ,or([
             [`92635`]

            , `67227`

            , `91257`

            , [`F`, `-`, `92635`]

       ])

       ,  or([
           
           generic_item( [ buyer_city , w, `CEDEX` ] )

           , generic_item( [ buyer_city , w, or([tab, newline ]) ] )

       ])

      

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,25,line)
	
   ,  or([
        
          generic_horizontal_details( [ [ `Number`, `:` ],  invoice_number, s1, newline ] )

          , generic_horizontal_details( [ [ `Nummer`, `:` ],  invoice_number, s1, newline ] )

        ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

q(0,25,line)
	
   ,  or([
        
        generic_horizontal_details( [ [ `Date`, `:` ],  invoice_date, date, newline ] )

        , generic_horizontal_details( [ [ `Datum`, `:` ],  invoice_date, date, newline ] )

        ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DELIVERY NOTE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

q(0,25,line)
	
   ,  or([
        
          generic_horizontal_details( [ [ `Delivery`, `note`, `no`, `.`, `:` ], line_delivery_note_number, s1, newline ] )

          , generic_horizontal_details( [ [  `Lieferungs`, `-`, `Nr`, `.`, `:` ], line_delivery_note_number, s1, newline ] )

        ])
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_net_amount, [
%=======================================================================

  q(0,100,line)
     
        

     , set(reverse_punctuation_in_numbers), set(regexp_cross_word_boundaries)

      ,  or([  
          
          generic_horizontal_details( [ [ `Total`, tab ],  total_net, d, newline ] )

      ,   generic_horizontal_details( [ [`Summe`, `Positionen`, tab ],  total_net, d, newline ] )

            ])

      , clear(reverse_punctuation_in_numbers)   , clear(regexp_cross_word_boundaries)

  

        
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE TOTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

 q(0,125,line)

	, set(reverse_punctuation_in_numbers), set(regexp_cross_word_boundaries)

    ,  or([

            generic_horizontal_details( [ [ `Final`, `amount`, tab ],  total_invoice, d, newline ] )
        
            ,  generic_horizontal_details( [ [ `Endbetrag`, tab],  total_invoice, d, newline ] )

    ])


    , clear(reverse_punctuation_in_numbers)  , clear(regexp_cross_word_boundaries)

  

        
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

q(0,40,line)

, generic_horizontal_details( [ [ `Currency`, `(` ], currency,[begin, q( [ alpha , other_skip("(") ] , 1 , 10 )    ] , [`)`,  newline] ] )  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

 q(0,40,line)

 , or([
     
     generic_horizontal_details( [ [  `purchase`, `order`, `:` ],  order_number, s,[q10(tab), check(order_number(end) < -109)] ] )

 ,  find_order_number
 

   ])

   
   , set(po_found)

    , trace( [ `TML line FOUND` ] )

    , q10([ peek_fails(test(po_found)) ,  set(consolidate_lines_non_po)])


] ).


 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([
        generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] )

    ])


]).

%=======================================================================
i_rule( get_set_consolidated_npo, [
%=======================================================================

     or([
        [with( invoice, order_number, Po ), trace( [ `PO found` ] )]

        , [ set(consolidate_lines_non_po)   , trace( [ `PO line not FOUND` ] )]

    ])
        

    ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,30,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

q0n(anything)


    , [`Invoice`, `cancellation`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section_control( get_invoice_lines, first_one_only ).
%=======================================================================
i_section_end( get_invoice_lines, line_section_end_line ).
%=======================================================================
i_line_rule( line_section_end_line, [ `Rechnung`, newline] ).
%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

	line_start_line
	
	,qn0( [ peek_fails(line_end_line)
		
		,or( [

            [line_invoice_disc_dummy , line_append_line,  q(0,2, line_append_line1),line_discount_line_2, line_net_line]
            		
		, line_invoice_line

           , line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Item`, tab, `Description`, tab]

        , [`Pos`, `.`, tab, `Artikel`, tab, `Teile`]
        
      ])

    , trace([`FOUND HEADER LINE`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
       
        [`Final`, `amount`]

        ,[ `Summe`, `Positionen`]

             


        ])

        , trace([`found the end lineTWO`])
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries) , set(reverse_punctuation_in_numbers)


      , generic_item([ line_reference, d ,tab ])

      , generic_item([ line_item, w ,q10(tab) ])

      , q10(generic_item([ line_descr, s1 ,tab ]))
       
      , generic_item([ line_quantity, d , [a(w), tab ]  ])

      , generic_item( [ line_unit_amount_dummy,d , tab ] )

      , generic_item( [ line_net_amount,d , newline ] )

      
       , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_disc_dummy, [
%=======================================================================
	
        set(regexp_cross_word_boundaries) , set(reverse_punctuation_in_numbers)


      , generic_item([ line_reference, d ,tab ])

      , generic_item([ line_item, w ,q10(tab) ])

      , q10(generic_item([ line_descr, s1 ,tab ]))
       
      , generic_item([ line_quantity, d , [a(w), tab ]  ])

      , generic_item( [ line_unit_amount_dummy,d , tab ] )

      , generic_item( [ line_net_amount_dummy,d , newline ] )

      
       , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_discount_line_2, [
%=======================================================================
	
      set(regexp_cross_word_boundaries) , set(reverse_punctuation_in_numbers)

      , q10([`_`, `_`, tab])

      , `Rabatt` , `%`,  tab

      , generic_item([ line_descr_dummy, s1 ,tab ])
       
      , generic_item([ line_amount_dummy, d, tab ])

      , generic_item( [ line_net_amount_dummy,d , newline ] )
      
       , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule_cut( line_net_line, [
%=======================================================================
	
      set(regexp_cross_word_boundaries) , set(reverse_punctuation_in_numbers)

      , q10([`_`, `_`, tab])

      , `Positionsnetto`, tab

      , generic_item( [ line_net_amount,d , newline ] )
      
       , clear(reverse_punctuation_in_numbers) , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

     q10([`_`, `_`, tab])

     , generic_append( [ line_descr , s1, newline, `--`, ``  ] )

     
        
] ).


%=======================================================================
i_line_rule_cut( line_append_line1, [
%=======================================================================

    q10([`_`, `_`, tab])

    , q10(generic_append( [ line_descr , s1, tab, `--`, ``  ] ))

    , generic_append( [ line_descr , s1, newline, `.`, ``  ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - May 21, 2018
% Mapped by - Roopesh 

% Updated on   - 14 Jube 2018
% Updated by   - Thejaswi
% Changes made - 

% Updated on   - 
% Updated by   -
% Changes made - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



