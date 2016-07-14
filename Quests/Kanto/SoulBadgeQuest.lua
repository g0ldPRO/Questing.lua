-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Sould Badge'
local description = 'Fuchsia City'
local level = 40

local SoulBadgeQuest = Quest:new()

function SoulBadgeQuest:new()
	local o = Quest.new(SoulBadgeQuest, name, description, level)
	o.zoneExp = 1
	return o
end

function SoulBadgeQuest:isDoable()
	if self:hasMap() then
		if getMapName() == "Fuchsia City" then 
			if hasItem("Soul Badge") then
				return false
			else
				return true
			end
		else
			return true
		end
	end
	return false
end

function SoulBadgeQuest:isDone()
	if hasItem("Soul Badge") and getMapName() == "Fuchsia City" then
		return true
	else
		return false
	end
end

function SoulBadgeQuest:pokemart_()
	local pokeballCount = getItemQuantity("Pokeball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 50 then
		if not isShopOpen() then
			return talkToNpcOnCell(9,8)
		else
			local pokeballToBuy = 50 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
			return buyItem("Pokeball", pokeballToBuy)
		end
	else
		return moveToMap("Fuchsia City")
	end
end

function SoulBadgeQuest:needPokemart_()
	if getItemQuantity("Pokeball") < 50 and getMoney() >= 200 then
		return true
	end
	return false
end

function SoulBadgeQuest:randomZoneExp()
	if self.zoneExp == 1 then
		if game.inRectangle(51,18,55,22) then--Zone 1
			return moveToGrass()
		else
			return moveToCell(53,20)
		end
	elseif self.zoneExp == 2 then
		if game.inRectangle(65,29,70,31) then--Zone 2
			return moveToGrass()
		else
			return moveToCell(68,30)
		end
	elseif self.zoneExp == 3 then
		if game.inRectangle(62,14,66,15) then--Zone 3
			return moveToGrass()
		else
			return moveToCell(64,14)
		end
	else 
		if game.inRectangle(89,14,91,18) then--Zone 4
			return moveToGrass()
		else
			return moveToCell(90,16)
		end
	end
end

function SoulBadgeQuest:PokecenterFuchsia()
	self:pokecenter("Fuchsia City")
end

function SoulBadgeQuest:Route18()
	return moveToMap("Fuchsia City")
end

function SoulBadgeQuest:FuchsiaCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Fuchsia" then
		return moveToMap("Pokecenter Fuchsia")
	elseif isNpcOnCell(13,7) then --Item: PP UP
		return talkToNpcOnCell(13,7)
	elseif isNpcOnCell(12,10) then --Item: Ultra Ball
		return talkToNpcOnCell(12,10)
	elseif self:needPokemart_() then
		return moveToMap("Safari Stop")
	elseif not self:isTrainingOver() then
		return moveToMap("Route 15 Stop House")
	elseif not hasItem("Soul Badge") then
		return moveToMap("Fuchsia Gym")
	else
		return fatal("need continue coding for get surf on next quest")
	end
end

function SoulBadgeQuest:SafariStop()
	if self:needPokemart_() then
		self:pokemart_()
	elseif hasItem("Soul Badge") then
		return moveToMap("Fuchsia City")
	else
		return moveToMap("Fuchsia City")
	end
end

function SoulBadgeQuest:Route15StopHouse()
	if self:needPokecenter() or self:isTrainingOver() or not self.registeredPokecenter == "Pokecenter Fuchsia" then
		return moveToMap("Fuchsia City")
	else
		self.zoneExp = math.random(1,4)
		return moveToMap("Route 15")
	end
end

function SoulBadgeQuest:Route15()
	if self:needPokecenter() or self:isTrainingOver() or not self.registeredPokecenter == "Pokecenter Fuchsia" then
		return moveToMap("Route 15 Stop House")
	else
		return self:randomZoneExp()
	end
end

function SoulBadgeQuest:FuchsiaGym()
	if not hasItem("Soul Badge") then
		if game.inRectangle(6,16,7,16) then -- Antistuck NearLinkExitCell (7,16) Pathfind Return move on this cell
			return moveToCell(6,15)
		else
			return talkToNpcOnCell(7,10)
		end
	else
		return moveToMap("Fuchsia City")
	end
end

return SoulBadgeQuest
