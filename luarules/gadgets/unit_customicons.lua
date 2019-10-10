--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    ico_customicons.lua
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
-- This gadget checks through the attributes of each unitdef and assigns an appropriate icon for use in the minimap & zoomed out mode.
--
-- The reason that this is a gadget (it could also be a widget) and not part of weapondefs_post.lua/iconTypes.lua is the following:  
-- the default values for UnitDefs attributes that are not specified in our unitdefs lua files are only loaded into UnitDefs AFTER
-- unitdefs_post.lua and iconTypes.lua have been processed. For example, at the time of unitdefs_post, for most units ud.speed is  
-- nil and not a number, so we can't e.g. compare it to zero. Also, it's more modularized as a widget/gadget. 
-- [We could set the default values up in unitdefs_post to match engine defaults but thats just too hacky.]
--
-- Bluestone 27/04/2013
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "CustomIcons",
    desc      = "Sets custom unit icons for TAPrime",
    author    = "trepan, BD, TheFatController, updated by MaDDoX",
    date      = "Jan 8, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -100,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then
  return false
end

--------------------------------------------------------------------------------

local wasLuaModUIEnabled = 0

--- iconID, baseIconSize
local unitIconTable = {
      air_generic=1.25,
      air_bomber=2,
      air_builder=1.25,
      air_fighter=1.4,
      air_gunshiplaser=1.2,
      air_gunshipmissile=1.2,
      def_artillery=1.8,
      def_builder=1.5,
      def_flak=1.4,
      def_generic=0.8,
      def_laser=1.3,
      def_missile=1.4,
      def_plasma=1.5,
      generic_unit=1,
      kbot_artillery=1.1,
      kbot_assault=1,
      kbot_builder=1.1,
      kbot_generic=0.8,
      kbot_missile=1,
      kbot_flak=1,
      kbot_neutron=1.15,
      kbot_antinuke=1.25,
      kbot_plasma=1.1,
      kbot_radar=1.1,
      kbot_rifle=0.9,
      structure_mine=0.5,
      structure_antinuke=1.5,
      structure_energy=1.5,
      structure_factory=1.7,
      structure_generic=0.5,
      structure_metal=1.25,
      structure_nuke=1.95,
      structure_radar=1.1,
      structure_shield=2,
      structure_tech=1.5,
      veh_antibot=1.5,
      veh_artillery=1.4,
      veh_assault=1.5,
      veh_builder=1.5,
      veh_flak=1.5,
      veh_generic=1.5,
      veh_missile=1.5,
      veh_neutron=1.5,
      veh_antinuke=2,
      veh_radar=1.5,
      veh_tank=1.6,
      sea_light = 0.9,
      sea_support = 1,
      sea_heavy = 1.25,
}

local tierSizeMult = {
    [0]=1.1,
    [1]=1.25,
    [2]=1.4,
    [3]=1.6,
    [4]=2,
}

--------------------------------------------------------------------------------

function gadget:Initialize()

    local function tryLoad(fileName, iconName, size)
        if VFS.LoadFile(fileName) then
            Spring.AddUnitIcon(iconName, fileName, size)
        else
            Spring.Echo("Icon file not found: "..fileName)
        end
    end
    for iconid, baseSize in pairs(unitIconTable) do
        for tier = 0, 4 do  -- eg.: veh_tank_1.png (for a tier 1 tank)
            local calcSize = baseSize * tierSizeMult[tier]
            local fileName = "LuaUI/Icons/"..iconid..".png"
            tryLoad(fileName, iconid.."_"..tier, calcSize )
          --if VFS.LoadFile(fileName) then
          --  Spring.AddUnitIcon(iconid.."_"..tier, fileName, calcSize)
          --else
          --  Spring.Echo("Icon file not found: "..fileName)
          --end
        end
    end
    -- Tech Centers
    local fileName = "LuaUI/Icons/structure_techcenter"
    for tier = 0, 4 do  -- eg.: veh_tank_1.png (for a tier 1 tank)
        local fileName = fileName..tier..".png"
        tryLoad(fileName, "structure_techcenter"..tier, 1.9 )
    end
    -- Outposts
    fileName = "LuaUI/Icons/structure_outpost"
    tryLoad(fileName..".png", "structure_outpost", 1.6 )
    tryLoad(fileName.."2.png", "structure_outpost2", 1.7 )
    tryLoad(fileName.."3.png", "structure_outpost3", 1.8 )
    tryLoad(fileName.."4.png", "structure_outpost4", 1.9 )

    -- Commanders et al
    Spring.AddUnitIcon("armcom.user", "LuaUI/Icons/armcom.png",2)
    Spring.AddUnitIcon("corcom.user", "LuaUI/Icons/corcom.png",2)
    Spring.AddUnitIcon("krogoth.user", "LuaUI/Icons/krogoth.png",3.3)
    Spring.AddUnitIcon("bantha.user", "LuaUI/Icons/bantha.png",2.6)
    Spring.AddUnitIcon("corjugg.user", "LuaUI/Icons/juggernaut.png",3.5)
    Spring.AddUnitIcon("star.user", "LuaUI/Icons/star.png")
    Spring.AddUnitIcon("blank.user", "LuaUI/Icons/blank.png")

    -- Setup the unitdef icons
    for udid,ud in pairs(UnitDefs) do
      if ud then
        local tier = ud.customParams.tier or 0
        local iconTag = ud.customParams.icontag
      --Spring.Echo(" udid | name: "..udid.." | "..ud.name.." subs: "..ud.name:sub(0,6))
          --      -- Icontag defined
          --      --Spring.Echo("Unit name for icon: "..ud.name)
        if iconTag then
          Spring.SetUnitDefIcon(udid, iconTag.."_"..tier)
          --Spring.Echo("Set icon: "..iconTag.."_"..tier)

        -- #################
        -- Exceptional Cases
        -- #################
        elseif (ud.name=="roost") or (ud.name=="meteor") then
          Spring.SetUnitDefIcon(udid, "star.user")
        elseif string.sub(ud.name, 0, 7) == "critter" then
          Spring.SetUnitDefIcon(udid, "blank.user")
        elseif ud.name == "armcom" or ud.name:sub(0,6)=="armcom" then    -- Tiers 1 through 4
          --Spring.Echo("Commander found")
          Spring.SetUnitDefIcon(udid, "armcom.user")
        elseif ud.name == "corcom" or ud.name:sub(0,6)=="corcom" then    -- Tiers 1 through 4
          --Spring.Echo("Commander found")
          Spring.SetUnitDefIcon(udid, "corcom.user")
        elseif ud.name == "armtech" or ud.name:sub(0,7)=="armtech" or    -- Tiers 1 through 4
               ud.name == "cortech" or ud.name:sub(0,7)=="cortech" then
          Spring.SetUnitDefIcon(udid, "structure_techcenter"..tier)
        elseif ud.name == "armoutpost" or ud.name == "coroutpost" then    -- Tiers 0 (no Tier 1)
          Spring.SetUnitDefIcon(udid, "structure_outpost")
        elseif ud.name:sub(0,10)=="armoutpost" or ud.name:sub(0,10)=="coroutpost" then -- Tiers 2 ~ 4
            Spring.SetUnitDefIcon(udid, "structure_outpost"..tier)
        elseif ud.name=="armbanth" then
            Spring.SetUnitDefIcon(udid, "bantha.user")
        elseif ud.name=="corkrog" then
            Spring.SetUnitDefIcon(udid, "krogoth.user")
        elseif ud.name=="corjugg" then
            Spring.SetUnitDefIcon(udid, "corjugg.user")
        --else
        --  Spring.SetUnitDefIcon(udid, "generic_unit_"..tier)
        --  Spring.Echo("Icontag for "..ud.name.." not found, setting it to generic_unit_"..tier)
        end
      end
    end

    --
    ---- Walls
    --Spring.SetUnitDefIcon(UnitDefNames["cordrag"].id, "tiny-square.user")
    --Spring.SetUnitDefIcon(UnitDefNames["armdrag"].id, "tiny-square.user")
    --Spring.SetUnitDefIcon(UnitDefNames["corfort"].id, "tiny-square.user")
    --Spring.SetUnitDefIcon(UnitDefNames["armfort"].id, "tiny-square.user")
    --Spring.SetUnitDefIcon(UnitDefNames["corfdrag"].id, "tiny-square.user")
    --Spring.SetUnitDefIcon(UnitDefNames["armfdrag"].id, "tiny-square.user")

end

--------------------------------------------------------------------------------

