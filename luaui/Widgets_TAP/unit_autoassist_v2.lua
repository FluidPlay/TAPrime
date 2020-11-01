---------------------------------------------------------------------------------------------------------------------
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal,
--	repair nearby units and assist in building if they have the possibility.
--	New: If you shift+drag a build order it will interrupt the current assist (from auto assist)
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "Auto Assist v2",
        desc = "Makes idle construction units and structures reclaim, repair nearby units and assist building",
        author = "MaDDoX, based on Johan Hanssen Seferidis' unit_auto_reclaim_heal_assist",
        date = "Oct 14, 2020",
        license = "GPLv3",
        layer = 0,
        enabled = true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitPosition = Spring.GetUnitPosition
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetUnitVelocity = Spring.GetUnitVelocity
local spGetCommandQueue = Spring.GetCommandQueue
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local idlingDelay = 5   -- How many frames after creation before the unit is force-idled (required to not break scripts)
local myTeamID = -1;
local updateRate = 40;

local basicBuilderAssistRadius = 250
-- We use this to identify units that can't be build-assisted by basic builders
local WIPmobileUnits = {}     -- { unitID = true, ... }
local unitsToAutomate = {}
local automatedUnits = {}

local mapsizehalfwidth = Game.mapSizeX/2
local mapsizehalfheight = Game.mapSizeZ/2

local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_REPAIR = CMD.REPAIR
local CMD_GUARD = CMD.GUARD
local CMD_RESURRECT = CMD.RESURRECT --125
local CMD_REMOVE = CMD.REMOVE
local CMD_RECLAIM = CMD.RECLAIM
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT

local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

----- Tables for 'canreclaim', 'canassist', canressurect, canrepair
local canreclaim = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canrepair = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canassist = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canresurrect = {
    armrectr = true, corvrad = true, cornecro = true,
}

-----

-- TODO: Remove, guys below are from the original implementation. To be replaced by "canreclaim", "canassist", etc

local basicbuilderDefs = {
    armck = true, corck = true, armca = true, corca = true, armcs = true, corcs = true,
}
-- These guys will use a 'less aggressive' reclaim, favoring ressurects or assistance vs reclaiming
local farkDefs = {
    armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}
local necroDefs = {
    cornecro = true, armrectr = true,
}
local builders = {}
local automatedUnits = {}
local assistStoppedUnits = {}
local cancelAutoassistForUIDs = {} -- { frame = unitID }
local internalCommandUIDs = {}
local guardingUnits = {}    -- TODO: Commanders guarding factories, we('ll) use it to stop guarding when we're out of resources
local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
local autoassistEnableDelay = 60

function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
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

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- If unit just created is a mobile unit, add it to array
    local uDef = UnitDefs[unitDefID]
    if not uDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine
        if UnitDefs[unitDefID].isBuilding == false then
            WIPmobileUnits[unitID] = false
        end
        if UnitDefs[unitDefID].isBuilder then
            builders[unitID] = true

            --Spring.Echo("Registering unit "..unitID.." as builder "..UnitDefs[unitDefID].name)
            widget:UnitIdle(unitID, unitDefID, unitTeam)
        end
    end
end

----Add builder to the register
function widget:UnitIdle(unitID, unitDefID, unitTeam)
    if not builders[unitID] then
        return end
    --Spring.Echo("Unit ".. unitID.." is idle.") --UnitDefs[unitDefID].name)
    if myTeamID == spGetUnitTeam(unitID) and not unitsToAutomate[unitID] then		--check if unit is mine
        unitsToAutomate[unitID] = spGetGameFrame() + idlingDelay
        assistStoppedUnits[unitID] = false
        --Spring.Echo("Re-enabling assist for ".. unitID) --..UnitDefs[unitDefID].name)
        cancelAutoassistForUIDs[unitID] = nil
    end
end

--Unregister reclaimer once it is given a command
function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams)

    --Spring.Echo("unit "..unitID.." got a command") --¤debug
    for builderID in pairs(automatedUnits) do
        if (builderID == unitID) then
            automatedUnits[builderID] = nil
            --Spring.Echo("unit ".. builderID .." is no longer idle")
        end
    end
    if cmdID < 0 then
        local nearFuture = spGetGameFrame() + orderRemovalDelay
        cancelAutoassistForUIDs[unitID] = { frame = nearFuture, cmdID = cmdID, cmdOpts = cmdOpts, cmdParams = cmdParams }
    end
end
--
function widget:UnitDestroyed(unitID)
    automatedUnits[unitID] = nil
    assistStoppedUnits[unitID] = nil
    builders[unitID] = nil
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

--TODO: Possible remove. If you don't have enough storage, that's your fault.
local function enoughEconomy()
    -- Validate for resources. If it's above 70% metal or energy, abort
    local currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
    local currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
    if not isnumber(currentM) or not isnumber(currentE) then
        return false end
    --if currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3 then
    --    Spring.Echo("Enough Eco!")
    --else
    --    Spring.Echo("NOPS eco!")
    --end
    return currentM > currentMstorage * 0.1 and currentE > currentEstorage * 0.1 --0.3
end

--- We use this to make sure patrol works, issuing two nearby patrol points
local function patrolOffset (x, y, z)
    local ofs = 50
    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
    z = (z > mapsizehalfheight) and z-ofs or z+ofs

    return { x = x, y = y, z = z }
end

local function sqrDistance (pos1, pos2)
    if not istable(pos1) or not istable(pos2) or not pos1.x or not pos1.z or not pos2.x or not pos2.z then
        return 999999   -- keeping this huge so it won't affect valid nearest-distance calculations
    end
    return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
end

-- typeCheck is a function (checking for true), if not defined it just returns the nearest unit
local function nearestItemAround(unitID, pos, unitDef, radius, typeCheck, getFeature)
    --local sqrRadius = radius ^ 2 -- commander build range (squared, to ease calculation)
    local nearestSqrDistance = 999999
    local nearestItemID, itemsAround = nil, nil
    if getFeature then
        itemsAround = spGetFeaturesInSphere(pos.x, pos.y, pos.z, radius, myTeamID)
    else
        itemsAround = spGetUnitsInSphere(pos.x, pos.y, pos.z, radius, myTeamID)
    end
    if not istable(itemsAround) then
        return nil
    end
    for _,targetID in pairs(itemsAround) do
        if getFeature and spValidFeatureID(targetID) then
            local targetDefID = spGetFeatureDefID(targetID)
            local targetDef = (targetDefID ~= nil) and FeatureDefs[targetDefID] or nil
            --if targetDef and targetDef.isFactory then ==> eg.: function(x) return x.isFactory end
            if targetDef and (typeCheck == nil or typeCheck(targetDef)) then
                local x, y, z = spGetFeaturePosition(targetID)
                local targetPos = { x = x, y = y, z = z }
                local thisSqrDist = sqrDistance(pos, targetPos)
                if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                   and thisSqrDist < nearestSqrDistance then
                        nearestItemID = targetID
                        nearestSqrDistance = sqrDistance
                        Spring.Echo("Assigned target feature: "..targetID)
                end
            end
        elseif IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            --if targetDef and targetDef.isFactory then ==> eg.: function(x) return x.isFactory end
            if targetDef and (typeCheck == nil or typeCheck(targetDef)) then
                local x, y, z = spGetUnitPosition(targetID)
                local targetPos = { x = x, y = y, z = z }
                local thisSqrDist = sqrDistance(pos, targetPos)
                if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                   and thisSqrDist < nearestSqrDistance then
                        nearestItemID = targetID
                        nearestSqrDistance = sqrDistance
                end
            end
        end
    end
    return nearestItemID
end

local function GetNearestValidTarget(unitID, unitDef)
    local pos = {}
    pos.x, pos.y, pos.z = spGetUnitPosition(unitID)
    local radius = unitDef.buildDistance * 1.2
    --local sqrRadius = radius ^ 2 -- builder build range, squared to speed up calculation
    local nearestSqrDistance = 999999
    local nearestUnitID = nil
    -- TODO: Support allied teams
    local unitsAround = spGetUnitsInCylinder(pos.x, pos.z, radius, myTeamID)
    if not istable(unitsAround) then
        return nil
    end
    for _,targetID in pairs(unitsAround) do
        if IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            if targetDef and not WIPmobileUnits[targetID] then --and not targetDef.isFactory
                local x, y, z = spGetUnitPosition(unitID)
                local targetPos = { x = x, y = y, z = z }
                local thisSqrDist = sqrDistance(pos, targetPos)
                if isnumber(thisSqrDist) and isnumber(nearestSqrDistance) then
                    if thisSqrDist < nearestSqrDistance then
                        nearestUnitID = targetID
                        nearestSqrDistance = sqrDistance
                    end
                end
            end
        end
    end
    return nearestUnitID
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
--- 3. If can assist, guard nearest factory
--- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 5. Reclaim nearest feature (prioritize metal)

local function assistSearch(pos, unitID, unitDef)
    local _orderIssued = false
    local radius = unitDef.buildDistance * 1.2

    --- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
    local hasWeapon = unitDef.weapons[1]
    if not hasWeapon then
        Spring.Echo("[1] Fast-reclaim check")
        local nearestEnemy = spGetUnitNearestEnemy(unitID, radius, false) -- useLOS = false ; => nil | unitID
        if nearestEnemy then
            spGiveOrderToUnit(unitID, CMD_RECLAIM, nearestEnemy, {"meta"} ) --shift
            _orderIssued = true
        end
    end
    --- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
    if canresurrect[unitDef.name] and not _orderIssued then
        Spring.Echo("[2] Resurrect check")
        --local nearestFeature = --TODO: WIP
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, true)
        if nearestFeatureID then
            spGiveOrderToUnit(unitID, CMD_RESURRECT, nearestFeatureID, {"meta"} )
            _orderIssued = true
        end --shift
    end
    --- 3. If can assist, guard nearest factory
    if canassist[unitDef.name] and not _orderIssued then
        Spring.Echo("[3] Factory-assist check")
        --TODO: Replace - Spring.GetUnitNearestAlly ( number unitID [, number range ] ) -> nil | number unitID
        local nearestFactoryUnitID = nearestItemAround(unitID, pos, unitDef, radius, function(x) return x.isFactory end)
        if nearestFactoryUnitID and enoughEconomy() then
            --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
            spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryUnitID }, {} )
            guardingUnits[unitID] = true
            _orderIssued = true
        end
    end
    --- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
    if canrepair[unitDef.name] and not _orderIssued then
        Spring.Echo("[4] Repair check")
        local nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil)
        if nearestUnitID then
            spGiveOrderToUnit(unitID, CMD_REPAIR, { nearestUnitID }, {} )
            _orderIssued = true
        end
    end
    --- 5. Reclaim nearest feature (prioritize metal)
    if canreclaim[unitDef.name] and not _orderIssued then
        Spring.Echo("[5] Reclaim check")
        --TODO: This seems to be wrong (furthest feature instead of closest)
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, true)
        if nearestFeatureID then
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, CMD_RECLAIM, CMD.OPT_INTERNAL+1, { nearestFeatureID }}, {"alt"})
            --Spring.GiveOrderToUnit(UnitID, CMD_INSERT, {cmdParams[1],cmdParams[2],cmdParams[3],cmdParams[4],y,cmdParams[6]}, cmdOptions.coded)
            --spGiveOrderToUnit(unitID,CMD_INSERT,{-1,CMD_CAPTURE,CMD_OPT_INTERNAL+1,unitID2},{"alt"});
            --Spring.GiveOrderToUnit(unitID,
            --        CMD.INSERT,
            --        {-1,CMD.RECLAIM,CMD.OPT_SHIFT,nearestFeatureID},
            --        {"alt"}
            --)
            --spGiveOrderToUnit(unitID, CMD_RECLAIM, { nearestFeatureID }, {"alt"} )
            local x,y,z = Spring.GetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
            _orderIssued = true
        else
            Spring.Echo("@autoassist: Nearest featureID not found")
        end --shift
    end
    if _orderIssued then
        Spring.Echo("@autoassist: Order issued")
        automatedUnits[unitID] = true
    end
end

local function AutoAssist(unitID, unitDef)
    local x, y, z = spGetUnitPosition(unitID)

    if basicbuilderDefs [unitDef.name] then
        local targetID = GetNearestValidTarget(unitID, unitDef)
        if targetID then
            --Spring.Echo("Nearest candidate found: "..targetID)
            spGiveOrderToUnit(unitID, CMD_REPAIR, {targetID}, {}) --, {"meta", "shift"} )
            automatedUnits[unitID] = true  -- Flag auto-assisting unit for further command event processing
        end
    elseif farkDefs[unitDef.name] then
        local offsetPos = patrolOffset(x, y, z)
        ---TODO: Convert to custom patrol; set to 'patrol' state; check every frame if it can assist > repair > reclaim something (regular builder)
        --- Or ressurect > repair > assist > reclaim (necro-type unit)
        ----- Add tables for 'canreclaim', 'canassist', canressurect, canrepair
        spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {}) --, {"meta", "shift"} )
        automatedUnits[unitID] = true  -- Flag auto-assisting unit for further command event processing
    elseif necroDefs[unitDef.name] then
        spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, { "alt", "shift" })   --'alt' autoressurects if available --Spring.Echo("Necroing")
        automatedUnits[unitID] = true  -- Flag auto-assisting unit for further command event processing
    else --- Is Commander
        -- TODO: To further test widget exploits, uncomment lines below:
        --local offsetPos = patrolOffset(x, y, z)
        --spGiveOrderToUnit(unitID, CMD_PATROL, { offsetPos.x, y, offsetPos.z }, {"meta"} ) --shift
        --spGiveOrderToUnit(unitID, CMD_REPAIR, { offsetPos.x, y, offsetPos.z, 160 }, {"meta"} ) --shift
        ---- Commanders have weapons, thus 'fight' won't work here. Need to find nearest factory, if any, and guard it
        if unitDef.customParams and unitDef.customParams.iscommander then
            local unitPos = { x = x, y = y, z = z }
            Spring.Echo("Commander auto-searching: "..unitID)
            assistSearch(unitPos, unitID, unitDef)
        --else    -- Usually outposts down here. Since it's static, let's have it reclaim aggressively.
        --    spGiveOrderToUnit(unitID, CMD_FIGHT, { x, y, z }, {"meta", "shift"} ) --shift and {"meta", "shift"} or
        end
    end
end

-- @Ivand: every frame mod 15 you should check builders queue (probably preselected set of builders who had guard/patrol command issued for them) and remove unwanted repair/reclaim etc from the front of the queue
-- or reimplement guard/partol kludges in Lua

----Give idle builders an assist command every n frames
function widget:GameFrame(f)
    for unitID, data in pairs(cancelAutoassistForUIDs) do
        -- Actual assist removal (a few frames after being issued)
        if IsValidUnit(unitID) and (not assistStoppedUnits[unitID]) and data.frame >= f then
            --Spring.Echo("Removing assist from ".. unitID)
            --spGiveOrderToUnit(uID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_RECLAIM, CMD_REPAIR}, {"alt"})
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, CMD_STOP, CMD.OPT_SHIFT}, {"alt"}) --
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
            automatedUnits[unitID] = nil
            assistStoppedUnits[unitID] = true
            --spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
        end
    end
    --if WG.Cutscene and WG.Cutscene.IsInCutscene() then
    --    return end

    if f % updateRate > 0.001 then
        return end

    for unitID, automateFrame in pairs(unitsToAutomate) do
        if f >= automateFrame and IsValidUnit(unitID)
            and not automatedUnits[unitID] and not assistStoppedUnits[unitID] then
            Spring.Echo("idle Builder unitID: "..unitID)
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            AutoAssist(unitID, unitDef)
            --if unitDef then
            --    if UnitNotMoving(unitID) and UnitHasNoOrders(unitID) then
            --        idleBuilders[unitID] = true
        end
    end
end