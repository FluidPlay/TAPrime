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

CMD.UPG_DGUN = 41999
CMD_UPG_DGUN = 41999

if gadgetHandler:IsSyncedCode() then

    local spSetUnitRulesParam = Spring.SetUnitRulesParam
    local upgradingUnits = {}

    function gadget:AllowCommand(unitID,_,unitTeam,cmdID,cmdParams)
        -- Require Tech1 for Upgrade
        -- TODO: Progress, progress percentage (check unit_morph.lua)
        if cmdID == CMD_UPG_DGUN and GG.TechCheck("Tech1", unitTeam) then
            Spring.Echo("Added "..unitID..", count: "..#upgradingUnits)
            upgradingUnits[#upgradingUnits+1] = { unitID = unitID, progress = 0 }
            spSetUnitRulesParam(unitID,"upgrade", 0)
        end
        return true
    end
--------------------------------------------------------------------------------
--region  UNSYNCED
--------------------------------------------------------------------------------
else

    local CMD_MANUALFIRE = CMD.MANUALFIRE

    local startFrame
    local metalCost = 200
    local energyCost = 1200
    local upgradeTime = 5 * 30 --5 seconds, in frames
    local upgradingUnits = {}

    local SYNCED = SYNCED
    local spairs = spairs
    local oldFrame = 0        --// used to save bandwidth between unsynced->LuaUI


    local spGetUnitDefID = Spring.GetUnitDefID
    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spInsertUnitCmdDesc = Spring.InsertUnitCmdDesc
    local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
    local spSetUnitRulesParam = Spring.SetUnitRulesParam
    local spGetGameFrame      = Spring.GetGameFrame

    local UpgDgunDesc = {
        id      = CMD_UPG_DGUN,
        type    = CMDTYPE.ICON,
        name    = 'Upg D-Gun',
        cursor = 'Morph',
        action  = 'dgunupgrade',
        tooltip = 'Enables D-gun ability / command',
    }

    function gadget:Initialize()
        startFrame = spGetGameFrame()
        for ct, unitID in pairs(Spring.GetAllUnits()) do
            gadget:UnitCreated(unitID)
        end
    end

    function gadget:UnitCreated(unitID, unitDefID, unitTeam)
        Spring.Echo("created: "..unitID)
        if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
            spInsertUnitCmdDesc(unitID, CMD_UPG_DGUN, UpgDgunDesc)
            local cmdDescID = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
            spEditUnitCmdDesc(unitID, cmdDescID, { disabled=true })--, queueing=false,
        end
    end
    --
    ----- Update methods are not useful on synced gadgets it seems
    --function gadget:GameFrame() --Update() --gameFrame(n)
    --    --if not n == startFrame then
    --    --    return end
    --end

    function gadget:Update()
        local frame = spGetGameFrame()
        if (frame<=oldFrame) then
            return end
        oldFrame = frame
        if not upgradingUnits then    -- If table empty, return
            return end

        for idx, unitID in spairs(upgradingUnits) do
            local function finishUpgrade(unitID)
                local cmdDescId = spFindUnitCmdDesc(unitID, CMD_UPG_DGUN)
                spEditUnitCmdDesc(unitID, cmdDescId, { disabled=true })

                local cmdDescId = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
                spEditUnitCmdDesc(unitID, cmdDescId, { disabled=false })

                ---TODO : Remove unit from upgradingUnits
                spSetUnitRulesParam(unitID,"upgrade", nil)
            end
            Spring.Echo("Count: "..#upgradingUnits)
            finishUpgrade(unitID)
        end
        --for _,data in ipairs(upgradingUnits) do
        --    local unitID = data.unitID
        --    local progress = data.progress
        --    Spring.Echo("Unit: "..unitID.." progress: "..progress)
        --    if spUseUnitResource(unitID, { ["m"] = metalCost/upgradeTime, ["e"] = energyCost/upgradeTime }) then
        --        local progress = progress + 1 / upgradeTime -- TODO: Add "Morph speedup" bonus maybe?
        --        upgradingUnits[unitID] = progress
        --        spSetUnitRulesParam(unitID,"upgrade", progress)
        --        if progress >= 1.0 then
        --            finishUpgrade(unitID)
        --        end
        --    end
        --end
    end
end