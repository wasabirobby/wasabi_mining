-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ESX = exports["es_extended"]:getSharedObject()

lib.callback.register('wasabi_mining:checkPick', function(source, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_mining:getRockData', function(source)
    local data = Config.rocks[math.random(#Config.rocks)]
    return data
end)

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

RegisterServerEvent("wasabi_mining:mineRock")
AddEventHandler("wasabi_mining:mineRock", function(data, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.miningAreas[index])
    if distance == nil then
        xPlayer.kick(Strings.kicked)
        return
    end
    if distance > 10 then
        xPlayer.kick(Strings.kicked)
        return
    end
    local awardItem = data.item
    local xPlayer = ESX.GetPlayerFromId(source)
    local awardItemLabel = ESX.GetItemLabel(awardItem)
    if Config.OldESX then
        local limitItem = xPlayer.getInventoryItem(awardItem)
        if limitItem.limit == -1 or (limitItem.count + 1) <= limitItem.limit then
            xPlayer.addInventoryItem(awardItem, 1)
            TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..awardItemLabel, 'success')
        else
            TriggerClientEvent('wasabi_mining:notify', source, Strings.cantcarry, Strings.cantcarry_desc..' '..awardItemLabel, 'error')
        end
    else
        if xPlayer.canCarryItem(awardItem, 1) then
            xPlayer.addInventoryItem(awardItem, 1)
            TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..awardItemLabel, 'success')
        else
            TriggerClientEvent('wasabi_mining:notify', source, Strings.cantcarry, Strings.cantcarry_desc..' '..awardItemLabel, 'error')
        end
    end
end)

RegisterServerEvent('wasabi_mining:sellRock')
AddEventHandler('wasabi_mining:sellRock', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.sellShop.coords)
    if distance == nil then
        xPlayer.kick(Strings.kicked)
        return
    end
    if distance > 3 then
        xPlayer.kick(Strings.kicked)
        return
    end
    for i=1, #Config.rocks do
        if xPlayer.getInventoryItem(Config.rocks[i].item).count then
            local rewardAmount = 0
            for j=1, xPlayer.getInventoryItem(Config.rocks[i].item).count do
                rewardAmount = rewardAmount + math.random(Config.rocks[i].price[1], Config.rocks[i].price[2])
            end
            if rewardAmount > 0 then
                xPlayer.addMoney(rewardAmount)
                TriggerClientEvent('wasabi_mining:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(xPlayer.getInventoryItem(Config.rocks[i].item).count, xPlayer.getInventoryItem(Config.rocks[i].item).label, addCommas(rewardAmount)), 'success')
                xPlayer.removeInventoryItem(Config.rocks[i].item, xPlayer.getInventoryItem(Config.rocks[i].item).count)
            end
        end
    end
end)

RegisterServerEvent('wasabi_mining:axeBroke')
AddEventHandler('wasabi_mining:axeBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem('pickaxe')
    if xItem.count >= 1 then
        xPlayer.removeInventoryItem('pickaxe', 1)
    else
        Wait(2000)
        xPlayer.kick(Strings.kicked)
    end
end)

RegisterNetEvent('wasabi_mining:discordlog', function()
    local src = source
    discordLog(src)
end)

local function discordLog(source)
    local Webhook = Config.Webhook
    local src = source
    local license = GetPlayerIdentifier(src)
    local steamName = GetPlayerName(src)
    local embed = {
        {
            ['title'] = 'Wasabi Mining Exploit',
            ['color'] = 16711680,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = 'A possible Mining Exploiter has been found\n\nName: ' .. steamName .. '\nLicense: ' .. license .. '\nSteamID: ' .. GetPlayerIdentifier(src, 1) .. '\nIP: ||' .. GetPlayerEndpoint(src) .. '||',
            ['author'] = {
                ['name'] = 'Wasabi Mining Log',
                ['icon_url'] = 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.XzwggimMDySC-qzfSRDykAHaHa%26pid%3DApi&f=1&ipt=bac0077c5a956e9251fd9ed073bdd20cc9e6b266b4a35aba05963b6f4bcc323a&ipo=images',
            },
        }
    }
    PerformHttpRequest(Webhook, function() end, 'POST', json.encode({ username = 'LOG', embeds = embedData}), { ['Content-Type'] = 'application/json' })
end
