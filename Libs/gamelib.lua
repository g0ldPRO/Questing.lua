-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local game = {}

local sys = require("Libs/syslib")

function game.isTeamFullyHealed()
	for pokemonId=1, getTeamSize(), 1 do
		if getPokemonHealthPercent(pokemonId) < 100
			or not isPokemonUsable(pokemonId) then
			return false
		end
	end
	return true
end

function game.isPokemonFullPP(pokemonId)
	sys.todo("add getPokemonMoves() to PROShine")
	error("waiting for proshine update")
	return true
end

local function returnSorted(valueA, valueB)
	if valueA > valueB then
		return valueB, valueA
	end
	return valueA, valueB
end

function game.inRectangle(x1, y1, x2, y2)
	local aX, bX = returnSorted(x1, x2)
	local aY, bY = returnSorted(y1, y2)
	local x = getPlayerX()
	local y = getPlayerY()
	if aX <= x and x <= bX and aY <= y and y <= bY then
		return true
	end
	return false
end

function game.minTeamLevel()
	local current
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  current == nil or pokemonLevel < current then
			current = pokemonLevel
		end
	end
	return current
end

function game.maxTeamLevel()
	local current
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  current == nil or pokemonLevel > current then
			current = pokemonLevel
		end
	end
	return current
end

function game.getMaxLevelUsablePokemon()
	local currentId
	local currentLevel
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  (currentLevel == nil or pokemonLevel > currentLevel)
			and isPokemonUsable(pokemonId) then
			currentLevel = pokemonLevel
			currentId    = pokemonId
		end
	end
	return currentId, currentLevel
end

function game.getUsablePokemonCountUnderLevel(level)
	local count = 0
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  pokemonLevel < level
			and isPokemonUsable(pokemonId) then
			count = count + 1
		end
	end
	return count
end
	
return game