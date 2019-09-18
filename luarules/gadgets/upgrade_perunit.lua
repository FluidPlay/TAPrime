---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by MaDDo.
--- DateTime: 31-Jul-19 4:55 PM
---
function gadget:GetInfo()
    return {
        name 	= "Upgrade - Per Unit",
        desc	= "Enables per-unit upgrades",
        author	= "MaDDoX",
        date	= "Sept 24th 2019",
        license	= "GNU GPL, v2 or later",
        layer	= -1,
        enabled = true,
        -- TODO: Currently only supports blocking/unblocking command fire weapons
    }
end

--[[    Full Upgrading Structure:

GlobalUpgrades [made by techcenter]
	=> Multiple upgrades per unit
	=> Provide / may require a team tech
	=> "Consumed" by other gadgets (GUHandler)
		* Morph Speedup (unit_morph.lua)
		* Button-unlock (update from capture)

PerUnitUpgrades [made by unit]
	=> One upgrade per unit (max)
	=> May require a team tech
	=> PUU Handlers: <rely on the global PUUunits table>
		* Button-unlock
		* Healing Pulse (Aura, increases health)
		* Overclock Pulse (Aura, increases speed + firerate)
		* Motor Hack (Weapon - reduces speed by 40%)
		* Weapon Switcher (disables primary, enables secondary weapon)
]]

VFS.Include("gamedata/taptools.lua")

--local spGetUnitDefID        = Spring.GetUnitDefID
--local spInsertUnitCmdDesc   = Spring.InsertUnitCmdDesc
--local spEditUnitCmdDesc     = Spring.EditUnitCmdDesc
--local spMarkerAddPoint      = Spring.MarkerAddPoint
--local spMarkerErasePosition = Spring.MarkerErasePosition
--local spGetUnitPosition     = Spring.GetUnitPosition
local spGetAllUnits         = Spring.GetAllUnits
local spGetUnitDefID        = Spring.GetUnitDefID
local spFindUnitCmdDesc     = Spring.FindUnitCmdDesc
local spGetUnitCmdDescs     = Spring.GetUnitCmdDescs
local spGetUnitTeam         = Spring.GetUnitTeam
local spSetUnitRulesParam   = Spring.SetUnitRulesParam
local spGetGameFrame        = Spring.GetGameFrame
local spUseUnitResource     = Spring.UseUnitResource

local unitRulesParamName = "upgrade"
local oldFrame = 0

-- Per-unit upgrade settings (TODO: Move to a separate file for better organization)
local CMD_MANUALFIRE = CMD.MANUALFIRE
CMD.UPG_DGUN = 41999
CMD_UPG_DGUN = CMD.UPG_DGUN
CMD.UPG_GRENADE = 41998
CMD_UPG_GRENADE = CMD.UPG_GRENADE
CMD.UPG_FIRERAIN = 41997
CMD_UPG_FIRERAIN = CMD.UPG_FIRERAIN
CMD.UPG_FIRERAIN = 41996
CMD_UPG_BARRAGE = CMD.UPG_BARRAGE

-- TODO: Move to Separate file for better organization
-- Unit Upgrades (as shown in a certain unit's command list)
UnitUpg = {
    dgun = {
        id = "dgun",
        UpgradeCmdDesc = {
            id      = CMD_UPG_DGUN,
            name    = '^ D-Gun',
            action  = 'dgunupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'D-Gun Upgrade: Enables D-gun weapon [per unit]',
            texture = 'luaui/images/upgrades/techdgun.dds',
            onlyTexture = true,
            params      = { refresh = "false", ... }
        },
        prereq = "Tech1",
        metalCost = 200,
        energyCost = 1200,
        upgradeTime = 10 * 30, --5 seconds, in frames
        type = "tech",          -- TODO: Currently unused. Should indicate special types (auras, debuffs, etc)
        alertWhenDone = true, -- [Optional] if true, fires an alert once completed
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "", --automatically fed when button is locked (@ unit create)
    },
    grenade = {     -- >> Peewee's Laser Grenade (Per Unit)
        id = "grenade",
        UpgradeCmdDesc = {
            id      = CMD_UPG_GRENADE,
            name    = '^ Grenade',
            action  = 'grenadeupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Laser Grenade upgrade: Enables manual-fire Grenade weapon [per unit]',
            texture = 'luaui/images/upgrades/techexplosives.dds',
            onlyTexture = true,
        },
        prereq = "Tech",
        metalCost = 80,
        energyCost = 480,     --6x metalCost
        upgradeTime = 5 * 30, --5 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    firerain = {     -- >> Arm Samson's Missile Shower (Per Unit)
        id = "firerain",
        UpgradeCmdDesc = {
            id      = CMD_UPG_FIRERAIN,
            name    = '^ FireRain',
            action  = 'firerainupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Fire Rain upgrade: Enables manual-fire Fire Rain weapon [per unit]',
            texture = 'luaui/images/upgrades/techdgun.dds',
            onlyTexture = true
        },
        prereq = "Tech1",
        metalCost = 250,
        energyCost = 1500, --960
        upgradeTime = 10 * 30, --10 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
    barrage = {     -- >> Core Informer comet rain (Per Unit)
        id = "barrage",
        UpgradeCmdDesc = {
            id      = CMD_UPG_BARRAGE,
            name    = 'Upg Barrage',
            action  = 'barrageupgrade',
            cursor  = 'Morph',
            type    = CMDTYPE.ICON,
            tooltip = 'Barrage upgrade: Enables manual-fire Barrage weapon [per unit]',
            texture = 'luaui/images/upgrades/techexplosives.dds',
            onlyTexture = true,
        },
        prereq = "Tech1",
        metalCost = 160,
        energyCost = 960,
        upgradeTime = 10 * 30, --5 seconds, in frames
        type = "perunit",
        buttonToUnlock = CMD_MANUALFIRE,
        buttonToUnlockTooltip = "",
    },
}
-- Value is used as key of PUU (Per-unit upgrade table)
UnitResearchers = {
    [UnitDefNames["corcom"].id] = "dgun",
    --[UnitDefNames["corcom2"].id] = "dgun",
    --[UnitDefNames["corcom3"].id] = "dgun",
    --[UnitDefNames["corcom4"].id] = "dgun",
    [UnitDefNames["armcom"].id] = "dgun",
    --[UnitDefNames["armcom2"].id] = "dgun",
    --[UnitDefNames["armcom3"].id] = "dgun",
    --[UnitDefNames["armcom4"].id] = "dgun",
    [UnitDefNames["armpw"].id] = "grenade",
    [UnitDefNames["armsam"].id] = "firerain",
    [UnitDefNames["corvrad"].id] = "plasmabarrage",
}
UnitUpgrades = {} -- Auto-completed from UnitUpg table @ Initialize

--local tooltipRequirement = "\n"..RedStr.."Requires ".. prereq,
--local UpgradeTooltip = 'Enables D-gun ability / command'
--local tooltipRequirement = "\n"..RedStr.."Requires ".. PUU.dgun.prereq
local upgradingUnits = {}   -- { [unitID] = { progress = 0, unitUpg = { id = "x", UpgradeCmdDesc = {}, ..} } }
local upgradedUnits  = {}
local upgradeLockedUnits = {} -- { [unitID] = { prereq = "", upgradeButton = cmdID, orgTooltip = "" .. }, ... }
local frameRate = 4

if not gadgetHandler:IsSyncedCode() then
    return end

local function startUpgrade(unitID, unitUpg)
    --Spring.Echo("Added "..unitID..", count: "..#upgradingUnits)
    upgradingUnits[unitID] = { progress = 0, unitUpg = unitUpg, }
    spSetUnitRulesParam(unitID, unitRulesParamName, 0)
end

local function cancelUpgrade(unitID)
    upgradingUnits[unitID] = nil
    spSetUnitRulesParam(unitID, unitRulesParamName, nil)
    return true
end

function gadget:AllowCommand(unitID,unitDefID,unitTeam,cmdID) --,cmdParams
    local upgrade = UnitResearchers[unitDefID]
    if not upgrade then
        return true
    end
    local unitUpg = UnitUpg[upgrade]
    local cmdDesc = unitUpg.UpgradeCmdDesc

    if cmdID == cmdDesc.id and (not upgradedUnits[unitID]) then
        --- If currently upgrading, cancel upgrade
        --TODO: Uncomment when below is fixed, currently useles..
        --if upgradingUnits[unitID] then
        --    cancelUpgrade(unitID)
        --end
        --- Otherwise, check for requirements
        if HasTech(unitUpg.prereq, unitTeam) then
            startUpgrade(unitID, unitUpg)
            BlockCmdID(unitID, cmdID, cmdDesc.tooltip, "Upgrading")
            --TODO: Must update texture to "WIP" texture. buildordermenu is not helping.
            --cmdDesc.texture = cmdDesc.texture:gsub(".dds", "_wip.dds") -- "Upgrade in progress" texture
            --cmdDesc.params.refresh = "true"
            --AddUpdateCommand(unitID, cmdDesc)
        else
            LocalAlert(unitID, "Requires: ".. unitUpg.prereq)
        end
    end
    return true
end

function gadget:Initialize()
    for _,upgrade in pairs(UnitUpg) do
        UnitUpgrades[upgrade] = true
    end
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local upgrade = UnitResearchers[unitDefID]
    if not upgrade then
        return end
    --Spring.Echo("Found locally available upgrade: "..upgrade)

    local unitUpg = UnitUpg[upgrade]
    if unitUpg then
        -- Store original buttonToUnlock tooltip for later usage (add suffix / restore)
        local cmdIdx = spFindUnitCmdDesc(unitID, unitUpg.buttonToUnlock)
        local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
        if cmdDesc then
            unitUpg.buttonToUnlockTooltip = cmdDesc.tooltip end

        -- Add upgrade Cmd, block & add it to watch list, if tech not yet available
        local block = not HasTech(unitUpg.prereq, unitTeam)
        AddUpdateCommand(unitID, unitUpg.UpgradeCmdDesc, block)
        -- Disable upgrade-locked button (since it's per-unit, it always starts locked)
        BlockCmdID(unitID, unitUpg.buttonToUnlock, unitUpg.buttonToUnlockTooltip, "Requires: "..upgrade.." upgrade [per-unit]")

        if block then
            upgradeLockedUnits[unitID] = { prereq = unitUpg.prereq, upgradeButton = unitUpg.UpgradeCmdDesc.id,
                                           orgTooltip = unitUpg.UpgradeCmdDesc.tooltip }
        end
    end
end

function gadget:UnitDestroyed(unitID)
    upgradedUnits[unitID] = nil
    upgradingUnits[unitID] = nil
    upgradeLockedUnits[unitID] = nil
end

-- If unit was taken, apply unit-creation check
function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    self:UnitCreated(unitID, unitDefID, teamID)
    --if isDone(unitID) then self:UnitFinished(unitID, unitDefID, teamID) end
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID, oldTeamID)
    self:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

local function finishUpgrade(unitID, unitUpg)
    -- TODO: Being blocked by Upgrade Start
    --BlockCmdID(unitID, unitUpg.UpgradeCmdDesc.id, unitUpg.UpgradeCmdDesc.tooltip)  --, "Requires: "..unitUpg.id)

    -- Enable action & remove "Requires" red alert at bottom
    UnblockCmdID(unitID, unitUpg.buttonToUnlock, unitUpg.buttonToUnlockTooltip)
    upgradingUnits[unitID] = nil
    upgradeLockedUnits[unitID] = nil -- Once an unit upgrade is complete we can safely stop watching its prereqs
    upgradedUnits[unitID] = true

    spSetUnitRulesParam(unitID, unitRulesParamName, nil)

    if unitUpg.alertWhenDone then
        LocalAlert(unitID, "Unit upgrade complete.")
    end
end

function gadget:GameFrame(n)
    local frame = spGetGameFrame()
    if (frame <= oldFrame or n % frameRate > 0.0001) then
        return end
    oldFrame = frame

    --Watch all prereq blocked units to see if theit prereqs are done/lost, block/unblock accordingly
    for unitID, data in pairs(upgradeLockedUnits) do
        local hasTech = HasTech(data.prereq, spGetUnitTeam(unitID))
        if not upgradingUnits[unitID] then
            SetCmdIDEnable(unitID, data.upgradeButton, not hasTech, data.orgTooltip, "Requires: "..data.prereq )
        end
    end

    if not upgradingUnits or tablelength(upgradingUnits) == 0 then    -- If table empty, return
        return end

    --{ unitID = unitID, progress = 0, unitUpg = unitUpg, }
    for unitID, data in pairs(upgradingUnits) do
        local progress = data.progress
        local unitUpg = data.unitUpg
        if spUseUnitResource(unitID, { ["m"] = unitUpg.metalCost / unitUpg.upgradeTime, ["e"] = unitUpg.energyCost / unitUpg.upgradeTime }) then
            local progress = progress + 1 / unitUpg.upgradeTime -- TODO: Add "Morph speedup" bonus maybe?
            upgradingUnits[unitID].progress = progress
            spSetUnitRulesParam(unitID, unitRulesParamName, progress)
            if progress >= 1.0 then
                finishUpgrade(unitID, unitUpg)
            end
        end
    end
end



--local function isUpgrading(unitID)
--    for idx = 1, #upgradingUnits do
--        if upgradingUnits[idx].unitID == unitID then
--            return idx
--        end
--    end
--    return nil
--end

--- TODO: Move the tooltip description editing logic to taptools (somehow?)
--local function editCommand (unitID, cmdID, options)
--    local cmdDesc = spFindUnitCmdDesc(unitID, cmdID)
--    if not cmdDesc or not options then --or not options.defCmdDesc then
--        return end
--
--    if options.req and options.defCmdDesc then
--        local append = ""
--        if options.req == "perunit" then        -- Just tags if the button requirement is a per-unit upgrade
--            if not upgradedUnits[unitID] then
--                append = "\n\n"..RedStr.."Requires: "..options.defCmdDesc.name.." unit upgrade."
--                --append = options.missingPrereqTooltip
--            end
--        else
--            if not options.req == "" and not GG.TechCheck(options.req, spGetUnitTeam(unitID)) then
--                append = "\n\n"..RedStr.."Requires Tech: "..options.req
--            end
--        end
--        options.tooltip = ((options.tooltip == nil) and options.defCmdDesc.tooltip or options.tooltip) .. append
--    end
--
--    local currentCmdDesc = spGetUnitCmdDescs(unitID, cmdDesc, cmdDesc)[1]
--
--    currentCmdDesc.tooltip = options.tooltip and options.tooltip or currentCmdDesc.tooltip
--    currentCmdDesc.hidden = (options.hidden == nil) and currentCmdDesc.hidden or options.hidden
--    currentCmdDesc.disabled = (options.disabled == nil) and currentCmdDesc.disabled or options.disabled
--
--    spEditUnitCmdDesc (unitID, cmdDesc, currentCmdDesc)
--end

--AddUpdateCommand(unitID, puuItem.UpgradeCmdDesc.id, puuItem.UpgradeCmdDesc, { req=puuItem.Prereq, defCmdDesc=puuItem.UpgradeCmdDesc })
--local function addUpdateCommand(unitID, puuItem)
--    local insertID = puuItem.UpgradeCmdDesc.id
--    local cmdDesc = puuItem.UpgradeCmdDesc
--    local options = { req=puuItem.prereq, defCmdDesc=puuItem.UpgradeCmdDesc }
--
--    --local cmdDescId = spFindUnitCmdDesc(unitID, cmdDesc.id)
--    --if not cmdDescId then
--    --    spInsertUnitCmdDesc(unitID, insertID, cmdDesc)
--    --else
--    --    spEditUnitCmdDesc(unitID, cmdDescId, cmdDesc)
--    --end
--    --spEditUnitCmdDesc(unitID, cmdDescId, options)
--end

