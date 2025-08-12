local Utils = require 'shared/utils'

local Framework = { mode = 'standalone' }

if GetResourceState('es_extended') == 'started' then
    Framework.mode = 'esx'
    Utils.Debug('Detected ESX')
elseif GetResourceState('qb-core') == 'started' then
    Framework.mode = 'qb'
    Utils.Debug('Detected QBCore')
else
    Utils.Debug('Running standalone mode')
end

function Framework.GetIdentifier(src)
    if Framework.mode == 'esx' then
        local xPlayer = exports['es_extended']:getPlayerFromId(src)
        return xPlayer and xPlayer.identifier
    elseif Framework.mode == 'qb' then
        local player = exports['qb-core']:GetPlayer(src)
        return player and player.PlayerData.citizenid
    else
        for _,id in ipairs(GetPlayerIdentifiers(src)) do
            if id:find('license:') then return id end
        end
    end
end

-- ESX status shims
if Framework.mode == 'esx' then
    RegisterNetEvent('esx_status:getStatus', function(name, cb)
        local src = source
        cb(exports['fivem-needs']:SvrGetStatus(src, name))
    end)
    RegisterNetEvent('esx_basicneeds:healPlayer', function()
        TriggerEvent('fivem-needs:healPlayer')
    end)
end

return Framework
