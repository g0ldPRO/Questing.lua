-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

name = "Questing"
author = "g0ld"
description = [[Everything.]]

dofile "config.lua"

local QuestManager
local questManager = nil

function onStart()
	math.randomseed(os.time())
	QuestManager = require "Quests/QuestManager"
	questManager = QuestManager:new()
end

function onPause()
	questManager:pause()
end

function onResume()
end

function onStop()
end

function onPathAction()
	questManager:path()
	if questManager.isOver then
		return fatal("No more quest to do. Script terminated.")
	end
end

function onBattleAction()
	questManager:battle()
end

function onDialogMessage(message)
	questManager:dialog(message)
end

function onBattleMessage(message)
	questManager:battleMessage(message)
end

function onSystemMessage(message)
	questManager:systemMessage(message)
end

function onLearningMove(moveName, pokemonIndex)
	questManager:learningMove(moveName, pokemonIndex)
end