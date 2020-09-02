--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    featuredefs_post.lua
--  brief:   featureDef post processing
--  author:  Dave Rodgers
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Per-unitDef featureDefs
--

local function isbool(x)   return (type(x) == 'boolean') end
local function istable(x)  return (type(x) == 'table')   end
local function isnumber(x) return (type(x) == 'number')  end
local function isstring(x) return (type(x) == 'string')  end

VFS.Include("gamedata/taptools.lua")

--------------------------------------------------------------------------------

local function ProcessUnitDef(udName, ud)

  local featuredefs = ud.featuredefs
  if not istable(featuredefs) then
    return
  end

  -- add this unitDef's featureDefs
  for id, featuredef in pairs(featuredefs) do
    -- Automatically set metal and resistance of this featuredef, according to its unitdef info
    local function calculateMetalAndDamage(id, featuredef, uDef)
        local metalFactor, damageFactor, crushresistFactor, groupMult = 1, 1, 1, 1
        if id:find("dead") then
            metalFactor, damageFactor, crushresistFactor = 0.6, 0.5, 1
        elseif id:find("heap") then
            metalFactor, damageFactor, crushresistFactor = 0.25, 0.25, 0.5
        end
        if uDef.customparams and uDef.customparams.groupsize then
            groupMult = 1/uDef.customparams.groupsize
        end
        featuredef.metal = uDef.buildcostmetal * metalFactor * groupMult --true buildcostmetal
        featuredef.damage = uDef.maxdamage * damageFactor    --health
        local crushResist = uDef.crushresistance or uDef.mass
        if crushResist then
            featuredef.crushresistance = crushResist * crushresistFactor
        end
        --Spring.Echo("name, id, metal, damage: "..uDef.name..", "..id..", "..featuredef.metal..", "..featuredef.damage)
        return featuredef
    end

    if (isstring(id) and istable(featuredef)) then
      if ud.buildcostmetal and ud.maxdamage then
        featuredef = calculateMetalAndDamage(id, featuredef, ud) end
      -- Make all unit's featureDefs 'unpushable'
      featuredef.mass = 999999
      local fullName = udName .. '_' .. id
      FeatureDefs[fullName] = featuredef
    end
  end

  -- FeatureDead name changes (featureName of the feature to spawn when this feature is destroyed)
  for id, featuredef in pairs(featuredefs) do
    if (isstring(id) and istable(featuredef)) then
      if (isstring(featuredef.featuredead)) then
        local fullName = udName .. '_' .. featuredef.featuredead:lower()
        if (FeatureDefs[fullName]) then
          featuredef.featuredead = fullName
        end
      end
    end
  end

  -- convert the unit corpse name
  if (isstring(ud.corpse)) then
    local fullName = udName .. '_' .. ud.corpse:lower()
    local fd = FeatureDefs[fullName]
    if (fd) then
      ud.corpse = fullName
    end
  end
  
  if Spring.GetModOptions().smallfeaturenoblock == "enabled" then
      for id,featureDef in pairs(FeatureDefs) do
          if featureDef.name ~= "rockteeth" and
             featureDef.name ~= "rockteethx" then
              if featureDef.footprintx ~= nil and featureDef.footprintz ~= nil then
                  if tonumber(featureDef.footprintx) <= 2 and tonumber(featureDef.footprintz) <= 2 then
                      --Spring.Echo(featureDef.name)
                      --Spring.Echo(featureDef.footprintx .. "x" .. featureDef.footprintz)
                      featureDef.blocking = false
                      --Spring.Echo(featureDef.blocking)
                  end
              end
          end
      end
  end

end


--------------------------------------------------------------------------------

-- Process the unitDefs
local UnitDefs = DEFS.unitDefs

for udName, ud in pairs(UnitDefs) do
  if (isstring(udName) and istable(ud)) then
    ProcessUnitDef(udName, ud)
  end
end


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
