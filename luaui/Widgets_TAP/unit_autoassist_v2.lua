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

local localDebug = false --true --|| Enables text and UI state debug messages

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitHealth   = Spring.GetUnitHealth
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetMyAllyTeamID     = Spring.GetMyAllyTeamID
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
local spGetFeatureResources = Spring.GetFeatureResources
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetFeaturesInCylinder = Spring.GetFeaturesInCylinder
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetCommandQueue = Spring.GetCommandQueue -- 0 => commandQueueSize, -1 = table
local spGetFullBuildQueue = Spring.GetFullBuildQueue --use this only for factories, to ignore rally points
local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition

local glGetViewSizes = gl.GetViewSizes
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix
local glColor		= gl.Color
local glText		= gl.Text
local glBillboard	= gl.Billboard
local glDepthTest        		= gl.DepthTest
local glAlphaTest        		= gl.AlphaTest
local glColor            		= gl.Color
local glTranslate        		= gl.Translate
local glBillboard        		= gl.Billboard
local glDrawFuncAtUnit   		= gl.DrawFuncAtUnit
local GL_GREATER     	 		= GL.GREATER
local GL_SRC_ALPHA				= GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA	= GL.ONE_MINUS_SRC_ALPHA
local glBlending          		= gl.Blending
local glScale          			= gl.Scale

local myTeamID, myAllyTeamID = -1, -1

local startupGracetime = 300        -- Widget won't work at all before those many frames (10s)
local updateRate = 15               -- Global update "tick rate"
local automationLatency = 60        -- Delay before automation kicks in, or the unit is set to idle
--local repurposeLatency = 160        -- Delay before checking if an automated unit should be doing something else
local deautomatedRecheckLatency = 30 -- Delay until a de-automated unit checks for automation again
local reclaimRadius = 20            -- Reclaim commands issued by code apparently only work with a radius (area-reclaim)

local automatableUnits = {} -- All units which can be automated // { [unitID] = true|false, ... }
local unitsToAutomate = {}  -- These will be automated, but aren't there yet (on latency); can be interrupted by direct orders
local automatedUnits = {}   -- All units currently automated    // { [unitID] = frameToRecheckAutomation, ... }
local deautomatedUnits = {} -- Post deautomation (direct order) // { [unitID] = frameToTryReautomation, ... }
        -- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }

local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period
local assistingUnits = {}    -- TODO: Commanders guarding factories, we use it to stop guarding when we're out of resources
--local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
--local internalCommandUIDs = {}
--local autoassistEnableDelay = 60

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

-- We use this to identify units that can't be build-assisted by basic builders
local WIPmobileUnits = {}     -- { unitID = true, ... }

--local mapsizehalfwidth = Game.mapSizeX/2
--local mapsizehalfheight = Game.mapSizeZ/2

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

----- Type Tables
local canreclaim = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canrepair = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canassist = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canresurrect = {
    armrectr = true, corvrad = true, cornecro = true,
}

-----

local function spEcho(string)
    --if localDebug and isCom(unitID) and state ~= "deautomated" then
    --if localDebug then Spring.Echo(string) end
end

local function isCom(unitID,unitDefID)
    if unitID and not unitDefID then
        unitDefID = spGetUnitDefID(unitID)
    end
    return UnitDefs[unitDefID] and UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.iscommander ~= nil
end

local function unitIsBeingBuilt(unitID)
    return select(5, spGetUnitHealth(unitID)) < 1
end

local function removeCommands(unitID)
    ---TODO: RemoveCommands is not working here..
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
end

local function stopAssisting(unitID)
    --deautomated (while guarding) => assisting || no chg state
    --assisting => deautomated || doesnt remove guard
    
    --if assistingUnits[unitID] then
        removeCommands(unitID)
        assistingUnits[unitID] = nil
    --end
end

local function setAutomateState(unitID, state, caller)
    if state == "deautomated" then --or state == "idle" then
        automatedUnits[unitID] = nil
        --- It'll only get out of deautomated if it's idle, that's only the delay to recheck idle
        if not deautomatedUnits[unitID] then
            deautomatedUnits[unitID] = spGetGameFrame() + deautomatedRecheckLatency end
        spEcho("To automate in: "..spGetGameFrame() + deautomatedRecheckLatency)
    else
        deautomatedUnits[unitID] = nil
        automatedUnits[unitID] = spGetGameFrame() + automationLatency
    end
    automatedState[unitID] = state
    spEcho("New automateState: "..state.." for: "..unitID.." set by function: "..caller)
end

local function hasCommandQueue(unitID)
    local commandQueue = spGetCommandQueue(unitID, 0)
    --spEcho("command queue size: "..(commandQueue or "N/A"))
    --Spring.Echo("command queue size: "..(commandQueue or "N/A"))
    if commandQueue then
        return commandQueue > 0
    else
        return false
    end
end

----- We use this to make sure patrol works, issuing two nearby patrol points
--local function patrolOffset (x, y, z)
--    local ofs = 50
--    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
--    z = (z > mapsizehalfheight) and z-ofs or z+ofs
--
--    return { x = x, y = y, z = z }
--end

--local function sqrDistance (pos1, pos2)
--    if not istable(pos1) or not istable(pos2) or not pos1.x or not pos1.z or not pos2.x or not pos2.z then
--        return 999999   -- keeping this huge so it won't affect valid nearest-distance calculations
--    end
--    return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
--end

local function hasBuildQueue(unitID)
    local buildqueue = spGetFullBuildQueue(unitID) -- => nil | buildOrders = { [1] = { [number unitDefID] = number count }, ... } }
    spEcho("build queue size: "..(buildqueue and #buildqueue or "N/A"))
    if buildqueue then
        return #buildqueue > 0
    else
        return false
    end
end

--- Spring's UnitIdle is just too weird, it fires up when units are transitioning between commands..
--function widget:UnitIdle(unitID, unitDefID, unitTeam)
local function customUnitIdle(unitID, delay)
    if not automatableUnits[unitID] then
        return end
    spEcho("Unit ".. unitID.." is idle.") --UnitDefs[unitDefID].name)
    --Spring.Echo("Unit ".. unitID.." is idle.") --UnitDefs[unitDefID].name)
    --if myTeamID == spGetUnitTeam(unitID) then --check if unit is mine
    ---If unit is on "assist" state and its guarded unit has no buildqueue, remove its guard command.
    if assistingUnits[unitID] then
        local assistedUnit = assistingUnits[unitID]
        if IsValidUnit(unitID) and IsValidUnit(assistedUnit) and not hasBuildQueue(assistedUnit) then
            --Spring.Echo("Removing guard")
            stopAssisting(unitID) --- We need to remove Guard commands, otherwise the unit will keep guarding
        end
    end

    setAutomateState(unitID, "deautomated", "customUnitIdle")
    --automatedState[unitID] = "idle"
    --automatedUnits[unitID] = nil
    --unitsToAutomate[unitID] = spGetGameFrame() + delay
    --spEcho("To automate in: "..spGetGameFrame() + delay)
    --end
end

local function DeautomateUnit(unitID)
    removeCommands(unitID)  -- removes Guard, Patrol, Fight and Repair commands

    --spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
    spEcho("Deautomating Unit: "..unitID)
    setAutomateState(unitID, "deautomated", "DeautomateUnit")
end

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
    -- We do this to re-initialize (after /luaui reload) properly
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        --local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitCreated(unitID, unitDefID) --, unitTeam)
        widget:UnitFinished(unitID, unitDefID) --, unitTeam)
    end
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- If unit just created is a mobile unit, add it to array
    local uDef = UnitDefs[unitDefID]
    if not uDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
    local unitDef = UnitDefs[unitDefID]
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        spEcho("Registering unit "..unitID.." as automatable: "..unitDef.name)--and isCom(unitID)
        automatableUnits[unitID] = true
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine
        local unitDef = UnitDefs[unitDefID]
        if not unitDef.isBuilding then
            WIPmobileUnits[unitID] = false
        end
        if canrepair[unitDef.name] or canresurrect[unitDef.name] then
            setAutomateState(unitID, "deautomated", "DeautomateUnit")
            --unitsToAutomate[unitID] = spGetGameFrame() + automationLatency --that's the frame it'll try automation
            --customUnitIdle(unitID)
        end
    end
end

function widget:UnitDestroyed(unitID)
    automatableUnits[unitID] = nil
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    deautomatedUnits[unitID] = nil
    automatedState[unitID] = nil
    assistingUnits[unitID] = nil
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

local enoughResourcesThreshold = 0.1 -- for 0.1, 'enough' is more than 10% storage

--- resourceType:: "e" (energy), "m" (metal), nil (must have enough of both types)
--- flood:: false/nil == "enough" resources; true = check for flooding resources (above 90%, or 1-enoughThreshold)
local function resourcesCheck(resourceType, flood)
    local thresholdToCheck = flood and (1 - enoughResourcesThreshold) or enoughResourcesThreshold
    local currentM, currentMstorage, currentE, currentEstorage
    if resourceType == "m" or resourceType == nil then
        currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
        if not isnumber(currentM) then
            return false end
    end
    if resourceType == "e" or resourceType == nil then
        currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
        if not isnumber(currentE) then
            return false end
    end
    if resourceType == nil then
        return currentM > (currentMstorage * thresholdToCheck) and currentE > (currentEstorage * thresholdToCheck)
    elseif resourceType == "m" then
        return currentM > (currentMstorage * thresholdToCheck)
    elseif resourceType == "e" then
        return currentE > (currentEstorage * thresholdToCheck)
    end
end

local function getNearest (originUID, targets, isFeature)
    local nearestSqrDistance = 999999
    local nearestItemID = targets[1]

    local ox,oy,oz = spGetUnitPosition(originUID)
    local origin = {x = ox, y = oy, z = oz}
    for targetID in pairs(targets) do
        local x,y,z
        if isFeature then
            x,y,z = spGetFeaturePosition(targetID)
        else
            x,y,z = spGetUnitPosition(targetID) end
        local target = { x = x, y = y, z = z }
        local thisSqrDist = sqrDistance(origin.x, origin.z, target.x, target.z)
        if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                and (thisSqrDist < nearestSqrDistance) then
            nearestItemID = targetID
            nearestSqrDistance = thisSqrDist
        end
    end
    return nearestItemID
end

-- typeCheck is a function (checking for true), if not defined it just returns the nearest unit
-- idCheck is a function (checking for true), checks the targetID to see if it fits a certain criteria
local function nearestItemAround(unitID, pos, unitDef, radius, typeCheck, idCheck, isFeature)
    local itemsAround = isFeature
            and spGetFeaturesInCylinder(pos.x, pos.z, radius)
            or spGetUnitsInCylinder(pos.x, pos.z, radius, myTeamID)
    if not istable(itemsAround) then
        return nil end
    local targets = {}
    --- Get list of valid targets
    for _,targetID in pairs(itemsAround) do
        if isFeature and spValidFeatureID(targetID) then
            local targetDefID = spGetFeatureDefID(targetID)
            local targetDef = (targetDefID ~= nil) and FeatureDefs[targetDefID] or nil
            --if targetDef and targetDef.isFactory then ==> eg.: function(x) return x.isFactory end
            if targetDef and (typeCheck == nil or typeCheck(targetDef))
                and (idCheck == nil or idCheck(targetID)) then
                targets[targetID] = true
            end
        elseif IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            if targetDef and (typeCheck == nil or typeCheck(targetDef))
                and (idCheck == nil or idCheck(targetID)) then
                targets[targetID] = true
            end
        end
    end
    return getNearest (unitID, targets, isFeature)
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
--- 3. If can assist, guard nearest factory
--- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 5. Reclaim nearest feature (prioritize metal)

local function automateCheck(unitID, unitDef, caller)
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    local _orderIssued = false
    local radius = unitDef.buildDistance * 1.8
    if unitDef.canFly then               -- Air units need that extra oomph
        radius = radius * 1.3
    end

    --- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
    local hasWeapon = unitDef.weapons[1]
    if not hasWeapon
        and automatedState[unitID] ~= "enemy reclaim" then
        --spEcho("[1] Enemy-reclaim check")
        local nearestEnemy = spGetUnitNearestEnemy(unitID, radius, false) -- useLOS = false ; => nil | unitID
        if nearestEnemy and automatedState[unitID] ~= "enemy reclaim" then
            --spGiveOrderToUnit(unitID, CMD_RECLAIM, nearestEnemy, {"meta"} ) --shift
            local x,y,z = Spring.GetUnitPosition(nearestEnemy)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,40}, {"alt"})
            setAutomateState(unitID, "enemy reclaim", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 2. If can resurrect, resurrect nearest feature
    if canresurrect[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and resourcesCheck("e") then   -- must have enough "E" to ressurect stuff
        --spEcho("[2] Resurrect check")
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
        if nearestFeatureID and automatedState[unitID] ~= "ressurect" then
            local x,y,z = spGetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
            setAutomateState(unitID, "resurrect", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 3. If can assist (and has enough resources), guard nearest factory
    if canassist[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and automatedState[unitID] ~= "assist" and resourcesCheck() then
        --spEcho("[3] Factory-assist check")
        --TODO: If during 'automation' it's guarding a factory but factory stopped production, remove it
        local nearestFactoryUnitID = nearestItemAround(unitID, pos, unitDef, radius,
                function(x) return x.isFactory end,     --We're only interested in factories currently producing
                function(x) return hasBuildQueue(x) end)
        --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
        if nearestFactoryUnitID then
            spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryUnitID }, {} )
            assistingUnits[unitID] = nearestFactoryUnitID    -- guardedUnit
            setAutomateState(unitID, "assist", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
    if canrepair[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and automatedState[unitID] ~= "assist" and automatedState[unitID] ~= "repair"
            and resourcesCheck("e") then   -- must have enough "E" to repair stuff
        --spEcho("[4] Repair check")
        local nearestUnitID
        if canassist[unitID] then
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        --local isAllied = spGetUnitAllyTeam(unitID) == myAllyTeamID
                        local health,maxHealth = spGetUnitHealth(x)
                        return health < (maxHealth * 0.99) end)
        else
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        local health,maxHealth,_,_,done = spGetUnitHealth(x)
                        return done and health < (maxHealth * 0.99) end )
        end
        if nearestUnitID and automatedState[unitID] ~= "repair" then
            --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
            spGiveOrderToUnit(unitID, CMD_REPAIR, { nearestUnitID }, {} )
            setAutomateState(unitID, "repair", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 5. Reclaim nearest feature (TODO: prioritize metal)
    ------ TODO: A metal feature has metal amount > energy, similar logic for an "energy" feature
    if canreclaim[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and automatedState[unitID] ~= "assist" and automatedState[unitID] ~= "repair" and automatedState[unitID] ~= "reclaim"
            then
        --spEcho("[5] Reclaim check")
        if automatedState[unitID] ~= "reclaim" then
            -- First we'll check if there's a metal resource nearby and if we're not flooding metal, reclaim it
            local nearestMetalFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        local remainingMetal,_,remainingEnergy = spGetFeatureResources(x) --feature
                        return remainingMetal and remainingEnergy and remainingMetal > remainingEnergy end,
                    true)
            if nearestMetalFeatureID and not resourcesCheck("m",true) then
                local x,y,z = spGetFeaturePosition(nearestMetalFeatureID)
                spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                setAutomateState(unitID, "reclaim", caller.."> automateCheck")
                _orderIssued = true
            else
                -- If not, we'll check if there's an energy resource nearby and if we're not flooding energy, reclaim it
                local nearestEnergyFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                        nil,true)
                if nearestEnergyFeatureID and not resourcesCheck("e",true) then
                    local x,y,z = spGetFeaturePosition(nearestEnergyFeatureID)
                    spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                    setAutomateState(unitID, "reclaim", caller.."> automateCheck")
                    _orderIssued = true
                end
            end
        end
    end
    if _orderIssued then
        spEcho ("New order Issued")
        unitsToAutomate[unitID] = nil
    end
    return _orderIssued
end

function widget:CommandNotify(cmdID, params, options)
    -- spEcho("CommandID registered: "..(cmdID or "nil"))
    ---TODO: If guarding, interrupt what's doing, otherwise don't
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        if automatableUnits[unitID] and IsValidUnit(unitID) then
            if automatedState[unitID] ~= "deautomated" then -- if it's working, don't touch it
               --guardingUnits[unitID] then --options.shift and
                DeautomateUnit(unitID)
            end
            --deassistCheck(unitID) --- We need to remove Guard commands, otherwise the unit will keep guarding
        end
    end
end

local function isReallyAssisting(unitID)
    if not IsValidUnit(unitID) then
        return false end
    local assistedUnit = assistingUnits[unitID]
    if not assistedUnit or not IsValidUnit(assistedUnit)
        or not hasBuildQueue(assistedUnit) then
           return false end
    return true
end

local function isReallyIdle(unitID)
    local result = true
    -- commandqueue with guard => not idle
    if hasBuildQueue(unitID) then
        result = false end
    if hasCommandQueue(unitID) then
        --if isReallyAssisting(unitID) then
        result = false
        --end
    end
    --Spring.Echo("IsReallyIdle: "..tostring(result))
    return result
end

--- Frame-based Update
function widget:GameFrame(f)
    if f < startupGracetime or f % updateRate > 0.001 then
        return
    end

    spEcho("This frame: "..f.." deauto'ed unit #: "..(pairs_len(deautomatedUnits) or "nil").." toAutomate #: "..(pairs_len(unitsToAutomate) or "nil"))

    ----- Deautomated units check || Done by unitsToAutomate / idle above
    for unitID, recheckFrame in pairs(deautomatedUnits) do
        if IsValidUnit(unitID) and f >= recheckFrame then --and not unitsToAutomate[unitID] then
            spEcho("0")
            --Spring.Echo("0")
            if isReallyIdle(unitID) then
                stopAssisting(unitID)
                if automatedState[unitID] ~= "deautomated" then
                   customUnitIdle(unitID, 0)
                elseif not unitsToAutomate[unitID] then
                   unitsToAutomate[unitID] = spGetGameFrame() + deautomatedRecheckLatency
                end
                --if not hasBuildQueue(guardedUnit) then -- builders assisting *do* have a commandqueue (guard)
                --    deassistCheck(unitID) end --- We need to remove Guard commands, otherwise the unit will keep guarding
            else
                unitsToAutomate[unitID] = nil
            end
        end
    end

    -- Check if it's time to actually try to automate an unit (after idle or creation)
    --spEcho(pairs_len(unitsToAutomate).." unit(s) to automate")
    for unitID, automateFrame in pairs(unitsToAutomate) do
        if IsValidUnit(unitID) and f >= automateFrame then
            spEcho("1")
            --Spring.Echo("1")
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            --- We only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
            local orderIssued = automateCheck(unitID, unitDef, "unitsToAutomate")
            if not orderIssued and not automatedState[unitID] then
                --spEcho("1.5")
                --automatedState[unitID] = "scanning" -- While it doesn't find a chance to be automated, it'll be "automating"
                --unitsToAutomate[unitID] = spGetGameFrame() + automationLatency
                setAutomateState(unitID, "deautomated", "DeautomateUnit")
            end
        end
    end

    for unitID, recheckFrame in pairs(automatedUnits) do
        spEcho("2")
        --Spring.Echo("2")
        if IsValidUnit(unitID) and f >= recheckFrame then
            --- Checking for Idle (let's dodge spring's default idle, its event fires in unwanted situations)
            spEcho("[automated] Checking "..unitID.." for idle; automatedState: "..(automatedState[unitID] or "nil"))
            if isReallyIdle(unitID) then
                customUnitIdle(unitID, automationLatency)
            else
                automatedUnits[unitID] = spGetGameFrame() + automationLatency
            end

            ----- Rechecking if a repairing/building unit has better things to do (like assist or ressurect)
            if unitState ~= "deautomated" then
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]    --TODO: Optimization - cache this within automatableUnits
                spEcho("[automated] Rechecking automation of unitID: "..unitID)
                automateCheck(unitID, unitDef, "repurposeCheck")
            end
            --- We need to remove Guard commands, otherwise the unit will keep guarding
            if assistingUnits[unitID] and not isReallyAssisting(unitID) then
                stopAssisting(unitID) end
        end
    end
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end

local loadedFontSize = 32
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color			= gl.Color

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

function widget:DrawScreen()
    if not localDebug then
        return end
    local textSize = 22

    gl.PushMatrix()
    gl.Translate(50, 50, 0)
    gl.BeginText()
    for unitID, state in pairs(automatedState) do
        if spIsUnitInView(unitID) then
            --local sx, sy = 1000, 500
            local x, y, z = spGetUnitViewPosition(unitID)
            --            local x, y, z = spGetUnitPosition(unitID)
            local sx, sy, sz = Spring.WorldToScreenCoords(x, y, z)
            gl.Text(state, sx, sy, textSize, "ocd")
        end
    end
    gl.EndText()
    gl.PopMatrix()
end

--function widget:DrawScreen()
--    if not glDebugStates or Spring.IsGUIHidden() then
--        return end
--    local textSize = 14
--    gl.PushMatrix()
--    for unitID, state in pairs(automatedUnits) do
--        if spIsUnitInView(unitID) then
--            spEcho("unitid/state: "..unitID..", "..state)
--
--            --local x, y, z = spGetUnitViewPosition(unitID)
--            local x, y, z = spGetUnitPosition(unitID)
--            local sx, sy, sz = Spring.WorldToScreenCoords(x, y, z)
--            --glTranslate(50, 50, 0)
--            --glBillboard()
--            --font:SetOutlineColor(outlineColor)
--            --font:Print(state, sx, sy, loadedFontSize, "con")
--            --glText(state, 0, 0, 28, 'ocd')
--
--            SetColor(1.0, 1.0, 0.7, 1.0)
--            glText(""..(state or "nil"), sx, sy, textSize, "ocd")
--        end
--    end
--    gl.PopMatrix()
--end