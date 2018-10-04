%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IDS MANUFACTURING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_ids_manufacturing, `23/2/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

    , get_buyer_reg_no

    ,set_credit_note
   
	, get_invoice_number

    , get_invoice_date

    , get_due_date

    , get_line_order_number
	
	, get_total_net

	, get_total_vat

    , get_vat_rate

    , get_total_invoice

    , get_currency

    ,  get_line_item

    %,  get_line_Description

    , get_invoice_lines

 

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
    
     
     sender_name(`IDS MANUFACTURING SDN BHD`)

     ,supplier_vat_number(`000955711488`)

     , currency( `MYR` )

     , set(tax_invoice)


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BUYER REG DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_buyer_reg_no, [
%=======================================================================

q(0,100,line)

    , bill_to_line1

    ,q(0,1,line)

    , bill_to_line2

    

]).

%=======================================================================
i_line_rule( bill_to_line1, [
%=======================================================================

    q0n(anything)

   ,or([

       [`C`, `/`, `O`, `UNILEVER`]
       ,[`20`, `(`, `EAST`, `)` ]

   ])

] ).

%=======================================================================
i_line_rule( bill_to_line2, [
%=======================================================================

    q0n(anything)

    , or([
    
    [[q10(`,`), `117439`]  ,buyer_registration_number(`3009`)]

    ,[[q10(`,`), `59200`],buyer_registration_number(`MY00`) ]

    ])
   
    ,trace( [ `Company code set to`, buyer_registration_number ] )
] ).


    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Credit Note
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,25, line)

    , credit_note_line1

    
] ).
%=======================================================================
i_line_rule( credit_note_line1, [
%=======================================================================

q(0,25, anything)

    , `Credit`, `Note`

     , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER AND DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================
  
   q(0,20,line)
   
   , or([
       
       generic_vertical_details( [ [ `Invoice`, `No`, `:` ], `Invoice`, q(0,1), (start, 30,30), invoice_number, s1, newline ] )

       ,[generic_vertical_details( [ [ `Debit`, `Note`, `No`],  `Debit`, q(0,1), (start,30,30), invoice_number_number, s1, newline ] )

       ,check(invoice_number_number=Invraw)
 
       , check(string_string_replace( Invraw , `2017/`,`` , InvNew ))

       ,invoice_number(InvNew)

       ,trace( [ `New Invoice Number`, invoice_number ] )]


       ,generic_vertical_details( [ [ `Credit`, `NOTE` , `No`, `:` ], `Credit`, q(0,1), (start, 30,30), invoice_number, s1, newline ] )

       
       , invoice_number_line

   ])
  
   
] ).
    
%=======================================================================
i_line_rule( invoice_number_line, [
%=======================================================================


    q0n(anything)

     
         , or([
             [read_ahead( [ `17`,`/` ] )   , nearest( 260,  10, 10 )     , generic_item( [invoice_number, s1 , newline ] )]

             ,[read_ahead( [ `18`,`/` ] )   , nearest( 260,  10, 10 )     , generic_item( [invoice_number, s1 , newline ] )]

         ])


      
	] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================
  
  q(0,20,line)
   
  
, or([

    generic_vertical_details( [ [ `Date`, `:` ], `Date`, q(0,1), (start, 10,10), invoice_date, date, tab ] )

  , [q01(line)    , invoice_date_line]

])
   
   
] ).

%=======================================================================
i_line_rule( invoice_date_line, [
%=======================================================================


         q0n(anything)

         , [nearest( 260,  10, 10 ) , generic_item( [invoice_date, date , newline ] )]

      
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DUE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_due_date, [
%=======================================================================
  
  q(0,20,line)
   

   , generic_vertical_details( [ [ `Due`, `Date`, `:` ], `Date`, q(0,1), (start, 10,10), due_date, date, tab ] )

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_order_number, [
%=======================================================================

   q0n(line)

  , or([

      generic_horizontal_details( [[ or([`M`, `SG`]) , `(`, dummy_word1(w), `)`, `-`], line_buyers_order_number, s, dummy_word2(w)] )
 
    , generic_horizontal_details( [[or([`M`, `SG`]), `(`, dummy_word2(w), `)`, `-`], line_buyers_order_number, s1, newline] )

 ,  find_order_number

   ])
 
 
    , check(line_buyers_order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , order_number(OrdNo)

    , trace( [ `THIS IS NOW THE Header ORDER Number` , OrdNo ])


] ).

 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)

    , or([
        generic_item( [ line_buyers_order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] )

    ])


]).

   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

     q0n(line)

     , or([ 

       generic_horizontal_details( [ [`Grand`, `Total`, tab, `:` ],300 ,  total_invoice, d, newline ] )

      , generic_horizontal_details( [ [`Grand`, `Total`, tab, `:`, `(`, `MYR`, `)`],300, total_invoice, d, newline ] )

      , generic_horizontal_details( [ [`Grand`, `Total`, `:`],200, total_invoice, d, newline ] )

     ])

       , q10( [  check( q_sys_comp_str_le( total_invoice, `0` ) )   

       , set( credit_note )     
       
      , trace( [ `Document Value < 0 - CREDIT NOTE SET` ] )  ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

 q0n(line)

    , or([ generic_horizontal_details( [ [ `Sub`, `Total`, tab, `:` ], 200,  total_net, d , newline ] )

    , generic_horizontal_details( [ [ `Sub`, `Total`, q10(`:`)],200, total_net, d , newline ] )

])
  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

qn0(line)
 
, or([
    
    generic_horizontal_details( [ [ `Total`, `GST`, tab, `:`],200, total_vat, d , newline] )

    ,generic_horizontal_details( [ [ `Total`, `GST`,`:`],200, total_vat, d , newline] )

    ,generic_horizontal_details( [ [ `Total`, `SST`, tab, `:`, tab], total_vat, d , newline] )
])

  
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  TOTAL  VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_vat_rate, [
%=======================================================================

qn0(line)



     ,or([

         generic_vertical_details( [ [`Tax`, `Rate` ], `Rate`, q(0,1), (start,50,100), default_vat_rate, d, or([ tab,`%` ]) ] )

             ])
   

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE ITEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_item, [
%=======================================================================

    q0n(line)

    , generic_vertical_details( [ [ `Description` ], `Description`, q(3,5), (start,10,10), line_item, d , tab  ] )
   
    
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET LINE DESCRIPTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_line_Description, [
%=======================================================================

    q0n(line)

    , generic_vertical_details( [ [ `Description` ], `Description`, q(2,3), (start,10,10), line_descr, s1 , tab  ] )

    
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

                credit_note_line

              , line_invoice_debit_credit_note
              
             , line_invoice_line 

             ,line_invoice_newline

             , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    or([ [`Description`, tab, `Customer`, `PO`, `Number`]

    , [`P`, `a`, `r`, `t`, `i`, `c`, `u`, `l`, `a`, `r`, `s`, tab, `Tax`, `Code`]

    ])

    , trace([`found the start line`])

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================


or([
 

[`FOR`, `GST`, `PURPOSE`, `USE`, `ONLY`, tab, `Sub`, `Total`, tab, `:`, tab ]
    
       , [`Sub`, `Total`]

       , [`Total`, `Quantity`, `:`]

       , [`page`]


])

     , trace([`found the end line`])

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    
      q10(generic_item( [ line_item_dummy, w , tab ] ))

        , q10(generic_item( [line_descr_dummy , s , `:` ] ))
	
	  
    , generic_item( [line_reference , d , tab] )

    , q10( [ with( 1, line_net_amount, _ ) % This q10 will only run if the first line_net_amount has been captured
	
		, with( 1, line_item, Item ) % This takes the first value of line_item (captured in rule 'get_line_item')

		, generic_item( [ line_item, Item ] ) % This stores the value in line_item for the current line
	
		, with( 1, line_descr, Descr ) % This takes the first value of line_descr (captured in rule 'get_line_Description')

		, generic_item( [ line_descr, Descr ] ) % This stores the value in line_descr for the current line
		
	] )

    , generic_item( [line_date , date , tab] )

    , generic_item( [line_quantity , d ] )

    , generic_item( [line_quantity_uom_code , w , tab] )

    , generic_item( [line_unit_amount , d , tab] )

    , generic_item( [line_net_amount , d , newline] )

] ).


%=======================================================================
i_line_rule_cut( line_desc_line, [
%=======================================================================

    generic_append( [ line_descr, s1, newline, ` `, ` `  ] )

] ).
          
%=======================================================================
i_line_rule_cut( credit_note_line, [
%=======================================================================
      
     
     q10( generic_item( [line_item_dummy , s1 , tab ] ))

      , generic_item( [line_descr , s1 , tab] )

      , q10(generic_item( [line_exp_date , date,tab ] ))

      , generic_item( [line_quantity , d ] )

      , generic_item( [line_uom_dummy , w, tab] )

      , generic_item( [line_unit_amount , d , tab] )

      , generic_item( [line_net_amount , d , newline] )

    ,   q10([  % LINE VAT Rate Calculation

       with( invoice , total_vat , VAT )  , trace( [ `vat tot`, VAT ] )

    , with( invoice , total_net , Net ) , trace( [ `sub total`, Net ] )  

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE)) , trace( [ `VAT Rate`, VAT_RATE ] )

     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) , generic_item( [ line_vat_rate , VAT_PERCENT ] )    

       ]) 


] ).


%=======================================================================
i_line_rule( line_invoice_debit_credit_note, [
%=======================================================================


	  generic_item([ line_descr , s1 , tab ]) 
 
     , generic_item([ line_tax_code , w ,  tab  ] )
	 
	 , generic_item([ line_net_amount , d , [ newline, check( line_net_amount(start) > 250 ) ] ] ) 

     , q10([  % LINE VAT Rate Calculation

       with( invoice , total_vat , VAT )  , trace( [ `vat tot`, VAT ] )

     , with( invoice , total_net , Net ) , trace( [ `sub total`, Net ] )  

     , check(sys_calculate_str_divide( VAT, Net, VAT_RATE)) , trace( [ `VAT Rate`, VAT_RATE ] )

     , check(sys_calculate_str_multiply( VAT_RATE, `100`, VAT_PERCENT )) , generic_item( [ line_vat_rate , VAT_PERCENT ] )    

       ]) 

     
]).

%=======================================================================
i_line_rule( line_invoice_newline, [
%=======================================================================


	  generic_item([ line_descr , s1 , tab ]) 
 
     , generic_item([ line_exp_date , date ,  tab  ] )
	 
	 , generic_item( [line_quantity , d ] )

      , generic_item( [line_uom_dummy , w, tab] )

      , generic_item( [line_unit_amount , d , tab] )

      , generic_item( [line_net_amount , d , newline] )
     
]).



