---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Global Upgrade Handler - Button",
        desc      = "Enables a command button in a set of units, once a global upgrade is available",
        author    = "MaDDoX",
        date      = "21 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -100,
        enabled   = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")
VFS.Include("LuaRules/configs/upgradedata_global.lua")
-----------------
---- SYNCED
-----------------

local spGetGameFrame = Spring.GetGameFrame
local spGetUnitTeam  = Spring.GetUnitTeam

local trackedUnits = {}   -- { unitID = true, ...} | who'll get the button unlocked once upgrade done

local upgradableUnitDefs = {} -- { UnitDefID = {}, ..} | Reverse table built in Initialize()

local updateRate = 5      -- How often to check for pending-research techs

function gadget:Initialize()
    upgradableUnitDefs = {}     -- { unitDefID = { capture = true, scan = true, .. } }
    -- Build reverse table from GlobalUpgrades
    for upgID, upgData in pairs(GlobalUpgrades) do
        for upgradableDefIDs in pairs(upgData.upgradableDefIDs) do
            if upgradableUnitDefs[upgradableDefIDs] == nil then
                upgradableUnitDefs[upgradableDefIDs] = {}
            end
            upgradableUnitDefs[upgradableDefIDs][upgID] = true
        end
    end
end

-- Assures locked commands are disabled when a new unit is created and prereq is not already researched
function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local lockedUpgradeIds = upgradableUnitDefs[unitDefID]
    if not lockedUpgradeIds then
        return end
    for lockedUpgID in pairs(lockedUpgradeIds) do
        for upgID, upgData in pairs(GlobalUpgrades) do
            --Spring.Echo("Locked upgID: "..lockedUpgID.." upgID: "..upgID)
            if lockedUpgID == upgID and not HasTech(upgID, unitTeam) then
                BlockCmdID(unitID, upgData.buttonToUnlock, upgData.UpgradeCmdDesc.tooltip,
                        "Requires: "..upgID)
                trackedUnits[unitID] = unitDefID
            end
        end
    end
end

local function Update()
    --- Check for tracked Units, verify if any of their lockedCMDs is done and unlock it/them
    for unitID, unitDefID in pairs(trackedUnits) do
        local lockedUpgradeIds = upgradableUnitDefs[unitDefID] -- { unitDefID = { capture = true, scan = true, .. } }
        if lockedUpgradeIds then
            --Spring.Echo("# Locked UnitDefs: "..pairs_len(upgradeLockedUnitDefs))
            for lockedUpgID in pairs(lockedUpgradeIds) do
                for upgID, upgData in pairs(GlobalUpgrades) do
                    if lockedUpgID == upgID and HasTech(upgID, spGetUnitTeam(unitID)) then
                        UnblockCmdID(unitID, upgData.buttonToUnlock, upgData.UpgradeCmdDesc.tooltip )
                        trackedUnits[unitID] = nil
                    end
                end
            end
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
