-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Training for Saffron'
local description = 'Exp in Seafoam'
local level = 60

local ExpForSaffronQuest = Quest:new()

function ExpForSaffronQuest:new()
	return Quest.new(ExpForSaffronQuest, name, description, level)
end

function ExpForSaffronQuest:isDoable()
	if self:hasMap() and not hasItem("Marsh Badge") then
		return true
	end
	return false
end

function ExpForSaffronQuest:canUseNurse()
	return getMoney() > 1500
end

function ExpForSaffronQuest:isDone()
	if getMapName() == "Route 19" or getMapName() == "Pokecenter Fuchsia" then
		return true
	end
	return false
end

function ExpForSaffronQuest:Route20()
	if not self:isTrainingOver() then
		return moveToCell(60,32) --Seafoam 1F
	else
		return moveToMap("Route 19")
	end
end

function ExpForSaffronQuest:Seafoam1F()
	if not self:isTrainingOver() then
		return moveToCell(20,8) --Seafom B1F
	else
		return moveToMap("Route 20")
	end
end

function ExpForSaffronQuest:SeafoamB1F()
	if not self:isTrainingOver() then
		return moveToCell(64,25) --Seafom B2F
	else
		return moveToCell(15,12)
	end
end

function ExpForSaffronQuest:SeafoamB2F()
	if isNpcOnCell(67,31) then --Item: TM13 - Ice Beam
		return talkToNpcOnCell(67,31)
	end
	if not self:isTrainingOver() then
		return moveToCell(63,19) --Seafom B3F
	else
		return moveToCell(51,27)
	end
end

function ExpForSaffronQuest:SeafoamB3F()
	if not self:isTrainingOver() then
		return moveToCell(57,26) --Seafom B4F
	else
		return moveToCell(64,16)
	end
end

function ExpForSaffronQuest:SeafoamB4F()
	if isNpcOnCell(57,20) then --Item: Nugget (15000 Money)
		return talkToNpcOnCell(57,20)
	end
	if not self:isTrainingOver() then
		if self:needPokecenter() then
			if self:canUseNurse() then -- if have 1500 money
				return talkToNpcOnCell(59,13)
			else
				return fatal("not enough money for continue exp (minium 1500 money)")
			end
		else
			return moveToRectangle(50,10,62,32)
		end
	else
		return moveToCell(53,28)
	end
end

return ExpForSaffronQuest
