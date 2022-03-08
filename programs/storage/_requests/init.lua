local reg_handlers = require(
 "utilities"
).register_handlers

local commands = require("_requests.commands")
local general = require("_requests.general")

local function register(net, com, data)
 local type = "REQ"
 
 reg_handlers(net, com, data, type, commands)
 reg_handlers(net, com, data, type, general)
end

return { register = register }
