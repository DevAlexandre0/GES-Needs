local Utils = require 'shared/utils'
local Config = require 'config'
local API = require 'shared/api'

local needs = {}

RegisterNetEvent('fivem-needs:syncAll', function(defs, values, tick)
    for k,v in pairs(defs) do
        API.RegisterNeed(k, v)
    end
    API.SetTickRate(tick)
    for k,v in pairs(values) do
        needs[k] = v
    end
    local bag = ('player:%s'):format(GetPlayerServerId(PlayerId()))
    for k,_ in pairs(defs) do
        AddStateBagChangeHandler('need:'..k, bag, function(_, _, val)
            needs[k] = val
        end)
    end
end)

exports('GetStatus', function(name)
    if name then return needs[name] end
    local snapshot = {}
    for k,v in pairs(needs) do snapshot[k] = v end
    snapshot._meta = { ts = os.time(), owner = GetPlayerServerId(PlayerId()), version = '1.0.0' }
    return snapshot
end)
