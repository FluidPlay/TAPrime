--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_outpost_fight.lua
--  brief:   Sets new outposts to fight (assist, repair, etc) automatically
--  author:  MaDDoX, 16/1/2017
--
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- This widget tries to be smarter about auto-assist for commanders and other
-- builders. Even when guarding a factory, if the factory queue is depleted it'll
-- find something else to do around. Only way to stop auto assist is setting unit
-- to 'Wait', 'Stop' won't work (it'd be conflicting for mobile builders)
-- It's tested and recommended to be used alongside unit_obedient_constructors,
-- to take shift-queued build orders straight away and interrupt patrol.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Builder Auto Patrol",
    desc      = "Sets new/idle builders (including outposts and commanders) to patrol",
    author    = "MaDDoX",
    date      = "Jan 16, 2017",
    license   = "GNU GPL, v2 or later",
    layer     = 10,
    enabled   = false --true  --  loaded by default?
  }
end

--[[
local CMD_MOVE = CMD.MOVE
local CMD_FIGHT	= CMD.FIGHT
local CMD_GUARD = CMD.GUARD
local CMD_PATROL = CMD.PATROL
local CMD_STOP = CMD.STOP
local CMD_WAIT = CMD.WAIT
local CMD_REPAIR = CMD.REPAIR
local CMD_RECLAIM = CMD.RECLAIM
local CMD_SET_WANTED_MAX_SPEED = CMD.SET_WANTED_MAX_SPEED

local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitViewPosition = Spring.GetUnitViewPosition
--local spGiveOrderToUnit = Spring.GiveOrderToUnit

local mapsizehalfwidth = Game.mapSizeX/2
local mapsizehalfheight = Game.mapSizeZ/2

local spGetSelUnitCount = Spring.GetSelectedUnitsCount
local spGetSelUnitsCounts = Spring.GetSelectedUnitsCounts
--local spGetSelUnitsSorted = Spring.GetSelectedUnitsSorted
local spGiveOrderToUnit = Spring.GiveOrderToUnit
--local spGiveOrderToUnitArray = Spring.GiveOrderToUnitArray
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetCommandQueue = Spring.GetCommandQueue
local spGetRealBuildQueue = Spring.GetRealBuildQueue    --only for factories

local guardingUnits = {} -- [unitID] = guardedUnitID
local spGetUnitDefID = Spring.GetUnitDefID
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetAllUnits = Spring.GetAllUnits
local spGetUnitTeam = Spring.GetUnitTeam
local spGetMyTeamID = Spring.GetMyTeamID

local glPushMatrix				= gl.PushMatrix
local glTranslate				= gl.Translate
local glPopMatrix				= gl.PopMatrix
local glColor					= gl.Color
local glText					= gl.Text
local glBillboard				= gl.Billboard

local glDebugStates             = false   -- Should the builder state be shown visually? (Debug)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local trackedUnits = {} -- {unitID="fight/build/stop"} We use this to track outposts which are in fight / build / idle mode
local previouslySelectedUnits = {}  -- Used by the 'obedient_constructors' re-implementation

local trackedDefNames = {
  armcom = true, armcom2 = true, armcom3 = true, armcom4 = true,
  corcom = true, corcom2 = true, corcom3 = true, corcom4 = true,
  armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
  coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
  armack = true, corack = true, armaca = true, coraca = true,
  armfark = true, cormuskrat = true, corfast = true, armconsul = true,
}

--local tDefIDs = {
--  UnitDefNames.armoutpost.id, UnitDefNames.armoutpost2.id, UnitDefNames.armoutpost3.id, UnitDefNames.armoutpost4.id,
--  UnitDefNames.coroutpost.id, UnitDefNames.coroutpost2.id, UnitDefNames.coroutpost3.id, UnitDefNames.coroutpost4.id,
--  UnitDefNames.armck.id, UnitDefNames.corck.id, UnitDefNames.armack.id, UnitDefNames.corack.id,
--  UnitDefNames.armfark.id, UnitDefNames.cormuskrat.id, UnitDefNames.corfast.id, UnitDefNames.consul.id,
--}

----------------------------------------------
------------------------------------------

function widget:Initialize()
  local _, _, spec = spGetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  local allUnits = spGetAllUnits()
  for i = 1, #allUnits do
    local unitID    = allUnits[i]
    local unitDefID = spGetUnitDefID(unitID)
    local unitTeam    = spGetUnitTeam(unitID)
    --local unitDefName = UnitDefs[unitDefID].name
    widget:UnitFinished(unitID, unitDefID, unitTeam)
  end
end

function widget:PlayerChanged()
  if Spring.GetSpectatingState() then
    widgetHandler:RemoveWidget()
  end
end

-- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
  widget:UnitFinished(unitID, unitDefID, unitTeam)
end

local function SetToPatrol(unitID, unitDefID, unitTeam, shift)
  if not trackedUnits[unitID] then
    return end

  local x, y, z = spGetUnitPosition(unitID)
  if (not x or not y or not z) then
    return end

  -- keeps commands within map boundaries
  x = (x > mapsizehalfwidth) and x-50 or x+50   -- x ? a : b, in lua notation
  z = (z > mapsizehalfheight) and z-50 or z+50

  -- meta enables reclaim enemy units, alt autoresurrect ( if available )
  spGiveOrderToUnit(unitID, CMD_PATROL, { x, y, z }, shift and {"meta", "shift"} or {"meta"} )
  trackedUnits[unitID] = "patrol"
  --Spring.Echo("Setting to patrol")
end

-- We'll only assign an order initially after any existing order
function widget:UnitFinished(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
  if ud == nil or unitTeam ~= Spring.GetMyTeamID() then
    return end
  if not trackedDefNames[ud.name] then
    return end

  trackedUnits[unitID] = "init"   -- Just a placeholder so it doesn't fail 1st SetToPatrol check
  local buildQueueSize = spGetRealBuildQueue(unitID)
  if #buildQueueSize == 0 then
    SetToPatrol(unitID, unitDefID, unitTeam, true)  --TODO: Verify/fix
    return end
end

function widget:UnitIdle(unitID, unitDefID, unitTeam)
  -- Check if the 'idle' unit wasn't previously hit by a stop (0,0,0,1) or a wait (5,0,0,1)
  if unitTeam ~= Spring.GetMyTeamID() or trackedUnits[unitID] == nil or trackedUnits[unitID] == "stop" then
    return end
  --TODO: Check if player is in critical-resources mode. Don't patrol if so (cancels build queue/assist)
  local buildQueueSize = spGetCommandQueue(unitID,0) --0 == cmdqueuesize
    --Spring.Echo("Command queue size: "..buildQueueSize)
  if #buildQueueSize==0 then
    SetToPatrol(unitID, unitDefID, unitTeam, true)
  else
    trackedUnits[unitID] = "idle"
  end
end

--function widget:CommandNotify(cmdID, cmdParams, cmdOptions)
  -- DEBUG: Info about the command taken by the unit
  --local cmdp = cmdParams and tostring(#cmdParams) or "nil"
  --local cmdo = cmdOptions and tostring(cmdOptions) or "nil"
  --Spring.Echo ( "cmdID: "..cmdID.." cmdParams: "..cmdp , " cmdOpts: "..cmdo, " sel count: "..spGetSelUnitCount() )
  --for i = 1, #cmdParams do
  --  Spring.Echo("   param "..i..": "..cmdParams[i])
  --end
  --for i = 1, #cmdOptions do
  --  Spring.Echo("   options "..i..": "..cmdOptions[i])
  --end
--end

--Called after a unit accepts a command, after AllowCommand returns true.
--Here we only set the new state the unit in entering
function widget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  --Spring.Echo("Unit: "..unitID.." ~ CmdID: "..cmdID)
  if teamID ~= Spring.GetMyTeamID() or trackedUnits[unitID] == nil then
    return end

  -- Build order is negative
  if cmdID < 0 then --and not trackedUnits[unitID] == "build" then --//and not cmdOptions.shift
    --Spring.Echo("Build order taken")
      if trackedUnits[unitID] ~= "build" then
          spGiveOrderToUnit(unitID, CMD.REMOVE, {CMD_REPAIR}, {"alt"})
      end
      spGiveOrderToUnit(unitID, CMD.REMOVE, {CMD_PATROL}, {"alt"})
      spGiveOrderToUnit(unitID, CMD.REMOVE, {CMD_FIGHT}, {"alt"})
      trackedUnits[unitID] = "build"
    --end
    return end

--  if trackedUnits[unitID] ~= "idle" then
--    return end

  if cmdID == CMD_MOVE then
    trackedUnits[unitID] = "move"
    return end

  if cmdID == CMD_RECLAIM or cmdID == CMD_REPAIR then   -- Build, reclaim or repair
    trackedUnits[unitID] = "work"
    return end

  ---- DEBUG: Info about the command taken by the unit
  --local cmdp = cmdParams and tostring(#cmdParams) or "nil"
  --local cmdo = cmdOptions and tostring(cmdOptions) or "nil"
  --Spring.Echo ( "cmdID: "..cmdID.." cmdParams: "..cmdp , " cmdOpts: "..cmdo, " sel count: "..spGetSelUnitCount() )
  --for i = 1, #cmdParams do
  --  Spring.Echo("   param "..i..": "..cmdParams[i])
  --end
  --for i = 1, #cmdOptions do
  --  Spring.Echo("   options "..i..": "..cmdOptions[i])
  --end

  if cmdID == CMD_GUARD then
    trackedUnits[unitID] = "guard"
    --Spring.Echo(" Guarded UnitDefID: "..UnitDefs[spGetUnitDefID(cmdParams[1])].name)
    local guardedUnitDef = UnitDefs[spGetUnitDefID(cmdParams[1])]
    if guardedUnitDef.isBuilder then
      guardingUnits[unitID] = cmdParams[1] end
    return end

  if cmdID == CMD_WAIT then   --cmdID == CMD_STOP or
    trackedUnits[unitID] = "wait"
    return end

  if cmdID == CMD_PATROL then
    trackedUnits[unitID] = "patrol"
    --Spring.Echo(" patrolling unit id: "..unitID)
    return end

  ---- All build orders have 4 params, fight/patrol have just a pos (3 params)
  ---- Attention: Repair/Reclaim in area also has 4 params, but 4th = 1 in build commands
  --if #cmdParams == 4 and cmdParams[4] == 1 then
  --
  --  -- ### Now we must check if all selected units are valid
  --
  --  --//Spring.GetSelectedUnitsCounts( ) -> { [number unitDefID] = number count, etc... }
  --  local selcounts = spGetSelUnitsCounts()
  --  local seloutposts = 0
  --  for _, unitID in ipairs(tDefIDs) do
  --    if selcounts [unitID] and selcounts [unitID] > 0 then
  --      seloutposts = seloutposts + 1
  --    end
  --  end
  --  if not seloutposts == selcounts then
  --    --Spring.Echo("cmd_outpost_fight: Not only outposts selected: "..seloutposts,spGetSelUnitCount())
  --    return false
  --  end
  --
  --  -- ### Finally, remove all fight commands
  --  local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
  --  for _, unitID in ipairs(selUnits) do
  --    --orderId = CMD_REMOVE --  options.ALT -> use the parameters as commandIDs --  params[0 ... N-1] = commandIDs to remove
  --    spGiveOrderToUnit(unitID, CMD.REMOVE, {CMD.FIGHT}, {"alt"})
  --    trackedUnits[unitID] = "build"
  --  end
  --else
  --  return false
  --end
end

-- Fired whenever a unit command is complete
function widget:UnitCmdDone(unitID, unitDefID, unitTeam, cmdID, cmdTag, cmdParams, cmdOpts)
  if unitTeam ~= spGetMyTeamID() or trackedUnits[unitID] == nil then
    return end

  -- DEBUG: Finished command
  --local cmdp = cmdParams and tostring(#cmdParams) or "nil"
  --local cmdo = cmdOpts and tostring(cmdOpts) or "nil"
  --Spring.Echo ( "cmdID: "..cmdID.." cmdParams: "..cmdp , " cmdOpts: "..cmdo, " sel count: "..spGetSelUnitCount() )
  --for i = 1, #cmdParams do
  --  Spring.Echo("   param "..i..": "..cmdParams[i])
  --end
  --for i = 1, #cmdTag do
  --  Spring.Echo("   tag "..i..": "..cmdTag[i])
  --end

--  local buildQueueSize = spGetRealBuildQueue(unitID)
  --Spring.Echo("queue size: "..#buildQueueSize)
--  if cmdID < 0 then
--    -- This is actually the buildqueue 'unique types' count, but it's ok for what we need here
--    local buildQueueSize = spGetRealBuildQueue(unitID)
--    if #buildQueueSize == 0 then
--      SetToPatrol(unitID, unitDefID, unitTeam, false)
--      return end
--  end

--  if #buildQueueSize==0 and trackedUnits[unitID] == "idle" then
--     --cmdID < 0 or cmdID == CMD_MOVE or cmdID == CMD_RECLAIM or cmdID == CMD_WAIT then
--
--    --spGiveOrderToUnit(unitID, CMD.REMOVE, {CMD_GUARD}, {"alt"})
--
--    SetToPatrol(unitID, unitDefID, unitTeam, false)
--    return
--  end

  local buildQueue = spGetRealBuildQueue(unitID)
  if buildQueue and #buildQueue == 0 and cmdID == CMD_REPAIR then
    --- Repair is also assist. So we must know if the finished 'repair' was of a guarded builder
    --- if so, check its queue and see if it's empty.. re-set it to patrol if that's the case
    if guardingUnits[unitID] then
      local guardedID = guardingUnits[unitID]
      local guardedBuildQueueSize = spGetRealBuildQueue(guardedID)
      -- This is actually the buildqueue 'unique types' count, but it's ok for what we need here
      --Spring.Echo("#build Queue size: "..#buildQueueSize)
      if guardedBuildQueueSize and #guardedBuildQueueSize == 0 then
        SetToPatrol(unitID, unitDefID, unitTeam, false)
        return end
--    else  -- It was a simple one-off repair, re-set to Patrol
--      SetToPatrol(unitID, unitDefID, unitTeam, false)
    end
  end

  -- -- Stopped building and assisting also call this one. Leaving as a reference
  --if cmdID == CMD_SET_WANTED_MAX_SPEED then
  --end
end

--
--- DEBUG state visually
function widget:DrawWorld()
  if not glDebugStates then
    return end
  local textColor = {1.0, 1.0, 0.7, 1.0}
  local textSize = 14
  --local trackedUnits = {} -- {unitID="patrol/build/stop"} We use this to track outposts which are in fight / build / idle mode
  --Spring.Echo("tracked count: "..#trackedUnits)
  for unitID, state in pairs(trackedUnits) do
    if Spring.IsUnitInView(unitID) then
      local ux, uy, uz = spGetUnitViewPosition(unitID)
      glPushMatrix()
      glTranslate(ux, uy, uz)
      glBillboard()
      glColor(textColor)
      glText("" .. state, -10.0, -10.0, textSize, "cos")
      glPopMatrix()
    end
  end
end
]]

--------------------------------------------------------------------------------
