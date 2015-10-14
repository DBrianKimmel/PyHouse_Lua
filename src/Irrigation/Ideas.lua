-- Blink Led
LED_PIN = 3
function BlinkLed()
    print("Blinking LED")
    gpio.mode(LED_PIN, gpio.OUTPUT)
    ix = 0
    while ix < 10 do
        gpio.write(LED_PIN, gpio.HIGH)
        tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
        gpio.write(LED_PIN, gpio.LOW)
        tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
        ix = ix + 1
    end
    gpio.write(LED_PIN, gpio.HIGH)
end
BlinkLed()

-- list the files
function ListFiles()
    print("List files")
    list = files.list()
    for k,v in pairs(list) do
        print(k.." : "..v)
    end
end
ListFiles()

-- print ap list
function listap(t)
    print("List Access Points")
    for k,v in pairs(t) do
        print(k.." : "..v)
    end
end
wifi.sta.getap(listap)

-- Connect WiFi
function ConnectWiFi()
    wifi.sta.config("accesspointname","yourpassword")
    wifi.sta.connect()
    tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
    print(wifi.sta.status())
    print(wifi.sta.getip())
end

-- Browse
function Browse()
    sk=net.createConnection(net.TCP, 0)
    sk:on("receive", function(sck, c) print(c) end )
    sk:connect(80,"207.58.139.247")
    sk:send("GET /testwifi/index.html HTTP/1.1\r\nHost: www.adafruit.com\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
end
