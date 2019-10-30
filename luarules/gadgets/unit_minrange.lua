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

if not gadgetHandler:IsSyncedCode() then
    return false
end


local spGetUnitWeaponState  = Spring.GetUnitWeaponState
local spSetUnitWeaponState  = Spring.SetUnitWeaponState
local spGetGameFrame        = Spring.GetGameFrame
local spGetUnitRulesParam   = Spring.GetUnitRulesParam
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
    if not ud.customParams or not ud.customParams.minrange then
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
		elseif type(targetType) == "table" then
			--TODO: Calculate distance and block shoot-ground within minrange as well
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

function gadget:UnitDestroyed(unitID)
	trackedUnits[unitID] = nil
end