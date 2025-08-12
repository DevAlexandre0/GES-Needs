-- บังคับ Blizzard Mode multipliers ถ้าเปิด
CreateThread(function()
    while true do
        Wait(Config.TickSeconds * 1000)
        if Config.BlizzardMode then
            for _, src in ipairs(GetPlayers()) do
                GlobalState[('m:%s:thirstDecayMul'):format(src)] = 1.50
                GlobalState[('m:%s:hungerDecayMul'):format(src)] = 1.25
                GlobalState[('m:%s:energyDecayMul'):format(src)] = 1.20
            end
        end
    end
end)
