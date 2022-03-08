local Queue = require(".modules.queue")
local ID = require(".modules.id")

local function format_network_message(msg)
 return string.format(
  "[%s*%s] **%s**",
  msg.type,
  msg.proc,
  textutils.serialise(msg.payload,{compact = true})
 )
end

local aki_net = {
 start = function(self, f)
  assert(type(f) == "function")
  self.active = true
  
  self.log.general(
   "Starting AkiNet.\n",
   "  Protocol: ", self.protocol
  )
  
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
   if id and msg and msg.type and msg.proc then
    self.log.comm(
     "RECV << ",
     format_network_message(msg)
    )
    
    self.msg_queue:enqueue({id = id, msg = msg})
   end
  end
 end,
 
 broadcast = function(
  self,
  proc,
  payload
 )
  local msg = {
   type = "NFY",
   proc = proc,
   payload = payload
  }
 
  self.log.comm(
   "BROADCAST >> ",
   format_network_message(msg)
  )
 
  rednet.broadcast(msg, self.protocol)
 end,
 
 send_request = function(
   self,
   target,
   proc, 
   payload, 
   callback
 )
  local ticket = self.tickets:get()
  local msg = {
   type = "REQ", 
   proc = proc, 
   payload = payload,
   ticket = ticket
  }
  
  self:send_message(target, msg)
  self.pending_requests[ticket] = {
   callback = callback,
   proc = proc
  }
 end,
 
 send_reply = function(
   self, 
   target,
   proc,
   payload,
   ticket
 )
  local msg = {
   type = "REP", 
   proc = proc, 
   payload = payload,
   ticket = ticket
  }
  self:send_message(target, msg)
 end,
 
 send_notify = function(
   self, 
   target, 
   proc, 
   payload
 )
  local msg = {
   type = "NFY", proc = proc, payload = payload
  }
  self:send_message(target, msg)
 end,
 
 send_message = function(self, target, msg)
  self.log.comm(
   "SEND >> ", 
   format_network_message(msg)
  )
  rednet.send(target, msg, self.protocol)
 end,
 
 register_handler = 
 function(self, type, proc, f, ...)
  assert(
   self.handlers[type][proc] == nil,
   string.format(
    "A handler for: (%s, %s) already exists",
    type, proc
   )
  )
  self.log.general(string.format(
   "Registering handler: [%s] -> [%s]",
   type, proc
  ))
  self.handlers[type][proc] = {
   f = f,
   args = {...}
  }
 end,
  
 process = function(self)
  local entry = self.msg_queue:dequeue()
  while entry do
   local id = entry.id
   local type = entry.msg.type
   local proc = entry.msg.proc
   local payload = entry.msg.payload
   local ticket = entry.msg.ticket
   
   local handler = self:get_handler(type, proc)
   handler.args = handler.args or {}
   handler.f = handler.f or function()
    local msg = {
     type = type,
     proc = proc,
     payload = payload
    }
    self.log.comm(
     textutils.serialise(msg, {compact=true})
    )
    --self:send_notify(id, "_unsupported", msg)
   end
   
   if type == "REP" then
    -- Requests can be provided with a callback
    -- that replies would be sent to instead of
    -- the handler.
    local request = self.pending_requests[ticket]
    handler.f = request.callback or handler.f
    
    self.pending_requests[ticket] = nil
    self.tickets:free(ticket)
   end
   
   local res = handler.f(
    payload,
    self,
    unpack(handler.args)
   )
   if type == "REQ" then
    -- Requests must be replied to
    self:send_reply(id, proc, res, ticket) 
   end
   
   entry = self.msg_queue:dequeue()
  end
 end,
 
 get_handler = function(self, type, proc)
  local handler = self.handlers[type]
  handler = handler or {}
  handler = handler[proc]
  handler = handler or {}
  return handler
 end
}

local meta = {
 __index = aki_net,
 __start = aki_net.start,
 __stop = aki_net.stop,
 __listener = aki_net.listener,
 __broadcast = aki_net.broadcast,
 __send_request = aki_net.send_request,
 __send_notify = aki_net.send_notify,
 __send_message = aki_net.send_message,
 __register_handler = aki_net.register_handler,
 __process = aki_net.process
}

local function new(protocol, logger, verbose)
 local general, comm, error
 if logger then
  general = logger:create_channel(
   "_aki_net", "(AkiNet: Log)\n  "
  )
  comm = logger:create_channel(
   "_aki_net_comm", "(AkiNet: Comm)\n  "
  )
  error = logger:create_channel(
   "_aki_net_error", "<AkiNet: Error>\n  ",
   function(msg)  printError(msg) end
  )
  
  logger.echo._aki_net = true
  logger.echo._aki_net_comm = verbose
  logger.echo._aki_net_error = true
 end
 
 local obj = setmetatable({ 
   msg_queue = Queue.new(),
   pending_requests = {},
   handlers = { 
    REQ = {}, 
    REP = {}, 
    NFY = {}
   },
   active = false,
   protocol = protocol,
   tickets = ID.new(256),
   log = {
    _logger = logger,
    general = general or print,
    comm = comm or function() end,
    error = error or printError
   }
  }, 
  meta
 )
 
 obj:register_handler(
  "NFY", "_unsupported", unsupported_handler
 )
 
 peripheral.find("modem", rednet.open)
 
 return obj
end

return { new = new }
