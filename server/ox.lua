local Config = require 'config'
local API = require 'shared/api'
local Utils = require 'shared/utils'

local hasOxInv = GetResourceState('ox_inventory') == 'started'
local cooldowns = {}

if not hasOxInv then
    Utils.Debug('ox_inventory not running; skipping item registration')
    return
end

local RegisterUsable = exports.ox_inventory.RegisterUsableItem or exports.ox_inventory.registerUsableItem

for item, data in pairs(Config.Items or {}) do
    RegisterUsable(item, function(src, itemInfo)
        local cdKey = ('%s:%s'):format(src, itemInfo.name or item)
        local now = os.time()
        if cooldowns[cdKey] and cooldowns[cdKey] > now then return end
        cooldowns[cdKey] = now + 2
        TriggerClientEvent('fivem-needs:client:useItem', src, item, data)
    end)
end

RegisterNetEvent('fivem-needs:server:consumeItem', function(item)
    local src = source
    if type(item) ~= 'string' then return end
    item = tostring(item)
    local data = Config.Items[item]
    if not data then return end
    local now = os.time()
    local cdKey = ('%s:%s'):format(src, item)
    if cooldowns[cdKey] and cooldowns[cdKey] > now then return end

    local removed = exports.ox_inventory:RemoveItem(src, item, 1)
    if not removed or removed < 1 then return end

    cooldowns[cdKey] = now + 2

    if data.hunger then API.SvrAddNeed(src, 'hunger', data.hunger) end
    if data.thirst then API.SvrAddNeed(src, 'thirst', data.thirst) end
    if data.energy then API.SvrAddNeed(src, 'energy', data.energy) end
    if data.stress then API.SvrAddNeed(src, 'stress', data.stress) end

    if data.debuff and type(data.debuff) == 'table' then
        local state = Player(src).state
        for k,v in pairs(data.debuff) do
            if k ~= 'duration' then
                state:set(k, v, true)
            end
        end
        SetTimeout(((data.debuff.duration or 60) * 1000), function()
            for k,_ in pairs(data.debuff) do
                if k ~= 'duration' then
                    state:set(k, nil, true)
                end
            end
        end)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        local now = os.time()
        for k,expires in pairs(cooldowns) do
            if expires <= now then cooldowns[k] = nil end
        end
    end
end)
