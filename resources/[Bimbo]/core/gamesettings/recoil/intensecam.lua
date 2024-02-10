
local shakeCounter = 0
local shakeCounter2 = 0
local isShaking = false
local intenseCam = false

local wait = Wait
local is_ped_still = IsPedStill
local is_player_free_aiming = IsPlayerFreeAiming
local is_ped_aiming_from_cover = IsPedAimingFromCover
local shake_gameplay_cam = ShakeGameplayCam
local stop_gameplay_cam_shaking = StopGameplayCamShaking
local createthread = CreateThread
local function setIntenseCam()
    createthread(function()
        while intenseCam do
            
            local plyPed = PlayerPed
    
            while true do
                local isAiming = is_player_free_aiming(playerID)
                local isPedStill = is_ped_still(plyPed)
        
                if isAiming and isPedStill and not is_ped_aiming_from_cover(plyPed) then
    
                    wait(100)
        
                    shakeCounter = shakeCounter + 1
                    shakeCounter2 = 0
        
                    if shakeCounter == 5 then
                        isShaking = true
                        shake_gameplay_cam('HAND_SHAKE', 0.2)
                    end
        
                elseif isAiming and not isPedStill then
        
                    wait(10)
        
                    shakeCounter2 = shakeCounter2 + 1
                    shakeCounter = 0
        
                    if shakeCounter2 == 5 then
                        isShaking = true
                        shake_gameplay_cam('HAND_SHAKE', 0.9)
                    end
        
                    shakeCounter = 0
                    shakeCounter2 = 0
        
                else
        
                    if isShaking then
        
                        isShaking = false
                        shakeCounter = 0
                        shakeCounter2 = 0
        
                        stop_gameplay_cam_shaking(true)
        
                    end
        
                    wait(1000)
        
                end
        
            end
        end
    end)
end

function SetIntenseCamEnabled(state)
    intenseCam = state
    isShaking = false
    shakeCounter = 0
    shakeCounter2 = 0
    stop_gameplay_cam_shaking(true)
    if state then
        setIntenseCam()
    end
end

exports("SetIntenseCamEnabled", SetIntenseCamEnabled)