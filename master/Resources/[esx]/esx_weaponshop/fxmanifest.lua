fx_version 'adamant'

game 'gta5'

description 'ESX Weapon Shop'

version '1.1.0'

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'locales/cs.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'locales/cs.lua',
	'config.lua',
	'client/main.lua'
}

files {
	'html/img/WEAPON_PISTOL.png',
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/logo.png',
	'html/Roboto-Regular.ttf'
}

dependency 'es_extended'
