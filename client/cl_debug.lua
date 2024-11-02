-- This file includes the command to spawn a weapon prop and move it around yourself which you can enable in via Config.Debug.
-- This makes it easy to get the right weapon coordinates at which you can attach the prop to the player.
CreateThread(function()
    if (not Config.Debug) then return end

    local weaponProp = nil
    local MovingProp = false
    local xp, yp, zp, xrp, yrp, zrp = 0.5, 0, 0, 0.0, 0.0, 0.0
    local positionIncrement = 0.005
    local rotationIncrement = 0.5

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end
        if DoesEntityExist(weaponProp) then
            DeleteEntity(weaponProp)
        end
    end)

    RegisterCommand('weaponprop_spawn', function(source, args, rawCommand)
        MovingProp = false
        if DoesEntityExist(weaponProp) then
            DeleteEntity(weaponProp)
        end

        local propName = args[1]
        local propBone = tonumber(args[2]) or 24818
        if (propName == nil) then return end

        AddPropToPlayer(propName, propBone, xp, yp, zp, xrp, yrp, zrp)
        if not DoesEntityExist(weaponProp) then return end

        MovingProp = true
        while (MovingProp) do
            Wait(0)
            if IsControlPressed(0, 21) and IsControlPressed(0, 111) then
                -- L-SHIFT + NUMPAD 8
                yrp = yrp + rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 111) then
                -- NUMPAD 8
                yp = yp + positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 21) and IsControlPressed(0, 110) then
                -- L-ALT + NUMPAD 5
                yrp = yrp - rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 110) then
                -- NUMPAD 5
                yp = yp - positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 21) and IsControlPressed(0, 117) then
                -- L-ALT + NUMPAD 7
                xrp = xrp - rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 117) then
                -- NUMPAD 7
                xp = xp - positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 21) and IsControlPressed(0, 118) then
                -- L-ALT + NUMPAD 9
                xrp = xrp + rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 118) then
                -- NUMPAD 9
                xp = xp + positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 21) and IsControlPressed(0, 108) then
                -- L-ALT + NUMPAD 4
                zrp = zrp + rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 108) then
                -- NUMPAD 4
                zp = zp + positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 21) and IsControlPressed(0, 109) then
                -- L-ALT + NUMPAD 6
                zrp = zrp - rotationIncrement
                RespawnProp(propName, propBone)
            elseif IsControlPressed(0, 109) then
                -- NUMPAD 6
                zp = zp - positionIncrement
                RespawnProp(propName, propBone)
            end

            if IsControlPressed(0, 177) or IsControlPressed(0, 73) then
                -- BACKSPACE OR X
                DeleteEntity(weaponProp)
                MovingProp = false
            end
        end
    end)

    function RespawnProp(propName, propBone)
        DeleteEntity(weaponProp)
        AddPropToPlayer(propName, propBone, xp, yp, zp, xrp, yrp, zrp)
        CopyToClipboard(string.format("{ %.2f, %.2f, %.2f, %.2f, %.2f, %.2f }", xp, yp, zp, xrp, yrp, zrp))
    end

    function AddPropToPlayer(propName, propBone, off1, off2, off3, rot1, rot2, rot3)
        local propHash = GetHashKey(propName)
        local ped = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(ped))

        if not HasModelLoaded(propHash) then
            LoadPropDict(propHash)
        end

        weaponProp = CreateObject(propHash, x, y, z + 0.2, true, true, true)
        while not DoesEntityExist(weaponProp) do
            Wait(50)
        end

        SetEntityCollision(weaponProp, false, false)
        local bone = GetPedBoneIndex(ped, propBone)
        AttachEntityToEntity(weaponProp, ped, bone, off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded(propHash)
    end

    function LoadPropDict(modelHash)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Wait(50)
        end
    end

    function CopyToClipboard(text)
        text = tostring(text)
        SendNUIMessage({
            type = 'copy',
            data = text
        })
        print(('Copied: %s'):format(text))
    end
end)
