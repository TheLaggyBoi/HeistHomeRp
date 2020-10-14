fx_version 'adamant'

game 'gta5'

description 'Disc MDT'

version '1.0.0'

client_scripts {
    'config/config.lua',
    'config/configcolours.lua',
    'client/main.lua',
    'client/vehicles.lua',
    'client/civilians.lua',
    'client/crimes.lua',
    'client/reports.lua',
    'client/bolo.lua',
    'client/notifications.lua',
    'utils/utils.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'server/main.lua',
    'server/vehicles.lua',
    'server/reports.lua',
    'server/civilians.lua',
    'server/crimes.lua',
    'server/bolo.lua',
    'server/notifications.lua',
    'utils/utils.lua',
}

ui_page "web/html/index.html"

files {
    "web/html/main.js",
    "web/html/index.html",
    "web/html/notification.wav",
}
