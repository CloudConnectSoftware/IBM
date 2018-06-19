%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM_KSB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ibm_ksb, `28/02/2018 14:40:04` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_page_split_rule_list( [ set( chain, `unrecognised_document` ), select_rules ] ).

%=======================================================================
i_no_lines_rule( encryption_error, Error_atom_in, Description_in, Error_atom_in, Description_in ):- q_sys_sub_string( Description_in, _, _, `PDF/OCR Error` ).
i_rule( encryption_error, [ set( chain, `ibm_ksb_reprint` ), trace( [ `IBM KSB REPRINT` ] ), set( re_extract ) ] ).
%=======================================================================

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

		,[ q0n(line), hosch_identify_rule ]

		, [q0n(line), ksb_halle_rule ]

		,[ q0n(line), nbe_identify_rule ]

		,[ q0n(line), schroder_identify_rule ]

		,[ q0n(line), baltico_identify_rule ]

		,[ q0n(line), auma_identify_rule ]

		,[ q0n(line), createc_identify_rule ]

		,[ q0n(line), exmar_identify_rule ]

		,[ q0n(line), kempchen_identify_rule ,set( re_extract ) ]

		,[ q0n(line), syro_identify_rule ]

		,[ q0n(line), ibs_identify_rule ]

		,[ q0n(line), weidenmann_identify_rule ]
	 
	    ,[ q0n(line), kb_schmiedetechnik_rule ]		

		,[ q0n(line), ksb_zetkama_comma_format_rule ]

		,[ q0n(line), ksb_zetkama_dot_format_rule ]	

		,[ q0n(line), ksb_amvi_rule ]	

		,[ q0n(line), ksb_service_rule ]	

		,[ q0n(line), leonard_identity_rule ]

		,[ q0n(line), ksb_oehler_rule]

		,[ q0n(line), willi_goebel_rule]

		,[ q0n(line), ksb_george_heinlein_rule]

		, [ q0n(line), ksb_se_co_identity_rule]

		,[ q0n(line), ksb_halm_motors_rule]

		,[ q0n(line), ksb_armaturen_rule]

		,[ q0n(line), weiss_kartonagen_rule]

		,[ q0n(line), wendik_pumpen_rule]

		,[ q0n(line), profil_identity_rule]

		,[ q0n(line), ksb_zetkama_comma_format_rule2]

		, [ q0n(line), scherer_identity_rule]

		, [ q0n(line), ksb_sas_identity_rule]

		

 		, [ q0n(line), metalldruckerei_identity_rule]

		


				
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

	[ check_text( `DataItemName(exactlyasitappearsonSDD)` ), set( chain, `generic test template` ), trace( [ `GENERIC TEST TEMPLATE` ] ) ]

	, [ check_text( `Turmstrasse92` ), set( chain, `ksb_halle` ), trace( [ `This is a KSB HALLE Document` ] ),set( re_extract )  ]  

	, [ check_text( `KSBSAS128,rueCarnot·59482Sequedin` ), set( chain, `ksb_ksb_sas` ), trace( [ `This is a KSB S.A.S document` ] ) ]

	, [ check_text( `DE230276848` ), set( chain, `ksb_eagle_burgmann_germany` ), trace( [ `This is EagleBurgmann Germany document` ] ) ]

	, [ check_text( `159105743` ), set( chain, `ksb_baltico` ), trace( [ `This is ksb_baltico document` ] ) ]

	, [ check_text( `FR91310540547` ), set( chain, `ksb_eagle_burgmann_france` ), trace( [ `This is EagleBurgmann France document` ] ) ]

	, [ check_text( `134525733` ), set( chain, `ksb_cog_germany` ), trace( [ `This is C. Otto Gehrckens GmbH & Co. document` ] ) ]

	, [ check_text( `DE-67065Ludwigshafen` ), set( chain, `ksb_rala_germany` ), trace( [ `This is Rala GmbH & Co. KG. document` ] ) ]

	, [ check_text( `5441114` ), set( chain, `ksb_rala_germany` ), trace( [ `This is Rala GmbH & Co. KG. document` ] ) ]

	, [ check_text( `100361` ), set( chain, `ksb_oehler_vermount` ), trace( [ `This is OEHLER VERPACKUNG GMBH document` ] ) ]

	, [ check_text( `DE144838902` ), set( chain, `ksb_guhring_kg` ), trace( [ `This is GUHRING KG document` ] ) ]

	%, [ check_text( `12298` ), set( chain, `ksb_george_heinlein` ), trace( [ `This is ksb_george_heinlein document` ] ) ]

	%, [ check_text( `KSBSE&Co.KGaA·Bahnhofplatz1·91257Pegnitz` ), set( chain, `ksb_ksb_aktiengesellschaft` ), trace( [ `This is KSB AKTIENGESELLSCHAFT document` ] ) ]

	% , [ check_text( `100002000` ), set( chain, `ksb_ksb_aktiengesellschaft` ), trace( [ `This is KSB AKTIENGESELLSCHAFT document` ] ) ]

	% , [ check_text( `100001000` ), set( chain, `ksb_ksb_aktiengesellschaft` ), trace( [ `This is KSB AKTIENGESELLSCHAFT document` ] ) ]

	, [ check_text( `DE811239368` ), set( chain, `ksb_e_w_neu` ), trace( [ `This is E.W. NEU GmbH document` ] ) ]

	, [ check_text( `062419102-36/062419102-22` )  , set( chain, `ksb_e_w_neu` ), trace( [ `THIS IS E.W. NEU GmbH DOCUMENT` ] ) ]

	, [ check_text( `01824150989` )  , set( chain, `ksb_motori_sommersi` ), trace( [ `THIS IS Motori DOCUMENT` ] ) ]

	, [ check_text( `FR91310540547` ), set( chain, `ksb_eagle_burgmann_germany` ), trace( [ `This is EagleBurgmann Germany document` ] ),  set( re_extract ) ]

	, [ check_text( `DE813137849` ), set( chain, `ksb_eriks_bayern` ), trace( [ `This is ERIKS BAYERN GMBH document` ] ) ]

	, [ check_text( `DE184690793` ), set( chain, `ksb_eriks_deutschland` ), trace( [ `This is ERIKS Deutschland GmbH document` ] ) ]

	, [ check_text( `DE815512007` ), set( chain, `ksb_dachser_se` ), trace( [ `This is Dachester document` ] ) ]

	, [ check_text( `DE811502037` ), set( chain, `ksb_hahn_kolb_werkzeuge` ), trace( [ `This is Hahn Kolb document` ] ) ]

	, [ check_text( `5800109` ), set( chain, `ksb_gmg_guesstec` ), trace( [ `This is GMG GuessTech document` ] ) ]

	, [ check_text( `DE811216379` ), set( chain, `ksb_klaus_kuhn` ), trace( [ `This is Kuhn Edelstahl document` ] ) ]

	, [ check_text( `34-948576031` ), set( chain, `ksb_aceros_moldeados` ), trace( [ `This is Aceros document` ] ) ]

	, [ check_text( `DE143331118` ), set( chain, `ksb_deufol_sudwest` ), trace( [ `This is Defoul document` ] ) ]

	, [ check_text( `DE144840510` ), set( chain, `ksb_martin_hohn` ), trace( [ `This is Martini Hohn document` ] ) ]

	, [ check_text( `210209` ), set( chain, `ksb_martin_hohn` ), trace( [ `This is Martini Hohn document` ] ) ]

	, [ check_text( `FR80394826721` ), set( chain, `ksb_safi` ), trace( [ `This is Safi document` ] ) ,set( re_extract ) ] 

	, [ check_text( `DE154069269` ), set( chain, `ksb_sandvik_tooling_eutschland` ), trace( [ `This is Sandbik tool document` ] ) ]

	, [ check_text( `DE813373709` ), set( chain, `ksb_steinfurth_co` ), trace( [ `This is Steinfurth co document` ] ) ]

	, [ check_text( `DE149695428` ), set( chain, `ksb_berger_lacke` ), trace( [ `This is Berger-Lacke GmbH document` ] ) ]

	, [ check_text( `812802911` ), set( chain, `ksb_general_logistics` ), trace( [ `This is GLS GmbH document` ] ) ]

	, [ check_text( `FR68998823504` ), set( chain, `ksb_adecco_france` ), trace( [ `This is ksb_adecco_france document` ] ) ]

	, [ check_text( `56980189700616` ), set( chain, `ksb_adecco_france` ), trace( [ `This is ksb_adecco_france document` ] ) ]

	, [ check_text( `DE310504248` ), set( chain, `ksb_metall_earbeitung` ), trace( [ `This is ksb_metall_earbeitung document` ] ) ]

	, [ check_text( `DE132952479` ), set( chain, `ksb_norpack_verpackungses` ), trace( [ `This is NORPACK Verpackungsges. mbH document` ] ) ]

	, [ check_text( `DE158880461` ), set( chain, `ksb_meyer_bhs` ), trace( [ `This is MEYER-BHS-EISENACH E.K. document` ] ) ]

	%, [ check_text( `43105015751000002313900991` ), set( chain, `ksb_zetkama_sp` ), trace( [ `This is Zetkama document` ] ) ]

	, [ check_text( `DE239321433` ), set( chain, `ksb_ruf_car` ), trace( [ `This is RUF CAR INH. SAJID SHEIKH document` ] ) ]

	, [ check_text( `DE811113924` ), set( chain, `ksb_schunk_ingenieurkeramik` ), trace( [ `This is SCHUNK INGENIEURKERAMIK GMBH document` ] ) ]

	, [ check_text( `5163844` ), set( chain, `ksb_erich_deinzer` ), trace( [ `This is ERICH DEINZER GMBH document` ] ) ]

	, [ check_text( `DE199451811` ), set( chain, `ksb_prysmian_kabel_und` ), trace( [ `This is Prysmian Kabel und Systeme GMBH document` ] ) ]

	, [ check_text( `DE250573510` ), set( chain, `ksb_kazenmaier_fleetservice` ), trace( [ `This is Kazenmaier FleetService GmbH document` ] ) ]

	, [ check_text( `68671` ), set( chain, `ksb_oberflachenschutz_strum` ), trace( [ `This is ksb_oberflachenschutz_strum document` ] ) ]

	, [ check_text( `DE121644009` ), set( chain, `ksb_seco_tools` ), trace( [ `This is Seco document` ] ) ]

	, [ check_text( `4-6·67227` ), set( chain, `ksb_mediaprint_mauthe` ), trace( [ `This is Mediaprint GmbH document` ] ) ]

	, [ check_text( `mediaprintmauthekalenderverlagGmbH` ), set( chain, `ksb_mediaprint_mauthe` ), trace( [ `This is Mediaprint GmbH document` ] ) ]

	, [ check_text( `DE121382220` ), set( chain, `ksb_edelstahlservice_frankfurte` ), trace( [ `This is Edelstahlservice Frankfurt document` ] ) ]

	, [ check_text( `5119136` ), set( chain, `ksb_antalis_verpackungen` ), trace( [ `This is Antalis Verpackungen GmbH document` ] ) ]

	, [ check_text( `DE147809725` ), set( chain, `ksb_antalis_verpackungen` ), trace( [ `This is Antalis Verpackungen GmbH document` ] ) ]

	, [ check_text( `DE814286379` ), set( chain, `ksb_metlog_gmbh` ), trace( [ `This is Metlog GmbH document` ] ) ]

	, [ check_text( `DE114176489` ), set( chain, `ksb_kennametal_deutschland` ), trace( [ `This is ksb_kennametal_deutschland document` ] ) ]

	, [ check_text( `DE811154786` ), set( chain, `ksb_thyssenkrupp_schulte` ), trace( [ `This is Thyssenkrupp Schulte document` ] ) ]

	, [ check_text( `5717430` ), set( chain, `ksb_societe_traitement` ), trace( [ `This is Societe Traitementdocument` ] ) ]

	, [ check_text( `FR57494956774` ), set( chain, `ksb_dhl_int_ltd` ), trace( [ `This is DHL Express document` ] ) ]

	, [ check_text( `FR36408531804` ), set( chain, `ksb_sotomeca` ), trace( [ `This is ksb_sotomeca document` ] ) ]

	, [ check_text( `DE246035481` ), set( chain, `ksb_schilling_lechbearbeitung` ), trace( [ `This is Schilling Blechbearbeitung GmbH document` ] ),set( re_extract )  ]
	
	, [ check_text( `FR36546850215` ), set( chain, `ksb_sachot_sas` ), trace( [ `This is Sachot SAS document` ] ),set( re_extract )  ]

	, [ check_text( `DE126936840` ), set( chain, `ksb_ids_logistik_gmbh` ), trace( [ `This is IDS Logistik Gmbh document` ] ),set( re_extract )  ]

    , [ check_text( `DE292339622` ), set( chain, `ksb_pumpentechnik` ), trace( [ `This is Pumpentechnik document` ] ),set( re_extract )  ]

	, [ check_text( `DE291636029` ), set( chain, `ksb_schaeffler_tech` ), trace( [ `This is Schaeffler Tech document` ] ),set( re_extract )  ]

	, [ check_text( `DE113541138` ), set( chain, `ksb_dell_gmbh` ), trace( [ `This is Dell GmbH document` ] ),set( re_extract )  ]

	, [ check_text( `DE275854405` ), set( chain, `ksb_mierawald` ), trace( [ `This is Mierawald document` ] ),set( re_extract )  ]

	, [ check_text( `DE125690970` ), set( chain, `ksb_heinrich_jungeblodt` ), trace( [ `This is Heinrich Jungeblodt GmbH & Co. KG document` ] ),set( re_extract )  ]

	, [ check_text( `DE147223734` ), set( chain, `ksb_emil_loffelhardt` ), trace( [ `This is Emil Löffelhardt GmbH & Co.KG, document` ] ),set( re_extract )  ]

	, [ check_text( `DE301803669` ), set( chain, `ksb_schuth_gmbh` ), trace( [ `This is Schüth GmbH document` ] ),set( re_extract )  ]

	, [ check_text( `DE811295751` ), set( chain, `ksb_ktr_systems` ), trace( [ `This is KTR Systems GmbH document` ] ),set( re_extract ) ]

	, [ check_text( `DE121978582` ), set( chain, `ksb_kussmann` ), trace( [ `This is Kussmann & Berkenhoff GmbH document` ] ),set( re_extract ) ]
	
	, [ check_text( `DE88545613100003866564` ), set( chain, `ksb_fs_fahrservice` ), trace( [ `This is FS Fahrservice document` ] ),set( re_extract ) ]

	, [ check_text( `DE248918483` ), set( chain, `ksb_pewag` ), trace( [ `This is a pewag Deutschland GmbH document` ] ),set( re_extract ) ]

	, [ check_text( `316/5710/0510` ), set( chain, `ksb_botec` ), trace( [ `This is a BOTEC GMBH document` ] ),set( re_extract ) ]

    , [ check_text( `CEEFR60703720078` ), set( chain, `ksb_seco_tools_france` ), trace( [ `This is a SECO TOOLS FRANCE document` ] ),set( re_extract ) ]

    , [ check_text( `DE293938584` ), set( chain, `ksb_abacus_resale` ), trace( [ `This is a Abacus Resale GmbH document` ] ),set( re_extract ) ]

    , [ check_text( `DE176919837` ), set( chain, `ksb_schumacher` ), trace( [ `This is a Schumacher Packaging GmbH document` ] ),set( re_extract ) ]

	, [ check_text( `DE73502109000400267014` ), set( chain, `ksb_nsk` ), trace( [ `This is a NSK Deutschland GmbH document` ] ),set( re_extract ) ]

    , [ check_text( `DE37600800000932500100` ), set( chain, `ksb_sika` ), trace( [ `This is a SIKA DEUTSCHLAND GMBH document` ] ),set( re_extract ) ]

    , [ check_text( `0341/41529-0` ), set( chain, `ksb_kessler` ), trace( [ `This is a KESSLER  CO. GMBH document` ] ),set( re_extract ) ]

    , [ check_text( `0324536470` ), set( chain, `ksb_la_fonte` ), trace( [ `This is a LA FONTE ARDENNAISE document` ] ),set( re_extract ) ]

    , [ check_text( `DE225673854` ), set( chain, `ksb_schneider` ), trace( [ `This is a SCHNEIDER ELECTRIC GMBH document` ] ),set( re_extract ) ]

	, [ check_text( `DE140462836` ), set( chain, `ksb_bgh` ), trace( [ `This is a BGH EDELSTAHL FREITAL GMBH document` ] ),set( re_extract ) ]

    , [ check_text( `DE132085007` ), set( chain, `ksb_gis` ), trace( [ `This is a GIS GESELLSCHAFT FÜR document` ] ),set( re_extract ) ]

    , [ check_text( `DE140853191` ), set( chain, `ksb_muller` ), trace( [ `This is a MÜLLER  PFEIFFER GMBH document` ] ),set( re_extract ) ]

    , [ check_text( `DE812676512` ), set( chain, `ksb_wurth` ), trace( [ `This is a WÜRTH INDUSTRIE SERVICE GMBH  CO. document` ] ),set( re_extract ) ]

    , [ check_text( `DE55593930000000591408` ), set( chain, `ksb_temeka` ), trace( [ `This is a Temeka GmbH Document` ] ),set( re_extract ) ]
		
	, [ check_text( `DE311282828` ), set( chain, `ksb_spt_surface` ), trace( [ `This is a S.P.T. GMBH document` ] ),set( re_extract ) ]

	, [ check_text( `DE26753600110000088919` ), set( chain, `ksb_samco_gmbh` ), trace( [ `This is a Samaco gmbh document` ] ),set( re_extract ) ]

	, [ check_text( `DE72753900000006488919` ), set( chain, `ksb_samco_gmbh` ), trace( [ `This is a Samaco gmbh document` ] ),set( re_extract ) ]

    , [ check_text( `DE215893757` ), set( chain, `ksb_runtime_packaging` ), trace( [ `This is a RUNTIME PACKAGING GMBH` ] ),set( re_extract ) ]

    , [ check_text( `DE262571627` ), set( chain, `ksb_hecker_werke` ), trace( [ `This is a HECKER WERKE GMBH Document` ] ),set( re_extract ) ]

	, [ check_text( `DE811179653` ), set( chain, `ksb_danfoss` ), trace( [ `This is a DANFOSS GMBH Document` ] ),set( re_extract ) ]

	, [ check_text( `FR29331607051` ), set( chain, `ksb_iscar_france` ), trace( [ `This is a ISCAR France Document` ] ),set( re_extract ) ]

	, [ check_text( `DE09330403100820025500` ), set( chain, `ksb_novafleet` ), trace( [ `This is a NOVOFLEET GmbH Document` ] ),set( re_extract ) ]

    , [ check_text( `FR44385317896` ), set( chain, `ksb_sarl_mecabess` ), trace( [ `This is a Mecabess Document` ] ),set( re_extract ) ]

	, [ check_text( `DE116735535` ), set( chain, `ksb_heckmann_maschinenbau` ), trace( [ `This is a Heckmann Maschinenbau Document` ] ) ]

	, [ check_text( `FR14439533902` ), set( chain, `ksb_saimap_vennot_fr` ), trace( [ `This is a ksb_saimap_vennot_fr Document` ] ) ]

	, [ check_text( `DE144742498` ), set( chain, `ksb_murrelektronik_gmbh` ), trace( [ `This is a Murrelektronik GmbH Document` ] ),set( re_extract ) ]

	, [ check_text( `FR33399402163` ), set( chain, `ksb_france_transmission_service` ), trace( [ `This is a FRANCE TRANSMISSION SERVICE Document` ] ) ]

	, [ check_text( `865513822222` ), set( chain, `ksb_anhui_yingliu` ), trace( [ `This is a Anhui Yingliu Document` ] ) ]

	, [ check_text( `FR61960201820` ), set( chain, `ksb_kennametal_france` ), trace( [ `This is a Kennametal France S.A.S Document` ] ) ,set( re_extract )  ]

	, [ check_text( `DE274210373` ), set( chain, `ksb_abacus_experten` ), trace( [ `This is a Abacus Experten GmbH Document` ] ),set( re_extract )  ]

	, [ check_text( `DE133554294` ), set( chain, `ksb_leger_gmbh` ), trace( [ `This is a LEGER GmbH Document` ] ) ,set( re_extract )  ]

	, [ check_text( `HU10886878` ), set( chain, `ksb_zollner_kft` ), trace( [ `This is a Zollner Kft  Document` ] ),set( re_extract )  ]

	, [ check_text( `DE143144040` ), set( chain, `ksb_carla_matejka` ), trace( [ `This is a Carla Matejka Document` ] ),set( re_extract )  ]

	, [ check_text( `DE117583549` ), set( chain, `ksb_westland_gummiwerke` ), trace( [ `This is a Westland Gummiwerke GmbH & Co KG Document` ] ),set( re_extract )  ]

	, [ check_text( `DE812975800` ), set( chain, `ksb_office_center` ), trace( [ `This is a OFFICE CENTER GMBH Document` ] ),set( re_extract )  ]

    , [ check_text( `400926078` ), set( chain, `ksb_holl_elektro` ), trace( [ `This is a HOLL ELEKTRO-TECHNIK GMBH Document` ] ),set( re_extract )  ]

    , [ check_text( `DE279204587` ), set( chain, `ksb_alex_faber` ), trace( [ `This is a ALEX FABER GMBH Document` ] ),set( re_extract )  ]

	, [ check_text( `DE277583745` ), set( chain, `ksb_lub_service` ), trace( [ `This is a Lub Service GmbH Document` ] ),set( re_extract )  ]

	, [ check_text( `DE812855907` ), set( chain, `ksb_lukas` ), trace( [ `This is a LUKAS-ERZETT VEREINIGTE SCHLEIF- UN Document` ] ),set( re_extract )  ]

	, [ check_text( `DE149703070` ), set( chain, `ksb_ksi_klaus` ), trace( [ `This is a KSI - Klaus Stahl Industrielackierungen GmbH Document` ] ),set( re_extract )  ]
  
    , [ check_text( `DE811971858` ), set( chain, `ksb_mondeo` ), trace( [ `This is a Mondeo GmbH Document` ] ),set( re_extract )  ]

    , [ check_text( `DE813878496` ), set( chain, `ksb_ratinger` ), trace( [ `This is a Ratinger Hochdruck Document` ] ),set( re_extract )  ]

    , [ check_text( `DE125352849` ), set( chain, `ksb_veolia` ), trace( [ `This is a Veolia Umweltservice Süd GmbH & Co. KG Document` ] ),set( re_extract )  ]

    , [ check_text( `DE813444819` ), set( chain, `ksb_freudenberg` ), trace( [ `This is a Freudenberg Process Seals GmbH & Co. KG Document` ] ),set( re_extract )  ]

    , [ check_text( `DE811113828` ), set( chain, `ksb_schunk_kohlenst` ), trace( [ `This is a Schunk Kohlenstofftechnik GmbH Document` ] ),set( re_extract )  ]

	, [ check_text( `DE168979887` ), set( chain, `ksb_ernst_augstin` ), trace( [ `This is a Ernst Augustin Document` ] ),set( re_extract )  ]

    , [ check_text( `DE20545613100000916854` ), set( chain, `ksb_bernd_ulrich` ), trace( [ `This is a BERND ULRICH Document` ] ),set( re_extract )  ]

    , [ check_text( `IT72E0200811804000003733126` ), set( chain, `ksb_reel_srl` ), trace( [ `This is a REEL  S.R.L. A SOCIO UNICO Document` ] ),set( re_extract )  ]

    , [ check_text( `DE812287130` ), set( chain, `ksb_findling` ), trace( [ `This is a FINDLING WÄLZLAGER GMBH Document` ] ),set( re_extract )  ]

    , [ check_text( `DE91760693690000063355` ), set( chain, `ksb_metallbau` ), trace( [ `This is a Metallbau Waldmann GmbH Document` ] ),set( re_extract )  ]

    , [ check_text( `GB774122046` ), set( chain, `ksb_inpro_seal` ), trace( [ `This is a INPRO/SEAL UK Document` ] ),set( re_extract )  ]

    , [ check_text( `DE811275032` ), set( chain, `ksb_fritz_unkauf` ), trace( [ `This is a Fritz Unkauf Document` ] ),set( re_extract )  ]
   
	, [ check_text( `DE117982729` ), set( chain, `ksb_f_reyher` ), trace( [ `This is a F. REYHER NCHFG. Document` ] ) ]

    , [ check_text( `DE120351311` ), set( chain, `ksb_bearing_service` ), trace( [ `This is a BEARING SERVICE Document` ] ) ]

	, [ check_text( `DE149960485` ), set( chain, `ksb_lebenshilfe` ), trace( [ `This is a LEBENSHILFE EINRICHTUNGEN GMBH Document` ] ) ]

    , [ check_text( `DE138278260` ), set( chain, `ksb_uder_elecktromechanik` ), trace( [ `This is a UDER ELEKTROMECHANIK GMBH Document` ] ) ]

	, [ check_text( `FR25320528615` ), set( chain, `ksb_techne` ), trace( [ `This is a TECHNE Document` ] ) ]

	, [ check_text( `DE811163253` ), set( chain, `ksb_bgh_edelstahl` ), trace( [ `This is a BGH Edelstahl Siegen GmbH Document` ] ) ]

    , [ check_text( `DE211251155` ), set( chain, `ksb_khg_warnecke` ), trace( [ `This is a KHG Warnecke GmbH Document` ] ) ]

    , [ check_text( `FR7618359000430001475364519` ), set( chain, `ksb_espa_production` ), trace( [ `This is a ESPA PRODUCTION FRANCE, S.A.S Document` ] ) ]

     , [ check_text( `FR7630004007530001016358348` ), set( chain, `ksb_espa_production` ), trace( [ `This is a ESPA PRODUCTION FRANCE, S.A.S Document` ] ) ]

	   , [ check_text( `FR20569801897016031` ), set( chain, `ksb_espa_production` ), trace( [ `This is a ESPA PRODUCTION FRANCE, S.A.S Document` ] ) ]

     , [ check_text( `DE184570807` ), set( chain, `ksb_ls_prazisionsguss` ), trace( [ `This is a L+S Präzisionsguss GmbH Document` ] ) ]

    , [ check_text( `DE298545374` ), set( chain, `ksb_samuel_thiessen` ), trace( [ `This is a SAMUEL THIESSEN Document` ] ) ]

    , [ check_text( `DE811145412` ), set( chain, `ksb_still_gmbh` ), trace( [ `This is a STILL GMBH Document` ] ) ]

    , [ check_text( `FR47352225668` ), set( chain, `ksb_deltametal` ), trace( [ `This is a DELTA METAL Document` ] ) ]

	, [ check_text( `FR27522059` ), set( chain, `ksb_vailmeca` ), trace( [ `This is a VAILMECA SARL Document` ] ) ]

    , [ check_text( `DE158866111` ), set( chain, `ksb_lms_maschinen` ), trace( [ `This is a LMS Maschinen- u. Stahlbau GmbH Document` ] ) ]

    , [ check_text( `DE212556619` ), set( chain, `ksb_schneider_gmbh` ), trace( [ `This is a SCHNEIDER GMBH Document` ] ) ]

    , [ check_text( `DE131878642` ), set( chain, `ksb_wika_alexander` ), trace( [ `This is a WIKA Alexander Wiegand SE & Co. KG Document` ] ) ]

    , [ check_text( `384300769` ), set( chain, `ksb_wmb_halle` ), trace( [ `This is a WMB WERKZEUGMASCHINENBAU HALLE GMBH Document` ] ) ]

	, [ check_text( `FR33324559970` ), set( chain, `ksb_office_depot` ), trace( [ `This is a Office Depot - KSB document` ] ) ]

	, [ check_text( `2005210` ), set( chain, `ksb_office_depot` ), trace( [ `This is a Office Depot - KSB document` ] ) ]

	, [ check_text( `DE814898873` ), set( chain, `ksb_walter_deutschland` ), trace( [ `This is a ksb_walter_deutschland - KSB document` ] ) ]

	, [ check_text( `DE129274202` ), set( chain, `ksb_siemens_ag` ), trace( [ `This is a FLENDER A SIEMENS COMPANY document` ] ) ]

	, [ check_text( `(02871)92-2185` ), set( chain, `ksb_siemens_ag` ), trace( [ `This is a FLENDER A SIEMENS COMPANY document` ] ) ]

	, [ check_text( `DE112400197` ), set( chain, `ksb_john_crane` ), trace( [ `This is a JOHN CRANE GMBH document` ] ) ]
	
	, [ check_text( `DE814853900` ), set( chain, `ksb_nosta_gmbh` ), trace( [ `This is a NOSTA GMBH document` ] ) ]	

	, [ check_text( `DE149880250` ), set( chain, `ksb_klockner` ), trace( [ `This is a KLÖCKNER  CO document` ] ) ]	

    , [ check_text( `DE144994594` ), set( chain, `ksb_kienle_spiess` ), trace( [ `This is a KIENLE + SPIESS GMBH document` ] ) ]

    , [ check_text( `DE157692005` ), set( chain, `ksb_kovintrade_aussenhandels` ), trace( [ `This is a KIENLE + SPIESS GMBH document` ] ) ]		

	%, [ check_text( `E0000032` ), set( chain, `ksb_zetkama_sp` ), trace( [ `This is Zetkama document` ] ) ]	

	, [ check_text( `DE126936392` ), set( chain, `ksb_eisengiesserei` ), trace( [ `This is a EISENGIESSEREI BAUMGARTE GMBH document` ] ) ]

    , [ check_text( `DE138332497` ), set( chain, `ksb_metatec` ), trace( [ `This is a METATEC document` ] ) ]	

	, [ check_text( `DE130520562` ), set( chain, `ksb_eagleburgmann_austria` ), trace( [ `This is a EAGLEBURGMANN AUSTRIA GMBH document` ] ) ]	

	, [ check_text( `FR38786450239` ), set( chain, `ksb_john_crane_france` ), trace( [ `This is a JOHN CRANE FRANCE S.A. document` ] ) ]	

	, [ check_text( `812511510` ), set( chain, `ksb_plasmatic_franken` ), trace( [ `This is a Plasmatic Franken document` ] ) ,set( re_extract )  ]

	, [ check_text( `09115271983` ), set( chain, `ksb_plasmatic_franken` ), trace( [ `This is a Plasmatic Franken document` ] ) ,set( re_extract )  ]

	, [ check_text( `DE140635258` ), set( chain, `ksb_edelstahlwerke` ), trace( [ `This is a ksb_edelstahlwerke document` ] ) ]

	, [ check_text( `+4923827069` ), set( chain, `ksb_reflex_winkelmann` ), trace( [ `This is a REFLEX WINKELMANN GMBH + CO. KG  document` ] ) ]

	, [ check_text( `DE132455671` ), set( chain, `ksb_petz_industries` ), trace( [ `This is a petz industries Verwaltungs-GmbH  document` ] ) ]

    , [ check_text( `DE144526522` ), set( chain, `ksb_rexim_werkzeug` ), trace( [ `This is a REXIM Werkzeug GmbH  document` ] ) ]

	, [ check_text( `ATU68207914` ), set( chain, `ksb_spa_energietechnik` ), trace( [ `This is a SPA ENERGIETECHNIK  document` ] ) ]

    , [ check_text( `FR58341310100` ), set( chain, `ksb_numac` ), trace( [ `This is a NUMAC document` ] ) ]

    , [ check_text( `DE126959438` ), set( chain, `ksb_wiechert_gmbh` ), trace( [ `This is a WIECHERT GMBH document` ] ) ]

    , [ check_text( `DE133898319` ), set( chain, `ksb_skf_gmbh` ), trace( [ `This is a SKF GMBH document` ] ) ]

	, [ check_text( `FR35663820413` ), set( chain, `ksb_crouzet` ), trace( [ `This is a Crouzet Automatismes SAS document` ] ) ]

	, [ check_text( `DE811440472` ), set( chain, `ksb_bardusch_gmbh` ), trace( [ `This is a BARDUSCH GMBH  CO. document` ] ) ]

	, [ check_text( `DE815302903` ), set( chain, `ksb_hilti_deutschland` ), trace( [ `This is a HILTI DEUTSCHLAND AG document` ] ) ]

	, [ check_text( `DE812323555` ), set( chain, `ksb_schneidtechnik` ), trace( [ `This is a SCHNEIDTECHNIK MEIER GMBH document` ] ) ]  

	, [ check_text( `DE309222442` ), set( chain, `ksb_carolinenhutte` ), trace( [ `This is a Carolinenhütte GmbH document` ] ) ]

	, [ check_text( `DE126454812` ), set( chain, `ksb_aw_schumacher` ), trace( [ `This is a A. W. SCHUMACHER GMBH document` ] ) ]

	, [ check_text( `ESA08703928` ), set( chain, `ksb_isovolta_sau` ), trace( [ `This is a ISOVOLTA S.A.U. document` ] ) ]

	, [ check_text( `DE813599265` ), set( chain, `ksb_sero_pumpsystems` ), trace( [ `This is a SERO PumpSystems GmbH document` ] ) ]

	, [ check_text( `DE238022269` ), set( chain, `ksb_hoffmann_group` ), trace( [ `This is a Hoffmann Group System GmbH document` ] ) ]

    , [ check_text( `DE266920018` ), set( chain, `ksb_hbk_metall` ), trace( [ `This is a HBK METALLBEARBEITUNG GMBH document` ] ) ]

  % , [ check_text( `896851000` ), set( chain, `ksb_ksb_amvi` ), trace( [ `This is a KSB AMVI document` ] ) ]

    , [ check_text( `IT14T0306909484100000006490` ), set( chain, `ksb_ksb_italia` ), trace( [ `This is a KSB ITALIA S.P.A. document` ] ) ]

  	%, [ check_text( `896851000` ), set( chain, `ksb_service_gmbh_johann` ), trace( [ `This is a KSB Service GmbH · Johann-Klein-Strasse  document` ] ) ]

	, [ check_text( `IBANDE19120700000264614900` ), set( chain, `ksb_ksb_service_gmbh` ), trace( [ `This is a KSB-SERVICE GMBH document` ] ) ]


	, [ check_text( `61288725-5039` ), set( chain, `ksb_volt_electric` ), trace( [ `This is a VOLT ELEKTRIC MOTOR document` ] ) ]

	, [ check_text( `FR7630003004250002027959673` ), set( chain, `ksb_rapic_sas` ), trace( [ `This is a RAPIC SAS document` ] ) ]

	, [ check_text( `FR7611899001000003296234590` ), set( chain, `ksb_brammer_sas` ), trace( [ `This is a BRAMMER SAS document` ] ) ]

	, [ check_text( `DE111796669` ), set( chain, `ksb_rittal_gmbh` ), trace( [ `This is a RITTAL GMBH document` ] ) ]

	, [ check_text( `27/155/70779` ), set( chain, `ksb_schreinerei_schreider` ), trace( [ `This is a SCHREINEREI SCHREIDER document` ] ) ]

	, [ check_text( `DE119559353` ), set( chain, `ksb_karl_puplichhuisen` ), trace( [ `This is a Karl Püplichhuisen KG document` ] ) ]

	, [ check_text( `DE121289819` ), set( chain, `ksb_air_liquide` ), trace( [ `This is a AIR LIQUIDE Deutschland GmbH document` ] ) ]

	, [ check_text( `DE213843665` ), set( chain, `ksb_eatec_gmbh` ), trace( [ `This is a EATECH GMBH document` ] ) ]

	, [ check_text( `DE145178813` ), set( chain, `ksb_ibm_deutschland` ), trace( [ `This is a IBM DEUTSCHLAND GMBH document` ] ) ]

	, [ check_text( `DE191864071` ), set( chain, `ksb_gs_rohrtechnik` ), trace( [ `This is a G  S ROHRTECHNIK GMBH document` ] ) ]

	, [ check_text( `DE315477029` ), set( chain, `ksb_halm_motors` ), trace( [ `This is a HALM MOTORS + SYSTEMS GMBH document` ] ) ]

	, [ check_text( `DE812080510` ), set( chain, `ksb_cimcool_europe` ), trace( [ `This is a Cimcool Europe B.V. document` ] ) ]

	, [ check_text( `FR35537487613` ), set( chain, `ksb_aep_paris` ), trace( [ `This is a AEP PARIS IDF document` ] ) ]

	, [ check_text( `DE227413019` ), set( chain, `ksb_protec` ), trace( [ `This is a PROTEC.THE CAP COMPANY GMBH  CO. KG document` ] ) ]

	, [ check_text( `DE293796345` ), set( chain, `ksb_bitgrip_gmbh` ), trace( [ `This is a BITGRIP GMBH document` ] ) ]

	, [ check_text( `GB686806191` ), set( chain, `ksb_usg_gledco` ), trace( [ `This is a USG-Gledco Limited document` ] ) ]

	, [ check_text( `BG686806191` ), set( chain, `ksb_usg_gledco` ), trace( [ `This is a USG-Gledco Limited document` ] ) ]

	, [ check_text( `118/246/02966` ), set( chain, `ksb_schweiberei_luttich` ), trace( [ `This is a SCHWEIßEREI LÜTTICH document` ] ) ]

	, [ check_text( `DE228271361` ), set( chain, `ksb_richard_schmidt` ), trace( [ `This is a RICHARD SCHMIDT document` ] ) ]

	, [ check_text( `DE255865622` ), set( chain, `ksb_rt_muller` ), trace( [ `This is a R. & T. Müller GbR document` ] ) ]

	, [ check_text( `DE123499369` ), set( chain, `ksb_quarzwerke_gmbh` ), trace( [ `This is a QUARZWERKE GMBH document` ] ) ]

	, [ check_text( `DE111669551` ), set( chain, `ksb_aseo_gmbh` ), trace( [ `This is a ASEO GMBH document` ] ) ]

	, [ check_text( `FR92428704654` ), set( chain, `ksb_fonderie_ghm` ), trace( [ `This is a FONDERIE G.H.M. document` ] ) ]

	, [ check_text( `DE270487791` ), set( chain, `ksb_e_und_s` ), trace( [ `This is a E UND S GMBH document` ] ) ]

	, [ check_text( `FR56650500283` ), set( chain, `ksb_ets_bouley` ), trace( [ `This is a ETS BOULEY document` ] ),set( re_extract )  ]

	, [ check_text( `DE114658596` ), set( chain, `ksb_franz_gottwald` ), trace( [ `This is a FRANZ GOTTWALD document` ] ) ]

	, [ check_text( `IT00751000357` ), set( chain, `ksb_unielectric_spa` ), trace( [ `This is a UNIELECTRIC SPA document` ] ) ]

	, [ check_text( `00214700122` ), set( chain, `ksb_fonderie_santa` ), trace( [ `This is a FONDERIE SANTA-CATERINA SRL document` ] ) ]

	, [ check_text( `DE122796981` ), set( chain, `ksb_pms_berchem` ), trace( [ `This is a PMS- BERCHEM GMBH document` ] ) ]

	, [ check_text( `DE145472383` ), set( chain, `ksb_dr_e_tretter` ), trace( [ `This is a Dr. Erich Tretter GmbH+Co document` ] ) ]

	, [ check_text( `DE116738094` ), set( chain, `ksb_heckmann_metal` ), trace( [ `This is a HECKMANN METALL- UND document` ] ) ]

	, [ check_text( `ATU28809901` ), set( chain, `ksb_pewag_austria` ), trace( [ `This is a PEWAG AUSTRIA GMBH document` ] ) ]

	, [ check_text( `+49479555042-130` ), set( chain, `ksb_ritag_gmbh` ), trace( [ `This is a RITAG GMBH document` ] ) ]

	, [ check_text( `65217/09505` ), set( chain, `ksb_selz_gmbh` ), trace( [ `This is a SELZ GMBH document` ] ) ]

	, [ check_text( `DE215490523` ), set( chain, `ksb_sigmakom` ), trace( [ `This is a SIGMAKOM document` ] ) ]	

	, [ check_text( `DE815038176` ), set( chain, `ksb_trompetter_guss` ), trace( [ `This is a TROMPETTER GUSS GMBH CO. KG document` ] ) ]	

	, [ check_text( `DE113371645` ), set( chain, `ksb_wikus_sagengabrik` ), trace( [ `This is a WIKUS-SÄGEFABRIK document` ] ) ]	

	, [ check_text( `DE227982277` ), set( chain, `ksb_wiesner` ), trace( [ `This is a WIESNER DICHTUNGSTECHNIK document` ] ) ]	  

	, [ check_text( `DE811124432` ), set( chain, `ksb_saint_gobain` ), trace( [ `This is a SAINT-GOBAIN ABRASIVES GMBH document` ] ) ]	

	, [ check_text( `DE265232953` ), set( chain, `ksb_aldo_vertrieb` ), trace( [ `This is a ALDO VERTRIEB GMBH document` ] ) ]	   

	, [ check_text( `DE232911961` ), set( chain, `ksb_gabriele_und` ), trace( [ `This is a Gabriele und Dirk Graze document` ] ) ]	  

	, [ check_text( `31/653/00167` ), set( chain, `ksb_michael_hellenbernd` ), trace( [ `This is a MICHAEL HELLENBRAND GMBH document` ] ) ]	

	, [ check_text( `LU420030133666340000` ), set( chain, `ksb_morgan_amt` ), trace( [ `This is a MORGAN AMT document` ] ) ]	

	, [ check_text( `DE294321637` ), set( chain, `ksb_udg_hamburg` ), trace( [ `This is a UDG HAMBURG GMBH document` ] ) ]	    

	, [ check_text( `DE813703629` ), set( chain, `ksb_fischer_deutschland` ), trace( [ `This is a FISCHER DEUTSCHLAND document` ] ) ]	 

	, [ check_text( `DK70191814` ), set( chain, `ksb_nymetal_as` ), trace( [ `This is a NYMETAL A/S document` ] ),set( re_extract )  ]	

	, [ check_text( `NL001854318B01` ), set( chain, `ksb_elcee_holland` ), trace( [ `This is a Elcee Holland B.V. document` ] )  ]  

	, [ check_text( `FR51319416939` ), set( chain, `ksb_michaud_chailly` ), trace( [ `This is a MICHAUD CHAILLY document` ] )  ] 

	, [ check_text( `DE197732157` ), set( chain, `ksb_karl_wolf` ), trace( [ `This is a KARL WOLF PRÄZISION³ document` ] )  ] 

    , [ check_text( `DE123047934` ), set( chain, `ksb_randstad_deutschland` ), trace( [ `This is a RANDSTAD DEUTSCHLAND document` ] )  ] 

	, [ check_text( `GB898620274` ), set( chain, `ksb_springco_ni` ), trace( [ `This is a SPRINGCO (NI) LIMITED document` ] )  ] 
	
	, [ check_text( `DE233459763` ), set( chain, `ksb_gerlitz_elektro` ), trace( [ `This is a GERLITZ ELEKTRO-GMBH document` ] )  ] 

	, [ check_text( `SK7811110000001425123000` ), set( chain, `ksb_eurocast` ), trace( [ `This is a EUROCAST KOSICE, S.R.O. document` ] )  ] 
	
    , [ check_text( `52-1150358` ), set( chain, `ksb_crowell_moring` ), trace( [ `This is a CROWELL  MORING document` ] ) ,set( re_extract )   ] 
	
	, [ check_text( `DE234667863` ), set( chain, `ksb_arno_blum` ), trace( [ `This is a ARNO BLUM SANDSTRAHLSERVICE document` ] )  ] 

	, [ check_text( `DE210157578` ), set( chain, `ksb_sap_deustchland` ), trace( [ `This is a SAP DEUTSCHLAND SE  CO. KG document` ] )  ] 

	, [ check_text( `DE121385449` ), set( chain, `ksb_ask_chemicals` ), trace( [ `This is a ASK CHEMICALS GMBH document` ] )  ] 

	, [ check_text( `DE32545613100005270871` ), set( chain, `ksb_universal_klimatechnik` ), trace( [ `This is a UNIVERSAL KLIMATECHNIK GMBH document` ] )  ]

	, [ check_text( `DE121308375` ), set( chain, `ksb_schreier_metal` ), trace( [ `This is a SCHREIER METALL GMBH document` ] )  ]  

	, [ check_text( `DE306691143` ), set( chain, `ksb_ims_bayern` ), trace( [ `This is a IMS BAYERN GMBH document` ] )  ]  

	, [ check_text( `DE148421587` ), set( chain, `ksb_isg_internationale` ), trace( [ `This is a ISG INTERNATIONALE SPEDITION GMBH document` ] )  ] 

	, [ check_text( `DE811157376` ), set( chain, `ksb_eni_schmiertechnik` ), trace( [ `This is a ENI SCHMIERTECHNIK GMBH document` ] )  ]  

	, [ check_text( `FR2730002022730000466245U28` ), set( chain, `ksb_mabeo_direct` ), trace( [ `This is a MABEO INDUSTRIES document` ] )  ]  

	, [ check_text( `02381100060` ), set( chain, `ksb_fsc_srl` ), trace( [ `This is a F.S.C SRL document` ] )  ]  

	, [ check_text( `DE145771748` ), set( chain, `ksb_gfd_mbh` ), trace( [ `This is a GFD mbH document` ] ),set( re_extract )  ]  

	, [ check_text( `DE93783400910850703000` ), set( chain, `ksb_schenker_deutschland` ), trace( [ `This is a SCHENKER DEUTSCHLAND 5490681 document` ] ) ]  

	, [ check_text( `DE183835922` ), set( chain, `ksb_lexsys_language` ), trace( [ `This is a LEXSYS LANGUAGE CONSULTING document` ] ) ] 

	, [ check_text( `DE186166409` ), set( chain, `ksb_schoembs_gmbh` ), trace( [ `This is a Schoembs GmbH Elektronik document` ] ) ] 

	, [ check_text( `27/575/00054` ), set( chain, `ksb_khuene_nagel` ), trace( [ `This is a KÜHNE  NAGEL (AG  CO) KG document` ] ) ] 
	
	, [ check_text( `FR40300560588` ), set( chain, `ksb_messer_france` ), trace( [ `This is a Messer France S.A.S. document` ] ) ] 

	, [ check_text( `DE157692005` ), set( chain, `ksb_kovintrade_aussenhandels` ), trace( [ `This is a KOVINTRADE GmbH München document` ] ) ] 

	, [ check_text( `NL006608061B01` ), set( chain, `ksb_ksb_bv` ), trace( [ `This is a KSB B.V. document` ] ),set( re_extract ) ] 

	, [ check_text( `DE170424399` ), set( chain, `ksb_markus_luithle` ), trace( [ `This is a MARKUS LUITHLE GMBH  document` ] ) ] 

	, [ check_text( `DE05600100700958419703` ), set( chain, `ksb_markus_luithle` ), trace( [ `This is a MARKUS LUITHLE GMBH  document` ] ) ] 

	, [ check_text( `DE165038067` ), set( chain, `ksb_avis_budget_auto` ), trace( [ `This is a AVIS BuDGETR  document` ] ) ] 

	%, [ check_text( `FR20569801897` ), set( chain, `ksb_schenker_france` ), trace( [ `This is a ksb_schenker_france document` ] ) ] 

	, [ check_text( `DE23ZZZ00000219648` ), set( chain, `ksb_dhl_express_germany` ), trace( [ `This is a DHL Express Germany GmbH,  document` ] ) ] 

	, [ check_text( `30162744400047` ), set( chain, `ksb_sbei` ), trace( [ `This is a ksb_sbei document` ] ) ]

	, [ check_text( `FR93301627444` ), set( chain, `ksb_sbei` ), trace( [ `This is a ksb_sbei document` ] ) ]

	, [ check_text( `DE811174987` ), set( chain, `ksb_werkzeug_jager` ), trace( [ `This is a ksb_werkzeug_jager document` ] ) ]

	, [ check_text( `MetalldrückereiSchmittGmbH&Co` ), set(chain,`ksb_metalldruckerei`) , trace( [ `THIS IS A Metalldrückerei Schmitt GmbH & Co. KG DOCUMENT` ] )]

	, [ check_text( `FR62572200624` ), set( chain, `ksb_latty_internantional` ), trace( [ `This is a ksb_latty_internantionaldocument` ] ),set( re_extract )  ]  

	, [ check_text( `DE6410070000093144440` ), set( chain, `ksb_schenker_deutschland_5801159` ), trace( [ `This ksb_schenker_deutschland_5801159 document` ] ),set( re_extract )  ] 

	, [ check_text( `DE85500800000096403700` ), set( chain, `ksb_schenker_deutschland_5440742` ), trace( [ `This ksb_schenker_deutschland_5440742 document` ] ),set( re_extract )  ]  

	, [ check_text( `E71791900000008939969` ), set( chain, `ksb_weidenmann` ), trace( [ `This ksb_weidenmann document` ] ),set( re_extract )  ]  

	, [ check_text( `DE139713483` ), set( chain, `ksb_bgh_edelstahl_lippendorf` ), trace( [ `This ksb_bgh_edelstahl_lippendorf document` ] ),set( re_extract )  ]  

	, [ check_text( `DE811155990` ), set( chain, `ksb_thyssenkrupp_plastic` ), trace( [ `This ksb_thyssenkrupp_plastic document` ] ),set( re_extract )  ]  

	, [ check_text( `FR61429955297` ), set( chain, `ksb_manpower` ), trace( [ `This ksb_manpower document` ] )  ]  

	, [ check_text( `DE310116948` ), set( chain, `ksb_burgmann_packings` ), trace( [ `This Burgmann Packings GmbH document` ] )  ] 

	, [ check_text( `DE09370700600167671700` ), set( chain, `ksb_weg_germany` ), trace( [ `This WEG Germany GmbH document` ] )  ] 

	, [ check_text( `GB14DEUT40508112120400` ), set( chain, `ksb_waukesha_bearings` ), trace( [ `This WAUKESHA BEARINGS LTD document` ] )  ] 

	, [ check_text( `FR65320955396` ), set( chain, `ksb_fr_orexad` ), trace( [ `This OREXAD document` ] )  ] 

	, [ check_text( `FR12434680377` ), set( chain, `ksb_inoxyda` ), trace( [ `This INOXYDA document` ] )  ] 



	% , [ check_text( `` ), set( chain, `` ), trace( [ `` ] ) ]
	
] ) ] ).

%=======================================================================
i_rule( hosch_identify_rule, [
%=======================================================================
       hosch_line_1 
     , hosch_line_2
     , hosch_line_3
     , set(chain,`ksb__hosch_inh`)
     , trace( [ `THIS IS A HOSCH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( hosch_line_1, [
%=======================================================================
  or([
	  [`RECHNUNG`, tab, `NR`, `.`]
	  ,`GUTSCHRIFT`

  ])
] ).
%=======================================================================
i_line_rule( hosch_line_2 , [
%=======================================================================
[`ArtNr`, `Artikel`, `-`, `Bezeichnung`, tab, `Teile`, `-`, `Nummer`, tab, `Menge`, tab, `EUR`, `/`, `St`, `Rabatt`, `Summe`, `EUR` ]

] ).
%=======================================================================
i_line_rule(hosch_line_2 , [
%=======================================================================
 [`-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-`, `-` ]

] ).


%=======================================================================
i_rule(ksb_se_co_identity_rule , [
%=======================================================================
   
	  ksb_se_n_co
	 , set( chain, `ksb_ksb_aktiengesellschaft` )
     , trace( [ `THIS IS A KSB SE&CO DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule(ksb_se_n_co , [
%=======================================================================
	  [`KSBSE&CoKGaAJohannKlein-Strasse9·67227Frankenthal`]

] ).

%=======================================================================
i_rule(ksb_halle_rule , [
%=======================================================================
     ksb_halle_line_1
	 , set( chain, `ksb_halle` )
     , trace( [ `THIS IS A KSB HALLE DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( ksb_halle_line_1 , [
%=======================================================================
  or([
	  [ `KSB`, `SE`, `&`, `Co`, `.`, `KGaA`, `·`, `Turmstrasse`, `92`]
	
  ] )
] ).


%=======================================================================
i_rule( nbe_identify_rule, [
%=======================================================================
       nbe_line_1 
     , nbe_line_2
	
     , set(chain,`ksb_nbe`)
     , trace( [ `THIS IS A NBE-Elektrische Maschinen und Geräte GmbH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( nbe_line_1, [
%=======================================================================
  [`NBE`, `-`, `Elektrische`, `Maschinen`, `und`, `Geräte`, `GmbH`, `Am`, `Teich`, `3`, `06116`, `Halle`,  newline ]
] ).
%=======================================================================
i_line_rule( nbe_line_2 , [
%=======================================================================
[`Rechnung`,  newline ]

] ).



%=======================================================================
i_rule( schroder_identify_rule, [
%=======================================================================
       schroder_line_1

	   , q(0,2,line) 
     , schroder_line_2
	 , schroder_line_3
	
     , set(chain,`ksb_schroder`)
     , trace( [ `THIS IS A SCHRÖDER FLEISCHWAREN GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( schroder_line_1, [
%=======================================================================
  or([
	  
	  [`Kunde`, tab, `Rechnung`, tab, `Datum`,  newline ]

  , [`Empfänger`, `-`, `Nr`, `.`, tab ]
  ] )

] ).
%=======================================================================
i_line_rule( schroder_line_2 , [
%=======================================================================
  or([

[`Bei`, `Zahlung`, `bitte`, `unbedingt`, `angeben`,  newline ]

, [`Bei`, `Zahlung`, `bitte`, `unbedingt`, `angeben`,  newline ]

 ] )

] ).
%=======================================================================
i_line_rule( schroder_line_3 , [
%=======================================================================
  or([

[`externe`, `Auf`, `.`, `-`, `Nr`, `.`, `:`,  newline ]

, [`externe`, `Auf`, `.`, `-`, `Nr`, `.`, `:`, tab ]

 ] )

] ).



%=======================================================================
i_rule( baltico_identify_rule, [
%=======================================================================
    
	  baltico_line_1
	 , baltico_line_2
	 , q(0,4,line) 
	 , baltico_line_3
	
     , set(chain,`ksb_baltico`)
     , trace( [ `THIS IS A BALTICO GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( baltico_line_1, [
%=======================================================================
  [ `RECHNUNG`,  newline ]
] ).
%=======================================================================
i_line_rule( baltico_line_2 , [
%=======================================================================
[`Nummer`, tab, `Datum`, tab, `Unsere`, `Auftrags`, `-`, `Nr`, `.`, tab, `Kunden`, `-`, `Nr`, `.`, tab, `Ihre`, `Auftrags`, `-`, `Nr`, `.`, `/`, `Datum`,  newline ]

] ).
%=======================================================================
i_line_rule( baltico_line_3 , [
%=======================================================================
[`Pos`, `.`, `-`, `Nr`, `.`, `Produktbezeichnung`, tab, `Menge`, tab, `Einzelpreis`, tab, `Gesamtpreis`,  newline ]

] ).


%=======================================================================
i_rule( auma_identify_rule, [
%=======================================================================
    
	  auma_line_1
	 , auma_line_2
	 , auma_line_3
	
     , set(chain,`ksb_auma`)
     , trace( [ `THIS IS A AUMA FRANCE  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( auma_line_1, [
%=======================================================================
  [ `pos`, `.`, `article`, `désignation`, tab, `quantité`, tab, `prix`, `unitaire`, tab, `montant`,  newline ]

  
] ).
%=======================================================================
i_line_rule( auma_line_2 , [
%=======================================================================
[`N`, `/`, `ITEM01`, `-`, `V`, `/`]


] ).


%=======================================================================
i_rule( createc_identify_rule, [
%=======================================================================
    
	  createc_line_1
	 , createc_line_2

     , q(0,3,line) 
	 , createc_line_3
	
     , set(chain,`ksb_createc`)
     , trace( [ `THIS IS CREATEC GMBH  CO. KG  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( createc_line_1, [
%=======================================================================
  [ `Createc`, `GmbH`, `&`, `Co`, `.`, `KG`, `-`, `Eckenerstr`, `.`, `65`, `/`, `6`, `-`, `88046`, `Friedrichshafen`, tab, `Rechnung`,  newline ]
] ).
%=======================================================================
i_line_rule( createc_line_2 , [
%=======================================================================
[`Projektnummer`, tab ]

] ).
%=======================================================================
i_line_rule( createc_line_3 , [
%=======================================================================
[`Belegnummer`, tab ]

] ).



%=======================================================================
i_rule( exmar_identify_rule, [
%=======================================================================
    
	  exmar_line_1

	  , q(0,5,line)
	 , exmar_line_2
	 , exmar_line_3
	
     , set(chain,`ksb_exmar`)
     , trace( [ `THIS IS EXMAR GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( exmar_line_1, [
%=======================================================================
  [ `EXMAR`, `GmbH`, `,`, `Am`, `Taubenbaum`, `6`, `,`, `D`, `-`, `61231`, `Bad`, `Nauheim`, tab, `Lieferadresse`,  newline ]
] ).
%=======================================================================
i_line_rule( exmar_line_2 , [
%=======================================================================
[`Rechnung` ]

] ).
%=======================================================================
i_line_rule( exmar_line_3 , [
%=======================================================================
[`Kundennummer`, `:`, tab ]

] ).

%=======================================================================
i_rule( kempchen_identify_rule, [
%=======================================================================
    
	 kempchen_line_1

	  , q(0,2,line)
	 , kempchen_line_2
	 , kempchen_line_3
	
     , set(chain,`ksb_kempchen`)
     , trace( [ `THIS IS KEMPCHEN DICHTUNGSTECHNIK  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( kempchen_line_1, [
%=======================================================================
  [ `Rechnung`, q10(`-`), q10(`Reklamation`) ]
] ).
%=======================================================================
i_line_rule( kempchen_line_2 , [
%=======================================================================
[ `Rechnungsdat`, `.`, `:` ]

] ).
%=======================================================================
i_line_rule( kempchen_line_3 , [
%=======================================================================
[ `Auftrag` ]

] ).

%=======================================================================
i_rule( syro_identify_rule, [
%=======================================================================
    
	 syro_line_1
	 , syro_line_2
    , q(0,2,line)
	 , syro_line_3
	
     , set(chain,`ksb_syro`)
     , trace( [ `THIS IS SYRO GmBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( syro_line_1, [
%=======================================================================
  [ `Bauvorhaben`, `:`  ]
] ).
%=======================================================================
i_line_rule( syro_line_2 , [
%=======================================================================
[ `Projekt`, `:`, tab, `Ihre`, `Bestellung`, tab, `vom` ]

] ).
%=======================================================================
i_line_rule( syro_line_3 , [
%=======================================================================
[ `Telefon`, `:`, tab ]

] ).



%=======================================================================
i_rule( ibs_identify_rule, [
%=======================================================================
    
	 ibs_line_1
	 , ibs_line_2
     , ibs_line_3
	
     , set(chain,`ksb_ibs_ingenieurburo`)
     , trace( [ `THIS IS A IBS INGENIEURBÜRO SÄNGER GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( ibs_line_1, [
%=======================================================================
  [ `Datum`, tab]
] ).
%=======================================================================
i_line_rule( ibs_line_2 , [
%=======================================================================
[ `Bearbeiter`, tab ]

] ).
%=======================================================================
i_line_rule( ibs_line_3 , [
%=======================================================================
[`Kunden`, `-`, `Nr`, `.`, tab, `10141`,  newline ]

] ).


%=======================================================================
i_rule( weidenmann_identify_rule, [
%=======================================================================
    
     weidenmann_line_1
     , weidenmann_line_2
     , weidenmann_line_3
     , weidenmann_line_4
     , weidenmann_line_5
     , weidenmann_line_6

    
     , set(chain,`ksb_weidenmann`)
     , trace( [ `THIS IS A WIEDENMANN -SEILE GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( weidenmann_line_1, [
%=======================================================================
  [`·`, `Absturzsicherung`, tab, `·`]
] ).
%=======================================================================
i_line_rule( weidenmann_line_2 , [
%=======================================================================
[ `Am`, `Traugraben`, `8`, tab, `Delitzscher`, `Straße` ]

] ).
%=======================================================================
i_line_rule( weidenmann_line_3 , [
%=======================================================================
[`Tel`, `.`, `0`, `93`, `32`, `/`, `50`, `61`, `-`, `0`, tab ]

] ).
%=======================================================================
i_line_rule( weidenmann_line_4 , [
%=======================================================================
[`Fax`, `0`, `93`, `32`, `/`, `50`, `61`, `-`, `18`, tab ]

] ).
%=======================================================================
i_line_rule( weidenmann_line_5 , [
%=======================================================================
[`Wiedenmann`, `-`, `Seile`, `GmbH`, `Delitzscher`, `Straße`]

] ).
%=======================================================================
i_line_rule( weidenmann_line_6 , [
%=======================================================================
[`Lechstr`, `aße`, `21`, tab ]

] ).


%=======================================================================
i_rule( kb_schmiedetechnik_rule, [
%=======================================================================
    
      kb_schmiedetechnik_line_1
    , kb_schmiedetechnik_line_2
    , kb_schmiedetechnik_line_3
    , kb_schmiedetechnik_line_4
    , kb_schmiedetechnik_line_5
	, q(0,1,line)
    , kb_schmiedetechnik_line_6

    
     , set(chain,`ksb_kb_schmiedetechnik`)
     , trace( [ `THIS IS A KB SCHMIEDETECHNIK GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_1, [
%=======================================================================
  [`Rechnung`,  newline ]
] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_2 , [
%=======================================================================
[ `Seite`, `:`, tab ]

] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_3 , [
%=======================================================================
[`Rechnungsnr`, `.`, `:`, tab ]

] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_4 , [
%=======================================================================
[`Belegdatum`, `:`, tab ]

] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_5 , [
%=======================================================================
[`Auftragsnr`, `.`, `:`, tab ]

] ).
%=======================================================================
i_line_rule( kb_schmiedetechnik_line_6 , [
%=======================================================================
[`Kundennr`, `.`, `:`, tab, `60365`,  newline ]

] ).


%=======================================================================
i_rule( ksb_zetkama_comma_format_rule, [
%=======================================================================
    
	   zet_comma_line_1
	 , zet_comma_line_2
     , zet_comma_line_3
	 , zet_comma_line_4
     , zet_comma_line_5
	 , set(chain,`ksb_zetkama_sp_coma`)
     , trace( [ `THIS IS A ksb_zetkama_sp_coma DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( zet_comma_line_1 , [
%=======================================================================
  `Lieferbedingungen`
] ).
%=======================================================================
i_line_rule( zet_comma_line_2 , [
%=======================================================================
 `Ship`, `via`, `:`

] ).
%=======================================================================
i_line_rule( zet_comma_line_3 , [
%=======================================================================
  `Pos`, `Artikle`, `-`, `Nr`
] ).
%=======================================================================
i_line_rule( zet_comma_line_4 , [
%=======================================================================
 `Beschreibung`

] ).
%=======================================================================
i_line_rule( zet_comma_line_5 , [
%=======================================================================
`EUR`

] ).

%=======================================================================
i_rule( ksb_zetkama_comma_format_rule2, [
%=======================================================================
    
	   zet_comma_1
	 , zet_comma_2
     , zet_comma_3
	 , zet_comma_4
     
	 , set(chain,`ksb_zetkama_sp_coma`)
     , trace( [ `THIS IS A ksb_zetkama_sp_coma DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( zet_comma_1 , [
%=======================================================================
  `Lieferbedingungen`, `:`
] ).
%=======================================================================
i_line_rule( zet_comma_2 , [
%=======================================================================
 `Versandart`, `:`

] ).
%=======================================================================
i_line_rule( zet_comma_3 , [
%=======================================================================
  `Pos`, `.`, `Artikel`, `-`, `Nr`, `.`
] ).
%=======================================================================
i_line_rule( zet_comma_4 , [
%=======================================================================
 `Beschreibung`

] ).


%=======================================================================
i_rule( ksb_zetkama_dot_format_rule, [
%=======================================================================
    
	   zet_dot_line_1
	 , zet_dot_line_2
     , zet_dot_line_3
	 , zet_dot_line_4
     , zet_dot_line_5
	 , set(chain,`ksb_zetkama_sp`)
     , trace( [ `THIS IS A ksb_zetkama_sp Dot separator DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( zet_dot_line_1 , [
%=======================================================================
  `Delivery`, `terms`, `:`
] ).
%=======================================================================
i_line_rule( zet_dot_line_2 , [
%=======================================================================
 `Ship`, `via`, `:`

] ).
%=======================================================================
i_line_rule(zet_dot_line_3 , [
%=======================================================================
  `Pos`, `.`, `Index`
] ).
%=======================================================================
i_line_rule( zet_dot_line_4 , [
%=======================================================================
 `Description`

] ).
%=======================================================================
i_line_rule( zet_dot_line_5 , [
%=======================================================================
`pcs`

] ).





%=======================================================================
i_rule( ksb_amvi_rule, [
%=======================================================================
    
      ksb_amvi_line_1
    , ksb_amvi_line_2
    , ksb_amvi_line_3
    , ksb_amvi_line_4
    , ksb_amvi_line_5
     
     , set(chain,`ksb_ksb_amvi`)
     , trace( [ `THIS IS A KSB AMVI  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( ksb_amvi_line_1, [
%=======================================================================
  [`Invoice`,  newline  ]
] ).
%=======================================================================
i_line_rule( ksb_amvi_line_2 , [
%=======================================================================
[ `Number`, `:`, dummy_num(d),  newline ]

] ).
%=======================================================================
i_line_rule( ksb_amvi_line_3 , [
%=======================================================================
[`Date`, `:`, dummy_num(date),  newline ]

] ).
%=======================================================================
i_line_rule( ksb_amvi_line_4 , [
%=======================================================================
[`KSB`, `AMVI`, `·`, `C`, `/`, `El`, `Escudo`, `,`, `s`, `/`, `n`, `P`, `.`, `I`, `.`, `Villalonquejar`, `·`, `09001`, `BURGOS`, tab ]

] ).
%=======================================================================
i_line_rule( ksb_amvi_line_5 , [
%=======================================================================
[`Delivery`, `note`, `no`, `.`, `:`, dummy_num1(d),  newline ]

] ).





%=======================================================================
i_rule( ksb_service_rule, [
%=======================================================================
    
      ksb_service_line_1
    , ksb_service_line_2
    , ksb_service_line_3
    , ksb_service_line_4
    , ksb_service_line_5

  

    
     , set(chain,`ksb_service_gmbh_johann`)
     , trace( [ `THIS IS A KSB SERVICE GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( ksb_service_line_1, [
%=======================================================================
  [`Rechnung`,  newline ]
] ).
%=======================================================================
i_line_rule( ksb_service_line_2 , [
%=======================================================================
[ `Nummer`, `:`, dummy_num(d),  newline ]

] ).
%=======================================================================
i_line_rule( ksb_service_line_3 , [
%=======================================================================
[`Datum`, `:`, dummy_num(date),  newline ]

] ).

%=======================================================================
i_line_rule( ksb_service_line_4 , [
%=======================================================================
[`Auftrags`, `-`, `Nr`, `.`, `:`, dummy_num(s1),  newline ]

] ).
%=======================================================================
i_line_rule( ksb_service_line_5 , [
%=======================================================================
[`KSB`, `Service`, `GmbH`, `·`, `Johann`, `-`, `Klein`, `-`, `Strasse`, `9`, `·`, `67227`, `Frankenthal`, tab ]

] ).

%=======================================================================
i_rule( leonard_identity_rule, [
%=======================================================================
    
      leonard_line_rule
    , leonard_line_rule1
	,q(0,2,line)
    , leonard_line_rule2   
     , set(chain,`ksb_leonard`)
     , trace( [ `THIS IS A LEONARD ENGINEERING GMBH  DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( leonard_line_rule, [
%=======================================================================
  [`LEONARD`, `Engineering`, `GmbH`, `-`, `Am`, `Holzplatz`, `14`, `-`, `45721`, `Haltern`, `am`, `See`,  newline ]
] ).
%=======================================================================
i_line_rule( leonard_line_rule1 , [
%=======================================================================
[ `R`, `E`, `C`, `H`, `N`, `U`, `N`, `G`,  newline ]

] ).
%=======================================================================
i_line_rule( leonard_line_rule2 , [
%=======================================================================
[ `Rechnungseingang`, tab ]

] ).



%=======================================================================
i_rule( ksb_oehler_rule, [
%=======================================================================
    
	   oehler_line_1
	 , oehler_line_2
     , oehler_line_3
	 , oehler_line_4
     , oehler_line_5
	 , set(chain,`ksb_oehler_vermount`)
     , trace( [ `THIS IS A ksb_oehler_vermount DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( oehler_line_1 , [
%=======================================================================
  `Wir`, `berechnen`, `Ihnen`, `folgende`, `zum`, `Rechnungsdatum`, `erbrachte`, `Leistung`, `:`
] ).
%=======================================================================
i_line_rule( oehler_line_2 , [
%=======================================================================
 `Artikel`, tab, `Menge`, `Einheit`, tab, `VK`, `-`, `Preis`, tab, `Betrag`

] ).



%=======================================================================
i_rule( willi_goebel_rule, [
%=======================================================================
    
      willi_goebel_line
	, q(0,4,line)
    , willi_goebel_line1
	, q(0,2,line)
	, willi_goebel_line2
	, willi_goebel_line3
	, willi_goebel_line4   
    , set(chain,`ksb_willi_goebel`)
    , trace( [ `THIS IS A WILLI GOEBEL  DOCUMENT` ] )

] ).

%=======================================================================
i_line_rule( willi_goebel_line , [
%=======================================================================
[ `R`, `E`, `C`, `H`, `N`, `U`, `N`, `G`,  newline ]

] ).
%=======================================================================
i_line_rule( willi_goebel_line1 , [
%=======================================================================
  [`Liefer`, `.`, `Nr`, `.`, `:`, `5723892`,  newline ]
] ).
%=======================================================================
i_line_rule( willi_goebel_line2  , [
%=======================================================================
[  `Auftr`, `.`, `Dat`, `.`, `:`, dummy_num(date),  newline ]

] ).
%=======================================================================
i_line_rule( willi_goebel_line3 , [
%=======================================================================
[ `UStIdNr`, `:` ]

] ).
%=======================================================================
i_line_rule( willi_goebel_line4 , [
%=======================================================================
[ `Lieferart`, `:`, dummy_num(s1),  newline ]

] ).
%=======================================================================
i_rule( ksb_george_heinlein_rule, [
%=======================================================================
    
	   geroge_line_1
	 , geroge_line_2
     , set(chain,`ksb_george_heinlein`)
     , trace( [ `THIS IS A ksb_george_heinlein DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( geroge_line_1 , [
%=======================================================================
  `HERR`, `PAULI`
] ).
%=======================================================================
i_line_rule( geroge_line_2 , [
%=======================================================================
 `12298`

] ).


%=======================================================================
i_rule( ksb_halm_motors_rule, [
%=======================================================================
    
	   halm_motors_line_1
	 , halm_motors_line_2
     , set(chain,`ksb_halm_motors`)
     , trace( [ `THIS IS A HALM MOTORS + SYSTEMS GMBH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( halm_motors_line_1 , [
%=======================================================================
  [`HALM`, `Motors`, `+`, `Systems`, `GmbH`, `-`, `Silcherstr`, `.`, `54`, `-`, `73666`, `Baltmannsweiler`,  newline ]
] ).
%=======================================================================
i_line_rule( halm_motors_line_2 , [
%=======================================================================
[  `Gutschrift`, `/`, `Credit`, `/`, `note`, `de`, `crédit`,  newline ]

] ).



%=======================================================================
i_rule( ksb_armaturen_rule, [
%=======================================================================
    
	   armaturen_line_1
	 , armaturen_line_2
     , set(chain,`ksb_armaturen`)
     , trace( [ `THIS IS A ARMATUREN-ARNDT GmbH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( armaturen_line_1 , [
%=======================================================================
  [`ARMATUREN`, `-`, `ARNDT`, `GmbH`, `-`, `Heuserweg`, `16`, `-`, `53842`, `Troisdorf`,  newline ]
] ).
%=======================================================================
i_line_rule( armaturen_line_2 , [
%=======================================================================
[ `Rechnung`,  newline ]

] ).


%=======================================================================
i_rule( weiss_kartonagen_rule, [
%=======================================================================
    
	   weiss_kartonagen_1
	 , weiss_kartonagen_2

     , set(chain,`ksb_weiss_kartonagen`)
     , trace( [ `THIS IS A WEISS KARTONAGEN GMBH  CO. KG DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( weiss_kartonagen_1 , [
%=======================================================================
  [`Weiss`, `Kartonagen`, `GmbH`, `&`, `Co`, `.`, `KG`, `,`, `Postfach`, `2640`, `,`, `76616`, `Bruchsal`,  newline ]
] ).
%=======================================================================
i_line_rule( weiss_kartonagen_2 , [
%=======================================================================
[ `Firma`,  newline ]

] ).



%=======================================================================
i_rule( wendik_pumpen_rule, [
%=======================================================================
    
	   wendik_pumpen_line_1
	 , wendik_pumpen_line_2
	 , wendik_pumpen_line_3
     , wendik_pumpen_line_4
	 , wendik_pumpen_line_5
     , set(chain,`ksb_wendik_pumpen`)
     , trace( [ `THIS IS A WENDIK PUMPEN SERVICE GMBH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( wendik_pumpen_line_1 , [
%=======================================================================
  [`Kundennummer`, `:`, `10321`,  newline ]
] ).
%=======================================================================
i_line_rule( wendik_pumpen_line_2 , [
%=======================================================================
[ `Rechnung`, tab, `Seite`, `1`,  newline ]

] ).
%=======================================================================
i_line_rule( wendik_pumpen_line_3 , [
%=======================================================================
[ `Ansprechpartner`, `:` ]

] ).
%=======================================================================
i_line_rule( wendik_pumpen_line_4 , [
%=======================================================================
[`Telefonnummer`, `:` ]

] ).
%=======================================================================
i_line_rule( wendik_pumpen_line_5 , [
%=======================================================================
[`E`, `-`, `Mail`, `:` ]

] ).

%=======================================================================
i_rule( profil_identity_rule, [
%=======================================================================
    
	 profil_line_1
	 , profil_line_2
	 , profil_line_3
     , set(chain,`ksb_profil_interim`)
     , trace( [ `THIS IS A PROFIL INTERIM DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( profil_line_1 , [
%=======================================================================
  [`Agence`, `:`, `54`, `A`, `Rue`, `de`, `la`, `République`, `-`, `BARBEZIEUX`,  newline ]
] ).
%=======================================================================
i_line_rule( profil_line_2 , [
%=======================================================================
[ `Facture`, tab ]

] ).
%=======================================================================
i_line_rule( profil_line_3 , [
%=======================================================================
[ `Numéro`, tab, `:` ]

] ).


%=======================================================================
i_rule( scherer_identity_rule, [
%=======================================================================
    
	 scherer_line_1
	, q(0,4,line)
	 , scherer_line_2
	 , scherer_line_3
     , set(chain,`ksb_scherer_elektrotechnik`)
     , trace( [ `THIS IS A SCHERER GMBH DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( scherer_line_1 , [
%=======================================================================
  [`Firma`,  newline ]
] ).
%=======================================================================
i_line_rule( scherer_line_2 , [
%=======================================================================
[ `Koordin`, `.`, `:`, tab ]

] ).
%=======================================================================
i_line_rule( scherer_line_3 , [
%=======================================================================
[ `Kostenst`, `.`, `:` ]

] ).


%=======================================================================
i_rule( metalldruckerei_identity_rule, [
%=======================================================================
    
	 q10(metalldruckerei_line_1)
	 , metalldruckerei_line_2
     , set(chain,`ksb_metalldruckerei`)
     , trace( [ `THIS IS A Metalldrückerei Schmitt GmbH & Co. KG DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( metalldruckerei_line_1 , [
%=======================================================================
  [`@`, `@`, `NUMMER`, `+`, `4934548264847`, `@`, `@`, tab, `@`, `@`, `BETREFFSammelrechnung`, `:`, `39047vom`, `:`, `31`, `.`, `01`, `.`, `2018von`, `:`, `MetalldrückereiSchmittGmbH`, `&`, `Co`, `.`, `KG`, `,`, `Pf`, `.`, `1421`, `,`, `50331Hürth`, `@`, `@`,  newline ]
] ).
%=======================================================================
i_line_rule( metalldruckerei_line_2 , [
%=======================================================================
[ `Metalldrückerei`, `Schmitt`, `GmbH`, `&`, `Co`, `.`, `KG`, `,`, `Pf`, `.`, `1421`, `,`, `50331`, `Hürth`, tab, `Sammelrechnung`,dummy_num(d),  newline ]

] ).


%=======================================================================
i_rule( ksb_sas_identity_rule , [
%=======================================================================
    	   sas_line_1
	 , set(chain,`ksb_ksb_sas`)
     , trace( [ `THIS IS A KSB SAS DOCUMENT` ] )

] ).
%=======================================================================
i_line_rule( sas_line_1 , [
%=======================================================================
  or([
	  [`Invoice`, tab, `KSB`, `SAS` ]
	, [ `KSB`, `SAS`, `·`, `128`, `,`, `rue`, `Carnot`, `·`, `59482`, `Sequedin` ]
	, [ `Rechnung`, tab, `KSB`, `S`, `.`, `A`, `.`, `S`, `.`, `·`, `128`, `RUE`, `CARNOT`, `·`, `59320`, `SEQUEDIN`,  newline ]  
	, [ `Invoice`, tab, `KSB`, `SAS`, `·`, `10`, `-`, `14`, `rue`, `de`, `la`, `Gare` ]
	, [ `Invoice`, tab, `·`, `10`, `,`, `14`, `rue`, `de`, `la`, `gare`]
	, [`Invoice`, tab, `KSB`, `SAS`, `·`, `10`, `-`, `14`, `rue`, `de`, `la`, `Gare`, `·`]
	
  ] )
] ).

