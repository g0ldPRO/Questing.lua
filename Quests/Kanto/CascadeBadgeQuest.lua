-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Cascade Badge - Cerulean City'
local description = 'Get Cerulean City Badge'
local level       = 20

local dialogs = {
	fossileGuyBeaten = Dialog:new({
		"Did you get the one you like?"--,
		--""
	})
}

local CascadeBadgeQuest = Quest:new()

function CascadeBadgeQuest:new()
	return Quest.new(CascadeBadgeQuest, name, description, level, dialogs)
end

function CascadeBadgeQuest:isDoable()
	if not hasItem("Cascade Badge") and self:hasMap()
	then
		return true
	end
	return false
end

function CascadeBadgeQuest:isDone()
	if hasItem("Cascade Badge") then
		return true
	else
		return false
	end
end

function CascadeBadgeQuest:CeruleanCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Cerulean" then
		return moveToMap("Pokecenter Cerulean")
	elseif not self:isTrainingOver() then
		return moveToCell(39,0)-- Route 24 Bridge
	else
		return moveToMap("Cerulean Gym")
	end
end

function CascadeBadgeQuest:PokecenterCerulean()
	self:pokecenter("Cerulean City")
end

function CascadeBadgeQuest:Route24()
	if self:needPokecenter() or self:isTrainingOver() then
		if game.inRectangle(14, 0, 15, 31) then
			return moveToCell(14,31)
		elseif game.inRectangle(6, 0, 12, 31) then
			return moveToCell(8,0)
		else
			error("CascadeBadgeQuest:Route24(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
		end
	else
		if game.inRectangle(14, 0, 15, 31) then
			return moveToCell(14,0)
		elseif game.inRectangle(6, 0, 12, 31) then
			return moveToRectangle(6, 2, 9, 16)
		else
			error("CascadeBadgeQuest:Route24(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
		end
	end
end

function CascadeBadgeQuest:Route25()
	if self:needPokecenter() or self:isTrainingOver() then
		return moveToCell(14,30)
	else
		return moveToCell(8,30)
	end
end

function CascadeBadgeQuest:CeruleanGym()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Cerulean" then
		return moveToMap("Cerulean City")
	else
		return talkToNpcOnCell(10, 6)
	end
end

return CascadeBadgeQuest
