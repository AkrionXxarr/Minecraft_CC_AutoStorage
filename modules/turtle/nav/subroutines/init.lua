local subroutines = {
 basic = require(".modules.turtle.nav.subroutines.basic")
}

local function get(...)
 local args = {...}
 local t = {}
 
 for i,arg in ipairs(args) do
  arg = string.lower(arg)
  t[arg] = subroutines[arg]
 end
 
 return t
end

return { get = get }
