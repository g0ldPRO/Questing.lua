-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

name = "Questing"
author = "g0ld"
description = [[Everything.]]

dofile "config.lua"
local sys = require("Libs/syslib")
local QuestManager
local questManager

function onStart()
	math.randomseed(os.time())
	QuestManager = require "Quests/QuestManager"
	questManager = QuestManager:new()
end

function onPathAction()
	questManager:path()
end

function onBattleAction()
	questManager:battle()
end

function onDialogMessage(message)
	questManager:dialog(message)
end