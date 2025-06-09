%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_PREDICATES_AND_LOOKUPS_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_predicates_and_lookups_v2, `01/02/2023 15:50:39` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PREDICATES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- multifile header_level_item/16.
:- multifile line_level_item/16.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% CREATE STRING FROM TEMPLATE
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_string_from_template( StringIn, StringOut )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  (
        sub_string_cut( StringIn, DataStartPosition, _, `<data>` ),
        sub_string_cut( StringIn, DataEndPosition, _, `</data>` ),
        StartOfDataValue is DataStartPosition + 6,
        Length is DataEndPosition - StartOfDataValue,
        sub_string_cut( StringIn, StartOfDataValue, Length, DataName ),
        get_data_value( DataName, DataValue ),
        q_sys_is_string( DataValue ),
        strcat_list( [ `<data>`, DataName, `</data>` ], DataNamePlusTags ),
        string_string_replace( StringIn, DataNamePlusTags, DataValue, UpdateString ),
        create_string_from_template( UpdateString, StringOut )
        ;   not( q_sys_sub_string( StringIn, _, _, `<data>` ) ),
            StringIn = StringOut
    )
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_string_from_template( StringIn, StringOut, EmailAddress )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
    (
        sub_string_cut( StringIn, DataStartPosition, _, `<data>` ),
        sub_string_cut( StringIn, DataEndPosition, _, `</data>` ),
        StartOfDataValue is DataStartPosition + 6,
        Length is DataEndPosition - StartOfDataValue,
        sub_string_cut( StringIn, StartOfDataValue, Length, DataName ),
        get_data_value( DataName, DataValue, EmailAddress ),
        q_sys_is_string( DataValue ),
        strcat_list( [ `<data>`, DataName, `</data>` ], DataNamePlusTags ),
        string_string_replace( StringIn, DataNamePlusTags, DataValue, UpdateString ),
        create_string_from_template( UpdateString, StringOut, EmailAddress )
        ;   not( q_sys_sub_string( StringIn, _, _, `<data>` ) ),
            StringIn = StringOut
    )
.

sub_string_cut( In, Start, Length, SubString ):- q_sys_sub_string( In, Start, Length, SubString ), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% DBG INSTANCE
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dbg_instance
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  instance( Instance ),

  string_to_upper( Instance, Instance_U ),

  q_sys_sub_string( Instance_U, _, _, `DBG` )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% EMAIL BLACKLIST CHECK
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
email_blacklist_check( From )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  string_to_lower( From, FromL ),
  not( whitelisted_emails( FromL ) ),
  trace( `Not whitelisted` ),
  noreply_blacklist( NoRep ),
  (
    q_sys_is_string( NoRep ),
    q_sys_sub_string( FromL, _, _, NoRep )

    ;

    q_sys_is_list( NoRep ),
    sub_string_all_components( FromL, NoRep )

    ;

    not( q_sys_sub_string( FromL, _, _, `@` ) )

  ),
  trace( `Email blacklisted` ),
  !
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sub_string_all_components( _, [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sub_string_all_components( From, [ H | T ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  q_sys_sub_string( From, _, _, H ),
  sub_string_all_components( From, T )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% ENSURE SCENARIOS HAVE NOT OCCURRED
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ensure_scenarios_have_not_occurred( [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ensure_scenarios_have_not_occurred( [ First_Item | Remaining_Items ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  ensure_scenario_has_not_occurred( First_Item ),

  ensure_scenarios_have_not_occurred( Remaining_Items )

  ;

  !,

  fail
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ensure_scenario_has_not_occurred( Scenario_Keyword )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  check_scenario_dependency( Scenario_Keyword, Scenario_Dependency_List ),
  ensure_no_dependencies_are_true( Scenario_Dependency_List )
  ;
  not( check_scenario_dependency( Scenario_Keyword, _ ) )
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_scenario_dependency( Scenario_Keyword, Scenario_Dependency_List )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  sys_findall(
    Scenario_Dependency,
    (
      header_level_scenario( _, Scenario, _, _, Action, _, _, _, _, _, _, _, Scenario_Dependency ),
      Action \= `Process As Normal`,
      q_sys_sub_string( Scenario, 1, _, Scenario_Keyword )
    ),
    Scenario_Dependency_List
  ),
  !,
  Scenario_Dependency_List \= [ ]
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ensure_no_dependencies_are_true( [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ensure_no_dependencies_are_true( [ Scenario_Dependency | Remaining_Items ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  not( sys_call( Scenario_Dependency ) ),

  ensure_no_dependencies_are_true( Remaining_Items )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% GET DATA VALUE
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- multifile get_data_value/2.
:- multifile get_data_value/3.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value, _ ):- get_data_value( Data, Value ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `To Address`, To ):- i_mail( to, To ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `From Address`, From ):- i_mail( from, From ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Email Subject`, Subject ):- i_mail( from, Subject ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Process`, Value ):- qq_op_param( process, Value ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Total Net Amount`, Value ):- result( _, invoice, total_net, Value ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Total Gross Amount`, Value ):- result( _, invoice, total_invoice, Value ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Received Date Time`, Time ):- i_mail( received_date, Date ), q_sys_sub_string( Date, 12, 5, Time ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Received Date Day`, Day ):- i_mail( received_date, Date ),	q_sys_sub_string( Date, 4, 2, Day ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Received Date Month`, Month ):- i_mail( received_date, Date ),	q_sys_sub_string( Date, 1, 2, Month_no ), month_lookup( Month_no, Month ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Received Date Year`, Year ):- i_mail( received_date, Date ), q_sys_sub_string( Date, 7, 4, Year ), !.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Sum of Line Net Amounts`, Value )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  sys_findall(
    Net,
    (
      (
        result( _, LID, line_net_amount, Net )
        ;
        data( LID, line_net_amount, Net )
      ),
      (
        not( result( _, LID, line_type, _ ) ),
        not( data( LID, line_type, _ ) )
        ;
        (
          result( _, LID, line_type, _ )
          ;
          data( LID, line_type, _ )
        ),
        qq_op_param( us_invoice, _ )
      )
    ),
    List_of_nets_Raw
  ),

  i_force_list( List_of_nets_Raw, List_of_nets ),

  i_user_check( sum_string_list, List_of_nets, Value )
.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Net Difference`, Value )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  (
    i_correlate_amounts_total_to_use( total_net, Variable )
    -> result( _, invoice, Variable, Total_net )

    ;

    result( _, invoice, total_net, Total_net )

  ),

  get_data_value( `Sum of Line Net Amounts`, Sum_of_nets ),

  sys_calculate_str_subtract( Total_net, Sum_of_nets, Diff ),

  (
    q_sys_comp_str_gt( `0`, Diff ),
    sys_calculate_str_multiply( Diff, `-1`, Value )

    ;

    Diff = Value

  )
.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Sum of Line Gross Amounts`, Value )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  sys_findall(
    Total,
    (
      (
        result( _, LID, line_total_amount, Total )
        ;
        data( LID, line_total_amount, Total )
      ),
      (
        not( result( _, LID, line_type, _ ) ),
        not( data( LID, line_type, _ ) )
        ;
        (
          result( _, LID, line_type, _ )
          ;
          data( LID, line_type, _ )
        ),
        qq_op_param( us_invoice, _ )
      )
    ),
    List_of_totals_Raw
  ),

  i_force_list( List_of_totals_Raw, List_of_totals ),

  i_user_check( sum_string_list, List_of_totals, Value )
.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( `Gross Difference`, Value )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  (
    i_correlate_amounts_total_to_use( total_invoice, Variable )
    -> result( _, invoice, Variable, Total_invoice )

    ;

    result( _, invoice, total_invoice, Total_invoice )

  ),

  get_data_value( `Sum of Line Gross Amounts`, Sum_of_totals_final ),

  sys_calculate_str_subtract( Total_invoice, Sum_of_totals_final, Diff ),

  (
    q_sys_comp_str_gt( `0`, Diff ),
    sys_calculate_str_multiply( Diff, `-1`, Value )

    ;

    Diff = Value

  )
.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- header_level_item( _, Data, _, _, _, _, _, _, Variable_String, _, _, _, _, _, _, _ ), sys_string_atom( Variable_String, Variable ), ( result( _, invoice, Variable, Value ); data( invoice, Variable, Value ) ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- not( q_sys_sub_string( Data, _, _, ` ` ) ), sys_string_atom( Data, Variable ), ( result( _, invoice, Variable, Value ); data( invoice, Variable, Value ) ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- q_sys_sub_string( Data, 1, 3, `UID` ), i_mail( unique_id, ID ), sys_string_number( IDS, ID ), q_sys_sub_string( Data, 4, _, Number_String ), sys_string_number( Number_String, Number ), string_pad_left( IDS, Number, `0`, Value ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- q_sys_sub_string( Data, _, _, ` Missing At Lines` ), string_string_replace( Data, ` Missing At Lines`, ``, Data_Item_Name ), strcat_list( [ `Missing `, Data_Item_Name ], Error_Reference ), i_user_data( error_lines( Error_Reference, Value ) ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- q_sys_sub_string( Data, _, _, ` Invalid At Lines` ), string_string_replace( Data, ` Invalid At Lines`, ``, Data_Item_Name ), strcat_list( [ `Invalid `, Data_Item_Name ], Error_Reference ), i_user_data( error_lines( Error_Reference, Value ) ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( Data, Value ):- q_sys_sub_string( Data, _, _, ` Occurred At Lines` ), string_string_replace( Data, ` Occurred At Lines`, ``, Scenario ), i_user_data( error_lines( Scenario, Value ) ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
get_data_value( I_Mail_Field_Name, Value )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  q_sys_sub_string( I_Mail_Field_Name, 1, _, `I Mail ` ),
  string_string_replace( I_Mail_Field_Name, `I Mail `, ``, I_Mail_Field_Replaced ),
  string_string_replace( I_Mail_Field_Replaced, ` `, `_`, I_Mail_Field_Underscore ),
  string_to_lower( I_Mail_Field_Underscore, I_Mail_Field_String ),
  sys_string_atom( I_Mail_Field_String, I_Mail_Field ),
  i_mail( I_Mail_Field, Value_Raw ),
  (
    q_sys_is_string( Value_Raw )
    ->	Value_Raw = Value
    ;
    q_sys_is_number( Value_Raw )
    -> sys_string_number( Value, Value_Raw )
    ;
    q_sys_is_atom( Value_Raw )
    -> sys_string_atom( Value, Value_Raw )
  )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% GET FILE NAME PREFIX
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_file_name_prefix( FNP )
:-
  i_mail( supplier, Supplier ),
  i_mail( invoice_number, Number ),
  sys_string_number( Number_String, Number ),
  i_mail( attachment, Attachment ),
  string_to_lower( Attachment, Attachment_L ),
  sys_string_split( Attachment_L, `.`, List ),
  sys_reverse( List, [ _ | Remaining_Items_Reversed ] ),
  sys_reverse( Remaining_Items_Reversed, Remaining_Items ),
  sys_stringlist_concat( Remaining_Items, `.`, Attachment_Final ),
  i_mail( time_stamp, Time_Stamp ),
  strcat_list( [ Supplier, ` (inv `, Number_String, `).`, Attachment_Final, `.`, Time_Stamp ], FNP )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% I FORCE LIST
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i_force_list( List_In, List_Out )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  q_sys_is_list( List_In )

  -> List_In = List_Out

  ;

  [ List_In ] = List_Out
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% MISSED DATA ITEMS CONDITION
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
missed_data_items_condition
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  ensure_scenarios_have_not_occurred( [ `Body of Email`, `Statement`, `New Layout`, `Not On Project`, `Image Document`, `PDF Error`, `Unsupported File Extension` ] ),

  sys_findall(
    ( Variable, Method ),
    (
      (
        header_level_item( _, _, _, _, _, _, _, Method, Variable, _, _, _, _, _, _, Scenario_Dependency )
        ;
        line_level_item( _, _, _, _, _, _, _, Method, Variable, _, _, _, _, _, _, Scenario_Dependency )
      ),
      sys_call( Scenario_Dependency ),
      q_sys_member( Method, [ `Rules (Mapped)`, `Both Rules & p_` ] ),
      Variable \= `sender_name`
    ),
    List_of_Variables
  ),

  check_all_data_items_are_missing( List_of_Variables ),

  !
.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_all_data_items_are_missing( [ ] ):- fail.
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
check_all_data_items_are_missing( [ ( Variable, Method ) | Remaining_Items ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  sys_string_atom( Variable, Var ),

  (
    Method == `Rules (Mapped)`,
    i_error_missing_data_item( Var )
    ;
    Method == `Both Rules & p_`,
    (
      i_error_missing_data_item( Var )
      ;
      not( i_error_missing_data_item( Var ) ),
      not( grammar_set( `mapped in rules`, Variable ) )
    )
  ),

  !,

  (
    Remaining_Items = [ ],
    !

    ;

    !,
    check_all_data_items_are_missing( Remaining_Items )

  )
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%///////////////////////////////////////////////////////////////////////
% VALIDATION PASSED CONDITION
%///////////////////////////////////////////////////////////////////////
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
validation_passed_condition
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
  i_user_data( header_level_document_scenarios( Header_Level_Document_Scenarios_List ) ),

  Header_Level_Document_Scenarios_List = [ ],

  !,

  i_user_data( line_level_document_scenarios( Line_Level_Document_Scenarios_List ) ),

  Line_Level_Document_Scenarios_List = [ ],

  !
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOOKUPS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% Month Lookup
%-----------------------------------------------------------------------
:- multifile month_lookup/2.
month_lookup( `01`, `January` ).
month_lookup( `02`, `February` ).
month_lookup( `03`, `March` ).
month_lookup( `04`, `April` ).
month_lookup( `05`, `May` ).
month_lookup( `06`, `June` ).
month_lookup( `07`, `July` ).
month_lookup( `08`, `August` ).
month_lookup( `09`, `September` ).
month_lookup( `10`, `October` ).
month_lookup( `11`, `November` ).
month_lookup( `12`, `December` ).

%-----------------------------------------------------------------------
% NoReply Blacklist
%-----------------------------------------------------------------------
:- multifile noreply_blacklist/1.
noreply_blacklist( [ `reply`, `no` ] ).
noreply_blacklist( `billing` ).
noreply_blacklist( `invoic` ).
noreply_blacklist( `service` ).
noreply_blacklist( `batch` ).
noreply_blacklist( `system` ).
noreply_blacklist( `processed.by.mitie@cloud-trade.com` ).

%-----------------------------------------------------------------------
% NoReply Email Swap
%-----------------------------------------------------------------------
:- multifile no_reply_email_swap/2.
no_reply_email_swap( `supplier.invoiceonly@downergroup.com`, `kofax.ap@downergroup.com` ).
no_reply_email_swap( `mining.invoices@downergroup.com`, `kofax.ap@downergroup.com` ).
no_reply_email_swap( `einvoices@dwonergroup.com`, `kofax.ap@downergroup.com` ).

%-----------------------------------------------------------------------
% Whitelisted Emails
%-----------------------------------------------------------------------
:- multifile whitelisted_emails/1.
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@premiersiteservices.co.uk` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@commercialservices.org.uk` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@churchillservices.com` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@cardiac-services.com` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@arcticservice.co.uk` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@custservices.co.uk` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@swft.nhs.uk` ).
whitelisted_emails( From ):- q_sys_sub_string( From, _, _, `@elfs.myservicedesk.com` ).

whitelisted_emails( `alltypefencing.rcservices@yahoo.co.uk` ).
whitelisted_emails( `billing.cmrs.uk@smcnet-sharedservices.com` ).
whitelisted_emails( `corporatecollectionservices@ealing.gov.uk` ).
whitelisted_emails( `councilinvoice@eurohotelsgroup.co.uk` ).
whitelisted_emails( `customerservices@scichem.com` ).
whitelisted_emails( `ebilling@travisperkins.co.uk` ).
whitelisted_emails( `invoice@crestaworldtravel.co.uk` ).
whitelisted_emails( `rob@specialistdogservices.co.uk` ).
whitelisted_emails( `servicedesk@ngagerecruitment.com` ).
whitelisted_emails( `slinvoicedistribution@ifs.inchcape.co.uk` ).
whitelisted_emails( `uk_b2b_invoice@euro.apple.com` ).
whitelisted_emails( `admin@jcmaintenanceservices.co.uk` ).
whitelisted_emails( `invoices@premierfarnell.com` ).
whitelisted_emails( `councilinvoice@lhg.co.uk` ).
whitelisted_emails( `apinvoices@smartlinkllc.com` ).
whitelisted_emails( `apinvoices2@smartlinkllc.com` ).
whitelisted_emails( `customer.services@crbard.com` ).
whitelisted_emails( `rcs.billing@careuk.com` ).
whitelisted_emails( `bagnallservices@msn.com` ).
whitelisted_emails( `ar-uk-businessinvoicing@amazon.co.uk` ).
whitelisted_emails( `invoices@wealden.gov.uk` ).
whitelisted_emails( `ct.invoiceprocessing@mitie.com` ).
whitelisted_emails( `credit.control@leica-microsystems.com` ).
whitelisted_emails( `ctsinvoices@croydon.gov.uk` ).
whitelisted_emails( `accounts@after5services.co.uk` ).
whitelisted_emails( `learninga-zbilling@learninga-z.com` ).
whitelisted_emails( `invoicing@wbmason.com` ).
whitelisted_emails( `arinvoice@schoolspecialty.com` ).
whitelisted_emails( `ar-fr-businessinvoicing@amazon.fr` ).
whitelisted_emails( `ar-uk-businessinvoicing@amazon.co.uk` ).
whitelisted_emails( `invoices@c2crail.net` ).
whitelisted_emails( `ct.invoiceprocessing@swisspostsolutionsuk.com` ).
whitelisted_emails( `mse.mseapinvoices@nhs.net` ).
whitelisted_emails( `plinvoices@somersetft.nhs.uk` ).
whitelisted_emails( `aegbillings@aegpc.net` ).
whitelisted_emails( `accounting@capitaldesignservices.com` ).
whitelisted_emails( `billing@ebiconsulting.com` ).
whitelisted_emails( `invoices@investedchildcare.com` ).
whitelisted_emails( `amtinvoices@amtcoffee.co.uk` ).
whitelisted_emails( `customerservice@don.com` ).
whitelisted_emails( `invoices@hughjordan.com` ).
whitelisted_emails( `finance.invoices@boltonft.nhs.uk` ).
whitelisted_emails( `invoices@approvedmedwaste.com` ).
whitelisted_emails( `invoiceservice350@lesjoforsab.com` ).
whitelisted_emails( `d365billing@onediversified.com` ).