local reg_handlers = require(
 "utilities"
).register_handlers

local general = require("requests.general")
local database = require("requests.database")

local function register(net, com, data)
 local type = "REQ"
 
 reg_handlers(net, com, data, type, general)
 reg_handlers(net, com, data, type, database)
end

return { register = register }
