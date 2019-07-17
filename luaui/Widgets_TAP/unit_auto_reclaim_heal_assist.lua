-----------------------------------
-- Author: Johan Hanssen Seferidis
--
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal
--					 , repair nearby units and assist in building if they have the possibility.
--					 If you select the unit while it is being idle the widget is not going to take effect on the selected unit.
--
-------------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name = "Auto Reclaim/Heal/Assist",
		desc = "Makes idle unselected builders/rez/com/nanos to reclaim metal if metal bar is not full, repair nearby units and assist in building",
		author = "Pithikos",
		date = "Nov 21, 2010", --Nov 7, 2013
		license = "GPLv3",
		layer = 0,
		enabled = true,
	}
end

--------------------------------------------------------------------------------------
--local echo           = Spring.Echo
local getUnitPos     = Spring.GetUnitPosition
local orderUnit      = Spring.GiveOrderToUnit
local getUnitTeam    = Spring.GetUnitTeam
local isUnitSelected = Spring.IsUnitSelected
--local gameInSecs     = 0
--local lastOrderGivenInSecs= 0
local spGetUnitDefID = Spring.GetUnitDefID
local idleReclaimers={} --reclaimers because they all can reclaim
CMD_FIGHT = CMD.FIGHT
CMD_PATROL = CMD.PATROL
CMD_REPAIR = CMD.REPAIR
-- These guys will use a 'less aggressive' reclaim, favoring ressurects
local farks = {
    armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}
local necros = {
    cornecro = true, armrectr = true,
}


myTeamID=-1;
--------------------------------------------------------------------------------------


--Initializer
function widget:Initialize()
	--disable widget if I am a spec
	local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
	if spec then
		widgetHandler:RemoveWidget()
		return false
	end
	myTeamID = Spring.GetMyTeamID()                         --get my team ID
end


--Give reclaimers the FIGHT command every second
function widget:GameFrame(n)
	if not (n%30 < 0.001) then
        return end
    if WG.Cutscene and WG.Cutscene.IsInCutscene() then
        return end
    for unitID in pairs(idleReclaimers) do
        --Spring.Echo("unitID: "..unitID)
        if not isUnitSelected(unitID) then              --if unit is not selected
            local x, y, z = getUnitPos(unitID)                --get unit's position
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            if unitDef ~= nil then
                --Spring.Echo("unitDef.name: "..unitDef.name)
                if farks[unitDef.name] then
                   --Spring.Echo("Farking")
                   orderUnit(unitID, CMD_REPAIR, { x, y, z }, {}) --, {"alt"}
                elseif necros[unitDef.name] then
                   --Spring.Echo("Necroing")
                   orderUnit(unitID, CMD_FIGHT, { x, y, z }, {"alt"})   --'alt' autoressurects if available
                else
                   orderUnit(unitID, CMD_FIGHT, { x, y, z }, {})   --command unit to reclaim
                end
            end
        end
    end
end

--Add reclaimer to the register
function widget:UnitIdle(unitID, unitDefID, unitTeam)
	if myTeamID==getUnitTeam(unitID) then					--check if unit is mine
		local factoryType = UnitDefs[unitDefID].isFactory	--***
		if factoryType then
            return end						--no factories ***
        --Spring.Echo("unitDef.name: "..UnitDefs[unitDefID].name.." can reclaim: "..tostring(UnitDefs[unitDefID]["canReclaim"]))
        if UnitDefs[unitDefID]["canReclaim"] then		--check if unit can reclaim
            idleReclaimers[unitID]=true					--add unit to register
            --Spring.Echo("<auto_reclaim_heal_assist>: registering unit "..unitID.." as idle "..UnitDefs[unitDefID].name)
		end
	end
end

--Unregister reclaimer once it is given a command
function widget:UnitCommand(unitID)
	--echo("<auto_reclaim_heal_assist>: unit "..unitID.." got a command") --¤debug
	for reclaimerID in pairs(idleReclaimers) do
		if (reclaimerID == unitID) then
			idleReclaimers[reclaimerID]=nil
			--Spring.Echo("<auto_reclaim_heal_assist>: unregistering unit "..reclaimerID.." as idle")
		end
	end
end

function widget:UnitDestroyed(unitID)
    idleReclaimers[unitID] = nil
end
