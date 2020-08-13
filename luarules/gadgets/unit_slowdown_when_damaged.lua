function gadget:GetInfo()
    return {
        name      = "Unit - Slowdown when damaged",
        desc      = "Vehicles max speed is reduced when they're damaged",
        author    = "MaDDoX",
        date      = "16 Jun 2019",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
    return
end

local spGetUnitMoveTypeData = Spring.GetUnitMoveTypeData
local spSetGroundMoveTypeData = Spring.MoveCtrl.SetGroundMoveTypeData
local spGetUnitHealth = Spring.GetUnitHealth
local spSetUnitRulesParam = Spring.SetUnitRulesParam

local trackedUnits = {} -- Ground vehicles
local damagedUnits = {}
local reallyDamagedUnits = {}

-- Units start slowing down when below slowdownMidHealthThreshold, applying the 'mid' factors
-- they slow down more when they drop below slowdownLowHealthThreshold, applying 'Low' factors

local slowdownMidHealthThreshold = 0.45  -- 0.35, 0.3
local slowdownLowHealthThreshold = 0.34

local turnrateMidReductionFactor = 0.8 -- 0.75
local maxspeedMidReductionFactor = 0.8  -- 0.6, 0.7

local turnrateLowReductionFactor = 0.6
local maxspeedLowReductionFactor = 0.7

local updateCheckRate = 7

local function isVehicle(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    return unitDef.customParams and unitDef.customParams.tedclass == "vehicle"
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if isVehicle(unitDefID) then
        trackedUnits[unitID] = { orgturnrate = UnitDefs[unitDefID].turnRate,
                                 orgspeed = UnitDefs[unitDefID].speed,
                                 orgreversespeed = UnitDefs[unitDefID].rSpeed, }
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    trackedUnits[unitID] = nil
    damagedUnits[unitID] = nil
    reallyDamagedUnits[unitID] = nil
end

local function ApplyNewSpeed(unitID, maxspeedReductionFactor, turnrateReductionFactor)
    local moveTypeData = spGetUnitMoveTypeData(unitID)
    if moveTypeData.name == "ground" then
        local newMaxSpeed = maxspeedReductionFactor * trackedUnits[unitID].orgspeed
        local newRevSpeed = maxspeedReductionFactor * trackedUnits[unitID].orgreversespeed
        spSetGroundMoveTypeData(unitID, {
            turnRate = turnrateReductionFactor * trackedUnits[unitID].orgturnrate,
            maxSpeed = newMaxSpeed,
            maxReverseSpeed = newRevSpeed,
        })
        -- Below will be read (and applied) by unit_reverse_move.
        --TODO: Make unit_reverse_move.lua "final speed setter"..
        spSetUnitRulesParam(unitID, "damagedSpeed", newMaxSpeed)
        spSetUnitRulesParam(unitID, "damagedrSpeed", newRevSpeed)
    end
end

local function AddToDamagedUnits(unitID)
    damagedUnits[unitID] = { orgturnrate = trackedUnits[unitID].orgturnrate,
                             orgspeed = trackedUnits[unitID].orgspeed,
                             orgreversespeed = trackedUnits[unitID].orgreversespeed, }
    ApplyNewSpeed(unitID, maxspeedLowReductionFactor, turnrateLowReductionFactor)
end

local function AddToReallyDamagedUnits(unitID)
    reallyDamagedUnits[unitID] = damagedUnits[unitID]
    ApplyNewSpeed(unitID, maxspeedLowReductionFactor, turnrateLowReductionFactor)
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer)
    if trackedUnits[unitID] then
        local unitHealth, maxHealth, paralyzeDamage = spGetUnitHealth(unitID)
        if paralyzer or not unitHealth or not maxHealth then
            return nil end
        local relativeHealth = unitHealth / maxHealth
        if (relativeHealth < slowdownMidHealthThreshold and not damagedUnits[unitID]) then
            AddToDamagedUnits(unitID)
        end
        if (relativeHealth < slowdownLowHealthThreshold and
                damagedUnits[unitID] and not reallyDamagedUnits[unitID]) then
            AddToReallyDamagedUnits(unitID)
        end
    end
end

local function RestoreDefaultSpeeds(unitID, moveData)
    spSetGroundMoveTypeData(unitID, {
        turnRate = moveData.orgturnrate,
        maxSpeed = moveData.orgspeed,
        maxReverseSpeed = moveData.orgreversespeed,
    })
    --Spring.Echo("Max speed restored")
    spSetUnitRulesParam(unitID, "damagedSpeed", nil)
    spSetUnitRulesParam(unitID, "damagedrSpeed", nil)
    damagedUnits[unitID] = nil
    reallyDamagedUnits[unitID] = nil    -- We do this here in case of some eventual instant healing ability
end

-- We'll check the health along time in case the vehicle is *healed*
function gadget:GameFrame(frame)
    if frame % updateCheckRate >= 0.0001 then
        return end
    --trackedUnits[unitID] = { orgturnrate=tr, orgspeed=ms }
    for unitID, moveData in pairs(damagedUnits) do
        local unitHealth, maxHealth = spGetUnitHealth(unitID)
        if unitHealth and maxHealth then
            local relativeHealth = unitHealth / maxHealth
            if (relativeHealth >= slowdownMidHealthThreshold) then
                RestoreDefaultSpeeds(unitID, moveData)
            elseif (relativeHealth >= slowdownLowHealthThreshold) then
                ApplyNewSpeed(unitID, maxspeedMidReductionFactor, turnrateMidReductionFactor)
                reallyDamagedUnits[unitID] = nil
            end
        end
    end
end