-----------------------------------
-- Author: Johan Hanssen Seferidis
--
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal
--					 , repair nearby units and assist in building if they have the possibility.
--					 If you select the unit while it is being idle the widget is not going to take effect on the selected unit.
--
-------------------------------------------------------------------------------------

-- TODO: Rewrite this P-O-S like so:
--builders = {}
--farks = {}
--necros = {}
--trackedUnits = {}
--
--create / destroy <=> add, remove from trackedUnits
--
--update {
    --if not (every n seconds) then
    --return end
    --
    --for (unitID) in trackedUnits {
        --if UnitNotMoving(unitID) and UnitHasNoOrders(unitID) then
    --AutoAssist(unitID)
--end
--}
--}

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
local CMD_INSERT = CMD.INSERT

-- These guys will use a 'less aggressive' reclaim, favoring ressurects or assistance vs reclaiming
local farkDefs = {
    armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}
local necroDefs = {
    cornecro = true, armrectr = true,
}
local builders = {}
local idleBuilders = {}
local cancelAutoassistForUIDs = {} -- { frame = unitID }
local internalCommandUIDs = {}
local guardingUnits = {}    -- TODO: Commanders guarding factories, we('ll) use it to stop guarding when we're out of resources

function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine
        --if UnitDefs[unitDefID].isFactory then
        --    return end
        --Spring.Echo("unitDef.name: "..UnitDefs[unitDefID].name.." can reclaim: "..tostring(UnitDefs[unitDefID]["canReclaim"]))
        if UnitDefs[unitDefID].isBuilder then
            builders[unitID] = true
            Spring.Echo("Registering unit "..unitID.." as builder "..UnitDefs[unitDefID].name)
        end
    end
end

---- Disable widget if I'm spec
function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        widget:PlayerChanged()
    end
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

----Add reclaimer to the register
function widget:UnitIdle(unitID, unitDefID, unitTeam)
    if not builders[unitID] then
        return end
--	if myTeamID==getUnitTeam(unitID) then					--check if unit is mine
--		local factoryType = UnitDefs[unitDefID].isFactory	--***
--		if factoryType then
--            return end						--no factories ***
    --Spring.Echo("unitDef.name: "..UnitDefs[unitDefID].name.." is builder: "..tostring(UnitDefs[unitDefID]["isBuilder"]))
--        if UnitDefs[unitDefID]["canReclaim"] then		--check if unit can reclaim
    idleBuilders[unitID]=true					--add unit to register
            --Spring.Echo("<auto_reclaim_heal_assist>: registering unit "..unitID.." as idle "..UnitDefs[unitDefID].name)
--		end
--	end
end

function widget:CommandNotify(cmdID, cmdParams, cmdOpts)
    Spring.Echo("CmdID: "..cmdID)
    --if (cmdID == CMD_RECLAIM) then --and (cmdParams[1] == 0)
    --    --spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
    --    --Spring.Echo("Reclaim found")
    --end
    return false
end
--
--Unregister reclaimer once it is given a command
function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams)

	--echo("<auto_reclaim_heal_assist>: unit "..unitID.." got a command") --¤debug
	for builderID in pairs(idleBuilders) do
		if (builderID == unitID) then
            idleBuilders[builderID]=nil
			--Spring.Echo("<auto_reclaim_heal_assist>: unregistering unit ".. builderID .." as idle")
		end
	end
    if cmdID < 0 then
        local nearFuture = Spring.GetGameFrame()+10
        --cancelAutoassistForUIDs[nearFuture] = unitID
        cancelAutoassistForUIDs[unitID] = { frame = nearFuture, cmdID = cmdID, cmdOpts = cmdOpts, cmdParams = cmdParams }
        idleBuilders[unitID] = nil
    end
end
--
function widget:UnitDestroyed(unitID)
    idleBuilders[unitID] = nil
    builders[unitID] = nil
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

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

local function enoughEconomy()
    -- Validate for resources. If it's above 70% metal or energy, abort
    local currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
    local currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
    --if currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3 then
    --    Spring.Echo("Enough Eco!")
    --else
    --    Spring.Echo("NOPS eco!")
    --end
    return currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3
end

local function patrolOffset (x, y, z)
    local ofs = 50
    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
    z = (z > mapsizehalfheight) and z-ofs or z+ofs

    return { x = x, y = y, z = z }
end

local function nearestFactoryAround(unitID, pos, unitDef)
    local function sqrDistance (pos1, pos2)
        return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
    end
    --Spring.GetUnitsInSphere ( number x, number y, number z, number radius [,number teamID] )
    ---> nil | unitTable = { [1] = number unitID, etc... }

    local radius = unitDef.buildDistance
    --local sqrRadius = radius ^ 2 -- commander build range (squared, to ease calculation)
    local nearestSqrDistance = 999999
    local nearestUnitID = nil
    for _,targetID in pairs(spGetUnitsInSphere(pos.x, pos.y, pos.z, radius, myTeamID)) do
        local targetDefID = spGetUnitDefID(targetID)
        local targetDef = targetDefID and UnitDefs[targetDefID] or nil
        if targetDef and targetDef.isFactory then
            local x, y, z = spGetUnitPosition(unitID)
            local targetPos = { x = x, y = y, z = z }
            if sqrDistance(pos, targetPos) < nearestSqrDistance then
                nearestUnitID = targetID
                nearestSqrDistance = sqrDistance
            end
        end
    end
    return nearestUnitID
end

local function AutoAssist(unitID, unitDef)
    internalCommandUIDs[unitID] = true  -- Flag auto-assisting unit for further command event processing
    local x, y, z = spGetUnitPosition(unitID)

    if farkDefs[unitDef.name] then
        local offsetPos = patrolOffset(x, y, z)
        spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {}) --, {"meta", "shift"} )
        --spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {}) --"alt" favors reclaiming --Spring.Echo("Farking")
    elseif necroDefs[unitDef.name] then
        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, { "alt", "shift" })   --'alt' autoressurects if available --Spring.Echo("Necroing")
    else
        -- Commanders have weapons, thus 'fight' won't work here. Need to find nearest factory, if any, and guard it
        if unitDef.customParams and unitDef.customParams.iscommander then
            local unitPos = { x = x, y = y, z = z }
            local nearestFactoryAround = nearestFactoryAround(unitID, unitPos, unitDef)
            --Spring.Echo("Try Guard")
            if nearestFactoryAround and enoughEconomy() then
                spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryAround }, {} )
                guardingUnits[unitID] = true
            else
                local offsetPos = patrolOffset(x, y, z)
                spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {"meta"} ) --shift
            end
        else    -- Usually outposts down here. Since it's static, let's have it reclaim aggressively.
            spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {"meta", "shift"} ) --shift and {"meta", "shift"} or
        end
        --Spring.Echo("Else-ing")
    end
end

----Give idle builders an assist command every n frames
function widget:GameFrame(n)
    --cancelAutoassistForUIDs[unitID] = { frame = nearFuture, cmdID = cmdID, cmdOpts = cmdOpts, cmdParams = cmdParams }
    for unitID, data in pairs(cancelAutoassistForUIDs) do
        if data.frame >= n then
            Spring.Echo("Removing assist from ".. unitID)
            --spGiveOrderToUnit(uID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_RECLAIM, CMD_REPAIR}, {"alt"})
            --spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            --spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
            --spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
            --spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, CMD_STOP, CMD.OPT_SHIFT}, {"alt"}) --
            spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
            Spring.Echo("cmdID: "..data.cmdID.." opts: "..(unpack(data.cmdOpts) or "nil").." params: "..(unpack(data.cmdParams) or "nil"))
            --TODO: Fix
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, data.cmdID, (unpack(data.cmdOpts) or {}), (unpack(data.cmdParams) or {})} ,{"alt"})
            cancelAutoassistForUIDs[unitID] = nil
        end
    end

    --if WG.Cutscene and WG.Cutscene.IsInCutscene() then
    --    return end

    if n % updateRate > 0.001 then
        return end

    --TODO: Finish below
    if guardingUnits[unitID] and not enoughEconomy() then
        --Spring.Echo("Stopping auto-guard")
        spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )  --spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
        guardingUnits[unitID] = false
    end
    for unitID in pairs(idleBuilders) do
        Spring.Echo("idle Builder unitID: "..unitID)
        local unitDef = UnitDefs[spGetUnitDefID(unitID)]
        --if unitDef then
        --    if UnitNotMoving(unitID) and UnitHasNoOrders(unitID) then
        --        idleBuilders[unitID] = true
        AutoAssist(unitID, unitDef)
        --    end
        --end
    end
end
