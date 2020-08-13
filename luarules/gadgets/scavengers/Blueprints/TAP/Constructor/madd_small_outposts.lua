--	facing:
--  0 - south
--  1 - east
--  2 - north
--  3 - west
-- randompopups[math_random(1,#randompopups)]

local UDN = UnitDefNames
local nameSuffix = '_scav'

local function MaDDSmallOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
local posradius = 400
local r = math_random(0,3)
	if radiusCheck then
		return posradius
	else
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(101), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(53), posy, posz+(-275), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(93), posy, posz+(-235), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(-155), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armsolar_scav.id), {posx+(37), posy, posz+(-163), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(-171), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(21), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(261), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(61), posy, posz+(-235), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-131), posy, posz+(229), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armvp_scav.id), {posx+(-35), posy, posz+(173), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(101), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(165), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(-59), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-59), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(125), posy, posz+(-235), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armlab_scav.id), {posx+(-131), posy, posz+(-59), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(133), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(5), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(-187), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-155), posy, posz+(269), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-259), posy, posz+(133), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armestor_scav.id), {posx+(325), posy, posz+(93), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(-203), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(277), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(309), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armsolar_scav.id), {posx+(101), posy, posz+(205), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(341), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(181), posy, posz+(205), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(-315), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(61), posy, posz+(-347), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(13), posy, posz+(-267), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(301), posy, posz+(53), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-155), posy, posz+(-179), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(29), posy, posz+(-235), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(181), posy, posz+(269), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(301), posy, posz+(-27), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(341), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(77), posy, posz+(341), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(333), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(269), posy, posz+(53), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(253), posy, posz+(21), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(165), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(277), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-163), posy, posz+(229), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armtech1_scav.id), {posx+(141), posy, posz+(109), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(133), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(133), posy, posz+(29), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(269), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-259), posy, posz+(-91), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(309), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(101), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(157), posy, posz+(-267), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(197), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-147), posy, posz+(-139), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-131), posy, posz+(-219), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(109), posy, posz+(-267), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(333), posy, posz+(5), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(165), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-91), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(37), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(93), posy, posz+(-331), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(293), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armap_scav.id), {posx+(181), posy, posz+(-107), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-91), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(77), posy, posz+(309), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-59), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(125), posy, posz+(-331), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-179), posy, posz+(-139), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(333), posy, posz+(37), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(293), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-163), posy, posz+(-219), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(77), posy, posz+(277), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(157), posy, posz+(-299), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(245), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(13), posy, posz+(-299), 0}, {"shift"})
	end
end

local function MaDDMediumOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 400
    local r = math_random(0,3)
    if radiusCheck then
        return posradius
    else
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(101), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(53), posy, posz+(-275), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(93), posy, posz+(-235), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(-155), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armsolar_scav.id), {posx+(37), posy, posz+(-163), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(-171), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(21), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(261), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(61), posy, posz+(-235), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-131), posy, posz+(229), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armvp_scav.id), {posx+(-35), posy, posz+(173), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(101), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(165), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(-59), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-59), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(125), posy, posz+(-235), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armlab_scav.id), {posx+(-131), posy, posz+(-59), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(133), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(5), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(-187), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-155), posy, posz+(269), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-259), posy, posz+(133), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armestor_scav.id), {posx+(325), posy, posz+(93), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(-203), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(277), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-259), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(309), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armsolar_scav.id), {posx+(101), posy, posz+(205), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(341), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(181), posy, posz+(205), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(-315), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(61), posy, posz+(-347), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(13), posy, posz+(-267), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(301), posy, posz+(53), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-155), posy, posz+(-179), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(29), posy, posz+(-235), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(181), posy, posz+(269), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(301), posy, posz+(-27), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(45), posy, posz+(341), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(77), posy, posz+(341), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(333), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(269), posy, posz+(53), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(253), posy, posz+(21), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(165), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(277), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-163), posy, posz+(229), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armtech1_scav.id), {posx+(141), posy, posz+(109), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(133), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(133), posy, posz+(29), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(269), posy, posz+(-27), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-259), posy, posz+(-91), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(109), posy, posz+(309), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(101), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(157), posy, posz+(-267), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(197), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-147), posy, posz+(-139), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-131), posy, posz+(-219), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(109), posy, posz+(-267), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(333), posy, posz+(5), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(165), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-91), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(365), posy, posz+(37), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(93), posy, posz+(-331), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-115), posy, posz+(293), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armap_scav.id), {posx+(181), posy, posz+(-107), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-91), 2}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(77), posy, posz+(309), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-291), posy, posz+(-59), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(125), posy, posz+(-331), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-179), posy, posz+(-139), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(333), posy, posz+(37), 1}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(293), posy, posz+(13), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-163), posy, posz+(-219), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(77), posy, posz+(277), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(157), posy, posz+(-299), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-227), posy, posz+(-123), 3}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-195), posy, posz+(245), 0}, {"shift"})
		Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(13), posy, posz+(-299), 0}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT0, MaDDSmallOutpost)
table.insert(ScavengerConstructorBlueprintsT1, MaDDSmallOutpost)
table.insert(ScavengerConstructorBlueprintsT2, MaDDSmallOutpost)
table.insert(ScavengerConstructorBlueprintsT3, MaDDSmallOutpost)

table.insert(ScavengerConstructorBlueprintsT0, MaDDMediumOutpost)
table.insert(ScavengerConstructorBlueprintsT1, MaDDMediumOutpost)
table.insert(ScavengerConstructorBlueprintsT2, MaDDMediumOutpost)
table.insert(ScavengerConstructorBlueprintsT3, MaDDMediumOutpost)


--local function DamWindfarm1(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 96
--local r = math_random(0,3)
--	if radiusCheck then
--		return posradius
--	else
--		if r == 0 then
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(-80), 1}, {"shift"})
--		elseif r == 1 then
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(-96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(-96), 1}, {"shift"})
--		elseif r == 2 then
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(-80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(80), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(-80), 1}, {"shift"})
--		else
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(-48), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(-96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(-96), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
--			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(96), 1}, {"shift"})
--		end
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamWindfarm1)
--table.insert(ScavengerConstructorBlueprintsT1,DamWindfarm1)
--
--
--local function DamMinefield1(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 192
--	if radiusCheck then
--		return posradius
--	else
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-192,192)), posy, posz+(math_random(-192,192)), 0}, {"shift"})
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamMinefield1)
--table.insert(ScavengerConstructorBlueprintsT1,DamMinefield1)
--table.insert(ScavengerConstructorBlueprintsT2,DamMinefield1)
--table.insert(ScavengerConstructorBlueprintsT3,DamMinefield1)
--
--local function DamMinefield2(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 96
--	if radiusCheck then
--		return posradius
--	else
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamMinefield2)
--table.insert(ScavengerConstructorBlueprintsT1,DamMinefield2)
--table.insert(ScavengerConstructorBlueprintsT2,DamMinefield2)
--table.insert(ScavengerConstructorBlueprintsT3,DamMinefield2)
--
--local function DamMinefield3(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 384
--	if radiusCheck then
--		return posradius
--	else
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine1_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.armmine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -(UDN.cormine3_scav.id), {posx+(math_random(-384,384)), posy, posz+(math_random(-384,384)), 0}, {"shift"})
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamMinefield3)
--table.insert(ScavengerConstructorBlueprintsT1,DamMinefield3)
--table.insert(ScavengerConstructorBlueprintsT2,DamMinefield3)
--table.insert(ScavengerConstructorBlueprintsT3,DamMinefield3)
--
--local function DamRandomTurretfieldT1(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 96
--local randomturrets = {UDN.armllt_scav.id, UDN.armbeamer_scav.id, UDN.armhlt_scav.id, UDN.armguard_scav.id, UDN.armrl_scav.id, UDN.armcir_scav.id, UDN.armnanotc_scav.id, UDN.cormaw_scav.id, UDN.corllt_scav.id, UDN.corhllt_scav.id, UDN.corhlt_scav.id, UDN.corpun_scav.id, UDN.corrl_scav.id, UDN.cormadsam_scav.id, UDN.corerad_scav.id,} --UDN.armclaw_scav.id, UDN.armpacko_scav.id, , UDN.cornanotc_scav.id,
--	if radiusCheck then
--		return posradius
--	else
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamRandomTurretfieldT1)
--table.insert(ScavengerConstructorBlueprintsT1,DamRandomTurretfieldT1)
--
--local function DamRandomTurretfieldT2(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 96
--local randomturrets = {UDN.armamb_scav.id, UDN.armpb_scav.id, UDN.armanni_scav.id, UDN.armflak_scav.id, UDN.armmercury_scav.id, UDN.armbrtha_scav.id, UDN.armvulc_scav.id, UDN.armtarg_scav.id, UDN.armveil_scav.id, UDN.armgate_scav.id, UDN.cortoast_scav.id, UDN.corvipe_scav.id, UDN.cordoom_scav.id, UDN.corflak_scav.id, UDN.corscreamer_scav.id, UDN.corint_scav.id, UDN.corbuzz_scav.id, UDN.cortarg_scav.id, UDN.corshroud_scav.id, UDN.corgate_scav.id, UDN.corsilo_scav.id, UDN.armsilo_scav.id, UDN.cortron_scav.id, UDN.armemp_scav.id, UDN.corjuno_scav.id, UDN.armjuno_scav.id, }
--	if radiusCheck then
--		return posradius
--	else
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		Spring.GiveOrderToUnit(scav, -randomturrets[math_random(1,#randomturrets)], {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT2,DamRandomTurretfieldT2)
--table.insert(ScavengerConstructorBlueprintsT3,DamRandomTurretfieldT2)
--
--local function DamRandomNanoTower(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 24
----local randomturrets = {UDN.armamb_scav.id, UDN.armpb_scav.id, UDN.armanni_scav.id, UDN.armflak_scav.id, UDN.armmercury_scav.id, UDN.armbrtha_scav.id, UDN.armvulc_scav.id, UDN.armtarg_scav.id, UDN.armveil_scav.id, UDN.armgate_scav.id, UDN.cortoast_scav.id, UDN.corvipe_scav.id, UDN.cordoom_scav.id, UDN.corflak_scav.id, UDN.corscreamer_scav.id, UDN.corint_scav.id, UDN.corbuzz_scav.id, UDN.cortarg_scav.id, UDN.corshroud_scav.id, UDN.corgate_scav.id,}
--	if radiusCheck then
--		return posradius
--	else
--		local r = math_random(0,1)
--		if r == 0 then
--			Spring.GiveOrderToUnit(scav, -UDN.cornanotc_scav.id, {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		else
--			Spring.GiveOrderToUnit(scav, -UDN.armnanotc_scav.id, {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
--		end
--	end
--end
--table.insert(ScavengerConstructorBlueprintsT0,DamRandomNanoTower)
----table.insert(ScavengerConstructorBlueprintsT1,DamRandomNanoTower)
----table.insert(ScavengerConstructorBlueprintsT2,DamRandomNanoTower)
----table.insert(ScavengerConstructorBlueprintsT3,DamRandomNanoTower)
--
--local function DamIceRandomNanoTowerDuo(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 48
----local randomturrets = {UDN.armamb_scav.id, UDN.armpb_scav.id, UDN.armanni_scav.id, UDN.armflak_scav.id, UDN.armmercury_scav.id, UDN.armbrtha_scav.id, UDN.armvulc_scav.id, UDN.armtarg_scav.id, UDN.armveil_scav.id, UDN.armgate_scav.id, UDN.cortoast_scav.id, UDN.corvipe_scav.id, UDN.cordoom_scav.id, UDN.corflak_scav.id, UDN.corscreamer_scav.id, UDN.corint_scav.id, UDN.corbuzz_scav.id, UDN.cortarg_scav.id, UDN.corshroud_scav.id, UDN.corgate_scav.id,}
--	if radiusCheck then
--		return posradius
--	else
--		local r = math_random(0,1)
--		if r == 0 then
--			Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(24), posy, posz, 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(-24), posy, posz, 0}, {"shift"})
--		else
--			Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(24), posy, posz, 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(-24), posy, posz, 0}, {"shift"})
--		end
--	end
--end
----table.insert(ScavengerConstructorBlueprintsT0,DamIceRandomNanoTowerDuo)
--table.insert(ScavengerConstructorBlueprintsT1,DamIceRandomNanoTowerDuo)
--table.insert(ScavengerConstructorBlueprintsT2,DamIceRandomNanoTowerDuo)
----table.insert(ScavengerConstructorBlueprintsT3,DamIceRandomNanoTowerDuo)
--
--local function DamIceRandomNanoTowerQuad(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
--local posradius = 56
----local randomturrets = {UDN.armamb_scav.id, UDN.armpb_scav.id, UDN.armanni_scav.id, UDN.armflak_scav.id, UDN.armmercury_scav.id, UDN.armbrtha_scav.id, UDN.armvulc_scav.id, UDN.armtarg_scav.id, UDN.armveil_scav.id, UDN.armgate_scav.id, UDN.cortoast_scav.id, UDN.corvipe_scav.id, UDN.cordoom_scav.id, UDN.corflak_scav.id, UDN.corscreamer_scav.id, UDN.corint_scav.id, UDN.corbuzz_scav.id, UDN.cortarg_scav.id, UDN.corshroud_scav.id, UDN.corgate_scav.id,}
--	if radiusCheck then
--		return posradius
--	else
--		local r = math_random(0,1)
--		if r == 0 then
--			Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(24), posy, posz+(24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(-24), posy, posz+(24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(24), posy, posz+(-24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.armnanotc_scav.id), {posx+(-24), posy, posz+(-24), 0}, {"shift"})
--		else
--			Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(24), posy, posz+(24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(-24), posy, posz+(24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(24), posy, posz+(-24), 0}, {"shift"})
--	        Spring.GiveOrderToUnit(scav, -(UDN.cornanotc_scav.id), {posx+(-24), posy, posz+(-24), 0}, {"shift"})
--		end
--	end
--end
----table.insert(ScavengerConstructorBlueprintsT0,DamIceRandomNanoTowerQuad)
----table.insert(ScavengerConstructorBlueprintsT1,DamIceRandomNanoTowerQuad)
--table.insert(ScavengerConstructorBlueprintsT2,DamIceRandomNanoTowerQuad)
--table.insert(ScavengerConstructorBlueprintsT3,DamIceRandomNanoTowerQuad)
