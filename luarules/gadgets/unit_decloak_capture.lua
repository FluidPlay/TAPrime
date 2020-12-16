function gadget:GetInfo()
    return {
        name      = "Decloak when capturing",
        desc      = "Decloaks units when they are trying to capture",
        author    = "MaDDoX",
        date      = "Mar 24, 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = false --true  --  Currently disabled in favor of the new unit_capture_blocker.lua
    }
end

local CMD_CAPTURE = CMD.CAPTURE --icon unit or area
local spSetUnitCloak = Spring.SetUnitCloak
local spGetUnitIsCloaked = Spring.GetUnitIsCloaked

--local function iscommander(uDefID)
--    local cParms = UnitDefs[uDefID].customParams
--    if cParms and cParms.iscommander then
--        return true
--    end
--    return false
--end

function gadget:AllowCommand(unitID, uDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
    if cmdID and cmdID == CMD_CAPTURE then
        if spGetUnitIsCloaked(unitID) then --iscommander(uDefID)
            spSetUnitCloak(unitID, false) end
        --TODO: Requires merge with unit_decloak_logic.
        --spSetUnitRulesParam(unitID, "cannotcloak", 1, alliedIsTrueTable)
    end
    return true
end