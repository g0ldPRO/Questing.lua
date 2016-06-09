-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Start'
local description = 'from Start to Pokedex'

local dialogs = {
	mom = Dialog:new({
		"Remember that I love you",
		"glad that you dropped by"
	}),
	oak = Dialog:new({
		"but you can have one",
		"which pokemon do you want"
	})
}

local StartQuest = Quest:new()
function StartQuest:new()
	local o = Quest.new(StartQuest, name, description, dialogs)
	-- setmetatable(o, self)
	-- self.__index     = self
	o.maps = {
		["Start"]                 = StartQuest.Start,
		["Player Bedroom Pallet"] = StartQuest.PlayerBedroomPallet,
		["Player House Pallet"]   = StartQuest.PlayerHousePallet,
		["Pallet Town"]           = StartQuest.PalletTown,
		["Oaks Lab"]              = StartQuest.OaksLab
	}
	return o
end

function StartQuest:isDoable()
	sys.todo("invalid for Johto: check the zones")
	if not hasItem("Pokedex") then
		return true
	end
	return false
end

function StartQuest:Start()
	if isNpcOnCell(21,38) then
		return talkToNpcOnCell(21,38)
	end
	return moveToCell(26,87)
end

function StartQuest:PlayerBedroomPallet()
	if getTeamSize() == 0 or hasItem("Pokeball") then
		return moveToMap("Player House Pallet")
	else
		if isNpcOnCell(7,3) then
			return talkToNpcOnCell(7,3)
		elseif isNpcOnCell(6,3) then
			return talkToNpcOnCell(6,3)
		else
			assert(false, "No Pokeball in 'Player Bedroom Pallet' nor in bag")
		end
	end
end

function StartQuest:PlayerHousePallet()
	if getTeamSize() == 0 or hasItem("Pokeball") then
		return moveToMap("Link")
	else
		if self.dialogs.mom.state == false then
			return talkToNpcOnCell(7,6)
		else
			return moveToMap("Player Bedroom Pallet")
		end
	end
end

function StartQuest:PalletTown()
	if getTeamSize() == 0 then
		return moveToMap("Oaks Lab")
	elseif hasItem("Pokeball") == false then
		return moveToMap("Player House Pallet")
	else
		if npcExists("#133") then
			return talkToNpc("#133")
		elseif npcExists("Jackson") then
			return talkToNpc("Jackson")
		else
			return moveToMap("Route 1")
		end
	end
end

function StartQuest:OaksLab()
	if getTeamSize() == 0 then
		if self.dialogs.oak.state == false then
			log(self.dialogs.oak.state)
			return talkToNpcOnCell(7,4) -- Oak
		else
			if KANTO_STARTER_ID == 1 then
				return talkToNpcOnCell(9,6)  -- bulbasaur
			elseif KANTO_STARTER_ID == 2 then
				return talkToNpcOnCell(10,6) -- charmander
			elseif KANTO_STARTER_ID == 3 then
				return talkToNpcOnCell(11,6) -- squirtle
			elseif KANTO_STARTER_ID == 4 then
				fatal("Missing Pikachu coordinates, help appreciated")
				-- return talkToNpcOnCell(?,?) -- pikachu
			else
				fatal("undefined KANTO_STARTER_ID" )
			end
		end
	else
		if not hasItem("Pokedex") then
			return talkToNpcOnCell(7,4) -- Oak
		else
			return moveToMap("Link")
		end
	end
end

function StartQuest:dialog(message)
	if self.dialogs == nil then
		return false
	end
	for _, dialog in pairs(self.dialogs) do
		if dialog:messageMatch(message) then
			dialog.state = true
			return true
		end
	end
	return false
end

return StartQuest
