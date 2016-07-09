-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: By Rympe

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Thunder Badge - Vermilion City'
local description = ' Get Badge'
local level       = 26



local dialogs = {
	switchWrong = Dialog:new({
		"wrong switch"
	}),
	switchTrigger = Dialog:new({
		"have triggered the first switch"
	}),
	switchReset = Dialog:new({
		"have been reset"
	})
}

local ThunderBadgeQuest = Quest:new()

function ThunderBadgeQuest:new()
	return Quest.new(ThunderBadgeQuest, name, description, level, dialogs)
end

function ThunderBadgeQuest:isDoable()
	if self:hasMap() then
		return true
	end
	return false
end

function ThunderBadgeQuest:isDone()
	if hasItem("Thunder Badge") and getMapName() == "Route 11" then
		return true
	else
		return false
	end
end

function ThunderBadgeQuest:PokecenterVermilion()
	self:pokecenter("Vermilion City")
end

function ThunderBadgeQuest:Route6()
	if self:needPokecenter() then
 		return moveToMap("Vermilion City")
	elseif hasItem("Thunder Badge") then
		return moveToMap("Vermilion City")
	elseif isNpcOnCell(24, 54) then -- Need talk again with Physic Wade for get Item: Dragon Fang
		return talkToNpcOnCell(24, 54)
	elseif not self:isTrainingOver() then
		return moveToRectangle(25,22,38,26) -- Go to Route 6 and Leveling
	else
 		return moveToMap("Vermilion City")
 	end
end

local pokemonId=1

function ThunderBadgeQuest:VermilionCity()
 	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Vermilion" then
 		return moveToMap("Pokecenter Vermilion")
	elseif not self:isTrainingOver() and not hasItem("Thunder Badge")then
		return moveToMap("Route 6")-- Go to Route 6 and Leveling
	else
		if hasItem("Thunder Badge") then
			return moveToMap("Route 11")
		else
			if game.hasPokemonWithMove("Cut") then
				local pokemonId = 1
				return moveToMap("Vermilion Gym")
			else
				if pokemonId < getTeamSize() then					
					useItemOnPokemon("HM01 - Cut", pokemonId)
					log("Pokemon: " .. pokemonId .. " Try Learning: HM01 - Cut")
					pokemonId = pokemonId + 1
				else
					fatal("No pokemon in this team can learn - Cut")
				end
			end
		end		
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
				if dialogs.switchReset.state then
					return switchReset_()
				elseif dialogs.switchWrong.state then
					return switchWrong_()
				elseif dialogs.switchTrigger.state then
					return switchTrigger_()
				else
					return solveSurgePuzzle()
				end
			end
		end
	end
end


-- SILVER FUNCTION FOR SOLVE SURGE PUZZLE -- @S1lv3r

SWITCHES_START_X = 2
SWITCHES_START_Y = 13
SWITCHES_END_X = 10
SWITCHES_END_Y = 17


firstSwitchFound = false
firstSwitchActivated = false
firstSwitchX = 0
firstSwitchY = 0
currentSwitchX = SWITCHES_START_X
currentSwitchY = SWITCHES_START_Y


function solveSurgePuzzle()
	if not isNpcOnCell(6, 10) then
		return true
	end
	if firstSwitchFound and not firstSwitchActivated then
		talkToNpcOnCell(firstSwitchX, firstSwitchY)
	else
		talkToNpcOnCell(currentSwitchX, currentSwitchY)
	end
end

function switchWrong_()
	log("[Surge puzzle] First switch [" .. currentSwitchX .. "," .. currentSwitchY .. "] is wrong, next.")
	nextSwitch()
	firstSwitchFound = false
	firstSwitchActivated = false
	dialogs.switchWrong.state = false
end

function switchTrigger_()
	if not firstSwitchFound then
		log("[Surge puzzle] Found the first switch! [" .. currentSwitchX .. "," .. currentSwitchY .. "] is correct.")
		firstSwitchFound = true
		firstSwitchX = currentSwitchX
		firstSwitchY = currentSwitchY
		currentSwitchX = SWITCHES_START_X
		currentSwitchY = SWITCHES_START_Y
	end
	firstSwitchActivated = true	
	dialogs.switchTrigger.state = false
end
	
function switchReset_()
	log("[Surge puzzle] Second switch [" .. currentSwitchX .. "," .. currentSwitchY .. "] is wrong, next.")
	nextSwitch()
	firstSwitchActivated = false
	dialogs.switchReset.state = false
end

function nextSwitch()
	currentSwitchX = currentSwitchX + 2
	if currentSwitchX > SWITCHES_END_X then
		currentSwitchX = SWITCHES_START_X
		currentSwitchY = currentSwitchY + 2
	end
	if currentSwitchY > SWITCHES_END_Y then
		currentSwitchY = SWITCHES_START_Y
	end
end

---  END SURGE PUZZLE SCRIPT ---

return ThunderBadgeQuest
