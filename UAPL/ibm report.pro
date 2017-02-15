%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM REPORT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ibm_report, `6 May 2016` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_ignore_enquire.

i_op_param( output, _, _, _, raw ).
i_op_param( output_file_type, _, _, _, `txt` ).
i_pdf_parameter( no_scaling, 1 ).

i_op_param( email_decision, _, _, _, email ) :- rules_result( _, daily_report, _ ).
i_op_param( email_decision, _, _, _, do_not_email ).

i_op_param( send_result( _ ) , _, _, _, true ).
i_op_param( send_image( _ ) , _, _, _, false ).
i_op_param( send_original( _ ) , _, _, _, true ).
i_op_param( send_pdf_image( _ ) , _, _, _, false ).


i_op_param( o_mail_subject, _, _, _, `IBM Daily Report` ).
i_op_param( o_mail, _, _, _, ibm_report_text ).

ibm_report_text
:- 
	i_ibm_name( From, N4 )
	, strcat_list( [ `Find attached daily report: `, N4 ], TEXT )
	, writeln_proc_file_predicate( o_mail( text, TEXT ) )
.


i_op_param( send_original_name, _, _, _, NAME ) :- i_mail(attachment, NAME ).
i_op_param( send_result_name, _, _, _, N4 ) :- i_ibm_name( From, N4 ).
i_op_param( output_transfer_name( From ), _, _, _, N4 ) :- i_ibm_name( From, N4 ).

i_ibm_name( From, N4 )
:-
	i_mail(attachment, N1)
	, strip_string2_from_filename1( N1, `.`, N2 )
	, sys_string_length( N2, N2_LEN )
	, sys_calculate( N3_START, N2_LEN - 13 )
	, q_sys_sub_string(N2, N3_START, 8, N3)
	, strcat_list( [ `Recon_`, N3, `0000.txt` ], N4 )
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	write_all

	, set_result
	
	, set( ignore_enquire )
	
] ).


%=======================================================================
i_rule( set_result, [ q0n(line), success_line, force_result(`success`), force_sub_result( `daily_report`), invoice_type(`REPORT`) ]).
%=======================================================================

%=======================================================================
i_rule( set_result, [ force_result(`defect`), force_sub_result( `empty_report`) ]).
%=======================================================================


i_section_quiet( write_all ). 

%=======================================================================
i_section( write_all, [
%=======================================================================

	peek_ahead( success_line )

	, report_line

] ).

%=======================================================================
i_line_rule( success_line, [ q0n(anything), `,`, q10(`"`), `success`,  q10(`"`), `,` ] ).
%=======================================================================


%=======================================================================
i_line_rule_cut( report_line, [
%=======================================================================

	qn0(anything), `,`, q10(`"`)

	, doc_id(sf), q10(`"`), newline

	, trace([ `line`, doc_id ])

%	, write([ `CT Transaction #` ]) 

	, write([ doc_id ])

	, write_input

	, write_nl

]).
