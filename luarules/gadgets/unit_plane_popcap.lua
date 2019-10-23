---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 22-Mar-19
---

function gadget:GetInfo()
    return {
        name      = "Plane Popcap",
        desc      = "Locks/unlocks construction of planes according to the amount of existing airpads",
        author    = "MaDDoX",
        date      = "22 March 2019",
        license   = "Whatever is free-er",
        layer     = -1,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetUnitTeam = Spring.GetUnitTeam
    local spGetCommandQueue = Spring.GetCommandQueue
    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
    local spGetGameFrame = Spring.GetGameFrame
    local spDestroyUnit = Spring.DestroyUnit
    local spMarkerAddPoint = Spring.MarkerAddPoint--(x,y,z,"text",local? (1 or 0))
    local spGetUnitPosition = Spring.GetUnitPosition
    local spSendMessageToTeam = Spring.SendMessageToTeam
    --local spSetUnitRulesParam = Spring.SetUnitRulesParam    -- To be used by gui_chili_buildordermenu
    --local spGetUnitRulesParam = Spring.GetUnitRulesParam

    --local color_yellow = "\255\255\255\1"   --yellow

    local pop = {}      -- {[team]=0,..} All planes that count to the plane popcap
    local popcap = {}   -- {[team]=0,..} Increases (per team) when airpads are built, decreases when airpads are destroyed
    local unitsbeingbuilt = {}   -- {unitID,..}
    local unitscompleted = {}

    local planeDefIDs = {
        [UnitDefNames["armfig"].id] = true,
        [UnitDefNames["corveng"].id] = true,
        [UnitDefNames["corshad"].id] = true,
        [UnitDefNames["armpnix"].id] = true,
        [UnitDefNames["corvamp"].id] = true,
        [UnitDefNames["armhawk"].id] = true,
        [UnitDefNames["armthund"].id] = true,
        [UnitDefNames["corstil"].id] = true,
        --[UnitDefNames["corape"].id] = true,
        [UnitDefNames["corhurc"].id] = true,
        --[UnitDefNames["armblade"].id] = true,
    }

    local popcapProviders = {
        [UnitDefNames["armpad"].id] = 1,
        [UnitDefNames["corpad"].id] = 1,
        [UnitDefNames["armap"].id] = 2,
        [UnitDefNames["corap"].id] = 2,
        [UnitDefNames["armaap"].id] = 2,
        [UnitDefNames["coraap"].id] = 2,
        [UnitDefNames["armcarry"].id] = 2,
        [UnitDefNames["corcarry"].id] = 2,
        [UnitDefNames["armasp"].id] = 4,
        [UnitDefNames["corasp"].id] = 4,
    }

    function gadget:Initialize()
        for _, teamID in ipairs(Spring.GetTeamList()) do
            popcap[teamID] = 0
            pop[teamID] = 0
            Spring.SetTeamRulesParam(teamID, "planepopcap", 0, {private=true, allied=false})
            Spring.SetTeamRulesParam(teamID, "planecount", 0, {private=true, allied=false})
        end
    end

    local function popcapUpdated(team)
        if pop[team] < popcap[team] then
            GG.TechGrant("Airpad", team, true)
            --Spring.Echo("Airpad tech GRANTED - planes: ".. pop[team].." popcap: "..popcap[team])
        else
            GG.TechRevoke("Airpad", team)
            --Spring.Echo("Airpad tech revoked..")
        end
        Spring.SetTeamRulesParam(team, "planepopcap", popcap[team], {private=true, allied=false})
        Spring.SetTeamRulesParam(team, "planecount", pop[team], {private=true, allied=false})
    end

    function gadget:unitCreated(unitID) --, unitDefID, unitTeam, builderID)
        unitsbeingbuilt[unitID] = true
    end

    -- This tracks the actual completion of the upgrade/tech-proxy
    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        if spGetGameFrame() <= 1 or not unitTeam then   -- Let's skip pre-spawned units (commanders etc)
            return end

        unitsbeingbuilt[unitID] = nil
        unitscompleted[unitID] = true

        local popcapProvision = popcapProviders[unitDefID]
        if popcapProvision then
            popcap[unitTeam] = popcap[unitTeam] + popcapProvision
            popcapUpdated(unitTeam)
            --Spring.Echo("Popcap provider created: "..unitID.." team: "..unitTeam.." new popcap: "..(popcap[unitTeam] or "nil"))
        end

        if planeDefIDs[unitDefID] then
            pop[unitTeam] = pop[unitTeam] + 1
            popcapUpdated(unitTeam)
            --Spring.Echo("Air unit created: "..unitID.." team: "..unitTeam.." new popcap: "..(popcap[unitTeam] or "nil"))
        end
    end

    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        if not unitscompleted[unitID] then
            return
        end
        unitscompleted[unitID] = nil
        local popcapProvision = popcapProviders[unitDefID]
        if popcapProvision then
            popcap[unitTeam] = math.max(0, popcap[unitTeam] - popcapProvision)
            popcapUpdated(unitTeam)
            --Spring.Echo("Unit destroyed: "..unitID.." team: "..unitTeam.." new popcap: "..(popcap[unitTeam] or "nil"))
        end
        if planeDefIDs[unitDefID] then
            pop[unitTeam] = pop[unitTeam] - 1
            popcapUpdated(unitTeam)
            --Spring.Echo("Air unit destroyed: "..unitID.." team: "..unitTeam.." new popcap: "..(popcap[unitTeam] or "nil"))
        end
    end

    function gadget:UnitGiven(unitID, unitDefID, teamID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end

else
    -----------------
    ---- UNSYNCED
    -----------------
end
