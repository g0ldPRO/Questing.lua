-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Start'
local description = 'from Start to Pokemon choice, included'

local dialogs = {
	MOM = Dialog:new({
		"Remember that I love you",
		"glad that you dropped by"
	}),
	OAK = Dialog:new({
		"but you can have one",
		"which pokemon do you want"
	})
}

local StartQuest = Quest:new(
	nil,
	name,
	description,
	dialogs
)

function StartQuest:isDoable()
	sys.todo("invalid for Johto: check the zones")
	if getTeamSize() == 0 then
		return true
	end
	return false
end

function StartQuest:Start()
	if isNpcOnCell(21, 38) then
		return talkToNpcOnCell(21, 38)
	end
end

function StartQuest:PlayerBedroomPallet()
	if getTeamSize() == 0 or hasItem("Pokeball") then
		return moveToMap("Player House Pallet")
	else
		if isNpcOnCell(7,3) then
			return talkToNpcOnCell(7,3)
		elseif isNpcOnCell(6,3) then
			return talkToNpcOnCell(6,3)
		else
			assert(false, "No Pokeball in 'Player Bedroom Pallet' nor in bag")
		end
	end
end

function StartQuest:PlayerHousePallet()
	if getTeamSize() == 0 or hasItem("Pokeball") then
		return moveToMap("Link")
	else
		if self.dialogs.MOM == false then
			return talkToNpcOnCell(7,6)
		else
			return moveToMap("Player Bedroom Pallet")
		end
	end
end

function StartQuest:PalletTown()
	return false
end

function StartQuest:OaksLab()
	return false
end

local maps = {
	["Start"]                 = StartQuest.Start,
	["Player Bedroom Pallet"] = StartQuest.PlayerBedroomPallet,
	["Player House Pallet"]   = StartQuest.PlayerHousePallet,
	["Pallet Town"]           = StartQuest.PalletTown,
	["Oaks Lab"]              = StartQuest.OaksLab
}
StartQuest.maps = maps


return StartQuest
