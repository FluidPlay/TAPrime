--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_blockassist.lua
--  brief:   Blocks the assist function from some construction units (basic, ground and air)
--  author:  Breno "MaDDoX" Azevedo
--  Special Thanks: Gajop, for pointing out LuaMsg for unsynced->synced communication
--
--  Copyright (C) 2017
--  Licensed under the terms of the GNU GPL, v2 or later
--
--  Caveats: Area repair is disabled and All repair orders during pause are ignored
--  TBD (WIP code at bottom): Allow Area Repair unless there's a factory in the radius
--  TBD (WIP code at bottom): We could use DefaultCommand to replace repair by 'move' when blocked
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- https://springrts.com/phpbb/viewtopic.php?f=23&t=23359
-- (CMDs) https://springrts.com/wiki/Lua_CMDs
-- (UnitCommand) https://springrts.com/phpbb/viewtopic.php?t=34594
-- -- https://springrts.com/wiki/LuaCallinReturn
-- (Default Action) https://springrts.com/phpbb/viewtopic.php?t&t=26438
-- -- https://springrts.com/phpbb/viewtopic.php?t=33319
-- (Stop means Stop - SelfD Replace) https://springrts.com/wiki/Lua:Tutorial_GettingStarted
-- (Trace ScreenRay) https://springrts.com/wiki/Lua_UnsyncedRead

-- (RecvLuaMsg) https://github.com/ZeroK-RTS/Zero-K/blob/master/LuaRules/Gadgets/start_unit_setup.lua

--return: bool actionAllowed
--
--Called when a construction unit wants to "use his nano beams".
--action is one of following:
-- -1 = Build
-- CMD.REPAIR = Repair
-- CMD.RECLAIM = Reclaim
-- CMD.RESTORE = Restore
-- CMD.RESURRECT = Resurrect
-- CMD.CAPTURE = Capture

function gadget:GetInfo()
    return {
        name      = "Assist Blocker",
        desc      = "Blocks the assist command from basic construction units",
        author    = "MaDDoX",
        date      = "Dec, 2017",
        license   = "GNU GPL, v2 or later",
        layer     = 510,
        enabled   = true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spRemoveUnitCmdDesc = Spring.RemoveUnitCmdDesc
local spGetGameFrame       	= Spring.GetGameFrame
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetSelUnitCount = Spring.GetSelectedUnitsCount
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetSpectatingState = Spring.GetSpectatingState
local spGetMouseState = Spring.GetMouseState
local spTraceScreenRay = Spring.TraceScreenRay
local spGetUnitDefID = Spring.GetUnitDefID
local spGetTeamResources = Spring.GetTeamResources

local CMD_FIGHT    	= CMD.FIGHT
local CMD_ATTACK    = CMD.ATTACK
--local CMD_WAIT    	= CMD.WAIT
--local CMD_MOVE     	= CMD.MOVE
local CMD_PATROL  	= CMD.PATROL
local CMD_REPAIR    = CMD.REPAIR
--local CMD_INSERT    = CMD.INSERT
local CMD_REMOVE    = CMD.REMOVE
local CMD_RECLAIM	= CMD.RECLAIM
local CMD_GUARD		= CMD.GUARD
--local CMD_STOP		= CMD.STOP

-- These are the builders DefIDs to be assist-blocked
local builderDefIDs = {
    UnitDefNames.armck.id, UnitDefNames.corck.id, UnitDefNames.armcv.id, UnitDefNames.corcv.id,
    UnitDefNames.armca.id, UnitDefNames.corca.id, UnitDefNames.armcs.id, UnitDefNames.corcs.id,
}
local mobileUnitsBeingBuilt = {}     -- { unitID, ... }
local basicBuilderUnits     = {}     -- { unitID, ... }
local PausedPlayers         = {}     -- { [playerID]=pausedState, ... }

GG.JustFinishedBuilders = {}

local nextUpdate = 30

--Returns if the uDef is from a basic builder or not
local function IsBasicBuilder(uDefID)
    --Spring.Echo(tostringplus(udef))
    for i = 1, #builderDefIDs do
        if (builderDefIDs[i] == uDefID) then
            return true end
    end
    return false
end

-- Check if it's Poker (Armfav)
local function IsArmFav(uDefID)
    return uDefID == UnitDefNames.armfav.id
end

local function IsWIPMobileUnit(uID)
    for _,v in ipairs(mobileUnitsBeingBuilt) do
        if v == uID then
            return true end
    end
    return false
end

--local function IsJustFinishedBuilder(uID)
--    for _,v in ipairs(GG.JustFinishedBuilders) do
--        -- = {unitID=unitID, cleanupFrame=spGetGameFrame()+2}
--        if v.unitID == uID then
--            return true end
--    end
--    return false
--end

--If the uID is from an existing basic builder
-- -- Not currently in use (just checking type)
--local function IsBasicBuilder(uID)
--    for i = 1, #basicBuilderUnits do
--        if (basicBuilderUnits[i] == uID) then
--            return true end
--    end
--    return false
--end

---- #################  SYNCED

if gadgetHandler:IsSyncedCode() then

    --region temp

    local newlineChar = "\b"	--was: \011 (FF) - "vertical tab" char, to allow proper parsing from spreadsheets
    local tabChar = "\t" 		--This can be replaced by another tabulation char if desired
    local function tostringplus(t, indent, sep, nl, text, osign, csign)
        if t == nil then
            return ""
        end
        if indent == nil then
            indent = ""
        end
        if sep == nil then
            sep = "="
        end
        if nl == nil then
            nl = ","..newlineChar
        end
        if text == nil then
            text = ""
        end
        if osign == nil then
            osign = "{"..newlineChar
        end
        if csign == nil then
            csign = "}"	-- comma is added automatically by the overarching routine
        end

        if type(t) == "string" then
            text = '"'..t..'"'
        else
            if type(t) == "table" then
                local outerind = indent
                text = text..osign

                indent = indent .. tabChar
                for k,v in pairs(t) do
                    if type(k) == "number" then
                        --iPairs don't need the explicit index
                        text = text..indent..tostringplus(v, indent) --, sep, nl, text, osign, csign, indent)
                                .. nl
                    else
                        text = text..indent..tostring(k, indent) --, sep, nl, text, osign, csign, indent)
                                -- TODO: the first 'sep' below shouldn't be added after a 'close sign'
                                .. sep ..tostringplus(v, indent) --, sep, nl, text, osign, csign, indent)
                                .. nl
                    end
                end

                text = text..outerind..csign
            else
                text = text..tostring(t)
            end
        end

        return text
    end
    --endregion

    local pointedUid = nil              -- That's the pointed unit Uid or nil (if no unit being pointed)

    --function gadget:Initialize()
    --end

    -- Used to remove an element from an itable where the inner param unitID equals to a certain value
    function RemoveUnitFromTable(table, unitID)
        for _, v in ipairs(table) do
            if v.unitID == unitID then
                ipairs_remove(table, v)
            end
        end
    end

    function gadget:Initialize()
        GG.JustFinishedBuilders = {}
        nextUpdate = spGetGameFrame() + 30
    end

    function gadget:PlayerChanged()
        if spGetSpectatingState() then
            widgetHandler:RemoveWidget()
        end
    end

    function gadget:RecvLuaMsg(msg, playerID) -- Receives messages from unsynced sent via Spring.SendLuaRulesMsg.
        --Spring.Echo("Message received: "..msg)
        -- if playerID ~= myPlayerID ?
        if msg:find("pointedunit:",1,true) then     -- Msg format (eg) - "pointedunit:0234"
            pointedUid = tonumber(msg:sub(13))      -- after colon
        elseif msg:find("nopointedunit",1,true) then
            pointedUid = nil
        end
    end

    -- Here's where we truly block orders
    function gadget:AllowCommand(unitID, unitDefID, teamID, cmd, params, options, tag, synced)
        --
        --if cmd == CMD_RECLAIM then
        --    Spring.Echo("Reclaim found")
        --    -- If it's a feature or enemy unit allow auto-reclaim
        --    local targetID = params[1]
        --    --// If Params #2 doesn't exist = invalid command; Param #5 exists = area-reclaim (ie., ignore)
        --    if (not params[2]) or (params[5]) then
        --        targetID = params[1]
        --        --// If it's an enemy unit, let it be reclaimed no matter what
        --        if Spring.ValidUnitID(targetID) then
        --            return true end
        --
        --        local featureID = targetID - Game.maxUnits
        --        if ((featureID >= 0) and Spring.ValidFeatureID(featureID))  then
        --            -- Validate for resources. If it's above 70% metal or energy, abort
        --            local currentM, currentMstorage = spGetTeamResources(teamID, "metal") --currentLevel, storage, pull, income, expense
        --            local currentE, currentEstorage = spGetTeamResources(teamID, "energy")
        --            if currentM <= currentMstorage * 0.7 and currentE <= currentEstorage * 0.7 then
        --                Spring.Echo("Reclaim validated")
        --                return true
        --            else
        --                Spring.Echo("Auto-reclaim cancelled")
        --                return false
        --            end
        --        end
        --    end
        --end


        -- [[Assist blocking]] Only basic builders and Pokers interest us here
        if not IsBasicBuilder(unitDefID) and not IsArmFav(unitDefID) then
            return true
            -- The following are always blocked for basic builders
        elseif cmd == CMD_FIGHT then   -- cmd == CMD_ATTACK or cmd == CMD.GUARD or --cmd == CMD.PATROL or --cmd == CMD.RESTORE)
            return false
            -- Repair orders during pause should be ignored, period (we can't track mousepos during pause)
        elseif cmd == CMD_REPAIR then
            --1 parameter in return (unitid) or 4 parameters in return (mappos+radius) | area repair
            if #params ~= 1 or PausedPlayers[teamID] then    -- Area Repair
                return false end
            if IsArmFav(unitDefID) then
                local targetuDef = UnitDefs[spGetUnitDefID(params[1])]
                return targetuDef.isImmobile  -- Can't repair mobile units
            end -- It's a basic builder
            return not IsWIPMobileUnit(params[1])
        elseif cmd == CMD_GUARD then
            -- Area guard not allowed (also doesn't exist?)
            if #params ~= 1 or PausedPlayers[teamID] then
                return false end
            local targetuID = params[1]
            local targetuDef = UnitDefs[spGetUnitDefID(targetuID)]      --local unitDef = UnitDefs[unitDefID]
            if IsArmFav(unitDefID) then
                return targetuDef and targetuDef.isImmobile or false -- Can't guard mobile units
            end
            local advBuilder = targetuDef.isBuilder and not IsBasicBuilder(targetuDef.id)
            return (not IsWIPMobileUnit(targetuID) and not targetuDef.isFactory and not advBuilder)
            --elseif pointedUid then
            --    -- If pointedUid is a WIP mobile unit block it
            --    if IsWIPMobileUnit(pointedUid) then
            --        return false
            --    end
            --    -- If pointedUid is a factory also block it
            --    local uDef = UnitDefs[spGetUnitDefID(pointedUid)]
            --    if uDef.isFactory or uDef.isBuilder then
            --        return false end
            --else
            --    return true end
            --return true
        end
        return true --- <=== All other builder commands (DON'T REMOVE this!)
    end

--    -- Fired after allow command. We can intercept and filter repair and prevent assist-build here
--    function gadget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
--        if cmdID == CMD_REPAIR then   -- repair or assist-build
--            local targetuID = cmdParams[1]
--            --local targetuDef = UnitDefs[spGetUnitDefID(targetuID)]
--            if IsWIPMobileUnit(targetuID) then
--                Spring.Echo("WIP Mobile unit detected")
--                -- Below won't work 'coz during UnitCommand the command is not yet in the unit queue..
--                spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD.REPAIR}, {"alt"})
--            end
--        end
--    end

    -- Fired whenever a unit starts being built
    function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
        local function RemoveCmd(cmd)
            local cmdDescID = spFindUnitCmdDesc(unitID, cmd)
            spRemoveUnitCmdDesc(unitID, cmdDescID)
        end

        if IsBasicBuilder(unitDefID) then
            basicBuilderUnits[#basicBuilderUnits +1] = unitID
            --RemoveCmd(CMD.GUARD) --RemoveCmd(CMD.PATROL) --RemoveCmd(CMD.REPAIR) --RemoveCmd(CMD.RESTORE)
            --RemoveCmd(CMD_ATTACK)
            RemoveCmd(CMD_FIGHT)
            RemoveCmd(CMD_PATROL)
        end

        -- If unit just created is a mobile unit, add it to array
        local uDef = UnitDefs[unitDefID]
        if not uDef.isImmobile then
            mobileUnitsBeingBuilt[#mobileUnitsBeingBuilt +1] = unitID
        end
    end

    -- Fired once a unit finishes building
    function gadget:UnitFinished(unitID, unitDefID, teamID)
        if UnitDefs[unitDefID].isBuilding == false then
            ipairs_remove(mobileUnitsBeingBuilt, unitID)
        end
        -- If finished unit is a builder, we must manually remove any guard/fight order or else it inherits from fac
        -- We'll do it after a couple frames, though; that's required so factory inheritance don't override it
        if IsBasicBuilder(unitDefID) then
            GG.JustFinishedBuilders[#GG.JustFinishedBuilders +1] = {unitID=unitID, cleanupFrame=spGetGameFrame()+2}
        end
    end

    -- When unit destroyed, remove it from control tables if needed
    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        if IsBasicBuilder(unitDefID) then
            ipairs_remove(basicBuilderUnits, unitID)
        end
        if UnitDefs[unitDefID].isBuilding == false then
            ipairs_remove(mobileUnitsBeingBuilt, unitID)
        end
        ipairs_removeByElement(GG.JustFinishedBuilders,"unitID", unitID)
        --RemoveUnitFromTable(GG.JustFinishedBuilders, unitID)
    end

    -- Warn when commands were issued during pause
    function gadget:GamePaused(playerID, paused)
        PausedPlayers[playerID]=paused
    end

    function gadget:UnitGiven(unitID,unitDefID,teamID,cmd,params,options,tag,synced)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end

    function gadget:GameFrame(thisFrame)
        for _, v in ipairs(GG.JustFinishedBuilders) do
            local unitID = v.unitID
            if thisFrame > v.cleanupFrame then
                ipairs_removeByElement(GG.JustFinishedBuilders,"unitID", unitID)
                if IsValidUnit(unitID) then
                    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_REPAIR}, {"alt"})
                    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_GUARD}, {"alt"})
                    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL}, {"alt"})
                end
                --Spring.Echo("blockassist: Repairs removed from: "..unitID)
                --RemoveUnitFromTable(GG.JustFinishedBuilders, unitID)
            end
        end
    end

else
---- #################  UNSYNCED

    function gadget:GameFrame(thisFrame)
        --Spring.Echo(" Just finished builders: "..#GG.JustFinishedBuilders)
        if ( thisFrame < nextUpdate ) then
            return end

        nextUpdate = thisFrame + 3	            -- try again in a few frames

        --// Get target (click) info
        local mx,my = spGetMouseState()
        local type, targetUID = spTraceScreenRay(mx,my)
        if type == "unit" then
            Spring.SendLuaRulesMsg("pointedunit:"..targetUID)
        else
            Spring.SendLuaRulesMsg("nopointedunit")
        end
    end

    ------(Deprecated) Old 'continuous remove order' method
    ----if (unitsBeingBuilt[targetUID] ~= null or uDef.isFactory) then
    ----    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_REPAIR}, {"alt"})
    ----    return false
    ----end


    --function gadget:CommandNotify(cmdID, cmdParams, cmdOpts)
    --    Spring.Echo ( "CommandNotify: (ID, #pararms, #cmdOpts, #sel) "..cmdID , #cmdParams , #cmdOpts, spGetSelUnitCount() )
    --    for i = 1, #cmdParams do
    --        Spring.Echo("param "..i..": "..cmdParams[i])
    --    end
    --end

    --function gadget:CommandNotify(cmdID, cmdParams, cmdOpts)
    --    Spring.Echo ( "CommandNotify: (ID, #pararms, #cmdOpts, #sel) "..cmdID , #cmdParams , #cmdOpts, spGetSelUnitCount() )
    --    for i = 1, #cmdParams do
    --        Spring.Echo("param "..i..": "..cmdParams[i])
    --    end
    --    --local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    --    local allUnits = Spring.GetAllUnits()
    --    for _, unitID in ipairs(allUnits) do
    --
    --        --local cmdQueue = Spring.GetUnitCommands(unitID)
    --        --local cmdTag
    --        --if (#cmdQueue>0) then
    --        --    cmdTag = cmdQueue[1].tag
    --        --    --Spring.Echo("cmdTag: "..cmdTag)
    --        --end
    --
    --        if IsJustFinishedBuilder(unitID) then
    --            --if not IsTrackedUnit(unitID) then
    --            --    return end
    --            --orderId = CMD_REMOVE --  options.ALT -> use the parameters as commandIDs --  params[0 ... N-1] = commandIDs to remove
    --            spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_REPAIR}, {"alt"})
    --            spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_GUARD}, {"alt"})
    --            spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL}, {"alt"})
    --            --spGiveOrderToUnit(unitID, CMD.REMOVE, {1, cmdTag}, {}) --CMD.REPAIR, {"alt"}
    --            --outposts[unitID] = "build"
    --
    --            Spring.Echo("blockassist: Repairs removed")
    --            ipairs_remove(GG.JustFinishedBuilders, unitID)
    --        end
    --    end
    --end

    -- TBD: We could use DefaultCommand to replace repair by 'move' when blocked
    ---- type = "unit" or "feature"; id = unitID or featureID
    --function gadget:DefaultCommand(type, id)
    --    if (type ~= "unit") then
    --        return end
    --    --local issueruDef = UnitDefs[Spring.GetUnitDefID(id)]
    --
    --
    --    local selected = Spring.GetSelectedUnits()
    --    --                and #selected == 1
    --    if (not selected or not selected[1]) then
    --        return end
    --    local unitDef = UnitDefs[Spring.GetUnitDefID (selected[1])]
    --    --Spring.Echo("UnitDef name: "..unitDef.humanName)
    --    if (unitDef.id ~= UnitDefNames.armck.id and
    --            unitDef.id ~= UnitDefNames.corck.id) then
    --        return end
    --
    --    --// Get target (click) info. If factory, default to move (vs repair)
    --    local mx,my = Spring.GetMouseState()
    --    local type, targetUID = Spring.TraceScreenRay(mx,my)
    --    if type == "unit" then
    --        local uDef = UnitDefs[Spring.GetUnitDefID(targetUID)]
    --        --Spring.Echo("target is unit, uDef.name: "..uDef.name.." uID: ".. targetUID) --(uDef.category or " null "))
    --        --if (uDef.isFactory) then
    --        if (unitsBeingBuilt[targetUID] ~= null) then
    --            return CMD.MOVE
    --        end
    --        local curhealth, maxhealth = Spring.GetUnitHealth(targetUID)
    --        --Spring.Echo("target: fac "..(tostring(uDef.isFactory) or "null ").." health: "..curhealth, maxhealth)
    --        -- Factories not on full health can't be guarded, or else they're assisted
    --        if (uDef.isFactory and curhealth >= maxhealth) then
    --            return CMD.MOVE
    --        end
    --    end
    --end

    -- TBD: Allow area repair unless there's a factory there
    --if cmd == CMD_IF_UNIT_IN_AREA then
    --    local tcid,tudid,x,y,z,radius,blocking=unpack(params)
    --    local closest_d,closest_u
    --    if not UnitDefs[tudid] then
    --        Spring.Echo("CMD_IF_UNIT_IN_AREA: not a valid unitDefID",tudid)
    --        return false
    --    end
    --    --Spring.Echo("CMD_IF_UNIT_IN_AREA: looking for a "..UnitDefs[tudid].name.." at ",x,y,z," in radius ",radius," blocking=",blocking)
    --    for _,u in ipairs(Spring.GetUnitsInCylinder(x,z,radius)) do
    --        if Spring.GetUnitDefID(u)==tudid then
    --            local ux,_,uz=Spring.GetUnitPosition(u)
    --            local d=(ux-x)^2+(uz-z)^2
    --            if (closest_u==nil) or (d<closest_d) then
    --                closest_u=u
    --                closest_d=d
    --            end
    --        end
    --    end
    --    if closest_u and not Spring.GetUnitIsDead(closest_u) then
    --        table.insert(Orders,{unit=u,cmd=tcid,params={closest_u},options={}})
    --        return true,true
    --    else
    --        return true,tonumber(blocking)==0
    --    end
    --end
end