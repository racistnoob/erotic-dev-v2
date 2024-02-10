local kvpValue = GetResourceKvpString("graphics_time")
local baseTime = 12
local currentTime = kvpValue or baseTime

AddEventHandler('erotic:playerSpawned', function()
    SetGameTime(currentTime)
    -- print('KVP loaded:', currentTime)
end)

RegisterCommand("time", function(source, args)
    local hour = tonumber(args[1])

    currentTime = hour

    SetGameTime(currentTime)
end, false)

function SetGameTime(currentTime)
    NetworkOverrideClockTime(currentTime, 0, 0)
    SetResourceKvp("graphics_time", currentTime)
end