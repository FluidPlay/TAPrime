function widget:GetInfo()
    return {
        name      = "Capture Blocker - UI",
        desc      = "Capture Blocker UI event",
        author    = "MaDDoX",
        date      = "Dec 16, 2020",
        license   = "GNU GPL v3",
        layer     = -1,
        enabled   = true  --  loaded by default?
    }
end

local spGetMyTeamID = Spring.GetMyTeamID
local myTeamID = -1

--- Receives an event from unit_capture_blocker gadget and plays a feedback sound

local function CaptureBlocked(unitTeam)
    if unitTeam == myTeamID then
        Spring.PlaySoundFile("errorbleep", 0.2, 'ui')
    end
end

function widget:Initialize()
    local myTeamID = spGetMyTeamID
    widgetHandler:RegisterGlobal("CaptureBlockedUIEvent", CaptureBlocked)
end

function widget:Shutdown()
    widgetHandler:DeregisterGlobal("CaptureBlockedUIEvent")
end