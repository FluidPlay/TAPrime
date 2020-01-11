function widget:GetInfo()
	return {
		name = "TAPrime Hotkeys",
		desc = "Enables TAPrime Hotkeys, including ZXCV,BN,YJ,O,Q" ,
		author = "Beherith, modified by MaDDoX",
		date = "23 march 2012",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true,
        handler = true,
	}
end

-- table of stuff that we unbind on load
local unbinds={
    "bind any+k cloak",
    "bind any+q",
    "bind q",
    "bind any+c controlunit",
    "bind c controlunit",
    "bind any+x  buildspacing dec",
    "bind x  buildspacing dec",
    "bind x  onoff",
    "bind Shift+x  onoff",
    "bindaction buildspacing dec",
    "bind any+z buildspacing inc",
    "bind z buildspacing inc",
    "bindaction buildspacing inc",
    "bind f fight",
    "bind Shift+f fight",
    "bind , prevmenu",
    "bind . nextmenu",
    "bind Any+i gameinfo",
    "bind any+m move",          -- Leaving 'M' for morph. Who uses M to move anyways?
    "bind m move",
    -- Below are new, from former uikeys.txt
    "bind Ctrl+b",
    "bind Ctrl+a",
    "bind Ctrl+d", 		--selfd
    "bind Ctrl+w", 		--FPS camera
    "bind Ctrl+shift+w", 	--FPS camera
    "bind Ctrl+Shift+d", 	--selfd queued
    "bind Ctrl+Shift+a",
    "bind Ctrl+alt+w",
    "bind alt+v",
    "bind alt+shift+v",
    "bind Any+i",		--gameinfo
    --"bind ` drawinmap",
}

-- table of stuff that we bind on load
local binds = {}
function MakeBindsTable (swapYZ)
    -- handle swapping YZ, its very awkward to have them the 'wrong' way around on AZERTY keyboards
    if swapYZ==nil then swapYZ=false end
    local Y = swapYZ and "z" or "y"
    local Z = swapYZ and "y" or "z"

    local _binds = {
        -- generic commands
        "bind Ctrl+a  select AllMap++_ClearSelection_SelectAll+",
        "bind Ctrl+b  select AllMap+_Builder_Idle+_ClearSelection_SelectOne+",
        "bind Ctrl+shift+c  select AllMap+_ManualFireUnit+_ClearSelection_SelectOne+",
        "bind Ctrl+r  select AllMap+_Radar+_ClearSelection_SelectAll+",
        "bind Ctrl+v  select AllMap+_Not_Builder_Not_Commander_InPrevSel_Not_InHotkeyGroup+_SelectAll+",
        "bind Ctrl+w  select AllMap+_Not_Aircraft_Weapons+_ClearSelection_SelectAll+",
        --"bind Ctrl+x  select AllMap+_InPrevSel_Not_InHotkeyGroup+_SelectAll+",
        "bind Ctrl+z  select AllMap+_InPrevSel+_ClearSelection_SelectAll+",
        "bind ctrl+x onoff",
        "bind l  loadunits",
        "bind Shift+l  loadunits",
        "bind u  unloadunits",
        "bind Shift+u  unloadunits",

        -- building hotkeys

        --- Metal extractors
        "bind "..Z.." buildunit_armmex",
        "bind shift+"..Z.." buildunit_armmex",
        "bind "..Z.." buildunit_cormex",
        "bind shift+"..Z.." buildunit_cormex",
        "bind "..Z.." buildunit_armmoho",
        "bind shift+"..Z.." buildunit_armmoho",
        "bind "..Z.." buildunit_cormoho",
        "bind shift+"..Z.." buildunit_cormoho",
        --- FARK-class units
        "bind "..Z.." buildunit_armfark",
        "bind shift+"..Z.." buildunit_armfark",
        "bind "..Z.." buildunit_cormuskrat",
        "bind shift+"..Z.." buildunit_cormuskrat",
        --"bind "..Z.." buildunit_corfast",
        --"bind shift+"..Z.." buildunit_corfast",
        --"bind "..Z.." buildunit_armconsul",
        --"bind shift+"..Z.." buildunit_armconsul",
        --- Underwater Metal extractors
        "bind "..Z.." buildunit_coruwmex",
        "bind shift+"..Z.." buildunit_coruwmex",
        "bind "..Z.." buildunit_armuwmex",
        "bind shift+"..Z.." buildunit_armuwmex",
        "bind "..Z.." buildunit_coruwmme",
        "bind shift+"..Z.." buildunit_coruwmme",
        "bind "..Z.." buildunit_armuwmme",
        "bind shift+"..Z.." buildunit_armuwmme",
        --- Arm Poker / Commando Mines
        "bind "..Z.." buildunit_armmine1",
        "bind shift+"..Z.." buildunit_armmine1",
        "bind "..Z.." buildunit_cormine4",
        "bind shift+"..Z.." buildunit_cormine4",

        "bind x buildunit_armsolar",        -- Solars, Wind Gens & Fusions
        "bind shift+x buildunit_armsolar",
        "bind x buildunit_armwin",
        "bind shift+x buildunit_armwin",
        "bind x buildunit_corsolar",
        "bind shift+x buildunit_corsolar",
        "bind x buildunit_corwin",
        "bind shift+x buildunit_corwin",
        --"bind x buildunit_armgeo",
        --"bind shift+x buildunit_armgeo",
        --"bind x buildunit_corgeo",
        --"bind shift+x buildunit_corgeo",
        "bind x buildunit_armfus",
        "bind shift+x buildunit_armfus",
        "bind x buildunit_corfus",
        "bind shift+x buildunit_corfus",
        "bind x buildunit_armawin",
        "bind shift+x buildunit_armawin",
        "bind x buildunit_corawin",
        "bind shift+x buildunit_corawin",

        --- Arm Poker Vehicle Mine
        "bind x buildunit_armmine3",
        "bind shift+x buildunit_armmine3",


        "bind x buildunit_armtide",
        "bind shift+x buildunit_armtide",
        "bind x buildunit_cortide",
        "bind shift+x buildunit_cortide",
        "bind x buildunit_armuwfus",
        "bind shift+x buildunit_armuwfus",
        "bind x buildunit_coruwfus",
        "bind shift+x buildunit_coruwfus",
        "bind x buildunit_armuwmmm",
        "bind shift+x buildunit_armuwmmm",
        "bind x buildunit_coruwmmm",
        "bind shift+x buildunit_coruwmmm",

        "bind c buildunit_armllt",          -- Basic Defenses (LLT, RL) & Radar
        "bind shift+c buildunit_armllt",
        "bind c buildunit_armrl",
        "bind shift+c buildunit_armrl",
        "bind c buildunit_armrad",
        "bind shift+c buildunit_armrad",
        "bind c buildunit_corllt",
        "bind shift+c buildunit_corllt",
        "bind c buildunit_corrl",
        "bind shift+c buildunit_corrl",		
        "bind c buildunit_corrad",		
        "bind shift+c buildunit_corrad",

        "bind c buildunit_armdeva",         -- adv infantry defense
        "bind shift+c buildunit_armdeva",
        "bind c buildunit_corshred",
        "bind shift+c buildunit_corshred",
        "bind c buildunit_armcir",         -- adv rocket defense
        "bind shift+c buildunit_armcir",
        "bind c buildunit_corerad",
        "bind shift+c buildunit_corerad",
        "bind c buildunit_armarad",         -- adv radar towers
        "bind shift+c buildunit_armarad",
        "bind c buildunit_corarad",
        "bind shift+c buildunit_corarad",

        "bind c buildunit_armtl",
        "bind shift+c buildunit_armtl",
        "bind c buildunit_cortl",
        "bind shift+c buildunit_cortl",		-- torpedo launcher
        "bind c buildunit_armsonar",
        "bind shift+c buildunit_armsonar",
        "bind c buildunit_corsonar",
        "bind shift+c buildunit_corsonar",
        "bind c buildunit_armfrad",
        "bind shift+c buildunit_armfrad",	-- floating radar
        "bind c buildunit_corfrad",
        "bind shift+c buildunit_corfrad",
        "bind c buildunit_armfrt",			-- floating AA
        "bind shift+c buildunit_armfrt",
        "bind c buildunit_corfrt",
        "bind shift+c buildunit_corfrt",

        -- Dragon Eyes
        "bind v buildunit_armeyes",
        "bind shift+v buildunit_armeyes",
        "bind v buildunit_coreyes",
        "bind shift+v buildunit_coreyes",

        -- Outposts
        "bind v buildunit_armoutpost2",
        "bind shift+v buildunit_armoutpost2",
        "bind v buildunit_coroutpost2",
        "bind shift+v buildunit_coroutpost2",
        "bind v buildunit_armoutpost",
        "bind shift+v buildunit_armoutpost",
        "bind v buildunit_coroutpost",
        "bind shift+v buildunit_coroutpost",

        -- Tech Centers
        "bind v buildunit_armtech",
        "bind shift+v buildunit_armtech",
        "bind v buildunit_cortech",
        "bind shift+v buildunit_cortech",
        "bind v buildunit_armtech2",
        "bind shift+v buildunit_armtech2",
        "bind v buildunit_cortech2",
        "bind shift+v buildunit_cortech2",

        -- Factories
        "bind v buildunit_armlab",
        "bind shift+v buildunit_armlab",
        "bind v buildunit_armvp",
        "bind shift+v buildunit_armvp",
        "bind v buildunit_corlab",
        "bind shift+v buildunit_corlab",
        "bind v buildunit_corvp",
        "bind shift+v buildunit_corvp",
        "bind v buildunit_armsy",
        "bind shift+v buildunit_armsy",
        "bind v buildunit_corsy",
        "bind shift+v buildunit_corsy",

        -- Advanced bot, vehicle and sea labs
        "bind alt+v buildunit_armalab",
        "bind alt+shift+v buildunit_armalab",
        "bind alt+v buildunit_coralab",
        "bind alt+shift+v buildunit_coralab",
        "bind alt+v buildunit_armavp",
        "bind alt+shift+v buildunit_armavp",
        "bind alt+v buildunit_coravp",
        "bind alt+shift+v buildunit_coravp",
        "bind alt+v buildunit_armasy",
        "bind alt+shift+v buildunit_armasy",
        "bind alt+v buildunit_corasy",
        "bind alt+shift+v buildunit_corasy",

        -- Air, Advanced Air and Experimental Gantries
        "bind ctrl+alt+v buildunit_corgant",
        "bind ctrl+alt+shift+v buildunit_corgant",
        "bind ctrl+alt+v buildunit_corgantuw",
        "bind ctrl+alt+shift+v buildunit_corgantuw",
        "bind ctrl+alt+v buildunit_armshltx",
        "bind ctrl+alt+shift+v buildunit_armshltx",
        "bind ctrl+alt+v buildunit_armshltxuw",
        "bind ctrl+alt+shift+v buildunit_armshltxuw",	-- underwater
        "bind ctrl+alt+v buildunit_armap",
        "bind ctrl+alt+shift+v buildunit_armap",
        "bind ctrl+alt+v buildunit_corap",
        "bind ctrl+alt+shift+v buildunit_corap",
        "bind ctrl+alt+v buildunit_armaap",
        "bind ctrl+alt+shift+v buildunit_armaap",
        "bind ctrl+alt+v buildunit_coraap",
        "bind ctrl+alt+shift+v buildunit_coraap",

        --"bind alt+x buildunit_corbhmth",
        --"bind alt+shift+x buildunit_corbhmth",

        -- Metal Converters, Energy and Metal Storages
        "bind f buildunit_armmakr",
        "bind shift+f buildunit_armmakr",
        "bind f buildunit_cormakr",
        "bind shift+f buildunit_cormakr",
        "bind f buildunit_armestor",
        "bind shift+f buildunit_armestor",
        "bind f buildunit_corestor",
        "bind shift+f buildunit_corestor",
        "bind f buildunit_armmstor",
        "bind shift+f buildunit_armmstor",
        "bind f buildunit_cormstor",
        "bind shift+f buildunit_cormstor",

        -- Advanced Metal Converters and Storages
        "bind f buildunit_armmmkr",
        "bind shift+f buildunit_armmmkr",
        "bind f buildunit_cormmkr",
        "bind shift+f buildunit_cormmkr",
        "bind f buildunit_armuwadves",
        "bind shift+f buildunit_armuwadves",
        "bind f buildunit_coruwadves",
        "bind shift+f buildunit_coruwadves",
        "bind f buildunit_armuwadvms",
        "bind shift+f buildunit_armuwadvms",
        "bind f buildunit_coruwadvms",
        "bind shift+f buildunit_coruwadvms",

        -- Energy defense, laser defense, heavy laser
        --"bind b buildunit_tawf001",
        --"bind shift+b buildunit_tawf001",
        --"bind b buildunit_hllt",
        --"bind shift+b buildunit_hllt",
        --"bind b buildunit_armclaw",
        --"bind shift+b buildunit_armclaw",
        --"bind b buildunit_cormaw",
        --"bind shift+b buildunit_cormaw",
        --"bind b buildunit_armhlt",
        --"bind shift+b buildunit_armhlt",
        --"bind b buildunit_corhlt",
        --"bind shift+b buildunit_corhlt",

        -- Ambusher, annihilator, bigbertha (Arm)
        "bind b buildunit_armguard",
        "bind shift+b buildunit_armguard",
        "bind b buildunit_armamb",
        "bind shift+b buildunit_armamb",
        "bind alt+b buildunit_armanni",
        "bind alt+shift+b buildunit_armanni",
        "bind alt+b buildunit_armbrtha",
        "bind alt+shift+b buildunit_armbrtha",
        -- Toaster, Doomsday Machine, Intimidator (Core)
        "bind b buildunit_corpun",
        "bind shift+b buildunit_corpun",
        "bind b buildunit_cortoast",
        "bind shift+b buildunit_cortoast",
        "bind alt+b buildunit_cordoom",
        "bind alt+shift+b buildunit_cordoom",
        "bind alt+b buildunit_corint",
        "bind alt+shift+b buildunit_corint",

        -- Nukes, Anti-nukes and LOLcannons :)
        "bind i buildunit_armsilo",
        "bind shift+i buildunit_armsilo",
        "bind i buildunit_corsilo",
        "bind shift+i buildunit_corsilo",
        -- Not included: buildunit_cortron (Tactical Nuke Launcher)
        "bind i buildunit_armamd",
        "bind shift+i buildunit_armamd",
        "bind i buildunit_corfmd",
        "bind shift+i buildunit_corfmd",
        "bind i buildunit_armvulc",
        "bind shift+i buildunit_armvulc",
        "bind i buildunit_corbuzz",
        "bind shift+i buildunit_corbuzz",

        -- Plasma Deflector
        "bind alt+i buildunit_armgate",
        "bind alt+shift+i buildunit_armgate",
        "bind alt+i buildunit_armfgate",	-- floating
        "bind alt+shift+i buildunit_armfgate",
        "bind alt+i buildunit_corgate",
        "bind alt+shift+i buildunit_corgate",
        "bind alt+i buildunit_corfgate",	-- floating
        "bind alt+shift+i buildunit_corfgate",

        -- Air Pads
        "bind p buildunit_armpad",
        "bind shift+p buildunit_armpad",
        "bind p buildunit_corpad",
        "bind shift+p buildunit_corpad",
        "bind p buildunit_armasp",
        "bind shift+p buildunit_armasp",
        "bind p buildunit_corasp",
        "bind shift+p buildunit_corasp",

        -- Build Spacing
        "bind any+t buildspacing inc",
        "bind shift+t buildspacing inc",
        "bind alt+t buildspacing dec",
        "bind alt+shift+t buildspacing dec",
        --"bind alt+"..Z.." buildspacing inc",
        --"bind shift+alt+"..Z.." buildspacing inc",
        --"bind any+alt+x buildspacing dec",
        --"bind shift+alt+x buildspacing dec",

        -- area mex
        "bind ctrl+alt+z areamex",

        -- numpad movement
        "bind numpad2 moveback",
        "bind numpad6 moveright",
        "bind numpad4 moveleft",
        "bind numpad8 moveforward",
        "bind numpad9 moveup",
        "bind numpad3 movedown",
        "bind numpad1 movefast",

        -- set target
        "bind Y settarget",
        "bind alt+Y canceltarget",
        "bind shift+q morphqueue",
        "bind shift+alt+q morphpause",
        "bind shift+alt+ctrl+q morphstop",
        "bind m morph",

        "bind j buildunit_armdrag",
        "bind shift+j buildunit_armdrag",
        "bind j buildunit_cordrag",
        "bind shift+j buildunit_cordrag",
        "bind j buildunit_armfort",
        "bind shift+j buildunit_armfort",
        "bind j buildunit_corfort",
        "bind shift+j buildunit_corfort",

        "bind q drawinmap", --some keyboards don't have ` or \
        "bind ,	buildfacing inc", --because some keyboards don't have [ and ] ke"..Y.."s
        "bind .	buildfacing dec",
        "bind o buildfacing inc", --apparently some keyboards don't have , and . either...

        "bind ctrl+f fight",

        -- New in v.0.998
        "bind Ctrl+Alt+d selfd",
        "bind Ctrl+Alt+a select AllMap++_ClearSelection_SelectAll+",

        "bind Ctrl+Alt+s SpecFullView",
        "bind Ctrl+Alt+m minimap simplecolors 1",

        -- Modified to select all builders in MaDDPack. You can filter the type
        --   the bottom row selector, and get only idle ones with the left row selector.
        "bind Ctrl+b select AllMap+_Not_Building_Not_NameContain_Nano_Builder_Not_NameContain_Commander+_ClearSelection_SelectAll+",
        "bind Ctrl+Alt+w select AllMap+_Aircraft_Weapons+_ClearSelection_SelectAll+",

        "bind space deselect",
        "bind Ctrl+p pause",
        "bind Ctrl+Alt+z areamex",
        "bind any+k wantcloak", --cloak was deprecated in the engine
        "bind Alt+z select Visible+_InPrevSel+_ClearSelection_SelectAll+",
        "bind Any+f9 showhealthbars",
    }

    binds = _binds
end

-----------

function LoadBindings()
    for k,v in ipairs(unbinds) do
        Spring.SendCommands("un"..v)
    end

    MakeBindsTable(WG.swapYZbinds) -- in case Y/Z swap has changed since last load

    for k,v in ipairs(binds) do
        Spring.SendCommands(v)
    end
end

function UnloadBindings()
    for k,v in ipairs(binds) do
        Spring.SendCommands("un"..v)
    end

    for k,v in ipairs(unbinds) do
        Spring.SendCommands(v)
    end
end

function ReloadBindings()
    UnloadBindings()
    LoadBindings()
end

function widget:Initialize()
    MakeBindsTable(WG.swapYZbinds)
    LoadBindings()

    WG.Reload_TAP_Hotkeys = ReloadBindings
end

function widget:Shutdown()
    UnloadBindings()
    WG.Reload_TAP_Hotkeys = nil

    if widgetHandler.orderList and (widgetHandler.orderList["TAPrime Hotkeys -- swap YZ"] or 0) > 0 then
        widgetHandler:DisableWidget("TAPrime Hotkeys -- swap YZ")
    end
end
