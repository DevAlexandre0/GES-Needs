local Utils = require 'shared/utils'
local Config = require 'config'

local GES = {}
GES.modules = {
    temperature = GetResourceState('GES-Temperature') == 'started',
    wetness = GetResourceState('GES-Wetness') == 'started',
    stamina = GetResourceState('GES-Stamina') == 'started',
    injury = GetResourceState('GES-Injury') == 'started',
    sickness = GetResourceState('GES-Sickness') == 'started'
}

local function setMult(src, key, val)
    local state = Player(src).state
    if state then
        state:set(key, val, true)
    end
end

if GES.modules.temperature and Config.Policy.enableFromTemperature then
    RegisterNetEvent('ges:temperature:changed', function(data)
        local src = source
        if type(data) ~= 'table' then return end
        if data.band == 'cold' then
            for k,v in pairs(Config.Policy.temperature.cold) do
                setMult(src, k, v)
            end
        else
            setMult(src, 'hungerDecayMul', nil)
            setMult(src, 'thirstDecayMul', nil)
            setMult(src, 'energyDecayMul', nil)
        end
    end)
end

if GES.modules.wetness and Config.Policy.enableFromWetness then
    RegisterNetEvent('ges:wetness:changed', function(data)
        local src = source
        if type(data) ~= 'table' or type(data.level) ~= 'number' then return end
        if data.level >= 80 then
            for k,v in pairs(Config.Policy.wetness.soaked) do
                setMult(src, k, v)
            end
        else
            setMult(src, 'energyDecayMul', nil)
            setMult(src, 'stressAdd', nil)
        end
    end)
end

if GES.modules.stamina and Config.Policy.enableFromStamina then
    RegisterNetEvent('ges:stamina:exhausted', function(data)
        local src = source
        TriggerClientEvent('advancedneeds:effect:blackout', src, Config.Policy.stamina.exhaustedBlackoutMs)
    end)
end

if GES.modules.injury and Config.Policy.enableFromInjury then
    RegisterNetEvent('ges:injury:update', function(data)
        local src = source
        if type(data) ~= 'table' then return end
        if data.bleeding then
            for k,v in pairs(Config.Policy.injury.bleeding) do setMult(src, k, v) end
        else
            for k,_ in pairs(Config.Policy.injury.bleeding) do setMult(src, k, nil) end
        end
        if data.fracture then
            for k,v in pairs(Config.Policy.injury.fracture) do setMult(src, k, v) end
        else
            for k,_ in pairs(Config.Policy.injury.fracture) do setMult(src, k, nil) end
        end
    end)
end

if GES.modules.sickness and Config.Policy.enableFromSickness then
    RegisterNetEvent('ges:sickness:update', function(data)
        local src = source
        if type(data) ~= 'table' then return end
        if data.fever then
            for k,v in pairs(Config.Policy.sickness.fever) do setMult(src, k, v) end
        else
            for k,_ in pairs(Config.Policy.sickness.fever) do setMult(src, k, nil) end
        end
        if data.type == 'foodpoison' then
            for k,v in pairs(Config.Policy.sickness.foodpoison) do setMult(src, k, v) end
        else
            for k,_ in pairs(Config.Policy.sickness.foodpoison) do setMult(src, k, nil) end
        end
    end)
end

function GES.ApplyBlizzard(src)
    if not Config.BlizzardMode.enabled then return end
    if GES.modules.temperature then return end
    setMult(src, 'thirstDecayMul', Config.BlizzardMode.thirstDecayMul)
    setMult(src, 'hungerDecayMul', Config.BlizzardMode.hungerDecayMul)
    setMult(src, 'energyDecayMul', Config.BlizzardMode.energyDecayMul)
    setMult(src, 'stressAdd', Config.BlizzardMode.stressBaseGain)
end
AddEventHandler('onResourceStart', function(res)
    if res == 'GES-Temperature' then
        GES.modules.temperature = true
    elseif res == 'GES-Wetness' then
        GES.modules.wetness = true
    elseif res == 'GES-Stamina' then
        GES.modules.stamina = true
    elseif res == 'GES-Injury' then
        GES.modules.injury = true
    elseif res == 'GES-Sickness' then
        GES.modules.sickness = true
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, id in ipairs(GetPlayers()) do
        local state = Player(id).state
        if state then
            state:set('thirstDecayMul', nil, true)
            state:set('hungerDecayMul', nil, true)
            state:set('energyDecayMul', nil, true)
            state:set('stressAdd', nil, true)
        end
    end
end)

return GES
