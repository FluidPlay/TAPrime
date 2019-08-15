---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Tech Capture",
        desc      = "Enables an upgradable capture button in builders & commandos",
        author    = "MaDDoX",
        date      = "21 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -100,
        enabled   = false, --true,
    }
end

--GG.RMBclicked = false
--function GG.SetRMBclicked(value)
--    GG.RMBclicked = value
--    --Spring.Echo(value)
--end
--_G.upgradelockedUnits = {}

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    --local spGetAllUnits	= Spring.GetAllUnits
    --local spGetUnitIsCloaked = Spring.GetUnitIsCloaked
    --local spSetUnitStealth = Spring.SetUnitStealth --spSetUnitStealth(unitID, iscloaked)
    local spGetPlayerList = Spring.GetPlayerList
    local spGetPlayerInfo = Spring.GetPlayerInfo
    local spGetUnitHealth = Spring.GetUnitHealth
    local spSetUnitRulesParam = Spring.SetUnitRulesParam
    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
    local spGetGameFrame = Spring.GetGameFrame
    local spDestroyUnit = Spring.DestroyUnit
    local spMarkerAddPoint = Spring.MarkerAddPoint--(x,y,z,"text",local? (1 or 0))
    local spGetUnitPosition = Spring.GetUnitPosition
    local spSendMessageToTeam = Spring.SendMessageToTeam
    --local spSetUnitRulesParam = Spring.SetUnitRulesParam    -- To be used by gui_chili_buildordermenu
    --local spGetUnitRulesParam = Spring.GetUnitRulesParam

    local builderUnits = {}     -- [unitTeam] = { unitID, ... } :: who'll unlock the button when upgrade done
    local techCenters = {}      -- techCenters[ownerTeam][unitID]
    local upgradeState = {}     -- { [unitTeam] = { techCenterID = unitID, techProxyID = unitID,
                                --                  status = "nonupgraded","upgrading","upgraded" }, ... }
    local CMD_CAPTURE = CMD.CAPTURE
    local upgradeName = "capture"

    local color_yellow = "\255\255\255\1"   --yellow

    local builderDefIDs = {
        [UnitDefNames["armck"].id] = true,
        [UnitDefNames["armcv"].id] = true,
        [UnitDefNames["armca"].id] = true,
        [UnitDefNames["corck"].id] = true,
        [UnitDefNames["corcv"].id] = true,
        [UnitDefNames["corca"].id] = true,
        [UnitDefNames["armack"].id] = true,
        [UnitDefNames["armacv"].id] = true,
        [UnitDefNames["armaca"].id] = true,
        [UnitDefNames["corack"].id] = true,
        [UnitDefNames["coracv"].id] = true,
        [UnitDefNames["coraca"].id] = true,
        [UnitDefNames["cormando"].id] = true,
    }

    local techCentersDefIDs = {
        [UnitDefNames["armtech"].id] = true,
        [UnitDefNames["armtech1"].id] = true,
        [UnitDefNames["armtech2"].id] = true,
        [UnitDefNames["armtech3"].id] = true,
        [UnitDefNames["armtech4"].id] = true,
        [UnitDefNames["cortech"].id] = true,
        [UnitDefNames["cortech1"].id] = true,
        [UnitDefNames["cortech2"].id] = true,
        [UnitDefNames["cortech3"].id] = true,
        [UnitDefNames["cortech4"].id] = true,
    }

    local techProxycmdID = -UnitDefNames["techcapture"].id  -- This is the proxy unit's build CmdID

    local function setUpgradeState(teamID, status, techCenterID, techProxyID)
        upgradeState[teamID] = { status = status, techCenterID = techCenterID, techProxyID = techProxyID }
        --Spring.Echo("New State: "..status.." TechProxyID: "..(techProxyID or "nil"))
    end

    local function isUpgradedTeam(teamID)
        return upgradeState[teamID].status == "upgraded"
    end

    local function isTechProxy(unitDefID)
        local uDef = UnitDefs[unitDefID]
        if not uDef then
            return false end
        local techToGrant = uDef.customParams and uDef.customParams.granttech
        return techToGrant == upgradeName
    end

    local function disableTargetUnitsCmd(unitTeam, status)
        if builderUnits[unitTeam] then
            for uID,_ in pairs(builderUnits[unitTeam]) do
                local cmdDescID = spFindUnitCmdDesc(uID, CMD_CAPTURE)
                if cmdDescID then
                    spEditUnitCmdDesc(uID, cmdDescID, {disabled=status}) --, queueing=not status
                end
            end
        end
    end

    -- TODO: This should become an spEditUnitCmdDesc to add a red alert to buttons: "Upgrade already in progress"
    --- Actual blocking should be done in gui_multi_tech, since it's realtime (prevents quick double-clicking from adding)
    --local function disableAllUpgradeButtons(unitTeam, status, uIDexception)
        --if uIDexception then
        --    Spring.Echo("Setting upgrade buttons 'disable' to "..tostring(status).." except "..uIDexception)
        --else
        --    Spring.Echo("Setting upgrade buttons 'disable' to "..tostring(status))
        --end
        --if techCenters[unitTeam] then
        --    for uID, _ in pairs(techCenters[unitTeam]) do
        --        if uIDexception == nil then
        --            disableUpgradeButton(uID, status)
        --        elseif not uID == uIDexception then
        --            disableUpgradeButton(uID, status)
        --        end
        --        --Spring.Echo("Processed: "..uID)
        --    end
        --end
    --end

    --- checks if a given techProxy is this team's in-progress upgrade
    local function isTeamTechProxy(unitID, teamID)
        --Spring.Echo(" Unit: "..(unitID or "nil").." compared to: "..(upgradeState[teamID].techProxyID or "nil"))
        return upgradeState[teamID].techProxyID == unitID
    end

    local function startUpgrade(techProxyID, techCenterID, teamID)
        techCenters[teamID][techCenterID] = true
        spSetUnitRulesParam(techCenterID,"upgrade", 0)
        --Spring.Echo("starting upgrade; techCenter ID: "..(techCenterID or "nil").." techProxy ID: "..(techProxyID or "nil"))
        setUpgradeState(teamID, "upgrading", techCenterID, techProxyID)
        --WG.upgrades = {} -- { techID = { techCenter = unitID, status = "nonupgraded"|"upgrading"|"upgraded", ...},..}
        --[TEST] moved to gui_multi_tech: SendToUnsynced("upgradeEvent", upgradeName, unitID, unitTeam, "upgrading")
    end

    function gadget:Initialize()
        builderUnits = {}
        techCenters = {}
        upgradeState = {}
        -- Initialize upgradeStates for all valid player teams (including AI, if any, and Gaia)
        for _, teamID in ipairs(Spring.GetTeamList()) do
            setUpgradeState(teamID, "nonupgraded", nil, nil)

            techCenters[teamID] = {}
            builderUnits[teamID] = {}
        end
    --    -- From cmd_multi_tech: Makes a command locked until all techs in str_reqs are reached.
    --    --GG.TechSlaveCommand(CMD_UPG_CAPTURE,"Capture")
    end

    local function blockUnit (unitID)
        Spring.SetUnitNoDraw (unitID, true)
        Spring.SetUnitNoSelect (unitID, true)
        Spring.SetUnitNoMinimap (unitID, true)
    end

    function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
        --- If upgrade is already completed, we have nothing to do here
        if not isUpgradedTeam(unitTeam) then
            --- Check for tech proxies being built, to set upgrade state accordingly
            if isTechProxy(unitDefID) then
                startUpgrade(unitID, builderID, unitTeam)
                blockUnit(unitID)
            end
            --- Disable capture button of builders being constructed, if upgrade is not available
            if builderDefIDs[unitDefID] then
                local cmdDescID = spFindUnitCmdDesc(unitID, CMD_CAPTURE)
                if cmdDescID then
                    spEditUnitCmdDesc(unitID, cmdDescID, { disabled=true })
                    builderUnits[unitTeam][unitID] = true
                end
            end
        end
    end

    local function cancelUpgrade(unitTeam)
        setUpgradeState(unitTeam,"nonupgraded", nil, nil)
        --disableAllUpgradeButtons(unitTeam, false)
        SendToUnsynced("upgradeEvent", upgradeName, nil, nil, unitTeam, "nonupgraded")
    end

    function gadget:GameFrame()
        local frame = spGetGameFrame()
        if frame % 5 > 0.001 then
            return end
        --- Check for all team tech proxies progresses (health)
        for _,playerID in ipairs(spGetPlayerList()) do
            --name,active,spectator,teamID,allyTeamID,ping
            local teamID = select(4, spGetPlayerInfo(playerID))
            --upgradestate { [unitTeam] = { techCenterID = unitID, techProxyID = unitID,
            --                 status = "nonupgraded"|"upgrading"|"upgraded" }, ... }
            if upgradeState[teamID] and upgradeState[teamID].status == "upgrading" then
                local techProxyID = upgradeState[teamID].techProxyID
                -- health, maxHealth, paralyzeDamage, captureProgress, buildProgress
                local buildProgress = select(5, spGetUnitHealth(techProxyID))
                spSetUnitRulesParam(upgradeState[teamID].techCenterID,"upgrade", buildProgress)
            end
        end
    end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
        ----Below returns a given cmdID index in the command queue
        ----local cmdIndex = Spring.GetCmdDescIndex(-UnitDefNames.peewee.id)
        ----Spring.Echo("cmdID: "..cmdID.." techproxy: "..techProxycmdID)
        ----Spring.Echo("Params & Options: "..#cmdParams,#cmdOptions)
        --Spring.Echo("cmdID: "..cmdID)
        if cmdID ~= techProxycmdID then
            return true
        end
        --- If team is already upgraded, don't allow command to go on
        if isUpgradedTeam(unitTeam) then
            return false end
        --- Otherwise, that's an upgrade command, allow it
        --startUpgrade(unitID, techCenterID, unitTeam) -- Done by the instantiation of tech proxy
        return true
    end

    -- This tracks the actual completion of the upgrade/tech-proxy
    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        if spGetGameFrame() <= 1 or not unitTeam then   -- Let's skip pre-spawned units (commanders etc)
            return end

        --- Let's now check if it's our target-tech proxy unit
        if not isTeamTechProxy(unitID, unitTeam) then
            return end

        --- Upgrade is complete, wrap things up
        local x,y,z = spGetUnitPosition(unitID)
        if x and y and z then
            spMarkerAddPoint(x,y,z,"", true) -- local message/marker
            spSendMessageToTeam(unitTeam, color_yellow.."Upgrade Finished: ".. upgradeName)
        end

        SendToUnsynced("upgradeEvent", upgradeName, nil, nil, unitTeam, "upgraded")
        -- disable upgrade progress bar
        spSetUnitRulesParam(upgradeState[unitTeam].techCenterID,"upgrade", nil)
        setUpgradeState(unitTeam, "upgraded", nil, nil)
        spDestroyUnit(unitID,false,true)    -- Remove the proxy unit instantly (won't deadlock since TechProxyId was set to nil)

        disableTargetUnitsCmd(unitTeam, false)      -- Enables capture buttons of all existing/tracked builders
        -- These are of no interest anymore, clean it up
        builderUnits[unitTeam] = nil
        techCenters[unitTeam] = nil
    end

    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        --Spring.Echo("Unit destroyed: "..unitID.." state techCenter: "..(upgradeState[unitTeam].techCenterID or "nil")
        --            .." techProxy: "..(upgradeState[unitTeam].techProxyID or "nil"))

        -- An under-construction tech proxy was destroyed or cancelled
        if isTeamTechProxy(unitID, unitTeam) then
            --Spring.Echo("WIP tech proxy destroyed, team: "..unitTeam)
            cancelUpgrade(unitTeam)
        -- Below is never happening, probably because the techProxy is destroyed first
        elseif upgradeState[unitTeam].techCenterID == unitID then
            --Spring.Echo("WIP upgrade's tech center destroyed")
            cancelUpgrade(unitTeam)
        end
        if techCenters[unitTeam] then
            techCenters[unitTeam][unitID] = nil end
        if builderUnits[unitTeam] then
            builderUnits[unitTeam][unitID] = nil end
    end

    function gadget:UnitGiven(unitID, unitDefID, teamID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end

else
-----------------
---- UNSYNCED
-----------------

    local function handleUpgradeEvent(cmd, techID, techCenterID, techProxyID, unitTeam, status)
        ---- Now we create an event at unsynced space
        if Script.LuaUI('UpgradeUIEvent') then
            Script.LuaUI.UpgradeUIEvent(techID, techCenterID, techProxyID, unitTeam, status)
            --Spring.Echo("Sent event about "..unitID)
        end
    end

    ---- Wiring SendToUnsync message "upgradeEvent" to the unsync'd "handle..." method
    function gadget:Initialize()
        gadgetHandler:AddSyncAction("upgradeEvent", handleUpgradeEvent)
    end

    function gadget:Shutdown()
        gadgetHandler:RemoveSyncAction("upgradeEvent")
    end

    --local spGetMouseState = Spring.GetMouseState
    --local spTraceScreenRay = Spring.TraceScreenRay
    --local spAreTeamsAllied = Spring.AreTeamsAllied
    --local spGetUnitTeam = Spring.GetUnitTeam
    --local spGetUnitDefID = Spring.GetUnitDefID
    --local spGetSelectedUnits = Spring.GetSelectedUnits
    --local CMD_CAPTURE = CMD.CAPTURE

    --local setRMBclicked = GG.SetRMBclicked

    --function gadget:MousePress(x, y, button)
    --    GG.SetRMBclicked(button == 3)
    --    return false
    --end

    -- button parameter values: left - 1, middle - 2, right - 3
    --function gadget:MouseRelease(x, y, button)
    --    --GG.SetRMBclicked(button == 3)
    --end

    --local techProxycmdID = -UnitDefNames["techcapture"].id  -- This is the proxy unit's build CmdID
    --
    --local function isTechProxy(unitDefID)
    --    local uDef = UnitDefs[unitDefID]
    --    if not uDef then
    --        return false end
    --    local techToGrant = uDef.customParams and uDef.customParams.granttech
    --    return techToGrant == checkedTech
    --end
    --
    --function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    --    if not unitTeam then
    --        return end
    --
    --    if isTechProxy(unitDefID) then
    --        UpgradingTechCenter[unitTeam] = nil
    --    end
    --end
    --
    --local strUnit = "unit"
    --
    --local geothermalsDefIDs = {
    --    [UnitDefNames["armgeo"].id] = true,
    --    [UnitDefNames["amgeo"].id] = true,
    --    [UnitDefNames["armgmm"].id] = true,
    --}
    --
    --function gadget:DefaultCommand()
    --    local function isGeothermal(unitDefID)
    --        return geothermalsDefIDs[unitDefID]
    --    end
    --    local mx, my = spGetMouseState()
    --    local s, targetID = spTraceScreenRay(mx, my)
    --    if s ~= strUnit then
    --        return false end
    --
    --    --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
    --    --    return false
    --    --end
    --
    --    -- Only proceed if target is one of the geothermal variations
    --    local targetDefID = spGetUnitDefID(targetID)
    --    if not isGeothermal(targetDefID) then
    --        return false end
    --
    --    -- If any of the selected units is a commander, default to 'capture'
    --    local sUnits = spGetSelectedUnits()
    --    for i=1,#sUnits do
    --        local unitID = sUnits[i]
    --        --TODO: Should become `all capture-enabled units` (with the upgrade)
    --        if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
    --            return CMD_CAPTURE
    --        end
    --    end
    --    return false
    --end

end
