function gadget:GetInfo()
    return {
        name 	= "Cmd - Gfx Buttons",
        desc	= "Adds button images on top of command buttons",
        author	= "MaDDoX",
        date	= "Feb 14 2020",
        license	= "GNU GPL, v2 or later",
        layer	= 10,
        enabled = true, --true, (WIP)
    }
end

VFS.Include("gamedata/taptools.lua")

local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
local CMD_UNIT_SET_TARGET = 34923
local CMD_UNIT_CANCEL_TARGET = 34924

if not gadgetHandler:IsSyncedCode() then
    return end

local GfxButtons = {
    [1] = { cmd = CMD.ATTACK, texture = 'luaui/images/gfxbuttons/cmd_attack.png', }, --{
    --id      = CMD_ATTACK,
    --name    = 'ATTACK',
    --action  = 'upgradecapture',
    --cursor  = 'Morph',
    --type    = CMDTYPE.ICON,
    --tooltip = 'Unlocks the Capture ability of all builder units',
    --texture = 'luaui/images/gfxbuttons/cmd_attack.png',
    --onlyTexture = true,
    --showUnique = true, --required by gui_chili_buildordermenu to show button as 'upgrading'
    --}
    [2] = { cmd = CMD_UNIT_CANCEL_TARGET, texture = 'luaui/images/gfxbuttons/cmd_canceltarget.png', },
    [3] = { cmd = CMD.CAPTURE, texture = 'luaui/images/gfxbuttons/cmd_capture.png', },
    [4] = { cmd = CMD.FIGHT, texture = 'luaui/images/gfxbuttons/cmd_fight.png', },
    [5] = { cmd = CMD.GUARD, texture = 'luaui/images/gfxbuttons/cmd_guard.png', },
    [6] = { cmd = CMD.MANUALFIRE, texture = 'luaui/images/gfxbuttons/cmd_manualfire.png', },
    [7] = { cmd = CMD.MOVE, texture = 'luaui/images/gfxbuttons/cmd_move.png', },
    [8] = { cmd = CMD.PATROL, texture = 'luaui/images/gfxbuttons/cmd_patrol.png', },

    [9] = { cmd = CMD.RECLAIM, texture = 'luaui/images/gfxbuttons/cmd_reclaim.png', },
    [10] = { cmd = CMD.REPAIR, texture = 'luaui/images/gfxbuttons/cmd_repair.png', },
    --[8] = { cmd = CMD.REPEAT, texture = 'luaui/images/gfxbuttons/cmd_patrol.png', },
    [11] = { cmd = CMD.RESTORE, texture = 'luaui/images/gfxbuttons/cmd_restore.png', },
    [12] = { cmd = CMD.SELFD, texture = 'luaui/images/gfxbuttons/cmd_restore.png', },
    [13] = { cmd = CMD_UNIT_SET_TARGET, texture = 'luaui/images/gfxbuttons/cmd_settarget.png', },
    [14] = { cmd = CMD.STOP, texture = 'luaui/images/gfxbuttons/cmd_stop.png', },
    [15] = { cmd = CMD.WAIT, texture = 'luaui/images/gfxbuttons/cmd_wait.png', },
}

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    for _,data in ipairs(GfxButtons) do
        --Spring.Echo("Key: "..(data.cmd or "nil").." value: "..(data.texture or "nil"))
        local cmdId = spFindUnitCmdDesc(unitID, data.cmd)
        if cmdId then
            local cmdDesc = spGetUnitCmdDescs(unitID, cmdId, cmdId)[1]
            if cmdDesc then
                cmdDesc.texture = data.texture
                spEditUnitCmdDesc(unitID, cmdId, cmdDesc)
            end
        end
    end
end

function gadget:Initialize()
    --TODO: For all existing units, call unitcreated
end

-- If unit was taken, apply unit-creation check
function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    self:UnitCreated(unitID, unitDefID, teamID)
    --if isDone(unitID) then self:UnitFinished(unitID, unitDefID, teamID) end
end