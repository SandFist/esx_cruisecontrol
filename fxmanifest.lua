fx_version 'adamant'

game 'gta5'

description 'CruiseControl System for ESX'

version '1.6.5-B'

dependencies {
  'es_extended'
}

client_scripts {
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config.lua',
  'client/main.lua'
}
