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
end)

CreateThread(function()
    while true do
        Wait(1000)
        for k,_ in pairs(API.Defs) do
            needs[k] = LocalPlayer.state['need:'..k] or needs[k]
        end
    end
end)

exports('GetStatus', function(name)
    if name then return needs[name] end
    local snapshot = {}
    for k,v in pairs(needs) do snapshot[k] = v end
    snapshot._meta = { ts = os.time(), owner = GetPlayerServerId(PlayerId()), version = '1.0.0' }
    return snapshot
end)
