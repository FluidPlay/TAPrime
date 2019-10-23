---
--- Created by Breno "MaDDoX" Azevedo.
---
if not gadgetHandler:IsSyncedCode() then
    return end

function gadget:GetInfo()
    return {
        name      = "Weapon Handler - Meteor Strike",
        desc      = "Spawns a bunch of minor meteors around the point where the tagger hit",
        author    = "MaDDoX",
        date      = "23 October 2019",
        license   = "GNU GPL, v2 or later",
        layer     = -100,
        enabled   = true,
    }
end

-----------------
---- SYNCED
-----------------

--VFS.Include("gamedata/taptools.lua")

local trackedWeapon
local createList = {}
local spCreateUnit = Spring.CreateUnit
local spGetUnitTeam = Spring.GetUnitTeam
local spSetWatchWeapon = Script.SetWatchWeapon

local meteorDefID = UnitDefNames["meteor"].id

function gadget:Initialize()
    for _,def in pairs(WeaponDefs) do
        if def.name == "corvrad_meteor_painter" then
            trackedWeapon = def.id
        end
    end
    spSetWatchWeapon(trackedWeapon, true)
end

function gadget:Explosion(w, x, y, z, owner)
    if w == trackedWeapon and owner then
        --if not Spring.GetGroundBlocked(x,z) then
        table.insert(createList, {owner = owner, x=x,y=y,z=z})
        Spring.Echo("Tracked Explosion")
        return true
        --end
    end
    return false
end

function gadget:GameFrame(f)
    for i,c in pairs(createList) do
        Spring.Echo("Spawning at: "..c.x..", "..c.y..", "..c.z)
        spCreateUnit(meteorDefID, c.x, c.y+50, c.z, "north", spGetUnitTeam(c.owner))
        createList[i]=nil
    end
end

