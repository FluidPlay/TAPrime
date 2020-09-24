---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 23-Sep-20 6:41 PM
---

if not gadgetHandler:IsSyncedCode() then
    return end

-----------------
---- SYNCED
-----------------
--VFS.Include("gamedata/taptools.lua")

function gadget:GetInfo()
    return {
        name      = "Scavenger Unit Tweaks",
        desc      = "Applies unitdef changes to scavenger units after they're spawned",
        author    = "MaDDoX",
        date      = "23 Sep 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 50,
        enabled   = true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spSetUnitNeutral = Spring.SetUnitNeutral

local targetDefIDs = {
    [UnitDefNames["armcom_scav"].id] = true,
    [UnitDefNames["corcom_scav"].id] = true,
}

local destroyedScavBuilders = {}

local function isTarget(unitDefID)
    return targetDefIDs[unitDefID]
end

function gadget:Initialize()
    --for uDefID, uDef in pairs(UnitDefs) do
    --    if (isstring(uDefID) and istable(uDef)) then
    --        Spring.Echo("Searching for scav on "..uDefID)
    --        if string.find(uDefID, '_scav') then
    --            UnitDefs[uDefID].wreckName = uDefID.."_dead"
    --        end
    --    end
    --end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    if isTarget(unitDefID) then
        local x, y, z = Spring.GetUnitPosition(unitID)
        destroyedScavBuilders[unitID] = { x = x, y = y, z = z }
    end
end

function gadget:FeatureCreated(featureID, allyTeam)
    local x, y, z = Spring.GetFeaturePosition(featureID)

    --local featureDefID = Spring.GetFeatureDefID(featureID)
    ----local featureDef = FeatureDefs[featureDefID]
    --local name = FeatureDefs[featureDefID].name or "nil"
    --Spring.Echo("feat def name: "..name)
    for unitID, pos in pairs(destroyedScavBuilders) do
        if pos.x == x and pos.y == y and pos.z == z then
            Spring.SetFeatureResurrect( featureID, -1 ) -- cancels resurrection
            destroyedScavBuilders[unitID] = nil
        end
    end
end
