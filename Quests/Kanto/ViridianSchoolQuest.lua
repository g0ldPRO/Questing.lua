-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Viridian School'
local description = 'from Route 1 to Route 2'

local dialogs = {
	jacksonDefeated = Dialog:new({
		"You will not take my spot!",
		"Sorry, the young boy there doesn't want to give his spot, I'm truly sorry..."
	})
}

local ViridianSchoolQuest = Quest:new()
function ViridianSchoolQuest:new()
	return Quest.new(ViridianSchoolQuest, name, description, 8, dialogs)
end

function ViridianSchoolQuest:isDoable()
	if not hasItem("Boulder Badge") and self:hasMap() then
		return true
	end
	return false
end

function ViridianSchoolQuest:isDone()
	return getMapName() == "Route 2"
end

-- necessary, in case of black out we come back to the bedroom
function ViridianSchoolQuest:PlayerBedroomPallet()
	return moveToMap("Player House Pallet")
end

function ViridianSchoolQuest:PlayerHousePallet()
	return moveToMap("Link")
end

function ViridianSchoolQuest:PalletTown()
	return moveToMap("Route 1")
end

function ViridianSchoolQuest:Route1()
	if self:needPokecenter() then
		if useItemOnPokemon("Potion", 1) then
			return true
		end
	end
	return moveToMap("Route 1 Stop House")
end

function ViridianSchoolQuest:Route1StopHouse()
	return moveToMap("Viridian City")
end

function ViridianSchoolQuest:isTrainingOver()
	if getTeamSize() >= 2 and game.minTeamLevel() >= self.level then
		return true
	end
	return false
end

function ViridianSchoolQuest:ViridianCity()
	if not game.isTeamFullyHealed()
		or self.registeredPokecenter ~= "Pokecenter Viridian" then
		return moveToMap("Pokecenter Viridian")
	elseif self:needPokemart() then
		return moveToMap("Viridian Pokemart")
	elseif not self.dialogs.jacksonDefeated.state and self:isTrainingOver() then
		return moveToMap("Viridian City School")
	elseif not self:isTrainingOver() then
		return moveToMap("Route 22")
	else
		return moveToMap("Route 2")
	end
end

function ViridianSchoolQuest:ViridianCitySchool()
	if self.dialogs.jacksonDefeated.state or not self:isTrainingOver() then
		return moveToMap("Viridian City")
	else
		return moveToMap("Viridian City School Underground")
	end
end

function ViridianSchoolQuest:ViridianCitySchoolUnderground()
	if self.dialogs.jacksonDefeated.state or not self:isTrainingOver() then
		return moveToMap("Viridian City School")
	elseif not isNpcVisible("Jackson") then
		self.dialogs.jacksonDefeated.state = true
		return moveToMap("Viridian City School")
	elseif isNpcOnCell(7,6) then
		return talkToNpcOnCell(7,6)
	else
		return talkToNpc("Jackson")
	end	
end

function ViridianSchoolQuest:Route22()
	if self:needPokecenter() then
		return moveToMap("Viridian City")
	elseif self:isTrainingOver() then
		return moveToMap("Viridian City")
	else
		return moveToGrass()
	end	
end

function ViridianSchoolQuest:PokecenterViridian()
	return self:pokecenter("Viridian City")
end

function ViridianSchoolQuest:ViridianPokemart()
	return self:pokemart("Viridian City")
end

return ViridianSchoolQuest
