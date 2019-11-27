-----------------------------------------------
-----------------------------------------------
---
--- file: unit_advwin.lua
--- brief: Adds 50% more energy to Advanced Wind Generators
--- author: Breno 'MaDDoX' Azevedo
--- DateTime: 4/11/2018 1:42 AM
---
--- License: GNU GPL, v2 or later.
---
-----------------------------------------------
-----------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Unit Adv Wind",
        desc      = "Adds additional energy output on high ground and to Advanced Wind Generators",
        author    = "MaDDoX",
        date      = "Apr, 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true
    }
end

-- Synced only
if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")

local updateRate = 6    -- how Often, in frames, to do updates

local maxHeightScaler = 1.5
local minMapHeight = 100        -- Just a sample starting value, we read this from the map
local maxMapHeightDelta = 464   -- 564 is DSD's highest, 100 is its lowest. Using that as reference.
local maxMapHeight = 565        -- Any y Position above this delta will cap @ maxHeightScaler

local spGetWind             = Spring.GetWind
local spGetUnitPosition     = Spring.GetUnitPosition
--local gmMinWind             = Game.windMin
local gmMaxWind             = Game.windMax
local t2WindMultiplier      = 4.5
local spSetUnitResourcing   = Spring.SetUnitResourcing
local maxModWindSpeed       = 25


local advWindGens = {}     --[unitID] = true
local windGens = {}

function gadget:Initialize()
    local readHeight = Spring.GetMapOptions().minMapHeight
    minMapHeight = (readHeight == nil)
            and Spring.GetGroundExtremes()
            or readHeight
    maxMapHeight = minMapHeight + maxMapHeightDelta
    --    if (readHeight ~= nil) then
    --        minMapHeight = readHeight
    --    else
    --        minMapHeight = Spring.GetGroundExtremes()
    --    end
    Spring.Echo("unit_advwin :: Found MinMapHeight = "..minMapHeight)
    for _,unitID in ipairs(Spring.GetAllUnits()) do
        local teamID = Spring.GetUnitTeam(unitID)
        local unitDefID = Spring.GetUnitDefID(unitID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end
end

-- Check if an adv. windgen was built, adding it to the table if so
function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    if ud == nil then
        return end
    if ud.customParams.specialty == "wind" then
        --Spring.Echo("Unit added, specialty: "..ud.customParams.specialty.." Tier: "..ud.customParams.tier)
        windGens[unitID] = true
        if ud.customParams.tier == "2" then
            advWindGens[unitID]=true end
    end
end

function gadget:GameFrame(f)
    if f % updateRate > 0.0001 then
        return end

    local _, _, _, currentWind = spGetWind()
    -- limit to 25, the maximum wind speed in TA Prime and BA
    currentWind = math.min(math.min(currentWind, gmMaxWind), maxModWindSpeed)
    for unitID,_ in pairs(windGens) do
        local _,unitYpos = spGetUnitPosition(unitID)
        local windMultiplier = lerp(1, maxHeightScaler, inverselerp(minMapHeight, maxMapHeight, unitYpos))
        if (advWindGens[unitID]) then
            windMultiplier = windMultiplier * t2WindMultiplier end
        spSetUnitResourcing (unitID, 'ume', currentWind * windMultiplier)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    windGens[unitID] = nil
    advWindGens[unitID] = nil
end