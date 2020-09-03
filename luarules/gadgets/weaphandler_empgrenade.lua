--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Weapon Handler - EMP Grenade",
    desc      = "Spawns EMP explosion and effects at EMP Grenade impact site",
    author    = "Bluestone, updated by MaDDoX",
    date      = "June 2014",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local emp_damage = 500

local EMPGRENADE_TRIGGER = WeaponDefNames['armpw_grenade'].id

--local EMPgrenadeExplosionParams = {
--                                    --damage = { default=999999, paralyzeDamageTime = 20 },
--                                    weaponDef = EMPGRENADE_TRIGGER,
--                                    hitUnit = 1,
--                                    hitFeature = 1,
--                                    craterAreaOfEffect = 50,
--                                    damageAreaOfEffect = 720,
--                                    edgeEffectiveness = 1,
--                                    explosionSpeed = 900,
--                                    impactOnly = false,
--                                    ignoreOwner = false,
--                                    damageGround = true,
--                                    }

local teamCEG = {} --teamCEG[tID] = cegID of commander blast for that team

function gadget:Initialize()
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
    --local x,y,z = Spring.GetUnitBasePosition(unitID)
    -- If it was actually killed/selfD-ed, spawn CEG and EMP explosion
    --Spring.SpawnCEG(teamCEG[teamID], x,y,z, 0,0,0, 0, 0)

    ----This will be intercepted by UnitDamaged to actually apply damage
    --Spring.SpawnExplosion (x,y,z, 0, 0, 0, EMPgrenadeExplosionParams)
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, attackerID, attackerDefID, attackerTeam)
    if (weaponDefID ~= EMPGRENADE_TRIGGER) then --and Spring.ValidUnitID(attackerID)
        return end
    --unitID, damage, paralyze = 0, attackerID = -1, weaponID = -1
    Spring.AddUnitDamage ( unitID, emp_damage, 17, attackerID, WeaponDefNames['armcom_empexplosion'].id )
end

