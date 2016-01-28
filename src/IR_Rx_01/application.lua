-- file : application.lua

local module = {}
m = nil

-- Sends a simple ping to the broker
local function send_ping()
    print("Sending ping...")
    m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
end

-- Sends my id to the broker for registration
local function register_myself()
    print("Subscribing to ENDPOINT")
    m:subscribe(config.ENDPOINT .. config.ID,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function display_mqtt_info()
    print(" ")
    print("============== MQTT ================") 
    print("  Host: " .. config.HOST)
    print("  Port: " .. config.PORT)
    print("Secure: " .. config.SECURE)
    print("    Id: " .. config.ID)
    print("====================================")
end

local function mqtt_start()
    m = mqtt.Client(config.ID, config.TIMEOUT, config.USER, config.PASSWORD)
    m:lwt("/lwt", "offline", config.QOS, config.RETAIN)
    m:on("connect", function(con) print ("I am connected") end)
    m:on("offline", function(con) print ("I am offline") end)
    m:on("message", function(conn, topic, data)
        print("I Got a message.")
        if data ~= nil then
            print(topic .. ": " .. data)
        end
    end)
    display_mqtt_info()
    m:connect(config.HOST, config.PORT, config.SECURE, function(con)
        print("Callback from connect.")
        -- register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 1000, 1, send_ping)
    end)
    -- m:subscribe("pyhouse/#", 0, function(conn) 
    --     print("subscribe success") 
    -- end)

    print("Just did connect")
end

function module.start()
    print("App start: " .. node.heap())
    mqtt_start()
end

return module
-- ### END DBK
