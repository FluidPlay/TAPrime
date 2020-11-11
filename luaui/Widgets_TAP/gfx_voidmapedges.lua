--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    widget_autosetup.lua
--  brief:   Auto-widget initializer. Enables/disables widgets according to MaddPack
--  author:  Breno 'MaDDoX' Azevedo
--
--  Copyright (C) 2017.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- changes:
--   First Release (28/8/2017) - added to BA's MaddPack
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name      = "Map Void Edges",
        desc      = "Voids Map Edges",
        author    = "Breno 'MaDDoX' Azevedo",
        date      = "Nov 5, 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        handler   = true,   -- Allows this to run 'SendCommands'
        enabled   = true,
    }
end

function widget:Initialize()
    Spring.Echo("Setting map edge as void (TAPrime)")
    Spring.SendCommands("luaui disablewidget Map Edge Extension")
    Spring.SendCommands("luaui disablewidget Map External VR Grid")
    Spring.SendCommands("mapborder 0")  -- gets rid of the map border downwards gradient


    --Spring.SetDrawSky(false)
    Spring.SetDrawWater(true)
    Spring.SetDrawGround(true)
    Spring.SetDrawSky(false)
    Spring.SetMapRenderingParams({voidWater = false, voidGround = true})
    Spring.SetSkyBoxTexture("LuaUI/Images/vr_grid.png")
        ---fog{Start,End}, {sun,sky,cloud}Color
    Spring.SetAtmosphere({ skyColor = { 0.0, 0.0, 0.0 }, sunColor = { 0.0, 0.0, 0.0 }})
end