-- wifi.lua

local WiFi = {}
WiFi.SSID = {}
WiFi.SSID["PINKPOPPY"] = "Koepfinger-59"
WiFi.SSID["CannonTrail"] = "Koepfinger-59"

SSID    = "PINKPOPPY"
APPWD   = "Koepfinger-59" 
CMDFILE = "mqtt.lua"   -- File that is executed after connection
WIFI_LOOP_DELAY = 1000 * 30
wifiTrys     = 0      -- Counter of trys to connect to wifi
MAX_WIFI_TRYS  = 90    -- Maximum number of WIFI Testings while waiting for connection

function do_mqtt()
    dofile("mqtt.lua")
end
function launch()
    print("WiFi IP Address: " .. wifi.sta.getip())
    print("Calling MQTT: " .. node.heap())
    tmr.alarm(2, WIFI_LOOP_DELAY, 0, do_mqtt)
end
function checkWIFI()
    if ( wifiTrys > MAX_WIFI_TRYS ) then
        print("wifi - Sorry. Not able to connect")
    else
        ipAddr = wifi.sta.getip()
        if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
            tmr.alarm( 1 , 500 , 0 , launch)
        else
            tmr.alarm( 0 , 2500 , 0 , checkWIFI)
            print("Checking WIFI..." .. wifiTrys)
            wifiTrys = wifiTrys + 1
        end 
    end 
end

print("Wifi Starting up: " .. node.heap())
-- Lets see if we are already connected by getting the IP
ipAddr = wifi.sta.getip()
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
    -- We aren't connected, so let's connect
    print("Configuring WIFI....")
    wifi.setmode( wifi.STATION )
    wifi.sta.config( SSID , APPWD)
    print("wifi Waiting for connection")
    tmr.alarm( 2 , 2500 , 0 , checkWIFI )  -- Call checkWIFI 2.5S in the future.
else  -- We are connected, so just run the launch code.
    launch()  -- Run the launch code
end
-- ### END DBK