local Logger = require(".modules.logger").new(128)

local common = {
  Logger = Logger,
  
  protocol = "auto_storage_server",
  server_name = "SpectroServ",
  network_ids = {},
  
  log = Logger:create_channel("log", ""),
  log_warning = Logger:create_channel(
   "warn", 
   "!! "
  ), 
  log_error = Logger:create_channel(
   "error", 
   "<Error> ",
   function(msg) printError(msg) end
  ) 
}

return common
