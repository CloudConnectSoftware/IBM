%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ODEM SCIENTIFIC APPLICATIONS LTD. / Mergerd mapping for V # 9000158311 and  9000025132
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version(amat_odem_scientific_english, `15 June 2022` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format(_).

i_trace_lists.

i_user_field( invoice, attachment_type, `attachmentType` ).  % This is a requirement

i_user_field( invoice, dummy_rounding_amount, `dummy_rounding_amount` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      get_supplier_detail

    , attachment_type(`LEGAL_INVOICE`)  % This is a requirement 

    , get_buyer_vat % required for CC 003

    , set_credit_note

    , get_invoice_number

    , get_original_invoice_number
    
    , get_invoice_date

    , get_invoice_date_2

    , get_order_number
 
    , get_total_net

    , get_total_discount

    %, get_total_vat

    , get_total_invoice

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

     sender_name( `ODEM SCIENTIFIC APPLICATIONS LTD.` )

   % Supplier VAT number - ` 512621020  %


] ).

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER VAT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_buyer_vat, [
%=======================================================================

       q(0,40,line)

     , check_text(`VAT` )

     , or([

       generic_horizontal_details( [ [`VAT`, `No`, `:`, tab ], buyer_vat_number, s1, newline ] )

     ,  generic_horizontal_details( [ [`VAT`, `Number`, `:`], buyer_vat_number, s1, newline ] )

    ] )
    
     , generic_item( [ buyer_tax_type, `VAT` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET CREDIT NOTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

    q(0,20,line)

    , credit_note_line

    
] ).
%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

    q0n(anything)

    , [`רוקמל`,  `ןמאנ`,  `קתעה`,  tab]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

     q(0,40,line)

     , or([

      generic_horizontal_details( [ [`Export`, `Invoice` ], invoice_number, s, [`-`, `Original` ] ] )

     , generic_horizontal_details( [ [`Export`, `Invoice` ], invoice_number, s, [`-`, `Copy` ] ] )

   
] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date, [
%=======================================================================

     q(0,40,line)

     , or([

        generic_horizontal_details( [ [`Date`, `:`, tab  ],invoice_date, date, newline ] )

      , generic_horizontal_details( [ [`Invoice`, `Date`, `:`  ],invoice_date, date, newline ] )


] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE FORMAT WITH SPLIT DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_2, [
%=======================================================================

%=======================================================================
  
     q(0,15,line)

   , line_date_line1

   , q(0,1,line)

   , line_date_line2

] ).

%=======================================================================
i_line_rule( line_date_line1, [
%=======================================================================

       q0n(anything)
     
     , read_ahead([`Invoice`, `Date`])

     , trace( [ `Found address`] )

     , generic_item( [ date_dummy, s, `:` ] )

     , generic_item( [ invoice_date_raw, s1, newline ] )


] ).

%=======================================================================
i_line_rule( line_date_line2, [
%=======================================================================

   generic_item( [ date_dummy1, s1, tab ] )

 , generic_append( [ invoice_date_raw, d, newline, `` ,`` ] )

  , check( invoice_date_raw = DateRaw )    , trace( [ `Date raw` , DateRaw ] )
 
  , invoice_date(DateRaw)  

  , trace( [ `Invoice Date` , invoice_date ] )

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

     , or([

       generic_horizontal_details( [ [ `Customer`, `order`, `number`, `:`, tab ], order_number,d, tab ] )

     , line_ordernumber
] )

] ).

%=======================================================================
i_line_rule( line_ordernumber, [
%=======================================================================

      q0n(anything)
    
      , or([

            [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("5"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("4"),1,1) , q(dec,8,10) , end ] ] ) ]

          , [ generic_item( [ order_number , [ begin, q(dec("4"),1,1) , q(dec("2"),1,1) , q(dec,8,10) , end ] ] ) ]
   

    ])
    
     
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL NET(English Lang)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_net, [
%=======================================================================

     q(0,40,line)

     , or([

       generic_horizontal_details( [ [`Total`, `Tax`, `Exempted`, tab, `$` ],total_net, d, newline ] )

     , generic_horizontal_details( [ [`TOTAL`, tab, `USD` ],total_net, d, newline ] )

 ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL DISCOUNT(English Lang)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_discount, [
%=======================================================================

     q(0,40,line)

     , or([

     [ test(credit_note), generic_horizontal_details( [ [`Discount`,   generic_item( [  dummy_rate, d ] ) , `%`,  tab, `$`,  `-` ],dummy_rounding_amount, d, newline ] )]

    , [ test(credit_note), generic_horizontal_details( [ [`Discount`, generic_item( [  dummy_rate, d ] ), `.`, `00`, `%`, tab, `$` ],dummy_rounding_amount, d, newline ] )]

   , generic_horizontal_details( [ [`Discount`,  generic_item( [  dummy_rate, d ] ), `.`, `00`, `%`,  tab, `$`,  `-` ],dummy_rounding_amount, d, newline ] )
    
    , generic_horizontal_details( [ [`Discount`, generic_item( [  dummy_rate, d ] ), `.`, `00`, `%`,  tab, `$` ],dummy_rounding_amount, d, newline ] )

] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL INVOICE(English Lang)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_invoice, [
%=======================================================================

     q(0,40,line)

     , or([

      [ generic_horizontal_details( [ [`Total`, `Due`, tab, `$` ],total_invoice, d, newline ] )

     , generic_item( [ currency,`USD`] )]

     ,[ generic_horizontal_details( [ [`TOTAL`, tab, `USD` ],total_invoice, d, newline ] )

     , generic_item( [ currency,`USD`] )]

  
] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOTAL VAT(English Lang)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_vat, [
%=======================================================================

     q(0,40,line)

     , generic_horizontal_details( [ [`Tax` ],total_vat, d, [`%`,  newline ] ] )

  
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


               [line_descr_line, line_invoice_line_english_7, line_append_line ]
                          
              , line_invoice_line_english_5

              , line_invoice_line_english_4

              , line_invoice_line_english_6

             , line_invoice_line_english_1
               
             , [line_invoice_line_english, line_po_line_english]

             , line_invoice_line_english_2

             , line_invoice_line_english_3


              , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    
    or([
      
        

       [`#`, tab, `Item`, `No`, `.`, tab, `Description`, tab ]

      , [ `Document`, tab, `Order`, tab, `Your`, `Order` ]

      , [`Document`, `Order`, tab, `Your`, `Order`, `Ln`, `Part`]

      , [`Document`,  tab, `Part`,  `Number`,  tab, `Part`,  `Description`,  tab ]

      , [`Your`, `Order`, `Ln`, tab ]
   
   

] )

    , trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================
     
     or([
       
       [`REHOVOT`, tab, `:` ]

     , [`TOTAL`, tab, `USD` ]

     , [`Due`, `by`, `:`, tab ]

     , [`Pay`, `by`, `:`]

 ] )
 
     , trace( [ `Found End line` ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line_english, [
%=======================================================================
   
    generic_item( [ line_reference, d, q10(tab) ] )

  , generic_item( [ line_item, s1, tab ] )

  , generic_item( [ line_descr, s1, tab ] )

  , generic_item( [ line_quantity, d, [ tab, `$`] ] )

  , generic_item( [ line_unit_amount_dummy, d, [ tab, `$` ] ] )

  ,  or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, tab ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, tab ] )
		
	] )

  , generic_item( [ line_reference_dummy, s1, newline ] )

  	, remove(dummy_rounding_amount)

  ] ).
%=======================================================================
i_line_rule_cut( line_po_line_english, [
%=======================================================================
   
   or([
     
     generic_item( [ line_reference_dummy, s, `line` ] )

  ,  generic_item( [ line_reference_dummy, s, [`\\`, `line`] ] )

  , generic_item( [ line_descr, s, [`\\`, `lline` ] ] )

   , generic_item( [ line_descr, s, [`\\`, `'`, `line` ] ] )

] )

 , generic_item( [ line_buyers_order_number_dummy1, d, newline ] )

  , with( line , line_buyers_order_number_dummy1 , PoLine1 )   

   , check(sys_calculate_str_multiply( PoLine1, `10`, PoLineNew1 )) , generic_item( [ line_buyers_order_number , PoLineNew1 ] )    

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line_english_1, [
%=======================================================================
   
    generic_item( [ line_reference, d, tab ] )

  , generic_item( [ line_item, s1, tab ] )

  , or([

    generic_item( [ line_descr, s, [`\\`, `LINE` ] ] )

  , generic_item( [ line_descr, s, [`\\`, `line`] ] )

  , generic_item( [ line_descr, s, [`\\`, `lline` ] ] )

  , generic_item( [ line_descr, s, [`\\`, `LONE` ] ] )

  , generic_item( [ line_descr, s, [`\\`, `POST ` ] ] )

  ,  generic_item( [ line_descr, s, [ `/`, `POST` ] ] )

  , generic_item( [ line_descr, s, [`\\`, `NUMBER` ] ] )

  , generic_item( [ line_descr, s, [`\\`, `'`, `line` ] ] )

  ,  generic_item( [ line_descr, s, [  `/`, `LINE` ] ] )

   

  ] )

  , or([

    generic_item( [ line_buyers_order_number_dummy1, d, tab ] )

  , generic_item( [ line_buyers_order_number_dummy1, d, [`)`,  tab] ] )

  ] )
    
    , generic_item( [ line_quantity, d, [ tab, `$`] ] )

  , generic_item( [ line_unit_amount_dummy, d, [ tab, `$` ] ] )

 , or( [  
   
		[
		
		with( invoice, dummy_rounding_amount, RoundingAmount )
		
		, generic_item( [ line_net_amount_x, d, tab ] )
		
		, check( sys_calculate_str_subtract( line_net_amount_x, RoundingAmount, LineNetAmount ) )
		
		, line_net_amount( LineNetAmount )
	
		
		]
		
		, generic_item( [ line_net_amount, d, tab ] )
		
	] )
	
  , generic_item( [ line_reference_dummy, w, newline ] )

  , remove(dummy_rounding_amount)

  , with( line , line_buyers_order_number_dummy1 , PoLine1 )   

   , check(sys_calculate_str_multiply( PoLine1, `10`, PoLineNew1 ))
   
   , generic_item( [ line_buyers_order_number , PoLineNew1 ] )    

  ] ).
%=======================================================================
i_line_rule_cut( line_po_line_1, [
%=======================================================================
   
   or([
     
      generic_append( [ line_descr, s, [`\\`, `line` ], ``, `` ] )

    , generic_append( [ line_descr, s, [`\\`, `LINE` ], ``, `` ] )

    , generic_append( [ line_descr, s, [`\\`, `lline` ] , ``, ``] )

    , generic_append( [ line_descr, s, [`\\`, `LINE` ] , ``, ``] )

    , generic_append( [ line_descr, s, [`\\`, `line` ] , ``, ``] )

    , generic_append( [ line_descr, s, [ `/`, `LINE` ] , ``, ``] )
    

 ] )
 
  , generic_item( [ line_buyers_order_number_dummy1, d, newline ] )

  , with( line , line_buyers_order_number_dummy1 , PoLine1 )   

   , check(sys_calculate_str_multiply( PoLine1, `10`, PoLineNew1 )) , generic_item( [ line_buyers_order_number , PoLineNew1 ] )    

] ).
%=======================================================================
i_line_rule_cut( line_po_line_2, [
%=======================================================================
   
  or([  
    
     generic_append( [ line_descr, s, [`/`, `LINE` ], ``, `` ] )

  ,  generic_append( [ line_descr, s, [`\\`, `line` ], ``, `` ] )

  , generic_append( [ line_descr, s, [ `/`, `LINE` ] , ``, ``] )

 ] )
 
  , generic_item( [ line_buyers_order_number_dummy1, d, newline ] )

  , with( line , line_buyers_order_number_dummy1 , PoLine1 )   

   , check(sys_calculate_str_multiply( PoLine1, `10`, PoLineNew1 )) , generic_item( [ line_buyers_order_number , PoLineNew1 ] )    

] ).




%=======================================================================
i_line_rule_cut( line_invoice_line_english_2, [
%=======================================================================
   
    generic_item( [ line_dummy, w ] )

  , generic_item( [ line_dummy, w ] )

  , generic_item( [ line_po_dummy, d ] )

  , generic_item( [ line_buyers_order_number, d ] )

  , generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

  , generic_item( [ line_quantity, d ] )

  , generic_item( [ line_quantity_uom_code, w, `USD` ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).


  %=======================================================================
i_line_rule_cut( line_invoice_line_english_3, [
%=======================================================================
   
    generic_item( [ line_dummy1, w ] )

  , generic_item( [ line_dummy2, w ] )

  , generic_item( [ line_po_dummy3, d ] )

  , generic_item( [ line_dummy4, d ] )

  , generic_item( [ line_buyers_order_number, d ] )

  
  , generic_item( [ line_dummy5, d ] )

  , generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

  , generic_item( [ line_quantity, d ] )

  , generic_item( [ line_quantity_uom_code, w, `USD` ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).

  %=======================================================================
i_line_rule_cut( line_invoice_line_english_4, [
%=======================================================================
 
    generic_item( [ line_reference_dummy, d ] )

  , generic_item( [ line_docno_dummy2, w ] )

  , generic_item( [ line_dummy4, w ] )

  , generic_item( [ line_po_number, d ] )

  , generic_item( [ line_buyers_order_number, d ] )

  , generic_item( [ line_descr, s1, tab ] )
 
  , generic_item( [ line_quantity, d ] )

  , generic_item( [ line_quantity_uom_code, w, `USD` ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).

  %=======================================================================
i_line_rule_cut( line_invoice_line_english_5, [
%=======================================================================


    q10(generic_item( [ line_reference_dummy, d ] ))

  , generic_item( [ line_docno_dummy2, s , q10(tab)] )

  , generic_item( [ line_dummy4, w , q10(tab)] )

  , generic_item( [ line_po_number, d, q10(tab) ] )

  , generic_item( [ line_buyers_order_number, d , q10(tab)] )

  , generic_item( [ line_descr, s1, tab ] )

  , q10(generic_item( [ line_descr_dummy, s1, tab ] ))

  , q10(generic_item( [ line_descr_dummy, s, q10(tab) ] ))

  , q10(generic_item( [ line_descr_dummy, s, q10(tab) ] ))
 
  , generic_item( [ line_quantity_dummy, d ] )

  , generic_item( [ line_quantity_uom_code, w, [q10(tab),`USD`] ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).


  %=======================================================================
i_line_rule_cut( line_invoice_line_english_6, [
%=======================================================================
   

    q10(generic_item( [ line_reference_dummy, d ] ))

  , generic_item( [ line_docno_dummy2, w , q10(tab)] )

  , generic_item( [ line_dummy4, w , q10(tab)] )

  , generic_item( [ line_po_number, d, q10(tab) ] )

  , generic_item( [ line_buyers_order_number, d , q10(tab)] )

  , generic_item( [ line_descr, s, q10(tab) ] )

  , q10(generic_item( [ line_descr_dummy, s1, tab ] ))
 
  , generic_item( [ line_quantity_dummy, d ] )

  , generic_item( [ line_quantity_uom_code, w, [q10(tab),`USD`] ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).
  %=======================================================================
i_line_rule_cut( line_invoice_line_english_7, [
%=======================================================================
   

    generic_item( [ line_reference_dummy, d ] )

  , generic_item( [ line_po_number, d, q10(tab) ] )

  , generic_item( [ line_buyers_order_number, d , q10(tab)] )

  , generic_item( [ line_item, s1, tab ] )
 
  , generic_item( [ line_quantity_dummy, d ] )

  , generic_item( [ line_quantity_uom_code, w, [q10(tab),`USD`] ] )

  , generic_item( [ line_unit_amount, d,  tab  ] )

	, generic_item( [ line_net_amount, d, newline ] )
 

  ] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================
   

     generic_item( [ line_descr, s1, tab ] )
 
  ,  generic_item( [ line_dummy, s1, newline ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on - 23 Sep, 2020
% Mapped by - Rohini 

% Updated on   - 25 Dec, 2020
% Updated by   - Rohini
% Changes made - Line details and Invoice totals updated 

% Updated on   - 1 Feb, 2021
% Updated by   - Rohini
% Changes made - Line details updated for Description

% Updated on   - 04 Feb, 2021
% Updated by   - Rohini
% Changes made - line_invoice_line_1 mapped

% Updated on   - 31 March, 2021
% Updated by   - Rohini
% Changes made - Negative Round off value captured as positive as per taulia 

% Updated on   - 08 April, 2021
% Updated by   - Rohini
% Changes made -  Credit note mapped and line_invoice_line_2 mapped


% Updated on   - 23 June, 2021
% Updated by   - Rohini
% Changes made - Original Invoice format udpated, line details updated


% Updated on   - 28 June, 2021
% Updated by   - Rohini
% Changes made -   Line buyers oder mapped from Line details as requested

% Updated on   - 02 Aug,2021
% Updated by   - Rohini
% Changes made - 003 format mapped (english)

% Updated on   - 13 Aug, 2021
% Updated by   - Rohini
% Changes made -  line_credit_line_1, line_po_line_1

% Updated on   - 24 Aug, 2021
% Updated by   - Rohini
% Changes made - LIne details line_invoice_line_4 updated and get_totals_1 mapped

% Updated on   - 26 Aug, 2021
% Updated by   - Rohini
% Changes made -line_invoice_line_5 mapped

% Updated on   - 07 Sep, 2021
% Updated by   - Rohini
% Changes made - Discount value mapped for English format

% Updated on   - 08 Sep, 2021
% Updated by   - Rohini
% Changes made - Line details updated for credit note

% Updated on   - 14 Sep, 2021
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 20 Sep, 2021
% Updated by   - Rohini
% Changes made - Line details updated


% Updated on   - 19 Oct, 2021
% Updated by   - Rohini
% Changes made - Line details updated for credit note

% Updated on   - 26 Oct,2021
% Updated by   - Rohini
% Changes made - Line details updated 


% Updated on   - 18 Nov, 2021
% Updated by   - Rohini
% Changes made - Line details updated



% Updated on   - 16 Dec, 2021
% Updated by   - Rohini
% Changes made - Line details updated for credit note and Invoice

% Updated on   - 30 Dec, 2021
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 12 Jan, 2022
% Updated by   - Rohini
% Changes made - Invoice format updated ( Invoice number - EI228000007  )

% Updated on   - 19 Jan, 2022
% Updated by   - Sushmitha
% Changes made - Invoice number, total invoice,to_net_tot_vat


% Updated on   - 25 Jan 2022
% Updated by   - Sushmitha
% Changes made - updated end line , english_4

% Updated on   - 26 jan 2022
% Updated by   - Sushmitha
% Changes made - updated first & last line



% Updated on   - 3 feb 2022
% Updated by   - Sushmitha
% Changes made - added line_invoice_line_12

% Updated on   - 10 Feb, 2022
% Updated by   - Rohini
% Changes made - Invoice number and line details updated for English Format, line_invoice_line_english_5, line_invoice_line_english_4

% Updated on   - 14 Feb, 2022
% Updated by   - Rohini
% Changes made - Line details updated

% Updated on   - 15 Feb, 2022
% Updated by   - Rohini
% Changes made -line_invoice_line_hebrew_1 mapped for format Invoice SI226000457 with confirmation from AMAT

% Updated on   - 01 March, 2022
% Updated by   - Rohini
% Changes made - Line details updated with start line

% Updated on   - 07 March, 2022
% Updated by   - Rohini
% Changes made -line_invoice_line_new, quantity and po line item hardcoded to 1 as per email 

% Updated on   - 09 March, 2022
% Updated by   - Rohini
% Changes made - Line details updated line_invoice_line_new_1



% Updated on   - 09 March 2022
% Updated by   - Sushmitha
% Changes made - added line_invoice_line_new_3


% Updated on   - 01 June 2022
% Updated by   - Sushmitha
% Changes made - updated header line

% Updated on   - 13 June 2022
% Updated by   - Sushmitha
% Changes made - updated invoice number

% Updated on   - 15 June 2022
% Updated by   - Sushmitha
% Changes made -updated line_total_vat_new_1

% Updated on   - 23 June, 2022
% Updated by   - Rohini
% Changes made - Invoice date get_invoice_date_2 mapped, [line_descr_line, line_invoice_line_english_7, line_append_line] mapped

% Updated on   - 
% Updated by   -
% Changes made -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%