local Error = require(".modules.error")

local local_pos = vector.new(0, 0, 0)
local forward = vector.new(0, 0, -1)
local up = vector.new(0, 1, 0)

local cardinal_directions = {
  north = vector.new( 0, 0, -1),
  east  = vector.new( 1, 0,  0),
  south = vector.new( 0, 0,  1),
  west  = vector.new(-1, 0,  0)
}

local function move(count, f, dir)
  for i=1,count do
    local result, msg = f()
    
    if not result then
      return result, msg
    end
    
    local_pos = local_pos + dir
  end
  
  return true
end

local function move_forward(count)
  local dir = forward
  local f = turtle.forward
  
  if count < 0 then
    count = math.abs(count)
    dir = -dir
    f = turtle.back
  end
  
  return move(count, f, dir)
end

local function move_back(count)
  local dir = -forward
  local f = turtle.back
  
  if count < 0 then
    count = math.abs(count)
    dir = -dir
    f = turtle.forward
  end
  
  return move(count, f, dir)
end 

local function move_up(count)
  local dir = up
  local f = turtle.up
  
  if count < 0 then
    count = math.abs(count)
    dir = -dir
    f = turtle.down
  end
  
  return move(count, f, dir)
end

local function move_down(count)
  local dir = -up
  local f = turtle.down
  
  if count < 0 then
    count = math.abs(count)
    dir = -dir
    f = turtle.up
  end
  
  return move(count, f, dir)
end

local function turn(count, right)
  local f
  if right then f = turtle.turnRight
  else f = turtle.turnLeft end
  
  for i=1,count do
    local result, msg = f()
    
    if not result then
      return result, msg
    end
    
    local x = forward.x
    local z = forward.z
    
    if right then forward = vector.new(-z, 0, x)
    else forward = vector.new(z, 0, -x)
    end
  end
  
  return true
end

local function turn_right(count)
  return turn(count, true)
end

local function turn_left(count)
  return turn(count, false)
end

local function turn_towards_cardinal(cardinal)
  if type(cardinal) ~= "string" then
    local err = Error.new("Invalid Type")
      .reason("Cardinal type was: " .. type(cardinal))
      .description("Cardinal type must be string")
      .build()
    
    return false, err   
  end

  cardinal = string.lower(cardinal)
  local cdir = cardinal_directions[cardinal]
  if cdir == nil then
    local err = Error.new("Invalid Cardinal")
      .reason("Cardinal was: " .. cardinal)
      .description("Valid cardinals are:")
      .description("North, East, South, West")
      .build()
      
      return false, err
  end
  
  if forward == cdir then return true end
  
  -- Turn 180
  if forward.x == 0 and cdir.x == 0 or
     forward.z == 0 and cdir.z == 0 then
     
     return turn_right(2)
  end 
  
  local cross = forward.x * cdir.z - forward.z * cdir.x
  if cross < 0 then
    return turn_left(1)
  else
    return turn_right(1)
  end 
end

local function get_local_position()
  return vector.new(
    local_pos.x,
    local_pos.y,
    local_pos.z
  )
end

local function get_forward()
  return vector.new(
    forward.x,
    forward.y,
    forward.z
  )
end

local function get_cardinal()
  if forward.x == -1 then return "west" end
  if forward.x == 1 then return "east" end
  if forward.z == -1 then return "north" end
  if forward.z == 1 then return "south" end
end

local function reset_local_position()
  local_pos = vector.new(0, 0, 0)
end

local function reset_forward()
  forward = vector.new(0, 0, -1)
end

local extern = {
  move_forward = move_forward,
  move_back = move_back,
  move_up = move_up,
  move_down = move_down,
  
  turn_right = turn_right,
  turn_left = turn_left,
  turn_towards_cardinal = turn_towards_cardinal,
  
  get_local_position = get_local_position,
  get_forward = get_forward,
  get_cardinal = get_cardinal,
  
  reset_local_position = reset_local_position,
  reset_forward = reset_forward,
}

return extern
