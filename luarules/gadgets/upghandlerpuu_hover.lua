---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Per-unit Upgrade Handler - Hover",
        desc      = "Switches locomotor to a given type",
        author    = "MaDDoX",
        date      = "27 December 2020",
        license   = "GNU GPL, v2 or later",
        layer     = -50,
        enabled   = true,
    }
end

--- To add new hover classes, make sure there's a duplicate entry @ movedefs.lua with "hover" at its name's end (eg: TANK3HOVER)

if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")
VFS.Include("LuaRules/Configs/upgradedata_perunit.lua")
-----------------
---- SYNCED
-----------------

local spGetGameFrame = Spring.GetGameFrame
local spGetUnitTeam  = Spring.GetUnitTeam
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetUnitDefID = Spring.GetUnitDefID

local trackedUnits = {}     -- { unitID = true, ...} | who'll get the speed improved once upgrade done

local upgradableDefIDs = {} -- { UnitDefID = {}, ..} | Reverse table built in Initialize()
local upgData = {}          -- { [UnitDefNames["armstump"].id] = true, ... }

local updateRate = 5        -- How often to check for pending-research techs
--local reductionFactor = 0.7

local unitRulesCompletedParamName = "upgraded"

function gadget:Initialize()
    upgData = UnitUpgrades.hover
    upgradableDefIDs = upgData.upgradableDefIDs
end

local function ApplyHover(unitID)
    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
    local orgMoveDef = unitDef.moveDef and unitDef.moveDef.name or nil
    if orgMoveDef then
        Spring.MoveCtrl.SetMoveDef(unitID, string.lower(orgMoveDef).."hover")
        --NOTE: string moveDefName needs to be in lowercase, notwithstanding the fact that it may be in another case in the movedef table.
    end
end

-- Adds unit of interest to trackedUnits table
function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if upgradableDefIDs[unitDefID] then
        trackedUnits[unitID] = unitDefID
    end
end

-- Constantly poll to check if per-unit upgrade is done (processed by upgrade_perunit.lua)
local function Update()
    for unitID, unitDefID in pairs(trackedUnits) do
        if spGetUnitRulesParam(unitID, unitRulesCompletedParamName) == 1 then
            ApplyHover(unitID, unitDefID, false)
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
