local FFABUNKER = {
    [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
    [2] = {x = 843.3173, y = -3235.2666, z = -98.6991, h = 143.0110},
    [3] ={x = 856.9405, y = -3212.1631, z = -98.4711, h = 143.0110},
    [4] ={x = 872.1874, y = -3211.3135, z = -97.2462, h = 143.0110},
    [5] ={x = 867.2796, y = -3186.1096, z = -96.2488, h = 143.0110},
    [6] ={x = 900.2949, y = -3182.2495, z = -97.0675, h = 143.0110},
    [7] ={x = 904.9290, y = -3199.6267, z = -97.1880, h = 143.0110},
    [8] ={x = 909.7304, y = -3236.9119, z = -98.2942, h = 143.0110},
    [9] ={x = 945.9636, y = -3210.4885, z = -98.2774, h = 143.0110},
    [10] ={x = 918.3181, y = -3201.2510, z = -98.2621, h = 143.0110},
    [11] ={x = 906.0173, y = -3230.5940, z = -98.2944, h = 143.0110},
    [12] = {x = 884.8878, y = -3211.9189, z = -98.1962, h = 143.0110},
}

local MirrorPark = {
    x = 770.5748, 
    y = -233.9927, 
    z = 66.1145, 
    h = 354.6606
}

WorldData = {
    --[[
    { ID = 1, custom = false, playerCount = 0, settings = {
        name = 'Tournament',
        tags = {'Hopouts: 762, RP Preset #1, HS, No Roofs'},
        recoilMode = 'roleplay',
        hsMulti = true,
        maxPlayers = 12,
        kits = {'ars'},
        kit = {'ars', '762'},
        tournament = true
    }},]]
    { ID = 1, custom = false, playerCount = 0, settings = {
        name = 'Southside #1',
        tags = {'FPS Mode', 'Pistols', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true,
        hsMulti = false,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kits = {'pistols'},
        kit = {'pistols', 'sp'},
    }},
    { ID = 2, custom = false, playerCount = 0, settings = {
        name = 'Southside #2',
        tags = {'FPS Mode', 'ARS', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true,
        hsMulti = false,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'}
    }},
    { ID = 3, custom = false, playerCount = 0, settings = {
        name = 'Car Fights',
        tags = {'Pistols', 'Rena'},
        recoilMode = 'roleplay3',
        firstPersonVehicle = false, 
        hsMulti = false,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kit = {'pistols', 'heavypistol'},
        kits = {'pistols'},
    }},
    { ID = 4, custom = false, playerCount = 0, settings = {
        name = 'Pistol FFA',
        tags = {'FFA', 'Pistols', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = false,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'pistols'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 5, custom = false, playerCount = 0, settings = {
        name = 'AR FFA',
        tags = {'FFA', 'ARs', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = true,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 6, custom = false, playerCount = 0, settings = {
        name = 'Envy',
        tags = {'FPS Mode', 'Headshots', 'Envy'},
        recoilMode = 'envy',
        firstPersonVehicle = true, 
        hsMulti = true,
        disableLadders = true,
        disableHighRoofs = true,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'ars','pistols','smgs'},
    }},
    { ID = 7, custom = false, playerCount = 0, settings = {
        name = 'Deluxo',
        tags = {'Deluxo', 'Snipers'},
        recoilMode = 'roleplay2',
        firstPersonVehicle = true, 
        hsMulti = false,
        maxPlayers = 30,
        spawningcars = false,
        kits = {'snipers'},
        kit = {'snipers', 'trick2'},
        spawn = MirrorPark
    }},
    { ID = 8, custom = false, playerCount = 0, settings = {
        name = 'Overtime (BETA)',
        tags = {'FPS Mode', 'Headshots', 'OT Combat', 'OT Recoil'},
        recoilMode = 'nonstop',
        nonstopcombat = true,
        firstPersonVehicle = true,
        disableLadders = true,
        disableHighRoofs = true,
        hsMulti = true,
        kits = {'ars','pistols','smgs'},
        maxPlayers = 30,
    }},
}

RegisterServerEvent('RemoveEmptyCustomLobby')
AddEventHandler('RemoveEmptyCustomLobby', function(lobbyID)
    for i = #WorldData, 1, -1 do
        local lobby = WorldData[i]
        if lobby.ID == lobbyID and lobby.custom and getLobbyPlayerCount(lobbyID) == 0 then
            table.remove(WorldData, i)
            --print("Removed empty custom lobby:", json.encode(lobby))
            TriggerClientEvent('UpdateLobbies', -1, WorldData)
            break
        end
    end
end)

local recoilModeTags = {
    roleplay = "RP Preset #1",
    envy = "Envy",
    hardcore = "Nopickle",
    roleplay3 = "Rena",
    roleplay2 = "RP Preset #2",
    qb = "QB",
    nonstop = "OT Recoil",
    pma = "AMP"
}

local function generateTags(settings)
    local tags = {}

    local recoilModeTag = recoilModeTags[settings.recoilMode]
    if recoilModeTag then
        table.insert(tags, recoilModeTag)
    end

    print(json.encode(settings))

    if settings.firstPersonVehicle then
        table.insert(tags, "FPS Mode")
    end

    if settings.hsMulti then
        table.insert(tags, "Headshots")
    end

    if settings.nonstopcombat then
        table.insert(tags, "OT Combat")
    end

    if settings.disableQPeeking then
        table.insert(tags, "No Q Peeking")
    end

    if settings.disableLadders then
        table.insert(tags, "No Ladders")
    end

    if settings.disableHighRoofs then
        table.insert(tags, "No Roofs")
    end
    
    if settings.disableFP then
        table.insert(tags, "Disable FP")
    end

    return tags
end

RegisterNetEvent('AddCustomLobby')
AddEventHandler('AddCustomLobby', function(customLobbySettings)
    local playerName = GetPlayerName(source)

    if playerName then
        for _, lobby in pairs(WorldData) do
            if lobby.custom and lobby.settings.name == playerName .. "'s lobby" then
                TriggerClientEvent('drp-notifications:client:SendAlert', source, {type = 'inform', text = 'You already have a custom lobby', length = 5000})
                return
            end
        end

        customLobbySettings.name = playerName .. "'s lobby"
        customLobbySettings.tags = generateTags(customLobbySettings)
        local customLobby = {
            ID = #WorldData + 1,
            custom = true,
            playerCount = 1,
            settings = customLobbySettings,
        }
        table.insert(WorldData, customLobby)

        TriggerClientEvent('updateLobbies', -1, WorldData)
        TriggerSwitchWorldToClient(source, customLobby.ID)
    end
end)


function TriggerSwitchWorldToClient(source, worldID)
    TriggerClientEvent('SwitchWorldData',source, worldID)
end

RegisterNetEvent('RequestWorldsData')
AddEventHandler('RequestWorldsData', function()
    TriggerClientEvent('ReceiveWorldsData', source, WorldData)
end)

RegisterServerEvent('getWorldsData')
AddEventHandler('getWorldsData', function()
    TriggerClientEvent('receiveWorldsData', -1, WorldData)
end)

local TX_ADMINS = {}
AddEventHandler("txAdmin:events:adminAuth", function(data)
    if data.netid ~= -1 then
        TX_ADMINS[tostring(data.netid)] = {}
        TX_ADMINS[tostring(data.netid)].isAdmin = data.isAdmin
        TX_ADMINS[tostring(data.netid)].username = data.username
    end
end)

local txadmin_Logs = "https://discord.com/api/webhooks/1202340309019922433/CqNYAmo_bLhXpy4ywfRnhOO_mN8dgHWlTlEuuS3OrUbtY3R7Fumd063xf715n5lGJHVX"
local function sendToDisc(webhook, title, msg)
    local embed = {
        {
            ["title"] = "**".. title .."**",
            ["description"] = msg,
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local normalLobbies = #WorldData
RegisterCommand("forcelobby", function(source, args, rawCommand)
    local src = source  
    local message = "No permission to use this command"
    if TX_ADMINS[tostring(src)] and TX_ADMINS[tostring(src)].isAdmin then
        if #args >= 1 then
            local targetPlayer = (#args == 2) and args[1] or src
            local lobbyID = (#args == 1) and args[1] or args[2]
            local playerName = GetPlayerName(targetPlayer)

            if lobbyID:sub(1, 1):lower() == "c" then
                lobbyID = tonumber(lobbyID:sub(2)) + normalLobbies
            end
            lobbyID = tonumber(lobbyID)

            if WorldData and not WorldData[lobbyID] then
                TriggerClientEvent('chat:addMessage', targetPlayer, {
                    template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                    args = { "[ADMIN]", "Lobby not found"}
                })
                return
            end

            local lobbyName = WorldData[tonumber(lobbyID)].settings.name

            sendToDisc(txadmin_Logs, 'Player sent to lobby', "Name: **" .. playerName .. "** \nAdmin: **" .. TX_ADMINS[tostring(src)].username .. "** \n".."Lobby: **" .. lobbyName .. "**")
            TriggerClientEvent("erotic-lobby:forceworld", targetPlayer, lobbyID, true)
            message = "Sent "..playerName.." to lobby: "..lobbyName

            if targetPlayer ~= src then
                TriggerClientEvent('chat:addMessage', targetPlayer, {
                    template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                    args = { "[ADMIN]", "You have been sent to lobby: "..lobbyName}
                })
            end
        else
            message = "Usage: forcelobby <playerid> <lobbyid> / forcelobby <lobbyid>"
        end
    end
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
        args = { "[ADMIN]", message}
    })
end, false)

RegisterCommand("forcemp", function(source, args, rawCommand)
    local src = source  
    local message = "No permission to use this command"
    if TX_ADMINS[tostring(src)] and TX_ADMINS[tostring(src)].isAdmin then
        if #args == 2 then
            local lobbyID = args[1]
            local playerCount = tonumber(args[2])

            if lobbyID:sub(1, 1):lower() == "c" then
                lobbyID = tonumber(lobbyID:sub(2)) + normalLobbies
            end
            lobbyID = tonumber(lobbyID)

            if WorldData and not WorldData[lobbyID] then
                TriggerClientEvent('chat:addMessage', source, {
                    template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                    args = { "[ADMIN]", "Lobby not found"}
                })
                return
            end

            local world = WorldData[lobbyID]
            local worldsettings = world.settings
            local lobbyName = worldsettings.name

            worldsettings.maxPlayers = playerCount

            sendToDisc(txadmin_Logs, 'Changed lobby player limit',
            "** Admin: **" .. TX_ADMINS[tostring(src)].username .. 
            "** \nLobby: **" .. lobbyName ..
            "** \nMax Players: **" .. playerCount)
            message = "Changed ("..lobbyName.. ") max player count to: "..playerCount
        else
            message = "Usage: forcemp <lobbyid> <max players>"
        end
    end
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
        args = { "[ADMIN]", message}
    })
end, false)