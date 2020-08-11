-- (note that alldefs_post.lua is still ran afterwards if you change anything there)

-- Special rules:
-- you only need to put the things you want changed in comparison with the regular unitdef. (use the same table structure)
-- since you cant actually remove parameters normally, it will do it when you set string: 'nil' as value
-- normally an empty table as value will be ignored when merging, but not here, it will overwrite what it had with an empty table

customDefs = {}


local scavUnit = {}
for name,uDef in pairs(UnitDefs) do
    scavUnit[#scavUnit+1] = name..'_scav'
end

-- Scav Commanders

customDefs.corcom = {		
	blocking = false,
	buildoptions = scavUnit,
	explodeas = "scavcomexplosion",
	footprintx = 4,
	footprintz = 4,
	hidedamage = true,
	maxdamage = 4500,
	workertime = 500,				-- can get multiplied in unitdef_post 
	customparams = {
		iscommander = 'nil',		-- since you cant actually remove parameters normally, it will do it when you set string: 'nil' as value
        providetech = 'Tech, Tech1, Tech2, Tech3, Tech4',
	},
	featuredefs = {
		dead = {
			resurrectable = 0,
			metal = 1500,
		},
		heap = {
			resurrectable = 0,
			metal = 750,
		},
	},
	weapondefs = {
		disintegrator = {
			commandfire = false,
			reloadtime = 1,
			weaponvelocity = 350,
			damage = {
				default = 2250,
				commanders = 225,
			},
		},
	},
}

customDefs.armcom = {		
	blocking = false,
	buildoptions = scavUnit,
	explodeas = "scavcomexplosion",
	footprintx = 4,
	footprintz = 4,
	hidedamage = true,
	maxdamage = 4500,
	workertime = 500,				-- can get multiplied in unitdef_post 
	customparams = {
		iscommander = 'nil',		-- since you cant actually remove parameters normally, it will do it when you set string: 'nil' as value
        providetech = 'Tech, Tech1, Tech2, Tech3, Tech4',
	},
	featuredefs = {
		dead = {
			resurrectable = 0,
			metal = 1500,
		},
		heap = {
			resurrectable = 0,
			metal = 750,
		},
	},
	weapondefs = {
		disintegrator = {
			commandfire = false,
			reloadtime = 1,
			weaponvelocity = 350,
			damage = {
				default = 2250,
				commanders = 225,
			},
		},
	},
}