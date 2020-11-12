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

---TODO: Allow debug messages only for the commanders
---Investigate bug of canceling a direct order, while the builder is assisting

VFS.Include("gamedata/taptools.lua")

local localDebug = true

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitHealth   = Spring.GetUnitHealth
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetMyAllyTeamID     = Spring.GetMyAllyTeamID
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
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

local idlingDelay = 10   -- How many frames after 'idle' the unit is actually considered idle (required to not break scripts)
local myTeamID, myAllyTeamID = -1, -1
local idleCheckUpdateRate = 40  -- How long it'll take for an idled unit to check things around it
local automatedRecheckRate = 60 -- How long it'll take for an automated unit to see if it shouldn't be doing something else
local basicBuilderAssistRadius = 250

local automatableUnits = {}
local guardingUnits = {}    -- TODO: Commanders guarding factories, we('ll) use it to stop guarding when we're out of resources
local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
local internalCommandUIDs = {}
local autoassistEnableDelay = 60

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

-- We use this to identify units that can't be build-assisted by basic builders
local WIPmobileUnits = {}     -- { unitID = true, ... }
local unitsToAutomate = {}
local automatedState = {}

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

local function isCom(unitID,unitDefID)
    if unitID and not unitDefID then
        unitDefID = spGetUnitDefID(unitID)
    end
    return UnitDefs[unitDefID] and UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.iscommander ~= nil
end

local function unitIsBeingBuilt(unitID)
    return select(5, spGetUnitHealth(unitID)) < 1
end

local function setAutomate(unitID, state, caller)
    if state == nil or state == "deautomated" then
        state = "deautomated" end
    if state ~= "assist" then       -- If unit is not assisting (guarding), remove it from the related table
        guardingUnits[unitID] = nil end
    automatedState[unitID] = state
    --unitsToAutomate[unitID] = nil
    if localDebug and isCom(unitID) then Spring.Echo("automating unit: "..unitID.." state: "..state.." from function: "..caller) end
end

local function hasCommandQueue(unitID)
    local commandQueue = spGetCommandQueue(unitID, 0)
    if isCom(unitID) then Spring.Echo("command queue size: "..(commandQueue or "N/A")) end
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

local function sqrDistance (pos1, pos2)
    if not istable(pos1) or not istable(pos2) or not pos1.x or not pos1.z or not pos2.x or not pos2.z then
        return 999999   -- keeping this huge so it won't affect valid nearest-distance calculations
    end
    return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
end

local function hasBuildQueue(unitID)
    local buildqueue = spGetFullBuildQueue(unitID) -- => nil | buildOrders = { [1] = { [number unitDefID] = number count }, ... } }
    --if isCom(unitID) then
        Spring.Echo("build queue size: "..(buildqueue and #buildqueue or "N/A")) --end
    if buildqueue then
        return #buildqueue > 0
    else
        return false
    end
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
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
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
    local unitDef = UnitDefs[unitDefID]
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
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
            if isCom(unitID) then Spring.Echo("Registering unit "..unitID.." as automatable: "..unitDef.name) end
            widget:UnitIdle(unitID, unitDefID, unitTeam)
        end
    end
end

----Add builder to the register
function widget:UnitIdle(unitID)
    -- If the unit has a build queue, it can't be set to idle - even if Spring says so.
    if not automatableUnits[unitID] then
        return end
    if (hasCommandQueue(unitID) and not guardingUnits[unitID]) or hasBuildQueue(unitID) then
        return end
    if isCom(unitID) then Spring.Echo("Unit ".. unitID.." is idle.") end --UnitDefs[unitDefID].name)
    if myTeamID == spGetUnitTeam(unitID) then -- and not unitsToAutomate[unitID] then		--check if unit is mine
        unitsToAutomate[unitID] = spGetGameFrame() + idlingDelay
    end
end

local function DeautomateUnit(unitID)
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})

    --spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
    if localDebug and isCom(unitID) then Spring.Echo("Deautomating Unit: "..unitID) end
    setAutomate(unitID, nil, "DeautomateUnit")
end

function widget:UnitDestroyed(unitID)
    unitsToAutomate[unitID] = nil
    automatedState[unitID] = nil
    automatableUnits[unitID] = nil
    guardingUnits[unitID] = nil
    --DeautomateUnit(unitID, "UnitDestroyed")
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

--TODO: Adapt to prevent reclaiming metal feature when it's capped on metal, or energy feature when capped on energy.
---A metal feature has metal amount > energy, similar logic for an "energy" feature
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

local function getNearest (sourceUID, targets, isFeature)
    local nearestSqrDistance = 999999
    local nearestItemID

    local ox,oy,oz = spGetUnitPosition(sourceUID)
    local origin = {x = ox, y = oy, z = oz}
    for targetID in pairs(targets) do
        local x,y,z
        if isFeature then
            x,y,z = spGetFeaturePosition(targetID)
        else
            x,y,z = spGetUnitPosition(targetID) end
        local target = { x = x, y = y, z = z }
        local thisSqrDist = sqrDistance(origin, target)
        if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                and (thisSqrDist < nearestSqrDistance) then
            nearestItemID = targetID
            nearestSqrDistance = sqrDistance
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

--local function GetNearestValidTarget(unitID, unitDef)
--    local pos = {}
--    pos.x, pos.y, pos.z = spGetUnitPosition(unitID)
--    local radius = unitDef.buildDistance * 1.2
--    --local sqrRadius = radius ^ 2 -- builder build range, squared to speed up calculation
--    local nearestSqrDistance = 999999
--    local nearestUnitID = nil
--    -- TODO: Support allied teams
--    local unitsAround = spGetUnitsInCylinder(pos.x, pos.z, radius, myTeamID)
--    if not istable(unitsAround) then
--        return nil
--    end
--    for _,targetID in pairs(unitsAround) do
--        if IsValidUnit(targetID) and targetID ~= unitID then
--            local targetDefID = spGetUnitDefID(targetID)
--            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
--            if targetDef and not WIPmobileUnits[targetID] then --and not targetDef.isFactory
--                local x, y, z = spGetUnitPosition(unitID)
--                local targetPos = { x = x, y = y, z = z }
--                local thisSqrDist = sqrDistance(pos, targetPos)
--                if isnumber(thisSqrDist) and isnumber(nearestSqrDistance) then
--                    if thisSqrDist < nearestSqrDistance then
--                        nearestUnitID = targetID
--                        nearestSqrDistance = sqrDistance
--                    end
--                end
--            end
--        end
--    end
--    return nearestUnitID
--end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
--- 3. If can assist, guard nearest factory
--- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 5. Reclaim nearest feature (prioritize metal)

local function automateCheck(unitID, unitDef, caller)
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    --Spring.Echo("Automatable auto-searching: "..unitID)
    local _orderIssued = false
    local radius = unitDef.buildDistance * 1.1

    --- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
    local hasWeapon = unitDef.weapons[1]
    if not hasWeapon
        and automatedState[unitID] ~= "enemy reclaim" then
        --if localDebug then Spring.Echo("[1] Enemy-reclaim check") end
        --TODO: Fix
        local nearestEnemy = spGetUnitNearestEnemy(unitID, radius, false) -- useLOS = false ; => nil | unitID
        if nearestEnemy and automatedState[unitID] ~= "enemy reclaim" then
            --spGiveOrderToUnit(unitID, CMD_RECLAIM, nearestEnemy, {"meta"} ) --shift
            local x,y,z = Spring.GetUnitPosition(nearestEnemy)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,40}, {"alt"})
            setAutomate(unitID, "enemy reclaim", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 2. If can resurrect, resurrect nearest feature (check for economy? might want to reclaim instead)
    if canresurrect[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect" then
        --if localDebug then Spring.Echo("[2] Resurrect check") end
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
        if nearestFeatureID and automatedState[unitID] ~= "ressurect" then
            local x,y,z = spGetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
            setAutomate(unitID, "resurrect", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 3. If can assist, guard nearest factory
    if canassist[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect" and automatedState[unitID] ~= "assist" then
        --if localDebug then Spring.Echo("[3] Factory-assist check") end
        --TODO: If during 'automation' it's guarding a factory but factory stopped production, remove it
        local nearestFactoryUnitID = nearestItemAround(unitID, pos, unitDef, radius,
                function(x) return x.isFactory end,     --We're only interested in factories currently producing
                function(x) return hasBuildQueue(x) end)
        if nearestFactoryUnitID and enoughEconomy() then
            --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
            spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryUnitID }, {} )
            guardingUnits[unitID] = nearestFactoryUnitID    -- guardedUnit
            setAutomate(unitID, "assist", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
    if canrepair[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and automatedState[unitID] ~= "assist" and automatedState[unitID] ~= "repair" then
        --if localDebug then Spring.Echo("[4] Repair check") end
        local nearestUnitID
        if canassist[unitID] then
            --TODO: Must check if the unit can assist or not (to assist building WIPmobileUnits)
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        --local isAllied = spGetUnitAllyTeam(unitID) == myAllyTeamID
                        local health,maxHealth = spGetUnitHealth(x)
                        return health < (maxHealth * 0.99) end) --isAllied and
        else
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        --local isAllied = spGetUnitAllyTeam(unitID) == myAllyTeamID
                        local health,maxHealth,_,_,done = spGetUnitHealth(x)
                        return done and health < (maxHealth * 0.99) end) --isAllied and
        end
        if nearestUnitID and automatedState[unitID] ~= "repair" then
            --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
            spGiveOrderToUnit(unitID, CMD_REPAIR, { nearestUnitID }, {} )
            setAutomate(unitID, "repair", caller.."> automateCheck")
            _orderIssued = true
        end
    end
    --- 5. Reclaim nearest feature (TODO: prioritize metal)
    if canreclaim[unitDef.name] and not _orderIssued
        and automatedState[unitID] ~= "enemy reclaim" and automatedState[unitID] ~= "ressurect"
            and automatedState[unitID] ~= "assist" and automatedState[unitID] ~= "repair" and automatedState[unitID] ~= "reclaim" then
        --if localDebug then Spring.Echo("[5] Reclaim check") end
        --TODO: This seems to be wrong (furthest feature instead of closest)
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
        if nearestFeatureID and automatedState[unitID] ~= "reclaim" then
            local x,y,z = Spring.GetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,40}, {"alt"})
            setAutomate(unitID, "reclaim", caller.."> automateCheck")
        end
    end
end

function widget:CommandNotify(cmdID, params, options)
    --Spring.Echo("CommandID registered: "..(cmdID or "nil"))
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        if automatableUnits[unitID] and IsValidUnit(unitID) and automatedState[unitID] ~= "deautomated" then -- if it's working, don't touch it
            DeautomateUnit(unitID)
        end
    end
end

-- @Ivand: every frame mod 15 you should check builders queue (probably preselected set of builders who had guard/patrol command issued for them) and remove unwanted repair/reclaim etc from the front of the queue
-- or reimplement guard/patrol kludges in Lua

----Give idle builders an assist command every n frames
function widget:GameFrame(f)
    --local commandQueueSize = spGetCommandQueue(unitID, 0) --use 20 to limit this

    if f % idleCheckUpdateRate < 0.001 then
        for unitID, automateFrame in pairs(unitsToAutomate) do
            if f >= automateFrame and IsValidUnit(unitID) --and automatedState[unitID]=="idle"
                then
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]
                --Spring.Echo("Trying to automate unitID: "..unitID)
                --- We only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
                automatedState[unitID] = "idle"
                automateCheck(unitID, unitDef, "idleCheckUpdateRate")
            end
        end
    end
    if f % automatedRecheckRate < 0.001 then
        for unitID in pairs(automatableUnits) do
            if localDebug and isCom(unitID) then
                Spring.Echo("Trying to recheck: "..unitID.."; automatedState: "..(automatedState[unitID] or "nil")
                            .." unitsToAutomate: "..(unitsToAutomate[unitID] or "nil"))
            end

            if IsValidUnit(unitID) and not unitIsBeingBuilt(unitID) and automatedState[unitID] ~= "deautomated" then -- then
                --and (unitsToAutomate[unitID] and unitsToAutomate[unitID] > f)
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]    --TODO: Cache this within automatedUnits
                if localDebug and isCom(unitID) then Spring.Echo("Rechecking automation of unitID: "..unitID) end
                automateCheck(unitID, unitDef, "automatedCheckRate")
            end
        end
        ---If unit is on "assist" state and its guarded unit has no buildqueue, set it to idle.

        for unitID, guardedUnit in pairs(guardingUnits) do
            if IsValidUnit(unitID) and IsValidUnit(guardedUnit) then
                if not hasBuildQueue(guardedUnit) then
                    widget:UnitIdle(unitID)
                end
            end
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
--            Spring.Echo("unitid/state: "..unitID..", "..state)
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