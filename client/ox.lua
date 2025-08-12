-- ใช้ ox_inventory สำหรับ usable items
for item, data in pairs(Config.Items) do
    if exports.ox_inventory:Search('count', item) then
        exports.ox_inventory:RegisterUsableItem(item, function(dataItem, slot, inventory)
            TriggerServerEvent('advancedneeds:useItem', item)
        end)
    end
end
