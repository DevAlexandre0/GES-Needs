-- เซฟด้วย oxmysql
function SavePlayerNeeds(src, needs)
    local identifier = GetPlayerIdentifier(src, 0)
    MySQL.update('REPLACE INTO player_needs (identifier, data) VALUES (?, ?)', {
        identifier, json.encode(needs)
    })
end

function LoadPlayerNeeds(src)
    local identifier = GetPlayerIdentifier(src, 0)
    local result = MySQL.single.await('SELECT data FROM player_needs WHERE identifier = ?', {identifier})
    if result and result.data then
        return json.decode(result.data)
    end
    return nil
end
