-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Quest: HM05 - Flash '
local description = 'Route 11 to Route 9'

local HmFlashQuest = Quest:new()

function HmFlashQuest:new()
	return Quest.new(HmFlashQuest, name, description, 1)
end

function HmFlashQuest:isDoable()
	if self:hasMap() and not hasItem("Rainbow Badge") then
		return true
	end
	return false
end

function HmFlashQuest:isDone()
	if getMapName() == "Route 9" and hasItem("HM05 - Flash")then
		return true
	else
		return false
	end
end

function HmFlashQuest:Route11()
	if isNpcOnCell(10, 13) then -- NPC Block Diglet's Entrance
		return talkToNpcOnCell(10, 13) 
	elseif not hasItem("HM05 - Flash") then
		if getPokedexOwned() < 10 then
			error("To take [HM05 - Flash] need 10 pokemons, you still have to catch ".. (10 - getPokedexOwned()) .." pokemons")
		else	
			return moveToMap("Digletts Cave Entrance 2")
		end
	else
		moveToMap("Vermilion City")
	end
end

function HmFlashQuest:VermilionCity()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Route 11")
	else
		return moveToMap("Route 6")
	end
end

function HmFlashQuest:Route6()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Vermilion City")
	else
		return moveToMap("Underground House 2")
	end
end

function HmFlashQuest:UndergroundHouse2()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Route 6")
	else
		return moveToMap("Underground2")
	end
end

function HmFlashQuest:Underground2()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Underground House 2")
	else
		return moveToMap("Underground House 1")
	end
end

function HmFlashQuest:UndergroundHouse1()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Underground2")
	else
		return moveToMap("Route 5")
	end
end

function HmFlashQuest:Route5() 
	if not hasItem("HM05 - Flash") then
		return moveToMap("Underground House 1")
	else
		return moveToCell(28,0)
	end
end

function HmFlashQuest:CeruleanCity()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Route 5")
	else
		return moveToMap("Route 9")
	end
end

function HmFlashQuest:DiglettsCaveEntrance2()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Digletts Cave")
	else
		return moveToMap("Route 11")
	end
end

function HmFlashQuest:DiglettsCave()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Digletts Cave Entrance 1")
	else
		return moveToMap("Digletts Cave Entrance 2")
	end
end

function HmFlashQuest:DiglettsCaveEntrance1()
	if not hasItem("HM05 - Flash") then
		return moveToMap("Route 2")
	else
		return moveToMap("Digletts Cave")
	end
end

function HmFlashQuest:Route2()
	if not hasItem("HM05 - Flash") then
		if isNpcOnCell(42,66) then -- Item: Sitrus Berry
			return talkToNpcOnCell(42,66)
		else
			return moveToMap("Route 2 Stop3")
		end
	else
		return moveToMap("Digletts Cave Entrance 1")
	end
end

function HmFlashQuest:Route2Stop3()
	if getPokedexOwned() < 10 then
		fatal("To take [HM05 - Flash] need 10 pokemons, you still have to catch ".. (10 - getPokedexOwned()) .." pokemons")
	elseif not hasItem("HM05 - Flash") then
		return talkToNpcOnCell(6,5)
	else
		return moveToMap("Route 2")
	end
end

return HmFlashQuest
