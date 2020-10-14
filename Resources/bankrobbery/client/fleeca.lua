ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    ESX.PlayerData = ESX.GetPlayerData()
    
    PlayerData = ESX.GetPlayerData()

    ESX.TriggerServerCallback('lh-bankrobbery:server:GetConfig', function(config)
        Config = config
    end)

    ResetBankDoors()
end)

-- Code

local closestBank = nil
local inRange
local copsCalled = false

currentThermiteGate = 0

CurrentCops = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)


Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist

        if ESX ~= nil then
            inRange = false

            for k, v in pairs(Config.SmallBanks) do
                dist = GetDistanceBetweenCoords(pos, Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"])
                if dist < 15 then
                    closestBank = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(2000)
                closestBank = nil
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if ESX ~= nil then
            if closestBank ~= nil then
                if not Config.SmallBanks[closestBank]["isOpened"] then
                    local dist = GetDistanceBetweenCoords(pos, Config.SmallBanks[closestBank]["coords"]["x"], Config.SmallBanks[closestBank]["coords"]["y"], Config.SmallBanks[closestBank]["coords"]["z"])
                    if dist < 20 then
                        DrawMarker(27,Config.SmallBanks[closestBank]["coords"]["x"], Config.SmallBanks[closestBank]["coords"]["y"], Config.SmallBanks[closestBank]["coords"]["z"]-0.9, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255,0,0, 60, 0, 0, 2, 0, 0, 0, 0)
                    end
                    if dist < 1 then
                        DrawText3Ds(Config.SmallBanks[closestBank]["coords"]["x"], Config.SmallBanks[closestBank]["coords"]["y"], Config.SmallBanks[closestBank]["coords"]["z"], "Use ~g~Electronic Kit~w~ [You need ~g~Trojan USB~w~] to start the robbery")                        
                    end
                end
                if Config.SmallBanks[closestBank]["isOpened"] then
                    for k, v in pairs(Config.SmallBanks[closestBank]["lockers"]) do
                        local lockerDist = GetDistanceBetweenCoords(pos, Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z)
                        if not Config.SmallBanks[closestBank]["lockers"][k]["isBusy"] then
                            if not Config.SmallBanks[closestBank]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then

                                    DrawMarker(27,Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z-0.9, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255,0,0, 60, 0, 0, 2, 0, 0, 0, 0)

                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.SmallBanks[closestBank]["lockers"][k].x, Config.SmallBanks[closestBank]["lockers"][k].y, Config.SmallBanks[closestBank]["lockers"][k].z, 'Press E to crack the safe')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            if CurrentCops >= Config.MinimumFleecaPolice then
                                                openLocker(closestBank, k)
                                            else
                                                exports['mythic_notify']:DoHudText('inform', "Not enough police (4 needed).")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(2500)
            end
        end

        Citizen.Wait(1)
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closestBank ~= nil then
        ESX.TriggerServerCallback('lh-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if closestBank ~= nil then
                    local dist = GetDistanceBetweenCoords(pos, Config.SmallBanks[closestBank]["coords"]["x"], Config.SmallBanks[closestBank]["coords"]["y"], Config.SmallBanks[closestBank]["coords"]["z"])
                    if dist < 1.5 then
                        ESX.TriggerServerCallback('bank:getOnlinePolice',
                            function(online)
                            if online >= Config.MinimumFleecaPolice then
                                if not Config.SmallBanks[closestBank]["isOpened"] then 
                                    ESX.TriggerServerCallback('lh-bankrobbery:server:HasItem', function(result)
                                        if result then 
                                            Skillbar = exports['skillbar']:GetSkillbarObject()

                                            Skillbar.Start({
                                                duration = math.random(5500, 7000),
                                                pos = math.random(10, 80),
                                                width = math.random(10, 20),
                                            }, function()
                                    
                                                Skillbar.Start({
                                                    duration = math.random(2500, 5000),
                                                    pos = math.random(10, 80),
                                                    width = math.random(8, 15),
                                                }, function()
                                        
                                                    Skillbar.Start({
                                                        duration = math.random(500, 2000),
                                                        pos = math.random(10, 80),
                                                        width = math.random(6, 10),
                                                    }, function()

                                                        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Hacked small bank door.')
                                                        TriggerEvent("mhacking:show")
                                                        TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone)
                                                        local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
                                                        if not copsCalled then
                                                            --local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                                            --local street1 = GetStreetNameFromHashKey(s1)
                                                            --local street2 = GetStreetNameFromHashKey(s2)
                                                            --local streetLabel = street1
                                                            --if street2 ~= nil then 
                                                            --  streetLabel = streetLabel .. " " .. street2
                                                            --end

                                                            if Config.SmallBanks[closestBank]["alarm"] then
                                                                TriggerServerEvent("esx_outlawalert:bankRobbery", pos, streetLabel, 'Small Bank Robbery', 1, true)
                                                                streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
                                                                streetName = GetStreetNameFromHashKey(streetName)
                                                                local emergency = 'smallbank'
                                                                TriggerServerEvent('bank:small',{
                                                                    x = ESX.Math.Round(playerCoords.x, 1),
                                                                    y = ESX.Math.Round(playerCoords.y, 1),
                                                                    z = ESX.Math.Round(playerCoords.z, 1)
                                                                }, streetName, emergency)                                                        
                                                                copsCalled = true
                                                                TriggerServerEvent('lh-bankrobbery:Server:RemoveItem', 'electronickit', 1)

                                                            end
                                                        end
                                                        
                                                    end, function()
                                                        
                                                        exports['mythic_notify']:DoHudText('inform',"Failed!")
                                                        TriggerServerEvent('lh-bankrobbery:Server:RemoveItem', 'electronickit', 1)
                                                        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to hack small bank door.')
                                                    end)
                                    
                                                end, function()
                                                    exports['mythic_notify']:DoHudText('inform',"Failed!")
                                                end)
                                                
                                            end, function()
                                                exports['mythic_notify']:DoHudText('inform',"Failed!")
                                            end)

                                        else
                                            exports['mythic_notify']:DoHudText('inform', "You're missing usb.")
                                        end
                                    end, "trojan_usb")
                                else
                                    exports['mythic_notify']:DoHudText('inform', "Looks like the bank is already open.")
                                end
                            else
                                exports['mythic_notify']:DoHudText('inform', "Not enough police (4 needed)")
                            end
                        end)
                    end
                end
            else
                exports['mythic_notify']:DoHudText('inform', "The security lock is active, opening the door is currently not possible.")
            end
        end)
    end
end)

RegisterNetEvent('lh-bankrobbery:client:setBankState')
AddEventHandler('lh-bankrobbery:client:setBankState', function(bankId, state)
    if bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        if state then
            OpenPacificDoor()
        end
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        if state then
            OpenBankDoor(bankId)
        end
    end
end)

RegisterNetEvent('lh-bankrobbery:client:enableAllBankSecurity')
AddEventHandler('lh-bankrobbery:client:enableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = true
    end
end)

RegisterNetEvent('lh-bankrobbery:client:disableAllBankSecurity')
AddEventHandler('lh-bankrobbery:client:disableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = false
    end
end)

RegisterNetEvent('lh-bankrobbery:client:BankSecurity')
AddEventHandler('lh-bankrobbery:client:BankSecurity', function(key, status)
    Config.SmallBanks[key]["alarm"] = status
end)

function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, Config.SmallBanks[bankId]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.SmallBanks[bankId]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading ~= Config.SmallBanks[bankId]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Citizen.Wait(10)
            end
        end)
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function ResetBankDoors()
    for k, v in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, Config.SmallBanks[k]["object"], false, false, false)
        if not Config.SmallBanks[k]["isOpened"] then
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].closed)
        else
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].open)
        end
    end

    if not Config.BigBanks["pacific"]["isOpened"] then
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].closed)
    else
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].open)
    end
end

function openLocker(bankId, lockerId)
    local pos = GetEntityCoords(GetPlayerPed(-1))

    TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', true)
    if bankId == "pacific" then
        ESX.TriggerServerCallback("lh-bankrobbery:server:HasItem", function(hasItem)
            if hasItem then
                if Config.usethermitegame == true then
                    if exports["thermite"]:startGame(15,2,10,800) then
                        TriggerEvent("attachItem","minigameThermite")

                        RequestAnimDict("weapon@w_sp_jerrycan")
                        while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                            Wait(10)
                        end
                        Wait(100)
                        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                        Wait(5000)
                        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                        TriggerEvent("destroyProp")
                        ClearPedTasks(PlayerPedId())
    
                        TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                        TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                        TriggerServerEvent('lh-bankrobbery:server:recieveItem', 'small')
                        exports['mythic_notify']:DoHudText('success', "Successful!")
                    else
                        local plyCoords = GetEntityCoords(PlayerPedId())            
                        TriggerServerEvent('lh-bankrobbery:Server:RemoveItemthermite')
                       TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open Pacific bank locker.')
                        exports['mythic_notify']:DoHudText('inform', "You notice fire, RUN!")
                        Wait(2000)
                        exports["thermite"]:startFireAtLocation(plyCoords["x"],plyCoords["y"],plyCoords["z"]-0.3,10000) 
                    end
                    TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Opened Pacific bank locker.')
                else
                    --TriggerEvent("attachItem","minigameThermite")

                    RequestAnimDict("weapon@w_sp_jerrycan")
                    while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                        Wait(10)
                    end
                    Wait(100)
                    TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                    Wait(5000)
                    TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "openThermite",
                        amount = math.random(5, 10),
                    })
                    --TriggerEvent("destroyProp")
                    ClearPedTasks(PlayerPedId())
                    exports['mythic_notify']:DoHudText('inform','You notice fire, RUN!')
                    --TriggerServerEvent('lh-bankrobbery:Server:RemoveItemthermite')
                    Citizen.Wait(2000)
                    TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    TriggerServerEvent('lh-bankrobbery:server:recieveItem', 'small')
                    TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open Pacific bank locker.')
                    exports['mythic_notify']:DoHudText('success', "Successful!")

                
                    
--[[                  local plyCoords = GetEntityCoords(PlayerPedId())            
                    TriggerEvent('lh-bankrobbery:removeItem',"thermite", 1)
                   -- TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open small bank locker.')
                    exports['mythic_notify']:DoHudText('inform', "You notice fire, RUN!", 2)
                    Wait(2000)
                    exports["thermite"]:startFireAtLocation(plyCoords["x"],plyCoords["y"],plyCoords["z"]-0.3,10000)  ]]
                end
            else
                exports['mythic_notify']:DoHudText('inform', "You dont have any thermite!")
            end
        end, 'thermite')
    else
        ESX.TriggerServerCallback("lh-bankrobbery:server:HasItem", function(hasItem)
            if hasItem then
                if Config.usethermitegame == true then
                    if exports["thermite"]:startGame(15,2,10,800) then
                        TriggerEvent("attachItem","minigameThermite")

                        RequestAnimDict("weapon@w_sp_jerrycan")
                        while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                            Wait(10)
                        end
                        Wait(100)
                        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                        Wait(5000)
                        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                        TriggerEvent("destroyProp")
                        ClearPedTasks(PlayerPedId())
    
                        TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                        TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                        TriggerServerEvent('lh-bankrobbery:server:recieveItem', 'small')
                        exports['mythic_notify']:DoHudText('success', "Successful!")
                    else
                        local plyCoords = GetEntityCoords(PlayerPedId())            
                        TriggerServerEvent('lh-bankrobbery:Server:RemoveItemthermite')
                       TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open small bank locker.')
                        exports['mythic_notify']:DoHudText('inform', "You notice fire, RUN!")
                        Wait(2000)
                    end
                    
                else
                    --TriggerEvent("attachItem","minigameThermite")

                    RequestAnimDict("weapon@w_sp_jerrycan")
                    while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                        Wait(10)
                    end
                    Wait(100)
                    TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                    Wait(5000)
                    TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                    --TriggerEvent("destroyProp")
                    ClearPedTasks(PlayerPedId())
--[[                     SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "openThermite",
                        amount = math.random(5, 10),
                    }) ]]
                    exports['mythic_notify']:DoHudText('inform','You notice fire, RUN!')
                    --local plyCoords = GetEntityCoords(PlayerPedId())
                    -- local randTime = math.random(1000, 5000)
                    -- Citizen.Wait(2000)
                    -- CreateFire(plyCoords, randTime)
                    -- Wait(randTime)
                    --exports['mythic_notify']:DoHudText('inform','You notice fire, RUN!')
                    TriggerServerEvent('lh-bankrobbery:Server:RemoveItemthermite')
                    TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('lh-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)

                    TriggerServerEvent('lh-bankrobbery:server:recieveItem', 'small')
                    TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. 'Opened small bank locker.')

                    exports['mythic_notify']:DoHudText('success', "Successful!")

                
                    
--[[                  local plyCoords = GetEntityCoords(PlayerPedId())            
                    TriggerEvent('lh-bankrobbery:removeItem',"thermite", 1)
                   -- TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open small bank locker.')
                    exports['mythic_notify']:DoHudText('inform', "You notice fire, RUN!", 2)
                    Wait(2000)
                    exports["thermite"]:startFireAtLocation(plyCoords["x"],plyCoords["y"],plyCoords["z"]-0.3,10000)  ]]
                end
            else
                exports['mythic_notify']:DoHudText('inform', "You dont have any thermite!")
            end
        end, 'thermite')
    end
end

RegisterNetEvent('lh-bankrobbery:client:setLockerState')
AddEventHandler('lh-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
end)

RegisterNetEvent('lh-bankrobbery:client:ResetFleecaLockers')
AddEventHandler('lh-bankrobbery:client:ResetFleecaLockers', function(BankId)
    Config.SmallBanks[BankId]["isOpened"] = false
    for k,_ in pairs(Config.SmallBanks[BankId]["lockers"]) do
        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
    end
end)

RegisterNetEvent('lh-bankrobbery:client:robberyCall')
AddEventHandler('lh-bankrobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if ESX.PlayerData.job.name == "police" then 
        local cameraId = 4
        local bank = "Fleeca"
        if type == "small" then
            cameraId = Config.SmallBanks[key]["camId"]
            bank = "Fleeca"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            -- Police Alert
        elseif type == "pacific" then
            bank = "Pacific Standard Bank"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Citizen.Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            -- Police Alert
        end
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Bank Robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('bank:smallblip')
AddEventHandler('bank:smallblip', function(targetCoords, type)
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
        AddTextComponentString('Bank Robbery')
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

RegisterNetEvent('bank:EmergencySend')
AddEventHandler('bank:EmergencySend', function(messageFull)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
		TriggerEvent('chat:addMessage', messageFull)
    end
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('lh-bankrobbery:server:setBankState', closestBank, true)
        TriggerServerEvent('lh-bankrobbery:Server:RemoveItem', 'trojan_usb', 1)
    else
        TriggerEvent('mhacking:hide')
        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to M-Hack small bank door.')
	end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ResetBankDoors()
        RemoveBlip(blipRobbery)
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function searchPockets()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "random@mugging4" )
        TaskPlayAnim( GetPlayerPed(-1), "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    end
end

function giveAnim()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end