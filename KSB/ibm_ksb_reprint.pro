%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM_KSB_REPRINT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ibm_ksb_reprint, `28/02/2018 14:38:53` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_op_param( extract_script_file_name, _, _, _, _, `utils.ps1` ).
i_op_param( extract_script_function_name, _, _, _, _, `bullzip` ).

i_page_split_rule_list( [ set( chain, `unrecognised_document` ), select_rules ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( select_rules, [
%=======================================================================

	or( [
	
		[ q0n(line), check_text_id_line ]
				
	] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK TEXT ID LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule( check_text_id_line, [ or( [
%=======================================================================

	[ check_text( `DE230276848` ), set( chain, `ksb_eagle_burgmann_germany` ), trace( [ `This is EagleBurgmann Germany document` ] ) ]

	, [ check_text( `FR91310540547` ), set( chain, `ksb_eagle_burgmann_france` ), trace( [ `This is EagleBurgmann France document` ] ) ]

	, [ check_text( `BittebeiZahlungangebe` ), set( chain, `ksb_general_logistics` ), trace( [ `This is a GLS document` ] ) ]

	, [ check_text( `FR92428704654` ), set( chain, `ksb_fonderie_ghm` ), trace( [ `This is a FONDERIE G.H.M. document` ] ) ]

	, [ check_text( `42870465400014` ), set( chain, `ksb_fonderie_ghm` ), trace( [ `This is a FONDERIE G.H.M. document` ] ) ]

	, [ check_text( `33(0)325567373` ), set( chain, `ksb_fonderie_ghm` ), trace( [ `This is a FONDERIE G.H.M. document` ] ) ]

	% , [ check_text( `` ), set( chain, `` ), trace( [ `` ] ) ]
	
] ) ] ).
