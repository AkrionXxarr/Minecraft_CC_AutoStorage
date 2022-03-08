local requests = {
 item_locations = function(
  items, aki_net, common, app_data
 )
   common.log("Request item_locations")
 
   local db = app_data.database
   local empty = db:fetch("__empty")
         
   local reply = {}
   for key, _ in pairs(items) do
     local entry = db:fetch(key)
     if not entry then
       entry = table.remove(empty)
       if entry then db:add(key, entry) end
     end
     
     if entry then
       if not reply[entry.aisle] then
        reply[entry.aisle] = {}
       end
       reply[entry.aisle][key] = entry
     end
   end
  
   return reply
 end
}

return requests
