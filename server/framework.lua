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

AddEventHandler('onResourceStart', function(res)
    if Framework.mode ~= 'standalone' then return end
    if res == 'es_extended' then
        Framework.mode = 'esx'
        Utils.Debug('Detected ESX')
    elseif res == 'qb-core' then
        Framework.mode = 'qb'
        Utils.Debug('Detected QBCore')
    end
end)

-- Robust identifier resolution across ESX/QB/standalone
function Framework.GetIdentifier(src)
    -- fallback license
    local license
    for _,id in ipairs(GetPlayerIdentifiers(src)) do
        if id:find('license:') then license = id:sub(9) break end
    end
    if Framework.mode == 'esx' then
        local ESX = rawget(_G, 'ESX') or (exports['es_extended'] and exports['es_extended']:getSharedObject())
        if ESX and ESX.GetPlayerFromId then
            local x = ESX.GetPlayerFromId(src)
            if x and x.identifier then return x.identifier end
        end
    elseif Framework.mode == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
            local p = QBCore.Functions.GetPlayer(src)
            if p and p.PlayerData and p.PlayerData.citizenid then return p.PlayerData.citizenid end
        end
    end
    return license or ('src'..src)
end

-- ESX/QB shims kept minimal. Avoid callback over NetEvent (unsupported).
-- Provide an export for ESX-style status retrieval.
exports('esx_getStatus', function(src, name)
    return exports['fivem-needs']:SvrGetStatus(src, name)
end)

return Framework
