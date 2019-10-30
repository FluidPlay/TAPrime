function widget:GetInfo()
    return {
        name      = "GUI - Draw Attack Minimum Range",
        desc      = "Draws minimum range rings",
        author    = "FLOZi (C. Lawrence), edited by MaDDoX",
        date      = "28/07/2013",
        license   = "GNU GPL v2",
        layer     = 10000,
        enabled   = true,
    }
end

-- localisations

-- OGL
local glBillboard	 		= gl.Billboard
local glColor 				= gl.Color
local glDrawGroundCircle 	= gl.DrawGroundCircle
local glTranslate			= gl.Translate
-- SyncedRead
local GetUnitPosition 		= Spring.GetUnitPosition
local GetUnitDefID			= Spring.GetUnitDefID
-- UnsyncedRead
local GetActiveCommand		= Spring.GetActiveCommand
local GetSelectedUnits		= Spring.GetSelectedUnits

local AttackRed = {1.0, 0.2, 0.2, 0.7}
local RingColor = { 0.3, 1.0, 0.3, 0.5} -- doesn't match engine for some reason so make less opaque

local minRanges = {} -- minRange[unitDefID] = {weapName = range, ...}
local buildRanges = {} -- buildRange[unitDefID] = minRange

function widget:Initialize()
    -- Cache ranges
    for unitDefID, unitDef in pairs(UnitDefs) do
        --local weapons = unitDef.weapons
        --for i = 1, #weapons do
        --    local weaponDef = WeaponDefs[weapons[i].weaponDef]
        --    local minRange = tonumber(weaponDef.customParams.minrange) or nil
        --    if minRange then
        --        if not minRanges[unitDefID] then
        --            minRanges[unitDefID] = {}
        --        end
        --        minRanges[unitDefID][weaponDef.name] = minRange
        --    end
        --end
        local minrange = unitDef.customParams.minrange or nil
        if minrange then
            minRanges[unitDefID] = minrange
        end
    end
end

function widget:DrawWorldPreUnit()
    if select(4, GetActiveCommand()) ~= "Attack" then
        return end
    for _,unitID in ipairs(GetSelectedUnits()) do
        local unitDefID = GetUnitDefID(unitID)

        glColor(RingColor)
        local rangeToDraw = minRanges[unitDefID]
        if rangeToDraw then
            local x, y, z = GetUnitPosition(unitID)
            --for weapName, radius in pairs(rangeToDraw) do
                --Spring.Echo("Found Min range entry: "..(tostring(radius) or "nil"))
            gl.PushMatrix()
            glDrawGroundCircle(x,y,z, rangeToDraw, 24)
            glTranslate(x, y + 40, z + rangeToDraw - 40)
            glBillboard()
            --gl.Text("Min Range: " .. weapName, 0, 0, 24, "c")
            --btFont:Print("Min Range: " .. weapName, 0, 0, 24, "c")
            gl.PopMatrix()
            --end
        end
        --end
        glColor(1,1,1,1)
    end
end