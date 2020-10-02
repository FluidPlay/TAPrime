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

-- Process the unitDefs
local UnitDefs = DEFS.unitDefs

--------------------------------------------------------------------------------

local function ProcessUnitDef(uDefID, uDef)

  local unitFeatureDefs = uDef.featuredefs
  if not istable(unitFeatureDefs) then
    return
  end

  -- add this unitDef's featureDefs
  for featID, featureData in pairs(unitFeatureDefs) do
    -- Automatically set metal and resistance of this featureDef, according to its unitdef info
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

    if (isstring(featID) and istable(featureData)) then
      if uDef.buildcostmetal and uDef.maxdamage then
        featureData = calculateMetalAndDamage(featID, featureData, uDef) end
      -- Make all unit's featureDefs 'unpushable'
      featureData.mass = 99999
      --Spring.Echo("Fullname: uDefID - ".. uDefID .." id - ".. featID)
      local fullName = uDefID .. '_' .. featID

        --- This is working / not working. The final scav UnitDef is somehow still pointing to the original featureDef
        if string.find(uDefID, '_scav_') then
            --Spring.Echo ("Processing "..uDefID)
            local baseCorpseName = uDefID
            if featID == "dead" and featureData.description then
                --Spring.Echo ("Found dead")
                featureData.description = "Scavenger "..featureData.description
                featureData.resurrectable = 0
                UnitDefs[uDefID].wreckName = baseCorpseName.."dead"    --eg: armcom_scav_dead
            end
            if featID == "heap" and featureData.description then
                featureData.description = "Scavenger "..featureData.description
            end
        end

      FeatureDefs[fullName] = featureData
      UnitDefs[uDefID].featuredefs[featID] = featureData
    end
  end

  ---TODO: Temporarily commented out
  -- FeatureDead name changes (featureName of the feature to spawn when this feature is destroyed)
  for id, featuredef in pairs(unitFeatureDefs) do
    if (isstring(id) and istable(featuredef)) then
      if (isstring(featuredef.featuredead)) then
        local fullName = uDefID .. '_' .. featuredef.featuredead:lower()
        if (FeatureDefs[fullName]) then
          featuredef.featuredead = fullName
        end
      end
    end
  end

  --convert the unit corpse name
  if (isstring(uDef.corpse)) then
    local fullName = uDefID .. '_' .. uDef.corpse:lower()
    local fd = FeatureDefs[fullName]
    if (fd) then
      uDef.corpse = fullName
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

for uDefID, uDef in pairs(UnitDefs) do
  if (isstring(uDefID) and istable(uDef)) then
    ProcessUnitDef(uDefID, uDef)
  end
end


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
