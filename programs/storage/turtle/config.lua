local config = {
 positions = {
  aisle = {
   vector.new(-2, 0, 0),
   vector.new(2, 0, 0)
  },
  idle     = vector.new(0, 0, 0),
  input    = vector.new(0, 0, 2),
  overflow = vector.new(0, 0, -2)
 },
 directions = {
  aisle = { "west", "east" },
  idle = "south",
  input = "south",
  overflow = "north",
  storage = { "north", "north" }
 },
 storage = {
  columns = 16,
  rows = 3,
  use_both_sides = true
 }
}

return config
