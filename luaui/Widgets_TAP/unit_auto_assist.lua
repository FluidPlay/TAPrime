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
        name = "Auto Assist",
        desc = "Makes idle construction units and structures reclaim, repair nearby units and assist building",
        author = "MaDDoX",
        date = "Jul 27, 2019",
        license = "FAIB (Free as in Beer)",
        layer = 2560,
        enabled = true,
    }
end

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitVelocity = Spring.GetUnitVelocity
local spGetCommandQueue = Spring.GetCommandQueue
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitTeam    = Spring.GetUnitTeam
local myTeamID = -1;
local updateRate = 7;

local mapsizehalfwidth = Game.mapSizeX/2
local mapsizehalfheight = Game.mapSizeZ/2

CMD_FIGHT = CMD.FIGHT
CMD_PATROL = CMD.PATROL
CMD_REPAIR = CMD.REPAIR
-- These guys will use a 'less aggressive' reclaim, favoring ressurects or assistance vs reclaiming
local farks = {
    armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}
local necros = {
    cornecro = true, armrectr = true,
}
local builders = {}
--local idleBuilders ={}

-- Disable widget if I'm spec
function widget:Initialize()
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
    myTeamID = Spring.GetMyTeamID()
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

local function AutoAssist(unitID, unitDef)
    local x, y, z = spGetUnitPosition(unitID)
    --Spring.Echo("unitDef.name: "..unitDef.name)
    if farks[unitDef.name] then
        Spring.Echo("Farking")
        --spGiveOrderToUnit(unitID, CMD_REPAIR, { x, y, z }, {}) --, {"alt"}
        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {}) --"alt" favors reclaiming
    elseif necros[unitDef.name] then
        Spring.Echo("Necroing")
        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, { "alt"})   --'alt' autoressurects if available
    else
        --local x, y, z = spGetUnitPosition(unitID)
        --if (not x or not y or not z) then
        --    return end
        --
        ---- keeps commands within map boundaries
        --x = (x > mapsizehalfwidth) and x-50 or x+50   -- x ? a : b, in lua notation
        --z = (z > mapsizehalfheight) and z-50 or z+50

        -- meta enables reclaim enemy units, alt autoresurrect ( if available )
        ---TODO: Outpost should take 'meta' (reclaim enemy units), commanders shouldn't
        -- TODO: Commanders have weapons, so 'fight' won't work here. Need to find nearest factory, if any, and guard it
        --spGiveOrderToUnit(unitID, CMD_PATROL, { x, y, z }, {} )
        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {"meta"} ) --shift and {"meta", "shift"} or
        Spring.Echo("Elsing")
    end
end

local function UnitNotMoving(unitID)
    local unitMoveSpeed = select(4, spGetUnitVelocity(unitID))
    return unitMoveSpeed < 0.01
end

local function UnitHasNoOrders(unitID)
    local buildQueueSize = spGetCommandQueue(unitID, 0) -- 0 => returns cmdqueuesize
    --Spring.Echo("Command queue size: "..buildQueueSize)
    return buildQueueSize == 0
end

--Give idle reclaimers the FIGHT command every 7 frames
function widget:GameFrame(n)
    if WG.Cutscene and WG.Cutscene.IsInCutscene() then
        return end

    if n % updateRate > 0.001 then
        return end

    for unitID in pairs(builders) do
        Spring.Echo("idle Builder unitID: "..unitID)
        local unitDef = UnitDefs[spGetUnitDefID(unitID)]
        if unitDef ~= nil then
            if UnitNotMoving(unitID) and UnitHasNoOrders(unitID) then
                AutoAssist(unitID, unitDef)
            end
        end
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine
        if UnitDefs[unitDefID].isFactory then
            return end
        --Spring.Echo("unitDef.name: "..UnitDefs[unitDefID].name.." can reclaim: "..tostring(UnitDefs[unitDefID]["canReclaim"]))
        if UnitDefs[unitDefID].canReclaim then
            builders[unitID] = true
            Spring.Echo("Registering unit "..unitID.." as builder "..UnitDefs[unitDefID].name)
        end
    end
end

-- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID)
    builders[unitID] = nil
end