local notifications = {
 save_database = function(
  data, aki_net, common, app_data
 )
  app_data.database:save(app_data.save_path)
 end,
 
 set_database = function(
  data, aki_net, common, app_data
 )
  common.log("Notify set_database")
  
  local db = app_data.database
  local empty = {}
  
  db:clear()
  
  for _, value in pairs(data.storage) do
   local entry = {
    position = value.position,
    cardinal = value.cardinal,
    aisle = value.aisle
   }
   
   if value.name then
    db:add(value.name, entry)
   else
    table.insert(empty, entry)
   end
  end
  
  local t_pos = vector.new(
   data.input.x,
   data.input.y,
   data.input.z
  )
  
  local sort = function(l, r)
   local l_pos = l.position
   local r_pos = r.position
   
   local l_vec = l_pos - t_pos
   local r_vec = r_pos - t_pos
   
   -- Use the squared length to avoid sqrt
   local l_len =
    l_vec.x * l_vec.x +
    l_vec.y * l_vec.y +
    l_vec.z * l_vec.z

   local r_len =
    r_vec.x * r_vec.x +
    r_vec.y * r_vec.y +
    r_vec.z * r_vec.z
   
   return l_len > r_len
  end
  
  table.sort(empty, sort)
  db:add("__empty", empty)
  db:save(app_data.save_path)
 end
}

return notifications
