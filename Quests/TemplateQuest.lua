-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

--[[
	This is a template file to create your own Quest.
	This file is made for you. If anything is unclear, do not hesitate to
	contact me through:
		- g0ld@tuta.io
		- proshine-bot.ml
		- discord.gg/0t8HE2IMuqUTour9
		
	To add your quest to the Questing script you need to edit QuestManager.lua.
--]]

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

-- Avoid using only the name of the map since multiple quests could happen on
-- the same map
local name        = 'Name of the Quest'
local description = 'from there to here, you should also now that and this'
-- The level the pokemon need to reach while farming
-- This level will increase by one any time you black out
local level       = 10

-- When a dialog contains one of those strings, the state variable of the
-- created instance will be set to true.
-- You can access it with: dialogs.aDialogInstance.state == true
local dialogs = {
	aDialogInstance = Dialog:new({
		"This is a dialog you can see in game",
		"And another one. It works only with game dialogs, not chat or popup",
		"e" -- would match any dialog with a 'e' in it
	})
}

-- This part is always the same for every script.
-- This is the constructor of the TemplateQuest class, inheriting from Quest.
-- All The functions of Quest.lua can be used with TemplateQuest.
local TemplateQuest = Quest:new()
function TemplateQuest:new()
	return Quest.new(TemplateQuest, name, description, level, dialogs)
end

-- If this function return true, the Quest will start.
-- self:hasMap() will check if this quest uses the map we are currently on.
-- See bellow how we add a map to the Quest
-- You should never assume that being on a map is enough to start a quest,
-- multiple quests can happen on the same map, always check something else at
-- the same time.
function TemplateQuest:isDoable()
	if not hasItem("Boulder Badge") and self:hasMap() then
		return true
	end
	return false
end

-- If you do not define this function, the Questing script will call the
-- default function from Quest.lua that simply returns: self:isDoable == false
-- Check it!
function TemplateQuest:isDone()
	return getMapName() == "Route 2"
end

--[[
	Adding Maps
	
	A Quest is divided by maps. Anytime the onPathAction is executed, the
	function matching the map name will be called.
	To write a function matching a map name, simply write the name of the map
	and remove the spaces and dots.
	For instance, the map "Player House Pallet" uses the function:
		function TemplateQuest:PlayerHousePallet() end
		
	This behaviour can be changed by overloading the Quest:path() function.
--]]

-- The following is an example of maps functions from ViridianSchoolQuest.lua

function TemplateQuest:PlayerBedroomPallet()
	return moveToMap("Player House Pallet")
end

function TemplateQuest:PlayerHousePallet()
	return moveToMap("Player Bedroom Pallet")
end

function TemplateQuest:PalletTown()
	return moveToMap("Route 1")
end

function TemplateQuest:Route1()
	if getTeamSize() == 1 and getPokemonHealthPercent(1) < 50 then
		if useItemOnPokemon("Potion", 1) then
			return true
		end
	end
	return moveToMap("Route 1 Stop House")
end

function TemplateQuest:Route1StopHouse()
	return moveToMap("Viridian City")
end

-- a simple method to divide our code and avoid duplication
function TemplateQuest:isReadyForJackson()
	if getTeamSize() >= 2 and game.minTeamLevel() >= 8 then
		return true
	end
	return false
end

function TemplateQuest:ViridianCity()
	if not game.isTeamFullyHealed()
		or self.registeredPokecenter ~= "Pokecenter Viridian" then
		return moveToMap("Pokecenter Viridian")
	elseif getItemQuantity("Pokeball") < 50 and getMoney() >= 200 then
		return moveToMap("Viridian Pokemart")
	elseif not self.dialogs.jacksonDefeated.state
		and self:isReadyForJackson() then
		return moveToMap("Viridian City School")
	elseif not self:isReadyForJackson() then
		return moveToMap("Route 22")
	else
		return moveToMap("Route 2")
	end
end


-- We call the pokecenter mehod of the Quest class that will heal the pokemon
-- if needed and leave the pokecenter
function TemplateQuest:PokecenterViridian()
	self:pokecenter("Viridian City") -- we still need to pass the exit map
end

-- Example of Pokemart script.
-- This will likely be improved in futur versions.
-- Currently there is no method to facilate the buy of items.
function TemplateQuest:ViridianPokemart()
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

-- End of maps functions

-- This is necessary for the require keyword to catch a value
-- See QuestManager.lua
return TemplateQuest
