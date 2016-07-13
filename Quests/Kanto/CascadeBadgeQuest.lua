-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Cascade Badge Quest'
local description = 'From Cerulean to Route 5'
local level       = 21

local dialogs = {
	billTicketDone = Dialog:new({
		"Oh!! You found it!",
		"Have you enjoyed the Cruise yet?"
	}),
	bookPillowDone = Dialog:new({
		"Oh! Looks like Bill's research book is under his pillow.",
		"There is nothing else here..."
	})
}

local CascadeBadgeQuest = Quest:new()

function CascadeBadgeQuest:new()
	return Quest.new(CascadeBadgeQuest, name, description, level, dialogs)
end

function CascadeBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("HM01 - Cut") then
		return true
	end
	return false
end

function CascadeBadgeQuest:isDone()
	if getMapName() == "Route 5" then
		return true
	else
		return false
	end
end

function CascadeBadgeQuest:CeruleanCity()
	if self:needPokecenter()
		or not game.isTeamFullyHealed()
		or self.registeredPokecenter ~= "Pokecenter Cerulean"
	then
		return moveToMap("Pokecenter Cerulean")
	elseif self:needPokemart() then
		return moveToMap("Cerulean Pokemart")
	elseif not self:isTrainingOver()
		or not dialogs.billTicketDone.state
	then
		return moveToCell(39,0)-- Route 24 Bridge
	else
		if not hasItem("Cascade Badge") then
			return moveToMap("Cerulean Gym")
		else  -- Gym complete --> Get Ticket Bill
			if isNpcOnCell(47, 27) then -- RocketGuy --> 2ND
				return talkToNpcOnCell(47, 27)
			else -- all done Ticket + Badge (Go to Route 5)
				return moveToCell(23,50) -- Route 5
			end
		end
	end
end

function CascadeBadgeQuest:CeruleanPokemart()
	self:pokemart("Cerulean City")
end

function CascadeBadgeQuest:PokecenterCerulean()
	return self:pokecenter("Cerulean City")
end

function CascadeBadgeQuest:Route24Bridge()
	if (not self:isTrainingOver()
			or not dialogs.billTicketDone.state)
		and not self:needPokecenter()
	then
		return moveToCell(14,0)
	else
		return moveToCell(14,31)
	end
end

function CascadeBadgeQuest:Route24Grass()
	if not self:isTrainingOver()
		and not self:needPokecenter()
	then
		return moveToRectangle(6, 2, 9, 16)
	else
		return moveToCell(8,0)
	end
end

function CascadeBadgeQuest:Route24()
	if game.inRectangle(14, 0, 15, 31) then
		return self:Route24Bridge()
	elseif game.inRectangle(6, 0, 12, 31) then
		return self:Route24Grass()
	else
		error("CascadeBadgeQuest:Route24(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
	end
end

function CascadeBadgeQuest:Route25()
	if isNpcOnCell(14, 9) then -- TM 19 
		return talkToNpcOnCell(14, 9)
	elseif isNpcOnCell(74, 5) then -- Berry 1 
		return talkToNpcOnCell(74, 5)
	elseif isNpcOnCell(75, 5) then -- Berry 2 
		return talkToNpcOnCell(75, 5)
	elseif isNpcOnCell(70, 7) then -- Item: Pokeball 
		return talkToNpcOnCell(70, 7)
	elseif hasItem("Nugget") then
		return moveToMap("Item Maniac House") -- sell Nugget give $15.000
	elseif self:needPokecenter() then
		moveToCell(14, 30)
	elseif not self:isTrainingOver() then
		return moveToCell(8,30)
	elseif isNpcOnCell(16, 27) then -- RocketGuy -> Give Nugget($15.000)
		return talkToNpcOnCell(16, 27)
	elseif not dialogs.billTicketDone.state then
		return moveToMap("Bills House")
	else
		moveToCell(14, 30)
	end
end

function CascadeBadgeQuest:BillsHouse() -- get ticket 
	if dialogs.billTicketDone.state then
		return moveToMap("Route 25")
	else
		if dialogs.bookPillowDone.state then
			return talkToNpcOnCell(11, 3)
		else
			return talkToNpcOnCell(18, 2)
		end
	end
end

function CascadeBadgeQuest:ItemManiacHouse() -- sell nugget
	if hasItem("Nugget") then
		return talkToNpcOnCell(6, 5)
	else
		return moveToMap("Route 25")
	end
end

function CascadeBadgeQuest:CeruleanGym() -- get Cascade Badge
	if self:needPokecenter() or hasItem("Cascade Badge") then
		return moveToMap("Cerulean City")
	else
		return talkToNpcOnCell(10, 6)
	end
end

return CascadeBadgeQuest
