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

	bullet={ 	peon = 1,		rpg = 1.5,		stalwart = 0.45,aiv = 0.45,			tank = 0.3,		artillery = 0.5,
				fighter = 0.4,	gunship = 2,	bomber = 1.5, 	structure = 0.75, 	defense = 0.263,defenseaa = 0.35, 	commander = 0.35,
				invader = 0.75,	heavybot = 0.6,	assault = 0.25,	heavyveh = 1,	    resource = 0.25,
	}
,
	rocket={ 	peon = 0.3, 	rpg = 0.5, 		stalwart = 0.65,aiv = 0.6, 			tank = 3.78, 	artillery = 0.85,
				fighter = 0.3, 	gunship = 2.55, bomber = 0.5, 	structure = 0.8, 	defense = 0.6, 	defenseaa = 0.5, 	commander = 0.4,
				invader = 0.3,	heavybot = 0.25,assault = 0.8,	heavyveh = 1.5,		resource = 0.8,
	}
,
	homing={ 	peon = 0.2, 	rpg = 0.25, 	stalwart = 0.5, aiv = 0.75, 		tank = 2.3, 	artillery = 1.25,
				fighter = 1.25, gunship = 3, 	bomber = 1.5, 	structure = 0.6, 	defense = 0.75, defenseaa = 0.125, 	commander = 0.2,
				invader = 0.4,  heavybot = 0.2,	assault = 0.75,	heavyveh = 1,		resource = 0.75,
	}
,
	laser={ 	peon = 2, 		rpg = 1.2, 		stalwart = 0.75, aiv = 0.6, 			tank = 0.33, 	artillery = 0.65,
			    fighter = 1.25, gunship = 1.25, bomber = 1, 	structure = 1,		defense = 0.7, 	defenseaa = 0.8, 	commander = 0.68,
			    invader = 0.9,	heavybot = 0.6,	assault = 0.5,	heavyveh = 0.75,	resource = 0.5,
	}
,
	hflaser={ 	peon = 2, 		rpg = 0.75,		stalwart = 0.45,aiv = 0.5, 			tank = 0.225, 	artillery = 0.3,
				fighter = 1.25, gunship = 0.5, 	bomber = 1, 	structure = 0.75, 	defense = 0.6,	defenseaa = 0.5, 	commander = 0.85,
				invader = 0.6, 	heavybot = 0.4,	assault = 0.75,	heavyveh = 0.3,		resource = 0.75,
	}
,
	plasma={ 	peon = 1.05, 	rpg = 0.45, 	stalwart = 1.3, aiv = 0.4, 			tank = 0.8, 	artillery = 1,
				fighter = 0.75, gunship = 1.25, bomber = 1.5, 	structure = 1, 		defense = 0.275,defenseaa = 0.6, 	commander = 1.33,
				invader = 1.1,	heavybot = 1,	assault = 1.5,	heavyveh = 0.65,	resource = 1,
	}
,
	cannon={ 	peon = 0.65, 	rpg = 0.25, 	stalwart = 0.9, aiv = 2, 			tank = 1.1, 	artillery = 2,
				fighter = 1.5, 	gunship = 2, 	bomber = 1.25, 	structure = 1, 		defense = 1.2, 	defenseaa = 0.3, 	commander = 0.75,
				invader = 0.3, 	heavybot = 0.2,	assault = 0.5,	heavyveh = 0.75,	resource = 1,
	}
,
	thermo={ 	peon = 0.4, 	rpg = 1.25, 	stalwart = 0.5, aiv = 0.2, 			tank = 1.2, 	artillery = 1.25,
				fighter = 1.3, 	gunship = 1.0, 	bomber = 1.25, 	structure = 0.75, 	defense = 1.25, defenseaa = 0.5, 	commander = 0.5,
				invader = 0.65,	heavybot = 1.2, assault = 0.6,	heavyveh = 1,		resource = 0.45,
	}
,
	siege={ 	peon = 0.4, 	rpg = 0.85, 	stalwart = 1.2,	aiv = 0.75, 		tank = 0.25, 	artillery = 0.6,
			   fighter = 2, 	gunship = 1, 	bomber = 2.5, 	structure = 1.2, 	defense = 1.8, 	defenseaa = 1.6, 	commander = 0.25,
			   invader = 0.5, 	heavybot = 0.3, assault = 1.5,	heavyveh = 0.2,		resource = 1.2,
	}
,
	emp={ 		peon = 1, 		rpg = 1, 		stalwart = 1, 	aiv = 0.125, 		tank = 2, 		artillery = 2,
				 fighter = 1, 	gunship = 1, 	bomber = 1, 	structure = 1, 		defense = 1, 	defenseaa = 0.75, 	commander = 0.1,
				 invader = 1, 	heavybot = 0.5, assault = 0.5,	heavyveh = 2,		resource = 1,
	}
,
	explosive={ peon = 1, 		rpg = 0.75, 	stalwart = 1,   aiv = 1, 			tank = 1, 		artillery = 1,
				fighter = 0.5, 	gunship = 0.5, 	bomber = 0.5, 	structure = 3, 		defense = 1.5, 	defenseaa = 0.75, 	commander = 0.3,
				invader = 1.5,	heavybot = 0.5, assault = 0.75,	heavyveh = 1.2,		resource = 1.25,
	}
,
	flak={ 		peon = 0.75, 	rpg = 0.4, 		stalwart = 0.3, aiv = 0.75,			tank = 0.275, 	artillery = 0.75,
				  fighter = 1, 	gunship = 0.75, bomber = 0.3, 	structure = 1, 		defense = 0.3, 	defenseaa = 0.8,	commander = 0.5,
				  invader = 1, 	heavybot = 1.25,assault = 0.5,	heavyveh = 0.3,		resource = 0.25,
	}
,
	rail={ 		peon = 1,		rpg = 1.4,		stalwart = 0.8,	aiv = 0.15,			tank = 1.2,		artillery = 0.35,
				fighter = 0.4,	gunship = 1,	bomber = 1, 	structure = 0.2, 	defense = 0.2, 	defenseaa = 0.2, 	commander = 0.15,
				invader = 0.75,	heavybot = 0.6,	assault = 0.25,	heavyveh = 0.2,		resource = 0.2,
	}
,
	neutron={ 	peon = 0.25, 	rpg = 0.5, 	    stalwart = 0.65,aiv = 0.75, 		tank = 3.5, 	artillery = 0.4,
				fighter = 1.25, gunship = 3, 	bomber = 1.5, 	structure = 0.5, 	defense = 0.15, defenseaa = 0.05, 	commander = 0.2,
				invader = 0.4, 	heavybot = 0.25,assault = 1.25,	heavyveh = 1.75,    resource = 0.75,
	}
,
	omni={ 	    peon = 1.01, 	    rpg = 1, 		stalwart = 1, 	aiv = 1, 			tank = 2, 	artillery = 1.5,
				fighter = 2, 	gunship = 2, 	bomber = 2, 	structure = 1, 		defense = 1, 	defenseaa = 1, 		commander = 1.5,
				invader = 1, 	heavybot = 1, 	assault = 1,	heavyveh = 1,		resource = 1,
	}
,
	nuke={ 		peon = 1, 		rpg = 1, 		stalwart = 1, 	aiv = 1, 			tank = 1.1,		artillery = 1,
				fighter = 1, 	gunship = 1, 	bomber = 1, 	structure = 1, 		defense = 1, 	defenseaa = 1, 		commander = 0.5,
				invader = 1, 	heavybot = 1, 	assault = 1,	heavyveh = 1,		resource = 1,
	}
,
	none={ 		peon = 0.1, 	rpg = 0.1, 		stalwart = 0.1, aiv = 0.1, 			tank = 0.1, 	artillery = 0.1,
				fighter = 0.1, 	gunship = 0.1, 	bomber = 0.1, 	structure = 0.1, 	defense = 0.1, 	defenseaa = 0.1, 	commander = 0.1,
				invader = 0.1, 	heavybot = 0.1, assault = 0.1,	heavyveh = 0.1,		resource = 0.1,
	}
,
	["else"] = {}
,
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageMultipliers)

return damageMultipliers
