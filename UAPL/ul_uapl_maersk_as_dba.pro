%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maersk A/S DBA Sealand Americas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_maersk_as_dba, `30 Aug, 2024` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%i_date_format(_).

i_date_format(_):- not( grammar_set( alternate_date_format ) ).

i_date_format(_):- grammar_set( alternate_date_format).

i_trace_lists.

i_include_partner_attachments_image_only.

i_pdf_parameter( dont_tokenise_on_font_change, 1 ).

i_pdf_parameter( x_tolerance_100, 100 ).

i_pdf_parameter( space, 2 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	  get_supplier_details

    , set_credit_note

    , get_currency

    , get_bank_account_no
	
	, get_invoice_number

	, get_invoice_date

    , get_invoice_date_1

   % , get_invoice_date_2

    , get_total_invoice

    , get_total_net

    , get_total_invoice_1
    
    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================================
i_rule_cut( get_supplier_details, [
%=======================================================================

	  sender_name(`Maersk A/S DBA Sealand Americas`)

    , supplier_party(`Maersk A/S DBA Sealand Americas`)

	, supplier_vat_number(`DK53139655`)

    , buyer_registration_number(`3009`)

    , set(freight_vendor)

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( set_credit_note, [
%=======================================================================

      q(0,50,line)

    , credit_note_line

   ] ).

%=======================================================================
i_line_rule( credit_note_line, [
%=======================================================================

     q0n(anything)

    , or([

        [`EXPORTCREDITNOTENumber` ]

    , [`IMPORTCREDITNOTENumber`]

    , [`CREDIT`, `NOTE`]

    , [`EXPORTCREDIT`]

    , [`IMPORTCREDIT` ]

    ])
    
    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

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

   , or([
       
          generic_horizontal_details( [ [ `EX`, `P`, `O`, `R`, `T`, `I`, `N`, `V`, `O`, `I`, `CE`, `N`, `u`, `m`, `b`, `e`, `r`, `:`, tab ], invoice_number, s1, newline ] )
        
        , generic_horizontal_details( [ [`EXPORT`,  `INVOICE`,  `Number`, `:`,  tab ], invoice_number, s1, newline ] )

        , generic_horizontal_details( [ [`Invoice`,  `Number`,  tab ], invoice_number, s1, newline ] )

        , generic_horizontal_details( [ [ `INVOICE`,  `Number`, `:`,  tab ], invoice_number, s1, newline ] )

        ,  generic_horizontal_details( [ [ `INVOICE`, `Number`, q10(`:`) ], 800, invoice_number, d, newline ] )

       , generic_horizontal_details( [ [ `Tax`, `Invoice`, q10(`:`) ], 800, invoice_number, d, newline ] )

       , generic_horizontal_details( [ [ `CREDIT`, `NOTE`, `Number`, `:`, tab ], 500, invoice_number, d, newline ] )

       , generic_horizontal_details( [ [ `Equipment`, `Maintenance`, `Invoice`, tab ],  invoice_number, d, newline ] )

       , generic_horizontal_details( [ [`IMPORT`, `CREDIT`, `NOTE`, `Number`, `:`, tab ],  invoice_number, d, newline ] )

       , generic_horizontal_details( [ [`EXPORT`, `INVOICE`, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORT`, `INVOICE`, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`EXPORT`, `CREDIT`, `NOTE`, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`EXPORTINVOICENumber`, `:` ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [ `EXPORT`, `INVOICE`, tab, `Number`, `:`, tab ],  invoice_number, s1, newline ] )
  
       , generic_horizontal_details( [ [ `DETENTION`, `CREDIT`, `NOTE`, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [ `TAX`, `IMPORT`, `CREDIT`, `NOTE`, `NUMBER`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORTINVOICENumber`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`EXPORTCREDITNOTENumber`, `:` ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORTCREDITNOTENumber`, `:` ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`EXPORTCREDIT`, q10(tab), `NOTENumber`, `:`],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORTCREDIT`, q10(tab), `NOTENumber`, `:`],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORT`, tab, `INVOICE`, tab, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [`IMPORT`, `INVOICE`, `Credit`, `Number`, `:`, tab ],  invoice_number, s1, newline ] )

       , generic_horizontal_details( [ [ `EXPORT`, `Credit`, `INVOICE`, `Number`, `:` ],  invoice_number, s1, newline ] )
   
            
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

          generic_horizontal_details( [ [`Invoice`,  `Date`, `:`,  tab ], invoice_date , date, newline ] )
 
    ] )
                , q10( [

          check( q_sys_sub_string( invoice_date, _, _, `.` ) )

          , set( alternate_date_format )

           ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE ALTERNATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_1, [
%=======================================================================

    q(0,20,line)

    , or([

          generic_horizontal_details( [ [`Invoice`,  `Date`,  tab ], invoice_date , date, newline ] )
 
    ] )
                , q10( [

          check( q_sys_sub_string( invoice_date, _, _, `,` ) )

          , set( alternate_date_format )

           ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE ALTERNATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_date_2, [
%=======================================================================

    q(0,20,line)

       , or([

          generic_horizontal_details( [ [`Invoice`,  `Date`,  tab ], invoice_date_raw , s1, newline ] )

       , generic_horizontal_details( [ [`Invoice`,  `Date`, `:`,  tab ], invoice_date_raw , s1, newline ] )
 
    ] )
         
         
      
 
    , check( invoice_date_raw = DateRaw )

    , trace( [ `Invoice Date Raw` , DateRaw ] )

    , check(string_string_replace( DateRaw, `,`, ``, DateStrip ))

    , trace( [ `Date Stripped Coma` , DateStrip ] )

    , invoice_date(DateStrip)

    , trace( [ `Invoice Date` , invoice_date ] )   

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

      generic_horizontal_details( [ [`Am`, `o`, `u`, `n`, `t`, `D`, `u`, `e`, tab ],total_invoice, d, newline ] )

   ,  generic_horizontal_details( [ [`Amount`,  `Due`,  tab ],total_invoice, d, newline ] )

  ] )
  
   , generic_item( [ currency, `USD` ] )

   , generic_item( [ line_descr , `Freight Charges` ] )
  
   , check( total_invoice = TotNet)

   , generic_item( [ total_net , TotNet ] )

   , generic_item( [ line_net_amount , TotNet ] )

   , generic_item( [ line_total_amount , TotNet ] )

   

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET NET INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

     q0n(line)

   , generic_horizontal_details( [ [`Total`,  `Base`,  `Amount`,  tab, generic_item( [ currency, w ] ),  tab ],total_net, d, newline ] )

    , check( total_net = TotNet1)

   , generic_item( [ line_net_amount , TotNet1 ] )

 
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice_1, [
%=======================================================================

     q0n(line)

   , generic_horizontal_details( [ [ `Total`,  `Payable`,  `Amount`,  tab, generic_item( [ currency, w ] ),  tab ],total_invoice, d, newline ] )
 
   , generic_item( [ line_descr , `Freight Charges` ] )
 
   , check( total_invoice = TotInv)

   , generic_item( [ line_total_amount , TotInv ] )


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

      generic_horizontal_details( [ [ `T`, `o`, `t`, `a`, `l`, `(` ], 100, currency,  w, [`)`,  newline ] ] )
    
   ,  generic_horizontal_details( [ [ `Total`, `(` ], currency,  w, [`)`,  newline ] ] )
   
  ] )  

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Mapped on  - 15 Feb,2023
% Mapped by  - Sushmitha

% Updated on   - 10 Nov, 2023
% Updated by   -  ROhini
% Changes made   - New format updated

% Updated on   - 16 Nov, 2023
% Updated by   -  Rohini
% Changes made   - Format mapped Invoice 7504971546

% Updated on   - 03 Dec, 2023
% Updated by   - Rohini
% Changes made   - Invoice number updated

% Updated on   -  24 Jan, 2024
% Updated by   -  Rohini
% Changes made   - i_pdf_parameter( space, X ). mapped

% Updated on   - 12 July, 2024
% Updated by   -  ROhini
% Changes made   - Total Invoice updated

% Updated on   - 
% Updated by   - 
% Changes made   - 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
