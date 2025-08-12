local Config = require 'config'
local API = require 'shared/api'
local Utils = require 'shared/utils'

local hasOxInv = GetResourceState('ox_inventory') == 'started'
local cooldowns = {}

if not hasOxInv then
    Utils.Debug('ox_inventory not running; skipping item registration')
    return
end

for item, data in pairs(Config.Items) do
    exports.ox_inventory:registerUsableItem(item, function(src, item)
        local cdKey = ('%s:%s'):format(src, item.name)
        local now = os.time()
        if cooldowns[cdKey] and cooldowns[cdKey] > now then return end
        cooldowns[cdKey] = now + 2
        TriggerClientEvent('fivem-needs:client:useItem', src, item.name, data)
    end)
end

RegisterNetEvent('fivem-needs:server:consumeItem', function(item)
    local src = source
    if type(item) ~= 'string' then return end
    local data = Config.Items[item]
    if not data then return end
    local cdKey = ('%s:%s'):format(src, item)
    local now = os.time()
    if cooldowns[cdKey] and cooldowns[cdKey] > now then return end
    local removed = exports.ox_inventory:RemoveItem(src, item, 1)
    if not removed or removed < 1 then return end
    cooldowns[cdKey] = now + 2
    if data.hunger then API.SvrAddNeed(src, 'hunger', data.hunger) end
    if data.thirst then API.SvrAddNeed(src, 'thirst', data.thirst) end
    if data.energy then API.SvrAddNeed(src, 'energy', data.energy) end
    if data.stress then API.SvrAddNeed(src, 'stress', data.stress) end
    if data.debuff then
        for k,v in pairs(data.debuff) do
            if k ~= 'duration' then
                GlobalState[('m:%s:%s'):format(src, k)] = v
            end
        end
        SetTimeout((data.debuff.duration or 60) * 1000, function()
            for k,_ in pairs(data.debuff) do
                if k ~= 'duration' then
                    GlobalState[('m:%s:%s'):format(src, k)] = nil
                end
            end
        end)
    end
end)
