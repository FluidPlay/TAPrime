function gadget:GetInfo()
    return {
        name      = "Plane Stop",
        desc      = "Fighters and Bombers set to flight mode freeze mid-air when stopped",
        author    = "MaDDoX",
        date      = "6 Dec 2019",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
    return
end

VFS.Include("gamedata/taptools.lua")
VFS.Include("LuaRules/Utilities/quaternion.lua")

--local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
local spGetUnitDefID = Spring.GetUnitDefID
--local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
--local GiveOrderToUnit = Spring.GiveOrderToUnit
--local SetUnitNeutral = Spring.SetUnitNeutral

local trackedUnits = {
    [UnitDefNames["armfig"].id] = true,
    [UnitDefNames["corveng"].id] = true,
    [UnitDefNames["armthund"].id] = true,
    [UnitDefNames["corshad"].id] = true,
    [UnitDefNames["armhawk"].id] = true,
    [UnitDefNames["corvamp"].id] = true,
    [UnitDefNames["armpnix"].id] = true,
    [UnitDefNames["corhurc"].id] = true,
    [UnitDefNames["armliche"].id] = true,
    [UnitDefNames["corstil"].id] = true,
}

local planes = {}
local planesToPause, pausedPlanes, planesToUnpause = {}, {}, {}, {}
local planeDestinations, pausingPlanes, idlingPlanes  = {}, {}, {}

local lerpFactor = 0.1 -- Interpolation factor for deceleration until pause. The lower the slower/smoother
local idleUpdateRate = 20

local CMD_STOP = CMD.STOP
local CMD_MOVE = CMD.MOVE
local CMD_IDLEMODE = CMD.IDLEMODE

--TODO: Check if spawning (by group) fires UnitFinished, if not enable this
--function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
--end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    planes[unitID] = nil
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if trackedUnits[unitDefID] then
        local uDefID = spGetUnitDefID(unitID)
        local uDef = UnitDefs[uDefID]
        planes[unitID] = uDef
        --Spring.Echo("Alt: "..tostring(uDef.wantedHeight))
        --GiveOrderToUnit(unitID, CMD.IDLEMODE, { planes[builderID].landAt }, { })
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    planes[unitID] = nil
    planesToPause[unitID] = nil
    pausedPlanes[unitID] = nil
    planesToUnpause[unitID] = nil
    planeDestinations[unitID] = nil
    pausingPlanes[unitID] = nil
    idlingPlanes[unitID] = nil
end

local function isSetToFly(unitID)
    local cmdIdleModeId = spFindUnitCmdDesc(unitID, CMD_IDLEMODE)
    if not cmdIdleModeId then
        return false end
    local cmdIdleModeDesc = spGetUnitCmdDescs(unitID, cmdIdleModeId, cmdIdleModeId)[1]
    if istable(cmdIdleModeDesc.params) then
        return cmdIdleModeDesc.params[1] == "0"    -- If equal "0" ==> Fly
    else
        return false end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    local planeuDefID = planes[unitID]
    if planeuDefID then
        --DebugTable(cmdOptions)
        if cmdID == CMD_MOVE or cmdID == CMD.PATROL or cmdID == CMD.ATTACK then
            idlingPlanes[unitID] = nil
            if pausedPlanes[unitID] then
                planesToUnpause[unitID] = planeuDefID end
        end
        if cmdID == CMD_MOVE then
            planeDestinations[unitID] = { x = cmdParams[1], y = cmdParams[2], z = cmdParams[3] }
        elseif cmdID == CMD_STOP and not cmdOptions.shift then --TODO: And flyState == fly
            if isSetToFly(unitID) and not pausedPlanes[unitID] then
                local x, y, z = Spring.GetUnitPosition(unitID)
                local velx, vely, velz= Spring.GetUnitVelocity(unitID)
                planesToPause[unitID] = { wantedHeight = planeuDefID.wantedHeight,
                                          targetPos = { x = x, y = y, z = z },
                                          sourceVel = { x = velx, y = vely, z = velz }
                                        }
            else
                if pausedPlanes[unitID] then
                    planesToUnpause[unitID] = planeuDefID end
            end
        elseif pausedPlanes[unitID] then
                planesToUnpause[unitID] = planeuDefID
        end
    end
    return true
end

local function verynear (a,b)
    return math.abs(b-a) < 20
end

local function sign(num)
    return num/math.abs(num)
end

function gadget:GameFrame(f)
    --if f%20 > 0.001 then
    --    return end
    for unitID, data in pairs(planesToPause) do
        local posx, posy, posz = Spring.GetUnitPosition(unitID)
        local relativeHeight = Spring.GetGroundHeight(posx, posz) + data.wantedHeight
        data.relativeHeight = relativeHeight

        local targetRotY = roty
        local dest = planeDestinations[unitID]

        if dest then
            --Spring.Echo("rot Y: "..dy.." target rot Y: "..py)
            local rx, ry, rz = Spring.GetUnitRotation(unitID)       -- source Rotation
            local dx, dy, dz = dest.x - posx, dest.y - posy, dest.z - posz  -- target Direction
            Spring.SetUnitDirection(unitID, dx, dy, dz)             -- apply target Direction
            local trx, try, trz = Spring.GetUnitRotation(unitID)    -- read back target Rotation
            Spring.SetUnitRotation(unitID, rx, ry, rz)              -- restores original rotation

            data.targetRotation = { x = trx, y = try, z = trz }
            -- Add some skidding, based off of velocity, so it isn't a totally instant pause
            data.targetPos.x = data.targetPos.x + data.sourceVel.x * 10
            data.targetPos.z = data.targetPos.z + data.sourceVel.z * 10
        end
        planesToPause[unitID] = nil
        pausingPlanes[unitID] = data
        Spring.MoveCtrl.Enable(unitID)
        pausedPlanes[unitID] = true
    end

    for unitID, data in pairs(pausingPlanes) do
        local rx, ry, rz = Spring.GetUnitRotation(unitID)       -- current Direction
        if rx and ry and rz then
            local posx, posy, posz = Spring.GetUnitPosition(unitID)

            local tr = data.targetRotation -- target Rotation vector

            Spring.SetUnitRotation(unitID, lerp(rx, tr.x, lerpFactor), lerp(ry, tr.y, lerpFactor), lerp(rz, tr.z, lerpFactor))

            Spring.MoveCtrl.SetPosition(unitID, lerp(posx, data.targetPos.x, lerpFactor),
                    lerp(posy, data.relativeHeight , 0.025),
                    lerp(posz, data.targetPos.z, lerpFactor))

            if not idlingPlanes[unitID] and
                    verynear(posx, data.targetPos.x) and verynear(posz, data.targetPos.z) and verynear(posy, data.relativeHeight) then
                idlingPlanes[unitID] = data
            end
        end
    end

    for unitID, data in pairs(idlingPlanes) do
        local posx, posy, posz = Spring.GetUnitPosition(unitID)
        if not data.idleNextFrame or f >= data.idleNextFrame then
            data.idleNextFrame = f + idleUpdateRate
            data.idleXoffset = math.random(-25,25)
            data.idleYoffset = math.random(-25,25)
            data.idleZoffset = math.random(-25,25)
        end
        Spring.MoveCtrl.SetPosition(unitID, lerp(posx, data.targetPos.x + data.idleXoffset, 0.01),
                lerp(posy, data.relativeHeight + data.idleYoffset, 0.01),
                lerp(posz, data.targetPos.z + data.idleZoffset, 0.01))
    end

    for unitID, uDef in pairs(planesToUnpause) do
        -- TODO: Store original rotation (before movectrl.enable) and interpolate/restore it around here
        Spring.MoveCtrl.Disable(unitID)
        Spring.SetUnitVelocity(unitID, 0,0,0)
        planesToUnpause[unitID] = nil
        pausingPlanes[unitID] = nil
        pausedPlanes[unitID] = nil
    end
end
