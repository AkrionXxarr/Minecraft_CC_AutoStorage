local function add(self, key, value)
  if self.database[key] then
    return false, 
      "Entry already exists for: " .. key
  end
  
  self.database[key] = value
  return true
end

local function remove(self, key)
  return self.database:remove(key)
end

local function fetch(self, key)
  local value = self.database[key]
  if not value then
    return nil,
      string.format("No entry found for: %s", key)
  end
  
  return value
end

local function save(self, path)
  local file, msg = io.open(path, "w")
  if not file then
    return false, msg
  end
  
  local result, msg = file:write(
    textutils.serialise(self.database)
  )
  file:close()
  
  if not result then
    return false , msg
  end
  
  return true
end

local function load(self, path)
  local file, msg = io.open(path, "r")
  if not file then
    return false, msg
  end
  
  local result, msg = file:read("a")
  file:close()
  if not result then
    return false, msg
  end
  
  self.database = textutils.unserialize(result)
  
  return true
end

local function clear(self)
  self.database = {}
end

local function print(self)
  print(self.database)
end

local function new()
  return {
    database = {},
    add = add,
    remove = remove,
    fetch = fetch,
    save = save,
    load = load,
    clear = clear,
    print = print
  }
end

return { new = new }
