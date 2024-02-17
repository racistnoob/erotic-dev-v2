local noImage = "https://cdn.forums.klei.com/monthly_2020_01/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg.269696d99af4a73e886c0731e7ed7c16.jpg"
local data = {
    red = {
        score =  0,
        alive =  0,
        players = {
            [1] = noImage,
            [2] = noImage,
            [3] = noImage,
            [4] = noImage
        }
    },
    blue = {
        score = 0,
        alive = 0,
        players = {
            [1] = noImage,
            [2] = noImage,
            [3] = noImage,
            [4] = noImage
        }
    },
    timer = "15:00",
    currentTeam = ""
}

local playerData = {
    [1] = {
        currentTeam = "",
        teamID = 0,
        alive = true,
        ready = true
    }
}
playerData = {}

local roundActive = false
local timerEnabled = false
local timePaused = false
local remainingTime = 0
local newTimer = false
local allDead = true
local damageEnabled = false

RegisterServerEvent("tournament:server:timer")
AddEventHandler("tournament:server:timer", function()
end)

local GetIdentifier = function(src)
    return GetPlayerIdentifiers(src)[1]
end

local function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end

	local t={} ; i=1
    if input ~= nil then
        for str in string.gmatch(input, '([^'..seperator..']+)') do
            t[i] = str
            i = i + 1
        end
        return t
    end
end

local function GetIDFromSource(Type, CurrentID)
	local ID = stringsplit(CurrentID, ':')
	if (ID[1]:lower() == string.lower(Type)) then
		return ID[2]:lower()
	end
	return nil
end

local function GetSteamPP(identifier)
    local callback = promise:new()
    PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', identifier), 16) .. '/?xml=1', function(Error, Content, Head)
        local SteamProfileSplitted = stringsplit(Content, '\n')
        if SteamProfileSplitted ~= nil and next(SteamProfileSplitted) ~= nil then
            for i, Line in ipairs(SteamProfileSplitted) do
                if Line:find('<avatarFull>') then
                    callback:resolve(Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', ''))
                    break
                end
            end
        end
    end)
    return Citizen.Await(callback)
end

local function getAllReady()
    for _, player in pairs(playerData) do
        if not player.ready then
            return false
        end
    end
    return true
end

local function getAllDead()
    for _, player in pairs(playerData) do
        if player.alive then
            allDead = false
            return false
        end
    end
    damageEnabled = false
    allDead = true
    return true
end

local function resetAlive()
    timerEnabled = false
    for _, player in pairs(playerData) do
        player.ready = false
        player.alive = true
        data[player.currentTeam].alive = 0
        data[player.currentTeam].alive = data[player.currentTeam].alive + 1
    end
    newTimer = true
    remainingTime = 0
    data.timer = "15:00"
    TriggerClientEvent("tournament:NUIMessage", -1, data)
end

local function dodamageTick()
    for playerId, _ in pairs(playerData) do
        if _.alive and damageEnabled then
            TriggerClientEvent('tournament:damagetick', playerId)
        end
    end
end

local function damageTick()
    Citizen.CreateThread(function()
        getAllDead()
        while damageEnabled do
            if not damageEnabled then
                return
            end
            getAllDead()
            dodamageTick()
            Wait(2000)
        end
    end)
end

local function roundEnd(allDead)
    data.timer = "15:00"
    TriggerClientEvent("tournament:NUIMessage", -1, data)
    timePaused = true
    
    roundActive = false
    if allDead then
        TriggerClientEvent('drp-notifications:client:SendAlert', -1, {type = 'inform', text = "Round over!", length = 5000})
    end
    Wait(1000)
    resetAlive()
    TriggerClientEvent('tournament:roundOver', -1)
end

local function timerEnd()
    data.timer = "0:00"
    TriggerClientEvent("tournament:NUIMessage", -1, data)

    damageTick()

    getAllDead()
    damageEnabled = true
    while not allDead do
        if damageEnabled then
            getAllDead()
            Wait(1000)
        end
    end
    roundEnd()
end

local function parseTime(timeString)
    local minutes, seconds = timeString:match("(%d+):(%d+)")
    return tonumber(minutes), tonumber(seconds)
end

local function countdown()
    roundActive = true
    newTimer = false
    Citizen.CreateThread(function()
        while remainingTime > 0 and not newTimer and roundActive do
            if remainingTime ~= nil then
                while timePaused do
                    Wait(1000)
                end
                local min = math.floor(remainingTime / 60)
                local sec = remainingTime % 60
        
                data.timer = tostring(min..":"..string.format("%02d", sec))
                TriggerClientEvent("tournament:NUIMessage", -1, data)
                remainingTime = remainingTime - 1
                Wait(1000)
            end
    
            if remainingTime == 0 then
                timerEnabled = false
            end
        end
        if not timerEnabled then
            timerEnd()
            remainingTime = 0
        end
    end)
    timerEnabled = false
end

local function startTimer(time)
    timePaused = false
    
    local timeString = time
    local minutes, seconds = parseTime(timeString)

    newTimer = true
    timerEnabled = true

    Wait(1000)

    remainingTime = minutes * 60 + seconds
    countdown()
end

RegisterCommand("ready", function(src, args)
    local _playerData = playerData[src]
    if _playerData then
        playerData[src].ready = true
        if getAllReady() then
            if not timerEnabled then
                damageEnabled = false
                TriggerClientEvent("tournament:startRound", -1)
                Wait(6200)
                startTimer("15:00")
            end
        end
    end
end)

RegisterCommand("pausetimer", function(src, args)
    timePaused = not timePaused
end)

RegisterCommand("starttimer", function(src, args)
    if #args == 1 then
        if args[1]:find(":") then
            startTimer(args[1])
        end
    end
end)

local nextTeamMemberId = {
    red = 1,
    blue = 1
}

RegisterCommand("team", function(src, args)
    if #args == 1 then
        local newTeam = tostring(args[1])
        
        if newTeam ~= "blue" and newTeam ~= "red" then
            return
        end

        if playerData[src] == nil then
            if nextTeamMemberId[newTeam] <= 4 then
                playerData[src] = {
                    currentTeam = newTeam,
                    alive = true,
                    ready = false,
                    teamMemberId = nextTeamMemberId[newTeam]
                }

                data[newTeam].players[nextTeamMemberId[newTeam]] = GetSteamPP(GetIdentifier(src))
                nextTeamMemberId[newTeam] = nextTeamMemberId[newTeam] + 1
                data[newTeam].alive = data[newTeam].alive + 1
            else
                return
            end
        else
            local currentTeam = playerData[src].currentTeam
            data[currentTeam].alive = data[currentTeam].alive - 1
            nextTeamMemberId[currentTeam] = nextTeamMemberId[currentTeam] - 1
            local teamMemberId = playerData[src].teamMemberId
            table.remove(data[currentTeam].players, teamMemberId)

            if nextTeamMemberId[newTeam] <= 4 then
                playerData[src] = {
                    currentTeam = newTeam,
                    alive = true,
                    ready = false,
                    teamMemberId = nextTeamMemberId[newTeam]
                }

                data[newTeam].players[nextTeamMemberId[newTeam]] = GetSteamPP(GetIdentifier(src))
                nextTeamMemberId[newTeam] = nextTeamMemberId[newTeam] + 1
                data[newTeam].alive = data[newTeam].alive + 1
            else
                return
            end
        end

        if data[newTeam].alive == -1 then
            data[newTeam].alive = 0
        end

        local clientData = data
        clientData.currentTeam = playerData[src].currentTeam
        TriggerClientEvent("tournament:NUIMessage", -1, data)
        TriggerClientEvent("tournament:NUIMessage", src, clientData)
        TriggerClientEvent('drp-notifications:client:SendAlert', src, {type = 'inform', text = "Joined "..newTeam.." team", length = 5000})
    else
        if playerData[src] and playerData[src].currentTeam ~= nil then
            local currentTeam = playerData[src].currentTeam
            local teamMemberId = playerData[src].teamMemberId
            nextTeamMemberId[currentTeam] = nextTeamMemberId[currentTeam] - 1
            table.remove(data[currentTeam].players, teamMemberId)
            data[currentTeam].alive = data[currentTeam].alive - 1

            if data[currentTeam].alive == -1 then
                data[currentTeam].alive = 0
            end

            TriggerClientEvent('drp-notifications:client:SendAlert', src, {type = 'inform', text = "Left "..currentTeam.." team", length = 5000})
            playerData[src] = nil

            local clientData = data
            clientData.currentTeam = ""
            TriggerClientEvent("tournament:NUIMessage", -1, data)
            TriggerClientEvent("tournament:NUIMessage", src, clientData)
        end
    end
end)

RegisterCommand("setscore", function(src, args)
    if #args == 2 then
        local team = args[1]
        local score = tonumber(args[2])

        data[team].score = score
        TriggerClientEvent("tournament:NUIMessage", -1, data)
    end
end)

RegisterCommand("resetall", function(src, args)
    data = {
        red = {
            score =  0,
            alive =  0,
            players = {
                [1] = noImage,
                [2] = noImage,
                [3] = noImage,
                [4] = noImage
            }
        },
        blue = {
            score = 0,
            alive = 0,
            players = {
                [1] = noImage,
                [2] = noImage,
                [3] = noImage,
                [4] = noImage
            }
        },
        timer = "15:00",
        currentTeam = ""
    }
    playerData = {}
    TriggerClientEvent("tournament:NUIMessage", -1, data)
end)

RegisterServerEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function()
    local player = source
    if playerData[player] then
        local _data = playerData[player]
        local currentTeam = _data.currentTeam
        local alive = data[_data.currentTeam].alive
        local newAlive = alive - 1

        if newAlive < 0 then
            return
        end

        if not roundActive then
            return
        end

        playerData[player].alive = false
        data[currentTeam].alive = data[currentTeam].alive - 1
        TriggerClientEvent("tournament:NUIMessage", -1, data)

        if newAlive == 0 then
            if roundActive then
                if currentTeam == "red" then
                    data.blue.score = data.blue.score + 1
                elseif currentTeam == "blue" then
                    data.red.score = data.red.score + 1
                end
            end
            TriggerClientEvent("tournament:NUIMessage", -1, data)
            roundEnd(true)
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    if playerData[src] and playerData[src].currentTeam ~= nil then
        local currentTeam = playerData[src].currentTeam
        table.remove(data[currentTeam].players, playerData[src].teamID)
        data[currentTeam].alive = data[currentTeam].alive - 1

        if data[currentTeam].alive == -1 then
            data[currentTeam].alive = 0
        end

        playerData[src] = nil
        TriggerClientEvent("tournament:NUIMessage", -1, data)
    end
end)