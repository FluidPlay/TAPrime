Spring.Echo("[Scavengers] Config initialized")

--- Modoptions --TODO: Integrate with in-game modoptions

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

--- End of Modoptions

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
		reinforcementsModule			= true, --false, (Can beacons be captured/destroyed?)
        randomEventsModule				= ScavRandomEventsEnabledModoption,
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
			scorePerKilledBuilding 			= 9, --4,
			scorePerKilledConstructor 		= 49, --99,
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
		-- On function UpdateTierChances() you have tier chances for every timer and then it's RNG
		-- Eg: T2start has 20% chance for T2 and 80% chance for T1; It's transition so it doesn't switch instantly from.pure T1 to pure T2
		T2start								= 4200*ScavTechCurveModoption, --2250, 2925
		T2low								= 4900*ScavTechCurveModoption, --3900
		T2med								= 5875*ScavTechCurveModoption,
		T2high								= 6850*ScavTechCurveModoption,
		T2top								= 7800*ScavTechCurveModoption,
		T3start								= 8500*ScavTechCurveModoption, -- 7500
		T3low								= 9500*ScavTechCurveModoption, -- 9000
		T3med								= 10500*ScavTechCurveModoption,
		T3high								= 12000*ScavTechCurveModoption,
		T3top								= 13500*ScavTechCurveModoption,
		T4start								= 14000*ScavTechCurveModoption, --15000
		T4low								= 16000*ScavTechCurveModoption, --18000
		T4med								= 19000*ScavTechCurveModoption, --21000
		T4high								= 22000*ScavTechCurveModoption, --24000
		T4top								= 24000*ScavTechCurveModoption, --28000
		BossFight							= 26000*ScavTechCurveModoption, --32000
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
		FinalBossHealth						= 80000*ScavBossHealthModoption, --140000, --250000, 180000 -- this*teamcount*difficulty
		FinalBossMinionsPassive				= 3000, -- this/(teamcount*difficulty), how often does boss spawn minions passively, frames.
		FinalBossMinionsActive				= 750, --150, -- this/(teamcount*difficulty), how often does boss spawn minions when taking damage, frames.
	BossWaveTimeLeft					= 180, --900,
	aircraftchance 						= 8, --6,9 [M] -- higher number = lower chance
	--- globalscoreperoneunit: Let's say scavs are on 3000 score, and score per unit is 1000,
	-- it will spawn 3 units if all other multipliers are 1 but there are multipliers for land/sea/air and multipliers for tiers
	globalscoreperoneunit 				= 1000, --4500,
	spawnchance							= 140, -- 20, 120; lower = more
	beaconspawnchance					= 60,
	minimumspawnbeacons					= 3,
	landmultiplier 						= 0.75,
	airmultiplier 						= 0.7, --2.0, 0.6 [M]
	seamultiplier 						= 0.2,
	chanceforaircraftonsea				= 6, --2, -- higher number = lower chance

	t0multiplier						= 3.5, --3,    ---Higher number bigger wave
	t1multiplier						= 2.2, --2.5, 2 [M]
	t2multiplier						= 1.1,  -- 0.8, 1 [M]
	t3multiplier						= 0.175, -- 0.1, 0.165 [M]
	t4multiplier						= 0.025, -- 0.05, 0.03 [M]
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
	if globalScore > scavconfig.timers.T4top then
		TierSpawnChances.T0 = 0
		TierSpawnChances.T1 = 0
		TierSpawnChances.T2 = 10
		TierSpawnChances.T3 = 30
		TierSpawnChances.T4 = 60
        TierSpawnChances.Message = "Current tier: Endless"
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
    elseif globalScore > scavconfig.timers.T2top then   -- Numbers below must always sum up to 100
		TierSpawnChances.T0 = 5 -- 10
		TierSpawnChances.T1 = 10
		TierSpawnChances.T2 = 85
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
        TierSpawnChances.Message = "Current tier: T2 Top"
    elseif globalScore > scavconfig.timers.T2high then
		TierSpawnChances.T0 = 5  --10
		TierSpawnChances.T1 = 25 --30
		TierSpawnChances.T2 = 70 --60
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
        TierSpawnChances.Message = "Current tier: T2 High"
    elseif globalScore > scavconfig.timers.T2med then
		TierSpawnChances.T0 = 5  --10
		TierSpawnChances.T1 = 35 --40
		TierSpawnChances.T2 = 60 --50
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
		TierSpawnChances.T0 = 30 --10
		TierSpawnChances.T1 = 70 --90
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
        TierSpawnChances.Message = "Current tier: T1 Top"
	elseif globalScore > scavconfig.timers.T1high then
		TierSpawnChances.T0 = 50 --40
		TierSpawnChances.T1 = 50 --60
		TierSpawnChances.T2 = 0
		TierSpawnChances.T3 = 0
		TierSpawnChances.T4 = 0
        TierSpawnChances.Message = "Current tier: T1 High"
    elseif globalScore > scavconfig.timers.T1med then
		TierSpawnChances.T0 = 70 --60
		TierSpawnChances.T1 = 30 --40
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