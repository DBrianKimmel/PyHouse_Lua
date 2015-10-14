-- init.lua

RETRY_DELAY = 1000 * 2

print("Running init.lua ...")
if wifi.sta.status() ~= 5 then
    tmr.alarm(1, RETRY_DELAY, 0, function(d)
        dofile('init.lua')
    end)
    return
end

if wifi.sta.status() == 5 then
    dofile('wifi.lua')
    return
end

-- Drop through here to let NodeMcu run