return {
	commander_blast2 = {
		areaofeffect = 720, --637, --380, --720,
        cameraShake = 720,
		craterboost = 6,
		cratermult = 3,
		edgeeffectiveness = 1, -- 0.25
        explosiongenerator="custom:COMMANDER_EXPLOSION", --"custom:BLANK", -- COMMANDER_EXPLOSION is called from gadget unit_commander_blast
		impulseboost = 3,
		impulsefactor = 3,
		name = "Matter/AntimatterExplosion",
		range = 380,
		reloadtime = 3.5999999046326,
		soundhit = "newboom",
		soundstart = "largegun",
		turret = 1,
		weaponvelocity = 900, --250
		damage = {
			default = 200000, --100000
		},
		customparams = { damagetype = "omni"},
	},
}
