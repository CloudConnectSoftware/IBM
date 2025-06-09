%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_SUPPORTING_DOCUMENT_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_supporting_document_v2, `03/03/2023 08:20:57` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SET INVOICE MARKER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_last:- i_analyse_invoice_marker___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_marker___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	(	(	missed_data_items_condition
			;	i_error_empty
			;	i_error_pdf_error
			;	i_error_unsupported_file_type
			;	grammar_set( i_analyse_supporting_document )
		),
		set_imail_data( `invoice`, `false` ),
        warn( [ `Document marked as potential supporting document by u_supporting_document_v2.pro` ] )
		;	set_imail_data( `invoice`, `true` ),
        	warn( [ `Document marked as invoice by u_supporting_document_v2.pro` ] )
	),
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DELAY ATTACHMENTS AND DETECT SUPPORTING DOCUMENT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_last:- i_analyse_attachment_delay___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_attachment_delay___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( grammar_set( send_to_cira_ui ) ),
	i_mail( invoice_number, 1 ),
	i_mail( num_attachments, Num ),
	Num > 1,
	Num < 15,
	(	missed_data_items_condition
		;	i_error_empty
		;	i_error_pdf_error
		;	i_error_unsupported_file_type
		;	grammar_set( i_analyse_supporting_document )
	),

	trace( [ `Checking if supporting document` ] ),

	sys_findall(
		Attachment,
		q_imail_data_partner_attachment( Attachment ),
		List_of_Attachments
	),
	sys_length( List_of_Attachments, Attachment_Count ),
	sys_calculate( Number_of_Available_Attachments, Attachment_Count + 1 ),

	(	(	trace( [ `Checking if partner attachments available` ] ),
			Number_of_Available_Attachments \= Num, % Means attachment which may be an invoice has not processed yet
			Trace = `Partner attachment(s) not yet received, delaying`,
			Delay_Mins = 1

			;	q_imail_data_partner_attachment( File ),
				trace( [ `Checking if partner attachment has processed`, File ] ),
				not( q_imail_data( File, `invoice`, _ ) ), % Checks whether it has been set - if not then File has not yet processed
				strcat_list( [ File, ` has not been processed yet, delaying` ], Trace ),
				Delay_Mins = Num
		),
		completed( split, _, _, _, Date_Time ),
		datetime_get( now, Date_Time_Now ),
		datetime_difference( Date_Time_Now, Date_Time, [ years( YDiff ), months( MonDiff ), days( DDiff ), hours( HDiff ), mins( MinDiff ), secs( SDiff ) ] ),
		(	(	YDiff > 0
				;	MonDiff > 0
				;	DDiff > 0
				;	HDiff > 3
			),
			trace( [ `Completed split over 4 hours ago, skipping delay` ] )
		
			;	sys_assertz( grammar_set( chain, `*delay*` ) ),
				sys_assertz( grammar_set( delay_mins, Delay_Mins ) ),
				set_imail_data( `delayed_document`, `true` ),
				trace( [ Trace ] )
		)

		;	q_imail_data_partner_attachment( File ),
			trace( [ `Checking if partner attachment is invoice with include_partner_attachments_image_only`, File ] ),
			q_imail_data( File, `include_partner_attachments_image_only`, `true` ), % Checks that it has been set to 'true'
			q_imail_data( File, `invoice`, `true` ), % Checks that it has been set to 'true'
			(	grammar_set( i_analyse_supporting_document )
				;	sys_assertz( grammar_set( i_analyse_supporting_document ) )
			),
			trace( [ `SUPPORTING DOCUMENT DETECTED` ] ),
			sys_assertz( grammar_set( ignore_enquire ) ),
			assertz_derived_data( invoice, force_sub_result, `i_analyse_supporting_document`, i_analyse_supporting_document ),
			assertz_derived_data( invoice, force_result, `defect`, i_forced_defect )
		
	),
	
	!
.
