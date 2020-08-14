--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
    return {
        name      = "SFX - Tech Up",
        desc      = "Plays a sound notification when a Tech Center morph is Finished",
        author    = "MaDDoX",
        date      = "Aug 2020",
        license   = "GNU GPL, v2 or later",
        version   = 1,
        layer     = 5,
        enabled   = true  --  loaded by default?
    }
end

local txtcolor = "\255\240\200\86"

--function GetAllyTeamID(teamID)
--	local _,_,_,_,_,allyTeamID = Spring.GetTeamInfo(teamID)
--	return allyTeamID
--end
--
--function GetPlayerTeamID(playerID)
--	local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--	return allyTeam
--end
--
--function AllPlayers()
--	local players = Spring.GetPlayerList()
--	for ct, id in pairs(players) do
--		local _,_,spectate = Spring.GetPlayerInfo(id)
--		if spectate == true then players[ct] = nil end
--	end
--	return players
--end
--
--function AllUsers()
--	local players = Spring.GetPlayerList()
--	return players
--end
--
--function PlayersInAllyTeamID(allyTeamID)
--	local players = AllPlayers()
--	for ct, id in pairs(players) do
--		local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--		if allyTeam ~= allyTeamID then players[ct] = nil end
--	end
--	return players
--end
--
--function AllButAllyTeamID(allyTeamID)
--	local players = AllPlayers()
--	for ct, id in pairs(players) do
--		local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--		if allyTeam == allyTeamID then players[ct] = nil end
--	end
--	return players
--end
--
--function PlayersInTeamID(teamID)
--	local players = Spring.GetPlayerList(teamID)
--	return players
--end

if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")

local techCenters = {armtech1 = 1, armtech2 = 2, armtech3 = 3, armtech4 = 4,
                     cortech1 = 1, cortech2 = 2, cortech3 = 3, cortech4 = 4}

function gadget:UnitFinished(unitID, unitDefID, teamID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil then
        return end
    if not techCenters[unitDef.name] then
        return end
    local newTier = tostring(techCenters[unitDef.name])
    --TODO: Check if tech was already unlocked, only play sound if it wasn't
    if IsValidUnit(unitID) then
        local team = Spring.GetUnitTeam(unitID)
        Spring.SendMessageToTeam(team, txtcolor .."------------------------------------------------")
        Spring.SendMessageToTeam(team, txtcolor .."You've reached Tech Level "..newTier)
        Spring.SendMessageToTeam(team, txtcolor .."------------------------------------------------")
        Spring.PlaySoundFile("sounds/ui/achievement.wav",0.75)
    end
end
	

