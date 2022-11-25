-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.esxImport = function()
    if IsDuplicityVersion() then
        --[[ SERVER ]]
        return exports['es_extended']:getSharedObject()
    else
        --[[ CLIENT ]]
        return exports['es_extended']:getSharedObject()
    end
end

Config.checkForUpdates = true -- Check for Updates?

Config.axe = {
    prop = `prop_tool_pickaxe`, -- Default: `prop_tool_pickaxe`
    breakChance = 20 -- When failing to mine rock, this is the percentage of a chance that your pickaxe will 'break'
}

Config.rocks = { -- Items obtained from mining
    { item = 'emerald', price = {190, 220}, difficulty = {'medium', 'medium', 'easy'} },
    { item = 'diamond', price = {150, 180}, difficulty = {'medium', 'easy', 'easy'} },
    { item = 'copper', price = {110, 140}, difficulty = {'medium', 'easy'} },
    { item = 'iron', price = {70, 100}, difficulty = {'easy', 'easy'} },
    { item = 'steel', price = {40, 60}, difficulty = {'easy', 'easy'} },
}


Config.miningAreas = {
    vec3(2977.45, 2741.62, 44.62), -- vec3 of locations for mining stones
    vec3(2982.64, 2750.89, 42.99),
    vec3(2994.92, 2750.43, 44.04),
    vec3(2958.21, 2725.44, 50.16),
    vec3(2946.3, 2725.36, 47.94),
    vec3(3004.01, 2763.27, 43.56),
    vec3(3001.79, 2791.01, 44.82)
}

Config.sellShop = {
    enabled = true, -- Enable spot to sell the things mined?
    coords = vec3(122.1, 6405.69, 31.36-0.9), -- Location of buyer
    heading = 314.65, -- Heading of ped
    ped = 'cs_joeminuteman' -- Ped name here
}

-- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
RegisterNetEvent('wasabi_mining:notify', function(title, message, msgType)
    msgType = msgType or 'inform'

    lib.notify({
        title = title,
        description = message,
        type = msgType
    })
end)