-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys   = require "Libs/syslib"

local Quest = {}

function Quest:new(name, description, dialogs)
	local o = {}
	setmetatable(o, self)
	self.__index     = self
	o.name        = name
	o.description = description
	o.maps        = {}
	o.dialogs     = dialogs
	return o
end

function Quest:isDoable()
	error("function 'isDone' is not overloaded")
	return nil
end

function Quest:isDone()
	return self:isDoable() == false
end

function Quest:message()
	return self.name .. ': ' .. self.description
end

function Quest:path()
	local mapName = getMapName()
	assert(self.maps[mapName] ~= nil, self.name .. " quest has no method for map: " .. mapName)
	self.maps[mapName](self)
	return true
end

function Quest:battle()
	sys.debug(name .. ' quest is using the default battle method')
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return true
		end
	end
	if getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run()
	else
		return run() or attack() or sendUsablePokemon()
	end
end

function Quest:dialog(message)
	if self.dialogs == nil then
		return false
	end
	for _, dialog in pairs(self.dialogs) do
		if dialog:messageMatch(message) then
			dialog.state = true
			return true
		end
	end
	return false
end

return Quest
