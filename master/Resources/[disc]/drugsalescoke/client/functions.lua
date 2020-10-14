TryToSellCoke = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsalescoke: ped: " .. pedId .. " not able to sell to.")
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

        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end

SellCoke = function()
    ESX.TriggerServerCallback("disc-drugsalescoke:sellDrug", function(soldDrug)
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


