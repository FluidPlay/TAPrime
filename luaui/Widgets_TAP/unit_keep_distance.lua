--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_keep_distance.lua
--  brief:   Shows the amount of metal/energy when using area reclaim.
--  original author:  Janis Lukss
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
return {
name      = "Unit Keep Distance",
desc      = "When making a group to fight, the specified radar and jammer units in it will follow others",
author    = "Pendrokar",
date      = "Nov 17, 2007",
license   = "GNU GPL, v2 or later",
layer     = 0,
enabled   = false, --true -- loaded by default?
}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local radarunitSet = {}
local jammerunitSet = {}
local countradars = 0
local countjammers = 0
local countoffensive = 0
local closeunit = {0, 9999}
local distance,udx1,udz1,udy1,udx2,udz2,udy2 = 0
local abs = math.abs 

local unitArray = {}
unitArray["radarunitArray"] = {
  --radar units
  -----TAPrime-----
  "armseer",
  "armmark",
  "corvrad",
  --"corvoyr",
}

unitArray["jammerunitArray"] = {
  --jammer units
  -----TAPrime-----
  "armaser",
  "coreter",
  "arm_jammer",
  "core_spectre",
  "armsjam",
  "corsjam",
}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:Initialize()
  if Spring.GetSpectatingState() or Spring.IsReplay() then
    widgetHandler:RemoveWidget()
    return true
  end
  for _, v in pairs(unitArray["radarunitArray"]) do
    radarunitSet[v] = true
  end
  for _, v in pairs(unitArray["jammerunitArray"]) do
    jammerunitSet[v] = true
  end
end

function widget:CommandNotify(commandID, params, options)
  local selUnits = Spring.GetSelectedUnits()
  local count = #selUnits

  if (count>1) and (commandID == CMD.FIGHT) then
    local radarunittable = {}
    local jammerunittable = {}
    local offensiveunittable = {}
    countradars = 0
    countjammers = 0
    countoffensive = 0
    for k,unitID in pairs(selUnits) do
      local udef = Spring.GetUnitDefID(unitID)
      local ud = UnitDefs[udef]
      if (ud ~=nil) and (radarunitSet[ud.name]) and (k ~= "n") then
       --radar unit
       countradars = countradars + 1
       radarunittable[countradars] = unitID
       
      elseif (ud ~=nil) and (jammerunitSet[ud.name]) and (k ~= "n") then
       --jammer unit
       countjammers = countjammers + 1
       jammerunittable[countjammers] = unitID
       
      elseif (ud ~= nil) then
       --other unit
       local wd = ud.weapons[1]
       if (wd ~= nil) then
        local weaponDefID = wd.weaponDef
        if (weaponDefID ~= nil) then
         --offensive unit
         if (WeaponDefs[weaponDefID].range ~= nil) and (k ~= "n") then 
          table.insert(offensiveunittable,{ unitID, WeaponDefs[weaponDefID].range })
          countoffensive = countoffensive + 1
         end 
        end
       end  
      end 
    end
    
    if((countradars ~= 0) or (countjammers ~= 0)) and (countoffensive ~= 0) then
      local aradar = 1
      local ajammer = 1

      table.sort(offensiveunittable, compRanges) --reversed sorting
      for i in ipairs(offensiveunittable) do
        unitID = offensiveunittable[i][1]
        range = offensiveunittable[i][2]
        udx1,udz1,udy1 = Spring.GetUnitPosition(unitID)
        
        if(countradars ~= 0) then
          for v1,i2 in pairs(radarunittable) do
            udx2,udz2,udy2 = Spring.GetUnitPosition(i2)
            distance = math.sqrt(abs(udx1 - udx2) + abs(udz1 - udz2)+ abs(udy1 - udy2))
            if (closeunit[2] > distance) then
             closeunit[1],closeunit[2] = i2, distance  
             aradar = v1
            end
          end
          Spring.GiveOrderToUnit(closeunit[1], CMD.GUARD, {unitID},options)
          if(aradar ~= nil) then
           radarunittable[aradar] = nil
           --Spring.Echo(closeunit[1],"--radar-->",unitID, countradars)
           countradars = countradars - 1
          end
        end
        closeunit[2] = 9999
        
        if(countjammers ~= 0) then
          for v2,i3 in pairs(jammerunittable) do
            udx2,udz2,udy2 = Spring.GetUnitPosition(i3)
            distance = math.sqrt(abs(udx1 - udx2) + abs(udz1 - udz2)+ abs(udy1 - udy2))
            if (closeunit[2] > distance) then
             closeunit[1],closeunit[2] = i3, distance  
             ajammer = v2
            end    
          end
          Spring.GiveOrderToUnit(closeunit[1], CMD.GUARD, {unitID},options)
          if(ajammer ~= nil) then
           jammerunittable[ajammer] = nil
           --Spring.Echo(closeunit[1],"--jammer-->",unitID, countjammers)
           countjammers = countjammers - 1
          end
        end
        countoffensive = countoffensive - 1
        closeunit[2] = 9999
        -- issue called command
        Spring.GiveOrderToUnit(unitID, CMD.FIGHT, params, options.coded)
        -- if radars and jammers are more than offensive units they will still go forth with fight order
      end
      -- Override command issue process
      return true
    end
  end
  return false
end

function compRanges(a,b) 
return a[2] > b[2]
end
