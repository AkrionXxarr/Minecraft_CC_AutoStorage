 -- This function walks the turtle through
 -- some designated storage area and compiles
 -- all items and locations. It finishes by
 -- sending the data to the server.
 -- This will overwrite the database currently
 -- stored by the server
function rebuild_storage_database(jobs, app_data)
 app_data.log("Job: rebuild_storage_database")
 app_data.states.idle = false
 
 local storage = {}
 
 local aisle_count = 
  #app_data.config.positions.aisle
 --jobs:attach(flush_inventory)
 for i = 1, aisle_count do
  app_data.log("Moving to aisle: ", i)
  jobs:attach(
   move_to, app_data.config.positions.aisle[i]
  )
  jobs:attach(walk_storage, storage, i)
  jobs:attach(
   move_to, app_data.config.positions.aisle[i]
  )
 end
 
 jobs:attach(notify_set_database, storage)
 jobs:attach(return_idle)
end

function retrieve_input(jobs, app_data)
 app_data.log("Job: retrieve_input")
 app_data.states.idle = false
 
 jobs:attach(
  move_to, app_data.config.positions.input
 )
 jobs:attach(
  face_cardinal, app_data.config.directions.input
 )
 jobs:attach(pull_all_items)
 jobs:attach(query_items)
end

function return_idle(jobs, app_data)
 app_data.log("Job: return_idle")
 
 jobs:attach(
  move_to, app_data.config.positions.idle
 )
 jobs:attach(
  face_cardinal, app_data.config.directions.idle
 )
 
 app_data.states.idle = true
 
 jobs:attach(check_input_status)
end


