local requests = {
 input_status = function(_, aki_net, common)
  common.log("Request input_status")
  
  local inv = peripheral.find("inventory")
  return #inv.list() ~= 0
 end
}

return requests
