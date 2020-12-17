function widget:GetInfo()
    return {
        name      = "Messages",
        desc      = "Typewrites messages at the center-bottom of the screen (missions, tutorials)",
        author    = "Floris",
        date      = "September 2019",
        license   = "GNU GPL, v2 or later",
        layer     = 30000,
        enabled   = true
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Widgets can call: WG['messages'].addMessage('message text')
-- Gadgets (unsynced) can call: Script.LuaUI.GadgetAddMessage('message text')
-- plain text (without markup) via: /addmessage message text

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local vsx,vsy = Spring.GetViewGeometry()

local posY = 0.16

local showTestMessages = false

local charSize = 19.5 - (3.5 * ((vsx/vsy) - 1.78))
local charDelay = 0.022
local maxLines = 6
local maxLinesScroll = 9
local lineTTL = 14
local fadeTime = 0.4
local fadeDelay = 0.25   -- need to hover this long in order to fadein and respond to CTRL
local backgroundOpacity = 0.18

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local ui_scale = tonumber(Spring.GetConfigFloat("ui_scale",1) or 1)

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (((vsx+vsy) / 2000) * 0.55) * (0.95+(ui_scale-1)/1.5)

local glPopMatrix      = gl.PopMatrix
local glPushMatrix     = gl.PushMatrix
local glDeleteList     = gl.DeleteList
local glCreateList     = gl.CreateList
local glCallList       = gl.CallList
local glTranslate      = gl.Translate
local glColor          = gl.Color

local messageLines = {}
local activationArea = {0,0,0,0}
local activatedHeight = 0
local currentLine = 0
local currentTypewriterLine = 0
local scrolling = false
local lineMaxWidth = 0

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function lines(str)
    local t = {}
    local function helper(line) t[#t+1] = line return "" end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

local function DrawRectRound(px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)
    local csyMult = 1 / ((sy-py)/cs)

    if c2 then
        gl.Color(c1[1],c1[2],c1[3],c1[4])
    end
    gl.Vertex(px+cs, py, 0)
    gl.Vertex(sx-cs, py, 0)
    if c2 then
        gl.Color(c2[1],c2[2],c2[3],c2[4])
    end
    gl.Vertex(sx-cs, sy, 0)
    gl.Vertex(px+cs, sy, 0)

    -- left side
    if c2 then
        gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
    end
    gl.Vertex(px, py+cs, 0)
    gl.Vertex(px+cs, py+cs, 0)
    if c2 then
        gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
    end
    gl.Vertex(px+cs, sy-cs, 0)
    gl.Vertex(px, sy-cs, 0)

    -- right side
    if c2 then
        gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
    end
    gl.Vertex(sx, py+cs, 0)
    gl.Vertex(sx-cs, py+cs, 0)
    if c2 then
        gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
    end
    gl.Vertex(sx-cs, sy-cs, 0)
    gl.Vertex(sx, sy-cs, 0)

    local offset = 0.15		-- texture offset, because else gaps could show

    -- bottom left
    if c2 then
        gl.Color(c1[1],c1[2],c1[3],c1[4])
    end
    if ((py <= 0 or px <= 0)  or (bl ~= nil and bl == 0)) and bl ~= 2   then
        gl.Vertex(px, py, 0)
    else
        gl.Vertex(px+cs, py, 0)
    end
    gl.Vertex(px+cs, py, 0)
    if c2 then
        gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
    end
    gl.Vertex(px+cs, py+cs, 0)
    gl.Vertex(px, py+cs, 0)
    -- bottom right
    if c2 then
        gl.Color(c1[1],c1[2],c1[3],c1[4])
    end
    if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2 then
        gl.Vertex(sx, py, 0)
    else
        gl.Vertex(sx-cs, py, 0)
    end
    gl.Vertex(sx-cs, py, 0)
    if c2 then
        gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
    end
    gl.Vertex(sx-cs, py+cs, 0)
    gl.Vertex(sx, py+cs, 0)
    -- top left
    if c2 then
        gl.Color(c2[1],c2[2],c2[3],c2[4])
    end
    if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2 then
        gl.Vertex(px, sy, 0)
    else
        gl.Vertex(px+cs, sy, 0)
    end
    gl.Vertex(px+cs, sy, 0)
    if c2 then
        gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
    end
    gl.Vertex(px+cs, sy-cs, 0)
    gl.Vertex(px, sy-cs, 0)
    -- top right
    if c2 then
        gl.Color(c2[1],c2[2],c2[3],c2[4])
    end
    if ((sy >= vsy or sx >= vsx)  or (tr ~= nil and tr == 0)) and tr ~= 2 then
        gl.Vertex(sx, sy, 0)
    else
        gl.Vertex(sx-cs, sy, 0)
    end
    gl.Vertex(sx-cs, sy, 0)
    if c2 then
        gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
    end
    gl.Vertex(sx-cs, sy-cs, 0)
    gl.Vertex(sx, sy-cs, 0)
end
function RectRound(px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)		-- (coordinates work differently than the RectRound func in other widgets)
    gl.Texture(false)
    gl.BeginEnd(GL.QUADS, DrawRectRound, px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)
end

function IsOnRect(x, y, leftX, bottomY,rightX,TopY)
    return x >= leftX and x <= rightX and y >= bottomY and y <= TopY
end

function widget:ViewResize()
    vsx,vsy = Spring.GetViewGeometry()
    lineMaxWidth = lineMaxWidth / widgetScale
    widgetScale = (((vsx+vsy) / 2000) * 0.55) * (0.95+(ui_scale-1)/1.5)
    lineMaxWidth = lineMaxWidth * widgetScale

    font = WG['fonts'].getFont(nil, 1, 0.2, 1.3)

    for i, _ in ipairs(messageLines) do
        if messageLines[i][6] then
            glDeleteList(messageLines[i][6])
            messageLines[i][6] = nil
        end
    end

    activationArea = {
        (vsx * 0.31)-(charSize*widgetScale), (vsy * posY)+(charSize*0.15*widgetScale),
        (vsx * 0.6), (vsy * (posY+0.077))
    }
    lineMaxWidth = math.max(lineMaxWidth, activationArea[3] - activationArea[1])
    activatedHeight = (1+maxLinesScroll)*charSize*1.15*widgetScale
end

function addMessage(text)
    if text then

        -- determine text typing start time
        local startTime = os.clock()
        if messageLines[#messageLines] then
            if startTime < messageLines[#messageLines][1] + messageLines[#messageLines][3]*charDelay then
                startTime = messageLines[#messageLines][1] + messageLines[#messageLines][3]*charDelay
            else
                currentTypewriterLine = currentTypewriterLine + 1
            end
        else
            currentTypewriterLine = currentTypewriterLine + 1
        end

        -- convert /n into lines
        local textLines = lines(text)

        -- word wrap text into lines
        local wordwrappedText = {}
        local wordwrappedTextCount = 0
        for i, line in ipairs(textLines) do
            local words = {}
            local wordsCount = 0
            local linebuffer = ''
            for w in line:gmatch("%S+") do
                wordsCount = wordsCount + 1
                words[wordsCount] = w
            end
            for wi, word in ipairs(words) do
                if font:GetTextWidth(linebuffer..' '..word)*charSize*widgetScale > lineMaxWidth then
                    wordwrappedTextCount = wordwrappedTextCount + 1
                    wordwrappedText[wordwrappedTextCount] = linebuffer
                    linebuffer = ''
                end
                if linebuffer == '' then
                    linebuffer = word
                else
                    linebuffer = linebuffer..' '..word
                end
            end
            if linebuffer ~= '' then
                wordwrappedTextCount = wordwrappedTextCount + 1
                wordwrappedText[wordwrappedTextCount] = linebuffer
            end
        end
        local messageLinesCount = #messageLines
        for i, line in ipairs(wordwrappedText) do
            lineMaxWidth = math.max(lineMaxWidth, font:GetTextWidth(line)*charSize*widgetScale)
            messageLinesCount = messageLinesCount + 1
            messageLines[messageLinesCount] = {
                startTime,
                line,
                string.len(line),
                0,  -- num typed chars
                0,  -- time passed during typing chars (used to calc 'num typed chars')
                glCreateList(function() end),
                0   -- num chars the displaylist contains
            }
            startTime = startTime + (string.len(line)*charDelay)
        end

        if currentTypewriterLine > messageLinesCount then
            currentTypewriterLine = messageLinesCount
        end
        if not scrolling then
            currentLine = currentTypewriterLine
        end
    end
end

function widget:Initialize()
    widget:ViewResize()
    widgetHandler:RegisterGlobal('GadgetAddMessage', addMessage)
    WG['messages'] = {}
    WG['messages'].addMessage = function(text)
        addMessage(text)
    end
end

local sec = 0
local testmessaged = 0
local uiSec = 0
function widget:Update(dt)
    uiSec = uiSec + dt
    if uiSec > 0.5 then
        uiSec = 0
        if ui_scale ~= Spring.GetConfigFloat("ui_scale",1) then
            ui_scale = Spring.GetConfigFloat("ui_scale",1)
            widget:ViewResize()
        end
    end

    local x,y,b = Spring.GetMouseState()
    if WG['topbar'] and WG['topbar'].showingQuit() then
        scrolling = false
    elseif IsOnRect(x, y, activationArea[1], activationArea[2], activationArea[3], activationArea[4]) then
        local alt, ctrl, meta, shift = Spring.GetModKeyState()
        if ctrl and startFadeTime and os.clock() > startFadeTime+fadeDelay then
            scrolling = true
        else
            --scrolling = false
        end
    elseif scrolling and IsOnRect(x, y, activationArea[1], activationArea[2], activationArea[1]+lineMaxWidth+(charSize*2*widgetScale), activationArea[2]+activatedHeight) then

    else
        scrolling = false
        currentLine = #messageLines
    end

    -- delayed test msg
    if showTestMessages and not dataRestored and Spring.GetGameFrame() > 30 then
        sec = sec + dt
        if testmessaged < 1 and sec > 3.5 then
            testmessaged = 1
            addMessage("\nStandby we will keep you updated.\nGood luck!")
        end
        if testmessaged < 2 and sec > 12 then --and Spring.GetGameFrame() < 30*11 then
            testmessaged = 2
            addMessage("\n\nEnemies have been detected in your vicinity!\nBetter expand quick.")
        end
    end

    if messageLines[currentTypewriterLine] ~= nil then
        -- continue typewriting line
        if messageLines[currentTypewriterLine][4] <= messageLines[currentTypewriterLine][3] then
            messageLines[currentTypewriterLine][5] = messageLines[currentTypewriterLine][5] + dt
            messageLines[currentTypewriterLine][4] = math.ceil(messageLines[currentTypewriterLine][5]/charDelay)

            -- typewrite next line when complete
            if messageLines[currentTypewriterLine][4] >= messageLines[currentTypewriterLine][3] then
                currentTypewriterLine = currentTypewriterLine + 1
                if currentTypewriterLine > #messageLines then
                    currentTypewriterLine = #messageLines
                end
            end
        end
    end
end

function processLine(i)
    if messageLines[i][6] == nil or messageLines[i][4] ~= messageLines[i][7] then
        messageLines[i][7] = messageLines[i][4]
        local text = string.sub(messageLines[i][2], 1, messageLines[i][4])
        glDeleteList(messageLines[i][6])
        messageLines[i][6] = glCreateList(function()
            font:Begin()
            lineMaxWidth = math.max(lineMaxWidth, font:GetTextWidth(text)*charSize*widgetScale)
            font:Print(text, 0, 0, charSize*widgetScale, "o")
            font:End()
        end)
    end
end

function widget:RecvLuaMsg(msg, playerID)
    if msg:sub(1,18) == 'LobbyOverlayActive' then
        chobbyInterface = (msg:sub(1,19) == 'LobbyOverlayActive1')
    end
end

function widget:DrawScreen()
    if chobbyInterface then return end
    if not messageLines[1] then return end

    local x,y,b = Spring.GetMouseState()
    if IsOnRect(x, y, activationArea[1], activationArea[2], activationArea[3], activationArea[4]) or  (scrolling and IsOnRect(x, y, activationArea[1], activationArea[2], activationArea[1]+lineMaxWidth+(charSize*2*widgetScale), activationArea[2]+activatedHeight))  then
        hovering = true
        if not startFadeTime then
            startFadeTime = os.clock()
        end
        if scrolling then
            glColor(0,0,0,backgroundOpacity)
            RectRound(activationArea[1], activationArea[2], activationArea[1]+lineMaxWidth+(charSize*2*widgetScale), activationArea[2]+activatedHeight, 6.5*widgetScale)
        else
            local opacity = ((os.clock() - (startFadeTime+fadeDelay)) / fadeTime) * backgroundOpacity
            if opacity > backgroundOpacity then
                opacity = backgroundOpacity
            end
            glColor(0,0,0,opacity)
            RectRound(activationArea[1], activationArea[2], activationArea[3], activationArea[4], 6.5*widgetScale)
        end

    else

        if hovering then
            local opacityPercentage = (os.clock() - (startFadeTime+fadeDelay)) / fadeTime
            startFadeTime = os.clock() - math.max((1-opacityPercentage)*fadeTime, 0)
        end
        hovering = false
        if startFadeTime then
            local opacity = backgroundOpacity - (((os.clock() - startFadeTime) / fadeTime) * backgroundOpacity)
            if opacity > 1 then
                opacity = 1
            end
            if opacity <= 0 then
                startFadeTime = nil
            else
                glColor(0,0,0,opacity)
                RectRound(activationArea[1], activationArea[2], activationArea[3], activationArea[4], 6.5*widgetScale)
            end
        end
        scrolling = false
        currentLine = #messageLines
    end

    if messageLines[currentLine] then
        glPushMatrix()
        glTranslate((vsx * 0.31), (vsy * posY), 0)
        local displayedLines = 0
        local i = currentLine
        local usedMaxLines = maxLines
        if scrolling then
            usedMaxLines = maxLinesScroll
        end
        while i > 0 do
            glTranslate(0, (charSize*1.15*widgetScale), 0)
            if scrolling or os.clock() - messageLines[i][1] < lineTTL then
                processLine(i)
                glCallList(messageLines[i][6])
            end
            displayedLines = displayedLines + 1
            if displayedLines >= usedMaxLines then
                break
            end
            i = i - 1
        end
        glPopMatrix()

        -- show newly written line when in scrolling mode
        if scrolling and currentLine < #messageLines and os.clock() - messageLines[currentTypewriterLine][1] < lineTTL then
            glPushMatrix()
            glTranslate((vsx * 0.31), (vsy * (posY-0.02)), 0)
            processLine(currentTypewriterLine)
            glCallList(messageLines[currentTypewriterLine][6])
            glPopMatrix()
        end

    end
end

function widget:MouseWheel(up, value)
    if scrolling then
        if up then
            currentLine = currentLine - 1
            if currentLine < maxLinesScroll then
                currentLine = maxLinesScroll
            end
        else
            currentLine = currentLine + 1
            if currentLine > #messageLines then
                currentLine = #messageLines
            end
        end
        return true
    else
        return false
    end
end

function widget:WorldTooltip(ttType,data1,data2,data3)
    local x,y,_ = Spring.GetMouseState()
    if #messageLines > 0 and IsOnRect(x, y, activationArea[1],activationArea[2],activationArea[3],activationArea[4]) then
        return "Press\255\255\255\001 CTRL \255\255\255\255to activate chatlog viewing/scrolling"
    end
end

function widget:GameStart()
    if showTestMessages then
        addMessage("\255\230\255\200Commander,\nWe're in a peculiar situation so you have to begin on your own...\nInitiate a base and we'll redirect reinforcements right after...")
    end
end

function widget:GameOver()
    --widgetHandler:RemoveWidget(self)
end

function widget:Shutdown()
    WG['messages'] = nil
    for i, _ in ipairs(messageLines) do
        if messageLines[i][6] then
            glDeleteList(messageLines[i][6])
            messageLines[i][6] = nil
        end
    end
    widgetHandler:DeregisterGlobal('GadgetAddMessage')
end

function widget:TextCommand(command)
    if string.sub(command,1, 11) == "addmessage " then
        addMessage(string.sub(command, 11))
    end
end

function widget:GetConfigData(data)
    for i, _ in ipairs(messageLines) do
        messageLines[i][6] = nil
    end
    savedTable = {}
    savedTable.messageLines = messageLines
    return savedTable
end

function widget:SetConfigData(data)
    if Spring.GetGameFrame() > 0 and data.messageLines ~= nil then
        messageLines = data.messageLines
        currentLine = #messageLines
        currentTypewriterLine = currentLine
        dataRestored = true
    end
end
