fx_version 'cerulean'
lua54 'yes'

game 'gta5'

name 'fivem-needs'
description 'Advanced Needs system for hardcore blizzard survival'

provide 'esx_status'
provide 'esx_basicneeds'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua',
    'shared/api.lua'
}

client_scripts {
    'client/ui.lua',
    'client/effects.lua',
    'client/ox.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/persistence.lua',
    'server/ges.lua',
    'server/ox.lua',
    'server/main.lua'
}

exports {
    'GetStatus'
}

server_exports {
    'SvrGetStatus'
}
