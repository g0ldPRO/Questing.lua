-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local QuestManager = {}


local StartQuest          = require('Quests/Kanto/StartQuest')
local PalletStartQuest    = require('Quests/Kanto/PalletStartQuest')
local ViridianSchoolQuest = require('Quests/Kanto/ViridianSchoolQuest')
local BoulderBadgeQuest   = require('Quests/Kanto/BoulderBadgeQuest')
local MoonFossilQuest     = require('Quests/Kanto/MoonFossilQuest')
local CascadeBadgeQuest	  = require('Quests/Kanto/CascadeBadgeQuest')
local LanceVermilionQuest = require('Quests/Kanto/LanceVermilionQuest')
local SSAnneQuest	  = require('Quests/Kanto/SSAnneQuest')
local ThunderBadgeQuest   = require('Quests/Kanto/ThunderBadgeQuest')


local quests = {
	StartQuest:new(),
	PalletStartQuest:new(),
	ViridianSchoolQuest:new(),
	BoulderBadgeQuest:new(),
	MoonFossilQuest:new(),
	CascadeBadgeQuest:new(),
	SSAnneQuest:new(),
	ThunderBadgeQuest:new(),
	LanceVermilionQuest:new()
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

function QuestManager:message()
	if self.selected then
		return self.selected:message()
	end
	return nil
end

function QuestManager:pause()
	if self.selected then
		log("Pause Quest: " .. self:message())
	end
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
	if not self.selected or self.selected:isDone() then
		return true
	end
	return false
end

function QuestManager:updateQuest()
	if getMapName() == "" then
		return false
	end
	if self:isQuestOver() then
		if self.selected then
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
	if not self.selected then
		return false
	end
	return self.selected:dialog(message)
end

function QuestManager:battleMessage(message)
	if not self:updateQuest() then
		return false
	end
	return self.selected:battleMessage(message)
end

function QuestManager:systemMessage(message)
	if not self.selected then
		return false
	end
	return self.selected:systemMessage(message)
end

function QuestManager:learningMove(moveName, pokemonIndex)
	if not self:updateQuest() then
		return false
	end
	return self.selected:learningMove(moveName, pokemonIndex)
end

return QuestManager
