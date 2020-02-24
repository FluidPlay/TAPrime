--
-- User: MaDDoX
-- Date: 26/10/17
-- Time: 05:47
--

local SIG_STATECHG = {}

--local base = piece 'base'
--local body = piece 'body'
--local aim = piece 'aim'
--local tower1, tower2, tower3 = piece('tower1', 'tower2', 'tower3')
--local emitnano = piece 'emitnano'

local base, body, aim, tower1, tower2, tower3, emitnano = piece('base', 'body', 'aim', 'tower1', 'tower2', 'tower3', 'emitnano')

--local TA = -- This is a TA script

--#include "sfxtype.h"
--#include "exptype.h"

local HeadingAngle, RestoreDelay, statechg_DesiredState, statechg_StateChanging
local level = 1
local justcreated = false
local Rad = math.rad
local Rand = math.random

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

local function SmokeUnit(healthpercent, sleeptime, smoketype)
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
		Sleep (400)
	end
	while true do
		local healthpercent = GetUnitValue(COB.HEALTH)
		if  healthpercent < 66  then
			smoketype = 258 --256 | 2
			if Rand (1, 66) < healthpercent  then
				smoketype = 257 end
			EmitSfx ( aim, smoketype )
		end
		sleeptime = healthpercent * 50
		if  sleeptime < 200  then
			sleeptime = 200
		end
		Sleep (sleeptime)
	end
end

local function RestoreAfterDelay()
	Sleep (RestoreDelay)
	Turn (aim , y_axis, 0, Rad(100.00000))
	WaitForTurn (aim, y_axis)
end

local function WaitOneFrame()
	Sleep (1)
end

local function EnableTowers()
	-- If we just morphed into this guy, insta-set pieces below the current level
	-- Why? A.: Those pieces have been raised before
	if (justcreated) then
		justcreated = false
		if level >= 3 then
			Move ( tower1, y_axis, 48.200000)
		end
		if level == 4 then
			Move ( tower2, y_axis, 48.200000)
		end
	end
	if level >= 2 then
		Move ( tower1, y_axis, 48.200000, 18.03424 )
	end
	if level >= 3 then
		Move ( tower2, y_axis, 48.200000, 18.03424 )
	end
	if level == 4 then
		Move ( tower3, y_axis, 48.200000, 18.03424 )
	end
end

local function DisableTowers()
		if level >= 2 then
			Move ( tower1, y_axis, 0.00000, 8.00000)
		end
		if level >= 3 then
			Move ( tower2, y_axis, 0.00000, 8.00000)
		end
		if level == 4 then
			Move ( tower3, y_axis, 0.00000, 8.00000)
		end
end

local function Go()
  Spring.UnitScript.Signal(SIG_STATECHG)
  Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    --Spring.Echo("armoutpost_lus: Going")
	EnableTowers()
	WaitOneFrame()
	Turn( aim , y_axis, HeadingAngle, Rad(160.00000) )
	WaitForTurn(aim, y_axis)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

local function Stop()
  Spring.UnitScript.Signal(SIG_STATECHG)
  Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    --Spring.Echo("armoutpost_lus: Stopping")
	SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
	--DisableTowers() :: Removed to prevent 'bouncing towers' after building etc
	WaitOneFrame()
	StartThread(RestoreAfterDelay)
end

local function RequestState(requestedstate, currentstate)
	if  statechg_StateChanging  then
		statechg_DesiredState = requestedstate
		return (0)
	end
	statechg_StateChanging = true
	currentstate = statechg_DesiredState
	statechg_DesiredState = requestedstate
	while statechg_DesiredState ~= currentstate  do
		if statechg_DesiredState == 0 then
			StartThread(Go)
			currentstate = 0
		elseif statechg_DesiredState == 1 then
      --Spring.Echo("Stop now")
			StartThread(Stop)
			currentstate = 1
		end
	end
	statechg_StateChanging = false
end

local function InitState()
	HeadingAngle = 0
	RestoreDelay = 5000
	justcreated = true
	statechg_DesiredState = 1
	statechg_StateChanging = false
	local unitDefID = UnitDefs[unitDefID].name
	if (unitDefID == "armoutpost") then
		level = 1
	elseif (unitDefID == "armoutpost2") then
		level = 2
	elseif (unitDefID == "armoutpost3") then
		level = 3
	elseif (unitDefID == "armoutpost4") then
		level = 4
	end
	EnableTowers()
end

function script.StartBuilding(heading, pitch)
	HeadingAngle = heading
	StartThread(RequestState, 0)
end

function script.StopBuilding()
	StartThread(RequestState, 1)
end

function script.QueryNanoPiece(piecenum)
	piecenum = emitnano
	return piecenum
end

local function SweetSpot(piecenum)
	piecenum = aim
end

function script.Create()
	StartThread(SmokeUnit)
	InitState()
end

function script.Activate()
    HeadingAngle = 0
	StartThread(RequestState, 0)
end

function script.Deactivate()
	StartThread(RequestState, 1)
end

function script.Killed(recentDamage, maxHealth)
	local corpsetype = 3
	local severity = recentDamage / maxHealth * 100

	if  severity <= 25  then
		corpsetype = 1
		Explode( base, sfxBITMAPONLY + sfxBITMAP1)
		Explode( aim, sfxBITMAPONLY + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 50  then
		corpsetype = 2
		Explode( base, sfxFall + sfxBITMAP1)
		Explode( aim, sfxFall + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 99  then
		corpsetype = 3
		Explode( base, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
		Explode( aim, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
		return (corpsetype)
	end
	Explode( base, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
	Explode( aim, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
	return (corpsetype)
end

