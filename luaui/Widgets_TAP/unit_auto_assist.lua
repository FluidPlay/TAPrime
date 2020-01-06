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
        license = "GPLv3",
        layer = 0,
        enabled = false, --true,
    }
end

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitVelocity = Spring.GetUnitVelocity
local spGetCommandQueue = Spring.GetCommandQueue
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local myTeamID = -1;
local updateRate = 60;

local mapsizehalfwidth = Game.mapSizeX/2
local mapsizehalfheight = Game.mapSizeZ/2

local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_REPAIR = CMD.REPAIR
local CMD_GUARD = CMD.GUARD
local CMD_RECLAIM = CMD.RECLAIM
local CMD_REMOVE = CMD.REMOVE
local CMD_STOP = CMD.STOP

-- These guys will use a 'less aggressive' reclaim, favoring ressurects or assistance vs reclaiming
local farkDefs = {
    armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}
local necroDefs = {
    cornecro = true, armrectr = true,
}
local builders = {}
local idleBuilders = {}
local cancelReclaimForUIDs = {} -- { frame = unitID }
local internalCommandUIDs = {}
local guardingUnits = {}    -- TODO: Commanders guarding factories, we('ll) use it to stop guarding when we're out of resources

--function widget:CommandNotify(cmdID, cmdParams, cmdOpts)
--    Spring.Echo("CmdID: "..cmdID)
--    --if (cmdID == CMD_RECLAIM) then --and (cmdParams[1] == 0)
--    --    --spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
--    --    --Spring.Echo("Reclaim found")
--    --end
--    return false
--end

---- Disable widget if I'm spec
--function widget:Initialize()
--    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
--        widget:PlayerChanged()
--    end
--    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
--    if spec then
--        widgetHandler:RemoveWidget()
--        return false
--    end
--    myTeamID = Spring.GetMyTeamID()
--    local allUnits = spGetAllUnits()
--    for i = 1, #allUnits do
--        local unitID    = allUnits[i]
--        local unitDefID = spGetUnitDefID(unitID)
--        local unitTeam  = spGetUnitTeam(unitID)
--        widget:UnitFinished(unitID, unitDefID, unitTeam)
--    end
--end
--
--local function nearestFactoryAround(unitID, pos, unitDef)
--    local function sqrDistance (pos1, pos2)
--        return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
--    end
--    --Spring.GetUnitsInSphere ( number x, number y, number z, number radius [,number teamID] )
--    ---> nil | unitTable = { [1] = number unitID, etc... }
--
--    local radius = unitDef.buildDistance
--    --local sqrRadius = radius ^ 2 -- commander build range (squared, to ease calculation)
--    local nearestSqrDistance = 999999
--    local nearestUnitID = nil
--    for _,targetID in pairs(spGetUnitsInSphere(pos.x, pos.y, pos.z, radius, myTeamID)) do
--        local targetDefID = spGetUnitDefID(targetID)
--        local targetDef = targetDefID and UnitDefs[targetDefID] or nil
--        if targetDef and targetDef.isFactory then
--            local x, y, z = spGetUnitPosition(unitID)
--            local targetPos = { x = x, y = y, z = z }
--            if sqrDistance(pos, targetPos) < nearestSqrDistance then
--                nearestUnitID = targetID
--                nearestSqrDistance = sqrDistance
--            end
--        end
--    end
--    return nearestUnitID
--end
--
--local function enoughEconomy()
--    -- Validate for resources. If it's above 70% metal or energy, abort
--    local currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
--    local currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
--    --if currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3 then
--    --    Spring.Echo("Enough Eco!")
--    --else
--    --    Spring.Echo("NOPS eco!")
--    --end
--    return currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3
--end
--
--local function patrolOffset (x, y, z)
--    local ofs = 50
--    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
--    z = (z > mapsizehalfheight) and z-ofs or z+ofs
--
--    return { x = x, y = y, z = z }
--end
--
--local function AutoAssist(unitID, unitDef)
--    internalCommandUIDs[unitID] = true  -- Flag auto-assisting unit for further command event processing
--    local x, y, z = spGetUnitPosition(unitID)
--
--    if farkDefs[unitDef.name] then
--        local offsetPos = patrolOffset(x, y, z)
--        spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {}) --, {"meta", "shift"} )
--        --spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {}) --"alt" favors reclaiming --Spring.Echo("Farking")
--    elseif necroDefs[unitDef.name] then
--        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, { "alt", "shift" })   --'alt' autoressurects if available --Spring.Echo("Necroing")
--    else
--        -- Commanders have weapons, so 'fight' won't work here. Need to find nearest factory, if any, and guard it
--        if unitDef.customParams and unitDef.customParams.iscommander then
--            local unitPos = { x = x, y = y, z = z }
--            local nearestFactoryAround = nearestFactoryAround(unitID, unitPos, unitDef)
--            --Spring.Echo("Try Guard")
--            if nearestFactoryAround and enoughEconomy() then
--                spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryAround }, {} )
--                guardingUnits[unitID] = true
--            else
--                local offsetPos = patrolOffset(x, y, z)
--                spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {"meta"} ) --shift
--            end
--        else    -- Usually outposts down here. Since it's static, let's have it reclaim aggressively.
--            spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {"meta", "shift"} ) --shift and {"meta", "shift"} or
--        end
--        --Spring.Echo("Else-ing")
--    end
--end
--
--local function UnitNotMoving(unitID)
--    local unitMoveSpeed = select(4, spGetUnitVelocity(unitID))
--    --TODO: If it's an air builder, threshold should be much higher
--    return unitMoveSpeed < 0.01
--end
--
--local function UnitHasNoOrders(unitID)
--    local buildQueueSize = spGetCommandQueue(unitID, 0) -- 0 => returns cmdqueuesize
--    --Spring.Echo("Command queue size: "..buildQueueSize)
--    return buildQueueSize == 0
--end
--
----function widget:CommandNotify(cmdID, cmdParams, cmdOpts)
----    if (cmdID == CMD_RECLAIM) then --and (cmdParams[1] == 0)
----        --spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
----        --Spring.Echo("Reclaim found")
----    end
----end
--
----Give idle reclaimers the FIGHT command every 7 frames
----We'll implement our own "IDLE" logic, 'coz Spring's Idle also includes guard..
--function widget:GameFrame(n)
--    for frame, uID in pairs(cancelReclaimForUIDs) do
--        if frame >= n then
--            --Spring.Echo("Removing reclaim from "..uID)
--            spGiveOrderToUnit(uID, CMD_REMOVE, {CMD_RECLAIM}, {"alt"})
--            cancelReclaimForUIDs[frame] = nil
--        end
--    end
--
--    if WG.Cutscene and WG.Cutscene.IsInCutscene() then
--        return end
--
--    if n % updateRate > 0.001 then
--        return end
--
--    for unitID in pairs(builders) do
--        --Spring.Echo("idle Builder unitID: "..unitID)
--        if guardingUnits[unitID] and not enoughEconomy() then
--            --Spring.Echo("Stopping auto-guard")
--            spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )  --spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
--            guardingUnits[unitID] = false
--        else
--            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
--            if unitDef then
--                if UnitNotMoving(unitID) and UnitHasNoOrders(unitID) then
--                    idleBuilders[unitID] = true
--                    AutoAssist(unitID, unitDef)
--                end
--            end
--        end
--    end
--end
--
--function widget:UnitFinished(unitID, unitDefID, unitTeam)
--    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine
--        if UnitDefs[unitDefID].isFactory then
--            return end
--        --Spring.Echo("unitDef.name: "..UnitDefs[unitDefID].name.." can reclaim: "..tostring(UnitDefs[unitDefID]["canReclaim"]))
--        if UnitDefs[unitDefID].canReclaim then
--            builders[unitID] = true
--            --Spring.Echo("Registering unit "..unitID.." as builder "..UnitDefs[unitDefID].name)
--        end
--    end
--end
--
---- Initialize the unit when received (shared)
--function widget:UnitGiven(unitID, unitDefID, unitTeam)
--    widget:UnitFinished(unitID, unitDefID, unitTeam)
--end
--
--function widget:UnitDestroyed(unitID)
--    builders[unitID] = nil
--end
--
--function widget:PlayerChanged(playerID)
--    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
--        widgetHandler:RemoveWidget(self)
--    end
--end

--Patrol snippet:
------ keeps commands within map boundaries
----local x, y, z = spGetUnitPosition(unitID)
----if (not x or not y or not z) then
----    return end
----x = (x > mapsizehalfwidth) and x-50 or x+50   -- x ? a : b, in lua notation
----z = (z > mapsizehalfheight) and z-50 or z+50
----spGiveOrderToUnit(unitID, CMD_PATROL, { x, y, z }, {} )
--
-----TODO: Outpost should take 'meta' (reclaim enemy units), commanders shouldn't
---- meta enables reclaim enemy units, alt autoresurrect ( if available )


-- Fired after AllowCommand, but works in unsynced. We can intercept and prevent commands here
-- ATTENTION: at widget:UnitCommand() the queue isnt updated yet
--function widget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
--    if not unitID or teamID ~= myTeamID then
--        return end
--    if cmdID == CMD_RECLAIM then
--        Spring.Echo("Unit reclaim: "..unitID)
--    end
--    if idleBuilders[unitID] then
--        if cmdID == CMD_RECLAIM then
--            Spring.Echo("Auto-reclaim found")
--            -- If it's a feature or enemy unit allow auto-reclaim
--            local targetID = cmdParams[1]
--            --// If Params #2 or #5 don't exist, it's an invalid command or area-reclaim (ie., ignore)
--            if (not cmdParams[2]) or (cmdParams[5]) then
--                targetID = cmdParams[1]
--                local featureID = targetID - Game.maxUnits
--
--                if ((featureID >= 0) and Spring.ValidFeatureID(featureID)) or Spring.ValidUnitID(targetID) then
--                    Spring.Echo("Auto-reclaim validated")
--                    return
--                end
--                cancelReclaimForUIDs[Spring.GetGameFrame()+1] = unitID
--                Spring.Echo("Auto-reclaim cancelled")
--            end
--        else
--            -- If Command is from the player, remove from idleBuilders
--            if not internalCommandUIDs[unitID]  then
--                idleBuilders[unitID] = false
--            end
--        end
--    end
--    internalCommandUIDs[unitID] = nil -- internal assist-command was just processed
--end