-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local QuestManager = {}


local StartQuest = require('Quests/000Start')

local quests = {
	StartQuest
}

function QuestManager:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.quests = quests
	self.selected = nil
	return o
end

function QuestManager:next()
	for id, quest in pairs(self.quests) do
		if quest:isDoable() == true then
			self.selected = quest
			return quest
		end
	end
	self.selected = nil
	return nil
end

function QuestManager:isQuestOver()
	if self.selected == nil or self.selected:isDoable() == false then
		return true
	end
	return false
end

function QuestManager:path()
	if QuestManager:isQuestOver() then
		if self.selected ~= nil then
			log(self.selected.name .. " is over")
		end
		if QuestManager:next() == false then
			log("no more quest to do")
			return false
		end
		log('Starting new quest: ' .. self.selected:message())
	end
	return self.selected:path()
end

function QuestManager:battle()
	if self.selected == nil then
		log('No quest selected, cannot call battle')
		return false
	end
	return self.selected:battle()
end

function QuestManager:dialog(message)
	if self.selected == nil then
		log('No quest selected, cannot call dialog')
		return false
	end
	return self.selected:dialog(message)
end

return QuestManager