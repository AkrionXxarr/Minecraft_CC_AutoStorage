local commands = {
}

local function tick(aki_net, common)
 io.flush()
 
 print("Target:")
 local input = io.read()
 input = string.lower(input)
 local target = common.network_ids[input]
 if target then
  print("Command:")
  input = io.read()
  input = string.lower(input)
  
  aki_net:send_notify(
   target,
   input,
   nil
  )
 else
  print("Target not recognized.")
  print("Valid targets:")
  print(textutils.serialise(common.network_ids))
 end

end

local function init(aki_net, common)
 return { tick = tick }
end

return { init = init }
