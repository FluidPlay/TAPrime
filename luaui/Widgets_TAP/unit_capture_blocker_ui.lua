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

--- Receives an event from unit_capture_blocker gadget and plays a feedback sound

local function CaptureBlocked(unitTeam)
    -- TODO: if unitTeam == myTeam
    Spring.PlaySoundFile("errorbleep", 0.2, 'ui')
end

function widget:Initialize()
    widgetHandler:RegisterGlobal("CaptureBlockedUIEvent", CaptureBlocked)
end

function widget:Shutdown()
    widgetHandler:DeregisterGlobal("CaptureBlockedUIEvent")
end