local Utils = require 'shared/utils'

local function blackout(ms)
    ms = ms or 500
    DoScreenFadeOut(250)
    Wait(ms)
    DoScreenFadeIn(250)
end

local function shake(intensity, duration)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity)
    if duration then
        Wait(duration)
        StopGameplayCamShaking(true)
    end
end

RegisterNetEvent('advancedneeds:effect:blackout', blackout)
RegisterNetEvent('advancedneeds:effect:shake', function(intensity, duration)
    shake(intensity, duration)
end)

RegisterNetEvent('advancedneeds:effect:breath', function(style)
    -- Placeholder for breath audio hooks
    Utils.Debug(('breath effect %s'):format(style))
end)

RegisterNetEvent('advancedneeds:effect:sway', function(level)
    -- simple camera sway
    if level == 'low' then
        ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 0.05)
        Wait(2000)
        StopGameplayCamShaking(true)
    end
end)
