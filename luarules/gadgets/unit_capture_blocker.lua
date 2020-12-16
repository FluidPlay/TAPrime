function gadget:GetInfo()
    return {
        name      = "Capture blocker",
        desc      = "Blocks capture under certain circumstances",
        author    = "MaDDoX",
        date      = "Dec 16, 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  Enabled by default?
    }
end

if gadgetHandler:IsSyncedCode() then
    --- SYNCED

    VFS.Include("gamedata/taptools.lua")

    local trackedUnits = {}             -- unitID = true, ... }
    local heightDiffPercentage = 0.2    -- Percentage of build range which validates vertical captures

    local math_abs = math.abs
    local CMD_CAPTURE = CMD.CAPTURE -- icon unit or area
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetUnitPosition = Spring.GetUnitPosition

    --local function iscommander(uDefID)
    --    local cParms = UnitDefs[uDefID].customParams
    --    if cParms and cParms.iscommander then
    --        return true
    --    endz
    --    return false
    --end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if not IsValidUnit(unitID) then
            return end
        if trackedUnits[unitID] and cmdID and cmdID == CMD_CAPTURE then
            local unitPosY = select(2, spGetUnitPosition(unitID))
            local targetUID = cmdParams[1]
            local targetPosY = select(2, spGetUnitPosition(targetUID))
            local heightDiff = math_abs(targetPosY - unitPosY)
            local buildDistance = UnitDefs[unitDefID].buildDistance or 100  -- fallback build distance in case of stats error
            if heightDiff > (heightDiffPercentage * buildDistance) then
                SendToUnsynced("CaptureBlockedEvent", unitTeam)
                return false
            end
        end
        return true
    end

    function gadget:UnitCreated(unitID, unitDefID)
        local uDef = UnitDefs[unitDefID]
        if uDef.canCapture and not uDef.canFly then
            trackedUnits[unitID] = true
        end
    end

    function gadget:Initialize()
        for _, unitID in ipairs(Spring.GetAllUnits()) do
            local unitDefID = spGetUnitDefID(unitID)
            gadget:UnitCreated(unitID, unitDefID)
        end
    end

else
    function HandleCaptureBlockedEvent(cmd, unitTeam)
        if Script.LuaUI("CaptureBlockedUIEvent") then
            Script.LuaUI.CaptureBlockedUIEvent(unitTeam)
        end
    end

    function gadget:Initialize()
        gadgetHandler:AddSyncAction("CaptureBlockedEvent", HandleCaptureBlockedEvent)
    end
    function gadget:Shutdown()
        gadgetHandler:RemoveSyncAction("CaptureBlockedEvent")
    end
end