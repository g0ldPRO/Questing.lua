-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Revive Fossils'
local description = ' DomeFossil, HelixFossil, OldAmber'
local level = 55

local ReviveFossilQuest = Quest:new()

function ReviveFossilQuest:new()
	return Quest.new(ReviveFossilQuest, name, description, level)
end

function ReviveFossilQuest:isDoable()
	return self:hasMap()
end

function ReviveFossilQuest:isDone()
	return getMapName() == "Cinnabar Island"
end

function ReviveFossilQuest:CinnabarLab()
	if not hasItem("Dome Fossil") and not hasItem("Helix Fossil") and not hasItem("Old Amber") then
		return moveToMap("Cinnabar Island")
	else
		if isNpcOnCell(34,10) then
			return talkToNpcOnCell(34,10)
		else
			return moveToMap("Cinnabar Lab Room 3")
		end
	end
end

function ReviveFossilQuest:CinnabarLabRoom3()
	if hasItem("Dome Fossil") or hasItem("Helix Fossil") or hasItem("Old Amber") then
		if hasItem("Dome Fossil") then
			pushDialogAnswer(1) --Choose Fossil
			pushDialogAnswer(1) --Confirm
			return talkToNpcOnCell(12,5)
		elseif hasItem("Helix Fossil") then
			pushDialogAnswer(2) --Choose Fossil
			pushDialogAnswer(1) --Confirm
			return talkToNpcOnCell(12,5)
		else --Old Amber
			pushDialogAnswer(3) --Choose Fossil
			pushDialogAnswer(1) --Confirm
			return talkToNpcOnCell(12,5)
		end		
	else
		return moveToMap("Cinnabar Lab")
	end	
end

return ReviveFossilQuest
