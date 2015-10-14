-- mqtt.lua

BROKER_IP = "192.168.1.2"
MQTT_PREFIX = "pyhouse/cannontrail"
CLIENTID = "Irrig-1"
QOS_0 = 0
RETAIN_0 = 0

function cb_message_received(client, topic, message)
    print("mqtt message - topic: " .. topic .. ": ")
    if message ~= nil then
        print(message)
    end
end

function cb_connect()
    print("mqtt connecting to" .. BROKER_IP)
    m:connect(BROKER_IP, 1833, 0)
end

function cb_offline(client)
    print("mqtt connecting ")
    tmr.alarm(3, 10000, 0, do_connect)
end

function cb_message_sent(client)
    print("mqtt message sent")
end

function cb_subscribed()
end

function do_connect()
    print("Connecting to: " .. BROKER_IP)
    m_client:connect(BROKER_IP, 1883, 0)
end

function do_subscribe(p_client, p_topic)
    print("mqtt subscribe to " .. p_topic)
    p_client:subscribe(p_topic, QOS_0, cb_subscribed)
end

function do_publish(p_client, p_topic, p_message)
    print("mqtt publish " .. p_topic)
    p_client:publish(p_topic, p_message, QOS_0, RETAIN_0, cb_message_sent)
end

print("mqtt Start")
m_client = mqtt.Client(CLIENT_ID, 120)--, "user", "password")
-- m:lwt("/lwt", wifi.sta.getmac(), 0, 0)

m_client:on("offline", cb_offline)

-- on publish message receive event
m_client:on("message", cb_message_received)

m_client:on("offline", function(con) 
     print ("mqtt reconnecting(2)-") 
     print(node.heap())
     tmr.alarm(3, 10000, 0, do_connect)
end)

tmr.alarm(4, 1000, 1, function()
 if wifi.sta.status() == 5 then
     tmr.stop(4)
     print("Connecting (2) to "..BROKER_IP)
     m_client:connect(BROKER_IP, 1883, 0, function(conn) 
          print("mqtt connected")
          print("mqtt subscribe to ")
          m_client:subscribe(CLIENTID, 0, function(conn)
              do_publish(m_client, "sensors/test/temp", "hello")
          end)
     end)
 end
end)
print("mqtt END")

-- function createSliderCallback( which_channel )
--     local audioChannel = which_channel
--     return function ( event )
--         local new_volume = event.value
--         audio.setVolume(new_volume, { channel = audioChannel } )
--     end
-- end

