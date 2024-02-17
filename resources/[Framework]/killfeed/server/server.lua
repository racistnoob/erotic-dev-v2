local function GetIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers - 1 do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end

local function CalculateKD(kills, deaths)
    if not deaths or deaths == 0 then
        return 0
    end

    return (kills / deaths)
end

AddEventHandler('weaponDamageEvent', function(sender, data)
    local _src = sender
    local victim = NetworkGetEntityFromNetworkId(data.hitGlobalId)

    if GetEntityType(victim) == 1 then
        local damage = data.weaponDamage

        if data.willKill and damage > 100 then
            damage = damage - 100
        end
    
        local lobby = exports['erotic-lobby']:GetWorld(_src)
        exports['erotic-lobby']:UpdateLobbyStats(_src, lobby, "Damage", {damage = damage})
    else
        -- cancels all damage coming from a gun that isnt going towards a player except for tires
        if data.tyreIndex == 0 then
            CancelEvent()
        end
    end
end)

local pairs = pairs
RegisterServerEvent("Grab:Leaderboard")
AddEventHandler("Grab:Leaderboard", function()
    local src = source
    local count = 0
    local Database = {}
    local players = GetPlayers()

    for _, playerId in pairs(players) do
        local Steam = GetIdentifier("steam", playerId)
        if Steam then
            local Character = exports.oxmysql:fetchSync("SELECT id, Kills, Deaths FROM users WHERE identifier=:identifier AND deleted='0'", { identifier = Steam })
            if Character and Character[1] then
                count = count + 1
                local Kills = Character[1].Kills or 0
                local Deaths = Character[1].Deaths or 0

                table.insert(Database, {
                    id = count,
                    Name = GetPlayerName(playerId),
                    Kills = Kills,
                    Deaths = Deaths,
                    kd = string.format("%.2f", CalculateKD(Kills, Deaths)),
                })
            end
        end
    end

    table.sort(Database, function(a, b) return a.Kills > b.Kills end)
    TriggerClientEvent('Recieved:Info', src, Database)
end)

local weaponNames = {
    [`WEAPON_UNARMED`] = 'weapon_unarmed',
    [`WEAPON_KNUCKLE`] = 'knuckle',
    [`WEAPON_BOTTLE`] = 'bottle',
    [`WEAPON_MACHETE`] = 'machete',
    [`WEAPON_REVOLVER`] = 'revolver',
    [`WEAPON_BAT`] = 'bat',
    [`WEAPON_GOLFCLUB`] = 'golfclub',
    [`WEAPON_TACTICALRIFLE`] = 'tacticalrifle',
    [`WEAPON_HEAVYRIFLE`] = 'weapon_heavyrifle',
    [`WEAPON_762`] = 'carbinerifle_mk2',
    [`WEAPON_SP45`] = 'weapon_heavypistol',
    [`WEAPON_1911`] = 'weapon_pistol_mk2',
    [`weapon_pistol_mk2`] = 'weapon_pistol_mk2',
    [`WEAPON_HEAVYPISTOL`] = 'weapon_heavypistol',
    [`WEAPON_PISTOL50`] = 'weapon_pistol50',
    [`WEAPON_MARKSMANRIFLE_MK2`] = 'weapon_marksmanrifle_mk2',
    [`WEAPON_HEAVYSNIPER_MK2`] = 'weapon_heavysniper_mk2',
    [`WEAPON_ASSAULTSMG`] = 'weapon_assaultsmg',
    [`WEAPON_GUSENBERG`] = 'weapon_gusenberg',
    [`WEAPON_MINISMG`] = 'weapon_minismg',
    [`WEAPON_MICROSMG`] = 'weapon_microsmg',
    [`WEAPON_MPX`] = 'weapon_smg_mk2',
    [`WEAPON_SMG_MK2`] = 'weapon_smg_mk2',
    [`WEAPON_COMPACTRIFLE`] = 'weapon_compactrifle',
    [`WEAPON_MACHINEPISTOL`] = 'weapon_machinepistol',
    [`WEAPON_COMBATMG`] = 'weapon_combatmg',
    [`WEAPON_ADVANCEDRIFLE`] = 'weapon_advancedrifle',
    [`WEAPON_MK18`] = 'carbinerifle_mk2',
    [`WEAPON_SPECIALCARBINE`] = 'weapon_specialcarbine',
    [`WEAPON_SCARH`] = 'weapon_scarh',
    [`WEAPON_AK47`] = 'weapon_assaultrifle',
    [`WEAPON_APPISTOL`] = 'weapon_appistol',
    [`WEAPON_CERAMICPISTOL`] = 'weapon_ceramicpistol',
    [`WEAPON_PISTOLXM3`] = 'weapon_ceramicpistol',
    [`WEAPON_GLOCK18C`] = 'weapon_appistol',
    [`WEAPON_GLOCK17`] = 'weapon_glock',
    [`WEAPON_FNX45`] = 'pistol',
    [`WEAPON_USP45`] = 'weapon_heavypistol',
    [`WEAPON_VINTAGEPISTOL`] = 'weapon_vintagepistol',
    [`WEAPON_COMBATPISTOL`] = 'weapon_combatpistol',
    [`WEAPON_M45A1`] = 'weapon_combatpistol',
}

local function GetWeaponName(hash)
    return weaponNames[hash.weaponhash] or 'unknown'
end

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    if source == killerId then
        return
    end
    
    local weaponName = GetWeaponName(deathData)

    local Victim = source
    local Killer = killerId

    local lobby = exports['erotic-lobby']:GetWorld(Killer)

    local KillerSteam = GetIdentifier("steam", Killer)
    local VictimSteam = GetIdentifier("steam", Victim)

    local picture = '</strong> <img src="img/'.. tostring(weaponName) ..'.png" width="30px" style="transform: rotate(-30deg);;"> <strong>'
    if weaponName == 'unknown' then
        picture = '<img src="img/skull.png" width="15px" style="margin: 2px;"> <strong>'
    end
    TriggerClientEvent('killfeed:client:feed', -1, lobby, '<strong>' .. tostring(GetPlayerName(killerId)) .. picture .. tostring(GetPlayerName(source)) .. '</strong>')

    if KillerSteam then
        exports.oxmysql:execute("UPDATE users SET Kills = Kills + 1 WHERE identifier=:identifier", { identifier = KillerSteam }, function(result)
            -- Handle the result if needed
        end)
    end

    if VictimSteam then
        exports.oxmysql:execute("UPDATE users SET Deaths = Deaths + 1 WHERE identifier=:identifier", { identifier = VictimSteam }, function(result)
            -- Handle the result if needed
        end)
    end

    exports['erotic-lobby']:UpdateLobbyStats(Killer, lobby, "Kills")
    exports['erotic-lobby']:UpdateLobbyStats(Victim, lobby, "Deaths")
end)