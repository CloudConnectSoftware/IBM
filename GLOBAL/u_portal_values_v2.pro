%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_PORTAL_VALUES_V2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_portal_values_v2, `07/03/2023 08:17:42` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DOCUMENT TYPE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_final_rule( [
%=======================================================================

    or( [
	
		[ test( credit_note ), document_type( `Credit Note` ) ]

		, [ test( purchase_order ), document_type( `Order` ) ]
		
		, document_type( `Invoice` )
		
	] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT SENDING ORGANISATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_sending_organisation___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_sending_organisation___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-

	(
		result( _, invoice, sender_name, Sender )
  
		;
		
		qq_op_param( sending_organisation, Sender )

		;

		Sender = `Unrecognised`
  
	)

	->	sys_retractall( result( _, invoice, sending_organisation, _ ) ),
		assertz_derived_data( invoice, sending_organisation, Sender, i_analyse_sending_organisation ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT RECEIVING ORGANISATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_receiving_organisation___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_receiving_organisation___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, invoice, receiving_organisation, _ ) ),

	(
		i_mail( from, From ),
		sys_asserta( from( From ) ),
		i_mail( to, To ),
		sys_asserta( to( To ) ),
		i_mail( subject, Subject ),
		sys_asserta( subject( Subject ) ),
		service_overview( `Receiving Organisation`, Receiving_Organisation_Raw, Scenario_Dependency ),
		sys_call( Scenario_Dependency ),
		create_string_from_template( Receiving_Organisation_Raw, Receiver ),
		Receiver \= ``

		;

		qq_op_param( receiving_organisation, Receiver )

		;

		Receiver = `Unrecognised`

	),
 
	assertz_derived_data( invoice, receiving_organisation, Receiver, i_analyse_receiving_organisation ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT CUSTOMER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_customer___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_customer___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, invoice, customer, _ ) ),

	(
		i_mail( from, From ),
		sys_asserta( from( From ) ),
		i_mail( to, To ),
		sys_asserta( to( To ) ),
		i_mail( subject, Subject ),
		sys_asserta( subject( Subject ) ),
		service_overview( `Customer`, Customer_Raw, Scenario_Dependency ),
		sys_call( Scenario_Dependency ),
		create_string_from_template( Customer_Raw, Customer ),
		Customer \= ``

		;

		qq_op_param( customer, Customer )

		;

		Customer = `Unrecognised`

	),
 
	assertz_derived_data( invoice, customer, Customer, i_analyse_customer ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT CHANNEL PARTNER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_fields_last:- i_analyse_channel_partner___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_channel_partner___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( result( _, invoice, channel_partner, _ ) ),

	(
		qq_op_param( channel_partner, Channel_Partner )

		;

		Channel_Partner = `Unrecognised`

	),
 
	assertz_derived_data( invoice, channel_partner, Channel_Partner, i_analyse_channel_partner ),
	
	!
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSERT STANDARD REPORTING VARIABLES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_enquire_last:- i_analyse_standard_reporting_variables____.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_standard_reporting_variables____
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
	not( dbg_instance ),
	(	grammar_set( ignore_enquire )
		;	result( _, _, force_result, `success` )
		;	not( grammar_set( customer_intervention_required ) ),
			not( grammar_set( rules_intervention_required ) )
	),

	get_file_name_prefix( FNP ),

	i_mail( received_date, Received_Date ),
	declare_custom_value( FNP, `Received Date`, Received_Date ),

    (	q_enquire_form( `customer_intervention_form`, _ )
        ->	Intervention = `Client`
        ;	q_enquire_form( `rules_intervention_form`, _ )
            ->	Intervention = `CT`
        ;	Intervention = `None`
    ),
	declare_custom_value( FNP, `Intervention`, Intervention ),

	(	chained_to( Chain ),
        q_sys_sub_string( Chain, _, _, `_ocr` )
		-> Image = `Yes`
		;	Image = `No`
	),
	declare_custom_value( FNP, `Image`, Image ),

	(	q_imail_data( self, `delayed_document`, `true` )
		->	Delayed = `Yes`
		;	Delayed = `No`
	),
	declare_custom_value( FNP, `Delayed`, Delayed ),

	!
.
