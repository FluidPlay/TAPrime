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
--local gaiaTeamID = Spring.GetGaiaTeamID()

local trackedWeapon
local createList = {}
local spCreateUnit = Spring.CreateUnit
local spGetUnitTeam = Spring.GetUnitTeam
local spSetWatchWeapon = Script.SetWatchWeapon

local meteorDefID =  UnitDefNames["meteor"].id
local METEOR_EXPLOSION = WeaponDefNames["meteor_weapon"].id

function gadget:Initialize()
    for _,def in pairs(WeaponDefs) do
        if def.name == "corvrad_meteor_painter" then
            trackedWeapon = def.id
        end
    end
    spSetWatchWeapon(trackedWeapon, true)
end

function gadget:Explosion(w, x, y, z, attackerID)
    if w == trackedWeapon and attackerID then
        --local y2 = Spring.GetGroundHeight(x,z)+100
        --if not Spring.GetGroundBlocked(x,z) then
        table.insert(createList, { attackerID = attackerID, x=x, y=y, z=z})
        Spring.Echo("Tracked Explosion")
        return true
        --end
    end
    return false
end

function gadget:GameFrame(f)
    for i,c in pairs(createList) do
        local radius = 250
        local rand1 = (math.random() - 0.5) * radius
        local rand2 = (math.random() - 0.5) * radius
        local unitID = Spring.CreateUnit(meteorDefID, c.x + rand1, c.y, c.z + rand2, "north", spGetUnitTeam(c.attackerID))
        --Spring.Echo("Spawned "..unitID.." at: "..c.x..", "..c.y..", "..c.z)
        Spring.SetUnitNoDraw(unitID, true)
        Spring.SetUnitStealth(unitID, true)
        Spring.SetUnitSonarStealth(unitID, true)
        --Spring.SetUnitNeutral(unitID, true) -- Watch out, this breaks stuff
        --spCreateUnit(meteorDefID, c.x, c.y+50, c.z, "north", spGetUnitTeam(c.owner))
        createList[i]=nil
    end
end

