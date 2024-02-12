-- locals --
local timecycles = {
    ["Default"] = "default",
    ["nofog"] = "full_bright",
    ["nofoglow"] = "full_bright_low_clip",
}

RegisterNUICallback('getTimecycleSettings', function(data, cb)
    cb(timecycles)
end)

RegisterNUICallback('getCurrentTimecycleIndex', function(data, cb)
    cb(GetResourceKvpString("graphics_timecycle") or "Default")
end)

function SetTimecycleModifierEffect(timecycleEffect)
    if timecycleEffect then
        SetTimecycleModifier(timecycleEffect)
        print("Timecycle effect changed to:", timecycleEffect)
    else
        print("Invalid timecycle effect:", timecycleEffect)
    end
end

RegisterNetEvent('reset-timecycle')
AddEventHandler('reset-timecycle', function()
    local kvpValue = GetResourceKvpString("graphics_timecycle")
    if kvpValue then
        -- print('KVP loaded:', kvpValue)
        SetTimecycleModifierEffect(kvpValue)
    elseif kvpValue == nil then
        SetTimecycleModifierEffect("default")
    end
end)

RegisterNetEvent('set-timecycle')
AddEventHandler('set-timecycle', function(params)
    local timecycleType = params.type
    local timecycleName = timecycles[timecycleType]
    
    if timecycleName then
        SetResourceKvp("graphics_timecycle", timecycleName) -- Store the timecycle name as a string
        -- print('KVP loaded', timecycleName)
        SetTimecycleModifierEffect(timecycleName)
    else
        -- print("Invalid timecycle type.")
    end
end)



AddEventHandler('erotic:playerSpawned', function()
    local kvpValue = GetResourceKvpString("graphics_timecycle")
        
    if kvpValue then
        -- print('KVP loaded:', kvpValue)
        SetTimecycleModifierEffect(kvpValue)
    else
        -- print("Player does not have KVP.")
    end
end)

RegisterNUICallback('timecycle:changeEffect', function(data, cb)
    local timecycleType = data.type
    local timecycleName = timecycles[timecycleType]
    
    if timecycleName then
        SetResourceKvp("graphics_timecycle", timecycleType)
        TriggerEvent("set-timecycle", { type = timecycleType })
    else
        print("Invalid timecycle type:", timecycleType)
    end
end)
