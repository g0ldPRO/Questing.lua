-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Mt. Moon Fossil'
local description = 'from Route 3 to Cerulean City'
local level       = 18

local dialogs = {
	fossileGuyBeaten = Dialog:new({
		"Did you get the one you like?"--,
		--""
	})
}

local MoonFossilQuest = Quest:new()
function MoonFossilQuest:new()
	return Quest.new(MoonFossilQuest, name, description, level, dialogs)
end

function MoonFossilQuest:isDoable()
	if not hasItem("Cascade Badge") and self:hasMap()
	then
		return true
	end
	return false
end

function MoonFossilQuest:isDone()
	return getMapName() == "Cerulean City"
end

function MoonFossilQuest:Route3()
	if self:needPokecenter()
		or not game.isTeamFullyHealed()
		or self.registeredPokecenter ~= "Pokecenter Route 3"
	then
		return moveToMap("Pokecenter Route 3")
	else
		return moveToMap("Mt. Moon 1F")
	end
end

function MoonFossilQuest:MtMoon1F()
	if self:needPokecenter() then
		return moveToMap("Route 3")
	elseif isNpcOnCell(19, 16) then
		return talkToNpcOnCell(19, 16) -- moon stone
	elseif not self:isTrainingOver() then
		return moveToRectangle(37, 60, 40, 62)
	else
		return moveToCell(21, 20) -- Mt. Moon B1F
	end
end

function MoonFossilQuest:MtMoonB1F()
	if game.inRectangle(56, 18, 66, 21) then
		return moveToCell(65, 20) -- Mt. Moon B2F (wrong way)
	elseif game.inRectangle(73, 15, 78, 34)
		or game.inRectangle(53, 29, 78, 34)
	then
		return moveToCell(56, 34) -- Mt. Moon B2F (right way)
	elseif game.inRectangle(32, 19, 42, 22) then
		return moveToCell(41, 20) -- Mt. Moon Exit
	else
		error("MoonFossilQuest:MtMoonB1F(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
	end
end

function MoonFossilQuest:MtMoonB2F()
	if game.inRectangle(10, 22, 63, 64) then
		if isNpcOnCell(25, 29) and isNpcOnCell(26, 29) then -- fossile on the way
			if dialogs.fossileGuyBeaten.state then
				if KANTO_FOSSIL_ID == 1 then
					return talkToNpcOnCell(25, 29)
				elseif KANTO_FOSSIL_ID == 2 then
					return talkToNpcOnCell(26, 29)
				else
					fatal("undefined KANTO_FOSSIL_ID")
				end
			else
				return talkToNpcOnCell(23, 31)
			end
		elseif isNpcOnCell(26, 23) then
			return talkToNpcOnCell(26, 23) -- Team Rocket
		else
			return moveToCell(17, 27) -- Mt. Moon B1F
		end
	else
		error("MoonFossilQuest:MtMoonB2F(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
	end
end

function MoonFossilQuest:MtMoonExit()
	return moveToMap("Route 4")
end

function MoonFossilQuest:Route4()
	return moveToCell(96, 21) -- Cerulean City (avoid water link)
end

function MoonFossilQuest:PokecenterRoute3()
	return self:pokecenter("Route 3")
end

return MoonFossilQuest
