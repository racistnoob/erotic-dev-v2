
RegisterNetEvent('erp_adminmenu:discord')
AddEventHandler('erp_adminmenu:discord', function(webhook, name, message) sendToDiscord(webhook, name, message) end)
function sendToDiscord(webhook, name, message)
    local embed = {
        {
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end
exports('sendToDiscord', sendToDiscord) -- exports['adminmenu']:sendToDiscord(name, message, color, webhook)

