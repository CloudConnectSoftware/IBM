%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - GENERIC RULES for Taulia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( generic_taulia_rules, `14th Aug 2013` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_user_field( invoice, start_of_invoice_page, `record the page that an invoice starts` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hard coded values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_list( [
%=======================================================================

	get_buyer_and_supplier_codes

	, currency(`USD`)
	
	, set( ignore_enquire )
] ).

%=======================================================================
i_rule( get_buyer_and_supplier_codes, [
%=======================================================================

	supplier_registration_number( FROM )

	, buyer_registration_number( TO )
] )

:-

	i_mail( from, FROM )

	, i_mail( to, TO )
.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify start of invoice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_list( [
%=======================================================================

	[ q0n( line ), identify_start_of_invoice ]
] ).

%=======================================================================
i_line_rule( identify_start_of_invoice, [
%=======================================================================

	gen_start_of_phrase

	, q( 0, 3, word )

	, read_ahead( `invoice` )

	, dummy(s1)

	, check( i_user_check( gen_same, dummy(page), PAGE ) )

	, start_of_invoice_page( PAGE )

	, trace( [ `invoice starts on page`, start_of_invoice_page ] )
] ).

%=======================================================================
i_rule( page_check, [
%=======================================================================

	with( invoice, start_of_invoice_page, START )

	, dummy(w1)

	, check( dummy(page) >= START )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search for Totals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_list( [
%=======================================================================

	hunt_for_possible_horizontal_totals

	, choose_total
] ).

%=======================================================================
i_section_quiet( hunt_for_possible_horizontal_totals ).
%=======================================================================
i_section( hunt_for_possible_horizontal_totals, [
%=======================================================================

	peek_ahead( possible_horizontal_total )

	, read_horizontal_total( [ STRENGTH ] )

	, check( i_user_check( store_total_data, STRENGTH, possible_total, possible_total(font), possible_total(size), possible_total(end), possible_total(y) ) )
] ).

%=======================================================================
i_line_rule( possible_horizontal_total, [
%=======================================================================

	page_check

	, or( [ check_text( `total` ), check_text( `amount` ), check_text( `due` ) ] )
] ).

%=======================================================================
i_line_rule_cut( read_horizontal_total( [ STRENGTH ] ), [
%=======================================================================

	gen_start_of_phrase

	, read_ahead( anchor(s1) )

	, q0n( word )

	, or( [ `total`, `amount`, `due` ] )

	, q0n( word )

	, q0n( or( [ `USD`, `$`, tab ] ) )

	, check( i_user_check( evaluate_total_anchor, anchor, STRENGTH ) )

	, possible_total( fd( [ begin, q( [ dec, other(",") ], 1,10 ), q( other("."), 1, 1 ), q( dec, 2, 2 ), end ] ) )
	
	, or( [ tab, newline ] )
] ).

%=======================================================================
i_user_check( evaluate_total_anchor, ANCHOR, STRENGTH )
%-----------------------------------------------------------------------
:-
%=======================================================================

	string_to_lower( ANCHOR, L_ANCHOR )

	, sys_findall( PLUS, ( positive_total_anchor( L_ANCHOR ), PLUS = 1 ), PLUS_LIST )

	, sys_findall( MINUS, ( negative_total_anchor( L_ANCHOR ), MINUS = 1 ), MINUS_LIST )

	, sys_length( PLUS_LIST, PLUS_LEN )

	, sys_length( MINUS_LIST, MINUS_LEN )

	, sys_calculate( STRENGTH, PLUS_LEN - MINUS_LEN )
.

%=======================================================================
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `due` ).
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `total` ).
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `amount` ).
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `this` ).
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `inc` ).
positive_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `invoice` ).
%=======================================================================
negative_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `tax` ).
negative_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `exc` ).
negative_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `date` ).
negative_total_anchor( ANCHOR ) :- q_sys_sub_string( ANCHOR, _, _, `sub` ).
negative_total_anchor( ANCHOR ) :- sys_member( DIGIT, [ `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9` ] ), q_sys_sub_string( ANCHOR, _, _, DIGIT ).
%=======================================================================

%=======================================================================
i_user_check( store_total_data, STRENGTH, TOTAL, FONT, SIZE, END, Y )
%-----------------------------------------------------------------------
:-
%=======================================================================

	ifont( FONT, F_TEXT )

	, string_to_lower( F_TEXT, LF_TEXT )

	, ( q_sys_sub_string( LF_TEXT, _, _, `bold` ) -> BOLD = 1 ; BOLD = 0 )

	, sys_assertz( i_user_data( total_horizontal_data, STRENGTH, TOTAL, BOLD, SIZE, END, Y ) )

	, trace( i_user_data( total_horizontal_data, STRENGTH, TOTAL, BOLD, SIZE, END, Y ) )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( choose_total, [
%=======================================================================

	or( [
		[
			check( i_user_check( retrieve_total, total_horizontal_data, TOTAL ) )
			
			, total_invoice( TOTAL )

			, trace( [ `horizontal total found`, total_invoice ] )
		]

		, [
			check( i_user_check( retrieve_total, total_vertical_data, TOTAL ) )
			
			, total_invoice( TOTAL )

			, trace( [ `horizontal total found`, total_invoice ] )
		]

		, trace( [ `NO TOTAL FOUND` ] )

	] )
] ).


%=======================================================================
i_user_check( retrieve_total, DATA_SOURCE, MAX_TOTAL )
%-----------------------------------------------------------------------
:-
%=======================================================================

	( i_user_data( DATA_SOURCE, _, _, 1, _, _, _ ) -> BOLD = 1 ; BOLD = 0 )

	, sys_findall( STRENGTH, i_user_data( DATA_SOURCE, STRENGTH, _, BOLD, _, _, _ ), STRENGTH_LIST )

	, sys_sort( STRENGTH_LIST, REV_STRENGTH_LIST )

	, sys_reverse( REV_STRENGTH_LIST, [ MAX_STRENGTH | _ ] )

	, sys_findall( TOTAL, i_user_data( DATA_SOURCE, MAX_STRENGTH, TOTAL, BOLD, _, _, _ ), TOTAL_LIST )

	, sys_sort( TOTAL_LIST, REV_TOTAL_LIST )

	, sys_reverse( REV_TOTAL_LIST, [ MAX_TOTAL | _ ] )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search for anchored data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule_list( [
%=======================================================================

	search_for_anchored_data( [ invoice_number_check_text, invoice_number_anchor, invoice_number, s1 ] )

	, search_for_anchored_data( [ order_number_check_text, order_number_anchor, order_number, s1 ] )

	, search_for_anchored_data( [ invoice_date_check_text, invoice_date_anchor, invoice_date, date(`m/d/y`) ] )

	, [ with( invoice_date ), invoice_date_format( `m/d/y` ) ]

	, search_for_anchored_data( [ invoice_date_check_text, invoice_date_anchor, invoice_date, date ] )
] ).

%=======================================================================
i_section_quiet( search_for_anchored_data( [ CHECK, ANCHOR, VARIABLE, TYPE ] ) ).
%=======================================================================
i_section( search_for_anchored_data( [ CHECK, ANCHOR, VARIABLE, TYPE ] ), [
%=======================================================================

	peek_ahead( CHECK )

	, WITHOUT_RULE

	, or( [
		read_horizontal_anchored_data( [ ANCHOR, VARIABLE, TYPE ] )

		, [	read_vertical_anchor( [ ANCHOR, START, END ] )
			, qn0( gen_line_nothing_here( [ START, END, 50, 50 ] ) )
			, read_vertical_data( [ START, END, VARIABLE, TYPE ] )
		]
	] )

] )
:-
	WITHOUT_RULE =.. [ without, VARIABLE ]
.

%=======================================================================
i_line_rule( read_horizontal_anchored_data( [ ANCHOR, VARIABLE, TYPE ] ), [
%=======================================================================

	gen_start_of_phrase

	, ANCHOR

	, qn0( or( [ `.`, `:`, `-`, tab ] ) )

	, READ_VARIABLE

	, TRACE_READ
] )
:-
	READ_VARIABLE =.. [ VARIABLE, TYPE ]

	, sys_string_atom( VARIABLE_STR, VARIABLE )

	, TRACE_READ =.. [ trace, [ `horizontal read`, VARIABLE_STR, VARIABLE ] ]
.

%=======================================================================
i_line_rule( read_vertical_anchor( [ ANCHOR, START, END ] ), [
%=======================================================================

	gen_start_of_phrase

	, read_ahead( anchor )

	, ANCHOR

	, check( i_user_check( gen_same, anchor(start), START ) )

	, check( i_user_check( gen_same, anchor(end), END ) )
] ).

%=======================================================================
i_line_rule( read_vertical_data( [ START, END, VARIABLE, TYPE ] ), [
%=======================================================================

	nearest( START, END, 50, 50 )

	, READ_VARIABLE

	, TRACE_READ
] )
:-
	READ_VARIABLE =.. [ VARIABLE, TYPE ]

	, sys_string_atom( VARIABLE_STR, VARIABLE )

	, TRACE_READ =.. [ trace, [ `vertical read`, VARIABLE_STR, VARIABLE ] ]
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Invoice Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule_cut( invoice_number_check_text, [ page_check, or([ check_text( `invoice` ), check_text( `bill` ) ])  ] ).
%=======================================================================

%=======================================================================
i_rule_cut( invoice_number_anchor, [
%=======================================================================

	or([ `invoice`, `bill` ])

	, or( [ `number`, `num`, `no`, `#`, `:`, tab ] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Order Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule_cut( order_number_check_text, [ page_check, check_text( `order` ) ] ).
%=======================================================================

%=======================================================================
i_rule_cut( order_number_anchor, [
%=======================================================================

	`order`

	, or( [ `number`, `num`, `no`, `#` ] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Invoice Date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule_cut( invoice_date_check_text, [ page_check, check_text( `date` ) ] ).
%=======================================================================

%=======================================================================
i_rule_cut( invoice_date_anchor, [
%=======================================================================

	q10( `invoice` )
	
	, `date`
] ).

