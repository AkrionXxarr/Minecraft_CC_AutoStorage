function move_to(
  jobs,
  app_data,
  position
)
 app_data.log(
  "Job: move_to -> ",
  string.format(
   "(x=%d, y=%d, z=%d)",
   position.x, position.y, position.z
  )
 )
 
 local ctrl = app_data.controller
 local vec = position - ctrl.get_local_position()
 
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
 
 -- Move along X
 local result, msg
 if vec.x ~= 0 then
  ctrl.turn_towards_cardinal(x_cardinal)
  result, msg = ctrl.move_forward(
   math.abs(vec.x)
  )
  if not result then 
   app_data.log_error("(Move X) ", msg) 
  end
 end
 
 -- Move along Z
 if vec.z ~= 0 then
  ctrl.turn_towards_cardinal(z_cardinal)
  result, msg = ctrl.move_forward(
   math.abs(vec.z)
  )
  if not result then 
   app_data.log_error("(Move Z) ", msg) 
  end
 end
 
 -- Move along Y
 if vec.y ~= 0 then 
  result, msg = ctrl.move_up(vec.y)
  if not result then
   app_data.log_error("(Move Y) ", msg)
  end
 end
end

function face_cardinal(
  jobs,
  app_data,
  cardinal
)
 app_data.log("Job: face_cardinal")

 app_data.controller.turn_towards_cardinal(
  cardinal
 )
end
