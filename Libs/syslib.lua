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

return sys
