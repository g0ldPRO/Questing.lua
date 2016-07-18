-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Exchange Voucher for the Bike'
local description = ' Cerulean City'
local level = 55

local BuyBikeQuest = Quest:new()

function BuyBikeQuest:new()
	return Quest.new(BuyBikeQuest, name, description, level, dialogs)
end

function BuyBikeQuest:isDoable()
	if self:hasMap() and hasItem("Bike Voucher") then
		return true
	end
	return false
end

function BuyBikeQuest:isDone()
	return getMapName() == "Route 5 Stop House"
end

function BuyBikeQuest:Route5()
	if hasItem("Bike Voucher") then
		return moveToCell(13,0)
	else
		return moveToMap("Route 5 Stop House")
	end
end

function BuyBikeQuest:CeruleanCity()
	if hasItem("Bike Voucher") then
		return moveToMap("Cerulean City Bike Shop")
	else
		return moveToMap("Route 5")
	end
end

function BuyBikeQuest:CeruleanCityBikeShop()
	if hasItem("Bike Voucher") then
		return talkToNpcOnCell(11,7)
	else
		return moveToMap("Cerulean City")
	end
end

return BuyBikeQuest
