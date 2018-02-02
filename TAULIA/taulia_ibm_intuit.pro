%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - TAULIA_IBM_INTUIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( taulia_ibm_intuit, `07/12/2017 10:01:57` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_page_split_rule_list( [ set(chain,`unrecognised_document`), select_buyer ] ) :- instance(I), q_sys_sub_string(I, _, _, `PRD`).
i_page_split_rule_list( [ set(chain,`generic_taulia`), select_buyer ] ) :- instance(I), not( q_sys_sub_string(I, _, _, `PRD`) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT BUYER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( select_buyer, [
%=======================================================================

	or( [
	
		[ q0n(line), buyer_id_line ]
	
		, [ q0n(line), quickbooks_id_line ]
	
	] )

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUYER ID LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule( buyer_id_line, [
%=======================================================================

	or( [

		[ check_text( `DataItemName(exactlyasitappearsonSDD)` ), set( chain, `generic test template` ), trace( [ `GENERIC TEST TEMPLATE` ] ) ]
		
		, [ check_text( `INTUIT01` ), set( chain, `intuit_cesg_critical_electric` ), trace( [ `THIS IS Critical Electric Systems Group, LLC DOCUMENT` ] ) ]

		, [ check_text( `1905878` ), set( chain, `intuit_commission_junction` ), trace( [ `THIS IS Affiliate by Conversant/ Commission Junction, LLC DOCUMENT` ] ) , set( re_extract ) ]
		
		, [ check_text( `36-4530079` ), set( chain, `intuit_cdw_direct` ), trace( [ `THIS IS CDW Direct, LLC DOCUMENT` ] ) , set( re_extract ) ]
		
        , [ check_text( `36-2137456` ), set( chain, `intuit_baker_mckenzie` ), trace( [ `This is a Baker & McKenzie LLP Document` ] ) ]

		, [ check_text( `378-4150` ), set( chain, `intuit_ic_compliance` ), trace( [ `This is a IC Compliance LLC dba ICon Professional Services Document` ] ) ]

		, [ check_text( `46-1140696` ), set( chain, `intuit_manpower` ), trace( [ `This is a Manpower Group US Inc Document` ] ) ]

	    , [ check_text( `94-2805249` ), set( chain, `intuit_oracle_america` ), trace( [ `This is a Oracle America, Inc Document` ] ) ]

   	    , [ check_text( `818-407-1911` ), set( chain, `intuit_pcc_network` ), trace( [ `This is a PCC Network Solutions Document` ] ) ]

	    , [ check_text( `77-0493581` ), set( chain, `intuit_google` ), trace( [ `This is a Google Inc Document` ] ) ]

		, [ check_text( `730759` ), set( chain, `intuit_rackspace_us` ), trace( [ `This is a Rackspace US, Inc Document` ] ) ]

		, [ check_text( `~503-740-0032` ), set( chain, `intuit_artsmentor` ), trace( [ `This is a Artsmentor, LLC, Inc Document` ] ) ]

		, [ check_text( `00000711734` ), set( chain, `intuit_unitedhealth_group` ), trace( [ `This is a United health Group, LLC, Inc Document` ] ) ]

		, [ check_text( `4801902834` ), set( chain, `intuit_taulia_camelot` ), trace( [ `This is a Camelot Communications Document` ] ) , set( re_extract ) ]

		 , [ check_text( `23-2588479` ), set( chain, `intuit_taulia_iron_mountain` ), trace( [ `This is a Iron mountain Document` ] ) , set( re_extract ) ]
 
        , [ check_text( `4945325025` ), set( chain, `intuit_taulia_access_emanate` ), trace( [ `This is a Access Emanate Communications Document` ] ) ]

		, [ check_text( `77-0562390` ), set( chain, `intuit_taulia_access_telecomm` ), trace( [ `This is a Access Telecomm Systems, Inc Document` ] ) ]

		, [ check_text( `77-0019522` ), set( chain, `intuit_taulia_adobe_systems` ), trace( [ `This is a Adobe Systems Incorporated Document` ] ) ]

        , [ check_text( `04-3432319` ), set( chain, `intuit_taulia_akamai` ), trace( [ `This is a AKAMAI TECHNOLOGIES, INC. Document` ] ) ]

	    , [ check_text( `703-7666` ), set( chain, `intuit_taulia_allied_universal` ), trace( [ `This is a Allied Universal Document` ] ) ]

		, [ check_text( `1852748811` ), set( chain, `intuit_taulia_altimetrik` ), trace( [ `This is a Altimetrik Corporation Document` ] ) ]

	    , [ check_text( `4072028` ), set( chain, `intuit_taulia_analytics8` ), trace( [ `This is a Analytics8 Document` ] ) ]

	    , [ check_text( `83-0472793` ), set( chain, `intuit_taulia_cloudpay` ), trace( [ `This is a CloudPay Solutions Inc Document` ] ) ]

	    , [ check_text( `13-3924155` ), set( chain, `intuit_taulia_cognizant` ), trace( [ `This is a Cognizant Technology Solutions Document` ] ) ]

        , [ check_text( `855-665-6380` ), set( chain, `intuit_taulia_concentrix` ), trace( [ `This is a Concentrix Corporation Document` ] ) ]

	   % , [ check_text( `221.4100` ), set( chain, `intuit_taulia_cpawebengage` ), trace( [ `This is a CPAwebengage, Inc Document` ] ) ]

	   , [ check_text( `881-2400` ), set( chain, `intuit_taulia_dei_rossie` ), trace( [ `This is a Dei Rossi Marketing Document` ] ) ]

	   , [ check_text( `816-778-7300` ), set( chain, `intuit_taulia_evolytics` ), trace( [ `This is a EVOLYTICS LLC Document` ] ) ]

       , [ check_text( `655-1643` ), set( chain, `intuit_taulia_emmarketing` ), trace( [ `This is a EM Marketing Document` ] ) ]

	   , [ check_text( `14997-25400` ), set( chain, `intuit_taulia_facebook` ), trace( [ `This is a Facebook Inc Document` ] ) ]

	   , [ check_text( `1499725400` ), set( chain, `intuit_taulia_facebook` ), trace( [ `This is a Facebook Inc Document` ] ) ]

	   , [ check_text( `0041823212` ), set( chain, `intuit_taulia_gerould` ), trace( [ `This is a Gerould & Player, LLP Document` ] ) ]

	   , [ check_text( `644-0450` ), set( chain, `intuit_taulia_giact` ), trace( [ `This is a GIACT Systems Document` ] ) ]

	   , [ check_text( `480-240-5240` ), set( chain, `intuit_taulia_intraedge` ), trace( [ `This is a IntraEdge, Inc Document` ] ) ]

	   , [ check_text( `550-5251` ), set( chain, `intuit_taulia_benz_com` ), trace( [ `This is a BENZ COMMUNICATIONS Document` ] ) ]

	   , [ check_text( `223-8300` ), set( chain, `intuit_taulia_high_tech` ), trace( [ `This is a High Tech Connect, LLC Document` ] ) ]

	   , [ check_text( `023950840` ), set( chain, `intuit_taulia_silverback` ), trace( [ `This is a Silverback Data Center Solutions, Inc Document` ] ) ]

	   , [ check_text( `432-7220` ), set( chain, `intuit_taulia_softclouds` ), trace( [ `This is a SoftClouds LLC Document` ] ) ]

	   , [ check_text( `468-3995` ), set( chain, `intuit_taulia_jeff_herman` ), trace( [ `This is a Jeff Herman Consulting, LLC Document` ] ) ]

	   , [ check_text( `282-5296` ), set( chain, `intuit_taulia_tangible` ), trace( [ `This is a Tangible UX, LLC Document` ] ) ]

	   , [ check_text( `13-5565207` ), set( chain, `intuit_taulia_kpmg` ), trace( [ `This is a KPMG LLP Document` ] ) ]




	] )
	
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUICKBOOKS ID LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_line_rule( quickbooks_id_line, [
%=======================================================================

	q0n(anything)

	, or( [

		[ `Please`, `detach`,  `top`,  `portion`, set(chain, `quickbooks`), trace([`QUICKBOOKS ...`]) ]

		, [ `date`, tab, `invoice`, `no`, `.`, newline, set(chain, `quickbooks`), trace([`QUICKBOOKS ...`])  ]

		, [ `date`, tab, `invoice`, `#`,  newline, set(chain, `quickbooks`), trace([`QUICKBOOKS ...`])  ]


	] )
	
] ).