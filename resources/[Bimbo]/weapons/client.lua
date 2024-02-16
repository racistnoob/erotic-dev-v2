-- this is placed here because game will crash if this resource is stopped
AddEventHandler("onClientResourceStop", function(name)
    TriggerServerEvent('admin:disabled', name)
end)

AddEventHandler('onResourceStop', function(name)
    TriggerServerEvent('admin:disabled', name)
end)