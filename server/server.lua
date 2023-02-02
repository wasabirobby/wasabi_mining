-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

lib.callback.register('wasabi_mining:checkPick', function(source, itemname)
    local item = HasItem(source, itemname)
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
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.miningAreas[index])
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 10 then
        KickPlayer(Strings.kicked)
        return
    end
    if Framework == 'esx' and not Config.oldESX then
        local player = GetPlayer(source)
        if player.canCarryItem(data.item, 1) then
            AddItem(source, data.item, 1)
            TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'error')
        else
	    TriggerClientEvent('wasabi_mining:notify', source, Strings.cantcarry, Strings.cantcarry_desc..' '..data.label, 'success')
        end
    else
        AddItem(source, data.item, 1)
        TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'success')
    end
end)

RegisterServerEvent('wasabi_mining:sellRock')
AddEventHandler('wasabi_mining:sellRock', function()
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.sellShop.coords)
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 3 then
        KickPlayer(source, Strings.kicked)
        return
    end
    for i=1, #Config.rocks do
        if HasItem(source, Config.rocks[i].item) >= 1 then
            local rewardAmount = 0
            for j=1, HasItem(source, Config.rocks[i].item) do
                rewardAmount = rewardAmount + math.random(Config.rocks[i].price[1], Config.rocks[i].price[2])
            end
            if rewardAmount > 0 then
                AddMoney(source, 'money', rewardAmount)
                TriggerClientEvent('wasabi_mining:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, Config.rocks[i].item), Config.rocks[i].label, addCommas(rewardAmount)), 'success')
                RemoveItem(source, Config.rocks[i].item, HasItem(source, Config.rocks[i].item))
            end
        end
    end
end)

RegisterServerEvent('wasabi_mining:axeBroke')
AddEventHandler('wasabi_mining:axeBroke', function()
    if HasItem(source, 'pickaxe') >= 1 then
        RemoveItem(source, 'pickaxe', 1)
    else
        Wait(2000)
        KickPlayer(source, Strings.kicked)
    end
end)
