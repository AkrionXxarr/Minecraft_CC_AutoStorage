function walk_storage(
 jobs, app_data, storage, aisle
)
 app_data.log("Job: walk_storage")
 
 local ctrl = app_data.controller
 local config = app_data.config
 local y_dir = 1
 local columns = config.storage.columns
 local rows = config.storage.rows
 local aisle_dir = config.directions.aisle[aisle]
 local store_dir = config.directions.storage[aisle]
 local both_sides = config.storage.use_both_sides

 local scan_inv = function()
  local entry = {
   position = ctrl.get_local_position(),
   cardinal = ctrl.get_cardinal(),
   aisle = aisle
  }
  
  if turtle.suck() then
   local details = turtle.getItemDetail()
   entry.name = details.name
   turtle.drop()
  end
  
  table.insert(storage, entry)
 end  
 
 local scan_row = function()
  for row = 1, rows do
   scan_inv()
   if row ~= rows then
    ctrl.move_up(y_dir)
   end
  end
  y_dir = -y_dir
 end
 
 ctrl.turn_towards_cardinal(aisle_dir)
 ctrl.move_forward(1)
 
 turtle.select(1)
 for col = 1, columns do
  ctrl.turn_towards_cardinal(aisle_dir)
  ctrl.move_forward(1)
  ctrl.turn_towards_cardinal(store_dir)
  
  scan_row()
  if both_sides then
   ctrl.turn_right(2)
   scan_row()
  end
 end
end
