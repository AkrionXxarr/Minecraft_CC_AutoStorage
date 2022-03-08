local Queue = require(".modules.queue")

local rednet_queue = {
 start = function(self, f)
  assert(type(f) == "function")
  self.active = true
  
  print("Starting rednet queue.")
  
  parallel.waitForAny(
   function() self:listener() end,
   function() f(self)  end
  )
 end,
 
 stop = function(self)
  self.active = false
 end,
 
 listener = function(self)
  while self.active do
   local id, msg = rednet.receive(protocol)
   if id ~= nil then
    self.queue:enqueue({id = id, msg = msg})
   end
  end
 end,
 
 process = function(self)
  local entry = self.queue:dequeue()
  while entry do
   self.handler(entry.id, entry.msg)
   entry = self.queue:dequeue()
  end
 end
 
 flush = function(self)
  self.queue:flush()
 end
}

local meta = {
 __index = rednet_queue,
 __start = rednet_queue.start,
 __stop = rednet_queue.stop,
 __listener = rednet_queue.listener,
 __process = rednet_queue.process_queue
}

local function new(handler, protocol)
 return setmetatable(
  { 
   queue = Queue.new(),
   active = false,
   protocol = protocol,
   handler = handler
  }, 
  meta
 )
end

return { new = new }
