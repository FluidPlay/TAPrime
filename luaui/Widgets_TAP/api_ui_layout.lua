
function widget:GetInfo()
    return {
        name      = "BGU layout",
        desc      = "Controls the positioning of the main BGU elements",
        author    = "Bluestone",
        date      = "socks",
        license   = "GPLv2",
        layer     = -999, -- before all UI elements
        enabled   = true,
        api       = true,
        handler   = true,
    }
end

-- todo: add font sizes that scale with screen?

local min = math.min
local max = math.max
local floor = math.floor
local vsx, vsy, screenAspect
local initialized
local screenAspect

local layouts = {
    "classic",
    "inverted",
    "hybrid",
    "spacious",
}
local options = {
    layout = "classic" -- default
}

-- ui element positions (& related menu button sizes)
local UIcoords = {
    minimap = {},
    sInfo = {},
    buildMenu = {},
    -- buildMenu controls its own width, according to how many buttons it displays
    -- build menu buttons?

    orderMenu = {},
    orderMenuButton = {},
    stateMenu = {},
    stateMenuButton = {},

    -- res bars
    -- todo

    -- console/chonsole
    -- todo


    -- player list has to choose its own dimensions
}

-------------------------------------
-- helpers

local function ApplyViewGeometry(t)
    local converted = {}
    for k,v in pairs(t) do
        converted[k] = {}
        for k2,v2 in pairs(v) do
            if k2=='x' or k2=='w' then
                converted[k][k2] = v2*vsx
            elseif k2=='y' or k2=='h' then
                converted[k][k2] = v2*vsy
            else
                converted[k][k2] = v2
            end
        end
    end
    return converted
end

local function GetMinimapDimensions(minW, maxW, minH, maxH)
    local screenW,screenH = Spring.GetViewGeometry()
    local mapAspect = Game.mapX/Game.mapY
    local relAspect = (screenW*maxW)/(screenH*maxH)
    local h,w
    if mapAspect <= relAspect then
        -- height limited
        h = screenH * maxH
        w = min(max(h*mapAspect, screenW*minW), screenW*maxW)
    else
        -- width limited
        w = screenW * maxW
        h = min(max(w/mapAspect, screenH*minH), screenH*maxH)
    end
    return w/screenW, h/screenH
end


-------------------------------------
-- classic

local function Classic()
    local minimapW,minimapH = GetMinimapDimensions(0.12, 0.27, 0.12, 0.27)
    local minimap = {x=0, y=0, w=minimapW, h=minimapH}

    local sInfoH = 0.2
    local sInfo = {x=0, y=1-sInfoH, w=sInfoH/screenAspect, h=sInfoH}

    local factionChange = {x=sInfo.w, y=1-0.08, w=0.17, h=0.08}

    local stateMenu = {x=sInfo.w, y=1-sInfo.h, w=0.06, h=sInfo.h}
    local stateGrid = {rows=9, cols=1, align="bottom"}

    local buildMenu = {x=0, y=max(minimapH,0.2), w=stateMenu.x+stateMenu.w, h=1-max(minimapH,0.2)-sInfo.h, menuTabs="internal", hideFacBar=true}
    local buildGrid = {wantedRows=4, wantedCols=3, maxRows=7, maxCols=5, maxGUICols=4, orientation="horizontal"}

    local facBar = {x=0, y=max(minimapH,0.2), w=0.25, h=1-max(minimapH,0.2)-sInfo.h}
    local facBarButton = {h=0.06}

    local orderMenuButton = {w=0.055/screenAspect, h=0.055}
    local orderMenu = {x=stateMenu.x+stateMenu.w, y=1-3*orderMenuButton.h, w=nil, h=nil, align="bottom", hideFacBar=false}
    local orderGrid = {rows=1, cols=24} -- it might override

    local resBars = {x=1-0.3, y=0, w=0.3, h=0.09}
    local clockFPS = {x=1-0.16, y=resBars.h+0.005, w=0.155, h=0.02}
    local musicPlayer = {x=1-0.16, y=clockFPS.y+clockFPS.h+0.005, w=0.155, h=0.09}
    local comCounter = {x=clockFPS.x-0.06/screenAspect-0.005, y=resBars.h, w=0.06/screenAspect, h=0.06}

    local consoleLeft = minimapW+0.05
    local consoleRight = resBars.x
    local console = {x=consoleLeft, y=0, w=max(0,consoleRight-consoleLeft), h=0.15}
    local chonsole = {x=consoleLeft, y=console.h, w=console.w, h=nil}

    UIcoords = {
        minimap=minimap, sInfo=sInfo,
        buildMenu=buildMenu, buildGrid=buildGrid,
        facBar=facBar, facBarButton=facBarButton, factionChange=factionChange,
        stateMenu=stateMenu, stateGrid=stateGrid,
        orderMenu=orderMenu, orderMenuButton=orderMenuButton, orderGrid=orderGrid,
        resBars=resBars, clockFPS=clockFPS, comCounter=comCounter, musicPlayer=musicPlayer,
        console=console, chonsole=chonsole,
    }
end

local function Hybrid()
    local minimapW,minimapH = GetMinimapDimensions(0.12, 0.27, 0.12, 0.27)
    local minimap = {x=0, y=0, w=minimapW, h=minimapH}
    local sInfoH = 0.2
    local sInfo = {x=0, y=max(minimapH,0.2), w=sInfoH/screenAspect, h=sInfoH}

    local stateMenu = {x=sInfo.w, y=sInfo.y, w=0.06, h=sInfo.h, menuTabs="internal"}
    local stateGrid = {rows=9, cols=1, align="bottom"}

    local buildMenu = {x=0, y=sInfo.y+sInfo.h, w=stateMenu.x+stateMenu.w, h=1-max(minimapH,0.2)-sInfo.h, menuTabs="internal", hideFacBar=true}
    local buildGrid = {wantedRows=4, wantedCols=3, maxRows=7, maxCols=5, maxGUICols=4, orientation="horizontal"}

    local factionChange = {x=buildMenu.w, y=1-0.08, w=0.17, h=0.08}

    local facBar = {x=0, y=sInfo.y+sInfo.h, w=0.25, h=1-max(minimapH,0.2)-sInfo.h}
    local facBarButton = {h=0.06}

    local orderMenuButton = {w=0.055/screenAspect, h=0.055}
    local orderMenu = {x=0.25, y=1-3*orderMenuButton.h, w=nil, h=nil, align="bottom", hideFacBar=false}
    local orderGrid = {rows=1, cols=21} -- it might override

    local resBars = {x=1-0.3, y=0, w=0.3, h=0.09}
    local clockFPS = {x=1-0.16, y=resBars.h+0.005, w=0.155, h=0.02}
    local musicPlayer = {x=1-0.16, y=clockFPS.y+clockFPS.h+0.005, w=0.155, h=0.09}
    local comCounter = {x=clockFPS.x-0.06/screenAspect-0.005, y=resBars.h, w=0.06/screenAspect, h=0.06}

    local consoleLeft = minimapW+0.05
    local consoleRight = resBars.x
    local console = {x=consoleLeft, y=0, w=max(0,consoleRight-consoleLeft), h=0.15}
    local chonsole = {x=consoleLeft, y=console.h, w=console.w, h=nil}

    UIcoords = {
        minimap=minimap, sInfo=sInfo,
        buildMenu=buildMenu, buildGrid=buildGrid,
        facBar=facBar, facBarButton=facBarButton, factionChange=factionChange,
        stateMenu=stateMenu, stateMenuButton=stateMenuButton, stateGrid=stateGrid,
        orderMenu=orderMenu, orderMenuButton=orderMenuButton, orderGrid=orderGrid,
        resBars=resBars, clockFPS=clockFPS, comCounter=comCounter, musicPlayer=musicPlayer,
        console=console, chonsole=chonsole,
    }
end

-------------------------------------
-- inverted

local function Inverted()
    local minimapW,minimapH = GetMinimapDimensions(0.12, 0.28, 0.12, 0.28)
    local minimap = {x=0, y=1-minimapH, w=minimapW, h=minimapH}
    local sInfo = {x=0, y=0, w=0.2/screenAspect, h=0.2}

    local factionChange = {x=minimap.w, y=1-0.08, w=0.17, h=0.08}

    local stateMenu = {x=sInfo.w, y=0, w=0.06, h=sInfo.h}
    local stateGrid = {rows=9, cols=1, align="bottom"}

    local buildMenu = {x=0, y=sInfo.h, w=stateMenu.x+stateMenu.w, h=1-sInfo.h-minimapH, menuTabs="internal", hideFacBar=true}
    local buildGrid = {wantedRows=4, wantedCols=3, maxRows=7, maxCols=5, maxGUICols=4, orientation="horizontal"}

    local facBar = {x=0, y=sInfo.h, w=0.25, h=0.5}
    local facBarButton = {h=0.06}

    local orderMenuButton = {w=0.055/screenAspect, h=0.055}
    local orderMenu = {x=minimapW, y=1-3*orderMenuButton.h, w=nil, h=nil, align="bottom", hideFacBar=false}
    local orderGrid = {rows=1, cols=21} -- it might override

    local resBars = {x=1-0.3, y=0, w=0.3, h=0.09}
    local clockFPS = {x=1-0.16, y=resBars.h+0.005, w=0.155, h=0.02}
    local musicPlayer = {x=1-0.16, y=clockFPS.y+clockFPS.h+0.005, w=0.155, h=0.09}
    local comCounter = {x=clockFPS.x-0.06/screenAspect-0.005, y=resBars.h, w=0.06/screenAspect, h=0.06}

    local consoleLeft = stateMenu.x+stateMenu.w+0.05
    local consoleRight = resBars.x
    local console = {x=consoleLeft, y=0, w=max(0,consoleRight-consoleLeft), h=0.15}
    local chonsole = {x=consoleLeft, y=console.h, w=console.w, h=nil}

    UIcoords = {
        minimap=minimap, sInfo=sInfo,
        buildMenu=buildMenu, buildGrid=buildGrid,
        facBar=facBar, facBarButton=facBarButton, factionChange=factionChange,
        stateMenu=stateMenu, stateMenuButton=stateMenuButton, stateGrid=stateGrid,
        orderMenu=orderMenu, orderMenuButton=orderMenuButton, orderGrid=orderGrid,
        resBars=resBars, clockFPS=clockFPS, comCounter=comCounter, musicPlayer=musicPlayer,
        console=console, chonsole=chonsole,
    }
end

-------------------------------------
-- spacious

local function Spacious()
    local minimapW,minimapH = GetMinimapDimensions(0.12, 0.27, 0.12, 0.27)
    local minimap = {x=0, y=0, w=minimapW, h=minimapH}

    local resBars = {x=1-0.3, y=0, w=0.3, h=0.09}
    local clockFPS = {x=1-0.16, y=resBars.h+0.005, w=0.155, h=0.02}
    local musicPlayer = {x=1-0.16, y=clockFPS.y+clockFPS.h+0.005, w=0.155, h=0.09}
    local comCounter = {x=clockFPS.x-0.06/screenAspect-0.005, y=resBars.h, w=0.06/screenAspect, h=0.06}

    local orderMenuButton = {w=0.055/screenAspect, h=0.055}
    local orderMenu = {x=0, y=minimapH, w=nil, h=nil, align="left", hideFacBar=true}
    local orderGrid = {rows=3, cols=8} -- it might override

    local sInfo = {x=0, y=1-0.18, w=0.18/screenAspect, h=0.18}

    local stateMenuW = 0.06 --math.max(minimapW - orderGrid.rows * orderMenuButton.w, 0.06)
    local stateMenu = {x=orderGrid.rows * orderMenuButton.w, y=minimapH, w=stateMenuW, h=0.2}
    local stateGrid = {rows=9, cols=1, align="top"}

    local buildMenu = {x=sInfo.x + sInfo.w, y=1-sInfo.h, w=0.13, h=sInfo.h, menuTabs="top", hideFacBar=false}
    local buildGrid = {wantedRows=2, wantedCols=2, maxRows=2, maxCols=18, maxGUICols=12, orientation="vertical"}

    local factionChange = {x=0, y=sInfo.y-0.08, w=sInfo.w, h=0.08}

    local facBar = {x=0, y=minimap.h, w=0.25, h=1-minimap.h-sInfo.h}
    local facBarButton = {h=0.06}

    local consoleLeft = minimapW+0.05
    local consoleRight = resBars.x
    local console = {x=consoleLeft, y=0, w=max(0,consoleRight-consoleLeft), h=0.15}
    local chonsole = {x=consoleLeft, y=console.h, w=console.w, h=nil}

    UIcoords = {
        minimap=minimap, sInfo=sInfo,
        buildMenu=buildMenu, buildGrid=buildGrid,
        facBar=facBar, facBarButton=facBarButton, factionChange=factionChange,
        stateMenu=stateMenu, stateMenuButton=stateMenuButton, stateGrid=stateGrid,
        orderMenu=orderMenu, orderMenuButton=orderMenuButton, orderGrid=orderGrid,
        resBars=resBars, clockFPS=clockFPS, comCounter=comCounter, musicPlayer=musicPlayer,
        console=console, chonsole=chonsole,
    }
end


-------------------------------------
-- other position related functionality

local function RelativeFontSize(i)
    -- set font sizes relative to vsy=1000
    local size = i*vsy/1000
    size = floor(size/2+0.5)*2
    return size
end

local function Cost(uDef)
    return 60*uDef.metalCost + uDef.energyCost
end

local function WaterOnly(unitDef)
    local water = (unitDef.minWaterDepth>0) or string.find(unitDef.moveDef and unitDef.moveDef.name or "", "hover")
    return water
end

local function BuildOrderComparator(item1, item2)
    -- from sMenu
    -- determines the order of uDIDs in the build menu
    local uDef1 = UnitDefs[item1.uDID]
    local uDef2 = UnitDefs[item2.uDID]

    -- cons at top
    local con1 = uDef1.isBuilder
    local con2 = uDef2.isBuilder
    if (con1 and not con2) then return true end
    if (con2 and not con1) then return false end

    -- water at bottom
    local water1 = WaterOnly(uDef1)
    local water2 = WaterOnly(uDef2)
    if (water1 and not water2) then return false end
    if (water2 and not water1) then return true end

    -- then by cost
    local cost1= Cost(uDef1)
    local cost2= Cost(uDef2)
    return (cost1<cost2)
end

-------------------------------------
-- callins etc

local function SetLayout(layout)
    local oldLayout = options.layout
    layout = layout or options.layout
    options.layout = layout

    if layout=="classic" then Classic()
    elseif layout=="hybrid" then Hybrid()
    elseif layout=="inverted" then Inverted()
    elseif layout=="spacious" then Spacious()
    else Classic() --default if options are broken
    end

    WG.UIcoords = ApplyViewGeometry(UIcoords)
    WG.UIcoords.layout = layout
    WG.UIcoords.SetLayout = SetLayout

    if initialized and oldLayout~=layout then
        for name,wData in pairs(widgetHandler.knownWidgets) do
            local _, _, category = string.find(wData.basename, '([^_]*)')
            if category=='bgu' and wData.active then
                widgetHandler:ToggleWidget(name)
                widgetHandler:ToggleWidget(name)
            end
        end
    end
	
	WG.UIcoords.layouts = layouts
	for i,lo in pairs(layouts) do
		if lo==layout then
			WG.UIcoords.layoutID = i
			break
		end
	end			
end

function widget:Initialize()
    vsx,vsy = Spring.GetViewGeometry()
    screenAspect = vsx/vsy

    WG.UIcoords = {}
    WG.UIcoords.SetLayout = SetLayout

    WG.RelativeFontSize = RelativeFontSize
    WG.BuildOrderComparator = BuildOrderComparator -- used by both hotkeys and sMenu

    SetLayout()

    initialized = true
end

function widget:ViewResize(x, y)
    vsx = x
    vsy = y
    screenAspect = vsx/vsy
    SetLayout()
end

function widget:GetConfigData()
    return options
end

function widget:SetConfigData(data)
    if data then
        options = data
    end
end