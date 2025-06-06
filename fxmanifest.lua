-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Syme Robinson'
description 'Agencies & Utilities Resource'

-- 1) The shared config is declared as a shared_script so that both client and server can see it
shared_script 'utils/shared/config.lua'

-- 2) Client‐only scripts.  `menu.lua` must be listed before `main.lua` if `main.lua` calls its export.
client_scripts {
    'utils/client_main.lua',
    'modules/agencies/client/menu.lua',
    'modules/agencies/client/main.lua'
}

-- 3) Server‐only scripts
server_scripts {
    'utils/server_main.lua',
    'modules/agencies/server/main.lua'
}

files {
    'data/**'
}
