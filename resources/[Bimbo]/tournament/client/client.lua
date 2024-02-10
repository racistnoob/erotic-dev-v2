exports("showTournamentUI", function(state)
    SendReactMessage('setVisible', state)
end)

RegisterNetEvent("tournament:NUIMessage")
AddEventHandler("tournament:NUIMessage", function(data)
    SendNUIMessage({
        type = "setRankedGameData",
        payload = data
    })
end)

RegisterNetEvent("tournament:damagetick")
AddEventHandler("tournament:damagetick", function()
    if not exports["noob"]:inSafeZone() then
        ApplyDamageToPed(PlayerPedId(), 50, true)
    end
end)

RegisterNetEvent("tournament:playSound")
AddEventHandler("tournament:playSound", function(audioName, audioRef)
    PlaySoundFrontend(-1, audioName, audioRef)
end)
