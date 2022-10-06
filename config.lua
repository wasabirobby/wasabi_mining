-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.checkForUpdates = true -- Check for Updates?

Config.DiscordMiningLogs = false --Set true to enable discord logs for mined ore. (Can set webhooks in wasabi_mining/server/discordwebhook.lua)
Config.DiscordCheatLogs = true --Set true to enable possible cheater logs. (Can set webhooks in wasabi_mining/server/discordwebhook.lua)

Config.OldESX = false --Getting 'canCarryItem' error? Set this to true if you're using limit system.

Config.Axe = `prop_tool_pickaxe` --Default: `prop_tool_pickaxe`

Config.AxeBreakPercent = 50 --When failing to mine rock, this is the percentage of a chance that your pickaxe will 'break'

Config.Rocks = { -- Items obtained from mining rocks
    'emerald',
    'diamond',
    'copper',
    'iron',
    'steel'
}

Config.RockPrices = { -- Items sell ranges. Ex: [item_name] = {price(lowest), price(highest)}
    ['emerald'] = {190, 220},
    ['diamond'] = {150, 180},
    ['copper'] = {110, 140},
    ['iron'] = {70, 100},
    ['steel'] = {40, 60}
}

Config.MiningAreas = {
    vector3(2977.45, 2741.62, 44.62), -- vector3 of locations for mining stones
    vector3(2982.64, 2750.89, 42.99),
    vector3(2994.92, 2750.43, 44.04),
    vector3(2958.21, 2725.44, 50.16),
    vector3(2946.3, 2725.36, 47.94),
    vector3(3004.01, 2763.27, 43.56),
    vector3(3001.79, 2791.01, 44.82)
}

Config.SellShop = vector3(122.1, 6405.69, 31.36) -- X, Y, Z Coords of where 

Language = {
    --Blips
    ['mining_blips'] = 'Mine',
    ['sell_shop_blip'] = 'Mining Sales',

    --Help Text
    ['intro_instruction'] = 'Press ~INPUT_ATTACK~ to mine rocks, ~INPUT_FRONTEND_RRIGHT~ to cancel.',

    --3D Text
    ['mine_rock'] = 'PRESS [~g~E~s~] TO MINE ROCK',
    ['sell_material'] = 'PRESS [~g~E~s~] TO SELL MATERIAL',

    --Notifications(Success)
    ['rewarded'] = 'You have been rewarded 1x',
    ['sold_for'] = 'You have sold',
    ['sold_for2'] = 'for $',

    --Notifications(Failed)
    ['failed_mine'] = 'You failed to mine rock!',
    ['no_pickaxe'] = 'You do not have a pickaxe!',
    ['axe_broke'] = 'You hit the rock wrong and your axe snapped!',
    ['cantcarry'] = 'No more room to carry 1x',
    ['possible_cheater'] = 'You have been reported to staff.',

    --Kicked Message
    ['kicked'] = 'You have been kicked and reported to staff for possible cheating.'
}

RegisterNetEvent('wasabi_mining:notify')
AddEventHandler('wasabi_mining:notify', function(message)	
    -- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    ESX.ShowNotification(message)
end)
