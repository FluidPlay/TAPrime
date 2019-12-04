--
-- Created by MaDDoX
-- Date: 23/08/17
-- Nice snippet from GoogleFrog at: https://springrts.com/phpbb/viewtopic.php?t=27268
--
function widget:GetInfo()
	return {
		name      = "Extra Console Commands",
		desc      = "Adds 'Restart' and 'Costmatch' commands to console",
		author    = "MaDDoX",
		date      = "Sep 20, 2017",
		license   = "GNU GPL, v2 or later",
		layer     = 500,
		enabled   = true, --  loaded by default?
        handler   = true,   -- Allows this to run 'SendCommands'
	}
end

local startscript = [[
[GAME]
{
	MapName=DeltaSiegeDry;
	GameType=Total Annihilation Prime V0.3;
	IsHost=1;
	[PLAYER0]
	{
		Team=0;
	}
	[TEAM0]
	{
		TeamLeader=0;
		AllyTeam=0;
	}
	[ALLYTEAM0]
	{
	}
}
]]

function Costmatch(command)
	--command:sub(6)
	-- Multi-word commands parsed below
	-- eg.: 		/costmatch 10 	 armpw corak -- outputs: 8 corak ~= 10 armpw
	-- default eg.: /costmatch armpw corak 		 -- outputs: 1 armpw = 0.8 corak
	local i = 1 -- word Index
	local qty, udefid1, udefid2
	local default = false
	local is_int = function(n)
		return (type(n) == "number") and (math.floor(n) == n)
	end
	for w in command:gmatch("%S+") do
		if i == 2 then
			if not is_int(tonumber(w)) then --truly a string, use default syntax
				qty = 1
				udefid1 = w
				default = true
			else
				qty = tonumber(w)
			end
		elseif i == 3 then
			if type(w) ~= nil then
				if default then
					udefid2 = w
				else
					udefid1 = w
				end
			else
				Spring.Echo("costmatch: wrong argument type")
			end
		elseif i == 4 then
			if not default then --and type(w)~=nil
				if type(w) ~= nil then
					udefid2 = w
				else
					Spring.Echo("costmatch: wrong argument type")
				end
			end
		end
		i = i + 1
	end
	if i > 5 then
		Spring.Echo ("costmatch(2): too many params. Eg.: /costmatch 10 armpw corak")
		return
	end
	--Spring.Echo(qty.." "..udefid1.." "..udefid2)
	local udef1 = UnitDefNames[udefid1]
	local udef2 = UnitDefNames[udefid2]
	if udef1 ~= nil and udef2 ~= nil then
		local udef1mcost, udef2mcost = udef1.metalCost, udef2.metalCost
		local function checkGroupSize(udef, mcost)
			if udef.customParams and udef.customParams.groupdef__size then
				local udefgroupSize = tonumber(udef.customParams.groupdef__size)
				if udefgroupSize and udefgroupSize > 1 then
					mcost = mcost / udefgroupSize
				end
			end
			return mcost
		end
		local function roundif (val, flag)
			return flag and math.round(val) or val
		end
		udef1mcost = checkGroupSize(udef1, udef1mcost)
		udef2mcost = checkGroupSize(udef2, udef2mcost)
		Spring.Echo("costmatch: ".. qty .." "..udefid1.." ~= "
				..roundif((qty * tonumber(udef1mcost) / tonumber(udef2mcost)), not default)
				.." "..udefid2)
	else
		Spring.Echo("cmd_extras(2): one of the udefs wasn't found")
	end
	return
end

function widget:TextCommand(command)
	if command == "restart" then
		Spring.Reload(startscript)
		return
	elseif command == "cheatall" then
		if not Spring.IsCheatingEnabled() then
			Spring.SendCommands("cheat")
			Spring.SendCommands("globallos")
			Spring.SendCommands("godmode")
		end
		return
    elseif command == "setmaxspeed" and Spring.IsCheatingEnabled() then
        Spring.SendCommands{"setmaxspeed 5"}
    elseif command == "setminspeed" and Spring.IsCheatingEnabled() then
        Spring.SendCommands("setmaxspeed 1")
	elseif (string.find(command, 'costmatch') == 1) then
		Costmatch(command)
		return
	end

end
