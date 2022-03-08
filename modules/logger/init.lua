local RingBuffer = require(".modules.ring_buffer")

local logger = {
 create_channel = function(
   self,
   name,
   header,
   callback
 )
  callback = callback or function(msg) 
   print(msg) 
  end
  
  table.insert(self.channels, {
   name = name,
   header = header,
   callback = callback
  })
    
  local ch = #self.channels
  return function(msg, ...)
   self:log(ch, msg, ...)
  end, ch
 end,
 
 log = function(self, channel, ...)
  channel = self.channels[channel]
  local echo = self.echo[channel.name]
  local msg = string.format(
   "%s%s", 
   channel.header, 
   table.concat(arg)
  )
  self.buffer:push(msg)
  
  if echo then
   channel.callback(msg)
  end
 end,
 
 save = function(self, path)
  local file, msg = io.open(path, "w")
  assert(file, msg)
  
  local result, msg = file:write(
   table.concat(self.buffer:get(), "\n")
  )
  file:close()
  assert(result, msg)
  
  print("Log saved to: ", path)
 end
}

local meta = {
  __index = logger,
  __create_channel = logger.create_channel,
  __set_echo_level = logger.set_echo_level,
  __log = logger.log,
  __save_log = logger.save_log
}

local function new(size)
 return setmetatable({
   buffer = RingBuffer.new(size),
   channels = {},
   echo = {}
  },
  meta
 )
end

return { new = new }
