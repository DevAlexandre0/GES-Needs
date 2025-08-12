fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Advanced Needs System (Standalone + ESX/QB autodetect) - Hardcore Blizzard Mode'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua',
    'locales/en.lua'
}

client_scripts {
    'client/ui.lua',
    'client/effects.lua',
    'client/ox.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/persistence.lua',
    'server/ges.lua',
    'server/ox.lua',
    'server/main.lua',
}

exports {
    'GetStatus',
    'GetNeed',
    'SetNeed',
    'AddNeed',
    'RegisterNeed'
}

server_exports {
    'SvrGetStatus',
    'SvrGetNeed',
    'SvrSetNeed',
    'SvrAddNeed',
    'SvrRegisterNeed'
}

provide {
    'esx_status',
    'esx_basicneeds',
    'qb-status',
    'qb-needs'
}
