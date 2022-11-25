-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

version '2.0.0'
author 'wasabirobby#5110'
description 'A simple yet smooth ESX based mining script'

shared_scripts {
    '@ox_lib/init.lua',
    'configuration/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}
