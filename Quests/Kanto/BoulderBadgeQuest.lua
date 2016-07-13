-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Boulder Badge'
local description = 'from route 2 to route 3'

local BoulderBadgeQuest = Quest:new()
function BoulderBadgeQuest:new()
	return Quest.new(BoulderBadgeQuest, name, description, 14)
end

function BoulderBadgeQuest:isDoable()
	if not hasItem("Cascade Badge") and self:hasMap()
	then
		return true
	end
	return false
end

function BoulderBadgeQuest:isDone()
	return getMapName() == "Pokecenter Route 3"
end

-- in case of black out
function BoulderBadgeQuest:PokecenterViridian()
	return moveToMap("Viridian City")
end

function BoulderBadgeQuest:ViridianCity()
	return moveToMap("Route 2")
end

function BoulderBadgeQuest:Route2()
	if game.inRectangle(0, 90, 24, 130) then
		return moveToMap("Route 2 Stop")
	elseif game.inRectangle(0, 0, 28, 42) then
		self:route2Up()
	else
		error("BoulderBadgeQuest:Route2(): This position should not be possible")
	end
end

function BoulderBadgeQuest:Route2Stop()
	return moveToMap("Viridian Forest")
end

function BoulderBadgeQuest:ViridianForest()
	return moveToMap("Route 2 Stop2")
end

function BoulderBadgeQuest:Route2Stop2()
	return moveToMap("Route 2")
end

function BoulderBadgeQuest:route2Up()
	if self.registeredPokecenter ~= "Pokecenter Pewter" then
		return moveToMap("Pewter City")
	elseif not self:needPokecenter() and not self:isTrainingOver() then
		return moveToGrass()
	else
		return moveToMap("Pewter City")
	end
end

function BoulderBadgeQuest:PewterCity()
	if isNpcOnCell(23, 22) then
		-- red blocking the way after beating Brock
		return talkToNpcOnCell(23, 22)
	elseif self:needPokemart() then
		return moveToMap("Pewter Pokemart")
	elseif hasItem("Boulder Badge") then
		return moveToMap("Route 3")
	elseif self.registeredPokecenter ~= "Pokecenter Pewter"
		or not game.isTeamFullyHealed()
	then
		return moveToMap("Pokecenter Pewter")
	elseif getItemQuantity("Pokeball") < 50 and getMoney() >= 200 then
		return moveToMap("Pewter Pokemart")
	elseif self:isTrainingOver() then
		return moveToMap("Pewter Gym")
	else
		return moveToMap("Route 2")
	end
end

function BoulderBadgeQuest:PewterGym()
	if hasItem("Boulder Badge") then
		sys.todo("BoulderBadgeQuest::PewterGym(): buy the TM")
		return moveToMap("Pewter City")
	else
		return talkToNpcOnCell(7,5)
	end
end

function BoulderBadgeQuest:Route3()
	return moveToMap("Pokecenter Route 3")
end

function BoulderBadgeQuest:PokecenterPewter()
	self:pokecenter("Pewter City")
end

function BoulderBadgeQuest:PewterPokemart()
	self:pokemart("Pewter City")
end

return BoulderBadgeQuest
