local id = {
 get = function(self)
  local id = table.remove(self.free_ids)
  self.assigned_ids[id] = true
  return id
 end,
 
 free = function(self, id)
  assert(
   self.assigned_ids[id],
   "Attempted to free unassigned id: " .. id
  )
  table.insert(self.free_ids, id)
  self.assigned_ids[id] = false
 end
}

local meta = {
 __index = id,
 __get = id.get,
 __free = id.free
}

local function new(size)
 local ids = {}
 for i = 1, size do
  table.insert(ids, i)
 end
 return setmetatable({
   free_ids = ids,
   assigned_ids = {},
   size = size
  },
  meta
 )
end

return { new = new }
