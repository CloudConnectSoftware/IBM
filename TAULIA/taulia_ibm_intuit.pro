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

	   , [ check_text( `133891517` ), set( chain, `intuit_taulia_deloittetouche` ), trace( [ `This is a Deloitte & Touche LLP Document` ] ) ]

	   , [ check_text( `861065772` ), set( chain, `intuit_taulia_deloittetax` ), trace( [ `This is a Deloitte Tax LLP Document` ] ) ]

	   , [ check_text( `528-0570` ), set( chain, `intuit_taulia_lexis` ), trace( [ `This is a LexisNexis Risk Solutions Document` ] ) ]

	   , [ check_text( `8005178268` ), set( chain, `intuit_taulia_matchpoint` ), trace( [ `This is a MatchPoint Solutions Document` ] ) ]

	   , [ check_text( `1-800-564-2688` ), set( chain, `intuit_taulia_real_world` ), trace( [ `This is a Real World Training Document` ] ) ]

	   , [ check_text( `140019613` ), set( chain, `intuit_taulia_clarity` ), trace( [ `This is a Clarity Consultants  Document` ] ) ]

	   , [ check_text( `4044756550` ), set( chain, `intuit_taulia_sally` ), trace( [ `This is a  Sally Williamson & Associates, Inc  Document` ] ) ]

       , [ check_text( `0052021029` ), set( chain, `intuit_taulia_switch` ), trace( [ `This is a  Switch, Ltd  Document` ] ) ]

	   , [ check_text( `30579543` ), set( chain, `intuit_taulia_yahoo` ), trace( [ `This is a Yahoo, Inc  Document` ] ) ]

	   , [ check_text( `2873602` ), set( chain, `intuit_taulia_hewitt` ), trace( [ `This is a Hewitt Associates LLC  Document` ] ) ]

	   , [ check_text( `35-2428242` ), set( chain, `intuit_taulia_interactive` ), trace( [ `This is a Interactive Intelligence  Document` ] ) ]

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

	   [`Pierpoint`, `International`, `LLC`,  newline ]


] ).

%=======================================================================
i_line_rule( pierpoint_rule1, [
%=======================================================================

	   
	   [`1065`, `Cross`, `Springs`, `Ct`,  newline ]


] ).


%=======================================================================
i_line_rule( pierpoint_rule2, [
%=======================================================================

	   
	   [`San`, `Jose`, `,`, `CA`, `95120`, `US`,  newline ]

] ).

%=======================================================================
i_line_rule( pierpoint_rule3, [
%=======================================================================

   [`ignacio`, `.`, `martin`, `@`, `pierpoint`, `.`, `com`,  newline  ]

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
