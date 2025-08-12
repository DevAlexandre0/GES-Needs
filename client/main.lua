local statusCache = {}

RegisterNetEvent('advancedneeds:sync', function(data)
    statusCache = data
end)

exports('GetStatus', function(name)
    if not name then return statusCache end
    return statusCache[name]
end)

-- ตรวจ decay/threshold ฝั่ง client (เช่น เอฟเฟกต์)
CreateThread(function()
    while true do
        Wait(Config.TickSeconds * 1000)
        for name, status in pairs(statusCache) do
            -- Trigger effects based on thresholds
        end
    end
end)
