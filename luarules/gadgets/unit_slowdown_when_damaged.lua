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

local slowdownHealthThreshold = 0.3  -- 0.35

local turnrateReductionFactor = 0.75
local maxspeedReductionFactor = 0.7  -- 0.6

local updateCheckRate = 7

local function isVehicle(unitDefID)
    local unitDef = UnitDefs[unitDefID]
    return unitDef.customParams and unitDef.customParams.tedclass == "vehicle"
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if isVehicle(unitDefID) then
        trackedUnits[unitID] = { orgturnrate=UnitDefs[unitDefID].turnRate,
                                 orgspeed=UnitDefs[unitDefID].speed,
                                 orgreversespeed = UnitDefs[unitDefID].rSpeed, }
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    trackedUnits[unitID] = nil
    damagedUnits[unitID] = nil
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer)
    if trackedUnits[unitID] then
        local unitHealth, maxHealth, paralyzeDamage = spGetUnitHealth(unitID)
        if paralyzer or not unitHealth or not maxHealth then
            return nil end
        local relativeHealth = unitHealth / maxHealth
        if (relativeHealth < slowdownHealthThreshold) then
            damagedUnits[unitID] = { orgturnrate = trackedUnits[unitID].orgturnrate,
                                     orgspeed = trackedUnits[unitID].orgspeed,
                                     orgreversespeed = trackedUnits[unitID].orgreversespeed, }
            local moveTypeData = spGetUnitMoveTypeData(unitID)
            if moveTypeData.name == "ground" then
                local newMaxSpeed = maxspeedReductionFactor * trackedUnits[unitID].orgspeed
                local newRevSpeed = maxspeedReductionFactor * trackedUnits[unitID].orgreversespeed
                spSetGroundMoveTypeData(unitID, {
                    turnRate = turnrateReductionFactor * trackedUnits[unitID].orgturnrate,
                    maxSpeed = newMaxSpeed,
                    maxReverseSpeed = newRevSpeed,
                })
                -- Below will be read by unit_reverse_move
                spSetUnitRulesParam(unitID, "damagedSpeed", newMaxSpeed)
                spSetUnitRulesParam(unitID, "damagedrSpeed", newRevSpeed)
            end
        end
    end
end

function gadget:GameFrame(frame)
    if frame % updateCheckRate >= 0.0001 then
        return end
    --trackedUnits[unitID] = { orgturnrate=tr, orgspeed=ms }
    for unitID, moveData in pairs(damagedUnits) do
        local unitHealth, maxHealth = spGetUnitHealth(unitID)
        if unitHealth and maxHealth then
            local relativeHealth = unitHealth / maxHealth
            --Spring.Echo("rel health: "..relativeHealth)
            if (relativeHealth >= slowdownHealthThreshold) then
                spSetGroundMoveTypeData(unitID, {
                    turnRate = moveData.orgturnrate,
                    maxSpeed = moveData.orgspeed,
                    maxReverseSpeed = moveData.orgreversespeed,
                })
                --Spring.Echo("Max speed restored")
                spSetUnitRulesParam(unitID, "damagedSpeed", nil)
                spSetUnitRulesParam(unitID, "damagedrSpeed", nil)
                damagedUnits[unitID] = nil
            end
        end
    end
end