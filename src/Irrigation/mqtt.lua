-- mqtt.lua

local Mqtt = {}
Mqtt.IPv4 = "192.168.1.3"
Mqtt.Port = 1883

BROKER_IP = "192.168.1.3"
MQTT_PREFIX = "pyhouse/pinkpoppy"
MQTT_KEEPALIVE = 120
CLIENTID = "pyh_sensor_001"
QOS_0 = 0
RETAIN_0 = 0


function cb_connected(p_arg1)
    print("cb_connected: ")
    do_subscribe(m_client, "pyhouse/#")
end
function cb_message_received(client, topic, message)
    print("cb_message_received - topic: " .. topic .. ": ")
    if message ~= nil then
        print(message)
    end
end 
function cb_offline(p_arg1)
    print("cb_offline: ")
end
function cb_message_sent(p_arg1)
    print("cb_message_sent: ")
end
function cb_subscribed()
    print("cb_subscribed: ") 
end
function cb_subscribe(p_arg1)
    print("cb_subscribe: ") 
--    do_publish(m_client, "sensors/test/temp", "hello")
end
function cb_message(conn, topic, data) 
    print(topic .. ":" ) 
    if data ~= nil then
        print(data)
    end
end


function do_connect(p_client)
    print("Connecting to: " .. BROKER_IP)
    p_client:connect(Mqtt.IPv4, Mqtt.Port, 0, cb_connected())
end
function do_subscribe(p_client, p_topic)
    print("Subscribing to: " .. p_topic)
    m_client:subscribe(p_topic, QOS_0, cb_subscribed)
end
function do_publish(p_client, p_topic, p_message)
    print("Publishing " .. p_topic)
    p_client:publish(p_topic, p_message, QOS_0, RETAIN_0, cb_message_sent)
end

print("Mqtt start: " .. node.heap())
m_client = mqtt.Client(CLIENT_ID, MQTT_KEEPALIVE)--, "user", "password")
print("After Client: " .. node.heap())
do_connect(m_client)
m_client:lwt("/lwt", "offline", 0, 0)
m_client:on("connect", cb_connected)
m_client:on("offline", cb_offline)
m_client:on("message", cb_message)
print("mqtt End: " .. node.heap())
