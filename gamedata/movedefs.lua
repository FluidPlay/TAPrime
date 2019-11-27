
local moveDatas = {
	AKBOT2 = {	--Used by Commanders
        allowRawMovement = true,
		crushstrength = 50,
		depthmod = 0,
		footprintx = 2,
		footprintz = 2,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 50,
		depthModParams = {
			minHeight = 0,
			linearCoeff = 0.03,
			maxScale = 1.4,
		}
	},
	AKBOTBOMB2 = {
        allowRawMovement = true,
		crushstrength = 50,
		depthmod = 0,
		footprintx = 2,
		footprintz = 2,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 50,
		depthModParams = {
			constantCoeff = 1.5,
		},
	},
	ANT = {
        allowRawMovement = true,
		footprintX = 1,
		footprintZ = 1,
		maxWaterDepth = 2,
		crushStrength = 0,
		speedModClass = 1, -- 0 = tank, 1 = kbot, 2 = hover, 3 = ship 
	},
	ALTVEH = {	-- Amphibious light vehicles, like the Muskrat
        allowRawMovement = true,
		crushstrength = 10,	-- plasma kbot crushresistance = 400
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TANK2 = {	-- Stumpy, Raider, Leveler -- (can crush light bots but not plasma bots or DTs)
        allowRawMovement = true,
		crushstrength = 300,	-- plasma kbots crushresistance = 400
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TANK3 = {	-- Poker, Samson, Seer, Merl -- (Can't crush except for rifle bots)
        allowRawMovement = true,
		crushstrength = 4, --15, (missile kbots crushresistance = 5)
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HTANK3 = {	-- Bulldog, Reaper
        allowRawMovement = true,
		crushstrength = 999,
		footprintx = 4,	--3
		footprintz = 4,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	ATANK3 = {	-- Triton (lvl3), Croc
        allowRawMovement = true,
		crushstrength = 2499,
		depthmod = 0,
		footprintx = 4.5,	--3
		footprintz = 4.5,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	HTANK4 = {	-- Goliath
        allowRawMovement = true,
		crushstrength = 2499,
		footprintx = 4,
		footprintz = 4,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	ATANK4 = {	-- Poison
        allowRawMovement = true,
		crushstrength = 1499,
		depthmod = 0,
		footprintx = 5,
		footprintz = 5,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	BOAT4 = {
        allowRawMovement = true,
		crushstrength = 40,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 8,
	},
	BOAT5 = {
        allowRawMovement = true,
		crushstrength = 50,
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 10,
	},
	--[[ 
	DBOAT3 = {
		crushstrength = 30,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 15,
	},
	]]--
	CRITTERH = {
        allowRawMovement = true,
		crushstrength = 0,
		footprintx = 1,
		footprintz = 1,
		maxslope = 50,
		maxwaterslope = 255,
		maxWaterDepth = 255,
		minwaterdepth = 15,
		speedModClass = 2, -- 0 = tank, 1 = kbot, 2 = hover, 3 = ship 
	},
	DBOAT6 = {
        allowRawMovement = true,
		crushstrength = 252,
		footprintx = 6,
		footprintz = 6,
		minwaterdepth = 15,
	},
	HAKBOT4 = {
        allowRawMovement = true,
		crushstrength = 252,
		depthmod = 0,
		footprintx = 4,
		footprintz = 4,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	--[[
	HDBOAT8 = {
		crushstrength = 1400,
		footprintx = 8,
		footprintz = 8,
		minwaterdepth = 15,
	},
	]]--
	HKBOT3 = {
        allowRawMovement = true,
		crushstrength = 1400,
		footprintx = 3,
		footprintz = 3,
		maxslope = 36,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HKBOT4 = {
        allowRawMovement = true,
		crushstrength = 1400,
		footprintx = 4,
		footprintz = 4,
		maxslope = 36,
		maxwaterdepth = 128, --26,
		depthModParams = {
			minHeight = -4,
			linearCoeff = 0.03,
			--maxValue = 0.7,
            maxScale = 1.1,
		}
	},
	HKBOT5 = {
        allowRawMovement = true,
		crushstrength = 1400,
		footprintx = 5,
		footprintz = 5,
		maxslope = 36,
		maxwaterdepth = 30,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HOVER3 = {
        allowRawMovement = true,
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 25,
		footprintx = 3,
		footprintz = 3,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HHOVER3 = {
        allowRawMovement = true,
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 252,
		footprintx = 3,
		footprintz = 3,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HOVER4 = {
        allowRawMovement = true,
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 25,
		footprintx = 4,
		footprintz = 4,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HTKBOT4 = {
        allowRawMovement = true,
		crushstrength = 252,
		footprintx = 4,
		footprintz = 4,
		maxslope = 80,
		maxwaterdepth = 128, --22,
		depthModParams = {
			minHeight = -4,
			linearCoeff = 0.03,
			--maxValue = 0.7,
            maxScale=1.25,
		}
	},
	KBOT1 = {
        allowRawMovement = true,
		crushstrength = 5,
		footprintx = 1,
		footprintz = 1,
		maxslope = 36,
		maxwaterdepth = 5,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
    KBOT12X2 = {
        allowRawMovement = true,
        crushstrength = 5,
        footprintx = 2,
        footprintz = 2,
        maxslope = 36,
        maxwaterdepth = 5,
        depthModParams = {
            minHeight = 4,
            linearCoeff = 0.03,
            maxValue = 0.7,
        }
    },
	KBOT2 = {		-- All basic kbots really
        allowRawMovement = true,
		crushstrength = 1,		--10
		footprintx = 3,
		footprintz = 3,
		maxslope = 36,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TKBOT2 = {
        allowRawMovement = true,
		crushstrength = 15,
		footprintx = 2,
		footprintz = 2,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TKBOT3 = {
        allowRawMovement = true,
		crushstrength = 15,
		footprintx = 3,
		footprintz = 3,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	VKBOT3 = {
        allowRawMovement = true,
		crushstrength = 1400,
		depthmod = 0,
		footprintx = 3,
		footprintz = 3,
		maxslope = 24,
		maxwaterdepth = 5000,
		maxwaterslope = 30,
	},
	VKBOT5 = {
        allowRawMovement = true,
		crushstrength = 1400,
		depthmod = 0,
		footprintx = 5,
		footprintz = 5,
		maxslope = 24,
		maxwaterdepth = 5000,
		maxwaterslope = 30,
	},

	-- Ships
	BOAT4 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 8,
	},

	BOAT42X2 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 2,
		footprintz = 2,
		minwaterdepth = 8,
	},
	BOAT43X3 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 8,
	},

	BOAT44X4 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 8,
	},
	BOAT45X5 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 5,
		footprintz = 5,
		minwaterdepth = 8,
	},

	BOAT46X6 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 6,
		footprintz = 6,
		minwaterdepth = 8,
	},

	BOAT47X7 = {
        allowRawMovement = true,
		crushstrength = 9,
		footprintx = 7,
		footprintz = 7,
		minwaterdepth = 8,
	},

	BOAT5 = {
        allowRawMovement = true,
		crushstrength = 16,
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 10,
	},

	BOAT53X3 = {
        allowRawMovement = true,
		crushstrength = 16,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 10,
	},
	BOAT54X4 = {
        allowRawMovement = true,
		crushstrength = 16,
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 10,
	},
	BOAT55X5 = {
        allowRawMovement = true,
		crushstrength = 16,
		footprintx = 5,
		footprintz = 5,
		minwaterdepth = 10,
	},

	BOAT56X6 = {
        allowRawMovement = true,
		crushstrength = 16,
		footprintx = 6,
		footprintz = 6,
		minwaterdepth = 10,
	},
	
	-- Subs
	UBOAT3 = {
        allowRawMovement = true,
		footprintx = 2,
		footprintz = 2,
		minwaterdepth = 22, --15
		crushstrength = 5,
		subMarine = 1,
	},
    UBOAT33X3 = {
        allowRawMovement = true,
        footprintx = 3,
        footprintz = 3,
        minwaterdepth = 22, --15
        crushstrength = 5,
        subMarine = 1,
    },
	--[[
	UBOAT4 = {
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 40,
		crushstrength = 5,
		subMarine = 1,
	},
	]]--
	NANO = {
        allowRawMovement = true,
		crushstrength = 0,
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 0,
	},

	--- Chicken Movedefs
	CHICKENNANO = {
        allowRawMovement = true,
		crushstrength = 0,
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 0,
	},
	CHICKQUEEN = {
        allowRawMovement = true,
		footprintx=3,
		footprintz=3,
		maxwaterdepth=72,
		maxslope=40,
		crushstrength=15000,
		avoidMobilesOnPath=false,
	},
	CHICKENHKBOT1 = {
        allowRawMovement = true,
		footprintx=1,
		footprintz=1,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=100,
	},
	CHICKENHKBOT2 = {
        allowRawMovement = true,
		footprintx=2,
		footprintz=2,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=200,
	},
	CHICKENHKBOT3 = {
        allowRawMovement = true,
		footprintx=3,
		footprintz=3,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=500,
	},
	CHICKENHKBOT4 = {
        allowRawMovement = true,
		footprintx=4,
		footprintz=4,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=900,
	},
	CHICKENHKBOT5 = {
        allowRawMovement = true,
		footprintx=5,
		footprintz=5,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=2000,
	},
	CHICKENHKBOT6 = {
        allowRawMovement = true,
		footprintx=6,
		footprintz=6,
		maxwaterdepth=22,
		maxslope=36,
		crushstrength=6000,
	},
	CHICKENHOVERDODO = {
        allowRawMovement = true,
		footprintx = 1,
		footprintz = 1,
		maxslope = 30,
		maxwaterslope = 255,
	},
}

--------------------------------------------------------------------------------
-- Final processing / array format
--------------------------------------------------------------------------------
local defs = {}

for moveName, moveData in pairs(moveDatas) do
	
	moveData.heatmapping = (Spring.GetModOptions() and tonumber(Spring.GetModOptions().mo_heatmap) and (tonumber(Spring.GetModOptions().mo_heatmap) ~= 0))
	moveData.name = moveName
	
	defs[#defs + 1] = moveData
end

return defs

