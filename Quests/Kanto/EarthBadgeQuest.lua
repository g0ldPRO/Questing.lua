-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Earth Badge'
local description = ' Beat Giovanni'
local level = 65

local EarthBadgeQuest = Quest:new()

function EarthBadgeQuest:new()
	return Quest.new(EarthBadgeQuest, name, description, level)
end

function EarthBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("Earth Badge") then
		return true
	end
	return false
end

function EarthBadgeQuest:isDone()
	if hasItem("Earth Badge") and getMapName() == "Viridian City" then
		return true
	end
	return false	
end

function EarthBadgeQuest:Route21()
	if isNpcOnCell(16,1) then --Item: Rawst Berry
		return talkToNpcOnCell(16,1)
	elseif isNpcOnCell(17,1) then --Item: Rawst Berry
		return talkToNpcOnCell(17,1)
	else
		return moveToMap("Pallet Town")
	end
end

function EarthBadgeQuest:PalletTown()
	return moveToMap("Route 1")
end

function EarthBadgeQuest:Route1()
	if isNpcOnCell(13,36) then --Item: Oran Berry
		return talkToNpcOnCell(13,36)
	elseif isNpcOnCell(14,36) then --Item: Pecha Berry
		return talkToNpcOnCell(14,36)
	else
		return moveToMap("Route 1 Stop House")
	end
end

function EarthBadgeQuest:Route1StopHouse()
	return moveToMap("Viridian City")
end

function EarthBadgeQuest:PokecenterViridian()
	self:pokecenter("Viridian City")
end

function EarthBadgeQuest:ViridianPokemart()
	self:pokemart("Viridian City")
end

function EarthBadgeQuest:ViridianCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Viridian" then
		return moveToMap("Pokecenter Viridian")
	elseif self:needPokemart() then
		return moveToMap("Viridian Pokemart")
	elseif not self:isTrainingOver() then
		return fatal("Error This team can't beat Giovanni")
	else
		return moveToCell(60,22) --Viridian Gym 2
	end
end

function EarthBadgeQuest:ViridianGym2()
	if hasItem("Earth Badge") then
		return moveToMap("Viridian City")
	else
		if isNpcOnCell(10,26) then --NPC Gary
			return talkToNpcOnCell(10,26)
		else
			return talkToNpcOnCell(10,8)
		end
	end
end

return EarthBadgeQuest
