return {
    --- Commander's Explosion EMP is fired by unit_commander_blast.lua, for all comm levels
    commanderexplosionemp = {
		areaofeffect = 720,
		craterboost = 6,
		cratermult = 3,
		edgeeffectiveness = 1,
		explosiongenerator = "custom:genericshellexplosion-huge-lightning",
		impulseboost = 0.12300000339746,
		impulsefactor = 0.12300000339746,
		name = "AntimatterExplosionEMP",
		range = 720,
		reloadtime = 3.5999999046326,
		soundhit = "",
		soundstart = "",
		turret = 1,
		weaponvelocity = 250,
		damage = {
			default = 999999,
		},
		customparams = {
            damagetype = "emp",
            expl_light_radius_mult = 1.15,
            expl_light_mult = 1,
            expl_light_color = "0.5 0.5 1",
            expl_light_life_mult = 1.3,
            expl_light_heat_radius_mult = 1.15,
			expl_light_heat_life_mult = 4.5,
		},
	},
}
