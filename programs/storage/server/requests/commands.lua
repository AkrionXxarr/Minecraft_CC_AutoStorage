local requests = {
 input_status = function(aki_net, common)
  local inv = peripheral.find("inventory")
  return #inv.list() ~= 0
 end
}

return requests
