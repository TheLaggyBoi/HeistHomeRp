ESX = nil
local pilot, aircraft, parachute, crate, pickup, blip, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu"} -- parachute, pickup case, plane, pilot, crate
local isPickingUp, isProcessing = false, false
local crds = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

    ESX.PlayerData = ESX.GetPlayerData()

    PlayerData = ESX.GetPlayerData()

end)

function hasKeycard (cb)
    cb(true)
end

function ShowNoKeyWarning ()
end

function hasKeycard (cb)
    if (ESX == nil) then return cb(0) end
    ESX.TriggerServerCallback('gunheist:getItemAmount', function(qtty)
      cb(qtty > 0)
    end, 'keycard')
end
function ShowNoKeyWarning () 
    if (ESX == nil) then return end
    exports['mythic_notify']:DoHudText('error', 'You Dont Have A Keycard')
end



RegisterCommand("cratedrop", function(playerServerID, args, rawString)
    local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0) -- ISN'T THIS A TABLE ALREADY?
    TriggerEvent("crateDrop", args[1], tonumber(args[2]), args[3] or false, args[4] or 400.0, {["x"] = playerCoords.x, ["y"] = playerCoords.y, ["z"] = playerCoords.z})
end, false)

RegisterNetEvent("gunheist:OnSatUse")
AddEventHandler("gunheist:OnSatUse", function(playerServerID, rawString)

    hasKeycard(function (hasKeycard)
        if hasKeycard == true then
            ESX.TriggerServerCallback('gunheist:getOnlinePolice',
                function(online)
                    if online >= 4 then
                        local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0) -- ISN'T THIS A TABLE ALREADY?
                        TaskStartScenarioInPlace(PlayerPedId(), 'world_human_stand_mobile_upright', 0, true)
                        Citizen.Wait(10000)
                        ClearPedTasksImmediately(PlayerPedId())
                        TriggerServerEvent('gunheist:alert')
                        Citizen.Wait(2000)
                        TriggerEvent("crateDrop", {["x"] = playerCoords.x, ["y"] = playerCoords.y, ["z"] = playerCoords.z})
                    else
                        exports['mythic_notify']:DoHudText('error', 'Whats The Fun Without Cops?')
                        TriggerServerEvent('gunheist:returnkeycard')
                    end
            end)
        else
            ShowNoKeyWarning()
        end
    end)
end)

RegisterNetEvent("crateDrop")

AddEventHandler("crateDrop", function(weapon, ammo, roofCheck, planeSpawnDistance, dropCoords) -- all of the error checking is done here before passing the parameters to the function itself
    local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
    local dropCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 10, 0)
    local ped        = PlayerPedId()

    exports['mythic_notify']:DoHudText('inform', 'Weapon Shipment Ordered, Supply Drop On its Way!')

    streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetName)
    local emergency = 'code3'
    TriggerServerEvent('gunheist:code3',{
        x = ESX.Math.Round(playerCoords.x, 1),
        y = ESX.Math.Round(playerCoords.y, 1),
        z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, emergency)

    Citizen.CreateThread(function()
        -- print("AMMO: " .. ammo)

        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then
            -- print(("DROP COORDS: success, X = %.4f; Y = %.4f; Z = %.4f"):format(dropCoords.x, dropCoords.y, dropCoords.z))
        else
            dropCoords = {0.0, 0.0, 72.0}
            -- print("DROP COORDS: fail, defaulting to X = 0; Y = 0")
        end

        if roofCheck and roofCheck ~= "false" then  -- if roofCheck is not false then a check will be performed if a plane can drop a crate to the specified location before actually spawning a plane, if it can't, function won't be called
            -- print("ROOFCHECK: true")
            local ray = StartShapeTestRay(vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), vector3(dropCoords.x, dropCoords.y, dropCoords.z), -1, -1, 0)
            local _, hit, impactCoords = GetShapeTestResult(ray)
            -- print("HIT: " .. hit)
            -- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
            -- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
            if hit == 0 or (hit == 1 and #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)) < 10.0) then -- ± 10 units
                -- print("ROOFCHECK: success")
                CrateDrop(planeSpawnDistance, dropCoords)
            else
                -- print("ROOFCHECK: fail")
                return
            end
        else
            -- print("ROOFCHECK: false")
            CrateDrop(planeSpawnDistance, dropCoords)
        end

    end)
end)

function CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)
    local dropCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 10, 0)
    Citizen.CreateThread(function()

        for i = 1, #requiredModels do
            RequestModel(GetHashKey(requiredModels[i]))
            while not HasModelLoaded(GetHashKey(requiredModels[i])) do
                Wait(0)
            end
        end

        --[[
        RequestAnimDict("P_cargo_chute_S")
        while not HasAnimDictLoaded("P_cargo_chute_S") do -- wasn't able to get animations working
            Wait(0)
        end
        ]]

        RequestWeaponAsset(GetHashKey("weapon_flare")) -- flare won't spawn later in the script if we don't request it right now
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end

        local rHeading = math.random(0, 360) + 0.0
        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) -- the plane is spawned at

        -- print(("PLANE COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(rPlaneSpawn.x, rPlaneSpawn.y, rPlaneSpawn.z))
        -- print("PLANE SPAWN DISTANCE: " .. #(vector2(rPlaneSpawn.x, rPlaneSpawn.y) - vector2(dropCoords.x, dropCoords.y)))

        local dx = dropCoords.x - rPlaneSpawn.x
        local dy = dropCoords.y - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates

        aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) -- lock the doors so pirates don't get in
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft) -- works for planes I guess
        SetVehicleEngineOn(aircraft, true, true, false)
        ControlLandingGear(aircraft, 3) -- retract the landing gear
        OpenBombBayDoors(aircraft) -- opens the hatch below the plane for added realism
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

        pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
        SetBlockingOfNonTemporaryEvents(pilot, true) -- ignore explosions and other shocking events
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        SetPlaneMinHeightAboveTerrain(aircraft, 50) -- the plane shouldn't dip below the defined altitude

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

        local droparea = vector2(dropCoords.x, dropCoords.y)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do -- wait for when the plane reaches the dropCoords ± 5 units
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) -- update plane coords for the loop
        end

        if IsEntityDead(pilot) then -- I think this will end the script if the pilot dies, no idea how to return works
            print("PILOT: dead")
            do return end
        end

        TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0) -- disposing of the plane like Rockstar does, send it to 0; 0 coords with -1.0 stop range, so the plane won't be able to achieve its task
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)

        local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0) -- crate will drop to the exact position as planned, not at the plane's current position

        crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true) -- a breakable crate to be spawned directly under the plane, probably could be spawned closer to the plane
        SetEntityLodDist(crate, 1000) -- so we can see it from the distance
        ActivatePhysics(crate)
        SetDamping(crate, 2, 0.1) -- no idea but Rockstar uses it
        SetEntityVelocity(crate, 0.0, 0.0, -0.2) -- I think this makes the crate drop down, not sure if it's needed as many times in the script as I'm using

        parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true) -- create the parachute for the crate, location isn't too important as it'll be later attached properly
        SetEntityLodDist(parachute, 1000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)

        -- PlayEntityAnim(parachute, "P_cargo_chute_S_deploy", "P_cargo_chute_S", 1000.0, false, false, false, 0, 0)
        -- ForceEntityAiAndAnimationUpdate(parachute)

--[[         pickup = CreateAmbientPickup(GetHashKey(weapon), crateSpawn, 0, ammo, GetHashKey("ex_prop_adv_case_sm"), true, true)  ]]-- create the pickup itself, location isn't too important as it'll be later attached properly
        pickup = CreateObject(1228641767, dropCoords.x, dropCoords.y+10, dropCoords.z, true, true, true)
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 0.0245)
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)
        pick = true
        soundID = GetSoundId() -- we need a sound ID for calling the native below, otherwise we won't be able to stop the sound later
        PlaySoundFromEntity(soundID, "Crate_Beeps", pickup, "MP_CRATE_DROP_SOUNDS", true, 0) -- crate beep sound emitted from the pickup

        blip = AddBlipForEntity(pickup)
        SetBlipSprite(blip, 408) -- 351 or 408 are both fine, 408 is just bigger
        SetBlipNameFromTextFile(blip, "AMD_BLIPN")
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAlpha(blip, 120) -- blip will be semi-transparent

        -- local crateBeacon = StartParticleFxLoopedOnEntity_2("scr_crate_drop_beacon", pickup, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)--1.0, false, false, false)
        -- SetParticleFxLoopedColour(crateBeacon, 0.8, 0.18, 0.19, false)

        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true) -- attach the crate to the pickup
        AttachEntityToEntity(pickup, crate, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) -- attach the pickup to the crate, doing it in any other order makes the crate drop spazz out

        while HasObjectBeenBroken(crate) == false do -- wait till the crate gets broken (probably on impact), then continue with the script
            Wait(0)
        end

        local parachuteCoords = vector3(GetEntityCoords(parachute)) -- we get the parachute dropCoords so we know where to drop the flare
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later
        DetachEntity(parachute, true, true)
        -- SetEntityCollision(parachute, false, true) -- pointless right now but would be cool if animations would work and you'll be able to walk through the parachute while it's disappearing
        -- PlayEntityAnim(parachute, "P_cargo_chute_S_crumple", "P_cargo_chute_S", 1000.0, false, false, false, 0, 0)
        DeleteEntity(parachute)
        DetachEntity(pickup) -- will despawn on its own
        SetBlipAlpha(blip, 255) -- make the blip fully visible

        while DoesEntityExist(pickup) do -- wait till the pickup gets picked up, then the script can continue
            Wait(0)
           -- Citizen.Wait(0)
    
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            
            if GetDistanceBetweenCoords(coords, GetEntityCoords(pickup)) < 2 then
                nearbyObject, nearbyID = pickup
            end
    
            if nearbyObject and IsPedOnFoot(playerPed) then
                if not isPickingUp then
                    ESX.ShowHelpNotification("press ~INPUT_CONTEXT~ to pickup gun")
                end
    
                if IsControlJustReleased(0, 38) and not isPickingUp then
                    isPickingUp = true
                    TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
    
                    Citizen.Wait(2000)
                    ClearPedTasks(playerPed)
                    Citizen.Wait(500)
    
                    ESX.Game.DeleteObject(nearbyObject)
                    TriggerServerEvent('gunheist:pickedUpgun')
                    isPickingUp = false
                    Citizen.SetTimeout(50000, false)
                end
            else
                Citizen.Wait(500)
            end
        end

        while DoesObjectOfTypeExistAtCoords(parachuteCoords, 10.0, GetHashKey("w_am_flare"), true) do
            Wait(0)
            local prop = GetClosestObjectOfType(parachuteCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
            RemoveParticleFxFromEntity(prop)
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
        end

        if DoesBlipExist(blip) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
            RemoveBlip(blip)
        end

        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    end)
end


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then

        -- print("RESOURCE: stopped")

        SetEntityAsMissionEntity(pilot, false, true)
        DeleteEntity(pilot)
        SetEntityAsMissionEntity(aircraft, false, true)
        DeleteEntity(aircraft)
        DeleteEntity(parachute)
        DeleteEntity(crate)
        RemovePickup(pickup)
        RemoveBlip(blip)
        RemoveBlip(blipRobbery)
        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

    end
end)


RegisterNetEvent('gunheist:killblip')
AddEventHandler('gunheist:killblip', function()
    RemoveBlip(blipRobbery)
end)

--[[ RegisterNetEvent('gunheist:setblip')
AddEventHandler('gunheist:setblip', function()
    local blipcrds = GetEntityCoords(PlayerPedId())
    blipRobbery = AddBlipForCoord(blipcrds.x, blipcrds.y, blipcrds.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 1)
    PulseBlip(blipRobbery)
end) ]]

RegisterNetEvent('gunheist:setblip')
AddEventHandler('gunheist:setblip', function(targetCoords, type)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local alpha = 250
        local blipRobbery = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite (blipRobbery, 161)
        SetBlipScale  (blipRobbery, 1.5)
        SetBlipColour(blipRobbery, 1)
        PulseBlip(blipRobbery)
        SetBlipAlpha(blipRobbery, alpha)
        SetBlipHighDetail(blipRobbery, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Code 3')
        EndTextCommandSetBlipName(blipRobbery)

        while alpha ~= 0 do
			Citizen.Wait(100 * 8)
			alpha = alpha - 1
			SetBlipAlpha(blipRobbery, alpha)

			if alpha == 0 then
				RemoveBlip(blipRobbery)
				return
			end
        end
    end
end)

RegisterNetEvent('gunheist:EmergencySend')
AddEventHandler('gunheist:EmergencySend', function(messageFull)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
		TriggerEvent('chat:addMessage', messageFull)
    end
end)