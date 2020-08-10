function gadget:GetInfo()
    return {
        name      = "Air Patrol = Slowdown",
        desc      = "Makes patrolling units move slower and thus, be easier to control",
        author    = "MaDDoX",
        date      = "Aug 4, 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 100,
        enabled   = true
    }
end

local CMD_STOP = CMD.STOP
local CMD_PATROL = CMD.PATROL
local CMD_MOVE = CMD.MOVE
local CMD_FIGHT = CMD.FIGHT
local CMD_ATTACK = CMD.ATTACK

local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetUnitDefID = Spring.GetUnitDefID

local UPDATE_RATE = 2
local speedReductionFactor = 0.37 --0.66
local isBomber = {
    [UnitDefNames["armthund"].id] = true,
    [UnitDefNames["corshad"].id] = true,
    [UnitDefNames["armpnix"].id] = true,
    [UnitDefNames["corhurc"].id] = true,
    [UnitDefNames["armliche"].id] = true,
    [UnitDefNames["corstil"].id] = true,
}

local slowedDownPlanes = {} -- { unitID = true, ... }

if gadgetHandler:IsSyncedCode() then

    ----====#### SYNCED

    --function gadget:UnitFinished(unitID, unitDefID, teamID)
    --    local unitDef = UnitDefs[unitDefID]
    --    if not unitDef or not unitDef.isAirUnit then
    --        return end
    --    if unitDef.speed ~= nil and unitDef.speed ~= 0 then
    --        Spring.Echo("Added unit: "..unitID)
    --        spSetUnitRulesParam(unitID, "maxSpeed", unitDef.speed)
    --    end
    --end

    local function validSlowdownCmdID(id)
        return id == CMD_PATROL or id == CMD_STOP
    end

    local function validResumeCmdID(id)
        return id == CMD_MOVE or id == CMD_FIGHT or id == CMD_ATTACK
    end

    function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
        --Spring.Echo("cmdID: "..cmdID)
        local unitDef = UnitDefs[unitDefID]
        if not unitDef or not unitDef.isAirUnit or unitDef.hoverAttack or isBomber[unitDefID] then
            return true end
        --local defMaxSpeed = spGetUnitRulesParam(unitID, "maxSpeed")
        local defMaxSpeed = unitDef.speed or 6
        if not defMaxSpeed then
            --Spring.Echo("max Speed not found")
            return true end
        if validSlowdownCmdID(cmdID) and not slowedDownPlanes[unitID] then
            --Spring.Echo("Reducing speed for unit: "..unitID)
            Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxSpeed", defMaxSpeed * speedReductionFactor)
            slowedDownPlanes[unitID] = true
        else if validResumeCmdID(cmdID) and slowedDownPlanes[unitID] then
            --Spring.Echo("Resuming speed for unit: "..unitID)
            Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxSpeed", defMaxSpeed)
            slowedDownPlanes[unitID] = nil
        end
        end
        return true
    end

    ---TODO: Auto-attacking (enemy unit in LOS) should take unit out of slowdown mode
    local function CheckProximityRestore()
        for unitID, _ in pairs(slowedDownPlanes) do
            local x,y,z = Spring.GetUnitPosition(unitID)
            if x and z then
                local unitsNearby = Spring.GetUnitsInCylinder(x,z,850) --TODO: Read 'airlos' from unit and use it here
                for _, otherUID in pairs(unitsNearby) do
                    if not Spring.AreTeamsAllied(Spring.GetUnitTeam(unitID), Spring.GetUnitTeam(otherUID)) then
                        --Spring.Echo("Auto-resuming speed for unit: "..unitID)
                        local unitDefID = Spring.GetUnitDefID(unitID)
                        local unitDef = UnitDefs[unitDefID]
                        local defMaxSpeed = unitDef.speed or 6
                        Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxSpeed", defMaxSpeed)
                        slowedDownPlanes[unitID] = nil
                    end
                end
            end
        end
    end

    function gadget:GameFrame(n)
        if n % UPDATE_RATE < 0.0001 then
            CheckProximityRestore()
        end
    end


    --local function getMaxSpeedFromID(unitID)
    --    local unitDefID = spGetUnitDefID(unitID)
    --    local unitDef = UnitDefs[unitDefID]
    --    if not unitDef or not unitDef.isAirUnit then
    --        return end
    --    return unitDef.speed or 6
    --end

    -- Receives messages from unsynced sent via Spring.SendLuaRulesMsg.
    --function gadget:RecvLuaMsg(msg, playerID)
    --    local mustslowdown = msg:find("mustslowdown:",1,true)
    --    local mustrestore = msg:find("mustrestore:",1,true)
    --    if not mustslowdown and not mustrestore then
    --        return
    --    end
    --    if mustslowdown then -- Msg format: mustslowdown:unitID or mustrestore:unitID
    --        local unitID = tonumber(msg:sub(14))       -- character 14 onwards (after color)
    --        local defMaxSpeed = getMaxSpeedFromID(unitID)
    --        Spring.Echo("Reducing speed for unit: "..unitID)
    --        Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxSpeed", defMaxSpeed * 0.5)
    --        slowedDownPlanes[unitID] = true
    --    else if mustrestore then
    --            local unitID = tonumber(msg:sub(13))       -- character 13 onwards (after color)
    --            local defMaxSpeed = getMaxSpeedFromID(unitID)
    --            Spring.Echo("Resuming speed for unit: "..unitID)
    --            Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxSpeed", defMaxSpeed)
    --            slowedDownPlanes[unitID] = nil
    --        end
    --    end
    --
    --end

else
    ----====#### UNSYNCED

    --local spGetSelectedUnits = Spring.GetSelectedUnits
    --local spGetUnitDefID = Spring.GetUnitDefID
    --
    --local function validSlowdownCmdID(id)
    --    return id == CMD_PATROL or id == CMD_STOP
    --end
    --
    --local function validRestoreCmdID(id)
    --    return id == CMD_MOVE or id == CMD_FIGHT or id == CMD_ATTACK
    --end
    --
    --function gadget:CommandNotify(cmdID, cmdParams, cmdOptions)     --return: bool removeCmd
    -----Called when a command is issued. Returning true DELETES the command and does not send it through the network.
    --    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    --    Spring.Echo("cmdID: "..cmdID)
    --    for _, unitID in ipairs(selUnits) do
    --        local unitDefID = spGetUnitDefID(unitID)
    --        local unitDef = UnitDefs[unitDefID]
    --        if not unitDef or not unitDef.isAirUnit then
    --            return false end
    --        local defMaxSpeed = unitDef.speed or 6
    --        if not defMaxSpeed then
    --            --Spring.Echo("max Speed not found")
    --            return false end
    --        if validSlowdownCmdID(cmdID) then
    --            Spring.Echo("Must reduce speed for unit: "..unitID)
    --            Spring.SendLuaRulesMsg("mustslowdown:"..unitID)
    --        else if validRestoreCmdID(cmdID) then
    --                Spring.Echo("Must restore speed for unit: "..unitID)
    --                Spring.SendLuaRulesMsg("mustrestore:"..unitID)
    --            end
    --        end
    --    end
    --    return false
    --end
end




