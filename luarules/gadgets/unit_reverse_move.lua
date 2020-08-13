function gadget:GetInfo()
    return {
        name = "ReverseMovementHandler",
        desc = "Sets reverse speeds/angles/distances",
        author = "[Fx]Doo, modified by MaDDoX to support slowdown_when_damaged.lua",
        date = "27 of July 2017",
        license = "Free",
        layer = 0,
        enabled = true
    }
end

local spGetUnitRulesParam = Spring.GetUnitRulesParam

if (gadgetHandler:IsSyncedCode()) then
    reverseUnit = {}
    refreshList = {}
    function gadget:UnitCreated(unitID, unitDefID)
        if not (UnitDefs[unitDefID].rSpeed == nil or UnitDefs[unitDefID].rSpeed == 0) then
            reverseUnit[unitID] = unitDefID
            refreshList[unitID] = unitDefID
            Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed", UnitDefs[unitDefID].speed)
            Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed", 0)
        end
    end

    function gadget:UnitDestroyed(unitID) -- Erase killed units from table
        reverseUnit[unitID] = nil
        refreshList[unitID] = nil
    end

    function gadget:Initialize()
        for ct, unitID in pairs(Spring.GetAllUnits()) do
            gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
        end
    end

    function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if reverseUnit[unitID] then
           refreshList[unitID] = unitDefID
        end
    end

    function gadget:UnitIdle(unitID, unitDefID)
        if reverseUnit[unitID] then
           refreshList[unitID] = unitDefID
        end
    end

    function gadget:UnitCmdDone(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
        if reverseUnit[unitID] then
            refreshList[unitID] = unitDefID
        end
    end

    function gadget:GameFrame(f)
        for unitID, unitDefID in pairs(refreshList) do
            local cmd = Spring.GetUnitCommands(unitID, 1)
            local uDef = UnitDefs[unitDefID]

            -- Set final speed and rSpeed values (considering upghandeler_throttle & slowdown_when_damaged)
            local throttleFactor = spGetUnitRulesParam(unitID, "throttleNerf")
            if not throttleFactor then
                throttleFactor = 1
            end
            --
            local damagedSpeed = spGetUnitRulesParam(unitID, "damagedSpeed")
            if not damagedSpeed then
                damagedSpeed = uDef.speed
            end
            damagedSpeed = damagedSpeed * throttleFactor
            --
            local damagedrSpeed = spGetUnitRulesParam(unitID, "damagedrSpeed")
            if not damagedrSpeed then
                damagedrSpeed = uDef.rSpeed
            end
            damagedrSpeed = damagedrSpeed * throttleFactor
            --
            if cmd and cmd[1] and cmd[1]["options"] and cmd[1]["options"].ctrl then
                Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed", damagedSpeed)
                Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed", damagedrSpeed)
            else
                Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed", damagedSpeed)
                Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed", 0)
            end
            refreshList[unitID] = nil
        end
    end
end