%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXMAR GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_exmar, `14 February 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( x_tolerance_100, 100 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

    ,set_credit_note
  
    , get_bank_account_no
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

    , get_packing

    , get_freight

    , get_currency

    % ,get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    , get_additional_amount

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `EXMAR GmbH` )

    ,supplier_party( `EXMAR GmbH` )

    , supplier_vat_number(`DE 811199533`)

     , supplier_bank_iban(`DE34510500150227085096`) % IBAN # on the document is Image
    
      
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

   , line_add_line

   , q(1,3,line)

    ,line_add_line2

] ).

%=======================================================================
i_line_rule( line_add_line, [
%=======================================================================

       read_ahead([`KSB` ])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party_raw ,  s1 , or([ tab, newline ])  ] )
   
     , or([
         
        [ check(buyer_party_raw = `KSB S.A.S`) ,generic_item( [ buyer_party, `KSB S.A.S.` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & Co.KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

        ,[ check(buyer_party_raw = `KSB SE & Co. KGaA`) ,generic_item( [ buyer_party, `KSB SE & Co. KGaA` ] ) ] 

         ,[ check(buyer_party_raw = Buyer_raw) ,generic_item( [ buyer_party, Buyer_raw ] ) ] 

    
        ])
   
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      or([ `67227`, `67206` ])

      ,generic_item( [ buyer_city , s1 , or([ tab, newline]) ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q(0,15,line)
	
   ,  or([
        
       generic_horizontal_details( [ [`Rechnung`], invoice_number, d, tab ] )

       , [ generic_horizontal_details( [ [`Gutschrift`], invoice_number, d, tab ] ), set(credit_note)]

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

q(0,15,line)
	
   ,  or([
        
          generic_horizontal_details( [ [ `Bad`, `Nauheim`, `,` ], invoice_date, date, `/` ] )

        ])

] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

    q(0,30,line)

    , or([
      
       find_order_number

   ])


] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([
        
        generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] )

        , generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("1"),1,1) , q(dec,8,10) , end ] ] )

    ])

]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DELIVERY NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_delivery_note_nr, [
%=======================================================================

    q(0,100,line)

    ,or([
        
        generic_horizontal_details( [ [ `Lieferscheinnr`, `.`, `/`, `-`, `datum`, `:`, tab ], delivery_note_number, d, `/` ] )

    ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_net_amount, [
%=======================================================================

	qn0(line)

     ,or([

    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [ `Waren`, `-`, `/`, `Nettowert`, tab ], total_net, d,  newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    
    
    ])

	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

qn0(line)

     ,or([

         [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


    ,  generic_horizontal_details( [ [`Mehrwertsteuer`, tab, `19`, `,`, `00`, tab, `%`, `von`, `EUR`, dummy_num(d), tab ], total_vat, d, newline ] )

    , generic_item( [ default_vat_rate, `19` ] )
    

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    ])

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

	q0n(line)

     ,or([
  
    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [ `Endbetrag`, tab, `EUR` ], total_invoice, d,  newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
        ])
	
	

]).

%=======================================================================
i_rule( get_packing, [
%=======================================================================

	q0n(line)

     ,or([
  
    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [`Anteil`, `Verpackung` ],800, line_net_amount, d,  newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
        ])

       , line_descr(`Anteil Verpackung`)
	
	

]).

%=======================================================================
i_rule( get_freight, [
%=======================================================================

	q0n(line)

     ,or([
  
    [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [`Anteil`, `Fracht` ],800, line_net_amount, d,  newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
        ])

       , line_descr(`Anteil Fracht`)
	
]).


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

, or([

 [`Endbetrag`, tab, `EUR`]

, [`EUR`,  newline ]

] )

,currency( `EUR` ) 

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

	line_start_line
	
	,qn0( [ peek_fails(line_end_line)
		
		,or( [

            		
			
             [line_invoice_line, q10(line_descr_line), q(0,10,line_append_line), q10(line_append_line1), q10(line_append_line),line_invoice_line1]

            , [q10(line_append_line),line_invoice_line1]

            
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`Pos`, tab, `Artikelnummer`, tab, `Urspr`]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([

          [`Rechnung`]
		 
        , [`Waren`, `-`, `/`, `Nettowert`, tab ]

         , [`Pos`, tab, `Artikelnummer`, tab, `Urspr`]

        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item( [line_number , d , [q10(tab), check(line_number(end) < -354)] ] )
      
      ,  generic_item([ line_item , s1 , tab ])

     , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

     ,  generic_item( [ line_quantity, d, q10(tab) ] )

    ,  generic_item( [ line_quantity_uom_code,s1, tab ] )

      ,  generic_item([ line_unit_amount_dummy , d ,tab ])

      ,  generic_item([ line_net_amount_dummy , d ,newline ])

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_descr_line, [
%=======================================================================
	
  generic_item( [ line_descr_dummy, s1, newline  ] )

    
] ).


%=======================================================================
i_line_rule( line_append_line, [
%=======================================================================
	
  generic_append( [ line_descr_dummy, s1, newline, ` `, ` `  ] )

    
] ).

%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================
	
        
        
        [`Position`, `Nettowert`, tab ]
        
        
      ,  set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)


      ,  generic_item([ line_unit_amount , d ,tab ])

      ,  generic_item([ line_net_amount , d ,newline ])

            
      , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%=======================================================================
i_line_rule( line_append_line1, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

     , generic_append( [ line_descr_dummy, s1, tab, ` `, ` `  ] )

      ,  generic_item([ line_dummy_amount , d ,[`%`, tab ] ])

      ,  generic_item([ line_amount_dummy , d ,newline ])

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_additional_amount, [
%=======================================================================

	q0n(line)

    , set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)

    ,  generic_horizontal_details( [ [`Mindestwertzuschlag`, tab ], line_net_amount, d,  newline ] )

    , generic_item( [ line_descr,`Mindestwertzuschlag` ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)
   	
	

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - February 14, 2018
% Updated by   - Rohini

% Updated on   - march 29, 2018
% Updated by   - Rohini
% Changes made   - Bank details hardcoded and line details updated


% Updated on   - Sep 14, 2018
% Updated by   - Rohini
% Changes made   - Additonal charges mapped



% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
