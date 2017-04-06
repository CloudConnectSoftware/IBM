%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - WE WORK DEMO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( we_work_demo , `05/04/2017 14:58:49`).

i_op_param( output, From, To, Subject, c_xml ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_date_format( _ ).


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

    `no` , `.` , tab , `description`

] ).

%=======================================================================
i_line_rule_cut( line_end_line, [
%=======================================================================

    `project` , `total`

] ).

%=======================================================================
i_line_rule_cut( line_invoice_line, [
%=======================================================================

    generic_item_cut( [ line_item , s , check( line_item(end) < -430 ) ] )

    , generic_item_cut( [ line_descr , s1 , tab ] )

    , check( i_user_check( look_up_po_line_number, line_descr, PoLine ) )

    , generic_item( [ line_order_line_number , PoLine ] )

    , generic_item_cut( [ line_scheduled_value , d , tab ] )

    , q0n(anything)

    , generic_item_cut( [ line_net_amount , d , newline  ] )

] ).


%=======================================================================
i_user_check( look_up_po_line_number, InvDescr, PoLine )
%-----------------------------------------------------------------------
:-
    description_to_po_line( PoLine, InvDescr )
.
%=======================================================================

description_to_po_line( `1` , `Building Permits` ).
description_to_po_line( `2` , `Temporary Utilities` ).
description_to_po_line( `3` , `Millwork` ).
description_to_po_line( `4` , `Metal Doors and Frames` ).
description_to_po_line( `5` , `Door Hardware` ).
description_to_po_line( `6` , `Plaster and Gypsum Board` ).
description_to_po_line( `7` , `Tiling` ).
description_to_po_line( `8` , `Wood Flooring` ).
description_to_po_line( `9` , `Carpeting` ).
description_to_po_line( `10` , `Painting and Coating` ).
description_to_po_line( `11` , `Interior Signage` ).
description_to_po_line( `12` , `Toilet, Bath, and Laundry Accessories` ).
description_to_po_line( `13` , `Commercial Equipment` ).
description_to_po_line( `14` , `Fire Suppression` ).
description_to_po_line( `15` , `Fire Extinguishers` ).
description_to_po_line( `16` , `Plumbing` ).
description_to_po_line( `17` , `Plumbing Fixtures` ).
description_to_po_line( `18` , `Heating, Ventilating, and Air Conditioning (HVAC)` ).
description_to_po_line( `19` , `Electrical` ).
description_to_po_line( `20` , `Window Blinds` ).
description_to_po_line( `21` , `Communications Backbone Cabling` ).
description_to_po_line( `22` , `Audio-Visual Equipment` ).
description_to_po_line( `23` , `Electronic Safety and Security` ).
description_to_po_line( `24` , `Fire Detection and Alarm` ).
description_to_po_line( `25` , `Demolition` ).
description_to_po_line( `26` , `VRF Mechanical System` ).
description_to_po_line( `27` , `Electrical` ).
description_to_po_line( `28` , `Structural Cost associated with Terracato Slab` ).
description_to_po_line( `29` , `Heating, Ventilating, and Air Conditioning (HVAC)` ).
description_to_po_line( `30` , `Fire Alarm Upgrade or New Install` ).
description_to_po_line( `31` , `Fire Proofing of Existing Slab, Columns or Beams` ).
description_to_po_line( `32` , `Area refuge (Fire Rated Wall in order to increase occupancy)` ).
description_to_po_line( `33` , `Plumbing` ).
description_to_po_line( `34` , `Concrete` ).
description_to_po_line( `35` , `Convenient Staircase` ).
description_to_po_line( `36` , `General Conditions` ).
description_to_po_line( `37` , `Insurance Requirements` ).
description_to_po_line( `38` , `Fees` ).
description_to_po_line( `39` , `Final Cleaning` ).
description_to_po_line( `40` , `Millwork` ).
description_to_po_line( `41` , `Plaster and Gypsum Board` ).
description_to_po_line( `42` , `Plaster and Gypsum Board` ).
description_to_po_line( `43` , `Electrical` ).
description_to_po_line( `44` , `Communications Backbone Cabling` ).
description_to_po_line( `45` , `Demolition` ).
description_to_po_line( `46` , `Demolition` ).
description_to_po_line( `47` , `Demolition` ).
description_to_po_line( `48` , `Fire Detection and Alarm` ).
description_to_po_line( `49` , `Applied Fireproofing` ).
description_to_po_line( `50` , `Plumbing` ).
description_to_po_line( `51` , `General Conditions` ).
description_to_po_line( `52` , `Heating, Ventilating, and Air Conditioning` ).


