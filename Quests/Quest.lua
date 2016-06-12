-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys  = require "Libs/syslib"
local game = require "Libs/gamelib"

local blacklist = require "blacklist"

local Quest = {}

function Quest:new(name, description, level, dialogs)
	local o = {}
	setmetatable(o, self)
	self.__index     = self
	o.name        = name
	o.description = description
	o.level       = level or 1
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

function Quest:mapToFunction()
	local mapName = getMapName()
	local mapFunction = sys.removeCharacter(mapName, ' ')
	mapFunction = sys.removeCharacter(mapFunction, '.')
	return mapFunction
end

function Quest:hasMap()
	local mapFunction = self:mapToFunction()
	if self[mapFunction] then
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

function Quest:isTrainingOver()
	if game.minTeamLevel() >= self.level then
		self.healPokemonOnceTrainingIsOver = true
		return true
	end
	return false
end

function Quest:needPokecenter()
	if getTeamSize() == 1 and getPokemonHealthPercent(1) <= 50 then
		return true
	-- else we would spend more time evolving the higher level ones
	elseif not self:isTrainingOver() then
		if getUsablePokemonCount() <= 1
			or game.getUsablePokemonCountUnderLevel(self.level) == 0
		then
			return true
		end
	else
		if not game.isTeamFullyHealed() then
			if self.healPokemonOnceTrainingIsOver then
				return true
			end
		else
			-- the team is healed and we do not need training
			self.healPokemonOnceTrainingIsOver = false
		end
	end
	return false
end

function Quest:message()
	return self.name .. ': ' .. self.description
end

-- I'll need a TeamManager class very soon
local moonStoneTargets = {
	"Clefairy",
	"Jigglypuff",
	"Munna",
	"Nidorino",
	"Nidorina",
	"Skitty"
}

function Quest:evolvePokemon()
	local hasMoonStone = hasItem("Moon Stone")
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonName = getPokemonName(pokemonId)
		if hasMoonStone
			and sys.tableHasValue(moonStoneTargets, pokemonName)
		then
			return useItemOnPokemon("Moon Stone", pokemonId)
		end
	end
	return false
end

function Quest:path()
	if self:evolvePokemon() then
		return true
	end
	if not isTeamSortedByLevelAscending() then
		return sortTeamByLevelAscending()
	end
	local mapFunction = self:mapToFunction()
	assert(self[mapFunction] ~= nil, self.name .. " quest has no method for map: " .. getMapName())
	self[mapFunction](self)
end

function Quest:isPokemonBlacklisted(pokemonName)
	return sys.tableHasValue(blacklist, pokemonName)
end

function Quest:battle()
	sys.debug(name .. ' quest is using the default battle method')
	if isWildBattle() and (isOpponentShiny()
		or (not isAlreadyCaught()) and not self:isPokemonBlacklisted(getOpponentName()))
	then
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
			return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
		end
	else
		return attack() or sendUsablePokemon() or sendAnyPokemon()
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

function Quest:battleMessage(message)
	if sys.stringContains(message, "black out") and self.level < 100 then
		self.level = self.level + 1
		log("Increasing " .. self.name .. " quest level to " .. self.level .. ". Training time!")
		return true
	end
	return false
end

function Quest:systemMessage(message)
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
