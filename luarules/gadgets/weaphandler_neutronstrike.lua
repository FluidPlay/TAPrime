---
--- Created by Breno "MaDDoX" Azevedo.
---
if not gadgetHandler:IsSyncedCode() then
    return end

function gadget:GetInfo()
    return {
        name      = "Weapon Handler - Neutron Strike",
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
local spawnList = {}
local spCreateUnit = Spring.CreateUnit
local spGetUnitTeam = Spring.GetUnitTeam
local spSetWatchWeapon = Script.SetWatchWeapon
local spSetUnitNoDraw = Spring.SetUnitNoDraw
local spSetUnitStealth = Spring.SetUnitStealth
local spSetUnitSonarStealth = Spring.SetUnitSonarStealth
local spSetUnitBlocking = Spring.SetUnitBlocking
local spSetUnitNeutral = Spring.SetUnitNeutral
local spGetGameFrame = Spring.GetGameFrame
local minSpawnDelay = 1.25 * 30 -- n seconds in frames  --TODO: Make static
local maxSpawnDelay = 2 * 30    -- n seconds in frames

local meteoriteDefID =  UnitDefNames["meteorite"].id
--local METEOR_EXPLOSION = WeaponDefNames["meteorite_weapon"].id

local meteroiteSpawnRadius = 250
local rnd = math.random

VFS.Include("gamedata/taptools.lua")

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
        local thisSpawnDelay = lerp(minSpawnDelay, maxSpawnDelay, rnd())
        table.insert(spawnList, { spawnTime = spGetGameFrame() + thisSpawnDelay, attackerID = attackerID, x=x, y=y, z=z})
        --Spring.Echo("Tracked Explosion")
        return true
        --end
    end
    return false
end

function gadget:GameFrame(f)
    for i, data in pairs(spawnList) do
        if data.spawnTime >= f then
            local rand1 = (rnd() - 0.5) * meteroiteSpawnRadius
            local rand2 = (rnd() - 0.5) * meteroiteSpawnRadius
            local unitID = spCreateUnit(meteoriteDefID, data.x + rand1, data.y, data.z + rand2, "north", spGetUnitTeam(data.attackerID))
            --Spring.Echo("Spawned "..unitID.." at: "..c.x..", "..c.y..", "..c.z)
            spSetUnitNoDraw(unitID, true)
            spSetUnitStealth(unitID, true)
            spSetUnitSonarStealth(unitID, true)
            spSetUnitBlocking(unitID, false, false, false, false, false, false, false)
            spSetUnitNeutral(unitID, true)
            table.remove(spawnList, i)
        end
        --spawnList[i]=nil
    end
end

