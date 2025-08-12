local Config = require 'config'
local Utils = require 'shared/utils'

local hasOxLib = GetResourceState('ox_lib') == 'started'

RegisterNetEvent('fivem-needs:client:useItem', function(item, data)
    local function finished()
        TriggerServerEvent('fivem-needs:server:consumeItem', item)
    end

    if hasOxLib and lib and lib.progressBar then
        if lib.progressBar({
            duration = data.time or 2000,
            label = ('Using %s'):format(item),
            useWhileDead = false,
            canCancel = true,
        }) then
            finished()
        end
    else
        TaskStartScenarioInPlace(PlayerPedId(), data.anim or 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
        Wait(data.time or 2000)
        ClearPedTasks(PlayerPedId())
        finished()
    end
end)
