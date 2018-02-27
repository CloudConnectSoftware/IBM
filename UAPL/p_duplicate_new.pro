%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - RULES FOR "DUPLICATE" PROCESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_duplicate_new, `31/08/2017 11:55:04` ).

%	Changed the logic slightly - new check to check if it exists
%	Then used the call to return one value - there should never be more than one
%
%	Updated to take advantage of a new analysis available to check the enquiry state
%	If the document is destined for enquire then it will not be added to the database
%	Once the document comes out and SUCCEEDS it will
%
%	Strange intermittent bug - duplicates not erroring correctly.
%
%	Added FILE name to table to stop false positives on rules retries
%
%	Changed - No longer looks for the value in the table
%	Now returns the value and compares it for a duplicate
%
%	Update - no longer directly looks up the date, instead compares it
%

%===============================================================================
i_analyse_fields_last :- i_analyse_duplicate_invoice.
%===============================================================================

%===============================================================================
i_analyse_duplicate_invoice
%-------------------------------------------------------------------------------
:- ( process_status( defect, _, E_MSG ); result( _, invoice, force_result, `defect` ) ), !, trace( [ `analyse for duplicate fields ignored because of defect `, E_MSG ] ).
%===============================================================================
i_analyse_duplicate_invoice
%-------------------------------------------------------------------------------
:- ( process_status( failed, _, E_MSG ); result( _, invoice, force_result, `failed` ) ), !, trace( [ `analyse for duplicate fields ignored because of failed `, E_MSG ] ).
%===============================================================================
ii_analyse_duplicate_invoice % Needs an update to prevent always existing enquiry conditions
%-------------------------------------------------------------------------------
:- not( i_no_enquire ), not( grammar_set( ignore_enquire ) ), enquire_question( Question ), !, trace( [ `analyse for duplicate fields ignored because of enquiry `, Question ] ).
%===============================================================================

%===============================================================================
i_analyse_duplicate_invoice
%-------------------------------------------------------------------------------
:-
%===============================================================================

	instance( Inst )

	, string_to_upper( Inst, INST )

	, not( q_sys_sub_string( INST, _, _, `DBG` ) )

	, (
		qq_op_param( duplicate_table_to_use, Table )
			->	true
			;	trace( [ `Duplicates not checked as table not specified` ] ),
				!, fail
	)

	, create_basic_invoice_table_if_necessary( Table )

	, grammar_set( table_exists )

	, (
		result( _, invoice, sending_organisation, SENDER )

		, (
			result( _, invoice, receiving_organisation, RECEIVER )

			;

			qq_op_param( receiving_organisation, RECEIVER )

		)

		, result( _, invoice, invoice_number, INVOICE )

		, result( _, invoice, total_invoice, TOTAL )

		, result( _, invoice, date, RAW_DATE )

		, date_string( RAW_DATE, 'd/m/y', DATE )

		, i_mail( file, FILE )

		, trace( `Got data` )

		, (	q_gratabase_lookup_one( Table, [ `general`, SENDER, RECEIVER, INVOICE, _, _, _ ], [ _, _, _, _, TOTAL_OR_DATE_LOOKUP, DATE_OR_TOTAL_LOOKUP_2, ORIGINAL ], Available )
			, trace( Available )

			->	( q_sys_comp( Available = false )

					-> trace( [ Table, `check, database disappeared` ] )

					;

					(	q_allow_duplicate_emails
						, strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, FILE ], Alert )
						, alert( Alert, 0, `hours` )

						;

						FILE = ORIGINAL
						, trace( [ `ALERT: Duplicate file - Duplicate Processed` ] )

						;

						(
							q_regexp_match( `^\\d+\\/\\d+\\/\\d+$`, TOTAL_OR_DATE_LOOKUP, _ )
							->	DATE_LOOKUP = TOTAL_OR_DATE_LOOKUP,
								TOTAL_LOOKUP = DATE_OR_TOTAL_LOOKUP_2

							;	DATE_LOOKUP = DATE_OR_TOTAL_LOOKUP_2,
								TOTAL_LOOKUP = TOTAL_OR_DATE_LOOKUP
						)

						%	To compare totals regardless of leading or trailing zeroes
						, q_sys_comp_str_eq( TOTAL, TOTAL_LOOKUP )

						%	To compare dates regardless of format - needs to be adjusted if US dates are used
						, date_string( DATE_LOOKUP_RAW, 'd/m/y', DATE_LOOKUP )
						, date_compare( RAW_DATE, =, DATE_LOOKUP_RAW )

						, wordcat( [ `Duplicate invoice rejected:`, SENDER, RECEIVER, INVOICE, TOTAL, DATE_LOOKUP ], E_MSG )

						, assertz_derived_data( invoice, force_sub_result, `duplicate_invoice`, i_analyse_duplicate_invoice )

						, sys_assertz( grammar_set( i_analyse_duplicate ) )

						, trace( E_MSG )
					)

				)

			; sys_assertz( i_user_data( new_invoice_detected, Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ) )
		)

 		;

		trace( [ `analyse for duplicate fields ignored because of lack of fields: ` ] )

		, ( result( _, invoice, sending_organisation, _ ) ; trace( [ `missing sending_organisation` ] ) )

		, ( ( result( _, invoice, receiving_organisation, _ ) ; qq_op_param( receiving_organisation, _ ) ) ; trace( [ `missing receiving_organisation` ] ) )

		, ( result( _, invoice, invoice_number, _ ) ; trace( [ `missing invoice_number` ] ) )

		, ( result( _, invoice, total_invoice, _ ) ; trace( [ `missing total_invoice` ] ) )

		, ( result( _, invoice, date, _ ) ; trace( [ `missing date` ] ) )

		, ( i_mail( file, _ ) ; trace( [ `missing file name` ] ) )

	)

	, !
.

%===============================================================================
create_basic_invoice_table_if_necessary( Table )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	( q_gratabase_check_table_exists( Table, Available )

		->	( q_sys_comp( Available = false )
				->	trace( [ `Cannot access database` ] )
				;	true, trace( `Table exists` ), sys_assertz( grammar_set( table_exists ) )
			)

		;	( q_gratabase_create_table( 7, GUID )

				-> ( q_gratabase_allocate( GUID, Table ),  trace( `Created and allocated table` ), sys_assertz( grammar_set( table_exists ) )

						; trace( [ `failed to allocate on creation`, Table ] )
					)

				; trace( [ `failed to create`, Table ] )
			)

	)
.

%===============================================================================
i_final_process( Enq )
%-------------------------------------------------------------------------------
:-
%===============================================================================
	i_user_data( new_invoice_detected, Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ),

	(	Enq = true
		->	trace( [ `Document destined for enquire, not written to database` ] )

		;	instance( Inst )
			, string_to_upper( Inst, INST )
			, q_sys_sub_string( INST, _, _, `DBG` )
			, trace( [ `DBG Instance Found - Not Writing to DB`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] )
			, set_imail_data( `completed_processing`, `true` )

		;	(	process_status( defect, _, E_MSG )

				;	result( _, invoice, force_result, `defect` )
			)

			->	trace( [ `Document has defected, not written to database`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
				set_imail_data( `completed_processing`, `true` )

		;	(	process_status( failed, _, E_MSG )

				;	result( _, invoice, force_result, `failed` )
			)

			->	trace( [ `Document has failed, not written to database`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
				set_imail_data( `completed_processing`, `true` )

		;	Enq = false,
			add_to_basic_invoice_table( Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ),
			trace( [ `Document processed - Database populated`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] ),
			set_imail_data( `completed_processing`, `true` )
	)
.

%===============================================================================
add_to_basic_invoice_table( Table, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE )
%-------------------------------------------------------------------------------
:-
%===============================================================================

	( q_gratabase_clone_table( Table, GUID )

		-> ( q_gratabase_add( GUID, [ `general`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE ] )

			->	trace( [ `added`, SENDER, RECEIVER, INVOICE, TOTAL, DATE, FILE , `to`, Table ] )

				, ( q_gratabase_allocate( GUID, Table ) ; trace( [ `failed to allocate`, Table ] ) )

			;	trace( [ `failed to add row to`, Table ] )
		)

		; trace( [ `failed to clone`, Table ] )
	)
.
