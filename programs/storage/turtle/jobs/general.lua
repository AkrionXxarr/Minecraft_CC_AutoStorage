function check_input_status(jobs, app_data)
 app_data.log("Job: check_input_status")
 
 app_data.aki_net:send_request(
  app_data.common.network_ids.server,
  "input_status",
  nil,
  function(has_items)
   if has_items then
    jobs:attach(retrieve_input)
   end
  end
 )
end

function notify_set_database(jobs, app_data, storage)
 app_data.aki_net:send_notify(
  app_data.common.network_ids.server,
  "set_database",
  {
   storage = storage,
   input = app_data.config.positions.input
  }
 )
end
