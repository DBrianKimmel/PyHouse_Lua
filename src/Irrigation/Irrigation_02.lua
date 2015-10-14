-- See README.md for notices.

SSID = "CannonTrail"
PASSWORD = "Koepfinger-59"
IPv4 = "192.168.1.51"
NETMASK = "255.255.255.0"
GATEWAY = "192.168.1.1"
BROKER = "192.168.1.2"
BROKERPORT = 1883
CLIENTID = "Sensor-" ..  node.chipid() -- The MQTT ID. Change to something you like

-- Create init.lua
function create_init_lua()
    file.remove("init.lua")
    file.open("init.lua", "w")
    file.writeline('"Hello"')
    file.close()
end

function wifi_setup()
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,PASSWORD)
    wifi.sta.connect()
    wifi.sta.setip({ip=IPv4,netmask=NETMASK,gateway=GATEWAY})
    print("Esp8266 mode is: " .. wifi.getmode())
    print("The module MAC address is: " .. wifi.ap.getmac())
    print("Config done, IP is "..wifi.sta.getip())
    -- dofile ("Irrigation_02.lua")
 end
 wifi_setup()
 
CMDFILE = "mqtt.lua"   -- File that is executed after connection
-- Change the code of this function that it calls your code.
function launch()
  print("Connected to WIFI!")
  print("IP Address: " .. wifi.sta.getip())
  tmr.alarm(0, 1000, 0, function() dofile(CMDFILE) end )  -- Zero as third parameter. Call once the file.
end  -- !!! Increase the delay to like 10s if developing mqtt.lua file otherwise firmware reboot loops can happen




-- Configuration to connect to the MQTT broker.
BRUSER = "user"           -- If MQTT authenitcation is used then define the user
BRPWD  = "pwd"            -- The above user password

-- MQTT topics to subscribe
topics = {"topic1","topic2","topic3","topic4"} -- Add/remove topics to the array

-- Control variables.
pub_sem = 0         -- MQTT Publish semaphore. Stops the publishing when the previous hasn't ended
current_topic  = 1  -- variable for one currently being subscribed to
topicsub_delay = 50 -- microseconds between subscription attempts, worked for me (local network) down to 5...YMMV
id1 = 0
id2 = 0

-- connect to the broker
print "Connecting to MQTT broker. Please wait..."
m = mqtt.Client( CLIENTID, 120, BRUSER, BRPWD)
m:connect( BROKER , BROKERPORT, 0, function(conn)
     print("Connected to MQTT:" .. BROKER .. ":" .. BROKERPORT .." as " .. CLIENTID )
     mqtt_sub() --run the subscription function
end)

function mqtt_sub()
     if table.getn(topics) < current_topic then
          -- if we have subscribed to all topics in the array, run the main prog
          run_main_prog()
     else
          --subscribe to the topic
          m:subscribe(topics[current_topic] , 0, function(conn)
               print("Subscribing topic: " .. topics[current_topic - 1] )
          end)
          current_topic = current_topic + 1  -- Goto next topic
          --set the timer to rerun the loop as long there is topics to subscribe
          tmr.alarm(5, topicsub_delay, 0, mqtt_sub )
     end
end

-- Sample publish functions:
function publish_data1()
   if pub_sem == 0 then  -- Is the semaphore set=
     pub_sem = 1  -- Nop. Let's block it
     m:publish("temperature","hello",0,0, function(conn) 
        -- Callback function. We've sent the data
        print("Sending data1: " .. id1)
        pub_sem = 0  -- Unblock the semaphore
        id1 = id1 +1 -- Let's increase our counter
     end)
   end  
end

function publish_data2()
   if pub_sem == 0 then
     pub_sem = 1
     m:publish("ts","hello",0,0, function(conn) 
        print("Sending data2: " .. id2)
        pub_sem = 0
        id2 = id2 + 1
     end)
   end  
end

--main program to run after the subscriptions are done
function run_main_prog()
     print("Main program")
     
     tmr.alarm(2, 5000, 1, publish_data1 )
     tmr.alarm(3, 6000, 1, publish_data2 )
     -- Callback to receive the subscribed topic messages. 
     m:on("message", function(conn, topic, data)
        print(topic .. ":" )
        if (data ~= nil ) then
          print ( data )
        end
      end )
end
-- END DBK