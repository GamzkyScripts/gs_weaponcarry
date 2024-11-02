fx_version 'cerulean'
games { 'gta5' }

author 'Eviate'
description 'Weapon Carry Script'
version '1.0.0'

lua54 'yes'

ui_page 'clipboard/index.html'

files {
    'clipboard/index.html',
    'clipboard/copy.js',
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/cl_*.lua',
}

server_scripts {
    'server/sv_*.lua',
}