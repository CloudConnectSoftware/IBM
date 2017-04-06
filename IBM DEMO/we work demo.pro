%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - WE WORK DEMO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( we_work_demo , `05/04/2017 14:58:49`).

i_op_param( output, From, To, Subject, c_xml ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).

 i_pdf_parameter( space, 1 ).

 % i_pdf_parameter( no_scaling, 1 ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_rule_list( [
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	get_supplier_details
    
    , get_invoice_number
    
    , get_invoice_date
    
    , get_invoice_totals
    
    , get_invoice_lines

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_supplier_details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_supplier_details, [
%=======================================================================

    supplier_party(`UA Builders Corp.`)

    , sender_name(`UA Builders Corp.`)

    , supplier_postcode(`11106`)


] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_invoice_number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_number, [
%=======================================================================

    q(0,30,line)

    , generic_horizontal_details( [ [ `Application` , `No` , `:` ], 350, invoice_number, d, tab ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_invoice_date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_date, [
%=======================================================================

    q(0,30,line)

    , generic_horizontal_details( [ [ `period` , `to` , `:` ], 250, invoice_date, date ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_invoice_totals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_rule( get_invoice_totals, [
%=======================================================================

    q(0,50,line)

    , generic_horizontal_details( [ [ `AMOUNT`, `CERTIFIED`, `.`, `.`, `.`, `.`, `.`, `.`, `.`, `.`, `.`, `.`, `.`, `$` ], 200, total_net, d, newline ] )
    
    , check( total_net = TotNet)

    , generic_item( [ total_invoice , TotNet ] )

] ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INVOICE LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
i_section( get_invoice_lines, [
%=======================================================================

    line_header_line

    , qn0( [ peek_fails(line_end_line)

        , or( [

            [ line_invoice_line]

            , [ line ]

        ] )

    ] )

] ).

%=======================================================================
i_line_rule_cut( line_header_line, [
%=======================================================================

    read_ahead(`code`) , code_hook(w) , `Compliance` , `Costs`

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    `project` , `total`

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item_cut( [ line_item , s , check( line_item(end) < code_hook(start) ) ] )

    , generic_item_cut( [ line_descr_x , s1 , tab ] )


    , check( i_user_check( look_up_po_line_number, line_descr_x, InvDescr, PoLine ) )

    , generic_item( [ line_order_line_number , PoLine ] )

    , generic_item( [ line_descr , InvDescr ] )

    , generic_item_cut( [ line_scheduled_value , d , tab ] )

    , q0n(anything)

    , generic_item_cut( [ line_net_amount , d , newline  ] )

] ).


%=======================================================================
i_user_check( look_up_po_line_number, InvDescr, Descr , PoLine )
%-----------------------------------------------------------------------
:-
   strip_string2_from_string1( InvDescr, ` `, InvDescrNoSpace )
   
    , description_to_po_line( PoLine, Descr, InvDescrNoSpace )
.
%=======================================================================

description_to_po_line( `1` , `Building Permits`,`BuildingPermits` ).
description_to_po_line( `2` , `Temporary Utilities`,`TemporaryUtilities` ).
description_to_po_line( `3` , `Millwork`,`Millwork` ).
description_to_po_line( `4` , `Metal Doors and Frames`,`MetalDoorsandFrames` ).
description_to_po_line( `5` , `Door Hardware`,`DoorHardware` ).
description_to_po_line( `6` , `Plaster and Gypsum Board`,`PlasterandGypsumBoard` ).
description_to_po_line( `7` , `Tiling`,`Tiling` ).
description_to_po_line( `8` , `Wood Flooring`,`WoodFlooring` ).
description_to_po_line( `9` , `Carpeting`,`Carpeting` ).
description_to_po_line( `10` , `Painting and Coating`,`PaintingandCoating` ).
description_to_po_line( `11` , `Interior Signage`,`InteriorSignage` ).
description_to_po_line( `12` , `Toilet, Bath, and Laundry Accessories`,`Toilet,Bath,andLaundryAccessories` ).
description_to_po_line( `13` , `Commercial Equipment`,`CommercialEquipment` ).
description_to_po_line( `14` , `Fire Suppression`,`FireSuppression` ).
description_to_po_line( `15` , `Fire Extinguishers`,`FireExtinguishers` ).
description_to_po_line( `16` , `Plumbing`,`Plumbing` ).
description_to_po_line( `17` , `Plumbing Fixtures`,`PlumbingFixtures` ).
description_to_po_line( `18` , `Heating, Ventilating, and Air Conditioning (HVAC)`,`Heating,Ventilating,andAirConditioning(HVAC)` ).
description_to_po_line( `19` , `Electrical`,`Electrical` ).
description_to_po_line( `20` , `Window Blinds`,`WindowBlinds` ).
description_to_po_line( `21` , `Communications Backbone Cabling`,`CommunicationsBackboneCabling` ).
description_to_po_line( `22` , `Audio-Visual Equipment`,`Audio-VisualEquipment` ).
description_to_po_line( `23` , `Electronic Safety and Security`,`ElectronicSafetyandSecurity` ).
description_to_po_line( `24` , `Fire Detection and Alarm`,`FireDetectionandAlarm` ).
description_to_po_line( `25` , `Demolition`,`Demolition` ).
description_to_po_line( `26` , `VRF Mechanical System`,`VRFMechanicalSystem` ).
description_to_po_line( `27` , `Electrical`,`Electrical` ).
description_to_po_line( `28` , `Structural Cost associated with Terracato Slab`,`StructuralCostassociatedwithTerracatoSlab` ).
description_to_po_line( `29` , `Heating, Ventilating, and Air Conditioning (HVAC)`,`Heating,Ventilating,andAirConditioning(HVAC)` ).
description_to_po_line( `30` , `Fire Alarm Upgrade or New Install`,`FireAlarmUpgradeorNewInstall` ).
description_to_po_line( `31` , `Fire Proofing of Existing Slab, Columns or Beams`,`FireProofingofExistingSlab,ColumnsorBeams` ).
description_to_po_line( `32` , `Area refuge (Fire Rated Wall in order to increase occupancy)`,`Arearefuge(FireRatedWallinordertoincreaseoccupancy)` ).
description_to_po_line( `33` , `Plumbing`,`Plumbing` ).
description_to_po_line( `34` , `Concrete`,`Concrete` ).
description_to_po_line( `35` , `Convenient Staircase`,`ConvenientStaircase` ).
description_to_po_line( `36` , `General Conditions`,`GeneralConditions` ).
description_to_po_line( `37` , `Insurance Requirements`,`InsuranceRequirements` ).
description_to_po_line( `38` , `Fees`,`Fees` ).
description_to_po_line( `39` , `Final Cleaning`,`FinalCleaning` ).
description_to_po_line( `40` , `Millwork`,`Millwork` ).
description_to_po_line( `41` , `Plaster and Gypsum Board`,`PlasterandGypsumBoard` ).
description_to_po_line( `42` , `Plaster and Gypsum Board`,`PlasterandGypsumBoard` ).
description_to_po_line( `43` , `Electrical`,`Electrical` ).
description_to_po_line( `44` , `Communications Backbone Cabling`,`CommunicationsBackboneCabling` ).
description_to_po_line( `45` , `Demolition`,`Demolition` ).
description_to_po_line( `46` , `Demolition`,`Demolition` ).
description_to_po_line( `47` , `Demolition`,`Demolition` ).
description_to_po_line( `48` , `Fire Detection and Alarm`,`FireDetectionandAlarm` ).
description_to_po_line( `49` , `Applied Fireproofing`,`AppliedFireproofing` ).
description_to_po_line( `50` , `Plumbing`,`Plumbing` ).
description_to_po_line( `51` , `General Conditions`,`GeneralConditions` ).
description_to_po_line( `52` , `Heating, Ventilating, and Air Conditioning`,`Heating,Ventilating,andAirConditioning` ).
