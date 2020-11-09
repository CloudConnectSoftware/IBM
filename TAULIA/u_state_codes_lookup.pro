%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAMATICA - U_STATE_CODES_LOOKUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_version( u_state_codes_lookup, `06/08/2020 15:15:03` ).

%-----------------------------------------------------------------------
% State Code Lookup
%-----------------------------------------------------------------------

%-------- USA codes --------

state_lookup( `ALABAMA`, `AL`, `US` ).
state_lookup( `ALASKA`, `AK`, `US` ).
state_lookup( `ARIZONA`, `AZ`, `US` ).
state_lookup( `ARKANSAS`, `AR`, `US` ).
state_lookup( `CALIFORNIA`, `CA`, `US` ).
state_lookup( `COLORADO`, `CO`, `US` ).
state_lookup( `CONNECTICUT`, `CT`, `US` ).
state_lookup( `DELAWARE`, `DE`, `US` ).
state_lookup( `FLORIDA`, `FL`, `US` ).
state_lookup( `GEORGIA`, `GA`, `US` ).
state_lookup( `HAWAII`, `HI`, `US` ).
state_lookup( `IDAHO`, `ID`, `US` ).
state_lookup( `ILLINOIS`, `IL`, `US` ).
state_lookup( `INDIANA`, `IN`, `US` ).
state_lookup( `IOWA`, `IA`, `US` ).
state_lookup( `KANSAS`, `KS`, `US` ).
state_lookup( `KENTUCKY`, `KY`, `US` ).
state_lookup( `LOUISIANA`, `LA`, `US` ).
state_lookup( `MAINE`, `ME`, `US` ).
state_lookup( `MARYLAND`, `MD`, `US` ).
state_lookup( `MASSACHUSETTS`, `MA`, `US` ).
state_lookup( `MICHIGAN`, `MI`, `US` ).
state_lookup( `MINNESOTA`, `MN`, `US` ).
state_lookup( `MISSISSIPPI`, `MS`, `US` ).
state_lookup( `MISSOURI`, `MO`, `US` ).
state_lookup( `MONTANA`, `MT`, `US` ).
state_lookup( `NEBRASKA`, `NE`, `US` ).
state_lookup( `NEVADA`, `NV`, `US` ).
state_lookup( `NEW HAMPSHIRE`, `NH`, `US` ).
state_lookup( `NEW JERSEY`, `NJ`, `US` ).
state_lookup( `NEW MEXICO`, `NM`, `US` ).
state_lookup( `NEW YORK`, `NY`, `US` ).
state_lookup( `NORTH CAROLINA`, `NC`, `US` ).
state_lookup( `NORTH DAKOTA`, `ND`, `US` ).
state_lookup( `OHIO`, `OH`, `US` ).
state_lookup( `OKLAHOMA`, `OK`, `US` ).
state_lookup( `OREGON`, `OR`, `US` ).
state_lookup( `PENNSYLVANIA`, `PA`, `US` ).
state_lookup( `RHODE ISLAND`, `RI`, `US` ).
state_lookup( `SOUTH CAROLINA`, `SC`, `US` ).
state_lookup( `SOUTH DAKOTA`, `SD`, `US` ).
state_lookup( `TENNESSEE`, `TN`, `US` ).
state_lookup( `TUSCALOOSA`, `AL`, `US` ).
state_lookup( `TEXAS`, `TX`, `US` ).
state_lookup( `UTAH`, `UT`, `US` ).
state_lookup( `VERMONT`, `VT`, `US` ).
state_lookup( `VIRGINIA`, `VA`, `US` ).
state_lookup( `WASHINGTON`, `WA`, `US` ).
state_lookup( `WEST VIRGINIA`, `WV`, `US` ).
state_lookup( `WISCONSIN`, `WI`, `US` ).
state_lookup( `WYOMING`, `WY`, `US` ).

%-------- Canada codes --------

state_lookup( `ALBERTA`, `AB`, `CA` ).
state_lookup( `BRITISH COLUMBIA`, `BC`, `CA` ).
state_lookup( `MANITOBA`, `MB`, `CA` ).
state_lookup( `NEW BRUNSWICK`, `NB`, `CA` ).
state_lookup( `NEWFOUNDLAND AND LABRADOR`, `NL`, `CA` ).
state_lookup( `NORTHWEST TERRITORIES`, `NT`, `CA` ).
state_lookup( `NOVA SCOTIA`, `NS`, `CA` ).
state_lookup( `NUNAVUT`, `NU`, `CA` ).
state_lookup( `ONTARIO`, `ON`, `CA` ).
state_lookup( `PRICE EDWARD ISLAND`, `PE`, `CA` ).
state_lookup( `QUEBEC`, `QC`, `CA` ).
state_lookup( `SASKATCHEWAN`, `SK`, `CA` ).
state_lookup( `YUKON`, `YT`, `CA` ).

% NOTE: before adding any state codes, ensure that all state codes are unique

%-------- Malaysia States --------

state_lookup( `PENANG`, `PEN`, `MY` ). % We can't apply any values as empty %
state_lookup( `PULAU PINANG`, `PEN`, `MY` ).
state_lookup( `BAYAN LEPAS`, `PEN`, `MY` ).

%-------- Australia States --------
% Australia has non-unique state codes so the use of the state code lookup is not appropriate
/*
state_lookup( `QUEENSLAND`, `QLD`, `AU` ).
state_lookup( `NEW SOUTH WALES`, `NSW`, `AU` ).
% state_lookup( `NORTHERN TERRITORY`, `NT`, `AU` ). % Not unique, shares with Canadian State %
state_lookup( `SOUTH AUSTRALIA`, `SA`, `AU` ).
state_lookup( `TASMANIA`, `TAS`, `AU` ).
state_lookup( `VICTORIA`, `VIC`, `AU` ).
%state_lookup( `WESTERN AUSTRALIA`, `WA`, `AU` ). % Not unique, shares with American State %
*/
