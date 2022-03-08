local function move_to(ctrl, target)
 local vec = target - ctrl.get_local_position()
    
 local x_cardinal, z_cardinal
 if vec.x > 0 then 
  x_cardinal = "east"
 else
  x_cardinal = "west"
 end 
  
 if vec.z > 0 then
  z_cardinal = "south"
 else
  z_cardinal = "north"
 end

 -- Move along X coordinate
 if vec.x ~= 0 then
  ctrl.turn_towards_cardinal(x_cardinal)
  local result, msg = ctrl.move_forward(
    math.abs(vec.x)
  )
  if not result then return result, msg end
 end
 
 -- Move along Y coordinate
 result, msg = ctrl.move_up(vec.y)
 if not result then return result, msg end
 
 -- Move along Z coordinate
 if vec.z ~= 0 then
  ctrl.turn_towards_cardinal(z_cardinal)
  result, msg = ctrl.move_forward(
    math.abs(vec.z)
  )
  if not result then return result, msg end
 end
  
 return true
end

local extern = {
  move_to = move_to
}

return extern
