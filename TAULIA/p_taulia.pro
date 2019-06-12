%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_TAULIA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_taulia, `04/02/2019 10:10:35` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rules_file( `d_taulia_compliance.pro` ).
i_rules_file( `d_zip_against_state.pro` ).
i_rules_file( `d_taulia_ibm.pro` ).
i_rules_file( `u_json_forms_new.pro` ).
i_rules_file( `u_supporting_document_new.pro` ).
i_rules_file( `u_invoice_number_validation_2.pro` )
:-
	collect_correct_p_file( File ),
	not( q_sys_sub_string( File, _, _, `redbull` ) )
.

i_rules_file( `u_invoice_date_validation.pro` ).
i_rules_file( File )
:-
	collect_correct_p_file( File )
.

collect_correct_p_file( File )
:-
	( i_mail( to, To ); chained_to( Chain ); i_mail( subject, Chain ), Chain \= `` ),

	q_taulia_customer_settings( _, _, To, _, _, _, _, Chain, Process ),

	strcat_list( [ `p_`, Process, `.pro` ], File ),
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Fields
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_user_field( invoice, currency_exchange_rate, `Currency Exchange Rate` ).
i_user_field( invoice, reason_for_credit, `Reason for Credit` ).
i_user_field( invoice, supplier_id, `Supplier ID` ).
i_user_field( invoice, buyer_id, `Buyer ID` ).
i_user_field( invoice, order_id, `Order ID` ).
i_user_field( invoice, buyer_tax_type, `Tax Type` ).
i_user_field( invoice, tooling_assist, `Tooling Assist` ).
i_user_field( invoice, requestor, `Requestor` ).
i_user_field( invoice, po_composer, `PO Composer` ).
i_user_field( invoice, supplier_tax_country, `Supplier Tax Country` ).
i_user_field( invoice, supplier_tax_type, `Supplier Tax Type` ).
i_user_field( invoice, rounding_amount, `Rounding Amount` ).
i_user_field( invoice, header_discount, `Header Discount` ).
i_user_field( line, line_tax_exempt_reason, `Line Exempt Reason` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAT Totals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_calculate_vat_totals_from_table:- not( grammar_set( vat_invoice ) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XML Transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_op_param( xml_transform( Var, In ), _, _, _, Out )
:-
	q_sys_member( Var, [ buyer_registration_number, supplier_registration_number ] ),
	string_to_lower( In, Out )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE DELIVERY CITY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( invoice, delivery_address_line, AL )
	, without( delivery_city )
	, trace( [ `Address Populated and City NOT captured - Manipulating` ] )

	, generic_item( [ delivery_city, AL ] )
	, remove( delivery_address_line )
	, trace( [ `delivery_address_line has been REMOVED` ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TAX BASED FINAL RULE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [ without( default_vat_rate ), without( line_vat_rate ),
%=======================================================================

    default_vat_rate(`0`)

	, vat_rate_1(`0`), rate_1_net(`0`), rate_1_gross(`0`)
	, vat_rate_2(`0`), rate_2_net(`0`), rate_2_gross(`0`)
	, vat_rate_3(`0`), rate_3_net(`0`), rate_3_gross(`0`)

 	, or( [

	%	Canadian Tax Handling
		[ 	or( [ test(canadian_tax)
				, [ with(invoice, currency, CAD ), check( CAD = `CAD` ) ]
			] )

			, q10( [ with(invoice, vat_subtotal_1, VS1)
				,  rate_1_vat( VS1 ), with(invoice, vat_code_1, VC1)
				, trace([ `VAT sub value 1`, rate_1_vat, VC1 ] )
			] )

			, q10( [ with(invoice, vat_subtotal_2, VS2)
				, rate_2_vat( VS2 ), with(invoice, vat_code_2, VC2)
				, trace([ `VAT sub value 2`, rate_2_vat, VC2 ] )
			] )

			, q10([ with(invoice, vat_subtotal_3, VS3)
				, rate_3_vat( VS3 ), with(invoice, vat_code_3, VC3)
				, trace([ `VAT sub value 3`, rate_3_vat, VC3 ] )
			] )

			, or( [ [

					without(vat_subtotal_1), without(vat_subtotal_2), without(vat_subtotal_3)
					, vat_code_1(`GST`)
					, or( [ [ with(invoice, total_vat, TV)
							, rate_1_vat( TV ), trace([ `GST Tax value`, rate_1_vat ])
						]
						, rate_1_vat(`0`)
					] )

				]

				, [

					or( [ with( vat_subtotal_1 ), with( vat_subtotal_2 ), with( vat_subtotal_3 ) ] )

					, q10( [ without( vat_subtotal_1 ), check( VS1 = `0` ) ] )
					, q10( [ without( vat_subtotal_2 ), check( VS2 = `0` ) ] )
					, q10( [ without( vat_subtotal_3 ), check( VS3 = `0` ) ] )

					, trace( [ VS1, VS2, VS3 ] )
					, check( i_user_check( sum_the_list, [ VS1, VS2, VS3 ], Total ) )
					, total_vat( Total )
					, trace( [ `Added Subtotals to get Total Tax`, Total ] )

				]

			] )

		]

	%	British Tax Handling
		, [ with(invoice, currency, GBP ), check( GBP = `GBP` )
			, vat_code_1(`VAT`)

			, or( [ [ with(invoice, total_vat, TV)
					, rate_1_vat( TV ), trace([ `VAT Tax value`, rate_1_vat ])
				]
				, rate_1_vat(`0`)
			] )
		]

	%	US Tax Handling
		, [ with( invoice, currency, USD ), check( USD = `USD` )
			, q10( [ without( vat_code_1 ), vat_code_1(`SALES`) ] )

			, or( [ [ with(invoice, total_vat, TV)
				, rate_1_vat( TV ), trace([ `Sales Tax value`, rate_1_vat ])
				]
				, rate_1_vat(`0`)
			] )
		]

	%	Pre-defined Tax Handling
		, [ with( vat_code_1 )

			, or( [ [ with(invoice, total_vat, TV)
				, rate_1_vat( TV ), trace([ `Sales Tax value`, rate_1_vat ])
				]
				, rate_1_vat(`0`)
			] )
		]

	] )

] ).

%-----------------------------------------------------------------------
i_user_check( sum_the_list, List, Sum )
%-----------------------------------------------------------------------
:-
	list_sum( List, Sum )
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
list_sum( [ Total ], Total ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
list_sum( [ Item1, Item2 | Tail ], Total )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
	sys_calculate_str_add( Item1, Item2, Added ),
	list_sum( [ Added | Tail ], Total )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE VAT TABLE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	with( rate_1_vat )
	, with( vat_code_1 )

	, vat_rate_1(`0`), rate_1_net(`0`), rate_1_gross(`0`)

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INVOICE TYPE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	without( invoice_type )

	, or( [ [ test( credit_note ), invoice_type( `CRN` ) ]

		, invoice_type( `INV` )

	] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUYER REGISTRATION NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [ buyer_registration_number( TO ) ] ) :- i_mail( to, TO ), not( q_taulia_customer_settings( _, `Southern Company`, TO, _, _, _, _, _, _ ) ).
%=======================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SUPPLIER REGISTRATION NUMBER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
%=======================================================================
i_final_rule( [
%=======================================================================

	remove( supplier_registration_number )

	, supplier_registration_number( R2 )

	, trace( [ `Supplier Registration Number`, supplier_registration_number ] )

] )
:-
	i_mail( reply_to, REPLY )
	, q_sys_sub_string( REPLY, _, _, `@` )
	, i_mail( from, FROM )
	, not( forced_no_reply_addresses( FROM ) )
	, ( q_sys_sub_string( FROM, _, _, `@intuit.com` )
		; q_sys_sub_string( FROM, _, _, `@quickbooks.com` )
		; q_sys_sub_string( FROM, _, _, `reply@` )
		; q_sys_sub_string( FROM, _, _, `replyto@` )
	)
	, string_string_replace( REPLY,  `<`, ``, R1)
	, string_string_replace( R1,  `>`, ``, R2)
.

forced_no_reply_addresses( `noreply@inexchange.se` ).
forced_no_reply_addresses( `payments-noreply@google.com` ).
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RESUBMISSION RULES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

	remove( supplier_registration_number )

	, supplier_registration_number( SenderAddr )

	, trace( [ `Finished Resubmit Rule, Supplier Reg Number:`, supplier_registration_number ] )

] )
:-
	trace( [ `Starting Resubmit Rule` ] ),
	i_mail( subject, Subject ),
	string_to_lower( Subject, SubjectL ),
	string_string_replace( SubjectL, ` `, ``, SubjectClean ),
	q_sys_sub_string( SubjectClean, _, _, `resubmitfrom:` ),
	q_sys_sub_string( SubjectClean, 14, _, SenderAddr )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POPULATE TOTALS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_missing_invoice_totals___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_missing_invoice_totals___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(
		not( result( _, invoice, total_net, _ ) ),
		result( _, invoice, total_vat, VAT ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			Sub_3 = `0`
		),
		result( _, invoice, total_invoice, Total ),
		sys_calculate_str_add( VAT, Sub_3, X ),
		sys_calculate_str_subtract( Total, X, Net ),
		assertz_derived_data( invoice, total_net, Net, i_analyse_total_net )
		
		;
		
		not( result( _, invoice, total_vat, _ ) ),
		result( _, invoice, total_net, Net ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			Sub_3 = `0`
		),
		result( _, invoice, total_invoice, Total ),
		sys_calculate_str_add( Net, Sub_3, X ),
		sys_calculate_str_subtract( Total, X, VAT ),
		assertz_derived_data( invoice, total_vat, VAT, i_analyse_total_vat )
		
		;
		
		not( result( _, invoice, total_invoice, _ ) ),
		result( _, invoice, total_net, Net ),
		result( _, invoice, total_vat, VAT ),
		(
			result( _, invoice, rounding_amount, Sub_3 )
			;
			Sub_3 = `0`
		),
		sys_calculate_str_add( Net, VAT, X ),
		sys_calculate_str_add( X, Sub_3, Total ),
		assertz_derived_data( invoice, total_invoice, Total, i_analyse_total_invoice )
		
	),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VALIDATE COUNTRY CODES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_validate_country_codes.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_validate_country_codes
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, Var, CC ),
	not( i_user_data( used_cc( Var ) ) ),
	sub_atom( Var, _, _, country_code ),

	string_to_upper( CC, CCUp ),
	( valid_taulia_country_code( Country, CCUp )
		->	trace( [ `Country code`, CCUp, `for`, Country ] ),
			sys_assertz( i_user_data( used_cc( Var ) ) )

		;	trace( [ `Country code`, CCUp, `invalid - REMOVING` ] ),
			sys_retractall( result( _, invoice, Var, _ ) )
	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SET DISCOUNT FLAG
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_discount_flag___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_discount_flag___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, total_discount, _ ),
	
	sys_assertz( grammar_set( discount_has_been_mapped ) ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EMAIL MANIPULATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_taulia_emails.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_taulia_emails
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, buyer_email, Email )
	, trace( email( Email ) )

	, ( q_sys_sub_string( Email, _, _, `@` )
		, not( q_sys_sub_string( Email, _, _, ` ` ) )
		->	trace( `Email Address Structure Validated` )

		;	trace( `Email address invalid` )
			, sys_retract( result( _, invoice, supplier_email, Email ) )

	)

	, !
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TRUNCATE CUSTOMER COMMENTS TO 1000 CHARACTERS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_customer_comments___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_customer_comments___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, invoice, customer_comments, Comments ),

	sys_string_length( Comments, Length ),

	Length > 1024,

	q_sys_sub_string( Comments, 1, 1024, Comments_1024 ),

	sys_retractall( result( _, invoice, customer_comments, _ ) ),

	assertz_derived_data( invoice, customer_comments, Comments_1024, i_analyse_customer_comments___ ),

	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TRUNCATE LINE DESCR TO 1000 CHARACTERS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_cut_descriptions_1000_characters( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_cut_descriptions_1000_characters( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, LID, line_descr, Descr ),																%% Bring through the result of line descr and call it Descr
	sys_string_length( Descr, DescrLen ),																%% Determine the length of Descr, call it DescrLen
	DescrLen > 1000,																					%% Is DescrLen more than 1000?
	q_sys_sub_string( Descr, 1, 1000, Descr1000 ),														%% Define Descr1000 as the first 1000 characters
	sys_retractall( result( _, LID, line_descr, _ ) ),													%% Remove current line description
	assertz_derived_data( LID, line_descr, Descr1000, i_cut_descriptions_1000_characters ),				%% Insert our Descr1000 as new line description
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TRUNCATE ADDITIONAL LINE DESCR TO 255 CHARACTERS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_cut_additional_descriptions_256_characters( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_cut_additional_descriptions_256_characters( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	result( _, LID, line_descr, Descr ),																%% Bring through the result of line descr and call it Descr
	result( _, LID, line_type, `extra` ),																%% Check it is an additional line
	sys_string_length( Descr, DescrLen ),																%% Determine the length of Descr, call it DescrLen
	DescrLen > 255,																					%% Is DescrLen more than 1000?
	q_sys_sub_string( Descr, 1, 255, Descr1000 ),														%% Define Descr1000 as the first 1000 characters
	sys_retractall( result( _, LID, line_descr, _ ) ),													%% Remove current line description
	assertz_derived_data( LID, line_descr, Descr1000, i_cut_additional_descriptions_256_characters ),				%% Insert our Descr1000 as new line description
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DEFAULT UOMS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_line_fields_first( LID ):- i_default_uoms( LID ).
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_default_uoms( LID )
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	( result( _, LID, line_quantity_uom_code, UOMRaw )
		->	( string_to_upper( UOMRaw, UOM ), trace( uom( UOM ) ), sys_retract( result( _, LID, line_quantity_uom_code, _ ) ) )
		;	( true, UOM = `EA` )
	),
	taulia_uom_code( UOM, TUOM), trace( tuom( TUOM ) ),
	assertz_derived_data( LID, line_quantity_uom_code, TUOM, i_default_uoms ),
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DERIVE TOTAL DISCOUNT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_total_discount___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_total_discount___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( discount_has_been_mapped ) ),
	
	sys_findall( Line_Amount_Discount, result( _, LID, line_amount_discount, Line_Amount_Discount ), List_of_Line_Discounts_Raw ),
	
	i_force_list( List_of_Line_Discounts_Raw, List_of_Line_Discounts ),
	
	i_user_check( sum_string_list, List_of_Line_Discounts, Sum_of_Line_Discounts ),
	
	(
		result( _, invoice, rounding_amount, Rounding_Amount )
		
		;
		
		not( result( _, invoice, rounding_amount, _ ) ),
		
		Rounding_Amount = `0`
		
	),
	
	!,
	
	(
		result( _, invoice, header_discount, Header_Discount )

		;

		not( result( _, invoice, header_discount, _ ) ),

		Header_Discount = `0`

	),

	!,

	sys_calculate_str_add( Sum_of_Line_Discounts, Header_Discount, Line_and_Header_Discount ),

	sys_calculate_str_subtract( Line_and_Header_Discount, Rounding_Amount, Total_Discount ),

	sys_retractall( result( _, invoice, total_discount, _ ) ),
	
	assertz_derived_data( invoice, total_discount, Total_Discount, i_analyse_total_discount ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GET AMERICAN ADDRESS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_american_address( [ Member ] ), [
%=======================================================================

	  Header

	, trace( [ `Found header` ] )

	, q0n( gen_line_nothing_here( [ Near_Hook, 10, 10 ] ) )

	, or( [ [ without( Party ), get_american_party( [ Hook, Party ] ) ]

		, with( Party )

	] )

	, check( i_user_check( gen_cntr_set, 20, 0 ) )

	, q( 0, 10, [ or( [ get_american_line( [ Hook, PC, State, City, AL, AL ] ), line ] ), american_ship_to_count_rule ] )

	, or( [ american_ship_to_complete

		, check( i_user_check( gen_cntr_get, 20, 10 ) )

		, End_Line

	] )

	, or( [ [ check( i_user_check( check_for_valid_state, State ) )

			, Default_CC

		]

		, trace( [ `Invalid State` ] )

	] )

	, clear_flags

] )
:-
	( q_sys_is_string( Member )	->	Member_Usable = Member
		;	q_sys_is_atom( Member )	->	sys_string_atom( Member_Usable, Member )
	)

	, Endings = [ `_hook`, `_header_rule`, `_party`, `_contact`, `_street`
				, `_address_line`, `_city`, `_state`, `_postcode`, `_end_line`
				, `_country_code` ]

	, prepend_the_whole_list( Member_Usable, Endings, Strings )
	, transform_list( sys_string_atom, Strings, Atoms )
	, Atoms = [ Hook, Header, Party, Contact, Street, AL, City, State, PC, End_Line, CC ]
	, Default_CC =.. [ CC, `US` ]
	, Near_Hook =.. [ Hook, start ]
	, !
.

prepend_the_whole_list( Beginning, [ ], [ ] ).
prepend_the_whole_list( Beginning, [ E_H | E_T ], [ S_H | S_T ] ):-

	  strcat_list( [ Beginning, E_H ], S_H )
	, prepend_the_whole_list( Beginning, E_T, S_T )
.

%=======================================================================
i_rule_cut( american_ship_to_count_rule, [
%=======================================================================

	  check( i_user_check( gen_cntr_get, 20, Number ) )
	, check(i_user_check(gen_add, Number, 1, Next_Number) )
	, check( i_user_check( gen_cntr_set, 20, Next_Number ) )

] ).

%=======================================================================
i_rule( clear_flags, [
%=======================================================================

	  clear( got_street ), clear( got_postcode )

	, clear( got_city ), clear( got_address_line )

	, clear( got_state ), clear( supplier_check )

] ).

%=======================================================================
i_rule( american_ship_to_complete, [
%=======================================================================

	  test( got_postcode )

	, test( got_city ), test( got_state )

] ).

%=======================================================================
i_line_rule( get_american_line( [ Hook, PC, State, City, Street, AL ] ), [
%=======================================================================

	  nearest_word( Near_Hook, 5, 50 )

	, peek_fails( [ `*`, `*` ] )

	, or( [ get_american_city_state_postcode_rule( [ PC, State, City ] )

		, get_american_street( [ Street ] )

		, get_american_address_line( [ AL ] )

	] )

] ):- Near_Hook =.. [ Hook, start ].

%=======================================================================
i_rule( get_american_city_state_postcode_rule( [ PC, State, City ] ), [
%=======================================================================

	  peek_fails( test( got_state ) )

	, peek_fails( test( got_city ) )

	, peek_fails( test( got_postcode ) )

	, q0n( or( [ get_american_postcode( [ PC ] )

			, get_american_state( [ State ] )

			, get_american_city( [ City ] )

			, tab(200)

		] )

	)

	, test( got_state )

	, test( got_postcode )

	, check( i_user_check( check_zip_and_state, PC, State ) )

	, q10( [ with( City ), trace( [ `Delivery City`, City ] ) ] )

] ).

%=======================================================================
i_rule( get_american_street( [ Street ] ), [
%=======================================================================

	  peek_fails( test( got_street ) )

	, read_ahead( dummy(f( [ q(dec,1,10) ] ) ) )

	, generic_item( [ Street, s1 ] )

	, set( got_street )

] ).

%=======================================================================
i_line_rule( get_american_party( [ Hook, Party ] ), [
%=======================================================================

	nearest_word( Near_Hook, 10, 10 )

	, generic_item( [ Party, s1 ] )

] ):- Near_Hook =.. [ Hook, start ].

%=======================================================================
i_rule( get_american_postcode( [ PC ] ), [
%=======================================================================

	  peek_fails( test( got_postcode ) )

	, or( [ generic_item( [ PC, [ begin, q(dec,5,5), q(other("-"),0,1), q(dec,4,4), end ] ] )

		, generic_item( [ PC, [ begin, q(dec,5,5), end ] ] )

	] )

	, set( got_postcode )

] ).

%=======================================================================
i_rule( get_american_city( [ City ] ), [
%=======================================================================

	  peek_fails( test( got_city ) )

	, or( [ [ Read_City, or( [ `,`, tab(50) ] ) ]

		, [ Read_City, q10( `,` ) ]

	] )

	, set( got_city )

] ):-
	Read_City =.. [ City, sf ]
.

%=======================================================================
i_rule( get_american_state( [ State ] ), [
%=======================================================================

	  peek_fails( test( got_state ) )

	, or( [ [ generic_item( [ State, [ begin, q(alpha,2,2), end ], check( i_user_check( check_for_valid_state, State ) ) ] )

		]

		, [ test( state_names_valid )
			, generic_item( [ State, sf, [ peek_fails( `City` ), check( i_user_check( valid_state_name, State ) ) ] ] )
		]

	] )

	, q10( `,` )

	, set( got_state )

] ).

%=======================================================================
i_rule( get_american_address_line( [ AL ] ), [
%=======================================================================

	generic_item( [ AL, s1 ] )

] ).

%=======================================================================
i_user_check( check_zip_and_state, ZipRaw, State ):-
%=======================================================================
	( q_regexp_match( `^\\d{5}$`, ZipRaw, _ )
		->	ZipRaw = Zip
		;	q_sys_sub_string( ZipRaw, 1, 5, Zip )
	),

	( zip_against_state_check( Zip, State, _ )
		->	true
		;	string_to_lower( State, StateL ),
			zip_against_state_check( Zip, _, StateL )
	),
	trace( `State and Zip match` )
.

%=======================================================================
i_user_check( valid_state_name, State ):-
%=======================================================================

	string_to_lower( State, State_L )
	, valid_state_search( State_L, _ )
	, trace( `Valid State Name` )
.

%=======================================================================
i_user_check( check_for_valid_state, State ):-
%=======================================================================

	( string_to_lower( State, State_L )
		, valid_state_search( State_L, _ )
		, trace( `Full State Name` )

	;
		string_to_upper( State, State_U )
		, valid_state_search( _, State_U )
		, trace( `State Abbreviation` )

	)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOOKUPS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% Taulia UOM Code
%-----------------------------------------------------------------------
taulia_uom_code( `HR`, `HUR` ).
taulia_uom_code( `HUR`, `HUR` ).
taulia_uom_code( `MSF`, `MSF` ).
taulia_uom_code( `PC`, `PC` ).
taulia_uom_code( `KG`, `KG` ).
taulia_uom_code( `TE`, `TE` ).
taulia_uom_code( `LE`, `LE` ).
taulia_uom_code( `TO`, `TO` ).
taulia_uom_code( `PCE`, `PCE` ).
taulia_uom_code( `PCS`, `PCS` ).
taulia_uom_code( `DAY`, `DAY` ).
taulia_uom_code( `10`, `10` ).
taulia_uom_code( `HOURS`, `HUR` ).
taulia_uom_code( `PIECE`, `PC` ).
taulia_uom_code( `EACH`, `EA` ).
taulia_uom_code( `CS`, `CS` ).
taulia_uom_code( `LB`, `LB` ).
taulia_uom_code( `LBR`, `LBR` ).
taulia_uom_code( `BOX`, `BX` ).
taulia_uom_code( `BX`, `BX` ).
taulia_uom_code( `H`, `H` ).
taulia_uom_code( `ST`, `ST` ).
taulia_uom_code( `H`, `H` ).
taulia_uom_code( `ROLL`, `ROL` ).
taulia_uom_code( `M`, `MTR` ).
taulia_uom_code( `MR`, `M` ).
taulia_uom_code( `PAK`, `PAC` ).
taulia_uom_code( `AU`, `AU` ).
taulia_uom_code( `STN`, `NS` ).
taulia_uom_code( `Month`, `MON` ).
taulia_uom_code( `PAA`, `PAA` ).
taulia_uom_code( `KM`, `KMT` ).
taulia_uom_code( `C62 (ONE)`, `C62` ).
taulia_uom_code( `FT`, `FOT` ).
taulia_uom_code( `GM`, `GM` ).
taulia_uom_code( `MTQ`, `MTQ` ).
taulia_uom_code( `TN`, `STN` ).
taulia_uom_code( `STN_US`, `STN` ).
taulia_uom_code( `MT`, `MTR` ).
taulia_uom_code( `CYL`, `CYL` ).
taulia_uom_code( `PK`, `PK` ).
taulia_uom_code( `TNE`, `TNE` ).
taulia_uom_code( `WU`, `WU` ).
taulia_uom_code( `TON`, `TON` ).
taulia_uom_code( `LTR`, `LTR` ).
taulia_uom_code( `KGM`, `KGM` ).
taulia_uom_code( `RL`, `RL` ).
taulia_uom_code( `CT`, `CT` ).
taulia_uom_code( _ , `EA` ).

%-----------------------------------------------------------------------
% Valid Taulia Country Code
%-----------------------------------------------------------------------
valid_taulia_country_code( `afghanistan`, `AF` ).
valid_taulia_country_code( `albania`, `AL` ).
valid_taulia_country_code( `algeria`, `DZ` ).
valid_taulia_country_code( `andorra`, `AD` ).
valid_taulia_country_code( `angola`, `AO` ).
valid_taulia_country_code( `antigua and barbuda`, `AG` ).
valid_taulia_country_code( `argentina`, `AR` ).
valid_taulia_country_code( `armenia`, `AM` ).
valid_taulia_country_code( `australia`, `AU` ).
valid_taulia_country_code( `austria`, `AT` ).
valid_taulia_country_code( `azerbaijan`, `AZ` ).
valid_taulia_country_code( `bahamas, the`, `BS` ).
valid_taulia_country_code( `bahrain`, `BH` ).
valid_taulia_country_code( `bangladesh`, `BD` ).
valid_taulia_country_code( `barbados`, `BB` ).
valid_taulia_country_code( `belarus`, `BY` ).
valid_taulia_country_code( `belgium`, `BE` ).
valid_taulia_country_code( `belize`, `BZ` ).
valid_taulia_country_code( `benin`, `BJ` ).
valid_taulia_country_code( `bhutan`, `BT` ).
valid_taulia_country_code( `bolivia`, `BO` ).
valid_taulia_country_code( `bosnia and herzegovina`, `BA` ).
valid_taulia_country_code( `botswana`, `BW` ).
valid_taulia_country_code( `brazil`, `BR` ).
valid_taulia_country_code( `brunei`, `BN` ).
valid_taulia_country_code( `bulgaria`, `BG` ).
valid_taulia_country_code( `burkina faso`, `BF` ).
valid_taulia_country_code( `burundi`, `BI` ).
valid_taulia_country_code( `cambodia`, `KH` ).
valid_taulia_country_code( `cameroon`, `CM` ).
valid_taulia_country_code( `canada`, `CA` ).
valid_taulia_country_code( `cape verde`, `CV` ).
valid_taulia_country_code( `central african republic`, `CF` ).
valid_taulia_country_code( `chad`, `TD` ).
valid_taulia_country_code( `chile`, `CL` ).
valid_taulia_country_code( `china, people's republic of`, `CN` ).
valid_taulia_country_code( `colombia`, `CO` ).
valid_taulia_country_code( `comoros`, `KM` ).
valid_taulia_country_code( `congo, (congo �_ kinshasa)`, `CD` ).
valid_taulia_country_code( `congo, (congo �_ brazzaville)`, `CG` ).
valid_taulia_country_code( `costa rica`, `CR` ).
valid_taulia_country_code( `cote d'ivoire (ivory coast)`, `CI` ).
valid_taulia_country_code( `croatia`, `HR` ).
valid_taulia_country_code( `cuba`, `CU` ).
valid_taulia_country_code( `cyprus`, `CY` ).
valid_taulia_country_code( `czech republic`, `CZ` ).
valid_taulia_country_code( `denmark`, `DK` ).
valid_taulia_country_code( `djibouti`, `DJ` ).
valid_taulia_country_code( `dominica`, `DM` ).
valid_taulia_country_code( `dominican republic`, `DO` ).
valid_taulia_country_code( `ecuador`, `EC` ).
valid_taulia_country_code( `egypt`, `EG` ).
valid_taulia_country_code( `el salvador`, `SV` ).
valid_taulia_country_code( `equatorial guinea`, `GQ` ).
valid_taulia_country_code( `eritrea`, `ER` ).
valid_taulia_country_code( `estonia`, `EE` ).
valid_taulia_country_code( `ethiopia`, `ET` ).
valid_taulia_country_code( `fiji`, `FJ` ).
valid_taulia_country_code( `finland`, `FI` ).
valid_taulia_country_code( `france`, `FR` ).
valid_taulia_country_code( `gabon`, `GA` ).
valid_taulia_country_code( `gambia, the`, `GM` ).
valid_taulia_country_code( `georgia`, `GE` ).
valid_taulia_country_code( `germany`, `DE` ).
valid_taulia_country_code( `ghana`, `GH` ).
valid_taulia_country_code( `greece`, `GR` ).
valid_taulia_country_code( `grenada`, `GD` ).
valid_taulia_country_code( `guatemala`, `GT` ).
valid_taulia_country_code( `guinea`, `GN` ).
valid_taulia_country_code( `guinea-bissau`, `GW` ).
valid_taulia_country_code( `guyana`, `GY` ).
valid_taulia_country_code( `haiti`, `HT` ).
valid_taulia_country_code( `honduras`, `HN` ).
valid_taulia_country_code( `hungary`, `HU` ).
valid_taulia_country_code( `iceland`, `IS` ).
valid_taulia_country_code( `india`, `IN` ).
valid_taulia_country_code( `indonesia`, `ID` ).
valid_taulia_country_code( `iran`, `IR` ).
valid_taulia_country_code( `iraq`, `IQ` ).
valid_taulia_country_code( `ireland`, `IE` ).
valid_taulia_country_code( `israel`, `IL` ).
valid_taulia_country_code( `italy`, `IT` ).
valid_taulia_country_code( `jamaica`, `JM` ).
valid_taulia_country_code( `japan`, `JP` ).
valid_taulia_country_code( `jordan`, `JO` ).
valid_taulia_country_code( `kazakhstan`, `KZ` ).
valid_taulia_country_code( `kenya`, `KE` ).
valid_taulia_country_code( `kiribati`, `KI` ).
valid_taulia_country_code( `korea, north`, `KP` ).
valid_taulia_country_code( `korea, south`, `KR` ).
valid_taulia_country_code( `kuwait`, `KW` ).
valid_taulia_country_code( `kyrgyzstan`, `KG` ).
valid_taulia_country_code( `laos`, `LA` ).
valid_taulia_country_code( `latvia`, `LV` ).
valid_taulia_country_code( `lebanon`, `LB` ).
valid_taulia_country_code( `lesotho`, `LS` ).
valid_taulia_country_code( `liberia`, `LR` ).
valid_taulia_country_code( `libya`, `LY` ).
valid_taulia_country_code( `liechtenstein`, `LI` ).
valid_taulia_country_code( `lithuania`, `LT` ).
valid_taulia_country_code( `luxembourg`, `LU` ).
valid_taulia_country_code( `macedonia`, `MK` ).
valid_taulia_country_code( `madagascar`, `MG` ).
valid_taulia_country_code( `malawi`, `MW` ).
valid_taulia_country_code( `malaysia`, `MY` ).
valid_taulia_country_code( `maldives`, `MV` ).
valid_taulia_country_code( `mali`, `ML` ).
valid_taulia_country_code( `malta`, `MT` ).
valid_taulia_country_code( `marshall islands`, `MH` ).
valid_taulia_country_code( `mauritania`, `MR` ).
valid_taulia_country_code( `mauritius`, `MU` ).
valid_taulia_country_code( `mexico`, `MX` ).
valid_taulia_country_code( `micronesia`, `FM` ).
valid_taulia_country_code( `moldova`, `MD` ).
valid_taulia_country_code( `monaco`, `MC` ).
valid_taulia_country_code( `mongolia`, `MN` ).
valid_taulia_country_code( `montenegro`, `ME` ).
valid_taulia_country_code( `morocco`, `MA` ).
valid_taulia_country_code( `mozambique`, `MZ` ).
valid_taulia_country_code( `myanmar (burma)`, `MM` ).
valid_taulia_country_code( `namibia`, `NA` ).
valid_taulia_country_code( `nauru`, `NR` ).
valid_taulia_country_code( `nepal`, `NP` ).
valid_taulia_country_code( `netherlands`, `NL` ).
valid_taulia_country_code( `new zealand`, `NZ` ).
valid_taulia_country_code( `nicaragua`, `NI` ).
valid_taulia_country_code( `niger`, `NE` ).
valid_taulia_country_code( `nigeria`, `NG` ).
valid_taulia_country_code( `norway`, `NO` ).
valid_taulia_country_code( `oman`, `OM` ).
valid_taulia_country_code( `pakistan`, `PK` ).
valid_taulia_country_code( `palau`, `PW` ).
valid_taulia_country_code( `panama`, `PA` ).
valid_taulia_country_code( `papua new guinea`, `PG` ).
valid_taulia_country_code( `paraguay`, `PY` ).
valid_taulia_country_code( `peru`, `PE` ).
valid_taulia_country_code( `philippines`, `PH` ).
valid_taulia_country_code( `poland`, `PL` ).
valid_taulia_country_code( `portugal`, `PT` ).
valid_taulia_country_code( `qatar`, `QA` ).
valid_taulia_country_code( `romania`, `RO` ).
valid_taulia_country_code( `russia`, `RU` ).
valid_taulia_country_code( `rwanda`, `RW` ).
valid_taulia_country_code( `saint kitts and nevis`, `KN` ).
valid_taulia_country_code( `saint lucia`, `LC` ).
valid_taulia_country_code( `saint vincent and the grenadines`, `VC` ).
valid_taulia_country_code( `samoa`, `WS` ).
valid_taulia_country_code( `san marino`, `SM` ).
valid_taulia_country_code( `sao tome and principe`, `ST` ).
valid_taulia_country_code( `saudi arabia`, `SA` ).
valid_taulia_country_code( `senegal`, `SN` ).
valid_taulia_country_code( `serbia`, `RS` ).
valid_taulia_country_code( `seychelles`, `SC` ).
valid_taulia_country_code( `sierra leone`, `SL` ).
valid_taulia_country_code( `singapore`, `SG` ).
valid_taulia_country_code( `slovakia`, `SK` ).
valid_taulia_country_code( `slovenia`, `SI` ).
valid_taulia_country_code( `solomon islands`, `SB` ).
valid_taulia_country_code( `somalia`, `SO` ).
valid_taulia_country_code( `south africa`, `ZA` ).
valid_taulia_country_code( `spain`, `ES` ).
valid_taulia_country_code( `sri lanka`, `LK` ).
valid_taulia_country_code( `sudan`, `SD` ).
valid_taulia_country_code( `suriname`, `SR` ).
valid_taulia_country_code( `swaziland`, `SZ` ).
valid_taulia_country_code( `sweden`, `SE` ).
valid_taulia_country_code( `switzerland`, `CH` ).
valid_taulia_country_code( `syria`, `SY` ).
valid_taulia_country_code( `tajikistan`, `TJ` ).
valid_taulia_country_code( `tanzania`, `TZ` ).
valid_taulia_country_code( `thailand`, `TH` ).
valid_taulia_country_code( `timor-leste (east timor)`, `TL` ).
valid_taulia_country_code( `togo`, `TG` ).
valid_taulia_country_code( `tonga`, `TO` ).
valid_taulia_country_code( `trinidad and tobago`, `TT` ).
valid_taulia_country_code( `tunisia`, `TN` ).
valid_taulia_country_code( `turkey`, `TR` ).
valid_taulia_country_code( `turkmenistan`, `TM` ).
valid_taulia_country_code( `tuvalu`, `TV` ).
valid_taulia_country_code( `uganda`, `UG` ).
valid_taulia_country_code( `ukraine`, `UA` ).
valid_taulia_country_code( `united arab emirates`, `AE` ).
valid_taulia_country_code( `united kingdom`, `GB` ).
valid_taulia_country_code( `united states`, `US` ).
valid_taulia_country_code( `uruguay`, `UY` ).
valid_taulia_country_code( `uzbekistan`, `UZ` ).
valid_taulia_country_code( `vanuatu`, `VU` ).
valid_taulia_country_code( `vatican city`, `VA` ).
valid_taulia_country_code( `venezuela`, `VE` ).
valid_taulia_country_code( `vietnam`, `VN` ).
valid_taulia_country_code( `yemen`, `YE` ).
valid_taulia_country_code( `zambia`, `ZM` ).
valid_taulia_country_code( `zimbabwe`, `ZW` ).
valid_taulia_country_code( `abkhazia`, `GE` ).
valid_taulia_country_code( `china, republic of (taiwan)`, `TW` ).
valid_taulia_country_code( `nagorno-karabakh`, `AZ` ).
valid_taulia_country_code( `northern cyprus`, `CY` ).
valid_taulia_country_code( `pridnestrovie (transnistria)`, `MD` ).
valid_taulia_country_code( `somaliland`, `SO` ).
valid_taulia_country_code( `south ossetia`, `GE` ).
valid_taulia_country_code( `ashmore and cartier islands`, `AU` ).
valid_taulia_country_code( `christmas island`, `CX` ).
valid_taulia_country_code( `cocos (keeling) islands`, `CC` ).
valid_taulia_country_code( `coral sea islands`, `AU` ).
valid_taulia_country_code( `heard island and mcdonald islands`, `HM` ).
valid_taulia_country_code( `norfolk island`, `NF` ).
valid_taulia_country_code( `new caledonia`, `NC` ).
valid_taulia_country_code( `french polynesia`, `PF` ).
valid_taulia_country_code( `mayotte`, `YT` ).
valid_taulia_country_code( `saint barthelemy`, `GP` ).
valid_taulia_country_code( `saint martin`, `GP` ).
valid_taulia_country_code( `saint pierre and miquelon`, `PM` ).
valid_taulia_country_code( `wallis and futuna`, `WF` ).
valid_taulia_country_code( `french southern and antarctic lands`, `TF` ).
valid_taulia_country_code( `clipperton island`, `PF` ).
valid_taulia_country_code( `bouvet island`, `BV` ).
valid_taulia_country_code( `cook islands`, `CK` ).
valid_taulia_country_code( `niue`, `NU` ).
valid_taulia_country_code( `tokelau`, `TK` ).
valid_taulia_country_code( `guernsey`, `GG` ).
valid_taulia_country_code( `isle of man`, `IM` ).
valid_taulia_country_code( `jersey`, `JE` ).
valid_taulia_country_code( `anguilla`, `AI` ).
valid_taulia_country_code( `bermuda`, `BM` ).
valid_taulia_country_code( `british indian ocean territory`, `IO` ).
valid_taulia_country_code( `british sovereign base areas`, `` ).
valid_taulia_country_code( `british virgin islands`, `VG` ).
valid_taulia_country_code( `cayman islands`, `KY` ).
valid_taulia_country_code( `falkland islands (islas malvinas)`, `FK` ).
valid_taulia_country_code( `gibraltar`, `GI` ).
valid_taulia_country_code( `montserrat`, `MS` ).
valid_taulia_country_code( `pitcairn islands`, `PN` ).
valid_taulia_country_code( `saint helena`, `SH` ).
valid_taulia_country_code( `south georgia & south sandwich islands`, `GS` ).
valid_taulia_country_code( `turks and caicos islands`, `TC` ).
valid_taulia_country_code( `northern mariana islands`, `MP` ).
valid_taulia_country_code( `puerto rico`, `PR` ).
valid_taulia_country_code( `american samoa`, `AS` ).
valid_taulia_country_code( `baker island`, `UM` ).
valid_taulia_country_code( `guam`, `GU` ).
valid_taulia_country_code( `howland island`, `UM` ).
valid_taulia_country_code( `jarvis island`, `UM` ).
valid_taulia_country_code( `johnston atoll`, `UM` ).
valid_taulia_country_code( `kingman reef`, `UM` ).
valid_taulia_country_code( `midway islands`, `UM` ).
valid_taulia_country_code( `navassa island`, `UM` ).
valid_taulia_country_code( `palmyra atoll`, `UM` ).
valid_taulia_country_code( `u.s. virgin islands`, `VI` ).
valid_taulia_country_code( `wake island`, `UM` ).
valid_taulia_country_code( `hong kong`, `HK` ).
valid_taulia_country_code( `macau`, `MO` ).
valid_taulia_country_code( `faroe islands`, `FO` ).
valid_taulia_country_code( `greenland`, `GL` ).
valid_taulia_country_code( `french guiana`, `GF` ).
valid_taulia_country_code( `guadeloupe`, `GP` ).
valid_taulia_country_code( `martinique`, `MQ` ).
valid_taulia_country_code( `reunion`, `RE` ).
valid_taulia_country_code( `aland`, `AX` ).
valid_taulia_country_code( `aruba`, `AW` ).
valid_taulia_country_code( `netherlands antilles`, `AN` ).
valid_taulia_country_code( `svalbard`, `SJ` ).
valid_taulia_country_code( `ascension`, `AC` ).
valid_taulia_country_code( `tristan da cunha`, `TA` ).
valid_taulia_country_code( `australian antarctic territory`, `AQ` ).
valid_taulia_country_code( `ross dependency`, `AQ` ).
valid_taulia_country_code( `peter i island`, `AQ` ).
valid_taulia_country_code( `queen maud land`, `AQ` ).
valid_taulia_country_code( `british antarctic territory`, `AQ` ).

%-----------------------------------------------------------------------
% Sender Name Lookup
%-----------------------------------------------------------------------
sender_name_lookup(`macmall`, `MacMall`).
sender_name_lookup(`quickbooks`, `Quickbooks`).
sender_name_lookup(`akoni kama`, `AKoni Kama`).
sender_name_lookup(`high performance coaching`, `High Performance Coaching`).
sender_name_lookup(`us foods`, `US Foods Inc.`).
sender_name_lookup(`authentic connections`, `Authentic Connections Inc.`).
sender_name_lookup(`anthem systems`, `Anthem Systems Integration LLC`).
sender_name_lookup(`best models`, `Best Agency`).
sender_name_lookup(`zone solutions`, `Zone Solutions`).
sender_name_lookup(`dayzad law`, `Dayzad Law Offices P.C.`).
sender_name_lookup(`fred bakht`, `Fred Bakht M.D.`).
sender_name_lookup(`certex`, `Certex`).
sender_name_lookup(`avis`, `Avis Rent A Car Systems Inc.`).
sender_name_lookup(`crane`, `Crane Worldwide Logistics LLC`).
sender_name_lookup(`taulia invoice`, `Taulia Invoice`).
sender_name_lookup(`charter supply co`, `Carter Supply Company`).
sender_name_lookup(`murphy shipping`, `Murphy Shipping and Commercial Services Inc.`).
sender_name_lookup(`excelsior transport`, `Excelsior Transportation Inc.`).
sender_name_lookup(`harris caprock`, `Harris CapRock Communications Inc.`).
sender_name_lookup(`art catering`, `Art Catering Inc.`).
sender_name_lookup(`med apparel services`, `Med-Apparel Services Inc.`).
sender_name_lookup(`international medicine pd`, `International Medicine Center`).
sender_name_lookup(`gap wireless`, `Gap Wireless`).
sender_name_lookup(`intergraph`, `Intergraph Canada Ltd.`).
sender_name_lookup(`hufco`, `HUFCO`).
sender_name_lookup(`lowen`, `Lowen Corporation`).
sender_name_lookup(`taulia inc`, `Taulia Inc.`).
sender_name_lookup(`falck safety services`, `Falck Safety Services`).
sender_name_lookup(`tanks a lot`, `Tanks-A-Lot Inc.`).
sender_name_lookup(`abcam`, `Abcam Inc.`).
sender_name_lookup(`garfunkel`, `Garfunkel Wild P.C.`).
sender_name_lookup(`sonesta es suites`, `Sonesta Es Suites`).
sender_name_lookup(`sam weiss woodworking`, `Sam Weiss`).
sender_name_lookup(`worldwide oilfield machine`, `Worldwide Oilfield`).
sender_name_lookup(`international sos`, `International SOS`).
