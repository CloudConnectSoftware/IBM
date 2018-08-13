%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - LINFOX LOGISTICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ul_uapl_linfox, `2/01/2017` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

i_trace_lists.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	get_supplier_details

	,get_supplier_bank_account_number

	,set_credit_note

	, get_invoice_number
	
	, get_invoice_date

    , get_total_net

	, get_total_vat

    , get_total_invoice

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

    
    sender_name(`Linfox Logistics (N.Z.) Limited`)

	, supplier_vat_number(`51-024-834`)

	, currency(`NZD`)

	,buyer_registration_number(`NZ00`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER BANK ACCOUNT NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_bank_account_number, [
%=======================================================================

	qn0(line)
	
	, generic_horizontal_details( [ [ `Account`, `no`, `:`, `01`, `-`, `0210`, `-` ], supplier_bank_account_number_raw, w, newline ] )
    
	,check(supplier_bank_account_number_raw=SupplierAccount)

    , check(strip_string2_from_string1( SupplierAccount, `-`, SupplierAccount1 ))

    ,supplier_bank_account_number(SupplierAccount1), trace( [ `New Bank`, supplier_bank_account_number ] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SUPPLIER DETAILS
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


    , `CREDIT`, `NOTE`

    , set(credit_note)

    , trace( [ `Credit Note Found` ] )

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

q0n(line)


 , or([
	 
	  generic_horizontal_details( [ [ `Invoice`, `No`, tab, `:` ] , invoice_number , w , newline ] )

     , generic_horizontal_details( [ [ `Invoice` , `No` , `:` , tab ] , invoice_number , w , tab ] )

	 , generic_horizontal_details( [ [ `Credit` , `Note` , tab, `:` , q10(tab) ] , invoice_number , w , newline ] )

	 , generic_horizontal_details( [ [ `Credit`, `No`, tab ] , invoice_number , w , newline ] )

 ])

] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE DATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

q0n(line)


, or([

	generic_horizontal_details( [ [ `Invoice`, `Date`, `:`, tab ] , 100 , invoice_date , date , newline ] )

   , generic_horizontal_details( [ [  `Date`, tab, `:`] , invoice_date , date , newline ] )

])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE NET AMOUNT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_net, [
%=======================================================================

	qn0(line)
	

	, or([

		[test(credit_note)  

		 , generic_horizontal_details( [ [ `Sub`, `Total` ] ,100,total_net , d , newline ] )]

		 , generic_horizontal_details( [ [ `Sub`, `Total`, tab, q10(`NZD`), q10(tab), `$` ] , total_net , d , newline ] )

		 , generic_vertical_details( [ [ `Total`, `Invoice`], `Total`, q(0,3,up),(end,10,10), total_net, d, tab ] )

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


qn0(line)

, or([

     generic_horizontal_details( [ [ `GST`, dummyvatrate(d), `%`, tab, `NZD`, tab, `$` ] , 100 , total_vat , d , newline ] )

     , generic_horizontal_details( [ [ `GST` , tab ] , 100 , total_vat , d , newline ] )

    ])

    , generic_item( [ default_vat_rate, `15` ] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET TOTAL INVOICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_total_invoice, [
%=======================================================================

qn0(line)

, or([

  generic_horizontal_details( [ [ `TOTAL`, `AMOUNT`, `PAYABLE`, tab, q10(`NZD`), `$` ] , total_invoice , d , newline ] )

  , generic_horizontal_details( [ [ `TOTAL`, `CREDIT`, `AMOUNT`, tab , `$` ] , total_invoice , d , newline ] )

])

] ).


%=======================================================================
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

			line_invoice_lines

			, line_invoice_lines_new

			, line_invoice_lines_2

			,[line_credit_lines , line_credit_descr_lines ]


			
			, line

		] )

	] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

or([

	[`Description`, `of`, `Charges`]

	,[`date`, tab, `Bill`, `No`]

	])

	, trace( [`Found header line` ] )


] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

	or([

			[`CARRIED`, `FORWARD`, tab ]
			
			, [`Sub`, `total`, tab, `$`, dummy_num11(d), newline ]

			, [`Sub`, `total`, tab, `NZD`, q10(tab) , `$`, dummy_num11(d), newline ]

		    , [`Sub`, `Total`, tab, `NZD`,`$`, tab, dummy_num10(d), newline ]


		, [`TOTAL`, `AMOUNT`, `PAYABLE`]
		
			])

	, trace( [ `FOUND END LINE`])

] ).

%=======================================================================
i_line_rule_cut( line_invoice_lines, [
%=======================================================================

    

		  generic_item( [ line_descr, s1, tab ] )
	
		, generic_item( [ line_net_amount, d, newline] )

	    , trace( [ `Complete line`] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_lines_new, [
%=======================================================================

    

		generic_item( [ line_descr, s1, tab ] )

		, q10(generic_item( [ line_reference, s1, tab ] ))
	
		, generic_item( [ line_net_amount, d, newline] )

	    , trace( [ `Complete line`] )


] ).


%=======================================================================
i_line_rule_cut( line_invoice_lines_2, [
%=======================================================================



generic_item([line_date, date])

    , generic_item( [ line_bil_no, d,tab] )

	, generic_item( [ line_descr, s1, tab ] )
	
	, generic_item( [ line_ship_from, s1, tab ] )

	, generic_item( [ line_city, s, q10(tab) ] )

	, generic_item( [ line_bill_to_ref, d,tab] )

	, generic_item( [ line_consignee_ref, d, tab ] )

	, generic_item( [ line_freight, s1, tab ] )

	, generic_item( [ line_quantity_uom, s1, tab ] )

	, generic_item( [ line_pcs, d, tab ] )

	, generic_item( [ line_quantity, d] )

	, generic_item( [ line_unit_amount, d, tab ] )

	, generic_item( [ line_ln_total, d,tab] )

	, generic_item( [ line_sub_total, d, tab ] )

	, generic_item( [ line_other, d,tab] )

	, generic_item( [ line_surcharge, d, tab ] )

	, generic_item( [ line_net_amount, d, newline] )

	,trace( [ `Complete line`] )


] ).


%=======================================================================
i_line_rule_cut( line_credit_lines, [
%=======================================================================

    
		 generic_item( [ line_net_amount, d, newline] )

	    , trace( [ `Complete line Net`] )


] ).
%=======================================================================
i_line_rule_cut( line_credit_descr_lines, [
%=======================================================================

    
		 generic_item( [ line_descr, s1, newline] )

	    , trace( [ `Complete line Decr`] )


] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAPPING AUDIT TRAIL

% Updated on   - December 15, 2017
% Updated by   - Rohini	
% Changes made - Line details 



% Updated on   - 25, Jan 2018
% Updated by   - Thejaswi K
% Changes made - Bank details


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%