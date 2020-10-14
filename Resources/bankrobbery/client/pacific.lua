
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false
        if ESX ~= nil then

            if Config.BigBanks["pacific"]["isOpened"] then
                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    local lockerDist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["lockers"][k].x, Config.BigBanks["pacific"]["lockers"][k].y, Config.BigBanks["pacific"]["lockers"][k].z)
                    if not Config.BigBanks["pacific"]["lockers"][k]["isBusy"] then
                        if not Config.BigBanks["pacific"]["lockers"][k]["isOpened"] then
                            if lockerDist < 5 then
                                inRange = true

                                DrawMarker(27,Config.BigBanks["pacific"]["lockers"][k].x, Config.BigBanks["pacific"]["lockers"][k].y, Config.BigBanks["pacific"]["lockers"][k].z-0.9, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255,0,0, 60, 0, 0, 2, 0, 0, 0, 0)

                                if lockerDist < 0.5 then
                                    DrawText3Ds(Config.BigBanks["pacific"]["lockers"][k].x, Config.BigBanks["pacific"]["lockers"][k].y, Config.BigBanks["pacific"]["lockers"][k].z, 'Press E to crack the safe')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        openLocker("pacific", k)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][1]["x"], Config.BigBanks["pacific"]["coords"][1]["y"], Config.BigBanks["pacific"]["coords"][1]["z"])
                local dist2 = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"])

                if dist < 20 then
                    inRange = true
                    DrawMarker(27,Config.BigBanks["pacific"]["coords"][1]["x"], Config.BigBanks["pacific"]["coords"][1]["y"], Config.BigBanks["pacific"]["coords"][1]["z"]-0.9, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255,0,0, 60, 0, 0, 2, 0, 0, 0, 0)
                end

                if dist < 1.5 then
                    DrawText3Ds(Config.BigBanks["pacific"]["coords"][1]["x"], Config.BigBanks["pacific"]["coords"][1]["y"], Config.BigBanks["pacific"]["coords"][1]["z"], "Use ~g~Security Card A~w~ to unlock the door")
                end

                if dist2 < 20 then
                    inRange = true
                    DrawMarker(27,Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"]-0.9, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255,0,0, 60, 0, 0, 2, 0, 0, 0, 0)
                end

                if dist2 < 1.5 then
                    DrawText3Ds(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], "Use ~g~Electronic Kit~w~ [You need ~g~Trojan USB~w~] to start the robbery")
                end
            end
            if not inRange then
                Citizen.Wait(2500)
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if ESX ~= nil then
            for k,v in pairs(Config.BigBanks["pacific"]["thermite"]) do
                local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["thermite"][k]["x"], Config.BigBanks["pacific"]["thermite"][k]["y"], Config.BigBanks["pacific"]["thermite"][k]["z"], true)
                if dist < 1.5 then
                    currentThermiteGate = Config.BigBanks["pacific"]["thermite"][k]["doorId"]
                end
            end
        end
    end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"])
    if dist < 1.5 then
        ESX.TriggerServerCallback('lh-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"])
                if dist < 1.5 then
                    if CurrentCops >= Config.MinimumPacificPolice then
                        if not Config.BigBanks["pacific"]["isOpened"] then 
                            ESX.TriggerServerCallback('lh-bankrobbery:server:HasItem', function(result)
                                if result then 

                                    TriggerEvent("mythic_progbar:client:progress", {
                                        name = "hack_gate",
                                        duration = math.random(5000, 10000),
                                        label = "Connecting the electronic kit",
                                        useWhileDead = false,
                                        canCancel = false,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                        animation = {
                                            animDict = "anim@gangops@facility@servers@",
                                            anim = "hotwire",
                                            flags = 16,
                                        },
                                    }, function(canceled)
                                        if not canceled then
                                            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            TriggerEvent("mhacking:show")
                                            TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackPacificDone)
                                            if not copsCalled then
                                                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                                local street1 = GetStreetNameFromHashKey(s1)
                                                local street2 = GetStreetNameFromHashKey(s2)
                                                local streetLabel = street1
                                                if street2 ~= nil then 
                                                    streetLabel = streetLabel .. " " .. street2
                                                end
                                                if Config.BigBanks["pacific"]["alarm"] then
                                                    TriggerServerEvent("esx_outlawalert:bankRobbery", pos, streetLabel, 'Pacific Bank Robbery', 1, true)
                                                    copsCalled = true
                                                end
                                            end
                                            TriggerServerEvent("lh-bankrobbery:Server:RemoveItem", "electronickit", 1)
                                            Citizen.Wait(2000)
                                            TriggerServerEvent("lh-bankrobbery:Server:RemoveItem", "trojan_usb", 1)
                                        else
                                            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            exports['mythic_notify']:DoHudText('inform', "Canceled..")
                                        end
                                    end)

                                else
                                    exports['mythic_notify']:DoHudText('inform', "You're missing usb.")
                                end
                            end, "trojan_usb")
                        else
                            exports['mythic_notify']:DoHudText('inform', "Looks like the bank is already open.")
                        end
                    else
                        exports['mythic_notify']:DoHudText('inform', "Not enough police (6 needed)")
                    end
                end
            else
                exports['mythic_notify']:DoHudText('inform', "The security lock is active, opening the door is currently not possible.")
            end
        end)
    end
end)


RegisterNetEvent('lh-bankrobbery:UseBankcardA')
AddEventHandler('lh-bankrobbery:UseBankcardA', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][1]["x"], Config.BigBanks["pacific"]["coords"][1]["y"],Config.BigBanks["pacific"]["coords"][1]["z"])

    if dist < 1.5 then
        ESX.TriggerServerCallback('lh-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                ESX.TriggerServerCallback('bank:getOnlinePolice',
                function(online)
                    if online >= Config.MinimumPacificPolice then
                        if not Config.BigBanks["pacific"]["isOpened"] then 

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
                                        --StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. '  Opened pacific bank door.')
                                        TriggerServerEvent('esx_doorlock:updateState', 58, false)
                                        --TriggerServerEvent('esx_doorlock:updateState', 58, false)
                                        TriggerServerEvent("lh-bankrobbery:Server:RemoveItem", "security_card_01", 1)
                                        if not copsCalled then
                                            -- local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                            -- local street1 = GetStreetNameFromHashKey(s1)
                                            -- local street2 = GetStreetNameFromHashKey(s2)
                                            -- local streetLabel = street1
                                            -- if street2 ~= nil then 
                                            --     streetLabel = streetLabel .. " " .. street2
                                            -- end
                                            streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                            streetName = GetStreetNameFromHashKey(streetName)
                                            local emergency = 'smallbank'
                                            TriggerServerEvent('bank:small',{
                                                x = ESX.Math.Round(pos.x, 1),
                                                y = ESX.Math.Round(pos.y, 1),
                                                z = ESX.Math.Round(pos.z, 1)
                                            }, streetName, emergency)   
                                            if Config.BigBanks["pacific"]["alarm"] then
                                                TriggerServerEvent("esx_outlawalert:bankRobbery", pos, streetLabel, 'Pacific Bank Robbery', 1, true)
                                                copsCalled = true
                                            end
                                        end
                    
                                    end, function()
                                        exports['mythic_notify']:DoHudText('inform',"Failed!")
                                        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open pacific bank door.')
                                    end)
                    
                                end, function()
                                    exports['mythic_notify']:DoHudText('inform',"Failed!")
                                    TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open pacific bank door.')
                                end)
                                
                            end, function()
                                exports['mythic_notify']:DoHudText('inform',"Failed!")
                                TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Failed to open pacific bank door.')
                            end)
                        else
                            exports['mythic_notify']:DoHudText('inform', "Looks like the bank is already open.")
                        end
                    else
                        exports['mythic_notify']:DoHudText('inform', "Not enough police (6 needed)")
                        TriggerServerEvent("robbery:logs", GetPlayerName(PlayerId()) .. ' Attempted Robbery of Pacific.')
                    end
                end)
            else
                exports['mythic_notify']:DoHudText('inform', "The security lock is active, opening the door is currently not possible.")
            end
        end)
    end 
end)

function OnHackPacificDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('lh-bankrobbery:server:setBankState', "pacific", true)
    else
		TriggerEvent('mhacking:hide')
	end
end

function OpenPacificDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["pacific"]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading > Config.BigBanks["pacific"]["heading"].open then
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

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerServerEvent("lh-bankrobbery:Server:RemoveItem", "thermite", 1)
    ClearPedTasks(GetPlayerPed(-1))
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local randTime = math.random(10000, 15000)
    Wait(3000)
    CreateFire(coords, randTime)
end)

RegisterNUICallback('thermitesuccess', function()
    ClearPedTasks(GetPlayerPed(-1))
    local time = 3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    while time > 0 do 
        exports['mythic_notify']:DoHudText('inform', "Fire over " .. time .. "!")
        Citizen.Wait(1000)
        time = time - 1
    end
    local randTime = math.random(10000, 15000)
    CreateFire(coords, randTime)
    if currentStation ~= 0 then
        exports['mythic_notify']:DoHudText('inform', "The fuses are broken!")
        TriggerServerEvent("lh-bankrobbery:server:SetStationStatus", currentStation, true)
    elseif currentGate ~= 0 then
        exports['mythic_notify']:DoHudText('inform', "The door is burned open!")
        TriggerServerEvent('esx_doorlock:server:updateState', currentGate, false)
        currentGate = 0
    end
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

function CreateFire(coords, time)
    TriggerServerEvent("robbery:fireMessage")
    for i = 1, math.random(1, 7), 1 do
        TriggerServerEvent("robbery:StartServerFire", coords, 24, false)
    end
    Citizen.Wait(time)
    TriggerServerEvent("robbery:StopFires")
end