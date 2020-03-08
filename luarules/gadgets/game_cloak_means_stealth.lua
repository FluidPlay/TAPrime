---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 20-Nov-18 3:45 AM
---
function gadget:GetInfo()
    return {
        name      = "Cloak means Stealth",
        desc      = "Makes unit become stealth whenever cloak is active (and not in enemy radar range)",
        author    = "MaDDoX",
        date      = "20 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
-----------------
---- SYNCED
-----------------

    VFS.Include("gamedata/taptools.lua")

    --local spGetGameFrame = Spring.GetGameFrame
    --local spGetFeaturePosition = Spring.GetFeaturePosition
    --local spCreateUnit = Spring.CreateUnit
    --local spSetUnitNeutral = Spring.SetUnitNeutral
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetAllUnits	= Spring.GetAllUnits
    local spGetUnitIsCloaked = Spring.GetUnitIsCloaked
    local spSetUnitStealth = Spring.SetUnitStealth --spSetUnitStealth(unitID, iscloaked)
    local spGetUnitPosition = Spring.GetUnitPosition
    local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
    local spGetMyAllyTeamID 	= Spring.GetMyAllyTeamID

    local initialized = false

    local trackedUnits = {}     -- [unitID] = allyTeamID
    local trackedRadars = {}    -- [unitID] = { allyID = 0, detectionSqrRad = 1500 }
    local mines = {}            -- {unitID=true, ..}
    local updateRate = 2        -- Update frame rate (every 2 frames)
    local customPingRate = 60   -- 1 ping every 2 seconds
    local diag = math.diag -- Cheap "distance" calculation.

    local mineIDs = {
        [UnitDefNames["armmine1"].id] = true,   -- Poker anti-inf mine
        [UnitDefNames["armmine3"].id] = true,   -- Poker anti-veh mine
        [UnitDefNames["cormine4"].id] = true,   -- Commando Flak mine
    }
    local radarIDs = {
        [UnitDefNames["armrad"].id] = 1,    -- Radar tower
        [UnitDefNames["corrad"].id] = 1,    -- Radar tower
        [UnitDefNames["armarad"].id] = 1,   -- Adv. radar tower
        [UnitDefNames["corarad"].id] = 1,   -- Adv. radar tower
        [UnitDefNames["armmark"].id] = 1,   -- Arm Radar Bot (Marky)
        [UnitDefNames["corvrad"].id] = 1,   -- Radar Vehicle (Informer)
    }

    function gadget:Initialize()
        -- eg: [UnitDefNames["armrad"].id] = unitDefs[UnitDefNames["armrad"].id].radarRadius,
        for thisId, _ in pairs(radarIDs) do
            radarIDs[thisId] = UnitDefs[thisId].seismicRadius --radarRadius
        end
    end

    function gadget:UnitFinished(unitID, unitDefID, teamID)
        local uDef = UnitDefs[unitDefID]
        --Spring.Echo("unit "..unitID.." stealth: ".. (tostring(uDef.stealth) or "nul")
        --        .." can cloak: ".. (tostring(uDef.canCloak) or "nul"))

        if radarIDs[unitDefID] then
            local seismicRadius = radarIDs[unitDefID]   -- Stealth Detection Range
            trackedRadars[unitID] = { allyID = spGetUnitAllyTeam(unitID), detectionSqrRad = (seismicRadius * seismicRadius) or 1 }
        end
        -- We won't track mines and units which are already stealth or can't cloak
        if uDef == nil or uDef.stealth or (not uDef.canCloak) then
            return end
        if mineIDs[unitDefID] then
            --Spring.AddUnitSeismicPing(unitID, 1)
            mines[unitID] = true
            --Spring.SetUnitNoSelect( unitID, true )    -- return
        end
        trackedUnits[unitID] = spGetUnitAllyTeam(unitID)
    end

    function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
        gadget:UnitFinished(unitID, unitDefID)
    end

    function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
        gadget:UnitFinished(unitID, unitDefID)
    end

    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        trackedUnits[unitID] = nil
        trackedRadars[unitID] = nil
        mines[unitID]=nil
    end

    function gadget:GameFrame(frame)
        -- Add all supported game-start spawned units (aka. commanders)
        if not initialized and frame > 0 then
            local allUnits = spGetAllUnits()
            for _, unitID in ipairs(allUnits) do
                local unitDefID = spGetUnitDefID(unitID)
                gadget:UnitFinished(unitID, unitDefID)
            end
            initialized = true
        end
        if frame % customPingRate < 0.001 then
            for unitID,_ in pairs(mines) do
                Spring.AddUnitSeismicPing(unitID, 1)
            end
        end
        if frame % updateRate < 0.001 then
            for unitID, unitAllyID in pairs(trackedUnits) do
                -- TODO: Check if unit is in range of a radar unit, if it does, set its stealth to FALSE
                local inRangeOfRadar = false
                if IsValidUnit(unitID) then
                    local unitX, unitY, unitZ = spGetUnitPosition(unitID)
                    for radarID, data in pairs(trackedRadars) do
                        if IsValidUnit(radarID) and data.allyID ~= unitAllyID then
                            local radarX, radarY, radarZ = spGetUnitPosition(radarID)
                            --local distance = diag(radarX-unitX, radarY-unitY, radarZ-unitZ)
                            local sqrDist = sqrDistance(radarX,radarZ,unitX,unitZ)
                            if sqrDist <= data.detectionSqrRad then
                                inRangeOfRadar = true
                            end
                        end
                    end
                end
                if not inRangeOfRadar then
                    --Spring.Echo("UnitID: "..unitID.." stealth = "..(tostring(spGetUnitIsCloaked(unitID)) or "nil"))
                    spSetUnitStealth(unitID, spGetUnitIsCloaked(unitID))
                else
                    --Spring.Echo("UnitID: "..unitID.." de-stealthed for being in range of enemy radar!")
                    spSetUnitStealth(unitID, false)
                end
            end
        end
    end

else
-----------------
---- UNSYNCED
-----------------

--local spGetMouseState = Spring.GetMouseState
--local spTraceScreenRay = Spring.TraceScreenRay
--local spAreTeamsAllied = Spring.AreTeamsAllied
--local spGetUnitTeam = Spring.GetUnitTeam
--local spGetUnitDefID = Spring.GetUnitDefID
--local spGetSelectedUnits = Spring.GetSelectedUnits
--local CMD_CAPTURE = CMD.CAPTURE
--
--local strUnit = "unit"
--
--local geothermalsDefIDs = {
--    [UnitDefNames["armgeo"].id] = true,
--    [UnitDefNames["amgeo"].id] = true,
--    [UnitDefNames["armgmm"].id] = true,
--}
--
--function gadget:DefaultCommand()
--    local function isGeothermal(unitDefID)
--        return geothermalsDefIDs[unitDefID]
--    end
--    local mx, my = spGetMouseState()
--    local s, targetID = spTraceScreenRay(mx, my)
--    if s ~= strUnit then
--        return false end
--
--    --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
--    --    return false
--    --end
--
--    -- Only proceed if target is one of the geothermal variations
--    local targetDefID = spGetUnitDefID(targetID)
--    if not isGeothermal(targetDefID) then
--        return false end
--
--    -- If any of the selected units is a commander, default to 'capture'
--    local sUnits = spGetSelectedUnits()
--    for i=1,#sUnits do
--        local unitID = sUnits[i]
--        --TODO: Should become `all capture-enabled units` (with the upgrade)
--        if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
--            return CMD_CAPTURE
--        end
--    end
--    return false
--end

end
