local reg_handlers = require(
 "utilities"
).register_handlers

local general = require("_notifications.general")

local function register(net, com, data)
 local type = "NFY"
 
 reg_handlers(net, com, data, type, general)
end

return { register = register }
