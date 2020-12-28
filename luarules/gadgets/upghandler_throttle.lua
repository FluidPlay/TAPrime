---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Global Upgrade Handler - Throttle",
        desc      = "Increases max speed on a set of units, once a global upgrade is available",
        author    = "MaDDoX",
        date      = "12 August 2020",
        license   = "GNU GPL, v2 or later",
        layer     = -50,
        enabled   = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")
VFS.Include("LuaRules/Configs/upgradedata_global.lua")
-----------------
---- SYNCED
-----------------

local spGetGameFrame = Spring.GetGameFrame
local spGetUnitTeam  = Spring.GetUnitTeam
local spSetUnitRulesParam = Spring.SetUnitRulesParam

local trackedUnits = {}     -- { unitID = true, ...} | who'll get the speed improved once upgrade done

local upgradableDefIDs = {} -- { UnitDefID = {}, ..} | Reverse table built in Initialize()
local upgData = {}          -- { [UnitDefNames["armstump"].id] = true, ... }

local updateRate = 5        -- How often to check for pending-research techs
local reductionFactor = 0.7

function gadget:Initialize()

    --throttle = {        upgradableDefIDs = { [UnitDefNames["armstump"].id] = true,
    --                                         [UnitDefNames["corraid"].id] = true,
    --                                         [UnitDefNames["armfav"].id] = true,
    --                                         [UnitDefNames["corlevlr"].id] = true,
    --                                         [UnitDefNames["armflash"].id] = true,
    --                                         [UnitDefNames["corgator"].id] = true,
    --},

    upgData = GlobalUpgrades.throttle
    upgradableDefIDs = upgData.upgradableDefIDs
end

local function ApplySlowDown(unitID, unitDefID, enable)
    --local defSpeed = UnitDefs[unitDefID].speed
    --local newSpeed = enable and (defSpeed * 0.6) or defSpeed
    --Spring.Echo("defSpeed: "..tostring(defSpeed).." new Speed: "..newSpeed)
    --Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed", newSpeed)

    --- SlowDown will be actually applied by unit_reverse_move, where this (and damaged) factor is used
    spSetUnitRulesParam(unitID, "throttleNerf", enable and reductionFactor or nil)
end

-- Applies negative effect when a new unit is created and prereq is not already researched
function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if upgradableDefIDs[unitDefID] and not HasTech(upgData.techToGrant, unitTeam) then
        --Spring.Echo("Tracking unit: "..UnitDefs[unitDefID].name)
        ApplySlowDown(unitID, unitDefID, true)
        trackedUnits[unitID] = unitDefID
    end
end

local function Update()
    --Check only for upgradeID == "TROTTLE" and improve speed (vs unitDef one) when found
    for unitID, unitDefID in pairs(trackedUnits) do
        if HasTech(upgData.techToGrant, spGetUnitTeam(unitID)) then
            ApplySlowDown(unitID, unitDefID, false)
            trackedUnits[unitID] = nil
        end
    end
end

function gadget:GameFrame()
    local frame = spGetGameFrame()
    if frame % updateRate > 0.001 then
        return end
    Update()
end

function gadget:UnitDestroyed(unitID)
    trackedUnits[unitID] = nil
end

function gadget:UnitGiven(unitID, unitDefID, teamID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
end
