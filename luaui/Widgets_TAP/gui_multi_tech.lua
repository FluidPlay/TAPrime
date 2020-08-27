--[[
Synced
	AllowCommand
		button @ TechCenter was clicked
		Can be 'upgrade' or 'cancelupgrade'
	Unit Destroyed - Frees for new updates, change status
	EditCmdDesc
		Change descriptions, unlock buttons

Unsynced
	-> Event "upgrading"
		Right-click processing
	Real-time processing of buttons

]]--

---<< DEPRECATED; check upgradedata_global.lua >>
--[[
*** How the upgrade system works

tech_capture gadget (as an example, there can be many tech_* gadgets):
	- Lock capture button in builders when built and
		upgrade/tech is not available
	- Track builders built
	- Track tech_proxies when they start building and are destroyed
	    - Send message to gui_multi_tech that upgrade is canceled
	- Award upgrade/tech once tech_proxy is finished
		- Destroy tech_proxy after is built
		- Send message to gui_multi_tech that upgrade is done
		- EditCmdDesc / Unlock `capture` in builders

gui_multi_tech widget: (everything that won't be exploitable if disabled goes in widgets)
    - Monitors if upgrade has started and instantly sets flag to block certain clicks on the cmd buttons
	- [upgradeLock="partial"] Locks adding more upgrades to the queue of the tech_proxy-assigned Tech Center
		- But allows removing (right-click)
	- [upgradeLock="full"] Locks clicking the build cmd button of other tech centers than the one assigned to it
	- Receives message from tech_capture that upgrade is done
		- Will set upgradeLock = "full" to all uses of the cmd button

gui_chili_buildordermenu: (actually parses the left- and right-click input
	- Checks WG.checkUpgradeLock(cmdID, unitID) function
	    - Blocks right and/or left clicks at the button

]]--

--function widget:GetInfo()
--   return {
--      name      = "Multi Tech GUI Controller",
--      desc      = "Monitors Upgrade states and feeds it to chili_buildordermenu",
--      author    = "MaDDoX",
--      version   = "v1.0",
--      date      = "Dec, 2018",
--      license   = "GNU GPL, v3 or later",
--      layer     = -100,
--      enabled   = false, --true,
--   }
--end
--
--WG.techIDs = {   -- List of valid TechIDs => cmdIDs
--    ["capture"]=-UnitDefNames["techcapture"].id,
--    ["booster1"]=-UnitDefNames["techbooster1"].id,
--    ["booster2"]=-UnitDefNames["techbooster2"].id,
--    ["booster3"]=-UnitDefNames["techbooster3"].id,
--}
--WG.upgrades = {} -- { techID = { techCenterID, techProxyID, status = "nonupgraded"|"upgrading"|"upgraded" },..}
--local techCentersDefIDs = {
--    [UnitDefNames["armtech"].id] = true,
--    [UnitDefNames["armtech1"].id] = true,
--    [UnitDefNames["armtech2"].id] = true,
--    [UnitDefNames["armtech3"].id] = true,
--    [UnitDefNames["armtech4"].id] = true,
--    [UnitDefNames["cortech"].id] = true,
--    [UnitDefNames["cortech1"].id] = true,
--    [UnitDefNames["cortech2"].id] = true,
--    [UnitDefNames["cortech3"].id] = true,
--    [UnitDefNames["cortech4"].id] = true,
--}
----This is the proxy unit's build CmdID (key) and techID (value)
--WG.techProxycmdIDs = {
--    [-UnitDefNames["techcapture"].id] = "capture",
--    [-UnitDefNames["techbooster1"].id] = "booster1",
--    [-UnitDefNames["techbooster2"].id] = "booster2",
--    [-UnitDefNames["techbooster3"].id] = "booster3",
--}
--
--local techCenters = {}      -- techCenters = { unitID = true, ... }
--
---- internal: was sent from within gui_multi_tech, not from a tech_*.lua gadget
--local function upgradeUIEvent(techID, techCenterID, techProxyID, unitTeam, status, internal)
--    if not WG.techIDs[techID] then
--        Spring.Echo("Invalid TechID found: "..techID) end
--    -- We only care about our own stuff
--    if (not internal) and Spring.GetLocalTeamID() ~= unitTeam then
--        return end
--    WG.upgrades[techID] = { techCenterID = techCenterID, techProxyID = techProxyID, status = status }
--    --Spring.Echo ("gui_multi_tech: tech '"..techID.."' status is now "..status.." on techCenter "..(techCenterID or "nil")
--    --            .." techProxy: "..(techProxyID or "nil"))
--end
--
---- Returns the techID if it's a techProxy unit
--local function checkTechProxy(unitDefID)
--    local uDef = UnitDefs[unitDefID]
--    if not uDef then
--        return false end
--    local techToGrant = uDef.customParams and uDef.customParams.granttech
--    return techToGrant
--end
--
--function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
--    if techCentersDefIDs[unitDefID] then
--        techCenters[unitID] = true
--    end
--    --- If it's a techProxy, fire an upgradeUIEvent to store it and change status to upgrading
--    local techID = checkTechProxy(unitDefID)
--    if techID then
--        --(techID, techCenterID, techProxyID, unitTeam, status)
--        upgradeUIEvent(techID, builderID, unitID, nil,"upgrading", true) --internal, team not needed
--    end
--end
--
----function widget:UnitFinished(unitID, unitDefID, unitTeam)
----
----end
--
--function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
--    techCenters[unitID] = nil
--    --- 'Cancel' has to come from tech_* gadget
--end
--
----    Initialize all upgrades
--function widget:Initialize()
--    widgetHandler:RegisterGlobal('UpgradeUIEvent', upgradeUIEvent)
--    widgetHandler:RegisterGlobal('UpgradeUIEvent2', upgradeUIEvent)
--    widgetHandler:RegisterGlobal('UpgradeUIEvent3', upgradeUIEvent)
--    widgetHandler:RegisterGlobal('UpgradeUIEvent4', upgradeUIEvent)
--    for techID,cmdID in pairs (WG.techIDs) do
--        WG.upgrades[techID] = { techCenterID = nil, techProxyID = nil, status = "nonupgraded" }
--    end
--end
--
--function widget:Shutdown()
--    widgetHandler:DeregisterGlobal('UpgradeUIEvent')
--    widgetHandler:DeregisterGlobal('UpgradeUIEvent2')
--    widgetHandler:DeregisterGlobal('UpgradeUIEvent3')
--    widgetHandler:DeregisterGlobal('UpgradeUIEvent4')
--end
