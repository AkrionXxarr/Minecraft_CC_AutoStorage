local Queue = require(".modules.queue")

local job_manager = {
 attach = function(
   self, 
   job,
   ...
 )
  self.job_queue:enqueue({
   func = job,
   args = {...}
  })
 end,
 
 execute = function(self)
  local job = self.job_queue:dequeue()
  if not job then return false end
  
  job.func(
   self,
   self.app_data,
   unpack(job.args)
  )
  return true
 end,
}

local meta = {
  __index = job_manager,
  __attach = job_manager.attach,
  __execute = job_manager.execute
}

local function new(app_data)
 return setmetatable({
   job_queue = Queue.new(),
   app_data = app_data,
   interrupt = false
  },
  meta
 )
end

return { new = new }
