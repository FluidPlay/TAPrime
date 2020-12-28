Spring.Echo("[Scavengers] Config initialized")

-- Modoptions
	-- Endless Mode
	local Modoption = Spring.GetModOptions().scavendless or "disabled"
	if Modoption == "disabled" then
		scavEndlessModoption = true
	else
		scavEndlessModoption = false
	end
	
	-- Boss Health Modifier
	local Modoption = Spring.GetModOptions().scavbosshealth or "normal"
	if Modoption == "normal" then
		ScavBossHealthModoption = 1
	elseif Modoption == "lower" then
		ScavBossHealthModoption = 0.5
	elseif Modoption == "higher" then
		ScavBossHealthModoption = 1.5
	elseif Modoption == "high" then
		ScavBossHealthModoption = 2
	end
	
	-- Tech Curve Modifier
	local Modoption = Spring.GetModOptions().scavtechcurve or "normal"
	if Modoption == "normal" then
		ScavTechCurveModoption = 1
	elseif Modoption == "fast" then
		ScavTechCurveModoption = 0.5
	elseif Modoption == "slow" then
		ScavTechCurveModoption = 1.5
	end
	
	-- Random Events Bool
	local Modoption = Spring.GetModOptions().scavevents or "enabled"
	if Modoption == "enabled" then
		ScavRandomEventsEnabledModoption = true
	elseif Modoption == "disabled" then
		ScavRandomEventsEnabledModoption = false
	end
	
	-- Random Events Amount
	local Modoption = Spring.GetModOptions().scaveventsamount or "normal"
	if Modoption == "normal" then
		ScavRandomEventsAmountModoption = 1
	elseif Modoption == "lower" then
		ScavRandomEventsAmountModoption = 2
	elseif Modoption == "higher" then
		ScavRandomEventsAmountModoption = 0.5
	end
	
	
	
	Modoption = nil
-- End of Modoptions


scavconfig = {
	difficulty = {
		easy = 1,
		medium = 2,
		hard = 3,
		brutal = 5,
	},
	unitnamesuffix = "_scav",
	messenger = true, -- BYAR specific thing, don't enable otherwise (or get gui_messages.lua from BYAR)
	modules = {
		buildingSpawnerModule 			= false,
		constructorControllerModule 	= true,
		factoryControllerModule 		= true,
		unitSpawnerModule 				= true,
		startBoxProtection				= true,
		reinforcementsModule			= false, --disabled for now for weird victory conditions and too much hp
		randomEventsModule				= ScavRandomEventsEnabledModoption,
		stockpilers						= true,
		nukes							= true,
	},
	
	scoreConfig = {
		-- set to 0 to disable
		scorePerMetal 					= 5, 	-- thisvalue*metalproduction
		scorePerEnergy 					= 1,	-- thisvalue*energyproduction
		scorePerSecond 					= 1,	-- thisvalue*secondspassed
		scorePerOwnedUnit				= 1,	-- thisvalue*countofunits
		-----------------------------------------
		baseScorePerKill 				= 1, -- How much score EVERY KILL and CAPTURE adds
			-- Additional score for specific unit types, use -baseScorePerKill(default 1) to make it have no effect on score, use values lower than baseScorePerKill to reduce score
			scorePerKilledBuilding 			= 9,
			scorePerKilledConstructor 		= 49,
			scorePerKilledSpawner 			= 99,
			scorePerCapturedSpawner 		= 50, -- this doesn't care about baseScorePerKill 
	},
	timers = {
		-- globalScore values
		T0start								= 1,
		T1start								= 600*ScavTechCurveModoption,
		T1low								= 900*ScavTechCurveModoption,
		T1med								= 1200*ScavTechCurveModoption,
		T1high								= 1500*ScavTechCurveModoption,
		T1top								= 1800*ScavTechCurveModoption,
		T2start								= 2250*ScavTechCurveModoption,
		T2low								= 3000*ScavTechCurveModoption,
		T2med								= 3750*ScavTechCurveModoption,
		T2high								= 4500*ScavTechCurveModoption,
		T2top								= 6000*ScavTechCurveModoption,
		T3start								= 7500*ScavTechCurveModoption,
		T3low								= 9000*ScavTechCurveModoption,
		T3med								= 10500*ScavTechCurveModoption,
		T3high								= 12000*ScavTechCurveModoption,
		T3top								= 13500*ScavTechCurveModoption,
		T4start								= 15000*ScavTechCurveModoption,
		T4low								= 18000*ScavTechCurveModoption,
		T4med								= 21000*ScavTechCurveModoption,
		T4high								= 24000*ScavTechCurveModoption,
		T4top								= 28000*ScavTechCurveModoption,
		BossFight							= 32000*ScavTechCurveModoption,
		Endless								= 35000*ScavTechCurveModoption,
		-- don't delete
		NoRadar								= 7500*ScavTechCurveModoption,
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
	bossFightEnabled					= scavEndlessModoption,
	FinalBossUnit						= true,
		FinalBossHealth						= 500000*ScavBossHealthModoption, -- this*teamcount*difficulty
		FinalBossMinionsPassive				= 3000, -- this/(teamcount*difficulty), how often does boss spawn minions passively, frames.
		FinalBossMinionsActive				= 150, -- this/(teamcount*difficulty), how often does boss spawn minions when taking damage, frames.
	BossWaveTimeLeft					= 300,
	aircraftchance 						= 6, -- higher number = lower chance
	globalscoreperoneunit 				= 900,
	spawnchance							= 240,
	beaconspawnchance					= 120,
	beacondefences						= false,
	minimumspawnbeacons					= 2,
	landmultiplier 						= 0.75,
	airmultiplier 						= 2.0,
	seamultiplier 						= 0.75,
	chanceforaircraftonsea				= 5, -- higher number = lower chance

	t0multiplier						= 3.5,
	t1multiplier						= 3,
	t2multiplier						= 1,
	t3multiplier						= 0.20,
	t4multiplier						= 0.05,
}

constructorControllerModuleConfig = {
	constructortimerstart				= 120, -- amount of seconds it skips from constructortimer for the first spawn (make first spawn earlier - this timer starts on timer-Timer1)
	constructortimer 					= 240, -- time in seconds between commander/constructor spawns
	constructortimerreductionframes		= 36000,
	minimumconstructors					= 5,
	useresurrectors						= true,
		searesurrectors					= false,
	useconstructors						= true,
	usecollectors						= true,
}

unitControllerModuleConfig = {
	minimumrangeforfight				= 650,
}

spawnProtectionConfig = {
	useunit				= false, -- use starbox otherwise
	spread				= 100,
}

randomEventsConfig = {
	randomEventMinimumDelay = 9000*ScavRandomEventsAmountModoption, -- frames
	randomEventChance = 200*ScavRandomEventsAmountModoption, -- higher = lower chance
}

-- Functions which you can configure
function CountScavConstructors()
	return UDC(GaiaTeamID, UDN.corcom_scav.id) + UDC(GaiaTeamID, UDN.armcom_scav.id)
end

function UpdateTierChances(n)
	-- Must be 100 in total 
	if globalScore > scavconfig.timers.Endless then
		TierSpawnChances.T0 = 1
		TierSpawnChances.T1 = 1
		TierSpawnChances.T2 = 1
		TierSpawnChances.T3 = 1
		TierSpawnChances.T4 = 96
		TierSpawnChances.Message = "Current tier: Endless" 
	elseif globalScore > scavconfig.timers.T4top then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 10
		TierSpawnChances.T3 = 30
		TierSpawnChances.T4 = 60
		TierSpawnChances.Message = "Current tier: T4 Top"
	elseif globalScore > scavconfig.timers.T4high then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 30
		TierSpawnChances.Message = "Current tier: T4 High"
	elseif globalScore > scavconfig.timers.T4med then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 30
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 20
		TierSpawnChances.Message = "Current tier: T4 Medium"
	elseif globalScore > scavconfig.timers.T4low then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 40
		TierSpawnChances.T3 = 50
		TierSpawnChances.T4 = 10
		TierSpawnChances.Message = "Current tier: T4 Low"
	elseif globalScore > scavconfig.timers.T4start then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 40
		TierSpawnChances.T3 = 55
		TierSpawnChances.T4 = 5
		TierSpawnChances.Message = "Current tier: T4 Start"
	elseif globalScore > scavconfig.timers.T3top then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 70
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T3 Top"
	elseif globalScore > scavconfig.timers.T3high then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 50
		TierSpawnChances.T3 = 40
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T3 High"
	elseif globalScore > scavconfig.timers.T3med then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 60
		TierSpawnChances.T3 = 30
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T3 Medium"
	elseif globalScore > scavconfig.timers.T3low then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 65
		TierSpawnChances.T3 = 25
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T3 Low"
	elseif globalScore > scavconfig.timers.T3start then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 70
		TierSpawnChances.T3 = 10
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T3 Start"
	elseif globalScore > scavconfig.timers.T2top then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 80
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T2 Top"
	elseif globalScore > scavconfig.timers.T2high then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 30
		TierSpawnChances.T2 = 60
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T2 High"
	elseif globalScore > scavconfig.timers.T2med then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 40
		TierSpawnChances.T2 = 50
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T2 Medium"
	elseif globalScore > scavconfig.timers.T2low then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 60
		TierSpawnChances.T2 = 30
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T2 Low"
	elseif globalScore > scavconfig.timers.T2start then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 70
		TierSpawnChances.T2 = 20
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T2 Start"
	elseif globalScore > scavconfig.timers.T1top then
		TierSpawnChances.T0 = 10
		TierSpawnChances.T1 = 90
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T1 Top"
	elseif globalScore > scavconfig.timers.T1high then
		TierSpawnChances.T0 = 40
		TierSpawnChances.T1 = 60
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T1 High"
	elseif globalScore > scavconfig.timers.T1med then
		TierSpawnChances.T0 = 60
		TierSpawnChances.T1 = 40
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T1 Medium"
	elseif globalScore > scavconfig.timers.T1low then
		TierSpawnChances.T0 = 80
		TierSpawnChances.T1 = 20
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T1 Low"
	elseif globalScore > scavconfig.timers.T1start then
		TierSpawnChances.T0 = 90
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T1 Start"
	else
		TierSpawnChances.T0 = 100
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
		TierSpawnChances.Message = "Current tier: T0"
	end
end
