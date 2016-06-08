-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys = require "Libs/syslib"

local Dialog = {state = false, text = {}}

function Dialog:new(text)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	assert(text ~= nil, "The Dialog constructor expect an array of strings")
	self.state   = false
	self.text    = text
	return o
end

function Dialog:copy(o)
	assert(o ~= nil, "Cannot create a Dialog copy from a nil variable")
	setmetatable(o, self)
	self.__index = self
	assert(text ~= nil, "The Dialog constructor expect an array of strings")
	self.state   = o.state
	self.text    = o.text
	return o
end

function Dialog:messageMatch(message)
	for key, text in pairs(self.text) do
		if stringContains(message, text) then
			return true
		end
	end
	return false
end

return Dialog
