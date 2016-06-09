-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local QuestManager = {}


local StartQuest = require('Quests/000Start')
local startQuest = StartQuest:new()

local quests = {
	startQuest
}

function QuestManager:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.quests = quests
	o.selected = nil
	o.isOver = false
	return o
end

function QuestManager:next()
	for _, quest in pairs(self.quests) do
		if quest:isDoable() == true then
			self.selected = quest
			return quest
		end
	end
	self.selected = nil
	return nil
end

function QuestManager:isQuestOver()
	if self.selected == nil or self.selected:isDone() == true then
		return true
	end
	return false
end

function QuestManager:updateQuest()
	if self:isQuestOver() then
		if self.selected ~= nil then
			log(self.selected.name .. " is over")
		end
		if not self:next() then
			self.isOver = true
			return false
		end
		log('Starting new quest: ' .. self.selected:message())
	end
	return true
end

function QuestManager:path()
	if not self:updateQuest() then
		return false
	end
	return self.selected:path()
end

function QuestManager:battle()
	if not self:updateQuest() then
		return false
	end
	return self.selected:battle()
end

function QuestManager:dialog(message)
	if not self:updateQuest() then
		return false
	end
	return self.selected:dialog(message)
end

return QuestManager