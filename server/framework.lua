-- Auto detect ESX / QB
if GetResourceState('es_extended') == 'started' then
    Framework = 'ESX'
elseif GetResourceState('qb-core') == 'started' then
    Framework = 'QB'
else
    Framework = 'Standalone'
end
