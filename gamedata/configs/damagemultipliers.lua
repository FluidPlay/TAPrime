--
-- Created by IntelliJ IDEA.
-- User: MaDDoX
-- Date: 14/05/17
-- Time: 04:16
--
-- Here we define, given a damageType key, a damage multiplier per armor class
--
--
local damageMultipliers = {

	bullet={ 	lightbot = 1.1,	supportbot = 1.8,	heavybot = 0.7, lightveh = 0.25,    supportveh = 0.5,   heavyveh = 0.3,
				lightair = 0.7,	supportair = 2,	    heavyair = 1.5, lightship = 0.75,   supportship = 1,    heavyship = 0.25,
                structure = 0.75,resource = 0.25, 	defense = 0.18, defenseaa = 0.25,   commander = 0.3,
	}
,
	rocket={ 	lightbot = 0.22,supportbot = 0.35,  heavybot = 0.35,lightveh = 0.4,     supportveh = 0.85,	heavyveh = 4,
				lightair = 0.3, supportair = 2.55,  heavyair = 0.5, lightship = 0.45,   supportship = 0.75, heavyship = 1.6,
                structure = 0.8,resource = 0.8,     defense = 0.4,  defenseaa = 0.85,   commander = 0.4,
	}
,
	homing={ 	lightbot = 1,   supportbot = 0.25, 	heavybot = 0.3, lightveh = 0.75,    supportveh = 1.25,  heavyveh = 3.2,
				lightair = 0.9, supportair = 3, 	heavyair = 2.5, lightship = 1.25,   supportship = 1.75, heavyship = 2.5,
                structure = 0.6,resource = 0.75, 	defense = 0.5, defenseaa = 0.125,  commander = 0.2,
	}
,
	laser={     lightbot = 1.5, supportbot = 1.6,   heavybot = 0.82,lightveh = 0.6,     supportveh = 0.65,  heavyveh = 0.33,
                lightair = 1.25,supportair = 1.25,  heavyair = 1,   lightship = 1.25,   supportship = 2,    heavyship = 0.5,
                structure = 1.1,resource = 0.5,     defense = 0.7,  defenseaa = 0.8,    commander = 0.68,
	}
,
	hflaser={   lightbot = 1.5,  supportbot = 1.2,	heavybot = 0.45,lightveh = 0.55,    supportveh = 0.3,   heavyveh = 0.225,
                lightair = 1.25, supportair = 0.5,	heavyair = 1,   lightship = 1.5,    supportship = 0.75, heavyship = 0.25,
                structure = 0.75,resource = 0.75,	defense = 0.6,  defenseaa = 0.5,    commander = 0.85,
	}
,
    plasma={ 	lightbot = 1.05,supportbot = 0.75, heavybot = 0.3,  lightveh = 0.9,     supportveh = 0.45,  heavyveh = 0.4,
                lightair = 0.75,supportair = 1.25, heavyair = 1.5,  lightship = 1.75,   supportship = 0.75, heavyship = 1.5,
                structure = 1,  resource = 1, 		defense = 0.275,defenseaa = 0.6,    commander = 1.33,
	}
,
	cannon={ 	lightbot = 0.5, supportbot = 0.25, heavybot = 0.6,  lightveh = 2, 	    supportveh = 2,        heavyveh = 1,
                lightair = 1.5, supportair = 2, 	heavyair = 1.25,lightship = 2,      supportship = 0.5,    heavyship = 1,
                structure = 1,  resource = 1, 		defense = 1.2, 	defenseaa = 0.22, 	commander = 0.75,
	}
,
	thermo={ 	lightbot = 0.4, supportbot = 1.1, 	heavybot = 1.6, lightveh = 0.3,    supportveh = 1.25,      heavyveh = 1.4,
                lightair = 1.3, supportair = 2.5,	heavyair = 1,   lightship = 2,     supportship = 0.5,     heavyship = 1.75,
                structure = 0.75,resource = 0.45, 	defense = 1,    defenseaa = 0.5, 	commander = 0.25,
	}
,
	siege={ 	lightbot = 0.4, supportbot = 0.85, heavybot = 1.2,	lightveh = 1, 	    supportveh = 0.6,       heavyveh = 0.25,
                lightair = 2, 	supportair = 1, 	heavyair = 2.5, lightship = 3,      supportship = 0.75,     heavyship = 0.25,
                structure = 1.2,resource = 1.2, 	defense = 1.8, 	defenseaa = 1.6, 	commander = 0.25,
	}
,
	emp={ 	    lightbot = 1, 	supportbot = 0.75, heavybot = 3, 	lightveh = 0.2,     supportveh = 2,      heavyveh = 4.5,
                 lightair = 1, 	supportair = 1, 	heavyair = 1,   lightship = 2,      supportship = 1.25, heavyship = 4,
                structure = 1, 	resource = 1,	    defense = 1, 	defenseaa = 0.75, 	commander = 0.1,
	}
,
	explosive={ lightbot = 1.2, supportbot = 0.65, heavybot = 0.85,lightveh = 1,       supportveh = 0.65,  heavyveh = 1.25,
                lightair = 0.5, supportair = 0.5, 	heavyair = 0.5, lightship = 3,      supportship = 1.5,  heavyship = 4,
                structure = 2,  resource = 1.25,	defense = 1.5, 	defenseaa = 0.75,   commander = 0.3,
	}
,
	flak={ 		lightbot = 0.5, supportbot = 0.65, 	heavybot = 1.2, lightveh = 0.35,    supportveh = 0.75,  heavyveh = 0.275,
				lightair = 1, 	supportair = 0.75,  heavyair = 0.4, lightship = 0.33,   supportship = 0.45,heavyship = 0.75,
                structure = 1, 	resource = 0.25,	defense = 0.3, 	defenseaa = 0.8,    commander = 0.15,
	}
,
	rail={ 		lightbot = 1,	supportbot = 2.4,	heavybot = 1,	lightveh = 0.2,     supportveh = 0.35,heavyveh = 1.2,
                lightair = 0.4,	supportair = 1,	    heavyair = 1, 	lightship = 1.5,    supportship = 0.5,heavyship = 1.5,
                structure = 0.2,resource = 0.2, 	defense = 0.2, 	defenseaa = 0.2,    commander = 0.15,
	}
,
	neutron={ 	lightbot = 0.3, supportbot = 0.65, 	heavybot = 0.25,lightveh = 0.75,    supportveh = 0.4, 	heavyveh = 3.5,
				lightair = 1.25, supportair = 3, 	heavyair = 1.5, lightship = 0.5,    supportship = 1,    heavyship = 4,
                structure = 0.5,resource = 0.75, 	defense = 0.15, defenseaa = 0.1, 	commander = 0.2,
	}
,
	omni={ 	    lightbot = 1.01,supportbot = 0.95, 	heavybot = 1, 	lightveh = 1,       supportveh = 1.5,   heavyveh = 2,
				lightair = 2, 	supportair = 2, 	heavyair = 2,   lightship = 1.25,   supportship = 0.75,heavyship = 2.5,
                structure = 1,  resource = 1, 		defense = 0.5, 	defenseaa = 0.5, 	commander = 1.5,
	}
,
	nuke={ 		lightbot = 1, 	supportbot = 1, 	heavybot = 1, 	lightveh = 1, 	    supportveh = 1,     heavyveh = 1.1,
				lightair = 1, 	supportair = 1, 	heavyair = 1,   lightship = 1,	    supportship = 1,    heavyship = 1,
                structure = 1, resource = 1,		defense = 1, 	defenseaa = 1, 		commander = 0.5,
	}
,
	none={ 		lightbot = 0.1, supportbot = 0.1, 	heavybot = 0.1, lightveh = 0.1,     supportveh = 0.1, 	heavyveh = 0.1,
				lightair = 0.1, supportair = 0.1, 	heavyair = 0.1, lightship = 0.1,    supportship = 0.1,	heavyship = 0.1,
                structure = 0.1,resource = 0.1,    defense = 0.1, 	defenseaa = 0.1,    commander = 0.1,
	}
,
	["else"] = {}
,
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageMultipliers)

return damageMultipliers
