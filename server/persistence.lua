local Utils = require 'shared/utils'
local Framework = require 'server/framework'

local Persist = {}

local useMysql = GetResourceState('oxmysql') == 'started'

function Persist.Load(src)
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return nil end
    if useMysql then
        local result = MySQL.single.await('SELECT data FROM needs_status WHERE identifier = ?', {identifier})
        return result and json.decode(result.data)
    else
        local data = GetResourceKvpString('needs:'..identifier)
        return data and json.decode(data)
    end
end

function Persist.Save(src, data)
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end
    local jsonData = json.encode(data)
    if useMysql then
        MySQL.insert.await('REPLACE INTO needs_status (identifier, data) VALUES (?, ?)', {identifier, jsonData})
    else
        SetResourceKvp('needs:'..identifier, jsonData)
    end
end

return Persist
