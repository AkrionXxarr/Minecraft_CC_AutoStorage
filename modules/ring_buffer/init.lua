local ring_buffer = {
 push = function(self, element)
  self.buffer[self.front + 1] = element
  self.front = bit.band(
   self.front + 1,
   self.mask
  )
 end,
 
 get = function(self)
  local buffer = {}
  
  for i = 0, self.mask do
   local index = bit.band(
    self.front + i,
    self.mask
   )
   
   local element = self.buffer[index + 1]
   if element then
    table.insert(buffer, element)
   end
  end
  
  return buffer
 end
}

local meta = {
  __index = ring_buffer
}

local function new(size)
 assert(
  size > 0,
  string.format(
   "Size must be greater than 0 (was %d)",
   size
  )
 )
 
 local mask = size - 1
 assert(
  bit.band(size, mask) == 0,
  string.format(
   "Size must be a power of 2 (was %d)",
   size
  )
 )
 
 return setmetatable({
   buffer = {},
   front = 0,
   mask = mask
  },
  meta
 )
end

return { new = new }
