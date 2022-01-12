function DrawText3Ds(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(vector - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry('STRING')
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(vector.xyz, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function loadModel(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

function ShowHelp(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CreateBlip(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

function MineRock(distance)
    TriggerServerEvent('wasabi_mining:mineRock', distance)
end

function MiningSellItems(distance)
	TriggerServerEvent('wasabi_mining:sellRock', distance)
end