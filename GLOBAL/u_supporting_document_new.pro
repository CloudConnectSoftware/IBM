%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_SUPPORTING_DOCUMENT_NEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_supporting_document_new, `08/08/2018 11:00:06` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DELAY ATTACHMENTS AND DETECT SUPPORTING DOCUMENT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_first:- i_analyse_attachment_delay___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_attachment_delay___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	i_mail( invoice_number, 1 ),
	
	i_mail( num_attachments, Num ),

	Num > 1,

	Num < 15,

	Delay_Mins = Num,

	(
		q_imail_data_partner_attachment( File ),
		
		not( q_imail_data( File, `include_partner_attachments_image_only`, _ ) ),
	
		completed( preprocessed, `ok`, _, _, Date_Time ),
		
		datetime_get( now, Date_Time_Now ),
		
		datetime_difference( Date_Time_Now, Date_Time, [ years( YDiff ), months( MonDiff ), days( DDiff ), hours( HDiff ), mins( MinDiff ), secs( SDiff ) ] ),

		(
			YDiff > 0
			
			;
			
			MonDiff > 0
			
			;
			
			DDiff > 0
			
			;
			
			HDiff > 3
			
		),
		
		trace( [ `Completed preprocess over 4 hours ago, skipping delay` ] )

		;

		q_imail_data_partner_attachment( File ),
		
		not( q_imail_data( File, `include_partner_attachments_image_only`, _ ) ),
		
		trace( [ File, `has not been processed yet, delaying` ] ),
		
		sys_assertz( grammar_set( chain, `*delay*` ) ), sys_assertz( grammar_set( delay_mins, Delay_Mins ) )
	
		;
	
		q_imail_data_partner_attachment( File ),
		
		q_imail_data( File, `include_partner_attachments_image_only`, `true` ),
		
		(
			(
				missed_data_items_condition
				
				;
				
				i_error_empty
				
				;
				
				i_error_pdf_error
				
				;
				
				i_error_unsupported_file_type
				
				;
				
				grammar_set( i_analyse_supporting_document )
				
			),
		
			(
				grammar_set( i_analyse_supporting_document )
				
				;
				
				sys_assertz( grammar_set( i_analyse_supporting_document ) )
				
			)
			
			;
			
			grammar_set( i_analyse_supporting_document )
			
		),
		
		trace( [ `SUPPORTING DOCUMENT DETECTED`, File ] ),
		sys_assertz( grammar_set( ignore_enquire ) ),
		assertz_derived_data( invoice, force_sub_result, `i_analyse_supporting_document`, i_analyse_supporting_document ),
		assertz_derived_data( invoice, force_result, `defect`, i_forced_defect )

		;

		set_imail_data( `non_supporting_document`, `true` )
		
	),
	
	!
.
