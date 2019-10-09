local armorDefs = {
	commander = {
		"armcom", "armcom2", "armcom3", "armdecom", "corcom", "corcom2", "corcom3", "cordecom",
	},
	aiv = {
		"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "corfast",
		"critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
	},
	artillery = {"armfido","armmart","armmerl","corcat","armshock","corhrk","cormart","cormh","cormort","corvroc","corwolv","corjugg","shiva","tawf013","cortrem",},

	invader={"armfast", "corsktl", "armspid", "cormando", "corpyro",},

	assault={"armlatnk","armfav","armjanus","armmlv","armkam","armsh","armspy","cordefiler","coresupp","corbw","corfav","corlevlr","corsh","corvrad","decade","marauder","nsaclash",},

	bomber={"armliche","armlance","armpnix","armsb","armthund","armstil","corhurc","corsb","corshad","cortitan","armblade",},

	gunship={"armatlas","armbrawl","armdfly","armpeep","armsaber","armseap","corseah","corape","corcrw","corcut","corfink","corseap","corvalk",},

	defense={"armvulc","armamb","armamd","armclaw","armdl","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armpb","corbhmth","corbuzz","corexp","corfgate","corfhlt","cormaw","corfmd","corgate","corhlt","corllt","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint","armamex",},

	defenseaa={"armrl","armatl","armcir","armdeva","armfflak","armflak","armfrt","coratl","corenaa","corerad","corflak","corfrt","corrl","madsam","armmercury","packo","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl",},

	heavybot={"corkrog","armmav","armsptk","armsnipe", "armmark", "armzeus", "armfboy", "cortermite", "corsumo",},

	heavyveh={"armsam", "cormist", "armmanni", "armjam", "corban",},

	peon={"armack","armch","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak","coramph","corch","corck","cornecro","corspy","corsub","corvoyr",},

	fighter={"armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corcsa","corhunt","corsfig","corvamp","corveng",},

	rpg={"armaak","armah","armjeth","armmh","armrock","coraak","corah","corbow","corcrash","corstorm",},

	stalwart={"armbanth","armham","armorco","armraz","armvader","armwar","corcan","corkarg","corroach","corthud","corthovr","krogtaar","meteor","tawf009",},

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

	tank={"armanac","armbull","armcroc","armlun","armpincer","armscab","armseer","armst","armstump","armthovr","cordl","coreter","corgarp","corgol","cormabm","cormlv","corparrow","corraid","correap","corseal","corsilo","corsnap","corsok","armintr",},

	lightship = {"corpt", "corcrus", "armpt", "armcrus",},

	supportship = {"armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam", "armaas",
				   "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam",},

	heavyship = {"armroy", "armtship", "armbats", "armsub", "armcarry", "armepoch",
				 "corshark", "corssub", "corcarry", "corroy", "cortship", "corbats", "corblackhy",} ,

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
