--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_auto_holdposition.lua
--  brief:   Sets starting units and new factories to hold position
--  author:  Masta Ali, updated by MaDDoX
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Auto hold position",
    desc      = "Sets starting units, new factories, and all units they build, to hold position automatically",
    author    = "Masta Ali",
    date      = "Mar 20, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetMyTeamID = Spring.GetMyTeamID
local spGetUnitDefID = Spring.GetUnitDefID
local spGetAllUnits = Spring.GetAllUnits
local spGetUnitTeam = Spring.GetUnitTeam
local spGetGameFrame = Spring.GetGameFrame
local unitSet = {}
local initialized = false

--local unitArray = {
--  "armlab",
--  "armalab",
--  "armvp",
--  "armavp",
--  "armsy",
--  "armasy",
--  "armhp",
--  "armfhp",
--  "armshtlx",
--  "armcom",  "armcom2",  "armcom3",  "armcom4",
--  "asubpen",
--  "corlab",
--  "coralab",
--  "corvp",
--  "coravp",
--  "corsy",
--  "corasy",
--  "corhp",
--  "corfhp",
--  "corgant",
--  "csubpen",
--  "corcom",  "corcom2",  "corcom3",  "corcom4",
--}
local exceptionArray = {
  armfark = true, cormuskrat = true, corfast = true, armconsul = true,
  corcom = true,  corcom2=true,  corcom3=true,  corcom4=true,
  armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
  coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
  armck = true, armcv = true, armca = true, armack = true, armacv = true, armaca = true,
  corck = true, corcv = true, corca = true, corack = true, coracv = true, coraca = true,
  corcrw = true,
}
----------------------------------------------
------------------------------------------

function widget:Initialize()
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  --for i, v in pairs(unitArray) do
  --  unitSet[v] = true
  --end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
  if ud ~= nil and unitTeam == spGetMyTeamID() then
    --for i, v in pairs(unitSet) do
    if not exceptionArray[ud.name] then
        spGiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, {})
    end
    --end
  end
end

-- We'll set starting units at frame 2 to make sure they're all instantiated
function widget:GameFrame(n)
  if initialized then
    return end
  if spGetGameFrame() > 1 then
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
      local unitID    = allUnits[i]
      local unitDefID = spGetUnitDefID(unitID)
      local unitTeam    = spGetUnitTeam(unitID)
      --local unitDefName = UnitDefs[unitDefID].name
      widget:UnitCreated(unitID, unitDefID, unitTeam)
    end
    initialized = true
  end
end

--------------------------------------------------------------------------------
