local Utils = require 'shared/utils'
local Config = require 'config'

local API = {}
API.Defs = {}
API.TickRate = Config.TickSeconds

local isServer = IsDuplicityVersion()

function API.RegisterNeed(name, def)
    API.Defs[name] = def
end

function API.SetTickRate(sec)
    API.TickRate = sec
end

-- CLIENT SIDE
if not isServer then
    local cache = {}

    function API.GetNeed(name)
        return LocalPlayer.state['need:'..name]
    end

    function API.SetNeed(name, val)
        TriggerServerEvent('fivem-needs:set', name, val)
    end

    function API.AddNeed(name, val)
        TriggerServerEvent('fivem-needs:add', name, val)
    end

    function API.GetAllNeeds()
        for k,_ in pairs(API.Defs) do
            cache[k] = LocalPlayer.state['need:'..k]
        end
        return cache
    end

    function API.GetStatus(name)
        if name then
            return API.GetNeed(name)
        end
        return API.GetAllNeeds()
    end

else -- SERVER SIDE
    local players = {}

    function API.EnsurePlayer(src)
        players[src] = players[src] or {}
        return players[src]
    end

    function API.SvrGetNeed(src, name)
        local p = players[src]
        return p and p[name]
    end

    function API.SvrSetNeed(src, name, val)
        local p = API.EnsurePlayer(src)
        local clamped = Utils.Clamp(val, Config.MinValue, Config.MaxValue)
        if p[name] == clamped then return end
        p[name] = clamped
        local player = Player(src)
        if player then
            player.state:set('need:'..name, clamped, true)
            GlobalState['p:'..src..':'..name] = clamped
        end
    end

    function API.SvrAddNeed(src, name, delta)
        local cur = API.SvrGetNeed(src, name) or 0
        API.SvrSetNeed(src, name, cur + delta)
    end

    function API.SvrGetAllNeeds(src)
        return players[src]
    end

    function API.SvrGetStatus(src, name)
        local p = players[src]
        if not p then return nil end
        if name then return p[name] end
        local snapshot = {}
        for k,v in pairs(p) do snapshot[k] = v end
        snapshot._meta = { ts = os.time(), owner = src, version = '1.0.0' }
        return snapshot
    end

    AddEventHandler('playerDropped', function()
        players[source] = nil
    end)

    local function validate(name, val)
        return type(name) == 'string' and type(val) == 'number' and API.Defs[name]
    end

    RegisterNetEvent('fivem-needs:set', function(name, val)
        local src = source
        if not validate(name, val) then return end
        API.SvrSetNeed(src, name, val)
    end)

    RegisterNetEvent('fivem-needs:add', function(name, val)
        local src = source
        if not validate(name, val) then return end
        API.SvrAddNeed(src, name, val)
    end)
end

return API
