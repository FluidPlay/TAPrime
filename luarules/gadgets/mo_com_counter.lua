function gadget:GetInfo()
  return {
    name      = "Com Counter",
    desc      = "Tells each team the total number of commanders alive in enemy allyteams",
    author    = "Bluestone",
    date      = "08/03/2014",
    license   = "Horses",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

local function isnumber(v)
	return (type(v)=="number")
end

local enabled = (tostring(Spring.GetModOptions().mo_enemycomcount) == "1") or false
if not enabled then 
  return false
end

if not (gadgetHandler:IsSyncedCode()) then --synced only
	return false
end

local spGetTeamList = Spring.GetTeamList
local spGetTeamUnitDefCount = Spring.GetTeamUnitDefCount
local spSetTeamRulesParam = Spring.GetTeamRulesParam
local spGetTeamInfo = Spring.GetTeamInfo

local teamComs = {} -- format is enemyComs[teamID] = total # of coms in enemy teams

-- This could be improved by initializing the array automatically, with the isCom method
local comDefIDs = { [1] = { id = UnitDefNames.armcom.id },
                    [2] = { id = UnitDefNames.armcom2.id },
                    [3] = { id = UnitDefNames.armcom3.id },
                    [4] = { id = UnitDefNames.armcom4.id },
                    [5] = { id = UnitDefNames.corcom.id },
                    [6] = { id = UnitDefNames.corcom2.id },
                    [7] = { id = UnitDefNames.corcom3.id },
                    [8] = { id = UnitDefNames.corcom4.id },}

local countChanged  = true 

function isCom(unitID,unitDefID)
	if not unitDefID and unitID then
		unitDefID =  Spring.GetUnitDefID(unitID)
	end
	if not unitDefID or not UnitDefs[unitDefID] or not UnitDefs[unitDefID].customParams then
		return false
	end
	return UnitDefs[unitDefID].customParams.iscommander ~= nil
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	-- record com creation
	if isCom(unitID) and not spGetUnitRulesParam(unitID, "morphedinto") then
		if not teamComs[teamID] then 
			teamComs[teamID] = 0
		end
		teamComs[teamID] = teamComs[teamID] + 1
		countChanged = true
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- record com death
	if isCom(unitID) and not spGetUnitRulesParam(unitID, "justmorphed") then
		if not teamComs[teamID] then 
			teamComs[teamID] = 0 --should never happen
		end
		teamComs[teamID] = teamComs[teamID] - 1
		countChanged = true
	end
end

-- TAP does not allow sharing to enemy, so no need to check Given, Taken, etc

local function CountCommanders(teamID)
	local count, teamComTypeCount = 0, nil
    for i, data in ipairs(comDefIDs) do
		teamComTypeCount = spGetTeamUnitDefCount(teamID, data.id)
		if isnumber(teamComTypeCount) then
			count = count + teamComTypeCount
		end
	end
	return count
end

local function ReCheck()
	-- occasionally, recheck just to make sure...
	local teamList = spGetTeamList()
	for _,teamID in pairs(teamList) do
		local newCount = CountCommanders(teamID) --Spring.GetTeamUnitDefCount(teamID, armcomDefID) + Spring.GetTeamUnitDefCount(teamID, corcomDefID)
		if newCount ~= teamComs[teamID] then
			countChanged = true
			teamComs[teamID] = newCount
		end
	end
end

function gadget:GameFrame(n)
	if n%30 < 0.001 then
		ReCheck()
	end

	if countChanged then
		UpdateCount()
		countChanged = false
	end
end

function UpdateCount()
    -- for each teamID, set a TeamRulesParam containing the # of coms in enemy allyteams
    for teamID,_ in pairs(teamComs) do
        local enemyComCount = 0
        local _,_,_,_,_,allyTeamID = spGetTeamInfo(teamID)
        for otherTeamID,val in pairs(teamComs) do -- count all coms in enemy teams, to get enemy allyteam com count
            local _,_,_,_,_,otherAllyTeamID = spGetTeamInfo(otherTeamID)
            if otherAllyTeamID ~= allyTeamID then
                enemyComCount = enemyComCount + teamComs[otherTeamID]
            end
        end
        spSetTeamRulesParam(teamID, "enemyComCount", enemyComCount, {private=true, allied=false})
    end
end

--function UpdateCount()
--	-- for each teamID, set a TeamRulesParam containing the # of coms in enemy allyteams
--	for teamID,_ in pairs(teamComs) do
--		local enemyComCount = 0
--		local _,_,_,_,_,allyTeamID = Spring.GetTeamInfo(teamID)
--		for otherTeamID,val in pairs(teamComs) do -- count all coms in enemy teams, to get enemy allyteam com count
--			local _,_,_,_,_,otherAllyTeamID = Spring.GetTeamInfo(otherTeamID)
--			if otherAllyTeamID ~= allyTeamID then
--				enemyComCount = enemyComCount + teamComs[otherTeamID]
--			end
--		end
----( number teamID, string paramName, number|string paramValue [, table losAccess] )
--		Spring.SetTeamRulesParam(teamID, "comcount", enemyComCount, {public=true})
--	end
--end
