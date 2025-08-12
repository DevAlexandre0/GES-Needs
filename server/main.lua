local playerNeeds = {}

exports('SvrGetStatus', function(src, name)
    if not name then return playerNeeds[src] end
    return playerNeeds[src] and playerNeeds[src][name] or nil
end)

-- tick loop
CreateThread(function()
    while true do
        Wait(Config.TickSeconds * 1000)
        for _, src in ipairs(GetPlayers()) do
            for name, cfg in pairs(StatusConfig) do
                local decay = cfg.decay or 0
                -- apply blizzard multipliers
                if name == 'hunger' then decay = decay * 1.25 end
                if name == 'thirst' then decay = decay * 1.50 end
                if name == 'energy' then decay = decay * 1.20 end

                playerNeeds[src][name] = math.max(Config.MinValue, playerNeeds[src][name] - decay)
            end
            TriggerClientEvent('advancedneeds:sync', src, playerNeeds[src])
        end
    end
end)
