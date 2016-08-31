%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - PROCESS RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( p_ibm, `19 June 2015` ).


i_final_rule([ agent_code_1(N3) ]) :- i_truncate_name( From, N2 ), strcat_list( [ `IBM_`, N2  ], N3 ).

i_truncate_name( From, N2 )
:-
	i_mail(time_stamp, TS )
	, i_mail(invoice_number, IN)
	, string_string_replace( TS,  `.`, ``, TSX)
	, sys_string_number(INX, IN)
	, strcat_list( [ INX, TSX  ], N2 )
.


i_op_param( zip_transfer_name( From ), _, _, _, N3)
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.zip`  ], N3 )
.

i_op_param( output_transfer_name( From ), _, _, _, N3 )
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.ctl`  ], N3 )
.

i_op_param( input_transfer_name( From ), _, _, _, N3 )
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.pdf`  ], N3 )
.

i_op_param( split_input_transfer_name( From ), _, _, _, N3 )
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.pdf`  ], N3 )
.

i_op_param( send_result_name, _, _, _, N3 ) 
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.ctl`  ], N3 )
.

i_op_param( send_pdf_image_name, _, _, _, N3 ) 
:-
	i_truncate_name( From, N2 )
	, strcat_list( [ `IBM_`, N2, `.pdf`  ], N3 )
.


i_truncate_name( From, N2 )
:-
	i_mail(time_stamp, TS )
	, i_mail(invoice_number, IN)
	, string_string_replace( TS,  `.`, ``, TSX)
	, sys_string_number(INX, IN)
	, strcat_list( [ INX, TSX  ], N2 )
.

