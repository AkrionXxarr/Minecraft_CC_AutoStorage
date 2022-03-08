local utilities = {
 register_handlers = function(
  aki_net, common, app_data, type, handlers
 )
  for name, func in pairs(handlers) do
   aki_net:register_handler(
    type, name, func, common, app_data
   )
  end
 end
}

return utilities
