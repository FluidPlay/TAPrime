function gadget:GetInfo()
  return {
    name      = "Sinking Ship",
    desc      = "Makes sinking ships go down faster",
    author    = "MaDDoX",
    date      = "Sep 2 2020",
    license   = "PD",
    layer     = 1000,
    enabled   = true,
  }
end

---TODO: Enhancement: Make the feature velocity slowdown along time (check plane_freeze as a reference)
     
if not gadgetHandler:IsSyncedCode() then
  return
end

local damping = 0.2
local sinkingMult = 4   -- currently not working, apparently an engine bug

local validFeatureDefID = {}

function gadget:Initialize()
    --- Currently Unused. Could be used to filter out valid FeatureDefIDs for the sink-damping effect
    --for i = 1, #FeatureDefs do
    --    local fdef = FeatureDefs[i]
    --    if fdef.customParams and fdef.customParams.tedclass and fdef.customParams.tedclass == "ship" then
    --        validFeatureDefID[i] = true
    --    end
    --end
    -- Exclusion List (if any)
	--sinkable[UnitDefNames['armpt'].id] = false
end

function gadget:FeatureCreated (featureID)
    --if validFeatureDefID[spGetFeatureDefID(featureID)] then

    local pos, rot, vel = {}, {}, {}
    pos.x, pos.y, pos.z = Spring.GetFeaturePosition( featureID )
    vel.x, vel.y, vel.z = Spring.GetFeatureVelocity(featureID)
    rot.x, rot.y, rot.z = Spring.GetFeatureRotation(featureID) --> nil | number pitch, number yaw, number roll

    Spring.SetFeaturePhysics( featureID, pos.x,pos.y,pos.z, vel.x * damping, vel.y * sinkingMult, vel.z * damping,
            rot.x, rot.y, rot.z) --, 0, 0, 0 ) --number dragx, number dragy, number dragz,
end

