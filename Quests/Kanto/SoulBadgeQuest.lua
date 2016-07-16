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

local dialogs = {
	questSurfAccept = Dialog:new({ 
		"There is something there I want you to take",
		"Did you get the HM broseph"
	})
}

local SoulBadgeQuest = Quest:new()

function SoulBadgeQuest:new()
	local o = Quest.new(SoulBadgeQuest, name, description, level, dialogs)
	o.zoneExp = 1
	o.pokemonId = 1
	return o
end

function SoulBadgeQuest:isDoable()	
	if self:hasMap() then
		if getMapName() == "Route 15" then 
			if hasItem("Soul Badge") and hasItem("HM03 - Surf") then
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
	if (hasItem("Soul Badge") and hasItem("HM03 - Surf") and getMapName() == "Route 15") or getMapName() == "Safari Entrance" or getMapName() == "Route 20"then
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

function SoulBadgeQuest:canEnterSafari()
	return getMoney() > 5000
	
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
	if not self:canEnterSafari() then
		return moveToMap("Fuchsia City")
	else
		return moveToGrass()
	end
end

function SoulBadgeQuest:FuchsiaCity()
	if game.minTeamLevel() >= 60 then
		return moveToMap("Route 15 Stop House")
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Fuchsia" then
		return moveToMap("Pokecenter Fuchsia")
	elseif isNpcOnCell(13,7) then --Item: PP UP
		return talkToNpcOnCell(13,7)
	elseif isNpcOnCell(12,10) then --Item: Ultra Ball
		return talkToNpcOnCell(12,10)
	elseif self:needPokemart_() and not hasItem("HM03 - Surf") then --It buy balls if not have badge, at blackoutleveling no
		return moveToMap("Safari Stop")
	elseif not self:isTrainingOver() then
		return moveToMap("Route 15 Stop House")
	elseif not hasItem("Soul Badge") then
		return moveToMap("Fuchsia Gym")
	elseif not self:canEnterSafari() then
		return moveToMap("Route 18")	
	elseif not hasItem("HM03 - Surf") then
		if not dialogs.questSurfAccept.state then
			return moveToMap("Fuchsia City Stop House")
		else
			return moveToMap("Safari Stop")
		end
	else
		return moveToMap("Fuchsia City Stop House")
	end
end

function SoulBadgeQuest:SafariStop()
	if self:needPokemart_() then
		self:pokemart_()
	elseif hasItem("Soul Badge") and dialogs.questSurfAccept.state then
		if not hasItem("HM03 - Surf") and self:canEnterSafari() then
			return talkToNpcOnCell(7,4)
		else
			return moveToMap("Fuchsia City")
		end
	else
		return moveToMap("Fuchsia City")
	end
end

function SoulBadgeQuest:Route15StopHouse()
	if game.minTeamLevel() >= 60 then
		return moveToMap("Route 15")
	elseif self:needPokecenter() or not self.registeredPokecenter == "Pokecenter Fuchsia" or self:isTrainingOver() then
		return moveToMap("Fuchsia City")
	elseif hasItem("HM03 - Surf") then
		return moveToMap("Route 15")
	elseif not self:isTrainingOver() then
		self.zoneExp = math.random(1,4)
		return moveToMap("Route 15")
	else
		return moveToMap("Route 15")
	end
end

function SoulBadgeQuest:FuchsiaCityStopHouse()
	if game.minTeamLevel() >= 60 then
		return moveToMap("Fuchsia City")
	elseif not hasItem("HM03 - Surf") then
		if dialogs.questSurfAccept.state then
			return moveToMap("Fuchsia City")
		else
			return moveToMap("Route 19")
		end
	else
		return moveToMap("Route 19")
	end
end

function SoulBadgeQuest:Route19()
	if game.minTeamLevel() >= 60 then
		return moveToMap("Fuchsia City Stop House")
	elseif hasItem("HM03 - Surf") then
		if not game.hasPokemonWithMove("Surf") then
			if self.pokemonId < getTeamSize() then					
				useItemOnPokemon("HM03 - Surf", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM03 - Surf")
				self.pokemonId = self.pokemonId + 1
			else
				fatal("No pokemon in this team can learn - Surf")
			end
		else
			return moveToMap("Route 20")
		end
	else
		if dialogs.questSurfAccept.state then
			return moveToMap("Fuchsia City Stop House")
		else
			return talkToNpcOnCell(33,19)
		end
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
