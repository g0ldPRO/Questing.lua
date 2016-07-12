-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Rainbow Badge'
local description = 'Beat Erika + Get FreshWater for future quest'
local level = 33

local dialogs = {
	martElevatorFloor1 = Dialog:new({ 
		"the first floor"
	}),
	martElevatorFloor5 = Dialog:new({ 
		"the fifth floor"
	})
}

local RainbowBadgeQuest = Quest:new()

function RainbowBadgeQuest:new()
	local o = Quest.new(RainbowBadgeQuest, name, description, level, dialogs)
	o.pokemonId = 1
	return o
end

function RainbowBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("Soul Badge") then
		if getMapName() == "Lavender Town" then
			return false
		else
			return true
		end
	end
	return false
end

function RainbowBadgeQuest:isDone()
	if hasItem("Rainbow Badge") and getMapName() == "Lavender Town" then
		return true
	else
		return false
	end
end

function RainbowBadgeQuest:CeladonCity()
	if isNpcOnCell(21,51) and getPlayerX() == 21 and getPlayerY() == 50 and hasItem("Rainbow Badge") then --NPC: Trainer OP
		return talkToNpcOnCell(21,51)
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Celadon" then
		return moveToMap("Pokecenter Celadon")
	elseif not self:isTrainingOver() and not hasItem("Rainbow Badge") then
		return moveToMap("Route 7")
	elseif isNpcOnCell(54,14) then --Item: Great Ball
		return talkToNpcOnCell(54,14)
	elseif isNpcOnCell(46,49) then --NPC: Rocket Guy
		return talkToNpcOnCell(46,49)
	elseif isNpcOnCell(58,51) then --NPC: Rocket Guy
		return talkToNpcOnCell(58,51)
	elseif isNpcOnCell(50,55) then --Item: 5x Ultra Balls
		return talkToNpcOnCell(50,55)
	elseif not game.hasPokemonWithMove("Cut") then
		if pokemonId < getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end
	elseif not hasItem("Rainbow Badge") then
		return moveToMap("CeladonGym")
	elseif isNpcOnCell(14,42) then --NPC: Remove the Guards
		return talkToNpcOnCell(14,42)
	elseif not hasItem("Fresh Water") then -- Buy Fresh Water for Future Quest (Saffron Guard)
		return moveToMap("Celadon Mart 1")
	else
		return moveToMap("Route 7")
	end
end

function RainbowBadgeQuest:PokecenterCeladon()
	self:pokecenter("Celadon City")
end

function RainbowBadgeQuest:Route7()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Celadon" then
		return moveToMap("Celadon City")
	elseif hasItem("Rainbow Badge") and hasItem("Fresh Water") then
		return moveToMap("Underground House 3")
	elseif not self:isTrainingOver() and not hasItem("Rainbow Badge") then
		if not game.inRectangle(12,8,21,21) then
			return moveToCell(17,17)
		else
			return moveToGrass()
		end
	else
		return moveToMap("Celadon City")
	end
end

function RainbowBadgeQuest:CeladonGym()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Celadon" or not self:isTrainingOver() then
		return moveToMap("Celadon City")
	elseif not hasItem("Rainbow Badge") then
		talkToNpcOnCell(8,4) -- Erika
	else
		return moveToMap("Celadon City")
	end
end

function RainbowBadgeQuest:CeladonMart1()
	if not hasItem("Fresh Water") then
		return moveToMap("Celadon Mart Elevator")
	else
		return moveToMap("Celadon City")
	end
end

function RainbowBadgeQuest:CeladonMartElevator()
	if not hasItem("Fresh Water") then
		if not dialogs.martElevatorFloor5.state then
			pushDialogAnswer(5)
			return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor5.state = false
			return moveToCell(2,5)
		end
	else
		if not dialogs.martElevatorFloor1.state then
			pushDialogAnswer(1)
			return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor1.state = false
			return moveToCell(2,5)
		end
	end
end

function RainbowBadgeQuest:CeladonMart5()
	if not hasItem("Fresh Water") then
		return moveToMap("Celadon Mart 6")
	else
		return moveToMap("Celadon Mart Elevator")
	end
end

function RainbowBadgeQuest:CeladonMart6()
	if not hasItem("Fresh Water") then
		if not isShopOpen() then
			return talkToNpcOnCell(15, 7)
		else
			if getMoney() > 1000 then
				return buyItem("Fresh Water", 5)
			else
				return buyItem("Fresh Water",(getMoney()/200))
			end
		end
	else
		return moveToMap("Celadon Mart 5")
	end
end

function RainbowBadgeQuest:UndergroundHouse3()
	return moveToMap("Underground1")
end

function RainbowBadgeQuest:Underground1()
	return moveToMap("Underground House 4")
end

function RainbowBadgeQuest:UndergroundHouse4()
	return moveToMap("Route 8")
end

function RainbowBadgeQuest:Route8()
	return moveToMap("Lavender Town")
end

return RainbowBadgeQuest
