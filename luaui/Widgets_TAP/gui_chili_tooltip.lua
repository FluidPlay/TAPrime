function widget:GetInfo()
    return {
        version   = "0.1",
        name      = "chiliTooltip",
        desc      = "Tooltip panel implemented with chili ui",
        author    = "Adrianulima",
        date      = "WIP",
        license   = "GNU GPL, v2 or later",
        layer     = -100,
        enabled   = true,
        handler   = true,
    }
end
--------------------------------------------------------------------------------
-- Localize
local sGetWindowGeometry = Spring.GetWindowGeometry
local sGetCurrentTooltip = Spring.GetCurrentTooltip
local sGetSelectedUnitsCount = Spring.GetSelectedUnitsCount
local sSendCommands = Spring.SendCommands
local sSetDrawSelectionInfo = Spring.SetDrawSelectionInfo

local stringformat = string.format

-- Chili classes
local Chili, Window, TextBox, Image, Button, Grid, Label, ScrollPanel, color2incolor

-- Global vars
local tooltipWindow, tooltipTextBox
local vsx, vsy = sGetWindowGeometry()
local fontfileScale = (0.75 + (vsx*vsy / 7000000))
local fontfileSize = 15 -- 40; 18

local Config = {
    tooltip = {
        x = '0%', y = '90%',
        width = '40%', height = '15%',
        fontSize = fontfileSize * fontfileScale, --19, --15,
        maxWidth = 1020,
        padding = {5, 5, 5, 5},     -- outer panel
    },
}
--------------------------------------------------------------------------------
-- Helpers
local function createTooltipWindow(config)
    local textBox = TextBox:New{
        name = 'textBox_tooltip',
        x=0, right=0,
        y=0, bottom=0,
        autosize = true,
        caption = '',
        fontsize = config.fontSize,
        color = {1, 0.75, 0.75, 1},
    }
    local textBoxWindow = Window:New{
        name = 'window_tooltip',
        parent = Chili.Screen0,
        x = config.x, y = config.y,
        --height = config.height, width = config.width,
        height = config.height,
        autosize = true,
        savespace = true,
        --maxWidth = config.maxWidth,
        children = {textBox},
        bringToFrontOnClick = false, dockable = false, draggable = false,
        resizable = false, tweakDraggable = true, tweakResizable = false,
        padding = config.padding,
    }
    --textBoxWindow:Hide()
    return textBox, textBoxWindow
end --createGridWindow

local function getEditedCurrentTooltip()
    local text = sGetCurrentTooltip()
    --extract the exp value with regexp
    local expPattern = "Experience (%d+%.%d%d)"
    local currentExp = tonumber(text:match(expPattern))
    --replace with limexp: exp/(1+exp) since all spring exp effects are linear in limexp, multiply by 10 because people like big numbers instead of [0,1]
    return currentExp and text:gsub(expPattern,stringformat("Experience %.2f", 10*currentExp/(1+currentExp)) ) or text
end --getEditedCurrentTooltip
--------------------------------------------------------------------------------
local function InitializeControls()
    vsx, vsy = sGetWindowGeometry()
    fontfileScale = (0.75 + (vsx*vsy / 7000000))
    Config.tooltip.fontSize = fontfileSize * fontfileScale
    tooltipTextBox, tooltipWindow = createTooltipWindow(Config.tooltip)
end --InitializeControls

local function updateTooltipText()
    local unitsCount = sGetSelectedUnitsCount()
    local units = ""
    if (unitsCount ~= 0) then
        units = "Selected units: " .. unitsCount .. "\n"
    else
        units = "\n"
    end
    tooltipTextBox:SetText(units .. (getEditedCurrentTooltip() or sGetCurrentTooltip()))
end --updateSelection
--------------------------------------------------------------------------------
function widget:Initialize()
    sSetDrawSelectionInfo(false) --disables springs default display of selected units count
    sSendCommands("tooltip 0")

    if not WG.Chili then
        widgetHandler:RemoveWidget()
        return
    end

    Chili = WG.Chili
    Window = Chili.Window
    TextBox = Chili.TextBox
    Grid = Chili.Grid
    Image = Chili.Image
    Button = Chili.Button
    Label = Chili.Label
    ScrollPanel = Chili.ScrollPanel
    color2incolor = Chili.color2incolor

    InitializeControls()
end --Initialize

function widget:Update()
    updateTooltipText()
end --Update

function widget:ViewResize(newX,newY)
    tooltipWindow:Dispose()
    InitializeControls()

    --vsx, vsy = sGetWindowGeometry()
    --fontfileScale = (0.75 + (vsx*vsy / 7000000))
    ----Config.tooltip.fontSize = fontfileSize * fontfileScale
    --tooltipTextBox.fontsize = fontfileSize * fontfileScale
    --updateTooltipText()
end

function widget:Shutdown()
    tooltipWindow:Dispose()
    sSendCommands("tooltip 1")
end
