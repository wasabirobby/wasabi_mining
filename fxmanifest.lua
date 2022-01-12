fx_version 'bodacious'

game 'gta5'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/main.js'
}

client_scripts {
    'client/client.lua',
    'client/functions.lua',
    'client/skillbar.lua',
    'config.lua'
}

server_scripts {
    'server/server.lua',
    'server/discordwebhook.lua',
    'config.lua'
}