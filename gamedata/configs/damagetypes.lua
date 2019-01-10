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

	cannon={"armcrus","armfflak","armflak","armmav","armroy","corcrus","corraid","corroy","corenaa","corflak","armst","armanac","armcroc","armlun","armpincer","corparrow","corseal","corsnap","corsok","armbull","armstump","corgol","correap","corgarp"},

	bullet={"armkam","armsaber","corcut","corfink","corveng","armamph","coramph","armpw","corak","armpt","corpt","corsub","armflash","corgripn","bladew","armemp","armspid",},

	rocket={"armfig","armlance","armmerl","armsb","blade","corcrw","corsb","cortitan","armseap","corape","corseap","corvipe","armtl","corptl","cortl","armclaw","armdl","armpb","corerad","cordl","armah","armraven","armrock","armjeth","coraak","corcrash","armaak","corstorm","armbanth","corbuzz","armmship","cormship","armptl","armaas","corarch","armsptk","corfrt","packo","armsub","corssub","tawf009","cormh","armmh","corah","armfrt","madsam",},

	laser={"armfast","armflea","armwar","commando","corfav","armsubk","corshark","armjanus","corgator",},

	hflaser={"armllt","corllt","armhlt","corhlt","corexp","hllt","armfhlt","corfhlt",},

	flak={"armdeva","armyork","corsent","corshred","corhrk",},

	neutron={"armmanni","corcan",},

	rail={"armsnipe","corsktl",},

	emp={"corgripn","bladew","armemp","armspid",},

	homing={"armrl","corrl","corsumo","armfav","armcir","armsam","coratl","cormist","armatl","mercury","screamer","armsfig","corsfig","corvamp","armsh","marauder","armorco","coresupp","decade","corsh","nsaclash","armmlv",},

	plasma={"tawf001","armanni","cordefiler","corbhmth","cortoast","cordoom","corthud","armham","armraz","corkarg","krogtaar","armamb","aseadragon","corbats","armbats","corblackhy","corlevlr","cormexp","trem",},

	explosive={"armfboy","armthund","armpnix","corhurc","corshad","armguard","corpun","tawf114",},

	thermo={"armzeus","cormaw","corpyro","armbrawl","armlatnk","armhawk","cortermite",},

	siege={"cormort","shiva","armfido","corkrog","armbrtha","corint","corvroc","tawf013","armmart","cormart","corwolv","tawf11",},

	omni={"armshock","gorg","armamd","corfmd","armcarry","corcarry","armscab","cormabm","armsd","corsd","armcom","armcom2","armcom3","armdecom","corcom","corcom2","corcom3","cordecom","meteor","ajuno","armjamt","armveil","cjuno","corjamt","corshroud","armfhp","armhp","corfhp","corhp","armsy","asubpen","armaap","armalab","armap","armasy","armavp","armlab","armplat","armshltx","armshltxuw","armvp","coraap","coralab","corap","corasy","coravp","corgant","corgantuw","corlab","corplat","corsy","corvp","csubpen","armspy","armfark","armaser","armvulc","armfmine3","armmine1","armmine2","armmine3","corfmine3","cormine1","cormine2","cormine3","cormine4","armsilo","armvader","corroach","corthovr","armthovr","intruder","armtship","cortship","coreter","corfgate","corgate","armfgate","armgate",},

	nuke={"cortron","armcybr","corsilo","armsilo",},

	none={"armpeep","armatlas","armdfly","armsl","corvalk","armsehak","corawac","armawac","corhunt","cormuskrat","cormls","armack","armacsub","armacv","armcv","armmls","coracsub","coracv","corfast","consul","coraca","corack","corch","corck","armch","armck","armcs","corcs","armaca","armca","armcsa","corca","corcsa","armbeaver","critter_ant","critter_duck","critter_goldfish","critter_gull","critter_penguin","cormakr","armmark","corspec","armrectr","corvoyr","cornecro","corspy","armnanotc","cornanotc","tllmedfusion","armmex","armmmkr","armuwes","armuwfus","armuwmex","armuwmme","armuwmmm","armuwms","aafus","amgeo","armadvsol","armamex","armckfus","armdf","armfmkr","armfus","armgeo","armgmm","armmakr","armsolar","armtide","armwin","cafus","cmgeo","coradvsol","corfmkr","corfus","corgeo","cormex","cormmkr","cormoho","corsolar","cortide","coruwfus","coruwmex","coruwmme","coruwmmm","corwin","coreyes","corsjam","armsjam","armason","armsonar","corason","corsonar","armmoho","armmstor","armestor","armuwadves","armuwadvms","corestor","cormstor","coruwadves","coruwadvms","coruwes","coruwms","corfrad","armarad","armfrad","armrad","corarad","corrad","corfatf","armasp","armeyes","armfatf","armtarg","corasp","cortarg","armrecl","correcl","armjam","corcv","armseer","corvrad","cormlv","armdrag","armfdrag","armfort","cordrag","corfdrag","corfort",},

	["else"] = {},
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageTypes)

return damageTypes

