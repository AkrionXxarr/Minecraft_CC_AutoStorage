local Pretty = require("cc.pretty")

local doc_table = {}
local builder_functions

local function reason(reason)
  local msg = 
    Pretty.text("-> ", colors.purple) ..
    Pretty.text(reason, colors.pink)
    
  table.insert(doc_table, msg)
  
  return builder_functions
end

local function description(desc)
  local msg = Pretty.text(desc, colors.lightBlue)
      
  table.insert(doc_table, msg)
  
  return builder_functions
end

local function build()
  local msg = ""
  
  for _, value in pairs(doc_table) do
    msg = msg .. value .. "\n"
  end
  
  return msg
end

local function new(type)
  local msg = 
    Pretty.text("<Error: ", colors.red) ..
    Pretty.text(type, colors.orange) ..
    Pretty.text(">", colors.red)
    
  table.insert(doc_table, msg)
    
  return builder_functions
end

builder_functions = { 
    reason = reason,
    description = description,
    build = build,
}

return { new = new }
