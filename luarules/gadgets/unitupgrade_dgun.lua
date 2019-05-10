function gadget:GetInfo()
    return {
        name 	= "Unit Upgrade - Dgun",
        desc	= "Enables D-gun command for Commanders",
        author	= "MaDDoX",
        date	= "Sept 24th 2019",
        license	= "GNU GPL, v2 or later",
        layer	= -1,
        enabled = true,
    }
end


if gadgetHandler:IsSyncedCode() then

    CMD.UPG_DGUN = 41999
    CMD_UPG_DGUN = 41999

    local CMD_MANUALFIRE = CMD.MANUALFIRE
    local unitRulesParamName = "upgrade"

    local startFrame
    local metalCost = 200
    local energyCost = 1200
    local upgradeTime = 5 * 30 --5 seconds, in frames
    local upgradingUnits = {}
    local RedStr = "\255\255\001\001"
    local Prereq = "Tech1"
    local UpgradeTooltip = 'Enables D-gun ability / command'
    local tooltipRequirement = "\n"..RedStr.."Requires ".. Prereq

    local SYNCED = SYNCED
    local spairs = spairs
    local oldFrame = 0        --// used to save bandwidth between unsynced->LuaUI

    local spGetUnitDefID        = Spring.GetUnitDefID
    local spGetUnitTeam         = Spring.GetUnitTeam
    local spFindUnitCmdDesc     = Spring.FindUnitCmdDesc
    local spInsertUnitCmdDesc   = Spring.InsertUnitCmdDesc
    local spEditUnitCmdDesc     = Spring.EditUnitCmdDesc
    local spSetUnitRulesParam   = Spring.SetUnitRulesParam
    local spGetGameFrame        = Spring.GetGameFrame
    local spUseUnitResource     = Spring.UseUnitResource

    local UpgradeBtnDesc = {
        id      = CMD_UPG_DGUN,
        type    = CMDTYPE.ICON,
        name    = 'Upg D-Gun',
        cursor  = 'Morph',
        action  = 'dgunupgrade',
        tooltip = UpgradeTooltip,
    }

    local function hasPrereq(unitTeam)
        return GG.TechCheck(Prereq, unitTeam)
    end

    function gadget:AllowCommand(unitID,_,unitTeam,cmdID,cmdParams)
        -- Require Tech1 for Upgrade
        if cmdID == CMD_UPG_DGUN and hasPrereq(unitTeam) then
            Spring.Echo("Added "..unitID..", count: "..#upgradingUnits)
            upgradingUnits[#upgradingUnits+1] = { unitID = unitID, progress = 0 }
            spSetUnitRulesParam(unitID,unitRulesParamName, 0)
        else
            --TODO: Add local warning that pre-req is not met
        end
        return true
    end

    function gadget:Initialize()
        startFrame = spGetGameFrame()
        for ct, unitID in pairs(Spring.GetAllUnits()) do
            gadget:UnitCreated(unitID)
        end
    end

    --    local UpgradeTooltip = 'Enables D-gun ability / command'
    --    local tooltipRequirement = "\n"..RedStr.."Requires "..TechRequirement
    local function getUpgradeTooltip(unitTeam)
        return UpgradeTooltip..(hasPrereq(unitTeam) and "" or tooltipRequirement)
    end

    ---TODO: prereq = { req = "tech1" | "perunit",
    ---                 missingPrereqTooltip = "req this" }
    local function AddButton (unitID, CMDID, defCmdDesc, disabled, prereq)
        local cmdDescID = spFindUnitCmdDesc(unitID, CMDID)
        if not cmdDescID then
            local newCmdDesc = defCmdDesc
            if prereq then
                newCmdDesc.tooltip = getUpgradeTooltip(spGetUnitTeam(unitID))
            end
            spInsertUnitCmdDesc(unitID, newCmdDesc, { disabled=disabled } )
        --else
        --    spEditUnitCmdDesc(unitID, cmdDescID, { disabled=disabled })
        end
    end

    -- TODO: Add manualfire edited tooltip
    local function EditButton (unitID, CMDID, disabled, prereq)
        local cmdDescID = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
        spEditUnitCmdDesc(unitID, cmdDescID, { disabled=disabled })
    end

    function gadget:UnitCreated(unitID, unitDefID, unitTeam)
        --Spring.Echo("created: "..unitID)
        if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
            AddButton (unitID, CMD_UPG_DGUN, UpgradeBtnDesc, false, true)

            --for debug purposes, so /unitrules reload works fine
            spSetUnitRulesParam(unitID, unitRulesParamName, nil)

            EditButton (unitID, CMD_MANUALFIRE, true)
        end
    end

    local function finishUpgrade(idx, unitID)

        EditButton (unitID, CMD_UPG_DGUN, true)

        EditButton (unitID, CMD_MANUALFIRE, false)

        upgradingUnits[idx] = nil
        spSetUnitRulesParam(unitID, unitRulesParamName, nil)
    end

    function gadget:GameFrame()
        local frame = spGetGameFrame()
        if (frame <= oldFrame) then
            return end
        --Spring.Echo("New frame: "..frame)
        oldFrame = frame
        if not upgradingUnits or #upgradingUnits == 0 then    -- If table empty, return
            return end

        Spring.Echo("Count: "..#upgradingUnits)

         --{ unitID = unitID, progress = 0 }
        for idx,data in ipairs(upgradingUnits) do
            local unitID = data.unitID
            local progress = data.progress
            Spring.Echo("Unit: "..unitID.." progress: "..progress.." m req: "..metalCost/upgradeTime.." e req: "..energyCost/upgradeTime )
            if spUseUnitResource(unitID, { ["m"] = metalCost/upgradeTime, ["e"] = energyCost/upgradeTime }) then
                local progress = progress + 1 / upgradeTime -- TODO: Add "Morph speedup" bonus maybe?
                --Spring.Echo("Progress: "..progress)
                upgradingUnits[idx] = { unitID = unitID, progress = progress }
                spSetUnitRulesParam(unitID,unitRulesParamName, progress)
                if progress >= 1.0 then
                    finishUpgrade(idx, unitID)
                end
            end
        end
    end
--------------------------------------------------------------------------------
--region  UNSYNCED
--------------------------------------------------------------------------------
else

    --local CMD_MANUALFIRE = CMD.MANUALFIRE
    --
    --local startFrame
    --local metalCost = 200
    --local energyCost = 1200
    --local upgradeTime = 5 * 30 --5 seconds, in frames
    --local upgradingUnits = {}
    --
    --local SYNCED = SYNCED
    --local spairs = spairs
    --local oldFrame = 0        --// used to save bandwidth between unsynced->LuaUI
    --
    --
    --local spGetUnitDefID = Spring.GetUnitDefID
    --local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    --local spInsertUnitCmdDesc = Spring.InsertUnitCmdDesc
    --local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
    --local spSetUnitRulesParam = Spring.SetUnitRulesParam
    --local spGetGameFrame      = Spring.GetGameFrame
    --
    --local UpgDgunDesc = {
    --    id      = CMD_UPG_DGUN,
    --    type    = CMDTYPE.ICON,
    --    name    = 'Upg D-Gun',
    --    cursor = 'Morph',
    --    action  = 'dgunupgrade',
    --    tooltip = 'Enables D-gun ability / command',
    --}

end