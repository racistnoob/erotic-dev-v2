local kvpValue = GetResourceKvpString("graphics_time")
local baseTime = 900
local timeOffset = 0
local timer = 0
local freezeTime = true
local currentTime = kvpValue or baseTime

AddEventHandler('erotic:playerSpawned', function()
    SetGameTime(currentTime)
    -- print('KVP loaded:', currentTime)
end)

RegisterCommand("time", function(source, args)
    local hour = (tonumber(args[1]) * 100)

    currentTime = hour
    SetGameTime(currentTime)
end, false)

function SetGameTime(currentTime)
    NetworkOverrideClockTime(currentTime, 0, 0)
    SetResourceKvp("graphics_time", currentTime)
end

RegisterNUICallback('getCurrentTimeSettings', function(data, cb)
    cb(GetResourceKvpString("graphics_time") or "12")
end)

RegisterNUICallback('getTimeSettings', function(data, cb)
    local timeSettings = {}
    for i = 0, 24 do
        table.insert(timeSettings, i)
    end
    print("Sending time settings to client:", json.encode(timeSettings))
    cb(timeSettings)
end)

RegisterCommand("freezetime", function(source, args)
    freezeTime = not freezeTime
end, false)

CreateThread(function()
    while true do
        Wait(0)
        local newBaseTime = currentTime

        if GetGameTimer() - 500 > timer then
          newBaseTime = newBaseTime + 0.25
          timer = GetGameTimer()
        end
        if freezeTime then
          timeOffset = timeOffset + currentTime - newBaseTime
        end
        currentTime = newBaseTime

        hour = math.floor(((currentTime + timeOffset) / 60) % 24)
        -- minute = math.floor((currentTime + timeOffset) % 60)
        NetworkOverrideClockTime(hour, 0, 0)
    end
end)