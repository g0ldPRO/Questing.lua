-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'SSAnne Quest'
local description = 'Completes the SSAnne'
local level       = 26

local dialogs = {
	NeedRegisterTicket = Dialog:new({ 
		"has been booked in the passenger registry of S.S. Anne!",
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
	return self:hasMap()
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
		if isNpcOnCell(20, 33) and not self.trashBin1Ballroom then -- Item: Leppa Berry
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(20, 33)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin1Ballroom = true
				return
			end
		elseif isNpcOnCell(10, 33) and not self.trashBin2Ballroom then -- Item: Chesto Berry
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(10, 33)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin2Ballroom = true
				return
			end		
		elseif isNpcOnCell(23, 39) and not self.trashBin3Ballroom then -- Item: Oran Berry
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(23, 39)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin3Ballroom = true
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
			if isNpcOnCell(28, 18) and not self.trashBinLeftovers then -- Item: LeftOvers
				if not dialogs.TrashBinCheck.state then
					return talkToNpcOnCell(28, 18)
				else
					dialogs.TrashBinCheck.state = false
					self.trashBinLeftovers = true
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
	else
		-- GET ITEMS CHECK
		if isNpcOnCell(14, 7) and not self.trashBin1Kitchen then -- Item: Great Ball
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 7)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin1Kitchen = true
				return
			end
		elseif isNpcOnCell(14, 9) and not self.trashBin2Kitchen then -- Item: Pecha Berry - [Mission Pharmacist]
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 9)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin2Kitchen = true
				return
			end
		elseif isNpcOnCell(14, 11) and not self.trashBin3Kitchen then -- Item: Hyper Potion
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 11)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin3Kitchen = true
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



return SSAnneQuest
