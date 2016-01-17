-- file : config.lua 
local module = {}

module.SSID = {}  
module.SSID["PINKPOPPY"] = "Koepfinger-59"

module.HOST = "192.168.1.3"  
module.PORT = 1883
module.SECURE = 0
module.ID = node.chipid()

module.ENDPOINT = "pyhouse/"  

return module
-- ### END DBK