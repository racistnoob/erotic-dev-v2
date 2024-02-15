local IsPedShooting = IsPedShooting
local GetCurrentPedWeapon = GetCurrentPedWeapon
local GetEntitySpeed = GetEntitySpeed
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleClass = GetVehicleClass
local GetWeapontypeGroup = GetWeapontypeGroup
local GetGameplayCamRelativeHeading = GetGameplayCamRelativeHeading
local SetGameplayCamRelativeHeading = SetGameplayCamRelativeHeading
local GetGameplayCamRelativePitch = GetGameplayCamRelativePitch
local SetGameplayCamRelativePitch = SetGameplayCamRelativePitch
local GetFollowPedCamViewMode = GetFollowPedCamViewMode
local ceil = math.ceil
local random = math.random
local GetEntityCoords = GetEntityCoords
local GetGameplayCamCoord = GetGameplayCamCoord

Recoil:RegisterMode("roleplay", function()
    local ped = PlayerPed
    if IsPedShooting(ped) then
        local _, wep = GetCurrentPedWeapon(ped)
        local GamePlayCam = GetFollowPedCamViewMode()
        local MovementSpeed = ceil(GetEntitySpeed(ped))

        if MovementSpeed > 69 then
            MovementSpeed = 69
        end

        local group = GetWeapontypeGroup(wep)
        local p = GetGameplayCamRelativePitch()
        local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(ped))
        local recoil = random(50, 75 + (ceil(MovementSpeed * 1.5))) / 100
        local rifle = false

        if group == 970310034 or group == 1159398588 then
            rifle = true
        end

        if cameraDistance < 5.3 then
            cameraDistance = 1.5
        else
            if cameraDistance < 8.0 then
                cameraDistance = 4.0
            else
                cameraDistance = 7.0
            end
        end

        if GamePlayCam == 4 then
            recoil = recoil * 0.35

            if rifle then
                recoil = recoil * 0.15
            else
                recoil = recoil * 0.05
            end
        end

        if rifle then
            recoil = recoil * 0.15
        end

        local rightleft = random(4)
        local h = GetGameplayCamRelativeHeading()
        local hf = random(10, 40 + MovementSpeed) / 100

        local direction = (rightleft == 1) and 1 or -1
        SetGameplayCamRelativeHeading(h + direction * hf)        

        local standardPitch = p + recoil
        local vehicleClass = GetVehicleClass(GetVehiclePedIsIn(ped))

        if vehicleClass == 8 or vehicleClass == 13 then
            local bikePitch = p + random(2, 5)
            if random(1, 10) >= random(1, 5) then
                SetGameplayCamRelativePitch(bikePitch, 1.0)
            else
                SetGameplayCamRelativePitch(bikePitch, 1.0)
            end
        else
            if random(1, 10) >= random(1, 5) then
                SetGameplayCamRelativePitch(standardPitch, 1.0)
            else
                SetGameplayCamRelativePitch(standardPitch, 1.0)
            end
        end
    end
end)
