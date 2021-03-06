return {
	cormh = {
		acceleration = 0.072,
		brakerate = 0.336,
		buildcostenergy = 3300,
		buildcostmetal = 200,
		buildpic = "CORMH.DDS",
		buildtime = 3500,
		canmove = true,
		category = "ALL HOVER MOBILE WEAPON NOTSUB NOTSHIP NOTAIR SURFACE",
		collisionvolumeoffsets = "0 1 0",
		collisionvolumescales = "33 12 43",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Hovercraft Rocket Launcher",
		energymake = 2.6,
		energyuse = 2.6,
		explodeas = "mediumexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 495,
		maxslope = 16,
		maxvelocity = 2.42,
		maxwaterdepth = 0,
		movementclass = "HOVER3",
		name = "Nixer",
		nochasecategory = "VTOL",
		objectname = "CORMH",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd",
		sightdistance = 509,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.5972,
		turnrate = 455,
		customparams = {
			
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "-0.112327575684 -0.511842897949 -0.201560974121",
				collisionvolumescales = "30.0869903564 18.3419342041 34.3326873779",
				collisionvolumetype = "Box",
				damage = 297,
				description = "Nixer Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 119,
				object = "CORMH_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 149,
				description = "Nixer Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 48,
				object = "3X3C",
                collisionvolumescales = "55.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg2",
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "hovmdok2",
			},
			select = {
				[1] = "hovmdsl2",
			},
		},
		weapondefs = {
			cormh_weapon = {
				areaofeffect = 80,
				avoidfeature = false,
				craterareaofeffect = 80,
				craterboost = 0,
				cratermult = 0,
				cegTag = "missiletrailsmall-starburst",
				explosiongenerator = "custom:genericshellexplosion-medium-bomb",
				firestarter = 100,
				firesubmersed = true,
				flighttime = 10,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				metalpershot = 0,
				model = "armmhmsl",
				name = "Rocket",
				noselfdamage = true,
				range = 700,
				reloadtime = 9,
				soundhit = "xplomed4",
				soundhitwet = "splssml",
				soundhitwetvolume = 0.5,
				soundstart = "Rockhvy1",
				smoketrail = false,
				texture1 = "trans",
				texture2 = "null",
				texture3 = "null",
				tolerance = 4000,
				turnrate = 24384,
				weaponacceleration = 70,
				weapontimer = 3,
				weapontype = "StarburstLauncher",
				weaponvelocity = 480,
				damage = {
					default = 550,
					subs = 5,
				},
				customparams = {
					bar_model = "corkbmissl1.s3o",
					light_mult = 2.4,
					light_radius_mult = 1,
					light_color = "1 0.6 0.17",
					expl_light_mult = 1.1,
					expl_light_radius_mult = 1.1,
					expl_light_life_mult = 1.1,
					expl_light_color = "1 0.5 0.05",
					expl_light_heat_radius_mult = 2.2,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "MOBILE",
				def = "CORMH_WEAPON",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
