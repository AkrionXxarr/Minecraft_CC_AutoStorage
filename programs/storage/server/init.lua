local Database = require(".modules.database").new()

local save_path = "./storage.db"

local input = peripheral.find("inventory")
local was_empty = false

local function tick(aki_net, common)
 local turtle = common.network_ids.storage_turtle
 
 if turtle and input then
  local input_has_items = #input.list() ~= 0
  if input_has_items and was_empty then
   was_empty = false
   -- Sent notification
   
   aki_net:send_notify(
    turtle, "input_filled", nil
   )
  
  elseif not input_has_items then
   was_empty = true
  end
 end
end

local function init(aki_net, common)
 rednet.host(common.protocol, common.server_name)
 local result, msg = Database:load(save_path)
 if not result then
  common.log_error(msg)
 end
 return { 
  tick = tick, 
  app_data = {
   database = Database,
   save_path = save_path
  }
 }
end

return { init = init }
