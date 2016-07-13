-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Route 12 to Fuchsia City'
local description = 'Snorlax Wakeup + All Items'
local level = 33

local SnorlaxQuest = Quest:new()

function SnorlaxQuest:new()
	return Quest.new(SnorlaxQuest, name, description, level)
end

function SnorlaxQuest:isDoable()
	if self:hasMap() and not hasItem("Soul Badge") then
		return true
	end
	return false
end

function SnorlaxQuest:isDone()
	if getMapName() == "Fuchsia City" then
		return true
	else
		return false
	end
end

function SnorlaxQuest:Route12()
	if isNpcOnCell(18,47) then --NPC: Snorlax
		return talkToNpcOnCell(18,47)
	elseif isNpcOnCell(4,73) then --Item: Iron
		return talkToNpcOnCell(4,73)
	elseif isNpcOnCell(3,76) then --Item: Rare Candy
		return talkToNpcOnCell(3,76)
	else
		return moveToMap("Route 13")
	end
end

function SnorlaxQuest:Route13()
	if isNpcOnCell(47,26) then --Item: PP UP
		return talkToNpcOnCell(47,26)
	elseif isNpcOnCell(28,27) then --Item: Calcium
		return talkToNpcOnCell(28,27)
	elseif isNpcOnCell(21,9) then --Item: Ultra Ball
		return talkToNpcOnCell(21,9)
	else
		return moveToCell(18,34) --Fixed: Can't Use moveToMap("Route 14") 1 cell of this link is on water
	end
end

function SnorlaxQuest:Route14()
	if isNpcOnCell(21,38) then --Item: Lum Berry
		return talkToNpcOnCell(21,38)
	elseif isNpcOnCell(22,38) then --Item: Lum Berry
		return talkToNpcOnCell(22,38)
	elseif isNpcOnCell(12,3) and game.hasPokemonWithMove("Cut")then --Item: Zync
		return talkToNpcOnCell(12,3)
	else
		return moveToMap("Route 15")
	end
end

function SnorlaxQuest:Route15()
	if isNpcOnCell(52,24) then --Item: TM-18: Counter
		return talkToNpcOnCell(52,24)
	elseif isNpcOnCell(32,14) then --Item: Pecha Berry
		return talkToNpcOnCell(32,14)
	elseif isNpcOnCell(33,14) then --Item: Leppa Berry
		return talkToNpcOnCell(33,14)
	elseif isNpcOnCell(12,14) then --Item: PP UP
		return talkToNpcOnCell(12,14)
	else
		return moveToMap("Route 15 Stop House")
	end
end

function SnorlaxQuest:Route15StopHouse()
	return moveToMap("Fuchsia City")
end

return SnorlaxQuest
