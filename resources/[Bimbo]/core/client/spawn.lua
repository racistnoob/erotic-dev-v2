local function Initialize()
    CreateThread(function()
        ShutdownLoadingScreen()
        Wait(1000)
        DoScreenFadeOut(0)
        exports.spawnmanager:setAutoSpawn(false)
        exports.spawnmanager:spawnPlayer({
            x = 0.0,
            y = 0.0,
            z = 0.0,
            heading = 90.0,
            skipFade = true,
        }, function()
            ShutdownLoadingScreenNui()
            Wait(250)
            RequestCollisionAtCoord(GetEntityCoords(PlayerPedId()))
            SetEntityCoords(PlayerPedId(), vector3(233.5797, -1393.9111, 30.5152))
            SetEntityHeading(PlayerPedId(), 143.0)
            TriggerEvent('clothing:checkIfNew')
            TriggerEvent('erotic:playerSpawned')
            TriggerServerEvent('erotic:playerSpawned')
            Wait(500)
            DoScreenFadeIn(1500)
        end)
        collectgarbage()
    end)
end

-- 1.
CreateThread(function()
	while true do
		Wait(1000)
        if NetworkIsSessionStarted() then
            Initialize()
			return
		end
	end
end)