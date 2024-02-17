local function showWalls(state)
    if state then
        RequestIpl("southside_blockers")
    else
        RemoveIpl("southside_blockers")
    end
end

Citizen.CreateThread(function()
    RemoveIpl("southside_blockers")
end)

-- DisplayPlayerNameTagsOnBlips

exports("showTournamentUI", function(state)
    SendReactMessage('setVisible', state)
    showWalls(state)
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
        ApplyDamageToPed(PlayerPedId(), 10, true)
    end
end)

local function countdown()
    for i=5, 1, -1 do
        showScaleform(i, "~p~Round Starting")
    end
    showScaleform("~p~BEGIN", "Drive Out")
end

function showScaleform(title, desc)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
        PushScaleformMovieFunction(scaleform, "SET_TEXT")
        PushScaleformMovieFunctionParameterString(tostring(title))
        PushScaleformMovieFunctionParameterString(desc)
        PopScaleformMovieFunctionVoid()
		PopScaleformMovieFunctionVoid()
		return scaleform
	end

	local scaleform = Initialize("MISSION_QUIT")

    PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
    local sec = 150
    while sec > 0 do
        sec = sec - 1
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait()
    end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

RegisterNetEvent("tournament:startRound")
AddEventHandler("tournament:startRound", function()
    countdown()
    showWalls(false)
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET")
    Wait(15000)
    RequestIpl("southside_blockers")
end)


RegisterNetEvent("tournament:roundOver")
AddEventHandler("tournament:roundOver", function()
    SetEntityHealth(PlayerPedId(), 0)
    showWalls(true)
end)