function gadget:GetInfo()
    return {
        name = "Unit no-stuck after built",
        desc = "Disables unit collision for a couple seconds right after it's built, to prevent it from getting stuck in the factory",
        author = "MaDDoX",
        date = "2020",
        license = "Public Domain",
        layer = 0,
        enabled = false, --true, || Disabled, caused weird edge cases
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--local AirTransports = {
--    [UnitDefNames["armatlas"].id] = true,
--    [UnitDefNames["armdfly"].id] = true,
--    [UnitDefNames["corvalk"].id] = true,
--    [UnitDefNames["corseah"].id] = true,
--}

if not (gadgetHandler:IsSyncedCode()) then
    return end

local delay = 50 -- How many frames to keep the unit collision disabled
local trackedUnits = {} -- { [unitID]=(number)enableframe, .. }

--function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)

function gadget:UnitFinished(unitID, unitDefID, teamID)
    --Spring.Echo("Disabling collision for "..unitID)
    Spring.SetUnitBlocking(unitID, false, false, true)
    Spring.SetUnitNeutral(unitID, true)
    --isBlocking, isSolidObjectCollidable, isProjectileCollidable, isRaySegmentCollidable, crushable, blockEnemyPushing, blockHeightChanges
    trackedUnits[unitID] = Spring.GetGameFrame() + delay
end

function gadget:GameFrame(n)
    for unitID, frame in pairs(trackedUnits) do
        if n >= frame then
            --Spring.Echo("Enabling collision for "..unitID)
            Spring.SetUnitBlocking(unitID, true, true, true, true,
                    true, true, true)
            Spring.SetUnitNeutral(unitID, false)
            trackedUnits[unitID]=nil
        end
    end
end

