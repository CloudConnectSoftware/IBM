%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - AMERICOLD NZ LIMITED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_americoldnz, `18/01/2017 09:16:05` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.

i_include_partner_attachments_image_only.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

	,get_bankdetails

	, get_Invoice_tax

	, set_credit_note

	, get_invoice_number
	
	, get_invoice_date

	, get_invoice_net

	, get_invoice_totals

	, get_total_vat

	, get_currency

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

	sender_name(`AMERICOLD NZ LIMITED`)
	
	, supplier_vat_number(`714139`)

	, buyer_registration_number(`NZ00`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET BANK DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_bankdetails, [
%=======================================================================

	q(10,60,line)

	, generic_horizontal_details( [ [ `BSB`, `/`, `Account`, `Number`, tab, `02`, `-`, `0214`], 100,  supplier_bank_account_number_raw, s1, newline  ] )

    ,check(supplier_bank_account_number_raw=SupplierAccount)

    , check(strip_string2_from_string1( SupplierAccount, `-`, SupplierAccount1 ))

    ,supplier_bank_account_number(SupplierAccount1), trace( [ `New Bank`, supplier_bank_account_number ] )
	

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET CREDIT NOTE
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


    ,`CREDIT`, `NOTE`

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TAX INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_Invoice_tax, [
%=======================================================================


    q(0, 10, line)
    
    , invoice_tax_line

] ).

%=======================================================================
i_line_rule( invoice_tax_line, [
%=======================================================================

q0n(anything)

	,`Tax`, `Invoice`, `/`, `(`, `Adjustment`, `Note`, `)`

	, set(tax_invoice)

	, trace( [ `Found Tax Invoice` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_number, [
%=======================================================================

	q(0,30,line)

	, or([
        
		 generic_horizontal_details( [ [`Invoice`, q10(`number`), `:`, tab ],  invoice_number, w, or([ tab, newline ]) ] )
        
		, generic_horizontal_details( [ [`Invoice`, `number`, `the`, `credit`, `note`, `relates`, `to`, `:`, tab ],  invoice_number, w, newline ] )

	    , generic_vertical_details( [ [ `Invoice` , `No` , `.` ,  tab  ], `Invoice`, q(0,1), (end,10,10), invoice_number, w , tab ] )

	    , generic_vertical_details( [ [ `Document`, `No`, `.`, tab  ], `Document`, q(0,1), (end,10,10), invoice_number, w , tab ] )

	
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

	q(0,30,line)

	, or([
        
      generic_horizontal_details( [ [ `Date`, `:` , q10(tab)],  invoice_date, s1, or([ tab, newline ])  ] )

	, generic_vertical_details( [ [ `Date` , tab ], `Date`, q(0,1), (start,10,10), invoice_date, date , tab ] )

	])

	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_net, [
%=======================================================================

	q0n(line)

	, or([
        
        generic_horizontal_details( [ [ `Sub`, `Total` ], total_net , d , newline ] )

		, generic_horizontal_details( [ [ `Total` , `For` , `Invoice`, tab , `$`], 100 , total_net, d, q10(tab) ] )

	    , generic_horizontal_details( [ [ `Total` , `Taxable` , `Amount`, tab , `$`], 100 , total_net, d, newline ] )


	])

		
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE TOTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_invoice_totals, [
%=======================================================================

	q0n(line)

	, or([
        
        generic_horizontal_details( [ [ `TOTAL`, `Credit` ], total_invoice , d , newline ] )

	    , generic_horizontal_details( [ [ `Total`, `Including`, `any`, `Goods`, `&`, `Services`, `Tax`, `(`, `in`, `NZD`, `)`, tab, `$`], total_invoice, d ] )

	   , generic_horizontal_details( [ [ `Total` , `Invoice` , `Payable`, tab , `$` ,tab ], total_invoice, d, `NZD`  ] )

	   , generic_horizontal_details( [ [ `TOTAL`, `INVOICE`, `AMOUNT`, tab , `$` ,tab ], total_invoice, d, `NZD`  ] )

	   , generic_horizontal_details( [ [ `TOTAL`, `INVOICE`, `AMOUNT`, tab , `$` ,tab ], total_invoice, d, `NZD`  ] )

	])
	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE TOTAL VAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_total_vat, [
%=======================================================================

	q0n(line)

	, or([
        
         generic_horizontal_details( [ [ `GST`], total_vat , d , newline ] )

		, generic_horizontal_details( [ [ `Plus`, `15`, `%`, `Goods`, `&`, `Services`, `Tax`, tab, `$` ], 100, total_vat, d ] )

	    , generic_horizontal_details( [ [ `Total` , `GST` , `AMOUNT`, tab , `$` ], 100, total_vat , d, newline ] )
	
	])

	, generic_item( [ default_vat_rate, 15 ] )
	
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE CURRENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_cut( get_currency, [
%=======================================================================

	q0n(line)
	
	, or([

	  generic_horizontal_details( [ [ `Total` , `Invoice` , `Payable`, tab , `$` , tab , [generic_item( [ total_invoice_dummy , d  ] )] ], 100 , currency , w , newline ] )

   , generic_horizontal_details( [ [ `TOTAL`, `INVOICE`, `AMOUNT`, tab , `$` , tab , [generic_item( [ total_invoice_dummy , d  ] )] ], 100 , currency , w , newline ] )

	])

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

	line_start_line
	
	, qn0( [ peek_fails(line_end_line)
		
		, or( [


			line_credit_note_new

			, line_credit_note
					
			, line_invoice_line

			, line_invoice_line2
			
			, line
			
		] )
	
	] )

] ).

%=======================================================================
i_line_rule_cut( line_start_line, [
%=======================================================================
	
	or([

	  [`Charge`, `Code`, `Charge`, `Description`, tab, `Charge`, `Units`, tab, `Invoice`, `Units`, tab, `Charge`, `Price`, tab, `GST`,  newline ]

	  , [`Charge`, `Code`, tab, `Quantity`, tab, `Charge`, `Rate`, tab, `Charge`, `Description`]

	  , [`27`, `Dalgety`, `Drive`, tab, `NZB` ]

	  , [`CREDIT`, `NOTE`, `FOR`, `INV`]

	])

	, trace( [ `FOUND LINE HEADER LINE`])

] ).


%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

	 or([

		 [`Total`, `for`, `Invoice`, tab, `$`]
		 
		 , [`TOTAL` , `TAXABLE` , `AMOUNT` , tab , `$` , tab ]

		 , [`Sub`, `Total`]

	 ])

    , trace( [ `FOUND LINE END LINE`] )

] ).


%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

	generic_item( [ line_charge , d, tab ] )

	, generic_item( [ line_descr , s1, tab ] )

	, q10( generic_item( [ line_dummy , s1 , tab ] ))

	, q10(generic_item( [ line_uom , w, tab ] ))

	, generic_item( [ line_quantity , d , [tab , `$` , tab] ] )

	, generic_item( [ line_unit_amount_dummy , d , [tab , `$` , tab ] ])

	, generic_item( [ line_net_amount, d , tab ] )

	, generic_item( [ line_gstdummy , w , newline ] )

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line2, [
%=======================================================================

	generic_item( [ line_charge , d, q10(tab) ] )

	, or([ 
		
		generic_item( [ line_descr , s1,tab  ] )

	,generic_item( [ line_descr , s1 ] )
		
		])

	, q10(generic_item( [ line_dummy2 , s ] ))

	, generic_item( [ line_uom , w, tab ] )

	, generic_item( [ line_quantity , d , [tab , `$` , tab] ] )

	, generic_item( [ line_unit_amount_dummy , d , [tab , `$` , tab ] ])

	, generic_item( [ line_net_amount, d , tab ] )

	, generic_item( [ line_gstdummy , w , newline ] )

] ).


%=======================================================================
i_line_rule_cut( line_credit_note, [
%=======================================================================

	generic_item( [ line_number , d, tab ] )
		
	, generic_item( [ line_quantity , d , [ tab , `$`] ] )

	, generic_item( [ line_unit_amount_dummy , d , tab ])

	, generic_item( [ line_descr , s1 , [ tab , `$`] ])

	, generic_item( [ line_net_amount, d , newline ] )


] ).


%=======================================================================
i_line_rule_cut( line_credit_note_new, [
%=======================================================================

	generic_item( [ line_number , d, tab ] )
      
	, generic_item( [ line_descr , s1 ,  tab  ])

	, generic_item( [ line_dummy4 , w , tab ])            

	, generic_item( [ line_unit_amount , n , tab ])

	, generic_item( [ line_quantity_dummy , n ,  [ tab ,`-` , q10(tab) ]  ] )

	, generic_item( [ line_net_amount, n ] )


] ).










