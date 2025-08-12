local Utils = {}

local function debugEnabled()
    return GetConvarInt('needs_debug', 0) == 1
end

function Utils.Debug(msg)
    if debugEnabled() then
        print(('[fivem-needs] %s'):format(msg))
    end
end

function Utils.Clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

return Utils
