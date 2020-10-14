TryToSell = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end
    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sell()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('esx-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('esx_outlawalert:DrugSaleInProgress', {
            x = ESX.Math.Round(pcoords.x, 1),
            y = ESX.Math.Round(pcoords.y, 1),
            z = ESX.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)

        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end
TryToSellcoke = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sellcoke()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('esx-dispatch:drugjob')

        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('esx_outlawalert:DrugSaleInProgress', {
            x = ESX.Math.Round(pcoords.x, 1),
            y = ESX.Math.Round(pcoords.y, 1),
            z = ESX.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)
    end
    ClearPedTasks(PlayerPedId())
end
TryToSellmarijuana = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sellmarijuana()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('esx-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('esx_outlawalert:DrugSaleInProgress', {
            x = ESX.Math.Round(pcoords.x, 1),
            y = ESX.Math.Round(pcoords.y, 1),
            z = ESX.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)
        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end
TryToSelloxy = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > 50 then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Selloxy()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('esx-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('esx_outlawalert:DrugSaleInProgress', {
            x = ESX.Math.Round(pcoords.x, 1),
            y = ESX.Math.Round(pcoords.y, 1),
            z = ESX.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)
        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end

Sell = function()
    ESX.TriggerServerCallback("disc-drugsales:sellDrug", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end
Sellcoke = function()
    ESX.TriggerServerCallback("disc-drugsales:sellDrugcoke", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end
Sellmarijuana = function()
    ESX.TriggerServerCallback("disc-drugsales:sellDrugmarijuana", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end
Selloxy = function()
    ESX.TriggerServerCallback("disc-drugsales:sellDrugoxy", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end

function PlayAnim(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, -8, -1, r and 49 or 0, 0, 0, 0, 0)
    end)
end


function GetStreetAndZone()
	local plyPos = GetEntityCoords(PlayerPedId(), true)
	local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street1 = GetStreetNameFromHashKey(s1)
	local street2 = GetStreetNameFromHashKey(s2)
	local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
	local street = street1 .. ", " .. zone
	return street
end