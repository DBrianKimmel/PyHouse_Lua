-- wifi.lua

-- Constants
SSID    = "CannonTrail"
APPWD   = "Koepfinger-59"
CMDFILE = "mqtt.lua"   -- File that is executed after connection
WIFI_LOOP_DELAY = 1000 * 10

-- Some control variables
wifiTrys     = 0      -- Counter of trys to connect to wifi
MAX_WIFI_TRYS  = 100    -- Maximum number of WIFI Testings while waiting for connection

-- Change the code of this function that it calls your code.
function launch()
  print("Connected to WIFI!")
  print("WiFi IP Address: " .. wifi.sta.getip())
  -- Call our command.
  tmr.alarm(2, WIFI_LOOP_DELAY, 1, function() dofile(CMDFILE) end )
end

function checkWIFI()
  if ( wifiTrys > MAX_WIFI_TRYS ) then
    print("wifi - Sorry. Not able to connect")
  else
    ipAddr = wifi.sta.getip()
    if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
      -- lauch()        -- Cannot call directly the function from here the timer... NodeMcu crashes...
      tmr.alarm( 1 , 500 , 0 , launch )
    else
      -- Reset alarm again
      tmr.alarm( 0 , 2500 , 0 , checkWIFI)
      print("Checking WIFI..." .. wifiTrys)
      wifiTrys = wifiTrys + 1
    end 
  end 
end

print("Wifi Starting up! ")

-- Lets see if we are already connected by getting the IP
ipAddr = wifi.sta.getip()
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  wifi.sta.config( SSID , APPWD)
  print("wifi Waiting for connection")
  tmr.alarm( 2 , 2500 , 0 , checkWIFI )  -- Call checkWIFI 2.5S in the future.
else
 -- We are connected, so just run the launch code.
 launch()
end
