RegisterNetEvent('advancedneeds:useItem', function(item)
    local src = source
    local effect = Config.Items[item]
    if not effect then return end

    -- consume item
    exports.ox_inventory:RemoveItem(src, item, 1)

    -- apply effects
    for need, value in pairs(effect) do
        if StatusConfig[need] then
            exports['fivem-needs']:SvrAddNeed(src, need, value)
        end
    end
end)
