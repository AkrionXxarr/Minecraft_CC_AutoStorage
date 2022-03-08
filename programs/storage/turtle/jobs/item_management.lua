-- Item Management jobs
function pull_all_items(jobs, app_data)
 app_data.log("Job: pull_all_items")
 
 while turtle.suck() do end
end

function push_slots(jobs, app_data, slots)
 app_data.log("Job: push_slots")
 
 for _, slot in pairs(slots) do
  turtle.select(slot)
  turtle.drop()
 end
end

function query_items(jobs, app_data)
 app_data.log("Job: query_items")
 
 -- Build a list of items
 local inv_items = {}
 for i = 1,16 do
  local details = turtle.getItemDetail(i, true)
  if details and details.maxCount > 1 then
   local name = details.name
   --local count = details.count
   
   local entry = inv_items[name]
   if not entry then
    entry = { 
     --count = 0,
     slots = {}
    }
    inv_items[name] = entry
   end
   --entry.count = entry.count + count
   table.insert(entry.slots, i)
  end
 end
 
 local callback = function(reply)
  local rep_items = {}
  local aisle_count = 
   #app_data.config.positions.aisle
  for aisle = 1, aisle_count do
   if reply[aisle] then 
    -- Server has responded with all the
    -- item storage locations
    for key, value in pairs(reply[aisle]) do
     assert(
      aisle == value.aisle,
      "Value not in correct aisle?"
     )
     if not rep_items[aisle] then
      rep_items[aisle] = {}
     end
    
     table.insert(rep_items[aisle], {
      position = value.position,
      cardinal = value.cardinal,
      aisle = aisle,
      slots = inv_items[key].slots
     })
    end
   end
  end
  
  jobs:attach(
   sort_items_by_distance, rep_items
  )
  jobs:attach(
   store_items, rep_items
  )
 end
 
 -- Send list to server for storage locations
 app_data.aki_net:send_request(
  app_data.common.network_ids.server,
  "item_locations",
  inv_items,
  callback
 )
end 

function sort_items_by_distance(
  jobs,
  app_data,
  items
)
 app_data.log("Job: sort_items_by_distance")
 local aisle_count = 
  #app_data.config.positions.aisle
 
 for aisle = 1, aisle_count do
  if items[aisle] then
   app_data.log("Sorting aisle: ", aisle)
   local t_pos = 
    app_data.config.positions.aisle[aisle]
   -- t_pos is just a table, so make it a vector
   t_pos = vector.new(t_pos.x, t_pos.y, t_pos.z)
  
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
    
    return l_len < r_len
   end
   
   table.sort(items[aisle], sort)
  end
 end
end

function store_items(jobs, app_data, items)
 app_data.log("Job: store_items")
 local aisle_count = 
  #app_data.config.positions.aisle
 
 for aisle = 1, aisle_count do
  if items[aisle] then
   app_data.log("Storing aisle: ", aisle)
   jobs:attach(
    move_to, app_data.config.positions.aisle[aisle]
   )
  
   for _, item in ipairs(items[aisle]) do
    jobs:attach(move_to, item.position)
    jobs:attach(face_cardinal, item.cardinal)
    jobs:attach(push_slots, item.slots)
   end
 
   jobs:attach(
    move_to, app_data.config.positions.aisle[aisle]
   )
  end
 end
  
 jobs:attach(
  move_to, app_data.config.positions.overflow
 )
 jobs:attach(
  face_cardinal, 
  app_data.config.directions.overflow
 )
 jobs:attach(dump_excess) 
end

function dump_excess(jobs, app_data)
 app_data.log("Job: dump_excess")
 
 for i = 1, 16 do
  turtle.select(i)
  turtle.drop()
 end
 
 app_data.aki_net:send_notify(
  app_data.common.network_ids.server,
  "save_database"
 )
 
 app_data.aki_net:send_request(
  app_data.common.network_ids.server,
  "input_status",
  nil,
  function(has_items)
   if has_items then
    jobs:attach(retrieve_input)
   else
    jobs:attach(return_idle)
   end
  end
 )
end
