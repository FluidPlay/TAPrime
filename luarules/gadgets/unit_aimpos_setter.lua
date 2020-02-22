--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_aimpos_setter.lua
--  brief:   Sets the aim position of defenses, to prevent EMGs to shoot past DTs
--  author:  Breno "MaDDoX" Azevedo
--
--  Copyright (C) 2017.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- API Reference:
-- --        Spring.GetUnitPosition ( number unitID, [, boolean midPos [, boolean aimPos ] ] ) -> nil |
--            number bpx, number bpy, number bpz
--            [, number mpx, number mpy, number mpz ]
--            [, number apx, number apy, number apz ]

--        Spring.SetUnitMidAndAimPos ( number unitID, number mpx, number mpy, number mpz, number apx, number apy, number apz,
--              [, boolean relative] ) -> boolean success

function gadget:GetInfo()
    return {
        name      = "Unit Aim Position Setter",
        desc      = "Sets the aim position (target) of defenses",
        author    = "MaDDoX",
        date      = "Dec, 2017",
        license   = "GNU GPL, v2 or later",
        layer     = 200,
        enabled   = true
    }
end

local spSetUnitRadiusAndHeight = Spring.SetUnitRadiusAndHeight

--UnitDefID, vertical offset of aim position from base
local unitsToEdit = { [UnitDefNames.armllt.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corllt.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armbeamer.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corhllt.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armamex.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corexp.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armhlt.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corhlt.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armdeva.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corshred.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corrl.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armrl.id] = {x=0,y=13,z=0}, --//TEST
                      --[UnitDefNames.armflak.id] = 13,
                      [UnitDefNames.corrad.id] = {x=0,y=15,z=0},    -- Model bugfix
                      [UnitDefNames.armcir.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corerad.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armmercury.id] = {x=0,y=13,z=0},
                      [UnitDefNames.corscreamer.id] = {x=0,y=13,z=0},
                      [UnitDefNames.armpw.id] = {x=0,y=15,z=0},
                      [UnitDefNames.corak.id] = {x=0,y=15,z=0},
                      [UnitDefNames.armoutpost.id] = {x=0,y=13,z=0}, [UnitDefNames.armoutpost2.id] = {x=0,y=13,z=0}, [UnitDefNames.armoutpost3.id] = {x=0,y=15,z=0}, [UnitDefNames.armoutpost4.id] = {x=0,y=15,z=0},
                      [UnitDefNames.coroutpost.id] = {x=0,y=13,z=0}, [UnitDefNames.coroutpost2.id] = {x=0,y=13,z=0}, [UnitDefNames.coroutpost3.id] = {x=0,y=15,z=0}, [UnitDefNames.coroutpost4.id] = {x=0,y=15,z=0},
                      [UnitDefNames.armtech.id] = {x=0,y=13,z=0}, [UnitDefNames.armtech1.id] = {x=0,y=13,z=0}, [UnitDefNames.armtech2.id] = {x=0,y=13,z=0}, [UnitDefNames.armtech3.id] = {x=0,y=15,z=0}, [UnitDefNames.armtech4.id] = {x=0,y=15,z=0},
                      [UnitDefNames.cortech.id] = {x=0,y=13,z=0}, [UnitDefNames.armtech1.id] = {x=0,y=13,z=0}, [UnitDefNames.cortech2.id] = {x=0,y=13,z=0}, [UnitDefNames.cortech3.id] = {x=0,y=15,z=0}, [UnitDefNames.cortech4.id] = {x=0,y=15,z=0},
}

--SYNCED
if (gadgetHandler:IsSyncedCode()) then

    function gadget:Initialize()
        -- Add aim offset to starting unit, if needed
    end

    -- When a unit is completed
    function gadget:UnitFinished(unitID, unitDefID, teamID)
        if type(unitsToEdit[unitDefID]) == nil then
            return end
        --local modelradius = (UnitDefs[unitDefID]).customParams.modelradius
        --if modelradius then
        --    Spring.Echo("Found modelradius")
        --    spSetUnitRadiusAndHeight(unitID, 0.1,0.1) --, modelradius) --, mr.height
        --end
        -- Check if unitDefID is in the unitsToEdit table
        if unitsToEdit[unitDefID] == nil then
            return end

        local bpx, bpy, bpz, mpx, mpy, mpz, apx, apy, apz = Spring.GetUnitPosition (unitID, true, true) --base, middle, aim positions
        --Spring.Echo("Created unit positions: ".. bpy, mpx, mpy, mpz, apx, apz.." new Y: "..bpy+tonumber(unitsToEdit[unitDefID]))

        Spring.SetUnitMidAndAimPos(unitID, bpx, mpy, bpz, --mpx, mpz
                bpx+tonumber(unitsToEdit[unitDefID].x),
                bpy+tonumber(unitsToEdit[unitDefID].y), --bpy, since offset is from base
                bpz+tonumber(unitsToEdit[unitDefID].z), false)

    end

else -- UNSYNCED

--    -- Called at the moment the unit is created (in production/nanoframe)
--    function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
--        --Spring.Echo(" unit Def ID: " .. unitDefID)
--        local unitDef = UnitDefs[unitDefID]
--        -- Only mobile units can't be assisted -- TODO: Add defenses too
--        --Spring.Echo((unitDef.name or " null ").. " is building? " ..tostring(unitDef.isBuilding) or " null ")
--        if unitDef.isBuilding == false then
--            unitsBeingBuilt[unitID] = unitDefID
--        end
--    end
--
--    -- When a unit is completed
--    function gadget:UnitFinished(unitID, unitDefID, teamID)
--        unitsBeingBuilt[unitID] = null
--    end

end