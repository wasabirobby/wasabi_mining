-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local mining = false

CreateThread(function()
    for i=1, #Config.miningAreas, 1 do
        CreateBlip(Config.miningAreas[i], 85, 5, Strings.mining_blips, 0.75)
    end
end)

CreateThread(function()
    local textUI = {}
    while true do
        local sleep = 1500
        local pos = GetEntityCoords(cache.ped)
        for i=1, #Config.miningAreas, 1 do
            local dist = #(pos - Config.miningAreas[i])	
            if dist <= 2.0 and not mining then
                sleep = 0
                if not textUI[i] then
                    lib.showTextUI(Strings.mine_rock)
                    textUI[i] = true
                end
                if IsControlJustReleased(0, 38) and dist <= 2.0 then
                    lib.hideTextUI()
                    local output = lib.callback.await('wasabi_mining:checkPick', 100, 'pickaxe')
                    if output then
                        mining = true
                        local model = Config.axe.prop
                        lib.requestModel(model, 100)
                        local axe = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                        AttachEntityToEntity(axe, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                        while mining do
                            Wait()
                            local unarmed = `WEAPON_UNARMED`
                            SetCurrentPedWeapon(cache.ped, unarmed)
                            showHelp(Strings.intro_instruction)
                            DisableControlAction(0, 24, true)
                            if IsDisabledControlJustReleased(0, 24) then
                                lib.requestAnimDict('melee@hatchet@streamed_core', 100)
                                TaskPlayAnim(cache.ped, 'melee@hatchet@streamed_core', 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local rockData = lib.callback.await('wasabi_mining:getRockData', 100)
                                if lib.skillCheck(rockData.difficulty) then
                                    ClearPedTasks(cache.ped)
                                    tryMine(rockData, i)
                                else
                                    local breakChance = math.random(1, 100)
                                    if breakChance < Config.axe.breakChance then
                                        TriggerServerEvent('wasabi_mining:axeBroke')
                                        TriggerEvent('wasabi_mining:notify', Strings.axe_broke, Strings.axe_broke_desc, 'error')
                                        ClearPedTasks(cache.ped)
                                        textUI[i] = nil
                                        break
                                    end
                                    ClearPedTasks(PlayerPedId())
                                    TriggerEvent('wasabi_mining:notify', Strings.failed_mine, Strings.failed_mine_desc, 'error')
                                end
                            elseif IsControlJustReleased(0, 194) then
                                textUI[i] = nil
                                break
                            elseif #(GetEntityCoords(cache.ped) - Config.miningAreas[i]) > 2.0 then
                                textUI[i] = nil
                                break
                            end
                        end
                        mining = false
                        textUI[i] = nil
                        DeleteObject(axe)
                        SetModelAsNoLongerNeeded(model)
                        RemoveAnimDict('melee@hatchet@streamed_core')
                    elseif not output then
                        TriggerEvent('wasabi_mining:notify', Strings.no_pickaxe, Strings.no_pickaxe_desc, 'error')
                    end
                end	
            elseif dist >= 2.1 then
                if textUI[i] then
                    lib.hideTextUI()
                    textUI[i] = nil
                end
            end
        end
        Wait(sleep)
     end
 end)


 if Config.sellShop.enabled then
    CreateThread(function()
        CreateBlip(Config.sellShop.coords, 207, 5, Strings.sell_shop_blip, 0.80)
        local ped, pedSpawned
        local textUI
        while true do
            local sleep = 1500
            local playerPed = cache.ped
            local coords = GetEntityCoords(playerPed)
            local dist = #(coords - Config.sellShop.coords)
            if dist <= 30 and not pedSpawned then
                lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                lib.requestModel(Config.sellShop.ped, 100)
                ped = CreatePed(28, Config.sellShop.ped, Config.sellShop.coords.x, Config.sellShop.coords.y, Config.sellShop.coords.z, Config.sellShop.heading, false, false)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                pedSpawned = true
            elseif dist <= 1.8 and pedSpawned then
                sleep = 0
                if not textUI then
                    lib.showTextUI(Strings.sell_material)
                    textUI = true
                end
                if IsControlJustReleased(0, 38) then
                    miningSellItems()
                end
            elseif dist >= 1.9 and textUI then
                sleep = 0
                lib.hideTextUI()
                textUI = nil
            elseif dist >= 31 and pedSpawned then
                local model = GetEntityModel(ped)
                SetModelAsNoLongerNeeded(model)
                DeletePed(ped)
                SetPedAsNoLongerNeeded(ped)
                RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                pedSpawned = nil
            end
            Wait(sleep)
        end
    end)
end

RegisterNetEvent('wasabi_mining:alertStaff')
AddEventHandler('wasabi_mining:alertStaff', function()
    TriggerEvent('wasabi_mining:notify', Strings.possible_cheater, Strings.possible_cheater_desc, 'error')
end)
