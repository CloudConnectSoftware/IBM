%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - IBM_UNILEVER_INDIA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( ibm_unilever_india, `16/08/2016 14:37:15` ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% i_pdf_parameter( max_pages, 30 ).

i_page_split_rule_list( [ set( chain,`generic test template beta`), select_rules ] ).

%=======================================================================
i_no_lines_rule( colchester_reprint, Error_atom_in, Description_in, Error_atom_in, Description_in ).
i_rule( colchester_reprint, [ set( chain, `ibm unilever india chain reprint` ), trace( [ `UNILEVER REPRINT` ] ), set( re_extract ) ] ).
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

	] )

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

		[ check_text( `072251234001` ), set( chain, `capgemini invoice` ), trace( [ `CAPGEMINI` ] ) ]

		, [ check_text( `AAQFA8058G` ), set( chain, `sits invoice` ), trace( [ `SITS` ] ) ]

		, [ check_text( `28452366` ), set( chain, `asia travels invoice` ), trace( [ `ASIA TRAVELS` ] ) ]

		, [ check_text( `27760633425` ), set( chain, `ergo invoice` ), trace( [ `ERGO` ] ) ]

		, [ check_text( `galaxysurfactants` ), set( chain, `galaxy surfactants invoice` ), trace( [ `GALAXY SURFACTANTS LTD.` ] ) ]

		, [ check_text( `AAKFB6188NSD00` ), set( chain, `blank slate invoice` ), trace( [ `BLANK SLATE` ] ) ]

		, [ check_text( `AABCL1515HSD004` ), set( chain, `linfox logistics invoice` ), trace( [ `LINFOX LOGISTICS` ] ) ]

		, [ check_text( `34460008455` ), set( chain, `new india invoice` ), trace( [ `NEW INDIA` ] ) ]

		, [ check_text( `AACPJ3064FST001` ), set( chain, `jal auto invoice` ), trace( [ `JAL AUTO` ] ) ]

		, [ check_text( `27110386481` ), set( chain, `reliance invoice` ), trace( [ `RELIANCE` ] ) ]

		, [ check_text( `AAACG4464BXM005` ), set( chain, `grasim invoice` ), trace( [ `GRASIM` ] ), set(re_extract) ]

		, [ check_text( `Officedge` ), set( chain, `office edge invoice` ), trace( [ `OFFICE EDGE` ] ) ]

		, [ check_text( `AABCM8839KST001` ), set( chain, `mindtree invoice` ), trace( [ `MINDTREE` ] ) ]

		, [ check_text( `AACCN3584DST001` ), set( chain, `madhu invoice` ), trace( [ `MADHU` ] ) ]

		, [ check_text( `AAACS8083LSD006` ), set( chain, `sarovar invoice` ), trace( [ `SAROVAR` ] ), set(re_extract) ]

		, [ check_text( `SodexoFacilities` ), set( chain, `sodexo facilities invoice` ), trace( [ `SODEXO FACILITIES` ] ) ]

		, [ check_text( `TATAChemicals` ), set( chain, `tata chemicals invoice` ), trace( [ `TATA CHEMICALS` ] ) ]
		
		, [ check_text( `22161966` ), set( chain, `chintiamani invoice` ), trace( [ `CHINTIAMANI` ] ) ]

		, [ check_text( `AABCD3611QST001` ), set( chain, `dhl ibm unilever` ), trace( [ `DHL IBM` ] ) ]
		
		, [ check_text( `MSCAGENCY(INDIA)PVTLTD` ), set( chain, `msc agency invoice` ), trace( [ `MSC AGENCY IBM` ] ), set( re_extract ) ]

		, [ check_text( `AAACJ0381LST001` ), set( chain, `technosoft invoice` ), trace( [ `TECHNOSOFT` ] ) , set(re_extract) ]

    ] )

] ).