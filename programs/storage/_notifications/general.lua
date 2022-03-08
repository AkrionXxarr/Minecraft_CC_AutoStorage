local notifications = {
 register_network_id = function(
   data, aki_net, common, app_data
 )
  common.log("Notify register_network_id")
  
  common.network_ids[data.label] = data.id
  aki_net:broadcast(
   "update_network_ids", common.network_ids
  )
 end,
 
 update_network_ids = function(
  data, aki_net, common, app_data
 )
  common.log("Notify update_network_ids")
  
  common.network_ids = data
 end
}

return notifications
