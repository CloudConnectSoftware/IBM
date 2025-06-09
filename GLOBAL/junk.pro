%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - JUNK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( junk_rules, `12:59 03 February 2016` ).

i_pdf_parameter( max_pages, 1 ).

i_op_param( email_decision, _, _, _, _, do_not_email ).
i_op_param( report, _, _, _, `JUNK` ).
i_op_param( report_addr, _, _, _, `do.not.process@cloud-trade.net` ).

%=======================================================================
i_no_lines_rule( junk, Error, Error_str, Error, Error_str ).
%=======================================================================
i_rule_list( [ junk ] ).
%=======================================================================
i_rule( junk, [ set( ignore_enquire ), force_result(`defect`), force_sub_result( `junk` ), set( i_analyse_junk_flag ), sender_name(`Unrecognised`) ] ).
%=======================================================================