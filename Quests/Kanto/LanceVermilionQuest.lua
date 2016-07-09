-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Lance Quest - Vermilion City: '
local description = 'Route 5 to SSAnne 1F'
local level       = 21

local dialogs = {
	PsychicWadePart2 = Dialog:new({ 
		"hurry up and tell him that"
	})
}

local LanceVermilionQuest = Quest:new()

function LanceVermilionQuest:new()
	return Quest.new(LanceVermilionQuest, name, description, level, dialogs)
end

function LanceVermilionQuest:isDoable()
	if self:hasMap() and not hasItem("HM01 - Cut") then
		return true
	end
	return false
end

function LanceVermilionQuest:isDone()
	if getMapName() == "SSAnne 1F" then
		return true
	else
		return false
	end
end

function LanceVermilionQuest:Route5() 
	return moveToMap("Underground House 1")
end

function LanceVermilionQuest:UndergroundHouse1()
	return moveToMap("Underground2")
end

function LanceVermilionQuest:Underground2()
	return moveToMap("Underground House 2")
end

function LanceVermilionQuest:UndergroundHouse2()
	return moveToMap("Route 6")
end

function LanceVermilionQuest:Route6()
	if isNpcOnCell(31, 5) then -- Berry 1
		return talkToNpcOnCell(31, 5)
	elseif isNpcOnCell(32, 5) then -- Berry 2
		return talkToNpcOnCell(32, 5)
	elseif isNpcOnCell(37, 5) then -- Berry 3
		return talkToNpcOnCell(37, 5)
	elseif isNpcOnCell(38, 5) then -- Berry 4
		return talkToNpcOnCell(38, 5)
	elseif not dialogs.PsychicWadePart2.state and isNpcOnCell(24, 54) then -- Check Psychic Wade Exist and Talk
		return talkToNpcOnCell(24, 54)
	else
		return moveToMap("Vermilion City")
	end
end

function LanceVermilionQuest:VermilionCity2()
	return talkToNpcOnCell(44, 30)
end

function LanceVermilionQuest:PokecenterVermilion()
	self:pokecenter("Vermilion City")
end

function LanceVermilionQuest:VermilionCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Vermilion" then
		return moveToMap("Pokecenter Vermilion")
	elseif not dialogs.PsychicWadePart2.state and isNpcOnCell(38, 63) then
		return moveToMap("Route 6")
	elseif dialogs.PsychicWadePart2.state and isNpcOnCell(38, 63) then -- Already Talk with Psychic Wade and need Talk with Surge
		return talkToNpcOnCell(38, 63)
	elseif not hasItem("HM01 - Cut") then -- Need do SSanne Quest
		return moveToCell(40, 67) -- Enter on SSAnne
	else
		return
	end
end

return LanceVermilionQuest
