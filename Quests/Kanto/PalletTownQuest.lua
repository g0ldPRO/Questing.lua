-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'PalletTown'
local description = 'from PalletTown to Route 1'

local dialogs = {
	mom = Dialog:new({
		"Remember that I love you", -- REMEMBER THAT, OKAY?!
		"glad that you dropped by"
	}),
	oak = Dialog:new({
		"but you can have one",
		"which pokemon do you want"
	}),
	bulbasaur = Dialog:new({
		"grass type Pokemon Bulbasaur",
	}),
	charmander = Dialog:new({
		"fire type Pokemon Charmander",
	}),
	squirtle = Dialog:new({
		"water type Pokemon Squirtle",
	})
}

local PalletTownQuest = Quest:new()
function PalletTownQuest:new()
	return Quest.new(PalletTownQuest, name, description, dialogs)
end

function PalletTownQuest:isDoable()
	local mapName = sys.removeCharacter(getMapName(), ' ')
	if not hasItem("Boulder Badge") and self[mapName] then
		return true
	end
	return false
end

function PalletTownQuest:isDone()
	return getMapName() == "Route 1"
end

function PalletTownQuest:PlayerBedroomPallet()
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

function PalletTownQuest:PlayerHousePallet()
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

function PalletTownQuest:PalletTown()
	if getTeamSize() == 0 then
		return moveToMap("Oaks Lab")
	elseif not hasItem("Pokeball") then
		return moveToMap("Player House Pallet")
	else
		if isNpcVisible("#133") then
			return talkToNpc("#133")
		elseif isNpcVisible("Jackson") then
			return talkToNpc("Jackson")
		else
			return moveToMap("Route 1")
		end
	end
end

function PalletTownQuest:OaksLab()
	if getTeamSize() == 0 then
		if self.dialogs.oak.state == false then
			return talkToNpcOnCell(7,4) -- Oak
		else
			if KANTO_STARTER_ID == 1 then
				return talkToNpcOnCell(9,6)  -- bulbasaur
			elseif KANTO_STARTER_ID == 2 then
				return talkToNpcOnCell(10,6) -- charmander
			elseif KANTO_STARTER_ID == 3 then
				return talkToNpcOnCell(11,6) -- squirtle
			elseif KANTO_STARTER_ID == 4 then
				if not self.dialogs.bulbasaur.state then
					pushDialogAnswer(2)
					return talkToNpcOnCell(9,6)  -- bulbasaur
				elseif not self.dialogs.charmander.state then
					pushDialogAnswer(2)
					return talkToNpcOnCell(10,6) -- charmander
				elseif not self.dialogs.squirtle.state then
					pushDialogAnswer(2)
					return talkToNpcOnCell(11,6) -- squirtle
				else
					return talkToNpcOnCell(9,2) -- pikachu
				end
			else
				fatal("undefined KANTO_STARTER_ID")
			end
		end
	else
		if not hasItem("Pokedex") then
			return talkToNpcOnCell(7,4) -- Oak
		else
			sys.todo("no executed because of the isDoable()")
			return moveToMap("Link")
		end
	end
end

return PalletTownQuest
