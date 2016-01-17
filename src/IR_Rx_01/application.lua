-- file : application.lua

local module = {}
m = nil

-- Sends a simple ping to the broker
local function send_ping()
    print("Sending ping...")
    m:publish(config.ENDPOINT .. "ping", "id=" .. config.ID, 0, 0)
end

-- Sends my id to the broker for registration
local function register_myself()
    print("Subscribing to ENDPOINT")
    m:subscribe(config.ENDPOINT .. config.ID, 0, function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()
    print("Before Client creation: " .. node.heap())
    m = mqtt.Client(config.ID, 120)
    print("After Client creation: " .. node.heap())

    -- register message callback beforehand
    m:on("message", function(conn, topic, data)
        if data ~= nil then
            print(topic .. ": " .. data)
            -- do something, we have received a message
        end
    end)
    print("Just set message callback.")

    -- Connect to broker
    print(" ")
    print("============== MQTT ================")
    print("Host: " .. config.HOST)
    print("Port: " .. config.PORT)
    print("Secure: " .. config.SECURE)
    print("====================================")
    m:connect(config.HOST, config.PORT, config.SECURE, 1, function(con)
        print("Callback from connect.")
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 1000, 1, send_ping)
    end)
    print("Just did connect")
end

function module.start()
    print("App start: " .. node.heap())
    mqtt_start()
end

return module
-- ### END DBK