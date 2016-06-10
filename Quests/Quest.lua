-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys  = require "Libs/syslib"
local game = require "Libs/gamelib"

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

function Quest:hasMap()
	local mapName = sys.removeCharacter(getMapName(), ' ')
	if self[mapName] then
		return true
	end
	return false
end

function Quest:pokecenter(exitMapName) -- idealy make it work without exitMapName
	self.registeredPokecenter = getMapName()
	sys.todo("add a moveDown() or moveToNearestLink() or getLinks() to PROShine")
	if not game.isTeamFullyHealed() then
		return usePokecenter()
	end
	return moveToMap(exitMapName)
end

-- at a point in the game we'll always need to buy the same things
-- use this function then
function Quest:pokemart(exitMapName)
	return moveToMap(exitMapName)

end

function Quest:message()
	return self.name .. ': ' .. self.description
end

function Quest:path()
	if not isTeamSortedByLevelAscending() then
		return sortTeamByLevelAscending()
	end
	local mapName = getMapName()
	local mapFunction = sys.removeCharacter(mapName, ' ')
	assert(self[mapFunction] ~= nil, self.name .. " quest has no method for map: " .. mapName)
	self[mapFunction](self)
end

function Quest:battle()
	sys.debug(name .. ' quest is using the default battle method')
	if isWildBattle() and (isOpponentShiny() or not isAlreadyCaught()) then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return true
		end
	end
	if isWildBattle() then
		if getTeamSize() == 1 or getUsablePokemonCount() > 1 then
			local opponentLevel = getOpponentLevel()
			local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
			if opponentLevel >= myPokemonLvl then
				local requestedId, requestedLevel = game.getMaxLevelUsablePokemon()
				if requestedId ~= nil and requestedLevel > myPokemonLvl then
					return sendPokemon(requestedId)
				end
			end
			return attack() or sendUsablePokemon() or run()
		else
			return run() or attack() or sendUsablePokemon()
		end
	else
		return attack() or sendUsablePokemon()
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

local hmMoves = {
	"cut",
	"surf",
	"flash"
}

function Quest:learningMove(moveName, pokemonIndex)
	return forgetAnyMoveExcept(hmMoves)
end

return Quest
