function widget:GetInfo()
	return {
	name	= "Set target default",
	desc	= "replaces default click from attack to set target, snaps within click radius",
	author	= "BD, Snap by MaDDoX",
	date	= "-",
	license	= "WTFPL",
	layer	= -math.huge,
	enabled	= true,
	}
end

VFS.Include("gamedata/taptools.lua")

local rebindKeys = false

local CMD_UNIT_SET_TARGET = 34923
local CMD_UNIT_CANCEL_TARGET = 34924
local CMD_ATTACK = CMD.ATTACK
local CMD_MOVE = CMD.ATTACK
local CMD_STOP = CMD.ATTACK
local CMD_FIGHT = CMD.FIGHT

local snapRadius = 100
local myAllyTeam = Spring.GetMyAllyTeamID()

local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local IsUnitAllied = Spring.IsUnitAllied
local GetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts
local spGetActionHotKeys = Spring.GetActionHotKeys
local spSendCommmands = Spring.SendCommands
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitDefID = Spring.GetUnitDefID

local hotKeys = {}
local targetSetUnits = {}

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
	if rebindKeys then
		for _, keycombo in ipairs(spGetActionHotKeys("attack")) do
			hotKeys[keycombo] = true
			spSendCommmands({ "unbind " .. keycombo .. " attack", "bind " .. keycombo .. " settarget"})
		end
	end
end

function widget:Shutdown()
    if rebindKeys then
        for keycombo in pairs(hotKeys) do
            spSendCommmands({ "unbind " .. keycombo .. " settarget", "bind " .. keycombo .. " attack"})
        end
    end
    targetSetUnits = nil
end

function widget:UnitDestroyed(unitID)
    targetSetUnits[unitID] = nil
    for sourceID, targetID in pairs(targetSetUnits) do
        if targetID == unitID then
            targetSetUnits[sourceID] = nil
        end
    end
end

--local function hasSetTarget(unitDefID)
--	local ud = UnitDefs[unitDefID]
--	return ud and ( ( ud.canMove and ud.speed > 0 and not ud.canFly and ud.canAttack and ud.maxWeaponRange and ud.maxWeaponRange > 0 ) or ud.isFactory )
--end

local function isBomber(unitID)
    local uDef = UnitDefs[spGetUnitDefID(unitID)]
    return uDef.customParams and uDef.customParams.tedclass and uDef.customParams.func == "bomber"
end

local function AssignSetTarget(targetUID, options)
    if options == nil then
        options = {} end
    for _,unitID in ipairs(spGetSelectedUnits()) do
        spGiveOrderToUnit(unitID, CMD_UNIT_SET_TARGET, { targetUID }, options)
        if not isBomber(unitID) then
            targetSetUnits[unitID] = targetUID
        end
    end
end

function widget:CommandNotify(id, params, options)
    if id == CMD_ATTACK then
        if #params == 1 then    -- Target one UnitID
            AssignSetTarget(params[1], options)
        else                    -- Targetted ground position
            ---#SNAP# If enemy unit is within cylinder/radius of clicked position, assign it as target
            --DebugTable(params)
            local click = { x = params[1], z = params[3] }
            local minSqrDist = 999999999 -- sqrDists usually have 8 digits or more.. :o
            local closestEnemyID = nil
            local unitsAroundClick = spGetUnitsInCylinder(click.x, click.z, snapRadius)
            --Spring.Echo("Units nearby found: "..#unitsAroundClick)
            for _,unitID in ipairs(unitsAroundClick) do
                if spGetUnitAllyTeam(unitID) ~= myAllyTeam then -- It's enemy Unit
                    local eUnitPos = {}
                    eUnitPos.x, eUnitPos.z = spGetUnitPosition(unitID)
                    local sqrDist = sqrDistance(click.x, click.z, eUnitPos.x, eUnitPos.z)
                    if (sqrDist < minSqrDist) then
                        closestEnemyID = unitID
                        minSqrDist = sqrDist
                    end
                end
            end
            if (closestEnemyID) then
                --Spring.Echo("Snapped to: "..closestEnemyID)
                AssignSetTarget(closestEnemyID)
            else    -- No nearby enemy, cancel target.
                for _,unitID in ipairs(spGetSelectedUnits()) do
                    targetSetUnits[unitID] = nil
                    spGiveOrderToUnit(unitID, CMD_UNIT_CANCEL_TARGET, {  }, {}) --CMD_FIGHT { x, y, z }
                end
            end
        end
    end
    --if id == CMD_MOVE or id == CMD_FIGHT or id == CMD_STOP then
    --    for unitID,targetID in pairs(targetSetUnits) do
    --        if IsValidUnit(targetID) then
    --            --Spring.Echo ("Reassigning: "..unitID.." to target: "..params[1])
    --            spGiveOrderToUnit(unitID, CMD_UNIT_SET_TARGET, { targetID }, {}) --TODO: Save options above? not sure
    --        else
    --            targetSetUnits[unitID] = nil
    --        end
    --    end
    --end
    if id == CMD_STOP then
        for unitID,targetID in pairs(targetSetUnits) do
            targetSetUnits[unitID] = nil
            spGiveOrderToUnit(unitID, CMD_UNIT_CANCEL_TARGET, {  }, {}) --CMD_FIGHT { x, y, z }
        end
    end
end

--function widget:DefaultCommand()
--	local mouseX, mouseY, onlyCoords, useMinimap, includeSky, ignoreWater = GetMouseState()
--	local targettype,data = TraceScreenRay(mouseX, mouseY, onlyCoords, useMinimap, includeSky, ignoreWater)
--	if targettype ~= "unit" or IsUnitAllied(data) then
--		return
--	end
--	for unitDefID in pairs(GetSelectedUnitsCounts()) do
--		if hasSetTarget(unitDefID) then
--			return CMD_UNIT_SET_TARGET
--		end
--	end
--end
