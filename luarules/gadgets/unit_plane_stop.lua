function gadget:GetInfo()
    return {
        name      = "Plane Stop",
        desc      = "Fighters and Bombers set to flight mode freeze mid-air when stopped",
        author    = "MaDDoX",
        date      = "6 Dec 2019",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
    return
end

VFS.Include("gamedata/taptools.lua")

local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit
local SetUnitNeutral = Spring.SetUnitNeutral

local trackedUnits = {
    [UnitDefNames["armfig"].id] = true,
    [UnitDefNames["corveng"].id] = true,
    [UnitDefNames["armthund"].id] = true,
    [UnitDefNames["corshad"].id] = true,
    [UnitDefNames["armhawk"].id] = true,
    [UnitDefNames["corvamp"].id] = true,
    [UnitDefNames["armpnix"].id] = true,
    --[UnitDefNames["armaap"].id] = true,
    --[UnitDefNames["armplat"].id] = true
}

local planes = {}
local buildingUnits = {}

local CMD_STOP = CMD.STOP
local CMD_IDLEMODE = CMD.IDLEMODE

--TODO: Check if spawning (by group) fires UnitFinished, if not enable this
--function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
--end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    planes[unitID] = nil
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if trackedUnits[unitDefID] then
        planes[unitID] = true
        --GiveOrderToUnit(unitID, CMD.IDLEMODE, { planes[builderID].landAt }, { })
    end
end

local function isSetToFly(unitID)
    local cmdIdleModeId = spFindUnitCmdDesc(unitID, CMD_IDLEMODE)
    if not cmdIdleModeId then
        return false end
    local cmdIdleModeDesc = spGetUnitCmdDescs(unitID, cmdIdleModeId, cmdIdleModeId)[1]
    if istable(cmdIdleModeDesc.params) then
        return cmdIdleModeDesc.params[1] == "0"    -- If equal "0" ==> Fly
    else
        return false end
end

local function PauseFly(unitID)

end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if planes[unitID] then
        Spring.Echo("cmdID "..cmdID)
        if cmdID == CMD_STOP then --TODO: And flyState == fly
            if isSetToFly(unitID) then
                PauseFly(unitID)
            end
        end
    end
    return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--function gadget:GetInfo()
--    return {
--        name = "Zeppelin Physics",
--        desc = "Forces Zeppelin-type units to obey their cruisealt and prevents them from pitching",
--        author = "Анархид",
--        date = "2.2.2009",
--        license = "None",
--        layer = 50,
--        enabled = true
--    }
--end
--
--zeppelins={}
--zeppelin={}
--
----SYNCED
--if (gadgetHandler:IsSyncedCode()) then
--
--    function gadget:Initialize()
--        for id,unitDef in pairs(UnitDefs) do
--            if unitDef.myGravity == 0 and
--                    unitDef.maxElevator == 0 then
--                Spring.Echo(unitDef.name.." is a zeppelin with cruisealt "..unitDef.wantedHeight)
--                zeppelins[id]={
--                    pitch=unitDef.maxPitch,
--                    alt=unitDef.wantedHeight,
--                    name= unitDef.name,
--                }
--            end
--        end
--    end
--
--    function gadget:UnitCreated(UnitID, whatever)
--        local type=Spring.GetUnitDefID(UnitID);
--        if zeppelins[type] then
--            zeppelin[UnitID]=type
--        end
--    end
--
--    function gadget:UnitDestroyed(UnitID, whatever)
--        local type=Spring.GetUnitDefID(UnitID);
--        if zeppelins[type] then
--            zeppelin[UnitID]=nil
--        end
--    end
--
--    local function sign(num)
--        return num/math.abs(num)
--    end
--
--    function gadget:GameFrame(f)
--        if f%20<1 then
--            for zid,zepp in pairs(zeppelin) do
--                local x,y,z=Spring.GetUnitVectors(zid)
--                local ux, uy, uz= Spring.GetUnitPosition(zid)
--                local vx, vy, vz= Spring.GetUnitVelocity(zid)
--                local dx, dy, dz=Spring.GetUnitDirection(zid)
--                local altitude=uy-Spring.GetGroundHeight(ux,uz)
--                local wanted=zeppelins[zepp].alt
--                if math.abs(altitude-wanted)>10 then
--                    Spring.SetUnitVelocity(zid,vx,vy+sign(wanted-altitude),vz)
--                end
--
--                if dy>0 then
--                    local h=math.asin(-dx/math.sqrt(dx*dx+dz*dz))
--                    Spring.SetUnitRotation(zid,0,h,0)
--                end
--            end--for
--        end--iff
--    end--fn
--
--end--sync