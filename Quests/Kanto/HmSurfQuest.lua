-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'HM Surf'
local description = 'Kanto Safari'
local level = 40

local HmSurfQuest = Quest:new()

function HmSurfQuest:new()
	return Quest.new(HmSurfQuest, name, description, level)
end

function HmSurfQuest:isDoable()
	return self:hasMap()	
end

function HmSurfQuest:isDone()
	if hasItem("HM03 - Surf") and getMapName() == "Safari Stop" then
		return true		
	end
	return false
end

function HmSurfQuest:SafariEntrance()
	if not hasItem("HM03 - Surf") then
		return moveToMap("Safari Area 1")
	else
		return talkToNpcOnCell(27,25)
	end
end

function HmSurfQuest:SafariArea1()
	if not hasItem("HM03 - Surf") then
		return moveToMap("Safari Area 2")
	else
		return moveToMap("Safari Entrance")
	end
end

function HmSurfQuest:SafariArea2()
	if not hasItem("HM03 - Surf") then
		return moveToMap("Safari Area 3")
	else
		return moveToMap("Safari Area 1")
	end
end

function HmSurfQuest:SafariArea3()
	if not hasItem("HM03 - Surf") then
		return moveToMap("Safari House 4")
	else
		return moveToMap("Safari Area 2")
	end
end

function HmSurfQuest:SafariHouse4()
	if not hasItem("HM03 - Surf") then
		return talkToNpcOnCell(11,3)		
	else
		return moveToMap("Safari Area 3")
	end
end

return HmSurfQuest
