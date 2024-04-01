local toggleHud = true
RegisterNetEvent('killfeed:client:feed')
AddEventHandler('killfeed:client:feed', function(worldID, context)
    if exports['erotic-lobby']:getCurrentWorld() == tonumber(worldID) then
        SendNUIMessage({
            type = "killfeed",
            context = context,
            show = toggleHud
        })
    end
end)

--[[
local List = {}
RegisterCommand("stats", function()
    TriggerServerEvent("Grab:Leaderboard")
    Wait(500)

    SendNUIMessage({
        type = "ui",
        mode = "Leaderboard",
        data = json.encode(List),
        show = toggleHud
    })

    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(50)
end)

AddEventHandler('Recieved:Info')
RegisterNetEvent('Recieved:Info', function(data)
    List = data or {}
end)

RegisterNUICallback("exit",function()
    SendNUIMessage({
        type = "ui",
        mode = "close_all",
        show = toggleHud
    })
    SetNuiFocus(false,false)
    TriggerScreenblurFadeOut(50)
end)
--]]

local lobbystats = {}
local extended = false
AddEventHandler('Update:Lobby:Stats')
RegisterNetEvent('Update:Lobby:Stats', function(data)
    lobbystats  = data
    SendNUIMessage({
        type = "ui",
        mode = "stats",
        state = extended,
        data = json.encode(data),
        show = toggleHud
    })
end)

exports("toggleHud", function(state)
    toggleHud = state
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)
  
RegisterCommand("+leaderboard_extend", function()
    extended = true
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)

RegisterCommand("-leaderboard_extend", function()
    extended = false
    Wait(100)
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)
  
RegisterKeyMapping("+leaderboard_extend", "Extend Lobby Leaderboard", "keyboard", "z")