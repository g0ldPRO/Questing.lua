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

function sys.error(functionName, message)
	fatal("error: " .. functionName .. ": " .. message)
	return false
end

function sys.assert(test, functionName, message)
	if not test then
		fatal("error: " .. functionName .. ": " .. message)
		return false
	end
	return true
end

function sys.stringContains(haystack, needle)
	haystack = string.upper(haystack)
	needle   = string.upper(needle)
	if string.find(haystack, needle) ~= nil then
		return true
	end
	return false
end

function sys.removeCharacter(str, character)
	return str:gsub("%" .. character .. "+", "")
end

function sys.tableHasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

return sys
