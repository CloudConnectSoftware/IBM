%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - WAN HAI INTERNATIONAL PTE LTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_wan_hai, `16 Dec, 2020` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

    , set_credit_note
	
	, get_invoice_number

 	, get_invoice_date

	, get_total_net

    , get_total_vat

    , get_total_invoice

    , get_currency

    , get_bank_accountnumber

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
  
      sender_name(`WAN HAI INTERNATIONAL PTE LTD`)

	   , supplier_vat_number(`M2-0109131-4`)	

       , set(freight_vendor)

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


    , [`CREDIT`, `NOTE`]

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

    
    q0n(line)

    ,or([
           generic_horizontal_details( [ [ `INVOICE`, `NO`, `.`, tab, `:` ], 100, invoice_number, s, newline ] ) 

         , generic_horizontal_details( [ [ `B`, `/`, `L`, `No`, `:`, `:` ], 100, invoice_number,w, tab ] ) 

         , generic_horizontal_details( [ [ `Tax`, `Invoice`, `No`, `:`, tab ], invoice_number, s, newline ] ) 
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

 q0n(line)

    ,or([

        generic_horizontal_details( [ [`INVOICE`, `DATE`, tab, `:` ],  invoice_date, date, newline ] )

        ,generic_horizontal_details( [ [`OB`, `DATE`, `:` ],  invoice_date, date, newline ] )

        ,generic_horizontal_details( [ [`Date`, `:`, tab ],  invoice_date, date, newline ] )

     ])
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

    q0n(line)

    ,or([ [generic_horizontal_details( [ [ `TOTAL`, `(`, `$`, `)`, tab ], total_net, d, tab ] )

          ,[set(regexp_allow_partial_matching)
          
          ,generic_horizontal_details( [ [ `TOTAL`,tab, `cny` ], total_net, d, tab ] )


          ,clear(regexp_allow_partial_matching)]]

          
          ,generic_horizontal_details( [ [ `GRAND`, `TOTAL`, tab ], total_net, d, newline ] )

          ,generic_horizontal_details( [ [ `TOTAL`, `(`, `$`, `)`, tab ], total_net, d, newline ] )
    ])  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_vat, [
%=======================================================================

    q0n(line)

    , or([

    generic_horizontal_details( [ [ `GST`, tab ], total_vat, d, tab ] )
    
    , generic_horizontal_details( [ [ `GST`, tab ], total_vat, d, newline ] )

 ] )   
] ).


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
        generic_horizontal_details( [ [ `GRAND`, `TTL`, `(`, `$`, `)`, tab ], total_invoice, d, tab ] )

        ,[set(regexp_allow_partial_matching) ,generic_horizontal_details( [ [ `TOTAL`,tab, `cny`,net_dummy(d), tab, `CNY` ], total_invoice, d, newline ] )  ,clear(regexp_allow_partial_matching)]

         ,generic_horizontal_details( [ [ `GRAND`, `TOTAL`, tab ], total_invoice, d, newline ] )

         ,generic_horizontal_details( [ [ `GRAND`, `TTL`, `(`, `$`, `)`, tab ], total_invoice, d, newline ] )
    ])
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

     , or([
         
    generic_horizontal_details( [ [  `AMOUNT`, `(`  ], currency, w, [`)`,newline ] ])

   ,  generic_horizontal_details( [ [ `AMOUNT`, `(`,q10(tab) ], currency, w, [`)`,tab ] ])

   , generic_vertical_details( [ [`Description`, tab, `Amount`],`Amount`, q(0,1), (start,300,500), currency, w, newline ] )

  ])

] ).

       
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(get_bank_accountnumber, [
%=======================================================================


    q0n(line)

    , with( invoice, currency, Currency )

    ,trace( [ `currency is`, Currency ] )

    , or([
        [check( Currency = `USD` ) ,generic_horizontal_details( [ [`Swift`, `Code`, `:`, `CITISGSG`, tab ], supplier_bank_account_number_raw, w, [`(`, `USD`, `)`] ] )

    ,check(supplier_bank_account_number_raw=AccRaw)

    ,check(strip_string2_from_string1( AccRaw, `-`, AccNew ))

    ,supplier_bank_account_number(AccNew), trace( [ `Supplier account number without special characters`, supplier_bank_account_number] )]

    , [check( Currency = `SGD` ) ,generic_horizontal_details( [ [`Citibank`, `N`, `.`, `A`, `.`, `Singapore`, tab ], supplier_bank_account_number_raw, w, [`(`, `SGD`, `)`] ] )

    ,check(supplier_bank_account_number_raw=AccRaw)

    ,check(strip_string2_from_string1( AccRaw, `-`, AccNew ))

    ,supplier_bank_account_number(AccNew), trace( [ `Supplier account number without special characters`, supplier_bank_account_number] )]

    ])
    

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - December 29, 2017
% Updated by   - Rohini
% Changes made - Credit note mapped


% Updated on   - 16 Dec, 2020
% Updated by   - Rohini
% Changes made - Invoice amount details updated

% Updated on   - 
% Updated by   -
% Changes made - 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

