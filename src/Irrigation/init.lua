-- init.lua

RETRY_DELAY = 1000 * 30

function do_init()
    dofile('init.lua')
end
function do_wifi()
    dofile('wifi.lua')
end


print("Init.lua: " .. node.heap())
-- print("Wait 30 seconds...")
-- tmr.alarm(0, 1000 * 30, 0, do_wifi())
-- print("Go...")

if wifi.sta.status() ~= 5 then
    tmr.alarm(1, RETRY_DELAY, 0, do_init)
    return
end

if wifi.sta.status() == 5 then
    print("Calling wifi: " .. node.heap())
    do_wifi()
    return
end

-- Drop through here to let NodeMcu run
