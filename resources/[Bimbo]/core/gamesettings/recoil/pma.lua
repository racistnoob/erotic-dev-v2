local recoilTable = {
    [`weapon_appistol`] = {noAim = 1.15, aim = 0.985},
    [`WEAPON_AK47`] = {noAim = 1.15, aim = 0.785},
    [`weapon_assaultrifle_mk2`] = {noAim = 1.15, aim = 0.785},
    [`weapon_bullpuprifle`] = {noAim = 1.15, aim = 0.785},
    [`weapon_bullpuprifle_mk2`] = {noAim = 1.15, aim = 0.785},
    [`weapon_carbinerifle_mk2`] = {noAim = 1.15, aim = 0.785},
    [`weapon_combatpistol`] = {noAim = 3.15, aim = 1.785},
    [`weapon_compactrifle`] = {noAim = 1.15, aim = 0.785},
    [`weapon_fnx45`] = {noAim = 3.15, aim = 1.785},
    [`weapon_glock18c`] = {noAim = 1.15, aim = 0.985},
    [`weapon_gusenberg`] = {noAim = 2.15, aim = 1.585},
    [`weapon_heavypistol`] = {noAim = 3.15, aim = 1.785},
    [`weapon_microsmg`] = {noAim = 3.15, aim = 1.995},
    [`weapon_minismg`] = {noAim = 1.15, aim = 0.985},
    [`weapon_pistol`] = {noAim = 1.15, aim = 1.785},
    [`weapon_pistol50`] = {noAim = 3.15, aim = 2.800},
    [`weapon_pistol_mk2`] = {noAim = 1.15, aim = 1.785},
    [`weapon_smg`] = {noAim = 1.15, aim = 1.285},
    [`weapon_smg_mk2`] = {noAim = 1.15, aim = 1.285},
    [`weapon_specialcarbine`] = {noAim = 5.15, aim = 4.085},
    [`weapon_sp45`] = {noAim = 3.15, aim = 1.785},
    [`weapon_usp45`] = {noAim = 3.15, aim = 1.785},
    [`weapon_vintagepistol`] = {noAim = 3.15, aim = 1.785},
    [`weapon_mk18`] = {noAim = 1.15, aim = 0.785},
}

local is_ped_shooting = IsPedShooting
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_gameplay_cam_relative_pitch = GetGameplayCamRelativePitch
local is_control_pressed = IsControlPressed
local is_ped_doing_driveby = IsPedDoingDriveby
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local get_gameplay_cam_relative_heading = GetGameplayCamRelativeHeading
local set_gameplay_cam_relative_heading = SetGameplayCamRelativeHeading
local set_gameplay_cam_relative_pitch = SetGameplayCamRelativePitch


Recoil:RegisterMode('pma', function()
    local ped = PlayerPedId()
    local currentWeapon = get_selected_ped_weapon(ped)
    local weprecoil = recoilTable[currentWeapon]
    
    if is_ped_shooting(ped) then
        local regularRecoil = weprecoil and weprecoil.noAim or 0.6
        local recoilAiming = weprecoil and weprecoil.aim or 0.25
        local recoilVehicle = -1.0
        
        local recoil = get_gameplay_cam_relative_pitch()
        local isShooting = is_control_pressed(0, 25)
        local doingDriveby = is_ped_doing_driveby(ped)
        local inVehicle = is_ped_in_any_vehicle(ped, true)
    
        if inVehicle then
            recoil = get_gameplay_cam_relative_heading()
        end
    
        if isShooting and not doingDriveby then
            recoil = recoil + recoilAiming
        elseif not doingDriveby then
            recoil = recoil + regularRecoil
        else
            recoil = recoil + recoilVehicle
        end
    
        if inVehicle then
            set_gameplay_cam_relative_heading(recoil);
        else
            set_gameplay_cam_relative_pitch(recoil, 1.0)
        end
    end
end)