fx_version 'adamant'

game 'gta5'

description 'Disc Death'

version '1.0.1'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/death.lua',
}

server_scripts {
    'config.lua',
    'server/main.lua',
    'server/death.lua',
    "@mysql-async/lib/MySQL.lua"
}
