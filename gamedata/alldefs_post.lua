--------------------------
-- DOCUMENTATION
-------------------------

-- TAPrime, like BA, contains weapondefs in its unitdef files
-- Standalone weapondefs are only loaded by Spring after unitdefs are loaded
-- So, if we want to do post processing and include all the unit+weapon defs, and have the ability to bake these changes into files, we must do it after both have been loaded
-- That means, ALL UNIT AND WEAPON DEF POST PROCESSING IS DONE HERE

-- What happens:
-- unitdefs_post.lua calls the _Post functions for unitDefs and any weaponDefs that are contained in the unitdef files
-- unitdefs_post.lua writes the corresponding unitDefs to customparams (if wanted)
-- weapondefs_post.lua fetches any weapondefs from the unitdefs, 
-- weapondefs_post.lua fetches the standlaone weapondefs, calls the _post functions for them, writes them to customparams (if wanted)
-- strictly speaking, alldefs.lua is a misnomer since this file does not handle armordefs, featuredefs or movedefs

VFS.Include("gamedata/taptools.lua")
local unitDefsData = VFS.Include("gamedata/configs/unitdefs_data.lua")
VFS.Include("gamedata/taptools.lua")
--local function istable(x)  return (type(x) == 'table') end

-- Switch for when we want to save defs into customparams as strings (so that a widget can then write them to file)
-- The widget to do so can be found in 'etc/Lua/bake_unitdefs_post'
SaveDefsToCustomParams = false

-- Might be commented out, only meant for generating this table and feed weapondamagetypes.lua (@weapondefs_post)
WeaponDamageTypes = {}

local damageTypes = VFS.Include("gamedata/configs/damagetypes.lua")
local damageMults = VFS.Include("gamedata/configs/damagemultipliers.lua")
local weaponDmgTypes = VFS.Include("gamedata/configs/weapondamagetypes.lua")


-- [DEPRECATED with v1 lua core] Spring.Utilities setup
    --Spring.Utilities = Spring.Utilities or {}
    --VFS.Include("LuaRules/Utilities/utilities_emul.lua")
    --CopyTable = Spring.Utilities.CopyTable
    --MergeTable = Spring.Utilities.MergeTable
local minimumbuilddistancerange = 155

-------------------------
-- DEFS POST PROCESSING
-------------------------

local function ApplyGroupCosts(name, uDef)
    if not uDef.customparams then
        return  end
    local groupSize = tonumber(uDef.customparams.groupdef__size)
	if not groupSize then
        return end

	local groupSize = groupSize or 1
    --Spring.Echo(uDef.name .." Group Size: "..groupSize)
	if (uDef.buildcostmetal ~= nil) then
		uDef.buildcostmetal = uDef.buildcostmetal * groupSize
		--Spring.Echo(uDef.name.." group size = "..groupSize..", final metal cost: "..uDef.buildcostmetal)
	end
	if (uDef.buildcostenergy ~= nil) then
		uDef.buildcostenergy = uDef.buildcostenergy * groupSize end
	if (uDef.buildtime ~= nil) then
		uDef.buildtime = uDef.buildtime * groupSize end
end

-- process unitdefs
function UnitDef_Post(name, uDef)
	ApplyUnitDefs_Data(name, uDef)
	-- Any post processing after unitdefs_data.lua is applied should come after this
	ApplyGroupCosts(name, uDef)
	-- [deprecated, now done straight in ssheet] Add reverse move to units with customDef allowreversemove defined as true
	--if uDef.speed and uDef.customParams then -- and uDef.customParams.allowreversemove == "1"
	--	Spring.Echo(name.." has allowreversemove.")
	--	uDef.rSpeed = uDef.speed * 0.6
	--end
    --Set a minimum for builddistance
    if uDef.builddistance ~= nil and uDef.builddistance < minimumbuilddistancerange then
        uDef.builddistance = minimumbuilddistancerange
    end
    if uDef.maxreversevelocity ~= nil then
        --Spring.Echo("Found reverse velocity "..tonumber(uDef.maxreversevelocity).." on unit "..name)
    end
end

--These parameter before/after combinations should not allow updating the uDef:
--was: nil  now: 0, false, {}, ""
local function shouldIgnore(was, now)
	if was ~= nil then
		return false end
	--if (type(now)=="number" and now == 0) then
	--	return true end
	--if (type(now)=="boolean" and now == false) then
	--	return true end
	if (type(now)=="table" and now == {}) then
		return true end
	if (type(now)=="string" and now == "") then
		return true end

	return false
end

-- Here's where the actual spreadsheet-exported data (UnitDefs_Data) is applied to the UnitDefs used in game
function ApplyUnitDefs_Data(name, uDef)
	if (unitDefsData == nil) then
		return end
	for idx, uData in pairs(unitDefsData.data) do
		if type(uData) == "table" then
			if uData[1] == name then
				--Spring.Echo("Processed unit: "..name)
				local newData = uData[2]
				for k, v in pairs (newData) do
					local oldDefVal = uDef[k]
					local newDefVal = v
                    -- custom processing of weapondefs
                    if oldDefVal and k == "weapondefs" then
						-- weapondefs={[[new or v]]vtol_emg2={craterboost=0,
						-- If we find matching weapondefs in source lua, we keep the orig cegtag and explosiongenerator
						for weapID, weapData in pairs (newDefVal) do
							local oldWeaponDef = oldDefVal[weapID]
							local oldcegtag, oldexpgen
							if oldWeaponDef then
								oldcegtag = oldWeaponDef.cegtag
								oldexpgen = oldWeaponDef.explosiongenerator
							else
								-- We couldn't know which old weapon corresponds to the new one, so we just grab whatever
								for ok, ov in pairs(oldDefVal) do
									if ov.cegtag then
										oldcegtag = ov.cegtag end
									if ov.explosiongenerator then
										oldexpgen = ov.explosiongenerator end
								end
								--Spring.Echo("Warning: couldn't find newWeap "..tostring(weapID)..
								--		" in "..name.."'s current data.")
								if oldcegtag or oldexpgen then
									Spring.Echo("Warning: 'Guessed' explosiongenerator and/or cegtag for unit "..name..", as: "
											..(oldexpgen or "nil").." and ceg: ".. (oldcegtag or "nil")) end
							end
							if oldcegtag then
								newDefVal[weapID].cegtag = oldcegtag end
							if oldexpgen then
								newDefVal[weapID].explosiongenerator = oldexpgen end
						end
                    end
                    --customParams table items will become customParams.item__subitem (only string,string supported)
                    if k == "customparams" then
                        newDefVal = {}
                        for cparmkey, cparmvalue in pairs (v) do
                            if type(cparmvalue) == "table" then
                                --Spring.Echo("Parsed unit: "..name.." table key: "..cparmkey or "nil")
                                --newDefVal[cparmkey] = nil                       -- We won't keep the original table
                                for cparmsubk, cparmsubv in pairs(cparmvalue) do       -- eg.: { groupDef = { size = 1, .. } }
                                    local newKeyName = cparmkey.."__"..cparmsubk
                                    newDefVal[newKeyName] = cparmsubv -- => [groupDef__size] = 1
                                    --Spring.Echo("New cParm for "..name..": "..(tostring(newKeyName) or "nil").." = "..(tostring(cparmsubv) or "nil"))
                                end
                            else
                                newDefVal[cparmkey] = cparmvalue                -- Not a table, just assign it
                            end
                        end
                    end
                    uDef[k] = newDefVal
                    --if newDefVal then
                    --    UnitDefs[name][k] = newDefVal end
                    --if k == "customParams" then
                    --    Spring.Echo("Unit: "..name.." Prop: "..k.." was: "..tostringplus(oldDefVal).." now: "..tostringplus(v))
                    --end
				end
				--Spring.Echo("\t\t----\n\t\t----")
			end
		end
	end
end

-- process weapondef
-- name: weaponName; wDef: weapon Definition; udName: unit definition name
function WeaponDef_Post(name, wDef, udName)
    --region Gfx / Particles Tweaks
    if wDef.weapontype == "Cannon" then
        if wDef.stages == nil then
            wDef.stages = 10
            if wDef.damage ~= nil and wDef.damage.default ~= nil and wDef.areaofeffect ~= nil then
                wDef.stages = math.floor(7.5 + math.min(wDef.damage.default * 0.0033, wDef.areaofeffect * 0.13))
                wDef.alphadecay = 1 - ((1/wDef.stages)/1.5)
                wDef.sizedecay = 0.4 / wDef.stages
            end
        end
    end

    if wDef ~= nil and wDef.laserflaresize ~= nil and wDef.laserflaresize > 0 then
        wDef.laserflaresize = wDef.laserflaresize * 1.1
    end

    --endregion Gfx / Particles Tweaks

    wDef.cratermult = (wDef.cratermult or 1) * 0.3 -- modify cratermult cause Spring v103 made too big craters

	--damageTypes = VFS.Include("gamedata/configs/damagetypes.lua")
	--damageMults = VFS.Include("gamedata/configs/damagemultipliers.lua")
	--weaponDmgTypes = VFS.Include("gamedata/configs/weapondamagetypes.lua")

	if not istable(damageTypes) then
        Spring.Echo("error: Damage Types table not found!")
		return
	end

	local baseDamage = tonumber(wDef.damage.default)
	if not baseDamage or baseDamage <= 0 then
		return end

	--  --> Uncomment below only when needing to regenerate the weapondamagetypes.lua table
	--damageType = GetBaseDamageType(udName)
	--UpdateWeaponDamageTypes(udName, wDef.name, damageType)

	damageType = "none"
	if (udName == nil) then									-- It's a standalone weapon, check customparams
		damageType = (wDef.customParams and wDef.customParams.damagetype)
				and wDef.customParams.damagetype or "none"
		--if damageType ~= "none" then
		--	Spring.Echo("Standalone Weapon: "..name.." "..wDef.name.." type: "..damageType)
		--end
	elseif (weaponDmgTypes[udName] ~= nil) then				-- otherwise, check if it's defined in weaponDmgTypes
		damageType = weaponDmgTypes[udName][wDef.name]
	end

	-- Now let's clear out all previous values (deprecate armor classes) and reassign default damage
	wDef.damage = {}
	wDef.damage.default = baseDamage
 
	local unitName = udName or "undefined"
	--local damages = "unit: "..unitName.." weapon: "..wDef.name.."; default: "..baseDamage.." "
	if (damageType ~= nil) then
		for armorClass, armorMultiplier in pairs(damageMults[damageType]) do
			wDef.damage[armorClass] = baseDamage * armorMultiplier
		end
	else
		Spring.Echo(" damagePerArmor error: couldn't find setting for "..udName
					.." - wrong weapon name in weapondamagetypes? unit assigned to 'none' in damagemultipliers.lua?")
	end
	--DebugTableKeys(wDef.damage)
end

local function UpdateWeaponDamageTypes(unitName, weaponName, baseDamageType)
	if (unitName == nil or unitName == "") then
		return end
	if (WeaponDamageTypes[unitName] == nil) then
		WeaponDamageTypes[unitName] = {} end
	WeaponDamageTypes[unitName][weaponName] = baseDamageType
end

-- Get the 'base' (standard or most important) damage type of this unit
-- Optionally lists the matchup
function GetBaseDamageType(udName)
	local debug = false 			--Turn this on for Debug printing
	local damageType = "none"
	if (udName == nil or udName == "") then
		--Spring.Echo("udName is nil or empty")
		return damageType end
	
	--Spring.Echo("UD Name :: "..udName)
	for thisDamageType, units in pairs(damageTypes) do
		if ipairs_contains(units, udName) then
			--Spring.Echo("Damage Type: "..thisDamageType) end
			damageType = thisDamageType
			break
		end
	end
	return damageType
end

--------------------------
-- MODOPTIONS
-------------------------

-- process modoptions (last, because they should not get baked; called by weapondefs_post.lua)
function ModOptions_Post (UnitDefs, WeaponDefs)
	
	if (Spring.GetModOptions) then
	    local modOptions = Spring.GetModOptions()
        local map_tidal = modOptions and modOptions.map_tidal
        if map_tidal and map_tidal ~= "unchanged" then
            for id, unitDef in pairs(UnitDefs) do
                if unitDef.tidalgenerator == 1 then
                    unitDef.tidalgenerator = 0
                    if map_tidal == "low" then
                        unitDef.energymake = 13
                    elseif map_tidal == "medium" then
                        unitDef.energymake = 18
                    elseif map_tidal == "high" then
                        unitDef.energymake = 23
                    end
                end
            end
        end

        -- transporting enemy coms
        if (modOptions.transportenemy == "notcoms") then
            for name,ud in pairs(UnitDefs) do
                if (name == "armcom" or name == "corcom" or name == "armdecom" or name == "cordecom") then
                    ud.transportbyenemy = false
                end
            end
        elseif (modOptions.transportenemy == "none") then
            for name, ud in pairs(UnitDefs) do
                ud.transportbyenemy = false
            end
        end

        --[[
        -- Make BeamLasers do their damage up front instead of over time
        -- Do this at the end so that we don't mess up any magic math
        for id,wDef in pairs(WeaponDefs) do
            -- Beamlasers do damage up front
            if wDef.beamtime ~= nil then
                beamTimeInFrames = wDef.beamtime * 30
                --Spring.Echo(wDef.name)
                --Spring.Echo(beamTimeInFrames)
                wDef.beamttl = beamTimeInFrames
                --Spring.Echo(wDef.beamttl)
                wDef.beamtime = 0.01
            end
        end
        ]]--
	end
end