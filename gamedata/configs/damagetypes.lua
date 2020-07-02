--
-- Created by IntelliJ IDEA.
-- User: MaDDoX
-- Date: 14/05/17
-- Time: 04:16
--
-- Here we store which units (values) are assigned to each base damage type (keys)
-- This was used as starting values for the weapondamagetypes.lua table, which's actually used in alldefs_post to calculate damage/armor
--
local damageTypes = {

	cannon={"armcrus","armfflak","armflak","armblade","armmav","armroy","corcrus","corraid","corroy","corenaa","corflak","armst","armanac","armcroc","armlun","armpincer","corparrow","corseal","corsnap","corsok","armbull","armstump","corgol","correap","corgarp"},

	bullet={"armkam","armsaber","corcut","corfink","corveng","armpw","corak","armpt","corpt","corsub","armflash","armemp","armspid",},

	rocket={"armfig","armpship","corpship","armlance","armmerl","armsb","corcrw","corsb","cortitan","armseap","corape","corseap","corvipe","armtl","corptl","cortl","armclaw","armdl","armpb","corerad","cordl","armah","corcat","armrock","armjeth","coraak","corcrash","armaak","corstorm","armbanth","corbuzz","armmship","cormship","armptl","armaas","corbow","armsptk","corfrt","packo","armsub","corssub","tawf009","cormh","armmh","corah","armfrt","madsam",},

	laser={"armfast","armwar","corfav","armsubk","corshark","armjanus","corgator",},

	hflaser={"armllt","corllt","armhlt","corhlt","corexp","corhllt","armfhlt","corfhlt",},

	flak={"armdeva","armyork","corsent","corshred","corhrk","cordefiler",},

	neutron={"armmanni","corcan",},

	rail={"armsnipe","corsktl",},

	emp={"corstil","corbw","armemp","armspid",},

	homing={"armrl","corrl","corsumo","armfav","armcir","armsam","coratl","cormist","armatl","armmercury","corscreamer","armsfig","corsfig","corvamp","armsh","marauder","armorco","coresupp","armdecade","corsh","nsaclash","armmlv",},

	plasma={"armbeamer","armanni","corbhmth","cortoast","cordoom","corthud","armham","armraz","corkarg","krogtaar","armamb","armepoch","corbats","armbats","corblackhy","corlevlr","cormexp","cortrem",},

	explosive={"armfboy","armthund","armpnix","corhurc","corshad","armguard","corpun","corban",},

	thermo={"armzeus","cormaw","cormando","corpyro","armbrawl","armlatnk","armhawk","cortermite",},

	siege={"cormort","shiva","armfido","corkrog","armbrtha","corint","corvroc","tawf013","armmart","cormart","corwolv","tawf11",},

	omni={"armshock","corjugg","armamd","corfmd","armcarry","corcarry","armscab","cormabm","armsd","corsd","armcom","armcom2","armcom3","armdecom","corcom","corcom2","corcom3","cordecom","meteor","armjuno","armjamt","armveil","corjuno","corjamt","corshroud","armfhp","armhp","corfhp","corhp","armsy","asubpen","armaap","armalab","armap","armasy","armavp","armlab","armshltx","armshltxuw","armvp","coraap","coralab","corap","corasy","coravp","corgant","corgantuw","corlab","corsy","corvp","csubpen","armspy","armfark","armaser","armvulc","armfmine3","armmine1","armmine2","armmine3","corfmine3","cormine1","cormine2","cormine3","cormine4","armvader","corroach","corthovr","armthovr","armintr","armtship","cortship","coreter","corfgate","corgate","armfgate","armgate",
    "meteor",},

	nuke={"cortron","armliche","corsilo","armsilo",},

	none={"armpeep","armatlas","armdfly","corseah","corvalk","armsehak","corawac","armawac","corhunt","cormuskrat","cormls","armack","armacsub","armacv","armcv","armmls","coracsub","coracv","corfast","armconsul","coraca","corack","corch","corck","armch","armck","armcs","corcs","armaca","armca","armcsa","corca","corcsa","armbeaver","critter_ant","critter_duck","critter_goldfish","critter_gull","critter_penguin","cormakr","armmark","armrectr","cornecro","corspy","armnanotc","cornanotc","tllmedfusion","armmex","armmmkr","armuwes","armuwfus","armuwmex","armuwmme","armuwmmm","armuwms","armafus","armageo","armadvsol","armamex","armckfus","armdf","armfmkr","armfus","armgeo","armgmm","armmakr","armsolar","armtide","armwin","corafus","corageo","coradvsol","corfmkr","corfus","corgeo","cormex","cormmkr","cormoho","corsolar","cortide","coruwfus","coruwmex","coruwmme","coruwmmm","corwin","coreyes","corsjam","armsjam","armason","armsonar","corason","corsonar","armmoho","armmstor","armestor","armuwadves","armuwadvms","corestor","cormstor","coruwadves","coruwadvms","coruwes","coruwms","corfrad","armarad","armfrad","armrad","corarad","corrad","corfatf","armasp","armeyes","armfatf","armtarg","corasp","cortarg","armrecl","correcl","armjam","corcv","armseer","corvrad","cormlv","armdrag","armfdrag","armfort","cordrag","corfdrag","corfort",},

	["else"] = {},
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageTypes)

return damageTypes

