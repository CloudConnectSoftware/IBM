%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pewag austria GmbH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ksb_pewag, `15 MARCH 2018` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( x_tolerance_100, 100 ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
	get_supplier_details

    , get_buyer_address 

    , set_credit_note
  
    , get_bank_account_no
	
	, get_invoice_number

    , get_order_number
	
	, get_invoice_date

    , get_due_date

    , get_delivery_note_nr

    , get_currency

    , get_net_amount

    , get_total_vat

    , get_total_invoice

    , get_invoice_lines

    , get_freight_line

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    sender_name( `Pewag austria GmbH` )

    ,supplier_party( `Pewag austria GmbH` )

    , supplier_vat_number(`ATU28809901`)
    
      
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

       read_ahead([ `KSB` ])

     , trace( [ `Found address`] )

     , generic_item( [buyer_party , s1, tab ] )
   
] ).

%=======================================================================
i_line_rule( line_add_line2, [
%=======================================================================

      or([
          
         [ `67206`]

      , [`92635`]

      ] )
      
         ,   or([

       generic_item( [ buyer_city_raw , s, `CEDEX`  ] )

      ,generic_item( [ buyer_city , w , tab ] )

         ] )

               ,or([

       [ check(buyer_city_raw = Buyer_raw) ,check(Buyer_raw = `GRENNEVILLIERS`) ,generic_item( [ buyer_city, `GENNEVILLIERS` ] ) ] 

     ] )



] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_account_no, [
%=======================================================================

   q(0,50,line)
	

   ,  [generic_horizontal_details( [ [`IBAN`, `:`],  supplier_bank_account_number_raw, s1, newline ] )
     
     
      , check( supplier_bank_account_number_raw = BankRaw )

    , trace( [ `Bank number raw` , BankRaw ] )

    , check(string_string_replace( BankRaw, ` `, ``, BankStrip ))

    , trace( [ `Bank Stripped Space` , BankStrip ] )

    , supplier_bank_iban(BankStrip)

    , trace( [ `Bank account Number` , supplier_bank_iban ] )  ]

 


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
        
      [ generic_vertical_details( [ [ `RECHNUNG`, `NR`, `.` ], `RECHNUNG`, q(0,1), (start,200,300), invoice_number_raw, s1, newline ] )

     , check( invoice_number_raw = InvoiceRaw )

    , trace( [ `Invoice number raw` , InvoiceRaw ] )

    , check(string_string_replace( InvoiceRaw, ` `, ``, InvoiceStrip ))

    , trace( [ `Invoice Stripped Space` , InvoiceStrip ] )

    , invoice_number(InvoiceStrip)

, trace( [ `Invoice Number` , invoice_number ] )  ]


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
        
        generic_horizontal_details( [ [ `VOM`, tab ], invoice_date, date, newline ] )

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
      
      generic_horizontal_details( [ [ `IHRE`, `BESTELLUNG`, `NR`, `.` ], order_number, d, `VOM` ] )

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

    q(0,20,line)

    ,or([
        
        generic_horizontal_details( [ [`LIEFER`, `-`, `NR`, `.`, tab ], delivery_note_number, d, newline ] )

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

    ,  generic_horizontal_details( [ [`Rechnungssumme`, tab ], total_net, d, newline ] )

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

    ,   generic_horizontal_details( [ [ `Rechnungssumme`, tab  ], total_invoice, d, newline ] )

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]
    
        ])
	
	
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FREIGHT CHARGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_freight_line, [
%=======================================================================

qn0(line)

     ,or([

         [set(reverse_punctuation_in_numbers)

    , set(regexp_cross_word_boundaries)


    , generic_horizontal_details( [ [`FRACHTKOSTEN`, tab ], line_net_amount, d, newline ] )

    , generic_item( [ line_descr, `FRACHTKOSTEN` ] )
    

    , clear(reverse_punctuation_in_numbers)

    , clear(regexp_cross_word_boundaries)]

    ])

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================================
i_rule( get_currency, [
%=======================================================================

q(0,50,line)

, generic_horizontal_details( [ [ tab, `NETTO` ], currency, w , newline ] )

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

            		
			[line_invoice_line, line_invoice_line1]

            
			, line

			
			
		] )
	
	] )

] ).


%=======================================================================
i_line_rule_cut( line_start_line,[
%=======================================================================
	
	or([

        [`POS`, `.`, tab, `BESTELL`, `-`, tab, `EH`, tab, `LIEFER`, `-`, tab ]

      ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line,[
%=======================================================================

	  or([
		 
         [`Summe`, `netto`, tab ]


        ])

        , trace([`found the end line`])
    
] ).

%=======================================================================
i_line_rule( line_invoice_line, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , generic_item([ line_reference , d ,tab ])

      ,  generic_item([ line_quantity , d ,tab ])

      ,  generic_item([ line_quantity_uom , w ,tab ])

      ,  generic_item([ line_quantity_dummy , d ,tab ])

      ,  generic_item([ line_item , d ])

       , generic_item([ line_descr , s1, newline  ])

             
      , q10( [ 

         with( invoice, delivery_note_number, Dnote ) % This takes the first value of delivery note no(captured in rule 'get_delivery_note_nr')

        , generic_item( [ line_delivery_note_number, Dnote ] ) % This stores the value in line_delivery_note for the current line
    
] )


       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).

%=======================================================================
i_line_rule( line_invoice_line1, [
%=======================================================================
	
        set(regexp_cross_word_boundaries)

      , set(reverse_punctuation_in_numbers)

      , q10(generic_item([ line_quantity_dummy , d ]))

      ,  generic_item([ line_quantity_uom_code , s1 ,tab ])

      ,  generic_item([ line_quantity_uom1 , s1 ,tab ])

      ,  generic_item([ line_unit_amount , d ,tab ])

      ,  generic_item([ line_net_amount , d ,newline ])

       , clear(reverse_punctuation_in_numbers)

       , clear(regexp_cross_word_boundaries)

    
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Created on   - march 15, 2018
% Updated by   - Rohini

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
