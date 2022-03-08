local stack = {
 is_empty = function(self)
  return self.top == 0
 end,
  
 push = function(self, element)
  table.insert(self.stack, element)
 end,

 pop = function(self)
  return table.remove(self.stack)
 end,
 
 top = function(self)
  return self.stack[table.maxn(self.stack)]
 end,
 
 flush = function(self)
  self.stack = {}
 end
}

local meta = {
 __index = stack,
 __push = stack.push,
 __pop = stack.pop,
 __flush = stack.flush
}

local function new()
 return setmetatable({ stack = {}}, meta)
end

local function from(t)
 return setmetatable(t, stack_meta)
end

return { new = new, from = from }
