local Database = require(".modules.database")
local Stack = require(".modules.stack")

------ Global Variables --------------------------
local globals = {
  database = Database.new(),
  
  sides = {
    modem = "top",
    chest = "left"
  }
}

globals.database:add("__empty", Stack.new())

return globals
