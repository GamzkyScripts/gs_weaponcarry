---@diagnostic disable: undefined-field

-- If the resource is stopped, ensure all props on the player are despawned as well
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    DeleteAllWeaponProps()
end)

-- We have to wait for the player to load in, before attaching any props to the player
function onPlayerLoaded(cb)
    -- When a player loads in, the default character is 'Michael', so we wait for the game to load the correct character
    local pedModel = nil
    while pedModel == GetHashKey('Michael') do
        Wait(100)
        pedModel = GetEntityModel(PlayerPedId())
    end

    -- I added an example for esx_multicharacter, the code below ensure the weapons only spawn once a player has chosen a character.
    -- You might need to change this if you are using a different character system.
    if (GetResourceState('esx_multicharacter') == 'started') then
        local ESX = exports['es_extended']:getSharedObject()
        while (not ESX.PlayerLoaded) do
            ESX = exports['es_extended']:getSharedObject()
            Wait(500)
        end
    end
    cb()
end

onPlayerLoaded(function()
    -- Save the current ped model such that we can detect a change
    local previousPedModel = GetEntityModel(PlayerPedId())

    CreateThread(function()
        while true do
            local ped = PlayerPedId()

            -- Reset equipped weapon
            for _, weapon in ipairs(Config.Weapons) do
                weapon.Equiped = false
            end

            -- Check the Config.Weapons list if any of the weapons is currently equipped
            local _, weaponHash = GetCurrentPedWeapon(ped, true)
            local iWeapon = nil
            for i, weapon in ipairs(Config.Weapons) do
                if weapon.WeaponHash == weaponHash then
                    iWeapon = i
                    break
                end
            end

            -- If a weapon is equipped, set the Equiped value to true
            if iWeapon then
                Config.Weapons[iWeapon].Equiped = true
            end

            -- Can the weapons be spawned?
            local enableWeapons = DoesPlayerRequireWeapons()
            if not enableWeapons then
                DeleteAllWeaponProps()
            end

            -- Check if the ped model has changed, if so we need to respawn the weapons
            local currentPedModel = GetEntityModel(ped)
            if (currentPedModel ~= previousPedModel) then
                DeleteAllWeaponProps()
                previousPedModel = currentPedModel
            end

            -- Loop over all weapons and see if they need to be displayed as props
            if enableWeapons then
                for _, weaponData in ipairs(Config.Weapons) do
                    -- Check if the player has the weapon in their inventory
                    local playerHasWeapon = DoesPlayerHaveWeapon(weaponData.Item)
                    if playerHasWeapon then
                        -- If weapon is equipped by the player, it should not display as a prop so we delete the weapon entity if it exists
                        if weaponData.Equiped and DoesEntityExist(weaponData.Entity) then
                            DeleteEntity(weaponData.Entity)
                            weaponData.Entity = -1
                            goto continue
                        end

                        -- The equipped weapon does not require a prop/entity, no need to continue
                        if weaponData.Equiped then
                            goto continue
                        end

                        -- If the weapon entity already exists, continue.
                        if DoesEntityExist(weaponData.Entity) then
                            goto continue
                        end

                        -- The weapon is not equipped, and also does not exist as a prop, so we spawn it
                        weaponData.Entity = SpawnWeaponProp(weaponData)

                        -- If a weapon is not present in a player inventory, ensure it is not displayed as a prop
                    elseif DoesEntityExist(weaponData.Entity) then
                        DeleteEntity(weaponData.Entity)
                        weaponData.Entity = -1
                    end
                    ::continue::
                end
            end

            Wait(250)
        end
    end)
end)

function DoesPlayerHaveWeapon(itemName)
    -- Handle the case if ox_inventory is used
    if (GetResourceState('ox_inventory') == 'started') then
        return exports.ox_inventory:GetItemCount(itemName) > 0
    end

    -- Handle the case if es_extended or qb-core is used
    if (GetResourceState('es_extended') == 'started' or GetResourceState('qb-core') == 'started') then
        return HasPedGotWeapon(PlayerPedId(), GetHashKey(itemName), false)
    end

    return false
end

function DoesPlayerRequireWeapons()
    -- If player is dead, ensure all props are deleted, you can add your own additions for cases where you want to remove the weapons.

    local isDead = IsPedDeadOrDying(PlayerPedId(), true)

    return not (isDead)
end

-- This function spawns the weapon prop and attaches it to the player at the right position
function SpawnWeaponProp(weaponData)
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))

    if not HasModelLoaded(weaponData.PropHash) then
        LoadPropDict(weaponData.PropHash)
    end

    local weaponEntity = CreateObject(weaponData.PropHash, x, y, z + 0.2, true, true, true)
    while not DoesEntityExist(weaponEntity) do
        Wait(50)
    end

    SetEntityCollision(weaponEntity, false, false)

    local bone = GetPedBoneIndex(ped, weaponData.Bone)
    local weaponPosition = GetWeaponPositionInfo(weaponData.Position)
    local xpos, ypos, zpos, xrot, yrot, zrot = table.unpack(weaponPosition)
    AttachEntityToEntity(weaponEntity, ped, bone, xpos, ypos, zpos, xrot, yrot, zrot, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(weaponData.PropHash)

    -- We sync the weapon prop with the server, in case the player disconnects to remove the props, otherwise they remaing floating in the air
    TriggerServerEvent('gs_weaponcarry:weaponPropSpawned', NetworkGetNetworkIdFromEntity(weaponEntity))
    return weaponEntity
end

-- This function loads the prop dict
function LoadPropDict(modelHash)
    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)
        Wait(50)
    end
end

-- This function deletes all the weapons currently on the body as a prop
function DeleteAllWeaponProps()
    for _, weaponData in ipairs(Config.Weapons) do
        if DoesEntityExist(weaponData.Entity) then
            DeleteEntity(weaponData.Entity)
        end
    end
end

-- This function gets the configured weapon position on the body, based on clothing
function GetWeaponPositionInfo(clothingPositions)
    -- Pick the default position based on the gender
    local gender = IsPedMale(PlayerPedId()) and 'male' or 'female'
    local weaponPosition = clothingPositions[gender].default

    -- If skinchanger is used, we can define a position based on the clothing of the player
    if (GetResourceState('skinchanger') == 'started') then
        local skinReceived = false
        while (not skinReceived) do
            Wait(0)

            TriggerEvent("skinchanger:getSkin", function(skin)
                local gender = skin.sex and 'male' or 'female'
                weaponPosition = clothingPositions[gender].default

                -- Loop over the configured clothing types (so tshirt_1, or bproof_1 for instance)
                for clothingType, clothingData in pairs(clothingPositions[gender]) do
                    -- Loop over the configured clothing indexes, if it is not the default position
                    if (clothingType ~= 'default') then
                        for clothingIndex, position in pairs(clothingData) do
                            -- If we have found matching clothing, we use the specified position
                            if (skin[clothingType] == clothingIndex) then
                                weaponPosition = position
                                break
                            end
                        end
                    end
                end

                -- Ensure the function waits for the event handler above to finish
                skinReceived = true
            end)
        end
    end

    return weaponPosition
end
