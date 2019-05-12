--VFS.Include("scripts/techcenter_generic.lua")
---
--- Created by MaDDoX.
--- DateTime: 20/09/17 15:42
---

local base = piece 'base'
local post1 = piece 'post1'
local post2 = piece 'post2'
local post3 = piece 'post3'
local post4 = piece 'post4'
local light4 = piece 'light4'
local light3 = piece 'light3'
local light2 = piece 'light2'
local light1 = piece 'light1'
local centerlight = piece 'centerlight'
local justcreated = false

--#include "sfxtype.h"
--#include "exptype.h"
-- TODO: Make below statics an includable lib

local statechg_DesiredState, statechg_StateChanging
local level = 0
local radians = math.rad

local Explode = Spring.UnitScript.Explode
local sfxShatter = SFX.SHATTER
local sfxBITMAPONLY = 32    --https://github.com/Balanced-Annihilation/Balanced-Annihilation/blob/master/scripts/exptype.h
local sfxBITMAP1 = 256
local sfxBITMAP2 = 512
local sfxBITMAP3 = 1024
local sfxBITMAP4 = 2048
local sfxBITMAP5 = 4096
local sfxFall = SFX.FALL
local sfxFire = SFX.FIRE
local sfxSmoke = SFX.SMOKE
local sfxExplodeOnHit = SFX.EXPLODE_ON_HIT

local SIG_BUILD = 2

-- Lights level sequence is: 1 -> 4 -> 2 -> 3
-- turn z, x -> switch and change signal (eg.: turn x_axis 90 => turn z_axis -90)
-- move z, x -> switch and keep signal; multiply amount by 6.9, speed by 10 (relative to upspring)
local function activatescr()
    --Spring.Echo("Level: "..level.." justcreated: "..tostring(justcreated))
    -- If we just morphed into this guy, insta-set pieces under the current level
    if level > 1 and justcreated then
        Turn( post1 , z_axis, 0 ) --x_axis
        Turn( post2 , z_axis, 0 ) --x_axis
        Turn( post3 , x_axis, 0 ) --z_axis
        Turn( post4 , x_axis, 0 ) --z_axis
        Move ( light1 , x_axis, 0 ) Move ( light2 , x_axis, 0 )
        Move ( light3 , z_axis, 0 ) Move ( light4 , z_axis, 0 )
        --
        Turn ( post1 , z_axis, radians(90))
        Move ( light1 , x_axis, 13.800000)
    elseif level >= 1 then
        Turn ( post1 , z_axis, radians(90), radians(82.329670) ) --x_axis -90.236264
        Sleep (1096)
        Move ( light1 , x_axis, 13.800000 , 18.03424 ) --z_axis 2, 1.803
    end

    if level > 2 and justcreated then
        Turn ( post4 , x_axis, radians(90) )
        Move ( light4 , z_axis, -12.500000 )
    elseif level >=2 then
        Turn ( post4 , x_axis, radians(90), radians(82.329670) ) --z_axis -90
        Sleep (1096)
        Move ( light4 , z_axis, -12.500000 , 17.13251 ) -- x_axis -1.9, 1.7132
    end

    if level > 3 and justcreated then
        Turn ( post2 , z_axis, radians(-90)) --x_axis 89.80
        Move ( light2 , x_axis, -12.600000) --z_axis -2, 1.8034
    elseif level >= 3 then
        Turn ( post2 , z_axis, radians(-90), radians(81.939560) ) --x_axis 89.80
        Sleep (1096)
        Move ( light2 , x_axis, -12.600000 , 18.03424 ) --z_axis -2, 1.8034
    end

    if level == 4 then
        Turn ( post3 , x_axis, radians(-90.236264), radians(82.329670) ) --z_axis 90
        Sleep (1096)
        Move ( light3 , z_axis, 13.145 , 18.48511 ) --x_axis, 2.05, 1.84
    end

    if justcreated then
        justcreated = false
    end

    --set ARMORED to 0
    SetUnitValue(COB.ARMORED, 0)

    Sleep(1109)
end

local function deactivatescr()
    if level >=1 then
        Turn ( post1, z_axis, radians(90) ) --x_axis
        Move ( light1, x_axis, 13.800000 ) --z_axis - 2
        Move ( light1, x_axis, 0.000000 , 16.58368 ) -- z_axis 0
        Sleep(1206)
        Turn ( post1, z_axis, radians(0), radians(73.961538) ) --x_axis
    end
    --
    if level >= 2 then
        Turn ( post4, x_axis, radians(90.236264) ) --z_axis 90
        Move ( light4, z_axis, -12.500000  )  --x_axis 1.9
        Move ( light4, z_axis, -0.000000 , 15.75452 ) --x_axis 0, 1.575452
        Sleep(1206)
        Turn ( post4, x_axis, radians(-(0.000000)), radians(73.961538) ) --z_axis
    end
    if level >= 3 then
        Turn ( post2 , z_axis, radians(-90) )        -- x_axis 89.8021
        Move ( light2 , x_axis, -12.600000 )          -- z_axis -2
        Move ( light2 , x_axis, 0.000000, 16.58374 ) -- z_axis 0, 1.6583
        Sleep (1206)
        Turn ( post2 , z_axis, 0, radians(73.609890) ) --x_axis, 0, 73.6
    end
    if level >= 4 then
        Move ( light3 , z_axis, 13.1450000  )               -- x_axis -2.05
        Move ( light3 , z_axis, -0.000000 , 16.99829 )      -- x_axis -0, 1.699829
        Turn ( post3 , x_axis, radians(-90.236264) )        --z_axis -90.23
        Sleep (1206)
        Turn ( post3 , x_axis, radians(0.000000), radians(73.961538) ) --z_axis 0
    end

    Sleep(1220)

    --set ARMORED to 1
    SetUnitValue(COB.ARMORED, 1)
end

local function setlevel(newlevel)
    level = newlevel
end

local function SmokeUnit(healthpercent, sleeptime, smoketype)
    --Spring.GetUnitHealth( number unitID ) -> nil | number health, number maxHealth, number paralyzeDamage,
    --number captureProgress, number buildProgress

    --local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID (??))
    --while buildProgress < 1 do

    --    local percenthealth,health,maxHealth,paralyzeDamage,captureProgress,buildProgress
    --    health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(unitID)
    --    percenthealth=(health/maxHealth)*100

    --while get BUILD_PERCENT_LEFT do
    while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
        Sleep (500)
    end
    while true do
        local healthpercent = GetUnitValue(COB.HEALTH)--get HEALTH
        if  healthpercent < 66 then
            smoketype = 258
            if math.random(1, 66) < healthpercent  then
                smoketype = 257 end
            EmitSfx (base, smoketype)
        end
        sleeptime = healthpercent * 50
        if  sleeptime < 200  then
            sleeptime = 200
        end
        Sleep(sleeptime)
    end
end

local function RequestState(requestedstate, currentstate)
    if  statechg_StateChanging then
        statechg_DesiredState = requestedstate
        return (0)
    end
    statechg_StateChanging = true
    currentstate = statechg_DesiredState
    statechg_DesiredState = requestedstate
    while statechg_DesiredState ~= currentstate  do
        if  statechg_DesiredState == 1  then
            deactivatescr()
            currentstate = 1
        else
            activatescr()
            currentstate = 0
        end
    end
    statechg_StateChanging = false
end

function script.Create()
    --Turn( base , y_axis, radians(-90.000000) ) ---45
    --Spring.Echo("Unit ID: "..UnitDefs[unitDefID].name)
    local unitDefID = UnitDefs[unitDefID].name
    if (unitDefID == "armtech") or (unitDefID == "cortech") then
        setlevel(0)
    elseif (unitDefID == "armtech1") or (unitDefID == "cortech1") then
        setlevel(1)
    elseif (unitDefID == "armtech2") or (unitDefID == "cortech2") then
        setlevel(2)
    elseif (unitDefID == "armtech3") or (unitDefID == "cortech3") then
        setlevel(3)
    elseif (unitDefID == "armtech4") or (unitDefID == "cortech4") then
        setlevel(4)
    end
    justcreated = true
    statechg_DesiredState = 1 --true
    statechg_StateChanging = false
    StartThread(SmokeUnit)
end

local function OpenCloseAnim(open)
    Signal(1) -- Kill any other copies of this thread
    SetSignalMask(1) -- Allow this thread to be killed by fresh copies
    if open then
        -- TODO: This is where you would add your opening up anim
    else
        -- TODO: This is where you would add your closing up anim
    end
    SetUnitValue(COB.INBUILDSTANCE, open)
    SetUnitValue(COB.BUGGER_OFF, open)
end

function script.Activate()
    StartThread(RequestState, 0)
    StartThread(OpenCloseAnim, true)
end

function script.Deactivate()
    StartThread(RequestState, 1)
    StartThread(OpenCloseAnim, false)
end

--called whenever construction begins.
function script.StartBuilding(heading, pitch)
    --Signal(SIG_BUILD)
    --SetSignalMask(SIG_BUILD)
    --SetUnitValue(COB.INBUILDSTANCE, 1)
    --return 1
end

function script.StopBuilding()
    --Signal(SIG_BUILD)
    --SetSignalMask(SIG_BUILD)
    --SetUnitValue(COB.INBUILDSTANCE, 0)
    --Sleep(1)
    --return 0
end

function script.QueryBuildInfo ( )
    return base
end

local function WasHit()
    while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
        Sleep(500)
    end
    Signal(2)
    SetSignalMask(2)
    script.SetUnitValue(COB.ACTIVATION, 0)      --ACTIVATION = 0
    Sleep (8000)
    script.SetUnitValue(COB.ACTIVATION, 1)      --ACTIVATION = 1
end

function script.HitByWeapon(Func_Var_1, Func_Var_2)
    StartThread(WasHit)
end

function SweetSpot(piecenum)
    piecenum = base
end

-- script.Killed ( number recentDamage, number maxHealth )
function script.Killed(recentDamage, maxHealth)
    local corpsetype = 3
    local severity = recentDamage / maxHealth * 100
    --Spring.Echo(" Death Severity: "..severity)

    if  severity <= 25  then
        corpsetype = 1
        Explode( base, sfxBITMAPONLY + sfxBITMAP1)
        Explode( centerlight, sfxBITMAPONLY + sfxBITMAP2)
        Explode( light1, sfxBITMAPONLY + sfxBITMAP3)
        Explode( light2, sfxBITMAPONLY + sfxBITMAP4)
        Explode( light3, sfxBITMAPONLY + sfxBITMAP5)
        Explode( light4, sfxBITMAPONLY + sfxBITMAP1)
        Explode( post1, sfxBITMAPONLY + sfxBITMAP2)
        Explode( post2, sfxBITMAPONLY + sfxBITMAP3)
        Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
        Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
        return (corpsetype)
    end
    if  severity <= 50  then
        corpsetype = 2
        Explode( base, sfxBITMAPONLY + sfxBITMAP1)
        Explode( centerlight, sfxFall + sfxBITMAP2)
        Explode( light1, sfxFall + sfxBITMAP3)
        Explode( light2, sfxFall + sfxBITMAP4)
        Explode( light3, sfxFall + sfxBITMAP5)
        Explode( light4, sfxFall + sfxBITMAP1)
        Explode( post1, sfxShatter + sfxBITMAP2)
        Explode( post2, sfxBITMAPONLY + sfxBITMAP3)
        Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
        Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
        return (corpsetype)
    end
    if  severity <= 99  then
        corpsetype = 3
        Explode( base, sfxBITMAPONLY + sfxBITMAP1)
        Explode( centerlight, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP2)
        Explode( light1, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP3)
        Explode( light2, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP4)
        Explode( light3, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP5)
        Explode( light4, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP1)
        Explode( post1, sfxShatter + sfxBITMAP2)
        Explode( post2, sfxBITMAPONLY + sfxBITMAP3)
        Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
        Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
        return (corpsetype)
    end
    --    corpsetype = 3
    Explode( base, sfxBITMAPONLY + sfxBITMAP1)
    Explode( centerlight, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP2)
    Explode( light1, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP3)
    Explode( light2, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP4)
    Explode( light3, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP5)
    Explode( light4, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP1)
    Explode( post1, sfxShatter + sfxExplodeOnHit + sfxBITMAP2)
    Explode( post2, sfxBITMAPONLY + sfxBITMAP3)
    Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
    Explode( post4, sfxBITMAPONLY + sfxBITMAP5)

    return corpsetype
end
