function widget:GetInfo()
    return {
        name      = "Capture Warning",
        desc      = "Tries to prevent comcaptures by issuing warnings",
        author    = "MaDDoX, based on the original anticomnap widget by []lennart",
        date      = "May 5, 2020",
        license   = "GNU GPL v3",
        layer     = -1,
        enabled   = true  --  loaded by default?
    }
end

local GiveOrderToUnit    = Spring.GiveOrderToUnit
local GetUnitPosition    = Spring.GetUnitPosition
local GetCommandQueue    = Spring.GetCommandQueue
local Echo               = Spring.Echo
local GetSelectedUnits   = Spring.GetSelectedUnits
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitIsCloaked   = Spring.GetUnitIsCloaked
local AreTeamsAllied     = Spring.AreTeamsAllied
local myTeamID           = Spring.GetMyTeamID()
local GetUnitTeam        = Spring.GetUnitTeam
local GetTeamUnitsSorted = Spring.GetTeamUnitsSorted
local spGetMyPlayerID    = Spring.GetMyPlayerID
local spGetPlayerInfo    = Spring.GetPlayerInfo
local MarkerAddPoint     = Spring.MarkerAddPoint
local MarkerErasePosition= Spring.MarkerErasePosition

local GetUnitIsTransporting = Spring.GetUnitIsTransporting

local gl_Rect							= gl.Rect
local gl_Color						= gl.Color

local GetTextWidth				= fontHandler.GetTextWidth
local UseFont							= fontHandler.UseFont
local TextDraw						= fontHandler.Draw
local TextDrawCentered		= fontHandler.DrawCentered


local vsx,vsy      = gl.GetViewSizes()

local px --used to prevent com from "travelling" when escaping naps
local py
local pz
local enemycomlist ={}  --keep track of enemy commanders
local allycomlist={}     --and of allied coms

local lastwarn={x=nil, y=nil, z=nil} -- position of last warning (alert) issued
local disabled=false

local buttonXA=vsx -180
local buttonXB=vsx
local buttonYA=(vsy*0.5) -8
local buttonYB=(vsy*0.5) +8
local buttonXM
local buttonYM

VFS.Include("gamedata/taptools.lua")

local function calcButton()
    --[[  buttonXA= vsx -180
      buttonXB= vsx
      buttonYA= (vsy*0.5) -8
      buttonYB= (vsy*0.5) +8
      --]]
    buttonXM= (buttonXA+buttonXB)/2
    buttonYM= (buttonYA+buttonYB)/2-3
end

--local function setUnitToPatrol(unitID, x, y, z)
--    if((px==nil) or (((px-x)^2+(py-y)^2+(pz-z)^2)^0.5>75)) then
--        px=x
--        py=y
--        pz=z
--        --    Echo("setting com to patrol")
--    end
--    local cQueue=GetCommandQueue(unitID)
--    if ((cQueue[0]~=nil) and (cQueue[1]~=nil)) then
--        if ((cQuese[0].id==CMD.MOVE) and (cQueue[1].id==CMD.MOVE)) then return true end
--    end
--    --GiveOrderToUnit(unitID, CMD.MOVE, {(x-50),y,z},{""})
--    GiveOrderToUnit(unitID, CMD.INSERT, {0,CMD.MOVE,CMD.OPT_SHIFT,(px-35),py,pz}, {"alt"})
--    GiveOrderToUnit(unitID, CMD.INSERT, {0,CMD.MOVE,CMD.OPT_SHIFT,(px+35),py,pz}, {"alt"})
--end

function widget:UnitEnteredLos(unitID, unitTeam)
    local unitDef = GetUnitDefID(unitID)
    if ((unitDef ~= nil) and UnitDefs[unitDef].customParams.iscommander --["isTransport"]
            and not(AreTeamsAllied(myTeamID, unitTeam))
            and (enemycomlist[unitID]==nil)) then
        enemycomlist[unitID]=0
        --	Echo("spotted enemy trans")
    end
end

function widget:UnitEnteredRadar(unitID, unitTeam)
    widget:UnitEnteredLos(unitID, unitTeam)
end

-- both following functions clear the enemycomlist var, but they are not necessary,
-- as <widget:GameFrame(..)> will delete any ids where the position is not accessible
--[[
function widget:UnitLeftLos(unitID, unitTeam)
  if (enemycomlist[unitID]~=nil) then
    enemycomlist[unitID]=nil
  end
end
function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  if (enemycomlist[unitID]~=nil) then
    enemycomlist[unitID]=nil
  end
end
--]]

function widget:UnitCreated(unitID, unitDefID, teamID)
    if(UnitDefs[unitDefID].customParams.iscommander and AreTeamsAllied(myTeamID, teamID)) then
        allycomlist[unitID]=teamID
    end
end

--function widget.UnitSeismicPing(x, y, z, strength, allyTeam, unitID, udefID)
--    local teamID = Spring.GetUnitTeam(unitID)
--    if not UnitDefs[udefID].customParams.iscommander or AreTeamsAllied(myTeamID, teamID) then
--        return end
--    --TODO: Add marker at pos
--    MarkerAddPoint(x, y, z,"Cloaked Enemy Commander Detected!")
--end

local function updateComlist()
    allycomlist={}
    local allUnits=Spring.GetAllUnits()
    if(allUnits~=nil) then
        for i,unitID in ipairs(allUnits) do
            unitTeamID=GetUnitTeam(unitID)
            if(AreTeamsAllied(myTeamID,unitTeamID) and UnitDefs[GetUnitDefID(unitID)].customParams.iscommander) then
                allycomlist[unitID]=unitTeamID
            end
        end
    end
    --  Echo("<anti-comnap> updated commander list.")
end

function widget:Initialize()
    --Echo("widget started!!")
    calcButton()
    updateComlist()
end

-- this callin is needed to make the widget work even with cheating (for testing the widget).
function widget:PlayerChanged()
    updateComlist()
end

local function checkSpecState()
    local playerID = spGetMyPlayerID()
    local _, _, spec, _, _, _, _, _ = spGetPlayerInfo(playerID)

    if ( spec == true ) then
        --spEcho("<anti-comnap> Spectator mode. Widget removed.")
        widgetHandler:RemoveWidget()
        return false
    end
    return true
end

function widget:ViewResize(viewSizeX, viewSizeY)
    vsx = viewSizeX
    vsy = viewSizeY
    calcButton()
end

function widget:DrawScreen()
    --if (lastwarn==0) then return true end
    ----draw button with background and text depending on <disabled>
    --gl_Color(0,0,0,0.2)
    --gl_Rect(buttonXA, buttonYA, buttonXB, buttonYB)
    --if (disabled) then
    --    gl_Color(1,1,1,0.5)
    --    TextDrawCentered("enable comnap evasion",buttonXM,buttonYM)
    --else
    --    gl_Color(1,0.5,0.2,1.0)
    --    TextDrawCentered("disable comnap evasion",buttonXM,buttonYM)
    --end
    --gl_Color(1,1,1,1)
    --  end
end

function widget:MousePress(x,y,button)
    --if    (x>=buttonXA) and (x<=buttonXB)
    --        and (y>=buttonYA) and (y<=buttonYB)
    --        and (lastwarn>0)
    --then
    --    if(disabled) then
    --        disabled=false
    --    else
    --        disabled=true
    --    end
    --end
end

function widget:GameFrame(frameNum)
    if ((frameNum%32)==0) then
        checkSpecState()
        --if(lastwarn > 0) then
        --    lastwarn = lastwarn - 1
        --    --if lastwarn == 0 then
        --    --    disabled = false end
        --end

        for ComUnitID, ComTeamID in pairs(allycomlist) do
            --local shouldescape=true -- prevent multiple commands for multiple transports sighted at once
            x,y,z=GetUnitPosition(ComUnitID)
            if(x==nil) then
                allycomlist[ComUnitID]=nil
            else
                for unitID,lastframe in pairs(enemycomlist) do
                    local ex, ey, ez = GetUnitPosition(unitID)
                    if(ex==nil) then
                        if ((frameNum-lastframe)>64) then --delete after three seconds out of sight
                            enemycomlist[unitID]=nil
                        end
                    else
                        local dist = ((x-ex)^2 + (y-ey)^2 +(z-ez)^2)^0.5
                        if ((frameNum-lastframe) > 800) then --800 (4s now)
                            if (dist < 800) then --1000 is the current warning distance (for allies mostly)
                                if isnumber(lastwarn.x) and isnumber(lastwarn.y) and isnumber(lastwarn.z) then
                                    MarkerErasePosition(lastwarn.x, lastwarn.y, lastwarn.z) end
                                MarkerAddPoint(ex,ey,ez,"Nearby enemy commander alert!")
                                enemycomlist[unitID] = frameNum
                                lastwarn={x=ex, y=ey, z=ez}
                                lastframe = frameNum
                            end
                        end
                        -- MaDDoX: Removing this, not used here. Also idle comms are always patrolling in TAP
                        ----500: the distance at which your com will start moving
                        --if ((dist<500) and (ComTeamID==myTeamID)
                        --        and shouldescape and (not disabled))
                        --then
                        --    setUnitToPatrol(ComUnitID,x,y,z)
                        --    shouldescape=false
                        --end
                    end
                end
            end
        end

        -- for testing whether coms are in list:
        --[[
            if((frameNum%1024)==0) then
              for unitID,_ in pairs(allycomlist) do
                local x,y,z = GetUnitPosition(unitID)
                if(x~=nil) then
                  MarkerAddPoint(x,y,z)
                end
              end
            end
        --]]
    end
end

function widget:TweakDrawScreen()
    gl_Color(0.2,0.2,0.2,0.8)
    gl_Rect(buttonXA, buttonYA, buttonXB, buttonYB)
    gl_Color(1,1,1,1)
    TextDrawCentered("comnap button",buttonXM,buttonYM)
end

local function moveButton(dx,dy)
    buttonXA = buttonXA+dx
    buttonXB = buttonXB+dx
    buttonYA = buttonYA+dy
    buttonYB = buttonYB+dy
end

function widget:TweakMouseMove(x,y,dx,dy,button)
    buttonXA = buttonXA+dx
    buttonXB = buttonXB+dx
    buttonYA = buttonYA+dy
    buttonYB = buttonYB+dy
    if(buttonXA<0)   then moveButton(-buttonXA,0) end
    if(buttonXB>vsx) then moveButton(vsx-buttonXB,0) end
    if(buttonYA<0)   then moveButton(0,-buttonYA) end
    if(buttonYB>vsy) then moveButton(0,vsy-buttonYB) end
    calcButton()
end

function widget:TweakMousePress(x,y,button)
    if (    (x>=buttonXA) and (x<=buttonXB)
            and (y>=buttonYA) and (y<=buttonYB) and (button==1)) then
        tweakmousedown=true
        return true
    end
end

function widget:GetConfigData()      -- send
    return {
        buttonXA = buttonXA,
        buttonXB = buttonXB,
        buttonYA = buttonYA,
        buttonYB = buttonYB
    }
end

function widget:SetConfigData(data)
    if((data.buttonXA~=nil) and (data.buttonXB~=nil)
            and (data.buttonYA~=nil) and (data.buttonYB~=nil)) then
        buttonXA = data.buttonXA
        buttonXB = data.buttonXB
        buttonYA = data.buttonYA
        buttonYB = data.buttonYB
        calcButton()
    end
end




