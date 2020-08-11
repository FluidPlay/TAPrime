--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Cloak Fire State 2",
		desc      = "Sets units to Hold Fire when cloaked, reverts to original state when decloaked",
		author    = "KingRaptor (L.J. Lim)",
		date      = "Feb 14, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = -1,
		enabled   = true  --  loaded by default?
	}
end

local enabled = true
local function CheckEnable()
	if Spring.GetSpectatingState() then
		enabled = false
	else
		enabled = true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Speedups
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitStates    = Spring.GetUnitStates

--local STATIC_STATE_TABLE = {0}
local holdFireState = 0

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local myTeam

local exceptionList = { --add exempt units here
	"armmine1",
	"armmine2",
	"armmine3",
	"armfmine3",
	"cormine1",
	"cormine2",
	"cormine3",
	"cormine4",
	"corfmine3",
	--"corsktl",
	"armpb",
	"armamb",
	--"armpacko",
	--"armsnipe",
}

local exceptionArray = {}
--local CMD_CLOAK = CMD.CLOAK
local CMD_FIRE_STATE = CMD.FIRE_STATE
for _,name in pairs(exceptionList) do
	local ud = UnitDefNames[name]
	if ud then
		exceptionArray[ud.id] = true
	end
end

local cloakUnit = {} --stores the desired fire state when decloaked of each unitID


function widget:UnitCloaked(unitID, unitDefID, teamID)
    local states = GetUnitStates(unitID)
    cloakUnit[unitID] = states.firestate --store last state
    spGiveOrderToUnit(unitID, CMD_FIRE_STATE, holdFireState, 0)
end

function widget:UnitDecloaked(unitID, unitDefID, teamID)
    if not cloakUnit[unitID] then
        return end
    local originalState = cloakUnit[unitID]
    spGiveOrderToUnit(unitID, CMD_FIRE_STATE, originalState, 0) --revert to last state
    cloakUnit[unitID] = nil
    --Spring.Echo("State set: "..targetState)
end

--function widget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams)
--    if not cmdID == 37382 or not enabled or teamID ~= myTeam or exceptionArray[unitDefID] then
--        return
--    end
--    local states = GetUnitStates(unitID)
--    Spring.Echo(" params[1]: "..cmdParams[1].." Curr state: "..states.firestate) --"cmdID: "..cmdID..
--    if cmdParams[1] == 1 then --[[ Cloak ]]
--        cloakUnit[unitID] = states.firestate --store last state
--        Spring.Echo("Stored state: "..states.firestate)
--        if states.firestate ~= 0 then
--            --STATIC_STATE_TABLE[1] = 0
--            local newState = 0
--            spGiveOrderToUnit(unitID, CMD.FIRE_STATE, newState, 0)
--        end
--    else --[[ Decloak ]] --cmdID == 37382 --if cmdParams[1] == 0 then
--        if not cloakUnit[unitID] then
--            return
--        end
--        --local states = GetUnitStates(unitID)
--        if states.firestate == 0 then
--            local targetState = cloakUnit[unitID]
--            --STATIC_STATE_TABLE[1] = targetState
--            spGiveOrderToUnit(unitID, CMD.FIRE_STATE, targetState, 0) --revert to last state
--            Spring.Echo("State set: "..targetState)
--            --Spring.Echo("Unit compromised - weapons free!")
--        end
--        cloakUnit[unitID] = nil
--    end
--end

function widget:PlayerChanged()
	myTeam = Spring.GetMyTeamID()
	CheckEnable()
end

function widget:Initialize()
	myTeam = Spring.GetMyTeamID()
	CheckEnable()
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if (not enabled) then
		return
	end
	if unitTeam == myTeam then
		local states = GetUnitStates(unitID)
		cloakUnit[unitID] = states.firestate
	else
		cloakUnit[unitID] = nil
	end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam)
	widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if cloakUnit[unitID] then
		cloakUnit[unitID] = nil
	end
end
