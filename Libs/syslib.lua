local sys = {}

function sys.debug(message)
	if debug then
		log(message)
	end
end

function sys.todo(message)
	if todo then
		log("TODO: " .. message)
	end
end

function sys.stringContains(haystack, needle)
	haystack = string.upper(haystack)
	needle   = string.upper(needle)
	if string.find(haystack, needle) ~= nil then
		return true
	end
	return false
end

function sys.removeCharacter(haystack, char)
	return haystack:gsub(char .. "+", "")
end

return sys
