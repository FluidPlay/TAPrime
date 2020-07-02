
function widget:GetInfo()
	return {
		name      = "Holdfire Fix",
		desc      = "Holdfire holds fire immediately",
		author    = "Niobium",
		date      = "3 April 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true
	}
end

local CMD_FIRE_STATE = CMD.FIRE_STATE
local CMD_INSERT = CMD.INSERT
local CMD_STOP = CMD.STOP
local spGiveOrder = Spring.GiveOrder

function removeSelfCheck()
    if Spring.GetSpectatingState() and (Spring.GetGameFrame() > 0 or gameStarted) then
        widgetHandler:RemoveWidget(self)
    end
end

function widget:GameStart()
    gameStarted = true
    removeSelfCheck()
end

function widget:PlayerChanged(playerID)
    removeSelfCheck()
end

function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        removeSelfCheck()
    end
end

function widget:CommandNotify(cmdID, cmdParams, cmdOpts)
	if (cmdID == CMD_FIRE_STATE) and (cmdParams[1] == 0) then
		spGiveOrder(CMD_INSERT, {0, CMD_STOP, 0}, {"alt"})
	end
end
