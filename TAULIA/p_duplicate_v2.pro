%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - P_DUPLICATE_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_duplicate_v2, `13/12/2022 14:09:21` ).

%===============================================================================
i_analyse_fields_last:- i_analyse_duplicate_invoice.
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

	%	Duplicate check requires a 'table' name
	(	qq_op_param( duplicate_table_to_use, Table ) -> true
		;	debug( [ `Duplicates not checked as table not specified` ] ), !, fail
	),

	%	Needs to remove this once the previous gratabase method is failing
	create_basic_invoice_table_if_necessary( Table ),
	% grammar_set( table_exists ),


	(	result( _, invoice, sending_organisation, Sender ), % Should always be taken from document

		%	Prefer document based (allows it to change) but global setting is fine if missing
		(	result( _, invoice, receiving_organisation, Receiver )
			;	qq_op_param( receiving_organisation, Receiver )
		),

		result( _, invoice, invoice_number, InvNumber ),

		(	qq_op_param( duplicate_check_exclude_total_invoice, true )
			->	Total_New = `0`
			;	result( _, invoice, total_invoice, Total ),
				Total = Total_New
		),

		(	qq_op_param( duplicate_check_exclude_invoice_date, true )
			->	RawDate = date( 2020, 1, 1 ),
				Date_New = `01/01/2020`
			;	result( _, invoice, date, RawDate ),
				(	i_no_dmy_dates
					->	RawDate = date( Y, M, D ),
						sys_string_number( Year, Y ),
						sys_string_number( M_String, M ),
						string_pad_left( M_String, 2, `0`, Month ),
						sys_string_number( D_String, D ),
						string_pad_left( D_String, 2, `0`, Day ),
						strcat_list( [ Day, `/`, Month, `/`, Year ], Date_New )
					;	date_string( RawDate, 'd/m/y', Date_New )
				)
		),

		i_mail( expected_output_file_name_after_split, File_Raw ),
		strcat_list( [ File_Raw, `.pdf` ], File ),

		(	present_in_document_occurrences( Table, File, _, _, _, _, _ )
			->	trace( [ `Specific file already processed - bypassing duplicate check` ] )

			;	grammar_set( duplicate_override )
				->	trace( [ `Duplicate check bypassed - duplicate override flag has been set` ] )

			;	present_in_document_occurrences( Table, _, Sender, Receiver, InvNumber, Date, Total ),
				trace( [ `Found in Document Occurrences Table` ] )
				->	(	check_if_present_on_whitelist( InvNumber, RawDate, Total_New )

						;	q_allow_duplicate_emails,
							strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, File ], Alert ),
							alert( Alert, 0, `hours` ),
							trace( [ Alert ] )

						;	sys_assertz( grammar_set( i_analyse_duplicate ) ),
							trace( [ `Duplicate invoice rejected:`, Sender, Receiver, InvNumber, Total, Date ] )
					)

				% Beyond here Gramatica is resorting back to the original variation
			;	grammar_set( table_exists ),
				q_gratabase_lookup_one( Table, [ `general`, Sender, Receiver, InvNumber, _, _, _ ], [ _, _, _, _, TotalOrDateLookup, DateOrTotalLookup2, Original ], Available )
				->	(	q_sys_comp( Available = false )
						->	trace( [ Table, `Existence check, database disappeared` ] )

						;	trace( [ `Found in Original Gratabase Duplicate Table` ] ),
							(	check_if_present_on_whitelist( InvNumber, RawDate, Total_New )

								;	q_allow_duplicate_emails,
									strcat_list( [ `Duplicate Emails Left On - Duplicate Processed - `, File ], Alert ),
									alert( Alert, 0, `hours` ),
									trace( [ Alert ] )

								;	File = Original,
									trace( [ `ALERT: Duplicate file - Duplicate Processed` ] )

								;	(	q_regexp_match( `^\\d+\\/\\d+\\/\\d+$`, TotalOrDateLookup, _ )
										->	DateLookup = TotalOrDateLookup,
											TotalLookup = DateOrTotalLookup2

										;	DateLookup = DateOrTotalLookup2,
											TotalLookup = TotalOrDateLookup
									),

									(	qq_op_param( duplicate_check_exclude_total_invoice, true )
										->	true
											% To compare totals regardless of leading or trailing zeroes
										;	q_sys_comp_str_eq( Total, TotalLookup )
									),

									(	qq_op_param( duplicate_check_exclude_invoice_date, true )
										->	true
											% To compare dates regardless of format - needs to be adjusted if US dates are used
										;	date_string( DateLookup_RAW, 'd/m/y', DateLookup ),
											date_compare( RawDate, =, DateLookup_RAW )
									),

									sys_assertz( grammar_set( i_analyse_duplicate ) ),
									trace( [ `Duplicate invoice rejected:`, Sender, Receiver, InvNumber, Total, Date ] )

							)

					)

			;	sys_assertz( i_user_data( new_invoice_detected, Table, Sender, Receiver, InvNumber, Total_New, Date_New, File ) )
		)

 		;	trace( [ `Duplicate Document Detcection IGNORED due to lack of data: ` ] ),
			( result( _, invoice, sending_organisation, _ ) ; trace( [ `Missing sending_organisation` ] ) ),
			( ( result( _, invoice, receiving_organisation, _ ) ; qq_op_param( receiving_organisation, _ ) ) ; trace( [ `Missing receiving_organisation` ] ) ),
			( result( _, invoice, invoice_number, _ ) ; trace( [ `Missing invoice_number` ] ) ),
			( result( _, invoice, total_invoice, _ ) ; trace( [ `Missing total_invoice` ] ) ),
			( result( _, invoice, date, _ ) ; trace( [ `Missing date` ] ) ),
			( i_mail( file, _ ) ; trace( [ `Missing file name` ] ) )

	),
	
	!
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
	i_user_data( new_invoice_detected, Table, Sender, Receiver, InvNumber, Total, Date, File ),

	(	Enq = true
		->	trace( [ `Document destined for intervention, not written to database` ] )

		;	instance( Inst )
			, string_to_upper( Inst, INST )
			, q_sys_sub_string( INST, _, _, `DBG` )
			, trace( [ `DBG Instance Found - Not Writing to DB`, Sender, Receiver, InvNumber, Total, Date, File ] )
			, set_imail_data( `completed_processing`, `true` )

		;	(	process_status( defect, _, _ )

				;	result( _, invoice, force_result, `defect` )
			)

			->	trace( [ `Document has defected, not written to database`, Sender, Receiver, InvNumber, Total, Date, File ] ),
				set_imail_data( `completed_processing`, `true` )

		;	(	process_status( failed, _, _ )

				;	result( _, invoice, force_result, `failed` )
			),

			not( grammar_set( i_analyse_flag_as_fail_and_post ) ),
			not( data( i_analyse_flag_as_fail_and_post, `true` ) )

			->	trace( [ `Document has failed, not written to database`, Sender, Receiver, InvNumber, Total, Date, File ] ),
				set_imail_data( `completed_processing`, `true` )

		;	Enq = false,
			( add_to_document_occurrences( Table, File, Sender, Receiver, InvNumber, Date, Total ) % New mechanism
				->	true
				;	true
			),
			add_to_basic_invoice_table( Table, Sender, Receiver, InvNumber, Total, Date, File ), % Old Mechanism
			trace( [ `Document processed - Database populated`, Sender, Receiver, InvNumber, Total, Date, File ] ),
			set_imail_data( `completed_processing`, `true` )
	)
.

%===============================================================================
add_to_basic_invoice_table( Table, Sender, Receiver, InvNumber, Total, Date, File )
%-------------------------------------------------------------------------------
:-

	( q_gratabase_clone_table( Table, GUID )

		-> ( q_gratabase_add( GUID, [ `general`, Sender, Receiver, InvNumber, Total, Date, File ] )

			->	trace( [ `added`, Sender, Receiver, InvNumber, Total, Date, File , `to`, Table ] )

				, ( q_gratabase_allocate( GUID, Table ) ; trace( [ `failed to allocate`, Table ] ) )

			;	trace( [ `failed to add row to`, Table ] )
		)

		; trace( [ `failed to clone`, Table ] )
	)
.
%===============================================================================

%===============================================================================
check_if_present_on_whitelist( Invoice, RawDate, Total )
%-------------------------------------------------------------------------------
:-
	qq_op_param( duplicate_check_abs_whitelist_table, WhiteTable ),
	result( _, invoice, buyers_code_for_supplier, BCFS ),
	q_gratabase_check_table_exists( WhiteTable, WEAvail ),
	WEAvail == `True`,
	result( _, invoice, buyers_code_for_supplier, BCFS ),

	q_gratabase_lookup( WhiteTable,
		[ _, _, _, BCFS, _, _, _, _, _, _, _, _, Invoice, _ ],
		[ _, _, _, BCFS, _, _, _, _, GrossWL, _, DateWL, _, Invoice, _ ],
		%	PO - second PArameter
		_ % Don't need avaialbility as there's comparisons after
	),

	date_string( WLDatePro, _, DateWL ),
	date_compare( RawDate, =, WLDatePro ),

	q_sys_comp_str_eq( GrossWL, Total ),
	sys_assertz( grammar_set( i_analyse_whitelisted_duplicate ) ),
	trace( [ `Invoice on whitelist - ignoring duplicate check` ] ).
%===============================================================================