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
local unitsToEdit = { [UnitDefNames.armllt.id] = 13,
                      [UnitDefNames.corllt.id] = 13,
                      [UnitDefNames.armbeamer.id] = 13,
                      [UnitDefNames.corhllt.id] = 13,
                      [UnitDefNames.armamex.id] = 13,
                      [UnitDefNames.corexp.id] = 13,
                      [UnitDefNames.armhlt.id] = 13,
                      [UnitDefNames.corhlt.id] = 13,
                      [UnitDefNames.armdeva.id] = 13,
                      [UnitDefNames.corshred.id] = 13,
                      [UnitDefNames.corrl.id] = 13,
                      [UnitDefNames.armrl.id] = 13,
                      --[UnitDefNames.armflak.id] = 13,
                      [UnitDefNames.corrad.id] = 15,    -- Model bugfix
                      [UnitDefNames.armcir.id] = 13,
                      [UnitDefNames.corerad.id] = 13,
                      [UnitDefNames.armmercury.id] = 13,
                      [UnitDefNames.corscreamer.id] = 13,
                      [UnitDefNames.armpw.id] = 15,
                      [UnitDefNames.corak.id] = 15,
                      [UnitDefNames.armoutpost.id] = 13, [UnitDefNames.armoutpost2.id] = 13, [UnitDefNames.armoutpost3.id] = 15, [UnitDefNames.armoutpost4.id] = 15,
                      [UnitDefNames.coroutpost.id] = 13, [UnitDefNames.coroutpost2.id] = 13, [UnitDefNames.coroutpost3.id] = 15, [UnitDefNames.coroutpost4.id] = 15,
                      [UnitDefNames.armtech.id] = 13, [UnitDefNames.armtech1.id] = 13, [UnitDefNames.armtech2.id] = 13, [UnitDefNames.armtech3.id] = 15, [UnitDefNames.armtech4.id] = 15,
                      [UnitDefNames.cortech.id] = 13, [UnitDefNames.armtech1.id] = 13, [UnitDefNames.cortech2.id] = 13, [UnitDefNames.cortech3.id] = 15, [UnitDefNames.cortech4.id] = 15,
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

        local _, bpy, _, mpx, mpy, mpz, apx, _, apz = Spring.GetUnitPosition (unitID, true, true)
        --Spring.Echo("Created unit positions: ".. bpy, mpx, mpy, mpz, apx, apz.." new Y: "..bpy+tonumber(unitsToEdit[unitDefID]))

        Spring.SetUnitMidAndAimPos(unitID, mpx, mpy, mpz, apx, bpy+tonumber(unitsToEdit[unitDefID]), apz, false)

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