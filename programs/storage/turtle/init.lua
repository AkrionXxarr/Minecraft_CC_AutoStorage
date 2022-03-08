-- Bring jobs into the global namespace
require("jobs.general")
require("jobs.item_management")
require("jobs.navigation")
require("jobs.procedures")
require("jobs.walk_storage")

local JobManager = require("jobs")
local Controller = require(
 ".modules.turtle.nav.controller"
)
local Config = require("config")

local states = {
 idle = true
}

local job_manager = nil

local function tick(aki_net, common)
 job_manager:execute()
end

local function init(aki_net, common)
 assert(
  #Config.positions.aisle == 
  #Config.directions.aisle,
  "All aisle config must have same # of entries"
 )
 assert(
  #Config.positions.aisle ==
  #Config.directions.storage,
  "All aisle config must have same # of entries"
 )
 
 job_manager = JobManager.new({
  aki_net = aki_net,
  common = common,
  log = common.log,
  log_warning = common.log_warning,
  log_error = common.log_error,
  controller = Controller,
  states = states,
  config = Config
 })
 
 job_manager:attach(return_idle)
 
 return { 
  tick = tick,
  app_data = {
   jobs = job_manager,
   states = states
  }
 }
end

return { init = init }

