-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Silph Co'
local description = 'Rocket Team Quest'
local level = 55

local dialogs = {
	silphCoDone = Dialog:new({ 
		"saving this building"
	})
}

local SilphCoQuest = Quest:new()

function SilphCoQuest:new()
	return Quest.new(SilphCoQuest, name, description, level, dialogs)
end

function SilphCoQuest:isDoable()
	if self:hasMap() and not hasItem("Volcano Badge") then
		return true
	end
	return false
end

function SilphCoQuest:isDone()
	if getMapName() == "Saffron City" or getMapName() == "Pokecenter Saffron" then
		return true
	else
		return false
	end
end

function SilphCoQuest:SilphCo1F()
	if (isNpcOnCell(19,7) and isNpcOnCell(19,7)) or dialogs.silphCoDone.state then
		return moveToMap("Saffron City")
	else
		return moveToMap("Silph Co 2F")
	end
end

function SilphCoQuest:SilphCo2F()
	if not dialogs.silphCoDone.state then
		return moveToMap("Silph Co 3F")
	else
		return moveToMap("Silph Co 1F")
	end
end

function SilphCoQuest:SilphCo3F()
	if not dialogs.silphCoDone.state then
		return moveToCell(16,18) --Silph Co 7F
	else
		if game.inRectangle(16,15,16,17) then --Fixed moving on TPCell
			return moveToCell(18,14) 
		else
			return moveToCell(29,5) --Silph Co 2F
		end
	end
end

function SilphCoQuest:SilphCo7F()
	if not dialogs.silphCoDone.state then
		return moveToCell(6,11) --Silph Co 11F
	else
		return moveToCell(6,6) --Silph Co 3F
	end
end

function SilphCoQuest:SilphCo11F()
	if isNpcOnCell(3,13) then
		return talkToNpcOnCell(3,13)
	elseif isNpcOnCell(6,15) then
		return talkToNpcOnCell(6,15)
	elseif not dialogs.silphCoDone.state then
		return talkToNpcOnCell(9,11)
	else
		return moveToCell(3,7) --Silph Co 7F
	end
end

return SilphCoQuest
