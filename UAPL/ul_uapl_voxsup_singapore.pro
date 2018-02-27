%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Voxsup (Singapore) Pte Ltd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_voxsup_singapore, `10 August 2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_pdf_parameter( dont_tokenise_on_font_change, 1 ). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
      get_supplier_details

    , get_bank_accountnumber
                     
    , get_invoice_number
    
    , get_invoice_date

    , get_due_date

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
i_rule( get_supplier_details, [
%=======================================================================
   
  
    sender_name(`Voxsup (Singapore) Pte Ltd`)

   , supplier_vat_number(` 201129524M`)

   , buyer_registration_number(`3009`)

      
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_bank_accountnumber, [
%=======================================================================

    q(0,40,line)
    
    , generic_horizontal_details( [ [`Account`, `No`, `.`, `:`], supplier_bank_account_number_raw, s1, tab ] )

    ,check(supplier_bank_account_number_raw=AccRaw)

    ,check(AccRaw=`641-736236-001`)

    ,supplier_bank_account_number(`736236001`), trace( [ `Supplier account number `, supplier_bank_account_number] )

   
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

     q(0,10,line)

    , generic_horizontal_details( [ [`INVOICE`, `#`, `:` ],  invoice_number, s1, newline ] )


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

     q(0,10,line)

    , generic_horizontal_details([ [`Date`, `:` ], invoice_date, date, newline  ])


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ORDER NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_order_number, [
%=======================================================================

   q(0,100,line)

   , find_order_number

] ).


%=======================================================================
i_line_rule_cut( find_order_number, [
%=======================================================================

     q0n(anything)

    , generic_item( [ order_number , [ begin, q(alpha("D"),1,1) , q(alpha("O"),1,1) , q(dec,5,15) , end ] ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

    q(0,50,line)

    ,generic_horizontal_details( [ [`SUBTOTAL`, tab, `$`, dummy_num, tab, generic_item( [ currency,w ] ) ], total_net, d, newline ] )


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE VAT AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%=======================================================================
    i_rule(get_total_vat, [
%=======================================================================
    
    q(0,50,line)

  ,generic_horizontal_details( [ [`GST`, `7`, `%`, tab, `$`, dummy_num1, tab, dummy_num2],total_vat, d, newline ] )

  , or([

     [ check( q_sys_comp_str_le( total_vat, `0` ) ) , generic_item( [ default_vat_rate, `0` ] )  ]

   ,  generic_item( [ default_vat_rate, `7` ] )

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
    
    q(0,50,line)

 ,generic_horizontal_details( [ [`TOTAL`, tab, `$`, dummy_num3, tab, dummy_num4 ],total_invoice, d, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [
              
          

               [line_append_descr1, line_append_descr2, line_invoice_line1, q10(line_append_descr3)]

              , [line_descr_line1, line_append_descr3,line_invoice_line2 ]

              , [line_descr_line1,line_append_descr2, line_invoice_line2 ]
              
              ,[line_descr_line, line_append_descr, line_invoice_line1]

              ,[line_descr_line1,line_invoice_line3, line_descr_line3]

              ,[line_descr_line1, q10(line_append_descr_1), q10(line_append_descr1), line_invoice_new , q10(line_append_descr1) , line_invoice_tot_line1,q10(line_append_descr_1)]
           
              ,[line_descr_line, line_append_descr, line_invoice_line,line_append_descr,line_invoice_tot_line1]

              , [line_descr_line1,q10(line_append_descr_1),q10(line_append_descr_1), line_invoice_line3,line_append_descr3,q10(line_append_descr_1),line_invoice_tot_line1 ]
            
            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

[ `ITEM`, `#`, tab, `DESCRIPTION`, tab ]

, trace( [ `Found Start line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

  
[`SUBTOTAL` ]

, trace( [ `Found End line` ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

trace( [ `line_invoice_line` ] )

 , q10(generic_item( [ line_item,s1, tab ] ))

,q10(generic_item( [ line_descr, s1, tab ] ))

,q10(generic_item( [line_descr_dummy, s1, tab ] ))

,generic_item( [ line_service_period, s1, tab ] )

,generic_item( [ line_quantity, d, tab ] )

,generic_item( [ line_unit_amount, d, [tab, q10(`$`)] ] )

,generic_item( [ line_net_amount, d, newline ] )



] ).

%=======================================================================
i_line_rule_cut( line_descr_line, [
%=======================================================================

trace( [ `Started line_descr_line` ] )

 ,q10(generic_item( [ line_descr, s1, tab ] ))

 ,q10(generic_append( [ line_descr_dummy, s1, tab , `, `, ` `  ] ))

 , generic_append( [ line_descr, s1, newline, `, `, ` `  ] )

] ).

%=======================================================================
i_line_rule_cut( line_descr_line1, [
%=======================================================================

trace( [ `started line_descr_line1` ] )

 ,generic_item( [ line_descr, s1, newline ] )
 
] ).

%=======================================================================
i_line_rule_cut( line_append_descr, [
%=======================================================================

 trace( [ `Started line_append_descr` ] )

,generic_append( [ line_descr, s1, tab, `, `, ` `  ] )

, q10(generic_append( [ line_descr, s1, tab, `, `, ` `  ] ))

, q10(generic_append( [ line_descr_dummy1, s1, tab, `, `, ` `  ] ))

, generic_item( [ line_dummy, s1, newline ] )



] ).


%=======================================================================
i_line_rule_cut( line_invoice_line1, [
%=======================================================================

trace( [ `Started line_invoice_line1` ] )

 ,generic_item( [ line_quantity, d, tab ] )

,generic_item( [ line_unit_amount, d, tab ] )

,generic_item( [ line_net_amount, d, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

trace( [ `Started line_invoice_line2` ] )

,q10(generic_item( [ line_descr_dummy2, s1, tab ] ))

,generic_item( [ line_quantity, d, tab ] )

,generic_item( [ line_unit_amount, d, [tab, `$`] ] )

,generic_item( [ line_net_amount, d, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_append_descr1, [
%=======================================================================

  trace( [ `Started line_append_descr1` ] )

  ,generic_append( [ line_descr, s1, tab, `, `, ` `  ] )

 ,generic_append( [ line_descr, s1, newline, `, `, ` `  ] )


] ).

%=======================================================================
i_line_rule_cut( line_append_descr_1, [
%=======================================================================

  trace( [ ` Started line_append_descr_1` ] )

  ,generic_append( [ line_descr, s1, newline, `, `, ` `  ] )


] ).

%=======================================================================
i_line_rule_cut( line_append_descr2, [
%=======================================================================

 trace( [ ` Started line_append_descr2` ] )

 ,generic_item( [ line_dummy2, s1, tab ] )
 
 ,generic_item( [ line_dummy3, s1, tab ] )
 
 ,generic_append( [ line_descr, s1, tab, `, `, ` `  ] )

 ,generic_append( [ line_descr, s1, newline, `, `, ` `  ] )


] ).


%=======================================================================
i_line_rule_cut( line_append_descr3, [
%=======================================================================

 trace( [ ` Started line_append_descr3` ] )

  ,generic_item( [ line_dummy2, s1, tab ] )
 
 , generic_item( [ line_dummy3, s1, tab ] )
 
 , generic_append( [ line_descr, s1, newline, `, `, ` `  ] )




] ).

%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

trace( [ ` Started line_invoice_line3` ] )

,generic_item( [ line_item,s1, tab ] )

,q10(generic_append( [ line_descr, s1, tab, `, `, ` `  ] ))

,generic_item( [ line_service_period, s1, tab ] )

,generic_item( [ line_quantity, d, tab ] )

,generic_item( [ line_unit_amount, d, [tab, q10(`$`)] ] )

,generic_item( [ line_net_amount, d, newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_descr_line3, [
%=======================================================================

trace( [ ` Started line_descr_line3` ] )

, generic_append( [ line_descr, s1, tab, `, `, ` `  ] )

, generic_item( [ line_dummy_currency, s1, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_new, [
%=======================================================================

trace( [ ` Started line_invoice_new` ] )

,generic_item( [ line_item_dummy,s1, tab ] )

,generic_append( [ line_descr, s1, tab, `, `, ` `  ] )

,generic_item( [ line_unit_amount, d, tab ] )

,generic_item( [ line_quantity, d, tab ] )

,generic_item( [ line_net_amount, d, tab ] )

,generic_item( [ line_currency, w, newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_tot_line1, [
%=======================================================================

trace( [ ` Started line_invoice_tot_line1` ] )

 ,q10(generic_append( [ line_descr, s1, tab, `, `, ` `  ] ))

 ,generic_item( [ line_descr_dummy3, s1, tab ] )

,generic_item( [ line_net_amount_dummy, d, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Updated on   - November 1, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format


% Updated on   - November 2, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format

% Updated on   - November 9, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format

% Updated on   - December 1, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format

% Updated on   - December 8, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format

% Updated on   - December 15, 2017
% Updated by   - Rohini 
% Changes made - Line details updated for new format

% Updated on   - December 29, 2017
% Updated by   - Thejaswi K
% Changes made - Line details updated for new format

% Updated on   - January 05, 2017
% Updated by   - Thejaswi K
% Changes made - Line details updated for new format


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 