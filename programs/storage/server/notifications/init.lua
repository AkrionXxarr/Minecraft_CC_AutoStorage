local reg_handlers = require(
 "utilities"
).register_handlers

local database = require("notifications.database")

local function register(net, com, data)
 local type = "NFY"
 
 reg_handlers(net, com, data, type, database)
end

return { register = register }
