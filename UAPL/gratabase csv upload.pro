%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - GRATABASE CSV UPLOAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


i_version( gratabase_csv_upload, `17/03/2017 14:50:21` ).

i_op_param( final_script_file_name, _, _, _, `office.ps1` ).
i_op_param( final_script_function_name, _, _, _, `csv_to_azure` ).

i_op_param( email_decision, _, _, _, do_not_email ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_op_param( gratabase_table_name, _, _, _, Table )
:- 
    i_mail( attachment, Table ), 
    q_sys_string_ends( Table, `.csv` )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_no_lines_rule( upload_trace, In1, In2, In1, In2 ).
i_rule_list( [ upload_trace ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% upload_trace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( upload_trace, [
%=======================================================================

    debug( [ `Uploading to Azure` ] )
    , force_result( `defect` )
    , force_sub_result( `i_analyse_statement_correspondence` ) % It is a non-invoice document
    , sender_name( `Automated Table Upload` )
    , set( ignore_enquire )

] ).
