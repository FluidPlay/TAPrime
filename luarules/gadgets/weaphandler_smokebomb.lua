---
--- Created by Breno "MaDDoX" Azevedo.
---
if not gadgetHandler:IsSyncedCode() then
    return end

function gadget:GetInfo()
    return {
        name      = "Weapon Handler - Smoke Bomb",
        desc      = "Spawns smoke particle effects and reduce line of sight of units in its effect radius",
        author    = "MaDDoX",
        date      = "18 August 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true,
    }
end

-----------------
---- SYNCED
-----------------

VFS.Include("gamedata/taptools.lua")

local reductionFactor = 0.33    -- multiplier of the default line of sight
local effectDuration = 10 * 30  -- how long, in frames, effect will last. Multiply x 30 to use seconds
local effectDelay = 0.1 * 30    -- n seconds in frames
local EffectRadius = 320
local updateRate = 5

local trackedWeapons = {}
local explosions = {}
local affectedUnits = {}        -- { unitID = recoveryFrame }

--local spCreateUnit = Spring.CreateUnit
--local spGetUnitTeam = Spring.GetUnitTeam
--local spSetUnitNoDraw = Spring.SetUnitNoDraw
--local spSetUnitStealth = Spring.SetUnitStealth
--local spSetUnitSonarStealth = Spring.SetUnitSonarStealth
--local spSetUnitBlocking = Spring.SetUnitBlocking
--local spSetUnitNeutral = Spring.SetUnitNeutral
local spSetWatchWeapon = Script.SetWatchWeapon
local spGetGameFrame = Spring.GetGameFrame
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder

local marky_smokebomb = "armmark_smokebomb"
local slasher_smokebomb = "cormist_smokebomb"

function gadget:Initialize()
    --local METEOR_EXPLOSION = WeaponDefNames["meteorite_weapon"].id --Didn't work, not sure why.
    for _,def in pairs(WeaponDefs) do
        if def.name == marky_smokebomb or def.name == slasher_smokebomb then
            trackedWeapons[def.id] = true
            spSetWatchWeapon(def.id, true)
        end
    end
end

function gadget:Explosion(w, x, y, z, attackerID)
    if trackedWeapons[w] and attackerID then
        --local y2 = Spring.GetGroundHeight(x,z)+100
        table.insert(explosions, { effectTime = spGetGameFrame() + effectDelay, attackerID = attackerID, x=x, y=y, z=z})
        return true         --- Return TRUE to hide the weapon explosion CEG
    end
    return false
end

local function ApplyLosReduction(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    local uDef = UnitDefs[unitDefID]

    local originalLos = uDef.losRadius --sightdistance in unitDefs

    --Spring.Echo("Old LOS: "..originalLos..", New LOS: "..originalLos * reductionFactor)
    --- Effect will be actually applied by unit_los_scaler, where this and the height factors are calculated
    spSetUnitRulesParam(unitID, "losmodifier", reductionFactor or nil)
    affectedUnits[unitID] = spGetGameFrame() + effectDuration
    --Spring.Echo("Frame: "..spGetGameFrame()..", recovery Frame: "..spGetGameFrame() + effectDuration)
end

function gadget:GameFrame(f)
    if (f % updateRate > 0.001) then
        return end
    for i, data in pairs(explosions) do
        if data.effectTime >= f then
            local unitsAroundImpact = spGetUnitsInCylinder(data.x, data.z, EffectRadius)
            --Spring.Echo("Nearby units found: "..#unitsAroundImpact)
            for _,unitID in ipairs(unitsAroundImpact) do
                ApplyLosReduction(unitID)
            end
            table.remove(explosions, i)
        end
    end
    -- Remove the effect from recovered units
    for unitID, recoveryFrame in pairs(affectedUnits) do
        if f >= recoveryFrame then
            spSetUnitRulesParam(unitID, "losmodifier", nil)
        end
    end
end