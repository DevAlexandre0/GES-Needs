local Config = require 'config'
local Utils = require 'shared/utils'
local API = require 'shared/api'
local Persist = require 'server/persistence'
local GES = require 'server/ges'

for name,def in pairs(Config.Statuses) do
    API.RegisterNeed(name, def)
end

local thresholds = {}

local function handleThreshold(src, name, value, def)
    thresholds[src] = thresholds[src] or {}
    thresholds[src][name] = thresholds[src][name] or {}
    local states = thresholds[src][name]
    for i,rule in ipairs(def.thresholds or {}) do
        local condition = (rule.lt and value < rule.lt) or (rule.gt and value > rule.gt)
        if condition and not states[i] then
            states[i] = true
            TriggerClientEvent('advancedneeds:threshold:enter', src, {need=name, level=i, value=value})
            for _,eff in ipairs(rule.effects or {}) do
                TriggerClientEvent('advancedneeds:effect:'..eff.type, src, eff.value)
            end
        elseif not condition and states[i] then
            states[i] = nil
            TriggerClientEvent('advancedneeds:threshold:leave', src, {need=name, level=i, value=value})
        end
    end
end

AddEventHandler('playerJoining', function()
    local src = source
    local loaded = Persist.Load(src)
    local defaults = {}
    for name,def in pairs(API.Defs) do
        local val = def.default or Config.MaxValue
        if loaded and loaded[name] then val = loaded[name] end
        defaults[name] = val
        API.SvrSetNeed(src, name, val)
    end
    TriggerClientEvent('fivem-needs:syncAll', src, API.Defs, defaults, API.TickRate)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local data = API.SvrGetAllNeeds(src)
    if data then Persist.Save(src, data) end
    thresholds[src] = nil
end)

CreateThread(function()
    while true do
        Wait(Config.TickSeconds * 1000)
        for _,id in ipairs(GetPlayers()) do
            for name,def in pairs(API.Defs) do
                local val = API.SvrGetNeed(id, name) or def.default or Config.MaxValue
                local decay = def.decay or 0
                local mul = GlobalState['m:'..id..':'..name..'DecayMul'] or 1.0
                decay = decay * mul
                val = val - decay
                if name == 'stress' then
                    val = val + (GlobalState['m:'..id..':stressAdd'] or Config.BlizzardMode.stressBaseGain or 0)
                end
                val = Utils.Clamp(val, Config.MinValue, Config.MaxValue)
                API.SvrSetNeed(id, name, val)
                handleThreshold(id, name, val, def)
                if def.damageAt and val <= def.damageAt and Config.DamagePerTick > 0 then
                    TriggerClientEvent('fivem-needs:damage', id, Config.DamagePerTick)
                end
            end
            GES.ApplyBlizzard(id)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.AutoSaveSeconds * 1000)
        for _,id in ipairs(GetPlayers()) do
            local data = API.SvrGetAllNeeds(id)
            if data then Persist.Save(id, data) end
        end
    end
end)

exports('SvrGetStatus', function(src, name)
    return API.SvrGetStatus(src, name)
end)
