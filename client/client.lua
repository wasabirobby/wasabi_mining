-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
ESX = nil
local mining = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    for i=1, #Config.MiningAreas, 1 do
        CreateBlip(Config.MiningAreas[i], 85, 5, Language['mining_blips'], 0.75)
    end
    CreateBlip(Config.SellShop, 207, 5, Language['sell_shop_blip'], 0.80)
end)

--Mining Functionality
Citizen.CreateThread(function()
    while true do 
        local Sleep = 1500
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)
        for i=1, #Config.MiningAreas, 1 do
            local dist = #(GetEntityCoords(player) - Config.MiningAreas[i])	
            if dist <= 10 and not mining then
                Sleep = 0
                DrawMarker(0, vector3(Config.MiningAreas[i].x, Config.MiningAreas[i].y, Config.MiningAreas[i].z-0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 205, 0, 100, false, true, 2, true, false, false, false) 
                if dist <= 1.5 and not mining then
                    DrawText3Ds(Config.MiningAreas[i], Language['mine_rock'], 0.55, 1.5, 0.7)
                    if IsControlJustReleased(0, 38) and dist <= 1.5 then
                        ESX.TriggerServerCallback('wasabi_mining:checkPick', function(output)
                            if output then
                                mining = true
                                local modelHash = Config.Axe
                                local model = loadModel(modelHash)
                                local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                                AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                                while mining do
                                    Wait(0)
                                    local unarmed = `WEAPON_UNARMED`
                                    SetCurrentPedWeapon(PlayerPedId(), unarmed)
                                    ShowHelp(Language['intro_instruction'])
                                    DisableControlAction(0, 24, true)
                                    if IsDisabledControlJustReleased(0, 24) then
                                        local dict = loadDict('melee@hatchet@streamed_core')
                                        TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        local skillbar = CreateSkillbar(1, "medium")
                                        if skillbar then
                                            ClearPedTasks(PlayerPedId())
                                            MineRock(dist)
                                        elseif not skillbar then
                                            local breakChance = math.random(1,100)
                                            if breakChance < Config.AxeBreakPercent then
                                                TriggerServerEvent('wasabi_mining:axeBroke')
                                                TriggerEvent('wasabi_mining:notify', Language['axe_broke'])
                                                ClearPedTasks(PlayerPedId())
                                                break
                                            end
                                            ClearPedTasks(PlayerPedId())
                                            TriggerEvent('wasabi_mining:notify', Language['failed_mine'])
                                        end
                                    elseif IsControlJustReleased(0, 194) then
                                        break
                                    elseif #(GetEntityCoords(PlayerPedId()) - Config.MiningAreas[i]) > 2.0 then
                                        break
                                    end
                                end
                                mining = false
                                DeleteObject(axe)
                            elseif not output then
                                TriggerEvent('wasabi_mining:notify', Language['no_pickaxe'])
                            end
                        end, 'pickaxe')
                    end	
                end
            end
        end
        Wait(Sleep)
     end
 end)

 --Sell Shop Functionality
Citizen.CreateThread(function()
	while true do
        local Sleep = 1500
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local dist = #(playerCoords - Config.SellShop)
		if dist <= 10.0 then
            Sleep = 0
            DrawMarker(0, vector3(Config.SellShop.x, Config.SellShop.y, Config.SellShop.z-0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 205, 0, 100, false, true, 2, true, false, false, false) 
            if dist <= 1.5 then
                DrawText3Ds(Config.SellShop, Language['sell_material'], 0.55, 1.5, 0.7)
                if IsControlJustReleased(0, 38) and dist <= 1.5 then
                    MiningSellItems(dist)
                end
			end
		end
    Wait(Sleep)
	end
end)

RegisterNetEvent('wasabi_mining:alertStaff')
AddEventHandler('wasabi_mining:alertStaff', function()
    TriggerEvent('wasabi_mining:notify', Language['possible_cheater'])
end)
