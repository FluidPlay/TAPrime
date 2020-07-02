function widget:GetInfo()
    return {
        name    = "Set Engine Font",
        desc    = "Sets the engine's default system font",
        author  = "MaDDoX, based on work by Floris",
        date    = "April 2020",
        layer   = -99989,
        enabled = true,
        handler = true,
    }
end

local customScale = 1.16
local centerPosX = 0.5	-- note: dont go too far from 0.5
local centerPosY = 0.49	-- note: dont go too far from 0.5

--    local fontfile = "fonts/" .. Spring.GetConfigString("bar_font", "Poppins-Regular.otf")
local fontfile = "fonts/Akrobat-SemiBold.otf"
local vsx,vsy = Spring.GetViewGeometry()
local widgetScale = (0.5 + (vsx*vsy / 5700000)) * customScale
WG.uiScale = widgetScale

local fontfileScale = (0.5 + (vsx*vsy / 5700000))
local fontfileSize = 40 --36
local fontfileOutlineSize = 9
local fontfileOutlineStrength = 2 --1.4
local font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)

local bgMargin = 6
local screenHeight = 520-bgMargin-bgMargin
local screenWidth = 1050-bgMargin-bgMargin

local screenX = (vsx*centerPosX) - (screenWidth/2)
local screenY = (vsy*centerPosY) + (screenHeight/2)


local function setEngineFont()
    local relativesize = 0.75
    --"fonts/FreeSansBold.otf"
    Spring.SetConfigInt("SmallFontSize", fontfileSize*fontfileScale * relativesize)
    Spring.SetConfigInt("SmallFontOutlineWidth", fontfileOutlineSize*fontfileScale * relativesize)
    Spring.SetConfigInt("SmallFontOutlineWeight", fontfileOutlineStrength * 1.5)

    Spring.SetConfigInt("FontSize", fontfileSize*fontfileScale * relativesize)
    Spring.SetConfigInt("FontOutlineWidth", fontfileOutlineSize*fontfileScale * relativesize)
    Spring.SetConfigInt("FontOutlineWeight", fontfileOutlineStrength * 1.5)

    --Spring.SendCommands("font "..Spring.GetConfigString("bar_font2", "Exo2-SemiBold.otf"))
    Spring.SendCommands("font Akrobat-SemiBold.otf")

    -- set spring engine default font cause it cant thee game archive fonts on launch
    Spring.SetConfigString("SmallFontFile", "FreeSansBold.otf")
    Spring.SetConfigString("FontFile", "FreeSansBold.otf")
end

setEngineFont() -- Makes sure it's ran as soon as the widget is loaded
function widget:ViewResize()
    vsx,vsy = Spring.GetViewGeometry()
    screenX = (vsx*centerPosX) - (screenWidth/2)
    screenY = (vsy*centerPosY) + (screenHeight/2)
    widgetScale = (0.5 + (vsx*vsy / 5700000)) * customScale
    widgetScale = widgetScale * (1 - (0.11 * ((vsx/vsy) - 1.78)))		-- make smaller for ultrawide screens
    WG.uiScale = widgetScale
    local newFontfileScale = (0.5 + (vsx*vsy / 5700000))
    if (fontfileScale ~= newFontfileScale) then
        fontfileScale = newFontfileScale
        font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
        setEngineFont()
    end
    --if windowList then gl.DeleteList(windowList) end
    --windowList = gl.CreateList(DrawWindow)
end
