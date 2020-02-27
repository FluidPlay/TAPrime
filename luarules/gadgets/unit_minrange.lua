function gadget:GetInfo()
	return {
		name		= "Unit Minrange",
		desc		= "Sets minimum attack range for certain unit types",
		author		= "MaDDoX",
		date		= "April 27, 2018",
		license		= "FAIFB (Free as in Free Beer)",
		layer		= 0,
		enabled		= true -- loaded by default?
	}
end
---TODO: Read/Apply the minRange from customDefs
---TODO: Support other weapons, currently only 1st supported (weaponNum == 1)

VFS.Include("gamedata/taptools.lua")

if not gadgetHandler:IsSyncedCode() then
    return false
end

local function istable(x)  return (type(x) == 'table') end

local spGetUnitWeaponState  = Spring.GetUnitWeaponState
local spSetUnitWeaponState  = Spring.SetUnitWeaponState
local spGetGameFrame        = Spring.GetGameFrame
local spGetUnitRulesParam   = Spring.GetUnitRulesParam
local spGetUnitPosition 	= Spring.GetUnitPosition
local spSetUnitRulesParam   = Spring.SetUnitRulesParam
local spGetUnitSeparation   = Spring.GetUnitSeparation
local spGetUnitExperience   = Spring.GetUnitExperience
local spSetUnitMaxRange     = Spring.SetUnitMaxRange
local spGetUnitDefID        = Spring.GetUnitDefID

local trackedUnits = {}

--function gadget:Initialize()
--end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    local ud = UnitDefs[unitDefID]
    if not ud.customParams or not ud.customParams.minrange
        or not ud.weapons or not ud.weapons[1] then
        return end
    -- Store min range and default reload for later processing
    local weapDef = WeaponDefs[ud.weapons[1].weaponDef]
    local defReload = weapDef.reload
    --Spring.Echo(defReload)
    spSetUnitRulesParam(unitID, "minrange", ud.customParams.minrange)
    spSetUnitRulesParam(unitID, "defreload", defReload)
    trackedUnits[unitID] = true		-- "can shoot"
end

function gadget:GameFrame(n)
	if n % 5 > 0.0001 then
		return end

	for unitID, canShoot in pairs(trackedUnits) do
		--- 0 | 1,	bool isUserTarget, number unitID |
		--- 2, 		bool isUserTarget, { number posX, number posY, number posZ } |
		--- 3, 		bool isUserTarget, number ProjectileID
		local targetType, isUserTarget, target = Spring.GetUnitWeaponTarget ( unitID, 1 )
		local dist = nil
		if targetType == 1 then		-- Targeting a unit
			dist = spGetUnitSeparation ( unitID, target, false ) -- unit1, unit2, 2D -> nil | number distance
		end

		if dist then
            -- eg.: thud range = 360, minrange = 130
			if dist < tonumber(spGetUnitRulesParam(unitID, "minrange")) then
				if canShoot then
					trackedUnits[unitID] = false end
				local reloadFrame = spGetUnitWeaponState(unitID, 1, "reloadState")
				spSetUnitWeaponState(unitID, 1, {reloadState = reloadFrame + 30}) -- "lock" it for 1s
			else
				if not canShoot then
					trackedUnits[unitID] = true
					local currFrame = spGetGameFrame()
                    local defReload = spGetUnitRulesParam(unitID, "defreload")
                    if defReload then
                        spSetUnitWeaponState(unitID, 1, {reloadState = currFrame + tonumber(defReload) })
                    else
                        Spring.Echo("unit_minrange: error, default reload not defined")
                    end
				end
			end
			--Spring.Echo("Can Shoot: "..tostring(checkedUnits[unitID]))
		end
	end
end

local function distance(x1,z1,x2,z2)
	local dis = math.sqrt((x1-x2)*(x1-x2)+(z1-z2)*(z1-z2))
	return dis
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
	-- if cmdParams = number, the attack was issued directly on an unit. Not our business here.
	if not trackedUnits[unitID] or cmdID ~= CMD.ATTACK or not istable(cmdParams) then
		return true end
	--DebugTable(cmdParams)
	local x,z = cmdParams[1], cmdParams[3] -- click position | cmdParams[2] = y
    if not isnumber(x) or not isnumber(z) then
        return true
    end
	local minrange = tonumber(spGetUnitRulesParam(unitID, "minrange"))
	local ux, _, uz = spGetUnitPosition(unitID)
	local dist = distance(ux, uz, x, z)
	--Spring.Echo("dist: "..dist)
	if dist < minrange then
		return false
	end
	return true
end

function gadget:UnitDestroyed(unitID)
	trackedUnits[unitID] = nil
end