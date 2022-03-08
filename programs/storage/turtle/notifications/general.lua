local notifications = {
 input_filled = function(
  _, aki_net, common, app_data
 )
  if app_data.states.idle then
   app_data.jobs:attach(retrieve_input)
  end
 end,
 
 rebuild_storage_database = function(
  _, _, _, app_data
 )
  app_data.jobs:attach(rebuild_storage_database)
 end
}

return notifications
