--	facing:
--  0 - south
--  1 - east
--  2 - north
--  3 - west
-- randompopups[math_random(1,#randompopups)]

local UDN = UnitDefNames
local nameSuffix = '_scav'
local amb_chance_small = 0.3    -- Chance of one or more Ambushers spawning in small outposts
local amb_chance_mid = 0.5
local emp_chance = 0.25         -- Chance of one EMP Launcher spawn in mid/large outposts
local bertha_chance_small = 0.175
local bertha_chance_mid = 0.4
local rand = math.random

local function T1TinyOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 110
    --local r = math_random(0,3)
    if radiusCheck then
        return posradius
    else
        Spring.CreateUnit("armllt"..nameSuffix, posx+(90), posy, posz+(8), 2,GaiaTeamID)
        Spring.CreateUnit("armpad"..nameSuffix, posx+(-78), posy, posz+(-48), 2,GaiaTeamID)
        Spring.CreateUnit("armcir"..nameSuffix, posx+(-6), posy, posz+(72), 2,GaiaTeamID)
        Spring.CreateUnit("armpad"..nameSuffix, posx+(82), posy, posz+(64), 2,GaiaTeamID)
        Spring.CreateUnit("armllt"..nameSuffix, posx+(-70), posy, posz+(8), 2,GaiaTeamID)
        Spring.CreateUnit("armoutpost"..nameSuffix, posx+(2), posy, posz+(0), 2,GaiaTeamID)
    end
end

local function T1SmallOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 260
    --local r = math_random(0,3)
	if radiusCheck then
		return posradius
	else
    Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-209), posy, posz+(37), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-145), posy, posz+(-27), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-129), posy, posz+(37), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-17), posy, posz+(-203), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-161), posy, posz+(85), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-169), posy, posz+(45), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(15), posy, posz+(149), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(15), posy, posz+(213), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-129), posy, posz+(69), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(159), posy, posz+(-91), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(79), posy, posz+(133), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(207), posy, posz+(-59), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(159), posy, posz+(5), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(15), posy, posz+(181), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-177), posy, posz+(5), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(31), posy, posz+(-187), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-17), posy, posz+(181), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(95), posy, posz+(165), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(47), posy, posz+(133), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(127), posy, posz+(37), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(31), posy, posz+(-155), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(47), posy, posz+(213), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-209), posy, posz+(5), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(-41), posy, posz+(-163), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(127), posy, posz+(-27), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(95), posy, posz+(197), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-145), posy, posz+(5), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-209), posy, posz+(-27), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-49), posy, posz+(-203), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-177), posy, posz+(-27), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armllt_scav.id), {posx+(-1), posy, posz+(-155), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-17), posy, posz+(149), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(167), posy, posz+(-51), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(191), posy, posz+(-91), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(15), posy, posz+(-219), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(191), posy, posz+(37), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-1), posy, posz+(-123), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(159), posy, posz+(37), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-33), posy, posz+(-123), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-81), posy, posz+(-155), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-225), posy, posz+(69), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(31), posy, posz+(-123), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(7), posy, posz+(-3), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armrl_scav.id), {posx+(55), posy, posz+(173), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(127), posy, posz+(5), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-17), posy, posz+(213), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(127), posy, posz+(-75), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(207), posy, posz+(-27), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-65), posy, posz+(-123), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(191), posy, posz+(5), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-81), posy, posz+(-187), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdrag_scav.id), {posx+(-193), posy, posz+(85), 0}, {"shift"})
	end
end

local function T1MediumOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 400
    --local r = math_random(0,3)
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

--==##==--==##==--==##==--==##==--==##==--
-- T2 OUTPOSTS
--==##==--==##==--==##==--==##==--==##==--

local function T2TinyOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 110
    --local r = math_random(0,3)
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.corarad_scav.id), {posx+(7), posy, posz+(-78), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.coroutpost2_scav.id), {posx+(-10), posy, posz+(-6), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corrl_scav.id), {posx+(-33), posy, posz+(-70), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corpad_scav.id), {posx+(-81), posy, posz+(74), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corvipe_scav.id), {posx+(-1), posy, posz+(74), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corrl_scav.id), {posx+(47), posy, posz+(58), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corshred_scav.id), {posx+(79), posy, posz+(10), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corpad_scav.id), {posx+(79), posy, posz+(-54), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corshred_scav.id), {posx+(-81), posy, posz+(-6), 2}, {"shift"})
    end
end

local function T2SmallOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 270
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        if rnd < bertha_chance_small then
            Spring.GiveOrderToUnit(scav, -(UDN.armbrtha_scav.id), {posx+(77), posy, posz+(9), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armgate_scav.id), {posx+(-83), posy, posz+(9), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armhlt_scav.id), {posx+(-243), posy, posz+(-55), 2}, {"shift"})
        if rnd < amb_chance_small then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(125), posy, posz+(-103), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(13), posy, posz+(185), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(205), posy, posz+(-7), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-211), posy, posz+(-7), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armhlt_scav.id), {posx+(189), posy, posz+(-55), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armhlt_scav.id), {posx+(-211), posy, posz+(41), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-19), posy, posz+(-183), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armhlt_scav.id), {posx+(253), posy, posz+(9), 2}, {"shift"})
        if rnd < amb_chance_small then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(-115), posy, posz+(153), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(-115), posy, posz+(-119), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(141), posy, posz+(121), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost2_scav.id), {posx+(-2), posy, posz+(7), 0}, {"shift"})
    end
end

local function T2MediumOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 460
    local rnd = rand() or 0
    local rnd2 = rand() or 0
    if radiusCheck then
        return posradius
    else
        if rnd2 < emp_chance then
            Spring.GiveOrderToUnit(scav, -(UDN.armemp_scav.id), {posx+(19), posy, posz+(78), 2}, {"shift"})
        elseif rnd2 < (emp_chance * 2) then -- Chance of a Tactical Nuke Launcher being spawned == EMP Launcher
            Spring.GiveOrderToUnit(scav, -(UDN.cortron_scav.id), {posx+(19), posy, posz+(78), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-29), posy, posz+(-450), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(291), posy, posz+(-66), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-349), posy, posz+(14), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(35), posy, posz+(398), 2}, {"shift"})
        if rnd < bertha_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armbrtha_scav.id), {posx+(99), posy, posz+(-2), 2}, {"shift"})
        elseif rnd < (bertha_chance_mid * 2) then    -- Antinuke
            Spring.GiveOrderToUnit(scav, -(UDN.armamd_scav.id), {posx+(99), posy, posz+(-2), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(3), posy, posz+(-354), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-61), posy, posz+(-386), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(35), posy, posz+(-434), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(19), posy, posz+(350), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(347), posy, posz+(38), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armgate_scav.id), {posx+(-61), posy, posz+(-2), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(83), posy, posz+(-370), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(43), posy, posz+(-394), 2}, {"shift"})
        if rnd < amb_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(-285), posy, posz+(270), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(83), posy, posz+(382), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-445), posy, posz+(46), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(83), posy, posz+(414), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(3), posy, posz+(446), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-5), posy, posz+(406), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-181), posy, posz+(182), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(339), posy, posz+(-18), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-45), posy, posz+(382), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-397), posy, posz+(-50), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(51), posy, posz+(350), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(387), posy, posz+(62), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(291), posy, posz+(62), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(387), posy, posz+(-66), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-61), posy, posz+(-418), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(323), posy, posz+(78), 0}, {"shift"})
        if rnd < amb_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(275), posy, posz+(-322), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-349), posy, posz+(-18), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-133), posy, posz+(230), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-13), posy, posz+(-402), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(387), posy, posz+(30), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(355), posy, posz+(78), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-389), posy, posz+(-10), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(387), posy, posz+(-2), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-13), posy, posz+(366), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(3), posy, posz+(-450), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(35), posy, posz+(446), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfus_scav.id), {posx+(155), posy, posz+(-234), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-365), posy, posz+(-50), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-445), posy, posz+(14), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(83), posy, posz+(350), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-381), posy, posz+(78), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(291), posy, posz+(30), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-29), posy, posz+(446), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-349), posy, posz+(46), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(387), posy, posz+(-34), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(67), posy, posz+(446), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadvms_scav.id), {posx+(99), posy, posz+(-114), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-429), posy, posz+(-50), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-413), posy, posz+(78), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-133), posy, posz+(182), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(323), posy, posz+(-66), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-349), posy, posz+(78), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-397), posy, posz+(30), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(355), posy, posz+(-66), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-29), posy, posz+(-354), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(-93), posy, posz+(-130), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-61), posy, posz+(-450), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(83), posy, posz+(-402), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadves_scav.id), {posx+(-77), posy, posz+(110), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-61), posy, posz+(-354), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(291), posy, posz+(-2), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-45), posy, posz+(414), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(67), posy, posz+(-338), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-429), posy, posz+(-18), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(35), posy, posz+(-354), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(163), posy, posz+(110), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-181), posy, posz+(230), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost2_scav.id), {posx+(20), posy, posz+(-4), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(291), posy, posz+(-34), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(67), posy, posz+(-434), 2}, {"shift"})
    end
end

local function T3MediumOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 180
    local rnd = rand() or 0
    local rnd2 = rand() or 0
    if radiusCheck then
        return posradius
    else
        if rnd2 < emp_chance then
            Spring.GiveOrderToUnit(scav, -(UDN.armemp_scav.id), {posx+(21), posy, posz+(80), 2}, {"shift"})
        elseif rnd2 < (emp_chance * 2) then -- Chance of a Tactical Nuke Launcher being spawned == EMP Launcher
            Spring.GiveOrderToUnit(scav, -(UDN.cortron_scav.id), {posx+(21), posy, posz+(80), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(-64), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(16), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(37), posy, posz+(400), 2}, {"shift"})
        if rnd < bertha_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armbrtha_scav.id), {posx+(101), posy, posz+(0), 2}, {"shift"})
        else    -- Antinuke
            Spring.GiveOrderToUnit(scav, -(UDN.armamd_scav.id), {posx+(101), posy, posz+(0), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-384), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(-432), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(21), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(349), posy, posz+(40), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armgate_scav.id), {posx+(-59), posy, posz+(0), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(-368), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(45), posy, posz+(-392), 2}, {"shift"})
        if rnd < amb_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(-283), posy, posz+(272), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(384), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-443), posy, posz+(48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(416), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(285), posy, posz+(280), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-3), posy, posz+(408), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-179), posy, posz+(184), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(341), posy, posz+(-16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-43), posy, posz+(384), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-395), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(53), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(64), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-416), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corscreamer_scav.id), {posx+(-235), posy, posz+(-320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armanni_scav.id), {posx+(229), posy, posz+(320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(325), posy, posz+(80), 0}, {"shift"})
        if rnd < amb_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(277), posy, posz+(-320), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(-16), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-131), posy, posz+(232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-11), posy, posz+(-400), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost3_scav.id), {posx+(22), posy, posz+(-2), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(32), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-179), posy, posz+(-360), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(357), posy, posz+(80), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corscreamer_scav.id), {posx+(165), posy, posz+(320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-387), posy, posz+(-8), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(0), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-11), posy, posz+(368), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfus_scav.id), {posx+(157), posy, posz+(-232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-363), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-443), posy, posz+(16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-379), posy, posz+(80), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(32), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(-235), posy, posz+(-176), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(165), posy, posz+(208), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(48), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(-32), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armbrtha_scav.id), {posx+(5), posy, posz+(-112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadvms_scav.id), {posx+(101), posy, posz+(-112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-427), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-411), posy, posz+(80), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-131), posy, posz+(184), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(325), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(80), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armanni_scav.id), {posx+(-283), posy, posz+(-320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-395), posy, posz+(32), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(357), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(-400), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadves_scav.id), {posx+(-75), posy, posz+(112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(0), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-43), posy, posz+(416), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(-336), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-427), posy, posz+(-16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(-352), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-179), posy, posz+(232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(-432), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(-32), 3}, {"shift"})
    end
end

-- Has a LOL Cannon, and 2 Tactical Nuke Launchers
local function T3LargeOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 500
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        if rnd < emp_chance then
            Spring.GiveOrderToUnit(scav, -(UDN.armemp_scav.id), {posx+(21), posy, posz+(80), 2}, {"shift"})
        elseif rnd < (emp_chance * 2) then -- Chance of a Tactical Nuke Launcher being spawned == EMP Launcher
            Spring.GiveOrderToUnit(scav, -(UDN.cortron_scav.id), {posx+(21), posy, posz+(80), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armafus_scav.id), {posx+(157), posy, posz+(-232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armvulc_scav.id), {posx+(5), posy, posz+(-112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(-64), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(16), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(37), posy, posz+(400), 2}, {"shift"})
        if rnd < bertha_chance_mid then
            Spring.GiveOrderToUnit(scav, -(UDN.armbrtha_scav.id), {posx+(101), posy, posz+(0), 2}, {"shift"})
        else    -- Antinuke
            Spring.GiveOrderToUnit(scav, -(UDN.armamd_scav.id), {posx+(101), posy, posz+(0), 2}, {"shift"})
        end
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-384), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(-432), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(21), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(349), posy, posz+(40), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armgate_scav.id), {posx+(-59), posy, posz+(0), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(-368), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(45), posy, posz+(-392), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(-283), posy, posz+(272), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(384), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-443), posy, posz+(48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(416), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(285), posy, posz+(280), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-3), posy, posz+(408), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-179), posy, posz+(184), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(341), posy, posz+(-16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-43), posy, posz+(384), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-395), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(53), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(64), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortron_scav.id), {posx+(-198), posy, posz+(8), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortron_scav.id), {posx+(202), posy, posz+(-9), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-416), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corscreamer_scav.id), {posx+(-235), posy, posz+(-320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armanni_scav.id), {posx+(229), posy, posz+(320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(325), posy, posz+(80), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armamb_scav.id), {posx+(277), posy, posz+(-320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(-16), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-131), posy, posz+(232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-11), posy, posz+(-400), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(32), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-179), posy, posz+(-360), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(357), posy, posz+(80), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corscreamer_scav.id), {posx+(165), posy, posz+(320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armdeva_scav.id), {posx+(-387), posy, posz+(-8), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(0), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-11), posy, posz+(368), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(5), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-363), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-443), posy, posz+(16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(352), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-379), posy, posz+(80), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(32), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(-235), posy, posz+(-176), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armasp_scav.id), {posx+(165), posy, posz+(208), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost4_scav.id), {posx+(22), posy, posz+(-2), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(48), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(389), posy, posz+(-32), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadvms_scav.id), {posx+(101), posy, posz+(-112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-427), posy, posz+(-48), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-411), posy, posz+(80), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-131), posy, posz+(184), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(325), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-347), posy, posz+(80), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armanni_scav.id), {posx+(-283), posy, posz+(-320), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armcir_scav.id), {posx+(-395), posy, posz+(32), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(357), posy, posz+(-64), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-27), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-448), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(85), posy, posz+(-400), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armuwadves_scav.id), {posx+(-75), posy, posz+(112), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-59), posy, posz+(-352), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(0), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-43), posy, posz+(416), 3}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(-336), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(-427), posy, posz+(-16), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(37), posy, posz+(-352), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(69), posy, posz+(-432), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armawin_scav.id), {posx+(-179), posy, posz+(232), 2}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfort_scav.id), {posx+(293), posy, posz+(-32), 3}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT0, T1TinyOutpost)
table.insert(ScavengerConstructorBlueprintsT0, T1SmallOutpost)

table.insert(ScavengerConstructorBlueprintsT1, T1SmallOutpost)
table.insert(ScavengerConstructorBlueprintsT1, T1MediumOutpost)
table.insert(ScavengerConstructorBlueprintsT1, T1MediumOutpost)

table.insert(ScavengerConstructorBlueprintsT2, T2TinyOutpost)
table.insert(ScavengerConstructorBlueprintsT2, T2SmallOutpost)
table.insert(ScavengerConstructorBlueprintsT2, T2MediumOutpost)

table.insert(ScavengerConstructorBlueprintsT3, T2SmallOutpost)
table.insert(ScavengerConstructorBlueprintsT3, T3MediumOutpost)
table.insert(ScavengerConstructorBlueprintsT3, T3MediumOutpost)

table.insert(ScavengerConstructorBlueprintsT4, T3MediumOutpost)
table.insert(ScavengerConstructorBlueprintsT4, T3LargeOutpost)
table.insert(ScavengerConstructorBlueprintsT4, T3LargeOutpost)


-- Adds a random outpost to the T0 & T1 constructor blueprints
local function RandomOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 24
    --local randomturrets = {UDN.armamb_scav.id, UDN.armpb_scav.id, UDN.armanni_scav.id, UDN.armflak_scav.id, UDN.armmercury_scav.id, UDN.armbrtha_scav.id, UDN.armvulc_scav.id, UDN.armtarg_scav.id, UDN.armveil_scav.id, UDN.armgate_scav.id, UDN.cortoast_scav.id, UDN.corvipe_scav.id, UDN.cordoom_scav.id, UDN.corflak_scav.id, UDN.corscreamer_scav.id, UDN.corint_scav.id, UDN.corbuzz_scav.id, UDN.cortarg_scav.id, UDN.corshroud_scav.id, UDN.corgate_scav.id,}
    if radiusCheck then
        return posradius
    else
        local rnd = rand() or 0
        if rnd < 0.5 then
            Spring.GiveOrderToUnit(scav, -UDN.coroutpost_scav.id, {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
        else
            Spring.GiveOrderToUnit(scav, -UDN.armoutpost_scav.id, {posx+(math_random(-96,96)), posy, posz+(math_random(-96,96)), 0}, {"shift"})
        end
    end
end
table.insert(ScavengerConstructorBlueprintsT0, RandomOutpost)
table.insert(ScavengerConstructorBlueprintsT1, RandomOutpost)

--Add random wind generators to T0 & T1 constructor blueprints

local function Windfarm(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 96
    local rnd = rand() or 0

	if radiusCheck then
		return posradius
	else
		if rnd < 0.25 then
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(48), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(96), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-96), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-48), posy, posz+(-80), 1}, {"shift"})
		elseif rnd < 0.5 then
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(-96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(-96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(0), posy, posz+(96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(80), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.armwin_scav.id), {posx+(-80), posy, posz+(-96), 1}, {"shift"})
        elseif rnd < 0.75 then
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(48), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(-80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-96), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-48), posy, posz+(80), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(96), posy, posz+(-80), 1}, {"shift"})
		else    -- 0.75 ~ 1
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(-96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(-48), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(-96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(-80), posy, posz+(-96), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(0), posy, posz+(0), 1}, {"shift"})
			Spring.GiveOrderToUnit(scav, -(UDN.corwin_scav.id), {posx+(80), posy, posz+(96), 1}, {"shift"})
		end
	end
end
table.insert(ScavengerConstructorBlueprintsT0, Windfarm)
table.insert(ScavengerConstructorBlueprintsT1, Windfarm)

--==--==--==--==--==
-- NAVAL Blueprints
--==--==--==--==--==

-- by IceXuick
local function waterblocks(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local unitoptionsarm = { UDN.armfdrag_scav.id, UDN.armsonar_scav.id, }
    local unitoptionscore = { UDN.corfdrag_scav.id, UDN.corsonar_scav.id, }
    local posradius = 100
    local r = math_random(0,3)
    if radiusCheck then
        return posradius
    else
        if r == 0 then
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx-64, posy, posz-64, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx-32, posy, posz-32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx, posy, posz, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx+32, posy, posz+32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx+64, posy, posz+64, 0}, { "shift"})
        elseif r == 1 then
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx-64, posy, posz+64, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx-32, posy, posz+32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx, posy, posz, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx+32, posy, posz-32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionsarm[math_random(1,#unitoptionsarm)]), { posx+64, posy, posz-64, 0}, { "shift"})
        elseif r == 2 then
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx-64, posy, posz-64, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx-32, posy, posz-32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx, posy, posz, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx+32, posy, posz+32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx+64, posy, posz+64, 0}, { "shift"})
        else
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx-64, posy, posz+64, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx-32, posy, posz+32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx, posy, posz, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx+32, posy, posz-32, 0}, { "shift"})
            Spring.GiveOrderToUnit(scav, -(unitoptionscore[math_random(1,#unitoptionscore)]), { posx+64, posy, posz-64, 0}, { "shift"})
        end
    end
end

local function T0TinySeaOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 135
    --local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.armtl_scav.id), {posx+(-9), posy, posz+(-125), 1}, {"shift"})
        --Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-1), posy, posz+(-69), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(7), posy, posz+(3), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armtl_scav.id), {posx+(7), posy, posz+(131), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfrt_scav.id), {posx+(127), posy, posz+(-5), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfrt_scav.id), {posx+(-129), posy, posz+(-5), 1}, {"shift"})
        --Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-1), posy, posz+(75), 1}, {"shift"})
    end
end

local function T1SmallSeaOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 150
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.armtl_scav.id), {posx+(-9), posy, posz+(-125), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-1), posy, posz+(-69), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(7), posy, posz+(3), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armtl_scav.id), {posx+(7), posy, posz+(131), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfrt_scav.id), {posx+(127), posy, posz+(-5), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfrt_scav.id), {posx+(-129), posy, posz+(-5), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-1), posy, posz+(75), 1}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT0Sea,T0TinySeaOutpost)
table.insert(ScavengerConstructorBlueprintsT0Sea,waterblocks)

table.insert(ScavengerConstructorBlueprintsT0Sea,waterblocks)
table.insert(ScavengerConstructorBlueprintsT1Sea,T0TinySeaOutpost)
table.insert(ScavengerConstructorBlueprintsT1Sea,T1SmallSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT1Sea,T1SmallSeaOutpost)

local function T1MediumSeaOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 300
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(216), posy, posz+(18), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corpad_scav.id), {posx+(-72), posy, posz+(-14), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-8), posy, posz+(-286), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost_scav.id), {posx+(8), posy, posz+(2), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(8), posy, posz+(242), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(8), posy, posz+(290), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(64), posy, posz+(250), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfrad_scav.id), {posx+(8), posy, posz+(-62), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-296), posy, posz+(18), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-8), posy, posz+(-206), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corpad_scav.id), {posx+(88), posy, posz+(18), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(280), posy, posz+(18), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(-64), posy, posz+(-294), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-232), posy, posz+(18), 1}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT1Sea,T1MediumSeaOutpost)

local function T2MediumSeaOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 360
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-316), posy, posz+(284), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.coroutpost2_scav.id), {posx+(1), posy, posz+(-4), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-12), posy, posz+(-292), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(4), posy, posz+(284), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(156), posy, posz+(116), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-332), posy, posz+(-244), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-300), posy, posz+(12), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(276), posy, posz+(12), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corasp_scav.id), {posx+(124), posy, posz+(-92), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(340), posy, posz+(252), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(-164), posy, posz+(-140), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corasp_scav.id), {posx+(-100), posy, posz+(116), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(340), posy, posz+(-244), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfdrag_scav.id), {posx+(-4), posy, posz+(-60), 1}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT2Sea,T1MediumSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT2Sea,T2MediumSeaOutpost)

local function T3LargeSeaOutpost(scav, posx, posy, posz, GaiaTeamID, radiusCheck)
    local posradius = 420
    local rnd = rand() or 0
    if radiusCheck then
        return posradius
    else
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-319), posy, posz+(276), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-15), posy, posz+(-300), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(1), posy, posz+(276), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-343), posy, posz+(348), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(-375), posy, posz+(-308), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armoutpost3_scav.id), {posx+(-1), posy, posz+(-13), 0}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(393), posy, posz+(-292), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(153), posy, posz+(108), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfdrag_scav.id), {posx+(-215), posy, posz+(-164), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(-335), posy, posz+(-252), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(-303), posy, posz+(4), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfdrag_scav.id), {posx+(185), posy, posz+(172), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corfhlt_scav.id), {posx+(273), posy, posz+(4), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corasp_scav.id), {posx+(121), posy, posz+(-100), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(337), posy, posz+(244), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corsonar_scav.id), {posx+(-167), posy, posz+(-148), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.corasp_scav.id), {posx+(-103), posy, posz+(108), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.cortl_scav.id), {posx+(337), posy, posz+(-252), 1}, {"shift"})
        Spring.GiveOrderToUnit(scav, -(UDN.armfhlt_scav.id), {posx+(393), posy, posz+(300), 1}, {"shift"})
    end
end

table.insert(ScavengerConstructorBlueprintsT3Sea,T2MediumSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT3Sea,T2MediumSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT3Sea,T3LargeSeaOutpost)

table.insert(ScavengerConstructorBlueprintsT4Sea,T2MediumSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT4Sea,T3LargeSeaOutpost)
table.insert(ScavengerConstructorBlueprintsT4Sea,T3LargeSeaOutpost)

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
