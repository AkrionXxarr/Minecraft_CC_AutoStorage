local commands = {
 echo = function(msg, aki_net, common)
  common.log(msg)
  return msg 
 end
}

return commands
