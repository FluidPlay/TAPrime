--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Tombstones",
    desc      = "Displays tombstones where commanders died",
    author    = "Floris",
    date      = "Sept 2017",
    license   = "GNU GPL, v2 or later",
    layer     = 10,
    enabled   = false --true  --  loaded by default? || Not a good idea with the morphing commanders..
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local tombstones = {}
local commanders = {}
local spGetUnitRulesParam = Spring.GetUnitRulesParam

for udefID,def in ipairs(UnitDefs) do
  if def.name == 'armstone' then
    armstoneUdefID = udefID
  end
  if def.name == 'corstone' then
    corstoneUdefID = udefID
  end
  if def.customParams.iscommander ~= nil then
    commanders[def.name] = true
  end
end

function widget:Initialize()
  if armstoneUdefID == nil or corstoneUdefID == nil then
    Spring.Echo('tombstones widget: No tombstones availible')
    widgetHandler:RemoveWidget(self)
  end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
  -- Only deal with destroyed commanders which weren't morphed into
  if ud == nil or commanders[ud.name] == nil or spGetUnitRulesParam(unitID, "justmorphed") == 1 then
    return end
  local x,y,z = Spring.GetUnitPosition(unitID)
  local tombstoneUdefID = armstoneUdefID
  if ud.name == 'corcom' then
    tombstoneUdefID = corstoneUdefID
  end
  tombstones[#tombstones+1] = {tombstoneUdefID, unitTeam, x, Spring.GetGroundHeight(x,z),z, ((math.random()-0.5)*25), (14 + (math.random()*14)), ((math.random()-0.5)*18)}
end


function widget:DrawWorldPreUnit()
  local camX, camY, camZ = Spring.GetCameraPosition()
  gl.DepthTest(true)
  for i=1, #tombstones do
    if Spring.IsSphereInView(tombstones[i][3],tombstones[i][4],tombstones[i][5], 30) and math.diag(camX-tombstones[i][3], camY-tombstones[i][4], camZ-tombstones[i][5]) < 5000 then
      tombstones[i][4] = Spring.GetGroundHeight(tombstones[i][3],tombstones[i][5])
      gl.PushMatrix()
        gl.LoadIdentity()
        gl.Translate(tombstones[i][3],tombstones[i][4],tombstones[i][5])
        gl.Rotate(tombstones[i][6],0,1,1)
        gl.Rotate(tombstones[i][7],-1,0,0)
        gl.Rotate(tombstones[i][8],0,0,1)
        gl.UnitShape(tombstones[i][1],tombstones[i][2], false, false, true)
      gl.PopMatrix()
    end
  end
  gl.DepthTest(false)
end

-- preserve data in case of a /luaui reload
function widget:GetConfigData(data)
  savedTable = {}
  savedTable.tombstones = tombstones
  savedTable.gameframe = Spring.GetGameFrame()
  return savedTable
end

function widget:SetConfigData(data)
  if Spring.GetGameFrame() > 0 and data.gameframe ~= nil and data.gameframe+1800 > Spring.GetGameFrame() and data.gameframe >= Spring.GetGameFrame() then
    if data.tombstones ~= nil then
      tombstones = data.tombstones
    end
  end
end

