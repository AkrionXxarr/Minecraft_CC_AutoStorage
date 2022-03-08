local queue = {
  is_empty = function(self)
   return self.back == 0
  end,
  
  enqueue = function(self, element)
    table.insert(self.queue, element)
  end,

  dequeue = function(self)
    return table.remove(self.queue, 1)
  end,
  
  flush = function()
   self.queue = {}
  end
}

local queue_meta = {
  __index = queue,
  __is_empty = queue.is_empty,
  __enqueue = queue.enqueue,
  __dequeue = queue.dequeue
}

local function new()
  return setmetatable(
   { queue = {} },
   queue_meta
  )
end

local function from(q)
  assert(q.back)
  return setmetatable(q, queue_meta)
end

return { new = new, from = from }
