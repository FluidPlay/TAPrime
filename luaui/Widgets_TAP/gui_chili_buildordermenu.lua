function widget:GetInfo()
    return {
        version   = "0.1",
        name      = "chiliBuildOrderMenu",
        desc      = "Build/Order menu implemented with chili ui",
        author    = "Adrianulima",
        date      = "WIP",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true, --false,
        handler   = true,
    }
end
--------------------------------------------------------------------------------
VFS.Include("gamedata/taptools.lua")

-- Localize
local spForceLayoutUpdate = Spring.ForceLayoutUpdate
local spSetActiveCommand = Spring.SetActiveCommand
local spGetCmdDescIndex = Spring.GetCmdDescIndex
local spGetActiveCommand = Spring.GetActiveCommand
local spGetWindowGeometry = Spring.GetWindowGeometry
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetSelectedUnits = Spring.GetSelectedUnits

local stringfind = string.find
local stringsub = string.sub
local stringgsub = string.gsub
local mathceil = math.ceil
local mathmax = math.max
local mathmin = math.min

local fontSizeOffset = 0 -- -5 || Buttons' font size offset (anything but zero is breaking with small screen sizes)

local glGetTextWidth = gl.GetTextWidth

-- Chili classes
local Chili, Window, Image, Button, Grid, Label, ScrollPanel, color2incolor

-- Global vars
local orderWindow, buildWindow, buildWindowAdv, orderGrid, buildGrid, buildGridAdv, updateRequired, tooltip, btWidth
local chiliCache = {}
local vsx, vsy = spGetWindowGeometry()

local Config = {
    ordermenu = {
        name = 'ordermenu',
        rows = 5, columns = 4,
        x = '0%', y = '25%',
        width = '17%', height = '17.5%', --width 14, height 20%
        orientation = 'horizontal',
        maxWidth = 490, --420
        padding = {2, 2, 2, 2},     -- outer panel
    },
    buildmenu = {
        name = 'buildmenu',
        rows = 3, columns = 5,
        x = '0%', y = '42.5%',
        width = '17%', height = '14%', --was 15 -- button width/height within the area (20,20)
        orientation = 'horizontal',
        maxWidth = 490,
        padding = {5, 5, 5, 5},
        --sortBy = 'customParams.tier',
    },
    buildmenuAdv = {
        name = 'buildmenuAdv',
        rows = 3, columns = 5,
        x = '0%', y = '57%', --64.5
        width = '17%', height = '14%', -- 20, 20
        orientation = 'horizontal',
        maxWidth = 490,
        padding = {5, 5, 5, 5},
        --sortBy = 'customParams.tier',
    },
    labels = {
        --captionFontMinSize = 12, -- test, not being used currently
        captionFontMaxSize = 18, --10, --18,
        queueFontSize = 24, --18, --32 (MaDDoX)
        costFontSize = 15, --9,
        showMetalCost = true,
        showEnergyCost = false, --true
    },
    hiddenCMDs = {
        timewait = true, deathwait = true, squadwait = true, gatherwait = true,
        loadonto = true, selfd = false, settargetnoground = true, manualfire = true,
    },
}
--------------------------------------------------------------------------------
-- Helpers
local function deepEquals(t1, t2, ignore_mt)
    if t1 == t2 then return true end
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepEquals(v1, v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepEquals(v1, v2) then return false end
    end
    return true
end --deepEquals

local function getProp(object, path, defaultValue)
    local t = {}
    local i = 1
    for str in string.gmatch(path, "([^.]+)") do
        t[i] = str
        i = i + 1
    end
    local value = object
    i = 1
    while t[i] do
        if not value then return defaultValue end
        value = value[t[i]]
        i = i + 1
    end
    return value or defaultValue
end --getProp

local function sortElements(t, a, b, p)
    local objA = getProp(UnitDefNames[t[a].name], p, nil)
    if objA then
        local objB = getProp(UnitDefNames[t[b].name], p, nil)
        if objB then
            return objA < objB
        end
    end
    return false
end --sortElements

local function processRelativeCoord(code, total)
    local num = tonumber(code)
    if (type(code) == "string") then
        local percent = tonumber(code:sub(1,-2)) or 0
        if (percent<0) then
            percent = 0
        elseif (percent>100) then
            percent = 100
        end
        return math.floor(total * percent/100)
    elseif (num)and((1/num)<0) then
        return math.floor(total + num)
    else
        return math.floor(num or 0)
    end
end --processRelativeCoord

local function createGridWindow(config)
    local scroll =  ScrollPanel:New{
        name = 'scroll_' .. config.name,
        x = '0%', y = '0%',
        width = '100%', height = '100%',
        padding = config.padding,
    }
    local grid = Grid:New{
        name = 'grid_' .. config.name,
        x = '0%', y = '0%',
        width = '100%', height = '100%',
        rows = config.rows,
        columns = config.columns,
        orientation = config.orientation,
        padding = {0, 0, 0, 0},
    }
    local gridWindow = Window:New{
        name = 'window_' .. config.name,
        parent = Chili.Screen0,
        x = config.x, y = config.y,
        height = config.height, width = config.width,
        maxWidth = config.maxWidth,
        children = {grid},
        bringToFrontOnClick = false, dockable = true, draggable = false,
        resizable = false, tweakDraggable = true, tweakResizable = false,
        padding = config.padding,
    }

    local function updateGrid()
        local rowsNeeded = mathceil(#grid.children / grid.columns)
        if rowsNeeded > grid.rows then
            local ratio = (gridWindow.height / config.rows) / (gridWindow.width / config.columns)
            grid:SetPos(nil, nil, nil, (grid.width / grid.columns) * ratio * rowsNeeded)
            grid.rows = rowsNeeded
            if grid.parent and grid.parent.name == gridWindow.name then
                gridWindow:RemoveChild(grid)
                gridWindow:AddChild(scroll)
                scroll:AddChild(grid)
            end
        elseif rowsNeeded <= config.rows then
            grid:SetPos(nil, nil, nil, gridWindow.height - gridWindow.padding[2] - gridWindow.padding[4])
            grid.rows = config.rows
            if scroll.parent and scroll.parent.name == gridWindow.name then
                scroll:RemoveChild(grid)
                gridWindow:RemoveChild(scroll)
                gridWindow:AddChild(grid)
            end
        end
    end

    grid.updateGrid = updateGrid
    gridWindow:Hide()
    return grid, gridWindow -- buttons, frame
end --createGridWindow

local function applyHighlightHandler(button, cmd)
    local selected = {0.85, 0.65, 0, 0.5}
    local hovered = {0.75, 0.75, 0.75, 0.25}
    local out = {0, 0, 0, 0}
    local disabled = {0, 0, 0, 0.6}
    local upgrading = { 0.85, 0, 0.85, 0.6}

    local highlight = chiliCache['highlight' .. button.cmdID] or Image:New{
        name = 'highlight' .. button.cmdID,
        parent = button.image or button,
        file   = 'LuaUI/Images/button-highlight.dds',
        width = '100%', height = '100%',
        fixedRatio = false, keepAspect = false,
        color = out,
    }
    chiliCache['highlight' .. button.cmdID] = highlight
    local function updateSelection(cmdID)
        local function tryApplyColor(color)
            if highlight.color ~= color then
                highlight.color = color
                highlight:Invalidate()
            end
        end
        local function isUpgrading(unitID)
            if unitID == nil then
                return false
            end
            local upgPerc = spGetUnitRulesParam(unitID, "upgrade")
            if upgPerc == nil then
                return false
            end
            upgPerc = tonumber(upgPerc)
            return upgPerc > 0 and upgPerc < 1
        end
        if cmd.disabled then
            tryApplyColor(disabled)
            if button.state.hovered then
                tooltip = stringgsub(cmd.tooltip, "Metal cost %d*\nEnergy cost %d*\n", "")
            end
        --- Using cmd.showUnique for per-unit upgrade buttons
        elseif cmd.showUnique then
            --Spring.Echo("Show Unique found!")
            if button.state.hovered then
                tooltip = stringgsub(cmd.tooltip, "Metal cost %d*\nEnergy cost %d*\n", "")
            end
            local selectedUnit = spGetSelectedUnits()[1]
            if selectedUnit and isUpgrading(selectedUnit) then
                tryApplyColor(upgrading)
            else
                tryApplyColor(out) end
        elseif button.cmdID == cmdID then
            tryApplyColor(selected)
        elseif button.state.hovered then
            tooltip = stringgsub(cmd.tooltip, "Metal cost %d*\nEnergy cost %d*\n", "")
            tryApplyColor(hovered)
        else tryApplyColor(out)
        end
    end
    button.updateSelection = updateSelection
    updateSelection()   -- (cmdID == nil)  =>  no highlight
    return button
end --applyHighlightHandler

local function applyStateHandler(button, cmd)
    local stateCount = #cmd.params - 1
    local state = cmd.params[1] + 1

    local function curve(c) return -0.5 * c * (c - 4) end -- makes yellow more vivid
    local function getStateColor(i)
        local g = (i - 1) / (stateCount - 1)
        return (i == state) and {curve(1 - g), curve(g), 0, 1} or {0.9, 0.9, 0.9, 0.3}
    end

    local stateButtons = {}
    for i = 1, stateCount do
        local pad = 7
        local sx = (100 - pad * (stateCount + 3)) / stateCount
        local px = pad + i * pad + (i - 1) * sx
        stateButtons[i] = chiliCache['stateButton_' .. cmd.id .. '_' .. i] or Image:New{
            name = 'stateButton_' .. cmd.id .. '_' .. i,
            parent = button,
            file   = 'LuaUI/Images/button-highlight.dds',
            x = px .. '%', y = '75%',
            width = sx .. '%', maxHeight = 6,
            keepAspect = false,
            color = getStateColor(i),
        }
        chiliCache['stateButton_' .. cmd.id .. '_' .. i] = stateButtons[i]
    end
    local oldUpdateSelection = button.updateSelection
    local function updateSelection(cmdID)
        oldUpdateSelection(cmdID)
        for i = 1, stateCount do stateButtons[i].color = getStateColor(i) end
    end
    button.updateSelection = updateSelection
    return button
end --applyStateHandler
--------------------------------------------------------------------------------
local function InitializeControls()
    if not orderGrid or not orderWindow then
        orderGrid, orderWindow = createGridWindow(Config.ordermenu)
    end
    if not buildGrid or not buildWindow then
        buildGrid, buildWindow = createGridWindow(Config.buildmenu)
    end
    if not buildGridAdv or not buildWindowAdv then
        buildGridAdv, buildWindowAdv = createGridWindow(Config.buildmenuAdv)
    end
end --InitializeControls

---- One of the selected units is an upgrading tech center, block left-click at it
--local function getUpgradeStatus(cmdID) -- => upgrading techcenter was clicked, other tech center was clicked
--    --local selUnits = spGetSelectedUnits()
--    --for i = 1, #selUnits do
--        --- WG.upgrades = { techID = { techCenter = unitID, status = "nonupgraded"|"upgrading"|"upgraded", ...},..}
--        --local selUnit = selUnits[i]
--    --for techID, data in pairs(WG.upgrades) do
--    --    local upgLock = data.status == "upgrading" and data.cmdID == cmdID --upgrade.techCenter == selUnit and
--    --    if upgLock then
--    --        --Spring.Echo("Status: upgrade lock")
--    --        return true
--    --    end
--    --end
--    local techID = WG.techProxycmdIDs[cmdID]
--    if techID and WG.techIDs[techID] then
--        local upgrade = WG.upgrades[techID] --= { techCenterID = unitID, status = status }
--        return upgrade.status
--    end
--    return "nonupgraded"    -- All other cmdIDs are also clear this way
--end

local function ActionCommand(self, x, y, mouse, mods)
    local index = spGetCmdDescIndex(self.cmdID)
    if index then
        local left, right = mouse == 1, mouse == 3
        local alt, ctrl, meta, shift = mods.alt, mods.ctrl, mods.meta, mods.shift
        --- If cmdID is for an upgrade, check its status, might fire if it's a right click
        --local status = getUpgradeStatus(self.cmdID)
        --if status == "nonupgraded" or (status =="upgrading" and right) then
        spSetActiveCommand(index, mouse, left, right, alt, ctrl, meta, shift)
        --end
    end
end --ActionCommand

local function addOrderCommand(cmd)
    local button
    if cmd.texture and cmd.texture ~= "" then --cmd.onlyTexture and
        local image = chiliCache['button' .. cmd.id .. 'texture'] or Image:New{
            name = 'button' .. cmd.id .. 'texture',
            --cmdID = cmd.id,
            width = '95%', height = '95%',
            file = cmd.texture,
            padding = {1, 1, 1, 1}, -- spacing around "blocked/unavailable" dark rectangle
            margin = {0, 0, 0, 0}, -- 4,4,4,4 top, bottom, left, right
            --OnClick = {ActionCommand},
        }
        chiliCache['button' .. cmd.id .. 'texture'] = image

        button = chiliCache['button' .. cmd.id] or Button:New{
            name = 'button' .. cmd.id,
            --parent = orderGrid,
            cmdID = cmd.id,
            image = image,
            caption = '',
            textPadding = 8, -- (MaDDoX)
            padding = {0, 0, 0, 0},
            margin = {1, 1, 1, 1}, --2,2,2,2 (separation between buttons)
            OnMouseUp = {ActionCommand},
        }
        if not image.parent then
            button:AddChild(image)
        end
    else
        button = chiliCache['button' .. cmd.id] or Button:New{
            name = 'button' .. cmd.id,
            --parent = orderGrid,
            cmdID = cmd.id,
            caption = cmd.name,
            textPadding = 8, -- (MaDDoX)
            padding = {0, 0, 0, 0},
            margin = {2, 2, 2, 2},
            OnMouseUp = {ActionCommand},
        }
        local truncName = cmd.name
        if not string.find(cmd.name,"\n") then
            truncName = (string.len(cmd.name) > 11) and cmd.name:sub(0,11).."." or cmd.name
        end
        button:SetCaption(truncName) --cmd.name
        local s = (btWidth - button.textPadding * 2) / glGetTextWidth(button.caption)
        button.font:SetSize(mathmin(s, Config.labels.captionFontMaxSize) + fontSizeOffset)
    end
    chiliCache['button' .. cmd.id] = button
    applyHighlightHandler(button, cmd)
    orderGrid:AddChild(button)
end --addOrderCommand

local function addStateCommand(cmd)
    local button
    if cmd.texture and cmd.texture ~= "" then
        local image = chiliCache['button' .. cmd.id .. 'texture'] or Image:New{
            name = 'button' .. cmd.id .. 'texture',
            --cmdID = cmd.id,
            width = '95%', height = '95%',
            file = cmd.texture,
            padding = {0, 0, 0, 0},
            margin = {4, 4, 4, 4},
            --OnClick = {ActionCommand},
        }
        chiliCache['button' .. cmd.id .. 'texture'] = image

        button = chiliCache['button' .. cmd.id] or Button:New{
            name = 'button' .. cmd.id,
            --parent = orderGrid,
            cmdID = cmd.id,
            image = image,
            caption = '',
            textPadding = 8, -- (MaDDoX)
            padding = {0, 0, 0, 0},
            margin = {2, 2, 2, 2},
            OnMouseUp = {ActionCommand},
        }
        if not image.parent then
            button:AddChild(image)
        end
    else button = chiliCache['button' .. cmd.id] or Button:New{
            name = 'button' .. cmd.id,
            cmdID = cmd.id,
            caption = cmd.params[cmd.params[1] + 2],
            textPadding = 12, --8,
            padding = {0, 0, 0, 0},
            margin = {2, 2, 2, 2},
            OnMouseUp = {ActionCommand},
        }
        button:SetCaption(cmd.params[cmd.params[1] + 2])
    end
    chiliCache['button' .. cmd.id] = button
    local s = (btWidth - button.textPadding * 2) / glGetTextWidth(button.caption)
    button.font:SetSize(mathmin(s, Config.labels.captionFontMaxSize)+fontSizeOffset)
    applyHighlightHandler(button, cmd)
    applyStateHandler(button, cmd)
    orderGrid:AddChild(button)
end --addStateCommand

local function addBuildCommand(cmd, advanced)
    local image = chiliCache['button' .. cmd.id] or Image:New{
        name = 'button' .. cmd.id,
        cmdID = cmd.id,
        width = '100%', height = '100%',
        file = '#' .. cmd.id * -1,
        padding = {0, 0, 0, 0},
        margin = {2, 2, 2, 2},
        OnClick = {ActionCommand},
    }
    chiliCache['button' .. cmd.id] = image

    if cmd.params[1] then
        if (not chiliCache['queueLabel' .. cmd.id]) then
            chiliCache['queueLabel' .. cmd.id] = Label:New{
                name = 'queueLabel' .. cmd.id,
                parent = image,
                right = '5%', y = '5%',
                align = 'right',
                valign = 'top',
                --caption = tostring(cmd.params[1] or ''),
                font = {
                    size = Config.labels.queueFontSize,
                    outline = true, shadow  = true,
                    outlineWidth  = 4, outlineWeight = 4,
                },
            }
        end
    end
    if chiliCache['queueLabel' .. cmd.id] then
        chiliCache['queueLabel' .. cmd.id]:SetCaption(tostring(cmd.params[1] or ''))
    end

    if not cmd.disabled and (Config.labels.showMetalCost or Config.labels.showEnergyCost) then
        local s, e, metalCost, energyCost, line = 0, 0, '', '', '\n'
        if Config.labels.showMetalCost then
            s, e = stringfind(cmd.tooltip, 'Metal cost %d*')
            metalCost = color2incolor(1,1,1) .. stringsub(cmd.tooltip, s + 11, e)
        else line = '' end
        if Config.labels.showEnergyCost then
            s, e = stringfind(cmd.tooltip, 'Energy cost %d*')
            energyCost = color2incolor(1,1,0) .. stringsub(cmd.tooltip, s + 12, e)
        else line = '' end
        if (not chiliCache['costLabel' .. cmd.id]) then
            chiliCache['costLabel' .. cmd.id] = Label:New{
                name = 'costLabel' .. cmd.id,
                parent = image,
                x = '5%', bottom = '5%',
                valign = 'bottom',
                --caption = metalCost .. line .. energyCost,
                font = {
                    size = Config.labels.costFontSize,
                    outline = true, shadow  = true,
                    outlineWidth  = 4, outlineWeight = 4,
                },
            }
        end
        chiliCache['costLabel' .. cmd.id]:SetCaption(metalCost .. line .. energyCost)
    end

    applyHighlightHandler(image, cmd)
    if advanced then
        buildGridAdv:AddChild(image)
    else
        buildGrid:AddChild(image)
    end
end --addBuildCommand

local function addBuildCommandAdv(cmd)
    addBuildCommand(cmd, true)
end

--TODO: Defines which commands go to which block (1, 2, 3)
local function processCommand(cmd)
    local uDef = UnitDefNames[cmd.name]
    --local uDefId = uDef.id
    if uDef then    -- It's a unit (build command)
        local advanced = (uDef.customParams and tonumber(uDef.customParams.tier) >= 2)
        return advanced and 4 or 3  -- Advanced: grid #4, regular: grid #3
    elseif #cmd.params > 1 then
        return 1
    else
        return 2
    end
end --processCommand

local lastCommands

-- Executed every Update, when updateRequired == true
local function processAllCommands()
    if (deepEquals(lastCommands, widgetHandler.commands)) then
        return
    end
    lastCommands = widgetHandler.commands

    buildGrid:ClearChildren()
    buildGridAdv:ClearChildren()
    orderGrid:ClearChildren()
    --chiliCache = {} -- clears all cached chili elements

    local haveCmd = 0
    local commands = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, }
    for _,cmd in ipairs(lastCommands) do
        if cmd.name ~= '' and not (Config.hiddenCMDs[cmd.name] or Config.hiddenCMDs[cmd.action]) then
            local grid = processCommand(cmd)
            haveCmd = mathmax(haveCmd, grid)
            commands[grid][#commands[grid]+1] = cmd
        end
    end

    local sortBy = { [1] = Config.ordermenu.sortBy, [2] = Config.ordermenu.sortBy, [3] = Config.buildmenu.sortBy, [4] = Config.buildmenu.sortBy }
    local gridFunc = { [1] = addStateCommand, [2] = addOrderCommand, [3] = addBuildCommand , [4] = addBuildCommandAdv }
    for grid,cmds in ipairs(commands) do
        -- pairsByKeys imported from taptools.lua
        if sortBy[grid] then
            for _,cmd in pairsByKeys(cmds, function(a,b) return sortElements(cmds, a, b, sortBy[grid]) end) do
                gridFunc[grid](cmd)
            end
        else
            for i = 1, #cmds do gridFunc[grid](cmds[i]) end
        end
    end

    orderGrid.updateGrid()
    buildGrid.updateGrid()
    buildGridAdv.updateGrid()

    if haveCmd > 0 and orderWindow.hidden then orderWindow:Show()
    elseif haveCmd == 0 and orderWindow.visible then orderWindow:Hide() end
    if haveCmd > 2 and buildWindow.hidden then buildWindow:Show()
    elseif haveCmd <= 2 and buildWindow.visible then buildWindow:Hide() end
    if haveCmd > 3 and buildWindowAdv.hidden then buildWindowAdv:Show()
    elseif haveCmd <= 3 and buildWindowAdv.visible then buildWindowAdv:Hide() end
end --processAllCommands

local function updateSelection()
    tooltip = nil
    if not buildGrid and not buildGridAdv then
        return end
    local _,cmdID = spGetActiveCommand()
    for _, bt in ipairs(buildGridAdv.children) do
        if bt.updateSelection then bt.updateSelection(cmdID) end
    end
    for _, bt in ipairs(buildGrid.children) do
        if bt.updateSelection then bt.updateSelection(cmdID) end
    end
    for _, bt in ipairs(orderGrid.children) do
        if bt.updateSelection then bt.updateSelection(cmdID) end
    end
end --updateSelection

local function OverrideDefaultMenu()
    local function layoutHandler(xIcons, yIcons, cmdCount, commands)
        widgetHandler.commands = commands
        widgetHandler.commands.n = cmdCount
        widgetHandler:CommandsChanged()
        local customCmds = widgetHandler.customCommands
        return '', xIcons, yIcons, {}, customCmds, {}, {}, {}, {}, {}, {[1337]=9001}
    end
    widgetHandler:ConfigLayoutHandler(layoutHandler)
    spForceLayoutUpdate()
end --OverrideDefaultMenu
--------------------------------------------------------------------------------

function widget:Initialize()
    if not WG.Chili then
        widgetHandler:RemoveWidget()
        return
    end
    OverrideDefaultMenu()

    Chili = WG.Chili
    Window = Chili.Window
    Grid = Chili.Grid
    Image = Chili.Image
    Button = Chili.Button
    Label = Chili.Label
    ScrollPanel = Chili.ScrollPanel
    color2incolor = Chili.color2incolor

    btWidth = processRelativeCoord(Config.ordermenu.width, vsx/Config.ordermenu.columns)

    chiliCache = {}

    InitializeControls()
end --Initialize

function widget:CommandsChanged()
    updateRequired = true
end --CommandsChanged

function widget:Update()
    if updateRequired then
        processAllCommands()
        updateRequired = false
    end
    updateSelection()
end --Update

function widget:WorldTooltip(ttType,data1,data2,data3)
    return tooltip
end --WorldTooltip

function widget:ViewResize(newX,newY)
    -- TODO: implement config for this resize and make a reusable helper function to handle it
    --widget:Shutdown()

    btWidth = processRelativeCoord(Config.ordermenu.width, vsx/Config.ordermenu.columns)

    chiliCache = {}

    InitializeControls()

    --Config.ordermenu.height = '17.5%'
    --Config.ordermenu.y = '25%'
    --orderWindow:SetPos(nil, nil, nil, Config.ordermenu.y)
    --
    --Config.buildmenu.height = '14%'
    --Config.buildmenu.y = '42.5%'
    --buildWindow:SetPos(nil, nil, nil, Config.buildmenu.y)
    --
    --Config.buildmenuAdv.height = '14%'
    --Config.buildmenuAdv.y = '61.5%'
    --buildWindowAdv:SetPos(nil, nil, nil, Config.buildmenuAdv.y)


    --Config.buildmenu.height = buildWindow.width * (Config.buildmenu.rows / Config.buildmenu.columns)
    --buildWindow:SetPos(nil, nil, nil, Config.buildmenu.height)
    --
    --Config.buildmenuAdv.height = buildWindowAdv.width * (Config.buildmenuAdv.rows / Config.buildmenuAdv.columns)
    --buildWindowAdv:SetPos(nil, nil, nil, Config.buildmenuAdv.height)
end --ViewResize

function widget:Shutdown()
    if orderWindow then
        orderWindow:Dispose()
    end
    if buildWindow then
        buildWindow:Dispose()
    end
    if buildWindowAdv then
        buildWindowAdv:Dispose()
    end
    widgetHandler:ConfigLayoutHandler(nil)
    chiliCache = nil
    spForceLayoutUpdate()
end --Shutdown
