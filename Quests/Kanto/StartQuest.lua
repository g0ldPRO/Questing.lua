-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Start'
local description = 'Play the Start map'

local StartQuest = Quest:new()
function StartQuest:new()
	return Quest.new(StartQuest, name, description, _, dialogs)
end

function StartQuest:isDoable()
	-- a quest should never monopolize a map
	-- but Start is a special map
	return getMapName() == "Start"
end

function StartQuest:Start()
	if isNpcOnCell(21,38) then
		return talkToNpcOnCell(21,38)
	end
	return moveToCell(26,87)
end

return StartQuest
