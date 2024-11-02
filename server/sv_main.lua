---@diagnostic disable: undefined-field
local propList = {}

-- If an entity is removed, we check if it was one of the props attached to a player, if so we remove it from the list
AddEventHandler('entityRemoved', function(entity)
    -- Check if entity is a prop
    if GetEntityType(entity) ~= 3 then return end

    -- Ensure it is a weapon of the right type
    local entityModel = GetEntityModel(entity)
    local isWeapon = false
    for _, weapon in ipairs(Config.Weapons) do
        if entityModel == weapon.NameHash then
            isWeapon = true
            break
        end
    end
    if not isWeapon then return end

    -- Check if the weapon is in the list, and remove if it is
    local entityNetId = NetworkGetNetworkIdFromEntity(entity)
    for _, weapons in pairs(propList) do
        for i = #weapons, 1, -1 do
            if weapons[i] == entityNetId then
                table.remove(weapons, i)
            end
        end
    end
end)

-- When the client spawns a weapon prop, we save it here
RegisterNetEvent('gs_weaponcarry:weaponPropSpawned')
AddEventHandler('gs_weaponcarry:weaponPropSpawned', function(netId)
    local src = source
    if propList[src] == nil then
        propList[src] = {}
    end
    table.insert(propList[src], netId)
end)

-- If a player disconnects, we delete all the weapons that were attached to him, to avoid floating weapons
AddEventHandler('playerDropped', function(reason)
    local src = source

    if propList[src] == nil then
        return
    end

    for _, netId in ipairs(propList[src]) do
        local entity = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(entity) then
            if GetEntityType(entity) == 3 then
                DeleteEntity(entity)
            end
        end
    end
end)
