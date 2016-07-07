-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: By Rympe 

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'SS-Anne Quest: '
local description = 'Route 5 to Vermilion City'
local level       = 27

local TrashBin1Kitchen = false
local TrashBin2Kitchen = false
local TrashBin3Kitchen = false
local TrashBin1Ballroom = false
local TrashBin2Ballroom = false
local TrashBin3Ballroom = false
local TrashBinLeftovers = false

local dialogs = {
	PsychicWadePart2 = Dialog:new({ 
		"hurry up and tell him that"
	}),
	NeedRegisterTicket = Dialog:new({ 
		"pc is already registered to your"
	}),
	PcGetRegisterDone = Dialog:new({ 
		"welcome aboard to"
	}),
	RegisterTicketDone = Dialog:new({ 
		"enjoy your passengership on the"
	}),
	NeedPharmacist = Dialog:new({ 
		"did you speak to the pharmacist"
	}),
	TrashBinCheck = Dialog:new({ 
		"is empty"
	}),
	PharmacistWorking = Dialog:new({ 
		"explore the ballroom for now"
	}),
	KitchenDone = Dialog:new({ 
		"that the captain is cured in a timely fashion"
	})
}

local SSAnneQuest = Quest:new()

function SSAnneQuest:new()
	return Quest.new(SSAnneQuest, name, description, level, dialogs)
end

function SSAnneQuest:isDoable()
	if not hasItem("HM01 - Cut") and self:hasMap() then
		return true
	end
	return false
end

function SSAnneQuest:isDone()
	if hasItem("HM01 - Cut") and getMapName() == "Vermilion City" then
		return true
	else
		return false
	end
end

function SSAnneQuest:Route5() 
	return moveToMap("Underground House 1")
end

function SSAnneQuest:UndergroundHouse1()
	return moveToMap("Underground2")
end

function SSAnneQuest:Underground2()
	return moveToMap("Underground House 2")
end

function SSAnneQuest:UndergroundHouse2()
	return moveToMap("Route 6")
end

function SSAnneQuest:Route6()
	if isNpcOnCell(31, 5) then -- Berry 1
		return talkToNpcOnCell(31, 5)
	elseif isNpcOnCell(32, 5) then -- Berry 2
		return talkToNpcOnCell(32, 5)
	elseif isNpcOnCell(37, 5) then -- Berry 3
		return talkToNpcOnCell(37, 5)
	elseif isNpcOnCell(38, 5) then -- Berry 4
		return talkToNpcOnCell(38, 5)
	elseif not dialogs.PsychicWadePart2.state and isNpcOnCell(24, 54) then -- Check Psychic Wade Exist and Talk
		return talkToNpcOnCell(24, 54)
	else
		return moveToMap("Vermilion City")
	end
end

function SSAnneQuest:VermilionCity2()
	return talkToNpcOnCell(44, 30)
end

function SSAnneQuest:PokecenterVermilion()
	self:pokecenter("Vermilion City")
end

function SSAnneQuest:SSAnneBasement()
	return moveToMap("SSAnne 1F")
end

function SSAnneQuest:SSAnne2FRoom6()
	if dialogs.PharmacistWorking.state then
		return moveToMap("SSAnne 2F")
	else
		return talkToNpcOnCell(9,9)
	end
end

function SSAnneQuest:SSAnne2FCaptainRoom()
	if hasItem("SecretPotion") and not hasItem("HM01 - Cut") then
		return talkToNpcOnCell(5,4)
	else
		return moveToMap("SSAnne 2F")
	end
end

function SSAnneQuest:BallroomSSAnne()
	if isNpcOnCell(2,20) then
		if isNpcOnCell(20, 33) and not TrashBin1Ballroom then -- Item: Leppa Berry			
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(20, 33)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin1Ballroom = true
				return
			end
		elseif isNpcOnCell(10, 33) and not TrashBin2Ballroom then -- Item: Chesto Berry
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(10, 33)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin2Ballroom = true
				return
			end		
		elseif isNpcOnCell(23, 39) and not TrashBin3Ballroom then -- Item: Oran Berry
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(23, 39)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin3Ballroom = true
				return
			end
		else
			return talkToNpcOnCell(2, 20)
		end
	else
		return moveToMap("SSAnne 3F")
	end
end

function SSAnneQuest:SSAnne3F()
	if not hasItem("SecretPotion") then
		if not hasItem("HM01 - Cut") then
			return moveToMap("Ballroom SS Anne")
		end
	else
		return moveToMap("SSAnne 2F")
	end
end

function SSAnneQuest:SSAnne2F()
	if hasItem("SecretPotion") then
		if isNpcOnCell(26, 4) then
			return talkToNpcOnCell(26,4)
		else
			return moveToMap("SSAnne 2F Captain Room")
		end
	elseif not hasItem("HM01 - Cut") then
		if dialogs.PharmacistWorking.state then
			return moveToMap("SSAnne 3F")				
		else
			if isNpcOnCell(28, 18) and not TrashBinLeftovers then -- Item: LeftOvers
				if not dialogs.TrashBinCheck.state then
					return talkToNpcOnCell(28, 18)
				else
					dialogs.TrashBinCheck.state = false
					TrashBinLeftovers = true
					return
				end
			else
				return moveToMap("SSAnne 2F Room6")
			end
		end
	else
		return moveToMap("SSAnne 1F")
	end
end

function SSAnneQuest:SSAnne1F()
	if hasItem("SecretPotion") then
		return moveToMap("SSAnne 2F")
	elseif not hasItem("HM01 - Cut") then
		if dialogs.RegisterTicketDone.state then
			if dialogs.NeedPharmacist.state or dialogs.KitchenDone.state then
				return moveToMap("SSAnne 2F")
			else
				return moveToMap("SSAnne 1F Kitchen")
			end
		else
			return talkToNpcOnCell(16,3)
		end
	else
		return moveToMap("Vermilion City")
	end
end

function SSAnneQuest:SSAnne1FKitchen()
	if dialogs.NeedPharmacist.state or dialogs.KitchenDone.state then
		return moveToMap("SSAnne 1F")
	--elseif then	
	else
		-- GET ITEMS CHECK
		if isNpcOnCell(14, 7) and not TrashBin1Kitchen then -- Item: Great Ball			
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 7)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin1Kitchen = true
				return
			end
		elseif isNpcOnCell(14, 9) and not TrashBin2Kitchen then -- Item: Pecha Berry - [Mission Pharmacist]
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 9)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin2Kitchen = true
				return
			end		
		elseif isNpcOnCell(14, 11) and not TrashBin3Kitchen then -- Item: Hyper Potion
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 11)
			else
				dialogs.TrashBinCheck.state = false
				TrashBin3Kitchen = true
				return
			end
		else
			return talkToNpcOnCell(5, 3)
		end
	end
end

function SSAnneQuest:SSAnneBasementRoom5()
	if isNpcOnCell(5, 10) then
		if dialogs.NeedRegisterTicket.state then -- Complete the Register on Left-PC and Exit
			if not dialogs.PcGetRegisterDone.state then
				return talkToNpcOnCell(6, 3)
			else
				return talkToNpcOnCell(5, 10)
			end
		else
			return talkToNpcOnCell(5, 10)
		end
	else
		return moveToMap("SSAnne Basement")
	end
end

function SSAnneQuest:VermilionCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Vermilion" then
		return moveToMap("Pokecenter Vermilion")
	elseif not dialogs.PsychicWadePart2.state and isNpcOnCell(38, 63) then
		return moveToMap("Route 6")
	elseif dialogs.PsychicWadePart2.state and isNpcOnCell(38, 63) then -- Already Talk with Psychic Wade and need Talk with Surge
		return talkToNpcOnCell(38, 63)
	elseif not hasItem("HM01 - Cut") then -- Need do SSanne Quest
		return moveToCell(40, 67) -- Enter on SSAnne
	else
		return
	end
end

return SSAnneQuest
