-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Volcano Badge'
local description = 'Revive Fossil + Cinnabar Key + Exp on Seafoam B4F'
local level = 75

local VolcanoBadgeQuest = Quest:new()

function VolcanoBadgeQuest:new()
	return Quest.new(VolcanoBadgeQuest, name, description, level)
end

function VolcanoBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("Earth Badge") then
		return true
	end
	return false
end

function VolcanoBadgeQuest:isDone()
	if getMapName() == "Cinnabar Lab" or getMapName() == "Cinnabar mansion 1" or getMapName() == "Route 21" then
		return true
	end
	return false
end

function VolcanoBadgeQuest:PokecenterCinnabar()
	self:pokecenter("Cinnabar Island")
end

function VolcanoBadgeQuest:CinnabarIsland()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Cinnabar" then
		return moveToMap("Pokecenter Cinnabar")
	elseif not self:isTrainingOver() then
		return moveToMap("Route 20")
	elseif not hasItem("Cinnabar Key") and isNpcOnCell(28,17) then
		if isNpcOnCell(18,15) then
			return talkToNpcOnCell(18,15)
		else
			return moveToMap("Cinnabar mansion 1")
		end
	elseif not hasItem("Volcano Badge") then
		if isNpcOnCell(28,17) then
			return talkToNpcOnCell(28,17)
		else
			return moveToMap("Cinnabar Gym")
		end
	elseif hasItem("Dome Fossil") or hasItem("Helix Fossil") then
		return moveToMap("Cinnabar Lab")
	else
		return moveToMap("Route 21")
	end
end

function VolcanoBadgeQuest:CinnabarGym()
	if not hasItem("Volcano Badge") then
		if isNpcOnCell(6,7) then
			return talkToNpcOnCell(6,7)
		else
			return moveToMap("Cinnabar Gym B1F")
		end
	else
		return moveToMap("Cinnabar Island")
	end
end

function VolcanoBadgeQuest:CinnabarGymB1F()
	if not hasItem("Volcano Badge") then
		return talkToNpcOnCell(18,16)
	else
		return moveToMap("Cinnabar Gym")
	end
end

--** EXP SECTION **

function VolcanoBadgeQuest:canUseNurse()
	return getMoney() > 1500
end

function VolcanoBadgeQuest:Route20()
	if not self:isTrainingOver() then
		return moveToCell(73,40) --Seafoam 1F
	else
		return moveToMap("Cinnabar Island")
	end
end

function VolcanoBadgeQuest:Seafoam1F()
	if not self:isTrainingOver() then
		return moveToCell(64,8) --Seafom B1F
	else
		return moveToMap("Route 20")
	end
end

function VolcanoBadgeQuest:SeafoamB1F()
	if not self:isTrainingOver() then
		return moveToCell(64,25) --Seafom B2F
	else
		return moveToCell(85,22)
	end
end

function VolcanoBadgeQuest:SeafoamB2F()
	if isNpcOnCell(67,31) then --Item: TM13 - Ice Beam
		return talkToNpcOnCell(67,31)
	end
	if not self:isTrainingOver() then
		return moveToCell(63,19) --Seafom B3F
	else
		return moveToCell(51,27)
	end
end

function VolcanoBadgeQuest:SeafoamB3F()
	if not self:isTrainingOver() then
		return moveToCell(57,26) --Seafom B4F
	else
		return moveToCell(64,16)
	end
end

function VolcanoBadgeQuest:SeafoamB4F()
	if not self:isTrainingOver() then
		if self:needPokecenter() then
			if self:canUseNurse() then -- if have 1500 money
				return talkToNpcOnCell(59,13)
			else
				if not game.getTotalUsablePokemonCount() > 1 then -- Try get 1500money
				    fatal("don't have enough Pokemons for farm 1500 money and heal the team")
				else 
				    return moveToRectangle(50,10,62,32)
				end
			end
		else
			return moveToRectangle(50,10,62,32)
		end
	else
		return moveToCell(53,28)
	end
end

-- ** END EXP SECTION 

return VolcanoBadgeQuest
