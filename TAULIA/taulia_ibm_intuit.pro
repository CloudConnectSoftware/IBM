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
		
	,  [ q0n(line), abvoinc_chain_rule ]

	,  [ q0n(line), cbi_chain_rule ]
	
	,  [ q0n(line), cpawedengage_chain_rule ]

    ,  [ q0n(line), etouch_chain_rule ]

	,  [ q0n(line), interactions_chain_rule ]

	,  [ q0n(line), stock_chain_rule ]

    ,  [ q0n(line), brandglue_chain_rule ]

	,  [ q0n(line), bookkeepers_chain_rule ]

	,  [ q0n(line), pierpoint_chain_rule ]

	,  [ q0n(line), gerould_chain_rule ]

	,  [ q0n(line), roaminghunger_chain_rule ]

	,  [ q0n(line), secure_one_identify_rule ]

	,  [ q0n(line), woodruff_sawyer_identify_rule ]

	,  [ q0n(line), realworld_identify_rule ]	

	,  [ q0n(line), cisco_identify_rule ]	

	,  [ q0n(line), twilio_identify_rule ]

	,  [ q0n(line), advantage_identify_rule ]

	,  [ q0n(line), sodexo_identify_rule ]

	,  [ q0n(line), sodexo_identify_rule1 ]

	,  [ q0n(line), realworld_identify_rule1 ]

    ,  [ q0n(line), switch_identify_rule ]

    ,  [ q0n(line), wieden_identify_rule ]

	



	 % , [ q0n(line), quickbooks_id_line ]
		
	

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

		, [ check_text( `4121196406` ), set( chain, `intuit_commission_junction` ), trace( [ `THIS IS Affiliate by Conversant/ Commission Junction, LLC DOCUMENT` ] ) , set( re_extract ) ]
		
		, [ check_text( `36-4530079` ), set( chain, `intuit_cdw_direct` ), trace( [ `THIS IS CDW Direct, LLC DOCUMENT` ] ) , set( re_extract ) ]
		
        , [ check_text( `36-2137456` ), set( chain, `intuit_baker_mckenzie` ), trace( [ `This is a Baker & McKenzie LLP Document` ] ) ]

		, [ check_text( `378-4150` ), set( chain, `intuit_ic_compliance` ), trace( [ `This is a IC Compliance LLC dba ICon Professional Services Document` ] ) ]

		, [ check_text( `46-1140696` ), set( chain, `intuit_manpower` ), trace( [ `This is a Manpower Group US Inc Document` ] ) ]

	    , [ check_text( `94-2805249` ), set( chain, `intuit_oracle_america` ), trace( [ `This is a Oracle America, Inc Document` ] ) ]

   	    , [ check_text( `818-407-1911` ), set( chain, `intuit_pcc_network` ), trace( [ `This is a PCC Network Solutions Document` ] ) ]

	    , [ check_text( `77-0493581` ), set( chain, `intuit_google` ), trace( [ `This is a Google Inc Document` ] ) ]

		, [ check_text( `730759` ), set( chain, `intuit_rackspace_us` ), trace( [ `This is a Rackspace US, Inc Document` ] ) ]

		, [ check_text( `74-3219359` ), set( chain, `intuit_rackspace_us` ), trace( [ `This is a Rackspace US, Inc Document` ] ) ]

		, [ check_text( `~503-740-0032` ), set( chain, `intuit_artsmentor` ), trace( [ `This is a Artsmentor, LLC, Inc Document` ] ) ]

		, [ check_text( `00000711734` ), set( chain, `intuit_unitedhealth_group` ), trace( [ `This is a United health Group, LLC, Inc Document` ] ) ]

		, [ check_text( `4801902834` ), set( chain, `intuit_taulia_camelot` ), trace( [ `This is a Camelot Communications Document` ] ) , set( re_extract ) ]

		 , [ check_text( `23-2588479` ), set( chain, `intuit_taulia_iron_mountain` ), trace( [ `This is a Iron mountain Document` ] ) , set( re_extract ) ]

		 , [ check_text( `1-800-934-3453` ), set( chain, `intuit_taulia_iron_mountain` ), trace( [ `This is a Iron mountain Document` ] ) , set( re_extract ) ]
 
        , [ check_text( `415-904-7070` ), set( chain, `intuit_taulia_access_emanate` ), trace( [ `This is a Access Emanate Communications Document` ] ) ]

	    , [ check_text( `4945325025` ), set( chain, `intuit_taulia_access_emanate` ), trace( [ `This is a Access Emanate Communications Document` ] ) ]

		, [ check_text( `77-0562390` ), set( chain, `intuit_taulia_access_telecomm` ), trace( [ `This is a Access Telecomm Systems, Inc Document` ] ) ]

		, [ check_text( `77-0019522` ), set( chain, `intuit_taulia_adobe_systems` ), trace( [ `This is a Adobe Systems Incorporated Document` ] ) ]

        , [ check_text( `04-3432319` ), set( chain, `intuit_taulia_akamai` ), trace( [ `This is a AKAMAI TECHNOLOGIES, INC. Document` ] ) ]

	    , [ check_text( `703-7666` ), set( chain, `intuit_taulia_allied_universal` ), trace( [ `This is a Allied Universal Document` ] ) ]

		, [ check_text( `1852748811` ), set( chain, `intuit_taulia_altimetrik` ), trace( [ `This is a Altimetrik Corporation Document` ] ) ]

	    , [ check_text( `20-3185454` ), set( chain, `intuit_taulia_analytics8` ), trace( [ `This is a Analytics8 Document` ] ) ]

		, [ check_text( `4072028` ), set( chain, `intuit_taulia_analytics8` ), trace( [ `This is a Analytics8 Document` ] ) ]

	    , [ check_text( `83-0472793` ), set( chain, `intuit_taulia_cloudpay` ), trace( [ `This is a CloudPay Solutions Inc Document` ] ) ]

	    , [ check_text( `13-3924155` ), set( chain, `intuit_taulia_cognizant` ), trace( [ `This is a Cognizant Technology Solutions Document` ] ) ]

        , [ check_text( `855-665-6380` ), set( chain, `intuit_taulia_concentrix` ), trace( [ `This is a Concentrix Corporation Document` ] ) ]

	   , [ check_text( `1-800-747-0583` ), set( chain, `intuit_taulia_concentrix` ), trace( [ `This is a Concentrix Corporation Document` ] ) ]

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

	   , [ check_text( `996-2132` ), set( chain, `intuit_taulia_tangible` ), trace( [ `This is a Tangible UX, LLC Document` ] ) ]

	   , [ check_text( `13-5565207` ), set( chain, `intuit_taulia_kpmg` ), trace( [ `This is a KPMG LLP Document` ] ) ]

	   , [ check_text( `133891517` ), set( chain, `intuit_taulia_deloittetouche` ), trace( [ `This is a Deloitte & Touche LLP Document` ] ) ]

	   , [ check_text( `861065772` ), set( chain, `intuit_taulia_deloittetax` ), trace( [ `This is a Deloitte Tax LLP Document` ] ) ]

	   , [ check_text( `41-1815880` ), set( chain, `intuit_taulia_lexis` ), trace( [ `This is a LexisNexis Risk Solutions Document` ] ) ]

	   , [ check_text( `8005178268` ), set( chain, `intuit_taulia_matchpoint` ), trace( [ `This is a MatchPoint Solutions Document` ] ) ]

	   , [ check_text( `1-800-564-2688` ), set( chain, `intuit_taulia_real_world` ), trace( [ `This is a Real World Training Document` ] ) ]

	   , [ check_text( `140019613` ), set( chain, `intuit_taulia_clarity` ), trace( [ `This is a Clarity Consultants  Document` ] ) ]

	   , [ check_text( `4044756550` ), set( chain, `intuit_taulia_sally` ), trace( [ `This is a  Sally Williamson & Associates, Inc  Document` ] ) ]

       , [ check_text( `0052021029` ), set( chain, `intuit_taulia_switch` ), trace( [ `This is a  Switch, Ltd  Document` ] ) ]

	   , [ check_text( `30579543` ), set( chain, `intuit_taulia_yahoo` ), trace( [ `This is a Yahoo, Inc  Document` ] ) ]

	   , [ check_text( `77-0398689` ), set( chain, `intuit_taulia_yahoo` ), trace( [ `This is a Yahoo, Inc  Document` ] ) ]

	   , [ check_text( `2873602` ), set( chain, `intuit_taulia_hewitt` ), trace( [ `This is a Hewitt Associates LLC  Document` ] ) ]

	   , [ check_text( `35-2428242` ), set( chain, `intuit_taulia_interactive` ), trace( [ `This is a Interactive Intelligence  Document` ] ) ]

	   , [ check_text( `45-1505676` ), set( chain, `intuit_taulia_interactive` ), trace( [ `This is a Interactive Intelligence  Document` ] ) ]

       , [ check_text( `0101092443` ), set( chain, `intuit_taulia_matters` ), trace( [ `This is a xMatters  Document` ] ) ]

	   , [ check_text( `84-1302031` ), set( chain, `intuit_taulia_payreel` ), trace( [ `This is a PayReel Document` ] ) ]

	   , [ check_text( `52-2121493` ), set( chain, `intuit_taulia_aol` ), trace( [ `This is a AOL Advertising Inc Document` ] ) ]

	   , [ check_text( `20-5056422` ), set( chain, `intuit_taulia_phenomenon` ), trace( [ `This is a Phenomenon Marketing & Entertainment, Inc Document` ] ) ]

	  , [ check_text( `435-773-1500` ), set( chain, `intuit_taulia_mager` ), trace( [ `This is a Mager Consortium, LLC Document` ] ) ]

	  , [ check_text( `267115458` ), set( chain, `intuit_taulia_theoutcast` ), trace( [ `This is a The OutCast Agency LLC Document` ] ) ]

	  , [ check_text( `1233009797` ), set( chain, `intuit_taulia_cvs_caremark` ), trace( [ `This is a CVS/Caremark Document` ] ) ]
	  
	  , [ check_text( `17963` ), set( chain, `intuit_worldwide_technology` ), trace( [ `This is a World Wide Technology Document` ] ) ]

	  , [ check_text( `935114660` ), set( chain, `intuit_taulia_tangtoe` ), trace( [ `This is a Tangoe, Inc  Document` ] ) ]

	  , [ check_text( `24-419665` ), set( chain, `intuit_taulia_weiden` ), trace( [ `This is a Wieden + Kennedy  Document` ] ) ]

	  , [ check_text( `12330-24344` ), set( chain, `intuit_taulia_resources` ), trace( [ `This is a RESOURCES GLOBAL PROFESSIONALS  Document` ] ) ]

	  , [ check_text( `1204420` ), set( chain, `intuit_xerox_tech` ), trace( [ `This is a Xerox Technology  Document` ] ) ]

	  , [ check_text( `3751736507` ), set( chain, `intuit_taulia_bingads` ), trace( [ `This is a Microsoft Online, Inc  Document` ] ) ]

	  , [ check_text( `134008324` ), set( chain, `intuit_taulia_pwc` ), trace( [ `This is a PricewaterhouseCoopers LLP  Document` ] ) ]

	  , [ check_text( `47-4641274` ), set( chain, `intuit_taulia_pwc_advisory` ), trace( [ `This is a PricewaterhouseCoopers Advisory Services LLC  Document` ] ) ]
	  
      , [ check_text( `26-3660836` ), set( chain, `intuit_taulia_syniverse` ), trace( [ `This is a Syniverse ICX Corporation  Document` ] ) ]

	  , [ check_text( `13-2554344` ), set( chain, `intuit_taulia_dimensiondata` ), trace( [ `This is a DIMENSION DATA NORTH AMERICA, INC  Document` ] ) ]

      , [ check_text( `74-2616805` ), set( chain, `intuit_taulia_dell` ), trace( [ `This is a DELL MARKETING L.P. Document` ] ) ]

	  , [ check_text( `858-414-5685` ), set( chain, `intuit_taulia_intuittreeline` ), trace( [ `This is a Treeline Inc Document` ] ) ]

	  , [ check_text( `81-4578737` ), set( chain, `intuit_taulia_experian` ), trace( [ `This is a Experian Marketing Solutions, LLC Document` ] ) ]

	  , [ check_text( `3751205782` ), set( chain, `intuit_taulia_microsoft` ), trace( [ `This is a Microsoft Corporation Document` ] ) ]

	  , [ check_text( `3750825354` ), set( chain, `intuit_taulia_microsoft` ), trace( [ `This is a Microsoft Corporation Document` ] ) ]

	  , [ check_text( `800-316-6440` ), set( chain, `intuit_taulia_eatclub` ), trace( [ `This is a EAT Club Inc Document` ] ) ]

	  , [ check_text( `866-815-6623` ), set( chain, `intuit_taulia_eatclub` ), trace( [ `This is a EAT Club Inc Document` ] ) ]

	  , [ check_text( `13-5565207` ), set( chain, `intuit_taulia_kpmg` ), trace( [ `This is a KPMG LLP Document` ] ) ]

	  , [ check_text( `8666309944` ), set( chain, `intuit_taulia_teletech` ), trace( [ `This is a TeleTech Services Corporation Document` ] ) ]

	  , [ check_text( `408-686-4489` ), set( chain, `intuit_taulia_armor` ), trace( [ `This is a ArmorBlue, Inc Document` ] ) ]

	  , [ check_text( `95-4465932` ), set( chain, `intuit_taulia_consumerinfo` ), trace( [ `This is a ConsumerInfo Document` ] ) ]

	  , [ check_text( `483043581006` ), set( chain, `intuit_taulia_bpn` ), trace( [ `This is a BPN WW INC Document` ] ) ]

	  , [ check_text( `602-415-1111` ), set( chain, `intuit_taulia_secure_one` ), trace( [ `This is aSecure one Outsource Soulutions Document` ] ) ]


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  abvoinc_chain_rule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  abvoinc_chain_rule, [
%=======================================================================

      abvoinc_rule

     , abvoinc_rule1

	 , abvoinc_rule2

	 , abvoinc_rule3

    , set(chain,`intuit_taulia_ab_ovo`)

    , trace( [ `This is a Ab Ovo Inc Document` ] )

] ).

%=======================================================================
i_line_rule( abvoinc_rule, [
%=======================================================================

   [`Ab`, `Ovo`, `Inc`,  newline ]

] ).

%=======================================================================
i_line_rule( abvoinc_rule1, [
%=======================================================================

   [`Invoice`,  newline ]

] ).


%=======================================================================
i_line_rule( abvoinc_rule2, [
%=======================================================================

   [`2320`, `-`, `G`, `,`, `Walsh`, `Ave`,  newline ]

] ).

%=======================================================================
i_line_rule( abvoinc_rule3, [
%=======================================================================

   [`Santa`, `Clara`, `,`, `CA`, `95051`,  newline ]

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Connectivity Based Integration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  cbi_chain_rule, [
%=======================================================================

      cbic_rule

     , cbic_rule1

	 , cbic_rule2

	 , cbic_rule3

	  , cbic_rule4

    , set(chain,`intuit_taulia_cbi`)

    , trace( [ `This is a Connectivity Based Integration Document` ] )

] ).

%=======================================================================
i_line_rule( cbic_rule, [
%=======================================================================
   [`Invoice`,  newline ]
] ).
%=======================================================================
i_line_rule( cbic_rule1, [
%=======================================================================
   [`Date`, tab, `Invoice`, `#`,  newline ]
] ).
%=======================================================================
i_line_rule( cbic_rule2, [
%=======================================================================
   [`Connectivity`, `Based`, `Integration`,  newline ]
] ).
%=======================================================================
i_line_rule( cbic_rule3, [
%======================================================================
   [dummy_num(date), tab, dummy_num(d),  newline ]
] ).
%=======================================================================
i_line_rule( cbic_rule4, [
%=======================================================================
   [`accounting`, `@`, `cbi`, `-`, `inc`, `.`, `net`,  newline ]
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BrandGlue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  brandglue_chain_rule, [
%=======================================================================

      brandglue_rule

     , brandglue_rule1

	 , brandglue_rule2

	 , brandglue_rule3

    , set(chain,`intuit_taulia_brandglue`)

    , trace( [ `This is a  BrandGlue Document` ] )

] ).
%=======================================================================
i_line_rule( brandglue_rule, [
%=======================================================================
   [`BrandGlue`,  newline ]
] ).
%=======================================================================
i_line_rule( brandglue_rule1, [
%=======================================================================
   [`P`, `.`, `O`, `.`, `Box`, `5531`,  newline ]
] ).
%=======================================================================
i_line_rule( brandglue_rule2, [
%=======================================================================
   [`Bellingham`, `WA`, `98227`,  newline ]
] ).
%=======================================================================
i_line_rule( brandglue_rule3, [
%=======================================================================
   [`Intuit`, `Accountants`, tab, `Invoice`, `#`, tab, dummy_num(d),  newline ]
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CPAwebengage, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  cpawedengage_chain_rule, [
%=======================================================================

     cpawedengage_rule

     , cpawedengage_rule1

	 , cpawedengage_rule2

	 , cpawedengage_rule3

	 , cpawedengage_rule4

    , set(chain,`intuit_taulia_cpawebengage`)

    , trace( [ `This is a  CPAwebengage, Inc. Document` ] )

] ).

%=======================================================================
i_line_rule( cpawedengage_rule, [
%=======================================================================
   [`CPAwebengage`, `,`, `Inc`, `.`,  newline ]
] ).
%=======================================================================
i_line_rule( cpawedengage_rule1, [
%=======================================================================
   [`1119`, `S`, `Gilpin`, `St`,  newline ]
] ).
%=======================================================================
i_line_rule( cpawedengage_rule2, [
%=======================================================================
   [`Denver`, `,`, `CO`, `80210`,  newline ]
] ).
%=======================================================================
i_line_rule( cpawedengage_rule3, [
%=======================================================================
   [`(`, `303`, `)`, `221`, `.`, `4100`,  newline ]
] ).
%=======================================================================
i_line_rule( cpawedengage_rule4, [
%=======================================================================
   [`scott`, `@`, `cpaacademy`, `.`, `org`,  newline ]
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  eTouch Systems Corp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule(  etouch_chain_rule, [
%=======================================================================

      etouch_rule

     , etouch_rule1

	 , etouch_rule2

	 , etouch_rule3

    , set(chain,`intuit_taulia_etouch`)

    , trace( [ `This is a eTouch Systems Corp Document` ] )

] ).

%=======================================================================
i_line_rule( etouch_rule, [
%=======================================================================
   [`eTouch`, `Systems`, `Corp`,  newline ]
] ).
%=======================================================================
i_line_rule( etouch_rule1, [
%=======================================================================
   [`Invoice`,  newline ]
] ).
%=======================================================================
i_line_rule( etouch_rule2, [
%=======================================================================
   [`6627`, `Dumbarton`, `Circle`,  newline ]
] ).
%=======================================================================
i_line_rule( etouch_rule3, [
%=======================================================================
   [`Fremont`, `,`, `CA`, `94555`, tab, `Date`, tab, `Invoice`, `#`,  newline ]
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Interactions LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( interactions_chain_rule, [
%=======================================================================

      interactions_rule

     , interactions_rule1

	 , interactions_rule2

	 , interactions_rule3

	 , interactions_rule4

    , set(chain,`intuit_taulia_interactions`)

    , trace( [ `This is a Interactions LLC Document` ] )

] ).

%=======================================================================
i_line_rule( interactions_rule, [
%=======================================================================
   or([
	   	   [`Remit`, `Payments`, `to`, `:`,  newline ]
          ,[`Remit`, `Payments`, `to`, `:`, tab, `USD`, `43`, `,`, `925`, `.`, `00`,  newline]
      ])

] ).
%=======================================================================
i_line_rule( interactions_rule1, [
%=======================================================================
   or([
	   	   [`Interactions`, `LLC`,  newline ]
          ,[`Subtotal`,  newline]
      ])

] ).

%=======================================================================
i_line_rule( interactions_rule2, [
%=======================================================================
   or([
	   [`Dept`, `3443`,  newline ]
	  ,[`Department`, `3443`,  newline ]
	  ,[`Interactions`, `LLC`, `-`, `Dept`, `3443`,  newline ]
	   ])
] ).
%=======================================================================
i_line_rule( interactions_rule3, [
%=======================================================================
   [`P`, `.`, `O`, `.`, `Box`, `123443`,  newline ]
] ).

%=======================================================================
i_line_rule( interactions_rule4, [
%=======================================================================
   or([
	   	   [`Dallas`, `,`, `TX`, `75312`, `-`, `3443`,  newline ]
		  ,[ `Dallas`, `,`, `TX`, `75312`, `-`, `3443`, tab, `Sales`, `Tax`, tab, `USD`, `0`, `.`, `00`,  newline ]
     ])

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Stock & Option Solutions, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( stock_chain_rule, [
%=======================================================================

      stock_rule

     , q10(stock_rule1)

	 , stock_rule2

	 , stock_rule3

	 , stock_rule4


    , set(chain,`intuit_taulia_stock_option`)

    , trace( [ `This is a Stock & Option Solutions, Inc. Document` ] )

] ).

%=======================================================================
i_line_rule( stock_rule, [
%=======================================================================

	   [`Stock`, `&`, `Option`, `Solutions`, `,`, `Inc`, `.`,  newline ]


] ).

%=======================================================================
i_line_rule( stock_rule1, [
%=======================================================================

	   
	   [`910`, `Campisi`, `Way`, `#`, `2E`,  newline ]


] ).


%=======================================================================
i_line_rule( stock_rule2, [
%=======================================================================

	   
	   [`Campbell`, `,`, `CA`, `95008`,  newline ]

] ).

%=======================================================================
i_line_rule( stock_rule3, [
%=======================================================================

   [`Invoice`,  newline ]

] ).

%=======================================================================
i_line_rule( stock_rule4, [
%=======================================================================

	   [`DATE`, tab, `INVOICE`, `#`,  newline ]


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The Bookkeepers Friend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( bookkeepers_chain_rule, [
%=======================================================================

      bookkeepers_rule

     , bookkeepers_rule1

	 , bookkeepers_rule2

	 , bookkeepers_rule3

	 , bookkeepers_rule4


    , set(chain,`intuit_taulia_bookkeepers`)

    , trace( [ `This is a The Bookkeepers Friend Document` ] )

] ).

%=======================================================================
i_line_rule( bookkeepers_rule, [
%=======================================================================

	   [`The`, `Bookkeepers`, `Friend`,  newline ]


] ).

%=======================================================================
i_line_rule( bookkeepers_rule1, [
%=======================================================================

	   
	   [`350`, `10th`, `Avenue`, `,`, `Suite`, `1000`, tab, `Invoice`, dummy_num(d),  newline ]


] ).


%=======================================================================
i_line_rule( bookkeepers_rule2, [
%=======================================================================

	   
	   [`San`, `Diego`, `,`, `CA`, `92101`, `US`,  newline ]

] ).

%=======================================================================
i_line_rule( bookkeepers_rule3, [
%=======================================================================

   [`erin`, `@`, `bookkeepersfriend`, `.`, `com`,  newline ]

] ).

%=======================================================================
i_line_rule( bookkeepers_rule4, [
%=======================================================================

	   [`www`, `.`, `BookkeepersFriend`, `.`, `com`,  newline ]


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Pierpoint International LLC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( pierpoint_chain_rule, [
%=======================================================================

      pierpoint_rule

     , pierpoint_rule1

	 , pierpoint_rule2

	 , pierpoint_rule3

	 , pierpoint_rule4


    , set(chain,`intuit_taulia_pierpoint`)

    , trace( [ `This is a Pierpoint International LLC Document` ] )

] ).

%=======================================================================
i_line_rule( pierpoint_rule, [
%=======================================================================

	   [`Pierpoint`, `International`, `LLC` ]


] ).

%=======================================================================
i_line_rule( pierpoint_rule1, [
%=======================================================================

	   
	   [`1065`, `Cross`, `Springs`, `Ct`]


] ).


%=======================================================================
i_line_rule( pierpoint_rule2, [
%=======================================================================

	   
	   [`San`, `Jose`, `,`, `CA`, `95120` ]

] ).

%=======================================================================
i_line_rule( pierpoint_rule3, [
%=======================================================================

   [`ignacio`, `.`, `martin`, `@`, `pierpoint`, `.`, `com` ]

] ).

%=======================================================================
i_line_rule( pierpoint_rule4, [
%=======================================================================

	   [`www`, `.`, `pierpoint`, `.`, `com`,  newline ]


] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Gerould & Player
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( gerould_chain_rule, [
%=======================================================================

      gerould_rule

     , gerould_rule1

	 , gerould_rule2

	 , gerould_rule3



    , set(chain,`intuit_taulia_gerould`)

    , trace( [ `This is a Gerould & Player Document` ] )

] ).

%=======================================================================
i_line_rule( gerould_rule, [
%=======================================================================

	   [`Total`, tab, `$`, dummy_num(d),  newline ]


] ).

%=======================================================================
i_line_rule( gerould_rule1, [
%=======================================================================

	   
	   [`Detailed`, `Statement`, `of`, `Account`,  newline ]


] ).


%=======================================================================
i_line_rule( gerould_rule2, [
%=======================================================================

	   
	   [`Current`, `Invoice`,  newline ]

] ).

%=======================================================================
i_line_rule( gerould_rule3, [
%=======================================================================

   [`Invoice`, `Number`, tab, `Due`, `On`, tab, `Amount`, `Due`, tab, `Payments`, `Received`, tab, `Balance`, `Due`,  newline ]

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Roaming Hunger, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( roaminghunger_chain_rule, [
%=======================================================================

      roaminghunger_rule

     , roaminghunger_rule1

	 , roaminghunger_rule2

	 , roaminghunger_rule3



    , set(chain,`intuit_taulia_roaming_hunger`)

    , trace( [ `This is a Roaming Hunger, Inc Document` ] )

] ).

%=======================================================================
i_line_rule( roaminghunger_rule, [
%=======================================================================

	   [`From`, tab, `Roaming`, `Hunger`, `,`, `Inc`, `.`,  newline ]


] ).

%=======================================================================
i_line_rule( roaminghunger_rule1, [
%=======================================================================

	   
	   [`8228`, `W`, `Sunset`, `Blvd`,  newline ]


] ).


%=======================================================================
i_line_rule( roaminghunger_rule2, [
%=======================================================================

	   
	   [`Suite`, `B`,  newline ]

] ).

%=======================================================================
i_line_rule( roaminghunger_rule3, [
%=======================================================================

   [`West`, `Hollywood`, `,`, `CA`, `90046`,  newline ]

] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Secure One identify rule
%=======================================================================
i_rule(  secure_one_identify_rule, [
%=======================================================================
     secure_rule_1
	, secure_rule_2
	, secure_rule_3
	, q(1,2,line)
	, secure_rule_4
    , set(chain,`intuit_taulia_secure_one`)
    , trace( [ `This is a - Secure One outsource Document` ] )
] ).
%=======================================================================
i_line_rule( secure_rule_1, [
%=======================================================================
   [`Invoice`,  newline ]
] ).
%=======================================================================
i_line_rule( secure_rule_2, [
%=======================================================================
   [`2801`, `N`, `.`, `33RD`, `AVE`, `.`, `,`, `STE`, `1`, tab, `INVOICE`, `DATE`, tab, `INVOICE`, `#`,  newline ]
] ).
%=======================================================================
i_line_rule( secure_rule_3, [
%=======================================================================
   [`PHOENIX`, `AZ`, `85009`, `-`, `1445`,  newline ]
] ).
%=======================================================================
i_line_rule( secure_rule_4, [
%======================================================================
   [`BILL`, `TO`,  newline ]
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WOODRUFF SAWYER AND CO identify rule
%=======================================================================
i_rule(  woodruff_sawyer_identify_rule, [
%=======================================================================
     woodruff_rule_1
	, woodruff_rule_2
	, woodruff_rule_3
	, woodruff_rule_4
	, q(1,2,line)
	, woodruff_rule_5
    , set(chain,`intuit_woodruff_sawyer`)
    , trace( [ `This is a - WoodRuff Sawyer Document` ] )
] ).
%=======================================================================
i_line_rule( woodruff_rule_, [
%=======================================================================
   [`PO`, `#` ]
] ).
%=======================================================================
i_line_rule( woodruff_rule_2, [
%=======================================================================
   [`Return`, `this`, `portion`, `with`, `your`, `payment`,  newline ]
] ).
%=======================================================================
i_line_rule( woodruff_rule_3, [
%=======================================================================
   [`Retain`, `this`, `portion`, `for`, `your`, `records`,  newline ]
] ).
%=======================================================================
i_line_rule( woodruff_rule_4, [
%======================================================================
   [`Invoice`, `#`, tab, `Inv`, `Date`, tab, `Total`, `Due`,  newline ]
] ).
%=======================================================================
i_line_rule( woodruff_rule_5, [
%======================================================================
   [`INVOICE`, `DUE`, `ON`, `PRESENTATION`,  newline ]
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real World Training
%=======================================================================
i_rule(  realworld_identify_rule, [
%=======================================================================
      realworld_rule_1
	, realworld_rule_2
	, realworld_rule_3
	, realworld_rule_4
	, q(1,2,line)
	, realworld_rule_5
    , set(chain,`intuit_taulia_real_world`)
    , trace( [ `This is a Real World Training Document` ] )
] ).
%=======================================================================
i_line_rule( realworld_rule_1, [
%=======================================================================
   [`Real`, `World`, `Training`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_2, [
%=======================================================================
   [`Invoice`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_3, [
%=======================================================================
   [`5501`, `LBJ`, `Freeway`, `,`, `Suite`, `180`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_4, [
%======================================================================
   [`Dallas`, `,`, `TX`, `75240`, tab, `DATE`, tab, `INVOICE`, `#`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_5, [
%======================================================================
   [`BILL`, `TO`,  newline ]
] ).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CISCO SYSTEMS CAPITAL CORPORATION
%=======================================================================
i_rule(  cisco_identify_rule, [
%=======================================================================
      cisco_rule_1
	, cisco_rule_2
	, cisco_rule_3
	, cisco_rule_4
	, cisco_rule_5
    , set(chain,`intuit_taulia_cisco`)
    , trace( [ `This is a CISCO SYSTEMS CAPITAL CORPORATION Document` ] )
] ).
%=======================================================================
i_line_rule( cisco_rule_1, [
%=======================================================================
   [`170`, `West`, `Tasman`, `Drive`,  newline ]
] ).
%=======================================================================
i_line_rule( cisco_rule_2, [
%=======================================================================
   [`San`, `Jose`, `,`, `CA`, `95134`, tab, `INVOICE`,  newline ]
] ).
%=======================================================================
i_line_rule( cisco_rule_3, [
%=======================================================================
   [`INVOICE`, `NO`, `:`, dummy_num(s1),  newline ]
] ).
%=======================================================================
i_line_rule( cisco_rule_4, [
%======================================================================
   [`INVOICE`, `DATE`, `:`, dummy_num(date),  newline ]
] ).
%=======================================================================
i_line_rule( cisco_rule_5, [
%======================================================================
   [`PAYMENT`, `DUE`, `DATE`, `:`, dummy_num1(date),  newline ]
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Twilio, Inc
%=======================================================================
i_rule(  twilio_identify_rule, [
%=======================================================================
      twilio_rule1
	  ,   twilio_rule2

    , set(chain,`intuit_taulia_twilio`)

    , trace( [ `This is a Twilio, Inc Document` ] )
] ).
%=======================================================================
i_line_rule( twilio_rule1, [
%=======================================================================
   [`Any`, `questions`, `regarding`, `this`, `invoice`, `,`, `contact`, `invoicing`, `@`, `twilio`, `.`, `com`, `.`,  newline ]
] ).

%=======================================================================
i_line_rule( twilio_rule2, [
%=======================================================================
   [`Twilio`, `,`, `Inc`, `.`, `,`, `375`, `Beale`, `Street`, `,`, `Suite`, `300`, `,`, `San`, `Francisco`, `,`, `CA`, `94105`,  newline ]
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Advantage Technical Resourcing
%=======================================================================
i_rule(  advantage_identify_rule, [
%=======================================================================
      advantage_rule1

    	, q(1,5,line)

	  ,   advantage_rule2

    , set(chain,`intuit_taulia_advantage`)

    , trace( [ `This is a Advantage Technical Resourcing Document` ] )
] ).
%=======================================================================
i_line_rule( advantage_rule1, [
%=======================================================================
   [`PLEASE`, `MAIL`, `ALL`, `REMITTANCES`, `TO`, `:`,  newline ]
] ).

%=======================================================================
i_line_rule( advantage_rule2, [
%=======================================================================
   [`PURCHASE`, `ORDER`, `NO`, `.`, tab, `TERMS`, tab, `SALESPERSON`, tab, `OFFICE`, `NO`, `.`, tab, `CUSTOMER`,  newline ]
] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SODEXO, INC & AFFILIATES
%=======================================================================
i_rule(  sodexo_identify_rule, [
%=======================================================================
         
		 sodexo_rule1

      , q(1,5,line)

	  ,  sodexo_rule2

	  , q(1,5,line)

	  ,  sodexo_rule3

    , set(chain,`intuit_taulia_sodexo`)

    , trace( [ `This is a SODEXO, INC & AFFILIATES Document` ] )
] ).
%=======================================================================
i_line_rule( sodexo_rule1, [
%=======================================================================

  or([

	  [`SODEXO`, `,`, `INC`, `&`, `AFFILIATES`,  newline ]
 ] )

] ).

%=======================================================================
i_line_rule( sodexo_rule2, [
%=======================================================================
  or([

	  [ `ATTN`, `:`,  newline  ]

   , [`BILL`, `TO`, `:`, tab, `MAKE`, `CHECK`, `PAYABLE`, `TO`, `:`,  newline ]

] )
] ).


%=======================================================================
i_line_rule( sodexo_rule3, [
%=======================================================================
  or([

	  [`TERMS`, tab, `ACCOUNT`, `NUMBER`, tab, `COST`, `CENTER`, tab, `INVOICE`, `DATE`, tab, `INVOICE`, `NO`, `.`,  newline ]
  , [`TERMS`, tab, `SDX`, `A`, `/`, `R`, `NUMBER`, tab, `UNIT`, `NUMBER`, tab, `INVOICE`, `DATE`, tab, `INVOICE`, `NUMBER`,  newline ]

] )
] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SODEXO, INC & AFFILIATES ALTERNATIVE
%=======================================================================
i_rule(  sodexo_identify_rule1, [
%=======================================================================
         
		 sodexo_rule1

	  , sodexo_rule2

      , q(1,5,line)

	  ,  sodexo_rule3

	  , q(1,5,line)

	  ,  sodexo_rule4


    , set(chain,`intuit_taulia_sodexo`)

    , trace( [ `This is a SODEXO, INC & AFFILIATES Document` ] )
] ).
%=======================================================================
i_line_rule( sodexo_rule1, [
%=======================================================================

  or([

	  [ `SODEXO`, `,`, `INC`, `&`, `AFFILIATES`,  newline ]
 ] )

] ).

%=======================================================================
i_line_rule( sodexo_rule2, [
%=======================================================================

  or([

	  [ `SERVICES`, tab, `INTUIT`,  newline ]
 ] )

] ).

%=======================================================================
i_line_rule( sodexo_rule3, [
%=======================================================================
  or([

	  [`BILL`, `TO`, `:`, tab, `INTUIT`, tab, `MAKE`, `CHECK`, `PAYABLE`, `TO`, `:`,  newline ]

] )
] ).


%=======================================================================
i_line_rule( sodexo_rule4, [
%=======================================================================
  or([

	  [`TERMS`, tab, `ACCOUNT`, `NUMBER`, tab, `COST`, `CENTER`, tab, `INVOICE`, `DATE`, tab, `INVOICE`, `NO`, `.`,  newline ]

] )
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real World Training
%=======================================================================
i_rule(  realworld_identify_rule1, [
%=======================================================================
      realworld_rule_11
	, realworld_rule_21
	, realworld_rule_31
	, realworld_rule_41
	, realworld_rule_51
    , set(chain,`intuit_taulia_real_world`)
    , trace( [ `This is a Real World Training Document` ] )
] ).
%=======================================================================
i_line_rule( realworld_rule_11, [
%=======================================================================
   [`Real`, `World`, `Training`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_21, [
%=======================================================================
   [`5501`, `LBJ`, `Freeway`, `,`, `#`, `180`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_31, [
%=======================================================================
   [`Dallas`, `,`, `TX`, `75240`, `US`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_41, [
%======================================================================
   [`trevor`, `_`, `matheson`, `@`, `realworldtraining`, `.`, `com`,  newline ]
] ).
%=======================================================================
i_line_rule( realworld_rule_51, [
%======================================================================
   [`www`, `.`, `quickbookstraining`, `.`, `com`,  newline ]
] ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Switch, Ltd
%=======================================================================
i_rule(  switch_identify_rule, [
%=======================================================================
     switch_rule_11
	, switch_rule_21
	,  switch_rule_31

    , set(chain,`intuit_taulia_switch`)
    , trace( [ `This is a Switch Ltd Document` ] )
] ).
%=======================================================================
i_line_rule( switch_rule_11, [
%=======================================================================
   [ `PO`, `Box`, `400850`,  newline ]
] ).
%=======================================================================
i_line_rule( switch_rule_21, [
%=======================================================================
   [`Las`, `Vegas`, `,`, `NV`, `89140`,  newline ]
] ).
%=======================================================================
i_line_rule( switch_rule_31, [
%=======================================================================
   [`Invoice`, `Date`, tab, `Due`, `Date`, tab, `Invoice`, `No`, `.`,  newline ]
] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wieden + Kennedy
%=======================================================================
i_rule(  wieden_identify_rule, [
%=======================================================================
     wieden_rule_11
	, wieden_rule_21
	,  wieden_rule_31

    , set(chain,`intuit_taulia_weiden`)
    , trace( [ `This is a Wieden + Kennedy Document` ] )
] ).
%=======================================================================
i_line_rule( wieden_rule_11, [
%=======================================================================
   [ `BILL`, `DATE`, dummy_num(date), tab, `PRODUCTION`, `BILL`, tab, `INVOICE`, tab ]
] ).
%=======================================================================
i_line_rule( wieden_rule_21, [
%=======================================================================
   [`CLIENT`, tab ]
] ).
%=======================================================================
i_line_rule( wieden_rule_31, [
%=======================================================================
   [`PRODUCT`, `COR`, tab ]
] ).