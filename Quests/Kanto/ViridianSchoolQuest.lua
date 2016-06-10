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
	return Quest.new(ViridianSchoolQuest, name, description, dialogs)
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
	return moveToMap("Player Bedroom Pallet")
end

function ViridianSchoolQuest:PalletTown()
	return moveToMap("Route 1")
end

function ViridianSchoolQuest:Route1()
	if getTeamSize() == 1 and getPokemonHealthPercent(1) < 50 then
		if useItemOnPokemon("Potion", 1) then
			return true
		end
	end
	return moveToMap("Route 1 Stop House")
end

function ViridianSchoolQuest:Route1StopHouse()
	return moveToMap("Viridian City")
end

function ViridianSchoolQuest:isReadyForJackson()
	if getTeamSize() >= 2 and game.minTeamLevel() >= 8 then
		return true
	end
	return false
end

function ViridianSchoolQuest:ViridianCity()
	if not game.isTeamFullyHealed()
		or self.registeredPokecenter ~= "Pokecenter Viridian" then
		return moveToMap("Pokecenter Viridian")
	elseif getItemQuantity("Pokeball") < 50 and getMoney() >= 200 then
		return moveToMap("Viridian Pokemart")
	elseif not self.dialogs.jacksonDefeated.state and self:isReadyForJackson() then
		return moveToMap("Viridian City School")
	elseif not self:isReadyForJackson() then
		return moveToMap("Route 22")
	else
		return moveToMap("Route 2")
	end
end

function ViridianSchoolQuest:ViridianCitySchool()
	if self.dialogs.jacksonDefeated.state or not self.isReadyForJackson() then
		return moveToMap("Viridian City")
	else
		return moveToMap("Viridian City School Underground")
	end
end

function ViridianSchoolQuest:ViridianCitySchoolUnderground()
	if self.dialogs.jacksonDefeated.state or not self:isReadyForJackson() then
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

function ViridianSchoolQuest:needPokecenter()
	if (getTeamSize() == 1 and getPokemonHealthPercent(1) > 50)
		or (getUsablePokemonCount() > 1
		 -- else we would spend more time evolving the higher level ones
		and game.getUsablePokemonCountUnderLevel(8) > 0)
		then
		return false
	end
	return true
end

function ViridianSchoolQuest:Route22()
	if self:needPokecenter() then
		return moveToMap("Viridian City")
	elseif self:isReadyForJackson() then
		return moveToMap("Viridian City")
	else
		return moveToGrass()
	end	
end

--[[
redondant sub maps
--]]
function ViridianSchoolQuest:PokecenterViridian()
	self:pokecenter("Viridian City")
end

function ViridianSchoolQuest:ViridianPokemart()
	local pokeballCount = getItemQuantity("Pokeball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 50 then
		if not isShopOpen() then
			return talkToNpcOnCell(3,5)
		else
			local pokeballToBuy = 50 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
			return buyItem("Pokeball", pokeballToBuy)
		end
	else
		return moveToMap("Viridian City")
	end
end

return ViridianSchoolQuest
