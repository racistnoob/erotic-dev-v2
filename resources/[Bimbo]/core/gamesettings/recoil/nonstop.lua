local recentShots = 0

local nonstopWeaponsList = {
    ["WEAPON_COMBATPISTOL"] = { recoil = 1.1 },
    ["WEAPON_HEAVYPISTOL"] = { recoil = 1.3 },
    ["WEAPON_M45A1"] = { recoil = 1.3 },
    ["WEAPON_PISTOL"] = { recoil = 1.0 },
    ["WEAPON_PISTOL_MK2"] = { recoil = 1.3 },
    ["WEAPON_PISTOL50"] = { recoil = 1.4 },
    ["WEAPON_VINTAGEPISTOL"] = { recoil = 1.2 },
    ["WEAPON_1911"] = { recoil = 1.1 },
    ["WEAPON_M9"] = { recoil = 1.2 },
    ["WEAPON_MARKSMANPISTOL"] = { recoil = 1.0 },
    ["WEAPON_GLOCK18C"] = { recoil = 1.1 },
    ["WEAPON_BROWNING"] = { recoil = 1.1 },
    ["WEAPON_L5"] = { recoil = 1.4 },
    ["WEAPON_REVOLVER_MK2"] = { recoil = 1.4 },
    ["makarov"] = { recoil = 0.8 },
    ["WEAPON_GLOCK17"] = { recoil = 1.3 },
    ["WEAPON_SP45"] = { recoil = 1.3 },
    ["WEAPON_AIMTRAINING"] = { recoil = 1.3 },

    ["WEAPON_APPISTOL"] = { recoil = 1.4 },
    ["WEAPON_COMPACTRIFLE"] = { recoil = 0.7 },
    ["WEAPON_MACHINEPISTOL"] = { recoil = 1.3 },
    ["WEAPON_MICROSMG"] = { recoil = 1.0 },
    ["WEAPON_MINISMG"] = { recoil = 1.1 },
    ["WEAPON_MAC10"] = { recoil = 1.1 },
    ["WEAPON_MP9A"] = { recoil = 1.0 },
    ["WEAPON_PP19"] = { recoil = 1.2 },
    ["WEAPON_MICROSMG2"] = { recoil = 1.0 },
    ["WEAPON_GEPARD"] = { recoil = 0.7 },
    ["WEAPON_MINIUZI"] = { recoil = 1.0 },
    ["WEAPON_MINISMG2"] = { recoil = 1.2 },
    ["WEAPON_G17"] = { recoil = 1.4 },
    ["WEAPON_VECTOR"] = { recoil = 1.0 },

    ["WEAPON_ASSAULTRIFLE_MK2"] = { recoil = 0.7 },
    ["WEAPON_ASSAULTRIFLE"] = { recoil = 0.7 },
    ["WEAPON_AK47"] = { recoil = 0.7 },
    ["WEAPON_BULLPUPRIFLE_MK2"] = { recoil = 0.8 },
    ["WEAPON_BULLPUPRIFLE"] = { recoil = 0.8 },
    ["WEAPON_CARBINERIFLE_MK2"] = { recoil = 0.7 },
    ["WEAPON_762"] = { recoil = 0.7 },
    ["WEAPON_CARBINERIFLE"] = { recoil = 0.7 },
    ["WEAPON_SPECIALCARBINE_MK2"] = { recoil = 0.8 },
    ["WEAPON_SPECIALCARBINE"] = { recoil = 0.8 },
    ["WEAPON_ADVANCEDRIFLE"] = { recoil = 0.7 },
    ["WEAPON_SCAR"] = { recoil = 0.7 },
    ["WEAPON_MPX"] = { recoil = 0.7 },
    ["WEAPON_M4"] = { recoil = 0.6 },
    ["WEAPON_M70"] = { recoil = 0.7 },
    ["WEAPON_MK18"] = { recoil = 0.7 },
    ["WEAPON_AK74"] = { recoil = 0.7 },
    ["WEAPON_TACTICALRIFLE"] = { recoil = 0.7 },
    ["WEAPON_M16"] = { recoil = 0.7 },
    ["WEAPON_HEAVYRIFLE"] = { recoil = 0.7 },
    ["WEAPON_M4A1"] = { recoil = 0.7 }, -- Carbine Rifle

    ["WEAPON_COMBATMG_MK2"] = { recoil = 0.05 },
    ["WEAPON_MG"] = { recoil = 0.02 },
    ["WEAPON_COMBATMG"] = { recoil = 0.04 },
    ["WEAPON_MK47FM"] = { recoil = 0.1 },

    ["WEAPON_DBSHOTGUN"] = { recoil = 0.2 },
    ["WEAPON_COMBATSHOTGUN"] = { recoil = 0.3 },
    ["WEAPON_PUMPSHOTGUN"] = { recoil = 0.4 },
    ["WEAPON_SAWNOFFSHOTGUN"] = { recoil = 0.2 },
    ["WEAPON_AUTOSHOTGUN"] = { recoil = 0.4 },

    ["WEAPON_MARKSMANRIFLE"] = { recoil = 1.0 },
    ["WEAPON_HEAVYSNIPER"] = { recoil = 1.0 },
    ["WEAPON_HOMINGLAUNCHER"] = { recoil = 1.0 },
    ["WEAPON_MARKSMANRIFLE_MK2"] = { recoil = 1.0 },
    ["WEAPON_DRAGUNOV"] = { recoil = 1.0 }
}

local recoilSettings = {
    pitchModifier = 0.03,
    headingModifier = 0.01,
    maxDur = 0.01,
    randomMult = 0.01,
    ammo = {
        ["9mm_rounds"] = 0.4,
        ["556_rounds"] = 0.5,
        ["50cal_rounds"] = 0.3,
    },
}

local weaponHashList = {}

-- Iterate through weapon settings
CreateThread(function()
    local weaponAmmos = exports['lane-inventory']:getWeaponAmmos()

    for weaponName, settings in pairs(nonstopWeaponsList) do
        local weaponHash = GetHashKey(weaponName)

        if weaponAmmos[weaponName] then
            weaponHashList[weaponHash] = {
                recoil = settings.recoil,
                ammo = weaponAmmos[weaponName]
            }
        end
    end

    for weaponName, ammo in pairs(weaponAmmos) do
        local weaponHash = GetHashKey(weaponName)
        if not weaponHashList[weaponHash] then
            weaponHashList[weaponHash] = {
                recoil = recoilSettings.ammo[weaponAmmos[weaponName]],
                ammo = weaponAmmos[weaponName]
            }
        end
    end
end)

local function getWeaponSettings(weaponHash)
    return weaponHashList[weaponHash]
end

local wait = Wait
local IsPedShooting = IsPedShooting
local GetSelectedPedWeapon = GetSelectedPedWeapon
local GetCurrentPedVehicleWeapon = GetCurrentPedVehicleWeapon
local GetGameTimer = GetGameTimer
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetGameplayCamRelativeHeading = GetGameplayCamRelativeHeading
local SetGameplayCamRelativeHeading = SetGameplayCamRelativeHeading
local GetGameplayCamRelativePitch = GetGameplayCamRelativePitch
local SetGameplayCamRelativePitch = SetGameplayCamRelativePitch
local SetGameplayCamRelativeRotation = SetGameplayCamRelativeRotation
local GetFollowPedCamViewMode = GetFollowPedCamViewMode
local GetFollowVehicleCamViewMode = GetFollowVehicleCamViewMode
local GetWeaponDamage = GetWeaponDamage
local DoesEntityExist = DoesEntityExist
local ShakeGameplayCam = ShakeGameplayCam
local getWeaponSettings = getWeaponSettings
local createthread = CreateThread

Recoil:RegisterMode("nonstop", function(_)
    local ped = PlayerPed
    -- recoil.
    if IsPedShooting(ped) then
        local weapon = GetSelectedPedWeapon(ped)
        local damage = GetWeaponDamage(weapon)
        local inVehicle = DoesEntityExist(GetVehiclePedIsIn(ped))
        local weaponSettings = getWeaponSettings(weapon)

        local ammo = weaponSettings.ammo
        local recoilModifier = (recoilSettings.ammo[ammo]+0.5 or 1.0) * (weaponSettings.recoil)

        ShakeGameplayCam("JOLT_SHAKE", 0.2 * recoilModifier)

        if damage then
            createthread(function()
                local startTime = GetGameTimer()
                local lastTime = startTime
                local mult = GetRandomFloatInRange(recoilSettings.randomMult, 1.0)
                local verticalMult = GetRandomIntInRange(0, 2) * 2.0 - 1.0
                local horizontalMult = GetRandomIntInRange(0, 2) * 2.0 - 1.0
                local duration = recoilSettings.maxDur * 1000 * recoilModifier
                local pitchOffset, headingOffset = -0.25, 0.0
                local viewMode

                if inVehicle then
                    viewMode = GetFollowVehicleCamViewMode()
                    verticalMult = verticalMult * 1.0

                    local isVehicleWeapon, _ = GetCurrentPedVehicleWeapon(ped)
                    if isVehicleWeapon then
                        return
                    end
                else
                    viewMode = GetFollowPedCamViewMode()
                end

                if not inVehicle and viewMode == 4 then
                    --verticalMult = verticalMult * 1.0
                    --horizontalMult = horizontalMult * 1.0
                    pitchOffset = -0.5
                    headingOffset = -0.5
                    duration = duration * 0.9
                end

                recentShots = recentShots + 1


                while (lastTime - startTime < duration) do
                    wait(1)
                    local amount = (GetGameTimer() - lastTime) / 1000.0 * mult * damage * recoilModifier
                    local pitch, heading = GetGameplayCamRelativePitch(), GetGameplayCamRelativeHeading()

                    pitch = pitch + (recoilSettings.pitchModifier * amount * verticalMult)
                    heading = heading + (recoilSettings.headingModifier * amount * horizontalMult)

                    if inVehicle then
                        if viewMode == 4 then
                            SetGameplayCamRelativeRotation(heading, pitch, 0.0)
                        else
                            SetGameplayCamRelativePitch(pitch + 2.0, 1.0)
                            SetGameplayCamRelativeHeading(heading + headingOffset)
                        end
                    else
                        SetGameplayCamRelativePitch(pitch + pitchOffset, 1.0)
                        SetGameplayCamRelativeHeading(heading + headingOffset)
                    end

                    lastTime = GetGameTimer()
                end

                while (GetGameTimer() - startTime < 1000) do
                    wait(200)
                end

                recentShots = recentShots - 1
            end)
        end
    end
end)

Recoil:OnModeChange(function()
    recentShots = 0
end)
