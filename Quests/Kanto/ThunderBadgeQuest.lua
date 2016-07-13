-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Thunder Badge Quest'
local description = 'From Route 5 to Route 6'
local level       = 26



local dialogs = {
	psychicWadePart2 = Dialog:new({
		"You see, that was Lance, the Pokemon League Champion.",
		"hurry up and tell him that"
	}),
	surgeVision = Dialog:new({
		"Take the cruise, become stronger, and after that, come at me and let's have a zapping match!"
	});
	switchWrong = Dialog:new({
		"wrong switch",
		"have been reset"
	}),
	switchTrigger = Dialog:new({
		"have triggered the first switch"
	})
}

local ThunderBadgeQuest = Quest:new()

function ThunderBadgeQuest:new()
	o = Quest.new(ThunderBadgeQuest, name, description, level, dialogs)
	o.pokemonId = 1
	o.puzzle = {}
	o.firstSwitchFound     = false
	o.firstSwitchActivated = false
	o.firstSwitchX = 0
	o.firstSwitchY = 0
	o.currentSwitchX = SWITCHES_START_X
	o.currentSwitchY = SWITCHES_START_Y
	return o
end

function ThunderBadgeQuest:isDoable()
	if not hasItem("Rainbow Badge") and self:hasMap() then
		return true
	end
	return false
end

function ThunderBadgeQuest:isDone()
	if getMapgetMapName == "Vermilion City 2" or getMapgetMapName == "SSAnne 1F" or getMapName() == "Route 11" then
		return true
	else
		return false
	end
end

function ThunderBadgeQuest:Route5() 
	return moveToMap("Underground House 1")
end

function ThunderBadgeQuest:UndergroundHouse1()
	return moveToMap("Underground2")
end

function ThunderBadgeQuest:Underground2()
	return moveToMap("Underground House 2")
end

function ThunderBadgeQuest:UndergroundHouse2()
	return moveToMap("Route 6")
end

function ThunderBadgeQuest:Route6()
	if not isNpcOnCell(24, 54) then -- Psychic Wade done
		self.dialogs.psychicWadePart2.state = true
		self.dialogs.surgeVision.state = true
	end

	if isNpcOnCell(31, 5) then -- Berry 1
		return talkToNpcOnCell(31, 5)
	elseif isNpcOnCell(32, 5) then -- Berry 2
		return talkToNpcOnCell(32, 5)
	elseif isNpcOnCell(37, 5) then -- Berry 3
		return talkToNpcOnCell(37, 5)
	elseif isNpcOnCell(38, 5) then -- Berry 4
		return talkToNpcOnCell(38, 5)
	end

	if not dialogs.psychicWadePart2.state then
		return talkToNpcOnCell(24, 54) -- Psychic Wade
	elseif not self.dialogs.surgeVision.state then
		return moveToMap("Vermilion City")
	elseif isNpcOnCell(24, 54) then -- Need talk again with Physic Wade for get Item: Dragon Fang
		return talkToNpcOnCell(24, 54)
	elseif self:needPokecenter() then
		return moveToMap("Vermilion City")
	elseif not self:isTrainingOver() then
		return moveToRectangle(25,22,38,26) -- Go to Route 6 and Leveling
	else
 		return moveToMap("Vermilion City")
 	end
end

function ThunderBadgeQuest:PokecenterVermilion()
	self:pokecenter("Vermilion City")
end

function ThunderBadgeQuest:VermilionCity()
	if isNpcOnCell(38, 63) then
		self.dialogs.surgeVision.state = false -- security check, sometimes a NPC takes time to appear
	else
		self.dialogs.surgeVision.state = true
	end

	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Vermilion" then
		return moveToMap("Pokecenter Vermilion")
	elseif not dialogs.psychicWadePart2.state then
		return moveToMap("Route 6")
	elseif not dialogs.surgeVision.state then
		return talkToNpcOnCell(38, 63) -- Surge
	elseif not self:isTrainingOver() then
		return moveToMap("Route 6")-- Go to Route 6 and Leveling
	elseif not hasItem("HM01 - Cut") then -- Need do SSanne Quest
		return moveToCell(40, 67) -- Enter on SSAnne
	elseif not hasItem("Thunder Badge") then
		if game.hasPokemonWithMove("Cut") then
			return moveToMap("Vermilion Gym")
		else
			if self.pokemonId < getTeamSize() then
				useItemOnPokemon("HM01 - Cut", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
				self.pokemonId = self.pokemonId + 1
			else
				fatal("No pokemon in this team can learn - Cut")
			end
		end
	else
		return moveToMap("Route 11")
	end
end

function ThunderBadgeQuest:puzzleBinPosition(binId)
	local xCount = 5
	local yCount = 3
	local xPosition = 2
	local yPosition = 17
	local spaceBetweenBins = 2
	
	local line   = math.floor(binId / xCount + 1)
	local column = math.floor((binId - 1) % xCount + 1)
	
	local x = xPosition + (column - 1) * spaceBetweenBins
	local y = yPosition - (line   - 1) * spaceBetweenBins
	
	return x, y
end

function ThunderBadgeQuest:solvePuzzle()
	if not self.puzzle.bin then
		self.puzzle.bin = 1
	end
	if self.dialogs.switchWrong.state then
		self.dialogs.switchWrong.state = false
		self.dialogs.switchTrigger.state = false
		self.puzzle.bin = self.puzzle.bin + 1
	elseif self.dialogs.switchTrigger.state and not self.puzzle.firstBin then
		self.puzzle.firstBin = self.puzzle.bin
		self.puzzle.bin = 1 -- we know the first bin, let start again
	end
	
	if not self.dialogs.switchTrigger.state and self.puzzle.firstBin then
		local x, y = self:puzzleBinPosition(self.puzzle.firstBin)
		return talkToNpcOnCell(x, y)
	else
		local x, y = self:puzzleBinPosition(self.puzzle.bin)
		return talkToNpcOnCell(x, y)
	end
end

function ThunderBadgeQuest:VermilionGym()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Vermilion" then
 		return moveToMap("Vermilion City")
	elseif not self:isTrainingOver() and not hasItem("Thunder Badge") then
		return moveToMap("Vermilion City")-- Go to Route 6 and Leveling
	else
		if hasItem("Thunder Badge") then
			return moveToMap("Vermilion City")
		else
			if not isNpcOnCell(6, 10) then
				return talkToNpcOnCell(6,4)
			else
				return self:solvePuzzle()
			end
		end
	end
end

return ThunderBadgeQuest
