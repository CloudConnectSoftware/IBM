%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R.H. ELECTRONICS LTD -  Mergred with  9000023578 and 9000158313 for  0026/0109, 0003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_rh_electronics_hebrew, `2026-07-10 18:51:32` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_op_param( us_invoice, _, _, _, false ).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_user_field( invoice, allocation_number, `IRN` ).  

json_custom_field( `IRN`, allocation_number ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_allocation_number

   % , get_buyer_vat mapping not needed as we should not map as per BIll to , it is hardcoded to DE811381130

    , set_credit_note

    , get_original_invoice_number

   % , get_original_invoice_number_1 
    
     , get_invoice_number 
    
    , get_invoice_date_1

    , get_invoice_date_2
	
    , get_order_number

    , get_po_line_number
	
	, get_net_amount_hebrew

    , get_vat_amount_hebrew

    , get_total_amount_hebrew

    , get_invoice_totals

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

     sender_name( `R.H. ELECTRONICS LTD` )

   % Supplier VAT number -   %

    , currency(`ILS`)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALLOCATION NUMBER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_allocation_number, [
%=======================================================================

  
     q(12,50,line)

   , line_irn_line

   , q(0,1,line)

   , line_irn_line_1
   

] ).

%=======================================================================
i_line_rule_cut( line_irn_line, [
%=======================================================================

       qn0(anything)
     
     , read_ahead([`560031387` ])

     , trace( [ `Found address`] )

     , generic_item( [ dummy_value, s1, newline ] )


] ).


%=======================================================================
i_line_rule_cut( line_irn_line_1, [
%=======================================================================

     generic_item( [ dummy_value, d, q10(tab) ] )

  ,  generic_item( [ allocation_number, d, `:` ] )

  , generic_item( [ dummy_value, s1, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER VAT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_vat, [
%=======================================================================
  
     q(1,20,line)

   , line_add_line


] ).


%=======================================================================
i_line_rule_cut( line_add_line, [
%=======================================================================

       q0n(anything)


     , read_ahead([ `Bill`, `to` ])
          
     , trace( [ `Found address`] )

     , generic_item( [bil_to_details, s1 , tab ] )

     , generic_item( [buyer_party_raw , s1 , tab ] )
       
     , [ check(buyer_party_raw = `APPLIED MATERIALS EUROPE`) ,generic_item( [ buyer_vat_number, `NL006790872B01` ] ) , generic_item( [ buyer_tax_type, `VAT` ] ) ] 

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

    , [`-`, dummy(d), tab, `:`, dummy(s),  newline ]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIGINAL INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_original_invoice_number, [ 
%=======================================================================
	
	q0n(line)

     , test(credit_note)

  , or([      

          generic_vertical_details( [ [ `Packing`,  `Slip`,  `הרוש`,  newline ], `Packing`, q(0,2), (start,100,900), original_invoice_number, d, [ dummy(s1), newline ] ] )

        , generic_vertical_details( [ [ `USD`,  dummy(s),  tab, `תומכ`,  tab ], `תומכ`, q(0,3), (start,100,900), original_invoice_number, d, [ dummy(s1), newline ] ] )

    ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIGINAL INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================================
i_rule_cut( get_original_invoice_number_1, [
%=======================================================================

      q0n(line)

     , test(credit_note)

     , read_ahead([`DELTA`,  `PRICE`])

     , trace( [ `Found text`] )

 , set(regexp_allow_partial_matching)

     , generic_item( [ original_invoice_number, d, `,`] )

     , generic_item( [ dummy, s1 , newline ] )

 , clear(regexp_allow_partial_matching)

     ] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [ 
%=======================================================================
	
	q0n(line)

  , or([

     generic_horizontal_details( [ [`רוקמ`, tab ],  invoice_number, d, [`:`, `רפסמ`,  `סמ`,  tab ] ] )

  ,  generic_horizontal_details( [ [`קתעה`,  tab ],  invoice_number, d, `:` ] )

  ,  generic_horizontal_details( [ [`הטויט`,  tab ],  invoice_number, d, [`:`, `רפסמ`,  `סמ`,  tab ] ] )

  ,  generic_horizontal_details( [ [`אטויט`,  `-` ],  invoice_number, s,  [ `תזכרמ`,  `סמ`,  `תינובשח`,  newline ] ] )

  ,  generic_horizontal_details( [ [`(`, `בשחוממ`,  `ךמסמ`, `)`,  `רוקמ`,  `-` ],  invoice_number, s, [ `תזכרמ`,  `סמ`,  `תינובשח`,  newline ] ] )

  ,  generic_horizontal_details( [ [ `קתעה`,  `-` ],  invoice_number, s,  [`תזכרמ`,  `סמ`,  `תינובשח`,  newline ] ] )

  ,  generic_horizontal_details( [ [`(`, `בשחוממ`,  `ךמסמ`, `)`,  `רוקמ`,  `-` ],  invoice_number, s, [ `תזכרמ`,  `יוכיז`,  `תינובשח`,  newline ] ] )
	
] )

  , generic_item( [ buyer_vat_number, `DE811381130` ] )
  
  , generic_item( [ buyer_tax_type, `VAT` ] )

] ).

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [ 
%=======================================================================
	
      q0n(line)

    , or([

      generic_vertical_details( [ [ `רוקמ`, tab ], `רוקמ`, q(0,1,up), (start, 500,500), invoice_date_raw, s, [`:`, `ךיראת`,  newline ]] )
   
    , generic_vertical_details( [ [ `קתעה`,  tab ], `קתעה`, q(0,1,up), (start, 500,500), invoice_date_raw, s, `:`] )

    , generic_vertical_details( [ [ `הטויט`,  tab ], `הטויט`, q(0,1,up), (start, 500,500), invoice_date_raw, s, `:`] )


   ] )
   
    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice Date raw` , DateRaw  ] )

    , check(string_string_replace( DateRaw, `-`, ` `, DateStrip  ))

    , trace( [ `Invoice Date Stripped Space`, DateStrip ] )
    
    , invoice_date(DateStrip )

    , trace( [ `Invoice Date` , invoice_date ] )  

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_1, [ 
%=======================================================================
	
	or([
        
        line_with_text(`תינובשחךיראת`)

      , line_with_text(`תינובשח ךיראת`)

        
] )
	
	, line_invoice_date

] ).

%=======================================================================
i_line_rule_cut( line_invoice_date, [ 
%=======================================================================
	
	generic_item( [ invoice_date, date, `:` ] ), q10(tab)
	
	, `תינובשח`,  `ךיראת`, gen_eof
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_2, [ 
%=======================================================================
	
      q0n(line)

    , or([

       generic_vertical_details( [ [`:`, `הספדה`,  `ךיראת`,  tab ], `ךיראת`, q(0,1,up), (start, 500,500), invoice_date_raw1, s, `:`] )

   ] )
   
    , check( invoice_date_raw1 = DateRaw1 )

    , trace( [ `Invoice Date raw` , DateRaw1  ] )

    , check(string_string_replace( DateRaw1, `/`, ` `, DateStrip1  ))

    , trace( [ `Invoice Date Stripped Space1`, DateStrip1 ] )
    
    , invoice_date(DateStrip1 )

    , trace( [ `Invoice Date1` , invoice_date ] )  

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_order_number, [
%=======================================================================

     q(0,50,line)

 , or( [

      find_order_number

   ])


] ).
 
%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

    q0n(anything)


, or( [
             [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("2"),1,1) , q(dec,8,10) , end ] ] ) ]
    ] )

 
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PO LINE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_po_line_number, [
%=======================================================================

     q(0,50,line)

 , or([
 
    generic_horizontal_details( [ [ dummy(date), tab, `LN`, `\\` ],  line_buyers_order_number,d, newline  ] )

 , generic_horizontal_details( [ [ dummy(date), tab, `LN`, `\\` ],  line_buyers_order_number,d, tab  ] ) 

 , generic_horizontal_details( [ [ `LN`, `\\` ],  line_buyers_order_number,d, q10(tab)  ] ) 
 
 ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_net_amount_hebrew, [
%=======================================================================

    q0n(line)

 , or([

      generic_horizontal_details( [ [ `USD`,  dummy(d),  tab, `ILS` ], total_net, d, [tab, `ללוכ`,  `ריחמ`,  tab ] ] )

    ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_vat_amount_hebrew, [
%=======================================================================

    q0n(line)

 , or([

      generic_horizontal_details( [ [ `USD`,  dummy(d),  tab, `ILS` ], total_vat, d, [ tab, `(`,generic_item( [ default_vat_rate,d ] ), `.`, `00`, `%`, `)` ] ] )
    
   ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_amount_hebrew, [
%=======================================================================

    q0n(line)

 , or([

      [generic_horizontal_details( [ [ `USD`,  dummy(d),  tab, `ILS` ], total_invoice, d, [  tab, `ריחמ`,  `כ`, `"`, `הס`,  tab ] ] )

      , generic_item( [ currency, `ILS` ] )]
    
   ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE TOTAL AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals, [
%=======================================================================


    line_with_text(`כ"הס`)
	
	 , line_total_net
	 
	 , q(0,1,line)
	 
	 , line_total_vat
	 
	  , q(0,1,line)
	 
	 , line_total_invoice	 

] ).


%=======================================================================
i_line_rule_cut( line_total_net, [
%=======================================================================

    generic_item( [ total_net, d, tab ] )
   
   ,`:`,  `כ`, `"`, `הס`,  newline
  
] ).

%=======================================================================
i_line_rule_cut( line_total_vat, [
%=======================================================================

    generic_item( [ total_vat, d, [ tab, `%`] ] )

  ,  generic_item( [ line_vat_rate_dummy, d, [ `מ`, `"`, `עמ`,  newline ] ] )

  , generic_item( [ default_vat_rate, `17`] )


] ).

%=======================================================================
i_line_rule_cut( line_total_invoice, [
%=======================================================================

    currency(`ILS`)
   
   , generic_item( [ total_invoice, d, tab ] )
   
   ,`:`, `ח`, `"`, `שב`,  `םולשתל`,  `כ`, `"`, `הס`,  newline
  
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
               

                 [ line_invoice_line_hebrew, q10(line_append_line) , q10(line_append_line), q10(line_append_line) ]

             , [ line_invoice_line_hebrew_1, q10(line_append_line) ]

             , [ line_invoice_line_hebrew_2, q10(line_append_line)  ]

              ,  [line_invoice_line_english, q10(line_append_line)]
              
              ,  [ line_invoice_line, q10(line_append_line) , q10(line_append_line) ]

               ,  [ line_invoice_line_1, q10(line_append_line) , q10(line_append_line) ]

                ,  [ line_invoice_line_english_1, q10(line_append_line) , q10(line_append_line) ]

              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([ 

        

         [`ח`, `"`, `שב`, `כ`, `"`, `הס`, tab, `ח`, `"`, `שב`, `'`, `חי`, `ריחמ`, tab ]

     , [`ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `הדיחיל`,  `ריחמ`,  tab ]

     , [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `תומכ`,  tab ]

     , [`ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `מ`, `"`, `עמ`,  `ללוכ`,  `'`, `חיל`,  `ריחמ`,  tab ]

     , [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  `מ`, `"`, `עמ`,  `ללוכ`,  `'`, `חיל`,  `ריחמ`,  `הדיחיל`,  `ריחמ`,  tab]

     ,  [ `ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `מ`, `"`, `עמ`,  `ללוכ`,  `'`, `חיל`,  `ריחמ`,  `הדיחיל`,  `ריחמ`,  tab ]

     , [ `ריחמ`,  tab, `מ`, `"`, `עמ`,  `ללוכ`,  tab, `רצומל`,  tab ]

     , [  `ריחמ`,  `כ`, `"`, `הס`,  tab, `רעש`,  tab, `הדיחיל`,  `ריחמ`,  `תומכ`,  tab ]

     , [  `מ`, `"`, `עמ`,  `ללוכ`,  tab, `הדיחיל`,  tab, `חוקל`,  `ט`, `"`, `קמ`,  newline ]



] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
   or([

       [`:`,  `כ`, `"`, `הס`,  newline ]

   % , [ dummy(d),  tab, dummy(d),  tab, dummy(s1),  tab, dummy(d),  newline ]
       
    , [ dummy(d), `ךותמ`, dummy(d), `דומע`,  newline]
      
   ,  [`P`, `.`, `O`, `.`, `Box`, `740`, `,`, `Hazoref`]
    
    , [dummy(s1),  tab, `:`,  `כ`, `"`, `הס`,  newline ]

  ] )
  
     , trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================


	  generic_item( [ line_net_amount, d, tab ] )
	
	, generic_item( [ line_unit_amount_dummy, s1, tab ] )

	, generic_item( [ dummy_value, d, tab ] )
  
	, generic_item( [ line_quantity_dummy, d, tab ] )

    , q10(generic_item( [ line_item, d, tab ] ))

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_delivery_note_number_dummy, s1, tab ] )

	, generic_item( [ dummy_line, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================


	  generic_item( [ line_net_amount, d, tab ] )
	
	, generic_item( [ line_unit_amount_dummy, s1, tab ] )
  
	, generic_item( [ line_quantity_dummy, d, tab ] )

    , q10(generic_item( [ line_item, d, tab ] ))

	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_descr_dummy, s1, tab ] )

	, generic_item( [ dummy_line, d, newline ] )


] ).

%=======================================================================
i_line_rule_cut( line_append_line, [
%=======================================================================

     q10(generic_append( [ line_descr, s1, tab, ` `, ` `  ] ))

  ,  generic_append( [ line_descr, s1, newline, ` `, ` `  ] )
  
] ).



%=======================================================================
i_line_rule_cut( line_invoice_line_english, [
%=======================================================================


	  generic_item( [ line_buyers_order_number_dummy, d, tab ] )
	
	, generic_item( [ line_item_dummy, s1, tab ] )

	, generic_item( [ line_item, s1, tab ] )
  
	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_quantity, d, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )

     , with( line , line_buyers_order_number_dummy , ORDLINE )
  
     , check(sys_calculate_str_multiply( ORDLINE, `10`, PO_ITEM )) 

     , generic_item( [ line_buyers_order_number , PO_ITEM ] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_hebrew, [
%=======================================================================


	  generic_item( [ line_net_amount, d, q10(tab) ] )
	
	, generic_item( [ currency_exchange_rate, d, [  q10(tab), `USD` ]] )

	, generic_item( [ line_dummy_usd, d,  `USD` ] )

    , generic_item( [ line_unit_amount_dummy,d ] )

    , generic_item( [ line_quantity_uom_code, w, q10(tab)  ] )

    , generic_item( [ line_quantity, d, q10(tab) ] )
     
  	, generic_item( [ line_descr, s1, tab ] )

    , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

    , generic_item( [ line_descr_dummy, s, q10(tab) ] )

    , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

    , generic_item( [ line_descr_dummy, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_hebrew_1, [
%=======================================================================


	  generic_item( [ line_net_amount, d, q10(tab) ] )
	
	, generic_item( [ currency_exchange_rate, d, [  q10(tab), dummy(w) ]] )

	, generic_item( [ line_dummy_usd, d,  [  q10(tab), dummy(w) ] ] )

    , generic_item( [ line_unit_amount_dummy,d ] )

    , generic_item( [ line_quantity_uom_code, w, q10(tab)  ] )

    , generic_item( [ line_quantity, d, q10(tab) ] )

    , generic_item( [ line_descr_dummy, s1, tab ] )

    , generic_item( [ line_descr, s, q10(tab) ] )

    , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

    , generic_item( [ line_descr_dummy, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_hebrew_2, [
%=======================================================================


	  generic_item( [ line_net_amount, d, q10(tab) ] )
	
	, generic_item( [ currency_exchange_rate, d, [  q10(tab), dummy(w) ]] )

	, generic_item( [ line_dummy_usd, d,  [  q10(tab), dummy(w)  ] ] )

    , generic_item( [ line_unit_amount_dummy,d ] )

    , generic_item( [ line_quantity_uom_code, w, q10(tab)  ] )

    , generic_item( [ line_quantity, d, q10(tab) ] )

    , generic_item( [ line_descr, s, q10(tab) ] )

    , generic_item( [ line_buyers_order_number, d, q10(tab) ] )

    , generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

    , generic_item( [ line_descr_dummy, s1, newline ] )

] ).
%=======================================================================
i_line_rule_cut( line_invoice_line_english_1, [
%=======================================================================


	  generic_item( [ line_dummy, w, q10(tab) ] )
	
	, generic_item( [ line_item_dummy, w, q10(tab) ] )

	, generic_item( [ dummy_po, [ begin, q(dec,10,10), end ], q10(tab) ] )

    , generic_item( [ line_buyers_order_number, d, q10(tab) ] )
  
	, generic_item( [ line_descr, s1, tab ] )

    , generic_item( [ line_item, s1, tab ] )

    , generic_item( [ line_quantity, d, `Ea` ] )

    , generic_item( [ line_quantity_dummy, d, [ `Ea`,  `USD` ] ] )
    
    , generic_item( [ line_unit_amount, d, tab ] )

    , generic_item( [ line_net_amount, d, newline ] )



] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 31 Jan, 2021
% Mapped by - Rohini 

% mapped regular mapping format since there was no freight/rounding off to map as per Globus International format

% Updated on   - 21 Feb, 2021
% Updated by   - Rohini
% Changes made - Invoice number and Invoice date updated


% Updated on   - 26 March, 2021
% Updated by   - Rohini
% Changes made - PO Line item number updated

% Updated on   - 31 March, 2021
% Updated by   - Rohini
% Changes made - PO Line item number updated

% Updated on   - 19 Oct, 2021
% Updated by   - Rohini
% Changes made - Line details updated with end line

% Updated on   - 03 Nov, 2021
% Updated by   - Rohini
% Changes made -  Invoice number and Invoice date updated

% Updated on   -  04 Nov, 2021
% Updated by   -  Rohini
% Changes made -  Mergred with  9000023578 and 9000158313 for  0026/0109, 0003

% Updated on   - 26 Aug,2022
% Updated by   - Sushmitha
% Changes made - updated line_invoice_line

% Updated on   - 26 Sep,2022
% Updated by   - Sushmitha
% Changes made - updated end line

% Updated on   - 07 Oct,2022
% Updated by   - Sushmitha
% Changes made - added set_credit_note and get_original_invoice_number

% Updated on   - 07 Nov, 2022
% Updated by   -  Rohini
% Changes made - End line updated

% Updated on   - 10 Nov,2022
% Updated by   - Sushmitha
% Changes made - updated get_original_invoice_number

% Updated on   - 11 Nov,2022
% Updated by   - Sushmitha
% Changes made - added get_original_invoice_number_1 and freezed

% Updated on   - 18 Nov 2022
% Updated by   - Sushmitha
% Changes made - updated line_invoice_line

% Updated on   - 23 Nov 2022
% Updated by   - Sushmitha
% Changes made - updated line_invoice_line

% Updated on   - 04 Oct 2023
% Updated by   - Yamini
% Changes made - updated original_invoice_number rule

% Updated on   - 31 Oct, 2023
% Updated by   -  Rohini
% Changes made - Line details mapped line_invoice_line_1

% Updated on   - 25 March, 2024
% Updated by   -  Rohini
% Changes made - Invoice format mapped for new format - sample Invoice #  SI246000459

% Updated on   - 26 March, 2024
% Updated by   -  Rohini
% Changes made -  get_invoice_date_2 mapped, Invoice number updated for Export Invoice, Total amount updated

% Updated on   - 28 March, 2024
% Updated by   -  Rohini
% Changes made - Invoice number updated

% Updated on   - 02 May, 2024
% Updated by   -  Rohini
% Changes made - Invoice number updated

% Updated on   - 31 May, 2024
% Updated by   - Rohini
% Changes made - Mapped Allocation number


% Updated on   - 19 June, 2024
% Updated by   -  Rohini
% Changes made - Invoice number updated


% Updated on   - 29 Aug, 2024
% Updated by   -  Rohini
% Changes made - Invoice number and Invoice date updated


% Updated on   - 23 Dec, 2024
% Updated by   -  Rohini
% Changes made - Line details updated english_1


% Updated on   - 02 Jan, 2025
% Updated by   -  Rohini
% Changes made - Line details updated 



% Updated on   - 14 April, 2025
% Updated by   -  Rohini
% Changes made - Line details updated  with start line


% Updated on   - 06 May, 2025
% Updated by   -  Rohini
% Changes made - Line details updated line_hebrew_1

% Updated on   - 12 June, 2025
% Updated by   -  Rohini
% Changes made - Line details updated with start line

% Updated on   - 28 nOV, 2025
% Updated by   -  Rohini
% Changes made - line_invoice_hebrew_2 mapped

% Updated on   - 
% Updated by   - 
% Changes made -

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  