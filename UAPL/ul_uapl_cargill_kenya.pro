%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GRAMATICA - CARGILL KENYA LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_cargill_kenya, `19/09/2017` `12:21:00` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

    , get_bank_accountnumber

    , set_credit_note
	
	, get_invoice_number
	
	, get_invoice_date

    , get_order_number

     , get_currency

    , get_invoice_lines

     , get_total_invoice
    
        
       ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================
   
  
   sender_name(`CARGILL KENYA LTD`)

   , supplier_vat_number(`0014166A`)

      
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


    , [`Credit`, `Note`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPPLIER BANK ACCOUNT DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bank_accountnumber, [
%=======================================================================

    qn0(line)

    ,generic_horizontal_details( [ [ `Account`, `number`, `:`, tab ],  supplier_bank_account_number, w, newline ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q(0,20,line)

   , generic_horizontal_details( [ [ q10(`Invoice`), `No`, `.`, q10(tab) ],  invoice_number, s1, newline ] )
	
	
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

    , or([
        generic_horizontal_details( [ [`Date`, `:`, q10(tab) ], invoice_date, date, newline ] )

        , generic_horizontal_details( [ [`Date`, `:`, q10(tab) ], invoice_date, date, `-` ] )

    ])
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

    , generic_horizontal_details( [ [ `Purchase`, `Order`, `No`, `.`, tab ], order_number, d, newline ] )

    , check(order_number = OrdNo)

    , trace([`Order Number Capital Varaible` , OrdNo])

    , line_buyers_order_number(OrdNo)

    , trace( [ `THIS IS NOW THE LINE ORDER Number` , order_number ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_currency, [
%=======================================================================

    q0n(line)

    
    , generic_vertical_details( [ [ `Value` ], `Value`, q(0,1), (start,10,10), currency, w, newline ] )

]).


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

            line_invoice_line_1

           , [line_invoice_line, q10(line_invoice_line2)]

            %, line_invoice_line4

            , line_invoice_line_new

            , line_invoice_line_po

            , line_invoice_line3

            , line

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================


    or( [

    
    [`Garden`, `Mark` ]

    , [`Description`, tab, `Value`]

    , [`Movement`, `No`, `.`, `/`, `PO`, `No`]

    , [`PO`, `No`, tab, `Supplier`]
    
    , [`Cargill`, `Kenya`, `Limited`]
    

        
      ] )

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    or( [

    [`Cargill`, `Kenya`, `Limited`]

    ,[`Please`, `remit`, `to` , `below` , `bank acccount`]

    ,[ `VAT`, `@`]

    ,[ `Total`, `invoice`]

    , [`Garden`, `Mark` ]

    , [`Total`, `Invoice`, `Value`, tab]

    ] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

     generic_item( [ line_descr, s1, tab ] )

    , generic_append( [ line_descr, s1, tab, ` - `, ` `  ] )
    
    , generic_append( [ line_descr, s1, tab, ` - `, ` `  ] )   

    , generic_item( [line_quantity , d , tab  ] )

    , generic_item( [line_kg_net ,d, tab ] )

    , generic_item( [line_unit_amount_dummy , d , tab ] )

    , q10( generic_item( [line_unit_amount_dummy_2 , d , tab ] ) )

    , generic_item( [line_net_amount , d , newline ] )

]).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

     generic_item( [ line_descr, s1, tab ] )

    , generic_item( [line_net_amount , d , newline ] )

]).

%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================

     generic_item( [ line_descr, s1, tab ] )

     , q10(generic_append( [ line_descr, s1, tab, ` - `, ``  ] ))

    , generic_item( [line_net_amount , d , newline ] )

]).



%=======================================================================
i_line_rule_cut( line_invoice_line3, [
%=======================================================================

       generic_item( [ line_descr, s1, tab ] )

     ,generic_item( [ line_descr_1, s1, tab ] )
    
     ,generic_item( [ line_descr_2, s1, tab ] )

     , generic_item( [ line_amount_dummy, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )

]).

%=======================================================================
i_line_rule_cut( line_invoice_line_po, [
%=======================================================================

       generic_item( [ line_buyers_order_number, s1, tab ] )

     ,generic_item( [ line_descr, s1, tab ] )
    
     ,generic_append( [ line_descr, s1, tab, ` - `, ``  ] )

     , generic_item( [ line_amount_dummy, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )

]).

%=======================================================================
i_line_rule_cut( line_invoice_line_new, [
%=======================================================================

      generic_item( [ line_descr, s1, tab ] )

     ,generic_item( [ line_descr, s1, tab ] )
    
     ,generic_append( [ line_descr, s1, tab, ` - `, ``  ] )

     , generic_item( [ line_amount_dummy, d, tab ] )

     , generic_item( [ line_unit_amount, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )

]).


%=======================================================================
i_line_rule_cut( line_invoice_line_1, [
%=======================================================================

      generic_item( [ line_descr, s1, tab ] )

    , generic_append( [ line_descr, s1, tab, ` - `, `` ] )
    
    , generic_append( [ line_descr, s1, tab, ` - `, ``  ] )

    , generic_item( [ line_year_dummy, d,tab ] )
   
    , generic_item( [ line_month_dummy, s1, tab ] )
  
    , generic_item( [ line_amount_dummy, d, tab ] )

     , generic_item( [ line_net_amount, d, newline ] )

]).



%=======================================================================
i_line_rule_cut( line_invoice_line4, [
%=======================================================================

     generic_item( [ line_descr, s1, tab ] )

]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================
    
     last_line
     
    , q(0,500,up)
   
    , or([

   
      generic_vertical_details( [ [ `Cargill`, `Kenya`, `Ltd` ], `Ltd`, q(0,2,up), (end,750,800), total_invoice, d,newline ] )

    , generic_vertical_details( [ [ `Please`, `remit`, `to`, `below`, `bank`, `acccount` ], `acccount`, q(0,2,up), (start,0,1000), total_invoice, d,newline ] )

    , generic_vertical_details( [ [ `P`, `.`, `O`, `.`, `Box` ], `Box`, q(0,1,up), (start,0,1000), total_invoice, d,newline ] )
      
   % ,generic_vertical_details( [ [ `Cargill`, `Kenya`, `Limited` ], `Limited`, q(0,2,up), (end,750,800), total_invoice, d,newline ] )
    
  
    
    ])
     
    , check( total_invoice = TotInv )

        , trace( [ `Total Inv` , TotInv] )

        , total_net(TotInv)

        , trace( [ `Total net` , total_net ] )

        


] ).
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL


% Updated on   - December 12, 2017
% Updated by   - Rohini
% Changes made - Line details mapped

% Updated on   - May 11, 2018
% Updated by   - Roopesh
% Changes made - added line for capture invoice total


% Updated on   - Aug 21, 2018
% Updated by   - Rohini
% Changes made - Total amount

% Updated on   - Nov 7, 2018
% Updated by   - Rohini
% Changes made - Line level data

% Updated on   - Nov 13, 2018
% Updated by   - Rohini
% Changes made - Line level data

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

