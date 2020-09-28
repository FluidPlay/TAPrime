-- TAP uses unitdefs_post and alldefs_post.lua
-- DONT TOUCH this if you're not sure what you're doing

--
--if Spring.GetModOptions and (tonumber(Spring.GetModOptions().barmodels) or 0) ~= 0 then
--    Spring.Echo("barmodels modoption is enabled")  -- notify that barmodels is enabled so infolog shows this
--end

-- see alldefs.lua for documentation
-- load the games _Post functions for defs, and find out if saving to custom params is wanted
VFS.Include("gamedata/alldefs_post.lua")
-- load functionality for saving to custom params
VFS.Include("gamedata/post_save_to_customparams.lua")

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tableMergeSpecial(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if next(v) == nil then
                t1[k] = v
            else
                if type(t1[k] or false) == "table" then
                    tableMergeSpecial(t1[k] or {}, t2[k] or {})
                else
                    t1[k] = v
                end
            end
        else
            t1[k] = v
        end
    end
    return t1
end
-- create BAR alternatives [ Not used in TAP, we're adding our own revamped stuff ]
--if not (Spring.GetModOptions and (tonumber(Spring.GetModOptions().barmodels) or 0) ~= 0) then
--    if Game and Game.gameVersion and (string.find(Game.gameVersion, 'test') or string.find(Game.gameVersion, '$VERSION')) then
--        local oldUnitName = {	-- mostly duplicates
--            armdecom = 'armcom',
--            cordecom = 'corcom',
--            armdf = 'armfus',
--            corgantuw = 'corgant',
--            armshltxuw = 'armshltx',
--        }
--        --local barUnitDefs = {}
--        --for name,uDef in pairs(UnitDefs) do
--        --    local barUnitName = oldUnitName[name] and oldUnitName[name] or name
--        --    if VFS.FileExists('objects3d/BAR/'..uDef.objectname..'.s3o') or VFS.FileExists('objects3d/BAR/'..barUnitName..'.s3o') then
--        --        barUnitDefs[name..'_bar'] = deepcopy(uDef)
--        --    end
--        --end
--        --for name,ud in pairs(barUnitDefs) do
--        --    UnitDefs[name] = ud
--        --end
--    end
--end
--
--for categoryName, categoryUnits in pairs(ArmorDefs) do
--    for _, thisUdID in pairs(categoryUnits) do
--        if not string.find(thisUdID, '_scav') then
--            table.insert(ArmorDefs.categoryName, thisUdID+"_scav")
--            Spring.Echo("Added Scav Unit: ", thisUdID, " to armorclass: "..categoryName)
--        end
--    end
--end

-- handle unitdefs and the weapons they contain


-- create scavenger units
for name,ud in pairs(UnitDefs) do
	UnitDef_Post(name,ud)
	if ud.weapondefs then
		for wname,wd in pairs(ud.weapondefs) do
			WeaponDef_Post(wname,wd)
		end
	end 
  
	--ud.acceleration = 0.75
	--ud.turnrate = 800
  
	if SaveDefsToCustomParams then
		SaveDefToCustomParams("UnitDefs", name, ud)    
	end
end

VFS.Include("gamedata/scavengers/unitdef_changes.lua")
local scavengerUnitDefs = {}

for name,uDef in pairs(UnitDefs) do
	--local faction = string.sub(name, 1, 3)
	if not string.find(name, '_scav') then
		if customDefs[name] ~= nil then
			scavengerUnitDefs[name..'_scav'] = tableMergeSpecial(deepcopy(uDef), deepcopy(customDefs[name]))
		else
			scavengerUnitDefs[name..'_scav'] = deepcopy(uDef)
		end
	end
end
 
for name,uDef in pairs(scavengerUnitDefs) do
	UnitDefs[name] = uDef
end

VFS.Include("gamedata/scavengers/unitdef_post.lua")
VFS.Include("gamedata/scavengers/weapondef_post.lua")

for name,uDef in pairs(UnitDefs) do
	if string.find(name, '_scav') then
		uDef = scav_Udef_Post(name, uDef)
		if uDef.weapondefs then
			for wname,wDef in pairs(uDef.weapondefs) do
				wDef = scav_Wdef_Post(name, wDef)
			end
		end 
	end
	if SaveDefsToCustomParams then
		SaveDefToCustomParams("UnitDefs", name, uDef)    
	end
end





---- TAPrime ::
-- We use unitdefs_data.lua as a lua table, generated from the units gsheet, which may be easily replace-able anytime
-- So the defs.lua should preprocess UnitDefs from whatever's in unitdefs_data (!)