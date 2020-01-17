fx_version 'adamant'

game 'gta5'

description 'ESX Crate Delivery'

version '0.1.0'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'client/main.lua',
	'client/marker.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'server/main.lua'
}

dependencies {
	'es_extended',
	'cratedrop'
}
