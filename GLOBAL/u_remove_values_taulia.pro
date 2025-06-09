%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_REMOVE_VALUES_TAULIA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_remove_values_taulia, `04/08/2020 11:56:04` ).

% Called from the Taulia UC rules file so it only runs for UC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REMOVE HEADER VALUES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_invoice_fields_last:- i_analyse_remove_header_values___.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
i_analyse_remove_header_values___
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:-
    
	trace( `Universal Capture invoice : removing header values` ),

    sys_findall(
        Variable,
        result( _, invoice, Variable, _ ),
        List_of_Variables
    ),
    
    remove_header_values( List_of_Variables ),

    !
.
% Calls each captured variable in turn
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
remove_header_values( [ ] ).
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
remove_header_values( [ Variable | Remaining_Variables ] )
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:-
    sys_string_atom( Variable_String, Variable ),

	(
        % Branch 1: Removes any variable with a blank "Mapping Logic"
        % Puts the captured variable name in the form shown on the SDD/d_
		(
            Variable_String = Variable_String_Test
            ;
            % Changes date in .pro to invoice_date
            strcat_list( [ `invoice_`, Variable_String ], Variable_String_Test )
            ;
            % removes processed_ from processed_ship_date-type
            string_string_replace( Variable_String, `processed_`, ``, Variable_String_Test )
        ),
        
        % Checks for a blank "Mapping Logic" field

        required_data_item( _,  Mapping_Logic, `Never`, _, _, _, _, _, _, Variable_String_Test, Scenario_Dependency ),

        q_sys_member( Mapping_Logic, [ ``] ),

        sys_retractall( result( _, invoice, Variable, _ ) ),

        strcat_list( [ `invoice : removed `, Variable_String ], Trace ),

        trace( Trace )

		;
        % Branch 2: leaves any other variables

        Variable_String = Variable_String_Test
		

	),

    remove_header_values( Remaining_Variables ),

	!
.