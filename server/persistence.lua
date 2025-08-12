local Utils = require 'shared/utils'
local Framework = require 'server/framework'

local Persist = {}

local useMysql = GetResourceState('oxmysql') == 'started'

function Persist.Load(src)
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return nil end
    if useMysql then
        local result = MySQL.single.await('SELECT data FROM needs_status WHERE identifier = ?', {identifier})
        
    if result and result.data then
        local ok, obj = pcall(json.decode, result.data)
        if ok and type(obj)=='table' then return obj end
    end
    return nil
    else
        local data = GetResourceKvpString('needs:'..identifier)
        return data and json.decode(data)
    end
end

function Persist.Save(src, data)
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end
    local ok, jsonData = pcall(json.encode, data or {})
    if not ok then jsonData = '{}' end
    if useMysql then
        MySQL.update.await('INSERT INTO needs_status (identifier, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)', {identifier, jsonData})
    else
        SetResourceKvp('needs:'..identifier, jsonData)
    end
end

return Persist
