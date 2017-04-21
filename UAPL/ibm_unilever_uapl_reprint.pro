%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM_UNILEVER_UAPL_REPRINT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ibm_unilever_uapl_reprint, `12:30 03 October 2016` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_op_param( extract_script_file_name, _, _, _, _, `utils.ps1` ).
i_op_param( extract_script_function_name, _, _, _, _, `bullzip` ).

i_page_split_rule_list( [ select_buyer ] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT BUYER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( select_buyer, [
%=======================================================================

	or( [

		[ q0n(line), check_text_id_line ]

		, [ q0n(line) , msc_identify_rule ]

	])
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK TEXT ID LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule( check_text_id_line, [
%=======================================================================
	
	or( [

		  [ check_text( `000760807424` ), set( chain, `ul_uapl_tepak_marketing` ), trace( [ `THIS IS A TEPAK MARKETING SDN BHD DOCUMENT` ] ) ]

		  ,  [ check_text( `204952` ), set( chain, `ul_uapl_tepak_marketing` ), trace( [ `THIS IS A TEPAK MARKETING SDN BHD DOCUMENT` ] ) ]

		 , [ check_text( `0-820162-013` ), set( chain, `ul_uapl_mediterranean` ), trace( [ `THIS IS A MEDITERRANEAN REPRINT DOCUMENT` ] ) ]

		 , [ check_text( `66-355-993` ), set( chain, `ul_uapl_mediterranean_nz` ), trace( [ `THIS IS A MEDITERRANEAN NZ DOCUMENT` ] ) ]

		 , [ check_text( `PTPANURJWAN` ), set( chain, `ul_uapl_pt_perusahaan` ), trace( [ `THIS IS A  PT.Perusahaan Pelayaran Nusantara Panurjwan DOCUMENT` ] ) ]

		 , [ check_text( `2051536` ), set( chain, `ul_uapl_kantar_japan` ), trace( [ `THIS IS A KANTAR JAPAN INC DOCUMENT` ] ) ]

		 ,  [ check_text( `M2-0078869-9` ), set( chain, `ul_uapl_rcl_feeder` ), trace( [ `THIS IS A RCL FEEDER PTE DOCUMENT` ] ) ]

		 , [ check_text( `001264435200` ), set( chain, `ul_uapl_apex_packaging` ), trace( [ `This is  APEX PACKAGING DOCUMENT` ] ) ]

		 , [ check_text( `0-820162-017` ), set( chain, `ul_uapl_mediterranean` ), trace( [ `THIS IS A MEDITERRANEAN DOCUMENT` ] ) ]

		 , [ check_text( `0-862595-009` ), set( chain, `ul_uapl_mediterranean` ), trace( [ `THIS IS A MEDITERRANEAN DOCUMENT` ] ) ]

		 , [ check_text( `00481C` ), set( chain, `ul_uapl_damco_australia` ), trace( [ `THIS IS A DAMCO AUSTRALIA PTY LTD DOCUMENT` ] ) ]

		 

		% [ check_text( `` ), set( chain, `` ), trace( [ `` ] ) ]
		
	] )

] ).



%=======================================================================
i_rule( msc_identify_rule, [
%=======================================================================

	check_line_msc1

	, check_line_msc2

	, check_line_msc3

	, check_line_msc4

	, check_line_msc5

	, set(chain,`ul_uapl_mediterranean`)

	, trace( [ `THIS IS A MEDITERRANEAN DOCUMENT` ] )

] ).

%=======================================================================
i_line_rule( check_line_msc1, [
%=======================================================================

	`Frd`, `Vsl`, `.`, `/`, `Mother`, `Vsl`

]).
%=======================================================================
i_line_rule( check_line_msc2, [
%=======================================================================

	`POD`, `/`, `FDEST`

] ).
%=======================================================================
i_line_rule( check_line_msc3, [
%=======================================================================

	`POL`

] ).

%=======================================================================
i_line_rule( check_line_msc4, [
%=======================================================================

	`B`, `/`, `L`, `No`, `.`

] ).

%=======================================================================
i_line_rule( check_line_msc5, [
%=======================================================================

	`Booking`, `No`

] ).
