Spring.Echo("[Scavengers] Config initialized")



scavconfig = {
	difficulty = {
		easy = 1,
		medium = 2,
		hard = 3,
		brutal = 5,
	},
	unitnamesuffix = "_scav",
	messenger = true, -- make sure gui_messages.lua is included in the mod
	modules = {
		buildingSpawnerModule 			= false,
		constructorControllerModule 	= true,
		factoryControllerModule 		= true,
		unitSpawnerModule 				= true,
		startBoxProtection				= true,
		reinforcementsModule			= false,
		stockpilers						= true,
		nukes							= true,
	},
	
	scoreConfig = {
		-- set to 0 to disable
		scorePerMetal 					= 1, 	-- thisvalue*metalproduction
		scorePerEnergy 					= 1,	-- thisvalue*energyproduction
		scorePerSecond 					= 1,	-- thisvalue*secondspassed
		scorePerOwnedUnit				= 1,	-- thisvalue*countofunits
		-----------------------------------------
		baseScorePerKill 				= 1, -- How much score EVERY KILL and CAPTURE adds
			-- Additional score for specific unit types, use -baseScorePerKill(default 1) to make it have no effect on score, use values lower than baseScorePerKill to reduce score
			scorePerKilledBuilding 			= 4,
			scorePerKilledConstructor 		= 99,
			scorePerKilledSpawner 			= -1,
			scorePerCapturedSpawner 		= 50, -- this doesn't care about baseScorePerKill 
	},
	timers = {
		-- globalScore values
		T0start								= 1,
		T1start								= 600,
		T1low								= 900,
		T1med								= 1200,
		T1high								= 1500,
		T1top								= 1800,
		-- On function UpdateTierChances() you have tier chances for every timer and then it's RNG
		-- Eg: T2start has 20% chance for T2 and 80% chance for T1; It's transition so it doesn't switch instantly from.pure T1 to pure T2
		T2start								= 3200, --2250, 2925
		T2low								= 3900, --3900
		T2med								= 4875,
		T2high								= 5850,
		T2top								= 7800,
		T3start								= 8500, -- 7500
		T3low								= 9500, -- 9000
		T3med								= 10500,
		T3high								= 12000,
		T3top								= 13500,
		T4start								= 15000,
		T4low								= 18000,
		T4med								= 21000,
		T4high								= 24000,
		T4top								= 28000,
		BossFight							= 28001,
		-- don't delete
		NoRadar								= 1200,
	},
	other = {
		heighttolerance						= 30, -- higher = allow higher height diffrences
		noheightchecksforwater				= true,
	}
}


-- Modules configs
buildingSpawnerModuleConfig = {
	spawnchance 						= 90,
}

unitSpawnerModuleConfig = {
	bossFightEnabled					= true,
	FinalBossUnit						= true,
		FinalBossHealth						= 250000, -- this*teamcount*difficulty
		FinalBossMinionsPassive				= 3000, -- this/(teamcount*difficulty), how often does boss spawn minions passively, frames.
		FinalBossMinionsActive				= 150, -- this/(teamcount*difficulty), how often does boss spawn minions when taking damage, frames.
	BossWaveTimeLeft					= 180, --900,
	aircraftchance 						= 8, --6,9 [M] -- higher number = lower chance
	--- globalscoreperoneunit: Let's say scavs are on 3000 score, and score per unit is 1000,
	-- it will spawn 3 units if all other multipliers are 1 but there are multipliers for land/sea/air and multipliers for tiers
	globalscoreperoneunit 				= 2000, --4500,
	spawnchance							= 70, -- 20, 120; lower = more
	beaconspawnchance					= 60,
	minimumspawnbeacons					= 3,
	landmultiplier 						= 0.75,
	airmultiplier 						= 0.7, --2.0, 0.6 [M]
	seamultiplier 						= 0.2,
	chanceforaircraftonsea				= 2, -- higher number = lower chance

	t0multiplier						= 3,    ---Higher number bigger wave
	t1multiplier						= 2.15, --2.5, 2 [M]
	t2multiplier						= 1.0,  -- 0.8 [M]
	t3multiplier						= 0.175, -- 0.1 [M]
	t4multiplier						= 0.03, -- 0.05, [M]
}

constructorControllerModuleConfig = {
	constructortimerstart				= 120, -- amount of seconds it skips from constructortimer for the first spawn (make first spawn earlier - this timer starts on timer-Timer1)
	constructortimer 					= 240, -- time in seconds between commander/constructor spawns
	constructortimerreductionframes		= 36000,
	minimumconstructors					= 2,
	useresurrectors						= true,
	searesurrectors					    = false,
	useconstructors						= true,
	usecollectors						= true,
}

unitControllerModuleConfig = {
	minimumrangeforfight				= 500, --650 [M], -- Low range units use Move command, units with range above this value use 'Fight'
}

spawnProtectionConfig = {
	spread				= 192,
}



-- Functions which you can configure
function CountScavConstructors()
	return UDC(GaiaTeamID, UDN.corcom_scav.id) + UDC(GaiaTeamID, UDN.armcom_scav.id)
end

function UpdateTierChances(n)
	-- Must be 100 in total
	if globalScore > scavconfig.timers.T4top then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 10
		TierSpawnChances.T3 = 30
		TierSpawnChances.T4 = 60
	elseif globalScore > scavconfig.timers.T4high then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 30
	elseif globalScore > scavconfig.timers.T4med then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 30
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 20
	elseif globalScore > scavconfig.timers.T4low then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 40
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 10
	elseif globalScore > scavconfig.timers.T4start then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 40
		TierSpawnChances.T3 = 55
		TierSpawnChances.T4 = 5
	elseif globalScore > scavconfig.timers.T3top then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 70
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T3high then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 50
		TierSpawnChances.T3 = 40
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T3med then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 60
		TierSpawnChances.T3 = 30
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T3low then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 65
		TierSpawnChances.T3 = 25
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T3start then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 70
		TierSpawnChances.T3 = 10
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T2top then   -- Numbers below must always sum up to 100
		TierSpawnChances.T0 = 5 -- 10
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 85
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T2high then
		TierSpawnChances.T0 = 5  --10
		TierSpawnChances.T1 = 25 --30
		TierSpawnChances.T2 = 70 --60
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T2med then
		TierSpawnChances.T0 = 5  --10
		TierSpawnChances.T1 = 35 --40
		TierSpawnChances.T2 = 60 --50
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T2low then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 60
		TierSpawnChances.T2 = 30
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T2start then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 70
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T1top then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 90
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T1high then
		TierSpawnChances.T0 = 40
		TierSpawnChances.T1 = 60
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T1med then
		TierSpawnChances.T0 = 60
		TierSpawnChances.T1 = 40
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T1low then
		TierSpawnChances.T0 = 80
		TierSpawnChances.T1 = 20
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	elseif globalScore > scavconfig.timers.T1start then
		TierSpawnChances.T0 = 90
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	else
		TierSpawnChances.T0 = 100
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
	end
end