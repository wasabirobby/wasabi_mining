ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('wasabi_mining:checkPick', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("wasabi_mining:mineRock")
AddEventHandler("wasabi_mining:mineRock", function(distance)
    if distance ~= nil then
        if distance <= 3 then
            local awardItem = Config.Rocks[math.random(#Config.Rocks)]
            local xPlayer = ESX.GetPlayerFromId(source)
            local awardItemLabel = ESX.GetItemLabel(awardItem)
            if xPlayer.canCarryItem(awardItem, 1) then
                xPlayer.addInventoryItem(awardItem, 1)
                TriggerClientEvent('wasabi_mining:notify', source, Language['rewarded']..' '..awardItemLabel)
                if Config.DiscordMiningLogs then
                    sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just mined rocks and was rewarded a "..awardItemLabel.."!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 3066993)
                end 
            else
                TriggerClientEvent('wasabi_mining:notify', source, Language['cantcarry']..' '..awardItemLabel)
            end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            TriggerClientEvent('wasabi_mining:alertStaff', source)
            if Config.DiscordCheatLogs then
                sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just mined rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
            end
            Wait(2000)
            xPlayer.kick(Language['kicked'])
        end
    else
        TriggerClientEvent('wasabi_mining:alertStaff', source)
        if Config.DiscordCheatLogs then
            sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just mined rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick(Language['kicked'])
    end
end)

RegisterServerEvent('wasabi_mining:sellRock')
AddEventHandler('wasabi_mining:sellRock', function(distance)
    if distance ~= nil then
        if distance <= 3 then
            for k, v in pairs(Config.RockPrices) do
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer.getInventoryItem(k).count > 0 then
                    local rewardAmount = 0
                    for i = 1, xPlayer.getInventoryItem(k).count do
                        rewardAmount = rewardAmount + math.random(v[1], v[2])
                    end
                    xPlayer.addMoney(rewardAmount)
                    TriggerClientEvent('wasabi_mining:notify', source, Language['sold_for']..' '..xPlayer.getInventoryItem(k).count..' '..xPlayer.getInventoryItem(k).label..' '..Language['sold_for2']..''..rewardAmount)
                    xPlayer.removeInventoryItem(k, xPlayer.getInventoryItem(k).count)
                end
            end
        else
            TriggerClientEvent('wasabi_mining:alertStaff', source) 
            if Config.DiscordCheatLogs then
                sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just attempted to sell rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
            end
            Wait(2000)
            xPlayer.kick(Language['kicked'])
        end
    else
        TriggerClientEvent('wasabi_mining:alertStaff', source) 
        if Config.DiscordCheatLogs then
            sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just attempted to sell rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick(Language['kicked'])
    end
end)

RegisterServerEvent('wasabi_mining:axeBroke')
AddEventHandler('wasabi_mining:axeBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem('pickaxe')
    if xItem.count >= 1 then
        xPlayer.removeInventoryItem('pickaxe', 1)
    else
        if Config.DiscordCheatLogs then
            sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** broke a pickaxe without having one in inventory!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick(Language['kicked'])
    end
end)