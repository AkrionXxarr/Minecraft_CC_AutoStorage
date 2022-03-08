local requests = {
 network_ids = function(_, _, common)
  common.log("Request network_ids")
  
  return common.network_ids
 end
}

return requests
