currentState = ""

RegisterNetEvent('core:updateLobby')
AddEventHandler("core:updateLobby", function(args)
    local lobbyID = tonumber(args)
    if lobbyID ~= nil then
        local lobbySettings = exports['erotic-lobby']:getLobbySettings(lobbyID)
        currentState = (lobbySettings.name)
        TriggerEvent('erotic:changeWatermark', '[' .. currentState .. ']')
    end
end)

local wait = Wait
local SetDiscordAppId = SetDiscordAppId
local SetDiscordRichPresenceAction = SetDiscordRichPresenceAction
local SetRichPresence = SetRichPresence
local SetDiscordRichPresenceAsset = SetDiscordRichPresenceAsset
Citizen.CreateThread(function()
    while true do
        wait(10000)
        SetDiscordAppId(1186601487720271923)
     
        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/XWjYGqyaHf")
        SetDiscordRichPresenceAction(1, "Connect", "fivem://connect/45.43.2.17:30120")
     
        SetRichPresence(currentState)
        SetDiscordRichPresenceAsset('erotic')
    end
end)