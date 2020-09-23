--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Commander Blast",
    desc      = "Spawns commander blast CEG according to skillclass, adds EMP explosion",
    author    = "Bluestone, updated by MaDDoX",
    date      = "June 2014",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false, --true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
	return false
end


local COMMANDER_EXPLOSION = "COMMANDER_EXPLOSION"
local COMMANDER_EXPLOSION_YELLOW = "COMMANDER_EXPLOSION_YELLOW"
local COMMANDER_EXPLOSION_BLUE = "COMMANDER_EXPLOSION_BLUE"

local COM_BLAST = WeaponDefNames['commander_blast'].id
local COM_BLAST2 = WeaponDefNames['commander_blast2'].id
local COM_EMPTRIGGER = WeaponDefNames['commander_emptrigger'].id

local spGetUnitRulesParam = Spring.GetUnitRulesParam

-- MaDDoX: Added Commanders level 2 through 4 to list
local COMMANDER = {
  [UnitDefNames["corcom"].id] = true,
  [UnitDefNames["corcom1"].id] = true,
  [UnitDefNames["corcom2"].id] = true,
  [UnitDefNames["corcom3"].id] = true,
  [UnitDefNames["corcom4"].id] = true,
  [UnitDefNames["armcom"].id] = true,
  [UnitDefNames["armcom1"].id] = true,
  [UnitDefNames["armcom2"].id] = true,
  [UnitDefNames["armcom3"].id] = true,
  [UnitDefNames["armcom4"].id] = true,
}

--local METEOR_EXPLOSION = WeaponDefNames["meteor_weapon"].id

local commanderExplosionEMPparams = {
                                    --damage = { default=999999, paralyzeDamageTime = 20 },
                                    weaponDef = COM_EMPTRIGGER,
                                    hitUnit = 1,
                                    hitFeature = 1,
                                    craterAreaOfEffect = 50,
                                    damageAreaOfEffect = 720,
                                    edgeEffectiveness = 1,
                                    explosionSpeed = 900,
                                    impactOnly = false,
                                    ignoreOwner = false,
                                    damageGround = true,
                                    }

local teamCEG = {} --teamCEG[tID] = cegID of commander blast for that team

function gadget:Initialize()
    -- give each team the CEG corresponding to the player with the lowest skillClass in that team
    local gaiaTeamID = Spring.GetGaiaTeamID()
    local teamList = Spring.GetTeamList()
    for _,tID in pairs(teamList) do
        if tID==gaiaTeamID then
            teamCEG[tID] = COMMANDER_EXPLOSION
        else
            local playerList = Spring.GetPlayerList(tID)
            local teamSkillClass = 5
            for _,pID in pairs(playerList) do
                local customtable = select(10, Spring.GetPlayerInfo(pID))
                if type(customtable) == "table" then
                    local skillClass = customtable.skillclass -- 1 (1st), 2 (top5), 3 (top10), 4 (top20), 5 (other)
                    teamSkillClass = math.min(teamSkillClass, skillClass or 5)
                end
            end
            if teamSkillClass >= 5 then
                teamCEG[tID] = COMMANDER_EXPLOSION
            elseif teamSkillClass >= 3 then
                teamCEG[tID] = COMMANDER_EXPLOSION_YELLOW
            else
                teamCEG[tID] = COMMANDER_EXPLOSION_BLUE
            end
        end    
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
    if not COMMANDER[unitDefID] then return end

    local x,y,z = Spring.GetUnitBasePosition(unitID)
    -- If it was simply morphed into => No explosion FX, just "level up" fx.
    if spGetUnitRulesParam(unitID, "justmorphed") == 1 then
        Spring.SpawnCEG("commander-levelup", x,y,z, 0,0,0, 0, 0)
        return
    end
    -- If it was actually killed/selfD-ed, spawn CEG and EMP explosion
    Spring.SpawnCEG(teamCEG[teamID], x,y,z, 0,0,0, 0, 0)

    --This will be intercepted by UnitDamaged to actually apply damage
    Spring.SpawnExplosion (x,y,z, 0, 0, 0, commanderExplosionEMPparams)
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, attackerID, attackerDefID, attackerTeam)
    if (weaponDefID ~= COM_EMPTRIGGER) then --and Spring.ValidUnitID(attackerID)
        return end
    --unitID, damage, paralyze = 0, attackerID = -1, weaponID = -1
    Spring.AddUnitDamage ( unitID, math.huge, 17, attackerID, WeaponDefNames['armcom_empexplosion'].id )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Enable Weapon?
--Spring.UnitWeaponFire(unitID, WeaponDefNames['commanderexplosionemp'].id)
