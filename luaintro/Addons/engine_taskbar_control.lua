--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function addon:GetInfo()
  return {
    name      = "Engine Taskbar Stuff",
    desc      = 'Icon, name',
    author    = "KingRaptor",
    date      = "13 July 2011",
    license   = "Public Domain",
    layer     = -math.huge,
    enabled   = false, --true,
  }
end

--------------------------------------------------------------------------------
function addon:Initialize()
	local name = Game.modName
    Spring.SetWMIcon("bitmaps/taplogo.png")
	Spring.SetWMCaption(name .. " (Spring " .. ((Game and Game.version) or (Engine and Engine.version) or "") .. ")", name)
end