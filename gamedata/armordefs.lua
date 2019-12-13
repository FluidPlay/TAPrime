local armorDefs = {
    lightbot={"armack","armch","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak",
              "coramph","corch","corck","cornecro","corspy","corsub","corvoyr","armfast", "corsktl", "armspid",
              "cormando", "corpyro",},
    supportbot={"armaak","armah","armjeth","armmh","armrock","coraak","corhrk","corah","corcrash","corstorm",},

    heavybot={"corkrog","armmav","armsptk","armsnipe", "armmark", "armzeus", "armfboy", "cortermite", "corsumo","armbanth",
              "armham","armorco","armraz","armvader","armwar","corcan","corkarg","corroach","corthud","corthovr","krogtaar",
              "meteor","tawf009",},

    --++++==== Vehicles
	lightveh = {
		"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "corfast",
		"critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
        "armlatnk","armfav","armjanus","armmlv","armkam","armsh","armspy","cordefiler","coresupp","corbw","corfav",
        "corlevlr","corsh","corvrad","decade","marauder","nsaclash",
	},
	supportveh = {"armfido","armmart","armsam", "cormist", "armmerl","corcat","armshock","cormart","cormh","cormort","corvroc","corwolv","corjugg","shiva","tawf013","cortrem",},

	heavyveh={"armanac","armbull","armcroc","armlun","armpincer","armscab","armseer","armst","armstump","armthovr","cordl",
              "coreter","corgarp","corgol","cormabm","cormlv","corparrow","corraid","correap","corseal","corsilo","corsnap",
              "corsok","armintr","armmanni", "armjam", "corban",},

    --++++==== Air
	lightair={"armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corcsa","corhunt","corsfig","corvamp","corveng",},
	supportair={"armatlas","armbrawl","armdfly","armpeep","armsaber","armseap","corseah","corape","corcut","corfink","corseap","corvalk","armblade",},
	heavyair={"armliche","armlance","armpnix","armsb","armthund","corstil","corhurc","corsb","corshad","cortitan","corcrw",},

    --++++==== Structures & Defenses
	defense={"armvulc","armamb","armamd","armclaw","armdl","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armpb","corbhmth","corbuzz","corexp","corfgate","corfhlt","cormaw","corfmd","corgate","corhlt","corllt","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint","armamex",},

	defenseaa={"armrl","armatl","armcir","armdeva","armfflak","armflak","armfrt","coratl","corenaa","corerad","corflak","corfrt","corrl","madsam","armmercury","packo","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl",},

	resource={ "armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","armafus","corafus","armuber","coruber","armgeo","armgmm","armageo",
        "armuwmex","armuwmme","armtide","coruwmex","coruwmme","cortide",},

	structure={"armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
		"cortech","cortech2", "cortech3","cortech4","armawin","corawin","armjuno","armaap","armadvsol","armalab","armap","armarad","armaser","armason",
		"armasp","armasy","armavp","armbeaver","armckfus","armdf","armestor","armeyes","armfatf","armfdrag","armfgate","armfhp","armfmine3","armfmkr","armfort","armfrad",
		"armgate","armhp","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armrad","armsd","armshltx",
		"armveil","armvp","armwin","asubpen","corjuno","corageo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
		"cordrag","corestor","coreyes","corfatf","corfdrag","corfhp","corfmine3","corfmkr","corfort","corfrad","corgant","corgantuw","corgeo","corhp",
		"corjamt","corlab","cormakr","cormexp","cormine1","cormine2","cormine3","cormine4","cormmkr","cormstor","cornanotc","corrad","corsd",
		"corshroud","corsonar","corsy","cortarg","cortron","coruwadves","coruwadvms","coruwes","coruwfus","coruwmmm","coruwms",
		"corvp","corwin","csubpen","tllmedfusion","armsonar",},

    --++++==== Ships
	lightship = {"corpt", "corcrus", "armpt", "armcrus",},
	supportship = {"armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam", "armaas",
				   "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam", "corbow",},
	heavyship = {"armroy", "armtship", "armbats", "armsub", "armcarry", "armepoch",
				 "corshark", "corssub", "corcarry", "corroy", "cortship", "corbats", "corblackhy",} ,

    --++++==== Extras
	commander = {
		"armcom", "armcom2", "armcom3", "armcom4", "armdecom", "corcom", "corcom2", "corcom3", "corcom4","cordecom",
	},

	["else"] = {},
}


--[[
-- -- put any unit that doesn't go in any other category in light armor
for name, ud in pairs(DEFS.unitDefs) do
	local found
	for categoryName, categoryTable in pairs(armorDefs) do
		for _, usedName in pairs(categoryTable) do
			if (usedName == name) then
				found = true
			end
		end
	end
	if (not found) then
		table.insert(armorDefs.LIGHT, name)
		--Spring.Echo("Unit: ", ud.unitname, " Armorclass: light armor")
	end
end
--]]

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(armorDefs)

return armorDefs
