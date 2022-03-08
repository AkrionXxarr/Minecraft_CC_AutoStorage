local args = {...}
local proc = args[1]
local verbose = args[2] == "-v"

print("Starting for: ", proc)

package.path = string.format(
 "%s;./%s/?.lua", package.path, proc
)
package.path = string.format(
 "%s;./%s/?/init.lua", package.path, proc
)

local Common = require("common")
local AkiNet = require(".modules.aki_net").new(
 Common.protocol, Common.Logger, verbose
)

Common.Logger.echo.log = verbose
Common.Logger.echo.warn = verbose
Common.Logger.echo.error = true

local Proc = require(proc).init(AkiNet, Common)

local MainREQ = require("_requests")
local MainNFY = require("_notifications")

local ProcREQ = require(proc .. ".requests")
local ProcNFY = require(proc .. ".notifications")

Common.log("\nRegistering (core) network...")
MainREQ.register(AkiNet, Common)
MainNFY.register(AkiNet, Common)

Common.log("\nRegstering (" .. proc .. ") network...")
ProcREQ.register(AkiNet, Common, Proc.app_data)
ProcNFY.register(AkiNet, Common, Proc.app_data)

Common.network_ids.server = rednet.lookup(
 Common.protocol, Common.server_name
)

assert(
 Common.network_ids.server, 
 string.format(
  "Server not found...\n" ..
  "  Protocol: %s\n" ..
  "  Name: %s",
  Common.protocol,
  Common.server_name
 )
)

------ Main --------------------------------------
local function main(aki_net)
 local nid = {
  label = os.getComputerLabel(),
  id = os.getComputerID()
 }
 
 if nid.id ~= Common.network_ids.server then
  aki_net:send_notify(
   Common.network_ids.server,
   "register_network_id",
   nid
  )
 end
 
 while aki_net.active do
  aki_net:process()
  Proc.tick(aki_net, Common)
  os.sleep(0.1)
 end
end

local status, err = pcall(
 AkiNet.start, AkiNet, main
)
if not status then
 Common.log_error(
  "Exception caught: ", err
 )
 Common.Logger:save(string.format(
  "./logs/%s.log", proc
 ))
end

rednet.unhost(Common.protocol)
peripheral.find("modem", rednet.close)
