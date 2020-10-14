----------------------
-- Author : Deediezi
-- Version 3.0
--
-- Contributors : No contributors at the moment.
--
-- Github link : https://github.com/Deediezi/FiveM_LockSystem
-- You can contribute to the project. All the information is on Github.

--  Main algorithm with all functions and events - Client side

----
-- @var vehicles[plate_number] = newVehicle Object
ESX = nil
local vehicles = {}
local searchedVehicles = {}
local pickedVehicled = {}
colors = {
    --[0] = "Metallic Black",
    [1] = "Metallic Graphite Black",
    [2] = "Metallic Black Steel",
    [3] = "Metallic Dark Silver",
    [4] = "Metallic Silver",
    [5] = "Metallic Blue Silver",
    [6] = "Metallic Steel Gray",
    [7] = "Metallic Shadow Silver",
    [8] = "Metallic Stone Silver",
    [9] = "Metallic Midnight Silver",
    [10] = "Metallic Gun Metal",
    [11] = "Metallic Anthracite Grey",
    [12] = "Matte Black",
    [13] = "Matte Gray",
    [14] = "Matte Light Grey",
    [15] = "Util Black",
    [16] = "Util Black Poly",
    [17] = "Util Dark silver",
    [18] = "Util Silver",
    [19] = "Util Gun Metal",
    [20] = "Util Shadow Silver",
    [21] = "Worn Black",
    [22] = "Worn Graphite",
    [23] = "Worn Silver Grey",
    [24] = "Worn Silver",
    [25] = "Worn Blue Silver",
    [26] = "Worn Shadow Silver",
    [27] = "Metallic Red",
    [28] = "Metallic Torino Red",
    [29] = "Metallic Formula Red",
    [30] = "Metallic Blaze Red",
    [31] = "Metallic Graceful Red",
    [32] = "Metallic Garnet Red",
    [33] = "Metallic Desert Red",
    [34] = "Metallic Cabernet Red",
    [35] = "Metallic Candy Red",
    [36] = "Metallic Sunrise Orange",
    [37] = "Metallic Classic Gold",
    [38] = "Metallic Orange",
    [39] = "Matte Red",
    [40] = "Matte Dark Red",
    [41] = "Matte Orange",
    [42] = "Matte Yellow",
    [43] = "Util Red",
    [44] = "Util Bright Red",
    [45] = "Util Garnet Red",
    [46] = "Worn Red",
    [47] = "Worn Golden Red",
    [48] = "Worn Dark Red",
    [49] = "Metallic Dark Green",
    [50] = "Metallic Racing Green",
    [51] = "Metallic Sea Green",
    [52] = "Metallic Olive Green",
    [53] = "Metallic Green",
    [54] = "Metallic Gasoline Blue Green",
    [55] = "Matte Lime Green",
    [56] = "Util Dark Green",
    [57] = "Util Green",
    [58] = "Worn Dark Green",
    [59] = "Worn Green",
    [60] = "Worn Sea Wash",
    [61] = "Metallic Midnight Blue",
    [62] = "Metallic Dark Blue",
    [63] = "Metallic Saxony Blue",
    [64] = "Metallic Blue",
    [65] = "Metallic Mariner Blue",
    [66] = "Metallic Harbor Blue",
    [67] = "Metallic Diamond Blue",
    [68] = "Metallic Surf Blue",
    [69] = "Metallic Nautical Blue",
    [70] = "Metallic Bright Blue",
    [71] = "Metallic Purple Blue",
    [72] = "Metallic Spinnaker Blue",
    [73] = "Metallic Ultra Blue",
    [74] = "Metallic Bright Blue",
    [75] = "Util Dark Blue",
    [76] = "Util Midnight Blue",
    [77] = "Util Blue",
    [78] = "Util Sea Foam Blue",
    [79] = "Uil Lightning blue",
    [80] = "Util Maui Blue Poly",
    [81] = "Util Bright Blue",
    [82] = "Matte Dark Blue",
    [83] = "Matte Blue",
    [84] = "Matte Midnight Blue",
    [85] = "Worn Dark blue",
    [86] = "Worn Blue",
    [87] = "Worn Light blue",
    [88] = "Metallic Taxi Yellow",
    [89] = "Metallic Race Yellow",
    [90] = "Metallic Bronze",
    [91] = "Metallic Yellow Bird",
    [92] = "Metallic Lime",
    [93] = "Metallic Champagne",
    [94] = "Metallic Pueblo Beige",
    [95] = "Metallic Dark Ivory",
    [96] = "Metallic Choco Brown",
    [97] = "Metallic Golden Brown",
    [98] = "Metallic Light Brown",
    [99] = "Metallic Straw Beige",
    [100] = "Metallic Moss Brown",
    [101] = "Metallic Biston Brown",
    [102] = "Metallic Beechwood",
    [103] = "Metallic Dark Beechwood",
    [104] = "Metallic Choco Orange",
    [105] = "Metallic Beach Sand",
    [106] = "Metallic Sun Bleeched Sand",
    [107] = "Metallic Cream",
    [108] = "Util Brown",
    [109] = "Util Medium Brown",
    [110] = "Util Light Brown",
    [111] = "Metallic White",
    [112] = "Metallic Frost White",
    [113] = "Worn Honey Beige",
    [114] = "Worn Brown",
    [115] = "Worn Dark Brown",
    [116] = "Worn straw beige",
    [117] = "Brushed Steel",
    [118] = "Brushed Black steel",
    [119] = "Brushed Aluminium",
    [120] = "Chrome",
    [121] = "Worn Off White",
    [122] = "Util Off White",
    [123] = "Worn Orange",
    [124] = "Worn Light Orange",
    [125] = "Metallic Securicor Green",
    [126] = "Worn Taxi Yellow",
    [127] = "police car blue",
    [128] = "Matte Green",
    [129] = "Matte Brown",
    [130] = "Worn Orange",
    [131] = "Matte White",
    [132] = "Worn White",
    [133] = "Worn Olive Army Green",
    [134] = "Pure White",
    [135] = "Hot Pink",
    [136] = "Salmon pink",
    [137] = "Metallic Vermillion Pink",
    [138] = "Orange",
    [139] = "Green",
    [140] = "Blue",
    [141] = "Mettalic Black Blue",
    [142] = "Metallic Black Purple",
    [143] = "Metallic Black Red",
    [144] = "hunter green",
    [145] = "Metallic Purple",
    [146] = "Metaillic V Dark Blue",
    [147] = "MODSHOP BLACK1",
    [148] = "Matte Purple",
    [149] = "Matte Dark Purple",
    [150] = "Metallic Lava Red",
    [151] = "Matte Forest Green",
    [152] = "Matte Olive Drab",
    [153] = "Matte Desert Brown",
    [154] = "Matte Desert Tan",
    [155] = "Matte Foilage Green",
    [156] = "DEFAULT ALLOY COLOR",
    [157] = "Epsilon Blue",
    [158] = "Unknown",
    }
---- Retrieve the keys of a player when he reconnects.
-- The keys are synchronized with the server. If you restart the server, all keys disappear.

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("ls:retrieveVehiclesOnconnect")
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isHotwiring then
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(0, 74, true)  -- Lights
        end
    end
end)

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

function getCardinalDirectionFromHeading()
    local heading = GetEntityHeading(PlayerPedId())
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

function GetVehicleDescription()
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(currentVehicle) then
      return
    end
  
    plate = GetVehicleNumberPlateText(currentVehicle)
    make = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))
    color1, color2 = GetVehicleColours(currentVehicle)
  
    if color1 == 0 then color1 = 1 end
    if color2 == 0 then color2 = 2 end
    if color1 == -1 then color1 = 158 end
    if color2 == -1 then color2 = 158 end 
  
    if math.random(100) > 25 then
      plate = "Unknown"
    end
  
    local dir = getCardinalDirectionFromHeading()
  
    local vehicleData  = {
      model = make,
      plate = plate,
      firstColor = colors[color1],
      secondColor = colors[color2],
      heading = dir
    }
    return vehicleData
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustReleased(0, 38) and isHotwiring then
            --exports['progressBars']:stopUI()
            TriggerEvent("mythic_progbar:client:cancel")
            StopAnimTask(PlayerPedId(), 'veh@std@ds@base', 'hotwire', 1.0)
            isHotwiring = false
        end
    end
end)

local isRobbing = false
local canRob = false
local prevPed = false
local prevCar = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local foundEnt, aimingEnt = GetEntityPlayerIsFreeAimingAt(PlayerId())
        local entPos = GetEntityCoords(aimingEnt)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, entPos.x, entPos.y, entPos.z, true)
        local streetName, playerGender
        local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(streetName)
        local playerGender = 'by an individual'

        if foundEnt and prevPed ~= aimingEnt and IsPedInAnyVehicle(aimingEnt, false) and IsPedArmed(PlayerPedId(), 7) and dist < 20.0 and not IsPedInAnyVehicle(PlayerPedId()) then
            if not IsPedAPlayer(aimingEnt) then
                prevPed = aimingEnt
                Wait(math.random(300, 700))
                local dict = "random@mugging3"
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Citizen.Wait(0)
                end
                local rand = math.random(1, 10)

                if rand > 3 then
                    prevCar = GetVehiclePedIsIn(aimingEnt, false)
                    TaskLeaveVehicle(aimingEnt, prevCar)
                    SetVehicleEngineOn(prevCar, false, false, false)
                    while IsPedInAnyVehicle(aimingEnt, false) do
                        Citizen.Wait(0)
                    end
                    SetBlockingOfNonTemporaryEvents(aimingEnt, true)
                    ClearPedTasksImmediately(aimingEnt)
                    TaskPlayAnim(aimingEnt, dict, "handsup_standing_base", 8.0, -8.0, 0.01, 49, 0, 0, 0, 0)
                    ResetPedLastVehicle(aimingEnt)
                    TaskWanderInArea(aimingEnt, 0, 0, 0, 20, 100, 100)
                    canRob = true
                    beginRobTimer(aimingEnt)

                    local pdnoti = math.random( 1, 10 )

                    if pdnoti >= 4 then
                        local street1 = GetStreetAndZone()
                        local esxder = IsPedMale(PlayerPedId())
                        local targetVehicle = object
                        local origin = GetEntityCoords(PlayerPedId())
                        if not DoesEntityExist(targetVehicle) then
                        vehicleData = GetVehicleDescription() or {}
                        plyPos = GetEntityCoords(PlayerPedId(), true)
                        if ESX.GetPlayerData().job.name == 'police' then
                                TriggerServerEvent('dispatch:svNotify', {
                                    dispatchCode = '10-60 B',
                                    firstStreet = street1,
                                    esxder = esxder,
                                    model = vehicleData.model,
                                    plate = vehicleData.plate,
                                    firstColor = vehicleData.firstColor,
                                    secondColor = vehicleData.secondColor,
                                    heading = vehicleData.heading,
                                    isImportant = false,
                                    priority = 1,
                                    dispatchMessage = "Vehicle Theft",
                                    origin = {
                                    x = plyPos.x,
                                    y = plyPos.y,
                                    z = plyPos.z
                                    }
                                })
                            end
                            TriggerEvent('esx-alerts:vehiclesteal')
                        end
                    end
                    --if rand > 6 then
--[[                         TriggerEvent('esx_outlawalert:carJackInProgress', {
							x = ESX.Math.Round(playerCoords.x, 1),
							y = ESX.Math.Round(playerCoords.y, 1),
							z = ESX.Math.Round(playerCoords.z, 1)
                        }, streetName, playerGender) ]]
                    --end
                end
            end
        end
    end
end)

local canTakeKeys = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if canRob and not IsEntityDead(prevPed) and IsPlayerFreeAiming(PlayerId()) then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local entPos = GetEntityCoords(prevPed)
--[[             if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, entPos.x, entPos.y, entPos.z, false) < 3.5 then
                DrawText3Ds(entPos.x, entPos.y, entPos.z, 'Press ~y~[E]~w~ to rob')
                if IsControlJustReleased(0, 38) then ]]
                    local rand = math.random(1, 10)
                    if rand == 1 then
                        Wait(400)
                        exports['mythic_notify']:DoHudText('inform', 'They do not hand over the keys')
                    else
                        local plate = GetVehicleNumberPlateText(prevCar)
                        --exports['progressBars']:startUI(3600, "Taking Keys")
                        exports['mythic_progbar']:Progress({
                            name = "taking_keys",
                            duration = 3600,
                            label = "Taking Keys",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = false,
                            }
                        },function()
                        end)
                        Wait(3600)
                        givePlayerKeys(plate)
                        local platenew = string.lower(plate)
                        TriggerEvent("ls:newVehicle", prevCar, platenew, nil)
                        exports['mythic_notify']:DoHudText('inform', 'You rob the keys')
                    end
                    SetBlockingOfNonTemporaryEvents(prevPed, false)
                    canRob = false
--[[                 end
            end ]]
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local lastVehicle = GetVehiclePedIsIn(ped, true)
        if not IsPedInVehicle(ped, lastVehicle, true) then 
            if DoesEntityExist(lastVehicle) and not IsEntityDead(lastVehicle) then
                SetVehicleEngineOn(lastVehicle, false, false, true)
            end
        end
    end
end)

RegisterCommand('engine', function() 
    -- toggleEngine()
     local ped = PlayerPedId()
     local vehicle = GetVehiclePedIsUsing(ped)
     SetVehicleEngineOn(vehicle, true, true, true)
     
end, false)

RegisterCommand('engineoff', function() 
    --  toggleEngineoff()
      local ped = PlayerPedId()
      local vehicle = GetVehiclePedIsUsing(ped)
      SetVehicleEngineOn(vehicle, false, true, true)
  
end, false)

local isSearching = false
local isHotwiring = false
local engine = false
local isshowing = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped)
            local driver = GetPedInVehicleSeat(veh, -1)
            local plate = GetVehicleNumberPlateText(veh)
            if driver == ped then
                if not hasKeys(plate) and not isHotwiring and not isSearching then
                    local pos = GetEntityCoords(ped)
                    if hasBeenSearched(plate) then
                        DrawText3Ds(pos.x, pos.y, pos.z + 0.2, 'Press ~y~[H] ~w~to hotwire')
                    else
                        DrawText3Ds(pos.x, pos.y, pos.z + 0.2, 'Press ~y~[H] ~w~to hotwire or ~g~[Space] ~w~to search')
                    end
                    SetVehicleEngineOn(veh, false, true, true)
                    --toggleEngine()
                    -- Searching
                    if IsControlJustReleased(0, 22) and not isSearching and not hasBeenSearched(plate) then -- G
                        if hasBeenSearched(plate) then
                            isSearching = true
                            --exports['progressBars']:startUI(5000, "Searching Vehicle")
                            exports['mythic_progbar']:Progress({
                                name = "Searching_Vehicle",
                                duration = 5000,
                                label = "Searching Vehicle",
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = false,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "veh@std@ds@base",
                                    anim = "hotwire",
                                    flags = 49,
                                },
                                prop = {
                                    model = nil,
                                }
                            },function()
                            end)
                            Citizen.Wait(5000)
                            isSearching = false
                            exports['mythic_notify']:DoHudText('error', 'You search the vehicle and find nothing')
                        else
                            local rnd = math.random(1, 8)
                            if rnd == 2 or rnd == 5 or rnd == 7 then
                                isSearching = true
                                --exports['progressBars']:startUI(6000, "Searching Vehicle")
                                exports['mythic_progbar']:Progress({
                                    name = "Searching_Vehicle",
                                    duration = 6000,
                                    label = "Searching Vehicle",
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = false,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "veh@std@ds@base",
                                        anim = "hotwire",
                                        flags = 49,
                                    },
                                    prop = {
                                        model = nil,
                                    }
                                },function()
                                end)
                                Citizen.Wait(6000)
                                isSearching = false
                                exports['mythic_notify']:DoHudText('inform', "You found the keys for plate [" .. plate .. ']')
                                givePlayerKeys(plate)
                                local plate = GetVehicleNumberPlateText(veh)
                                local platenew = string.lower(plate)
                                TriggerEvent("ls:newVehicle", veh, platenew, nil)
                                table.insert(searchedVehicles, plate)
                            else
                                isSearching = true
                                --exports['progressBars']:startUI(6000, "Searching Vehicle")
                                exports['mythic_progbar']:Progress({
                                    name = "Searching_Vehicle",
                                    duration = 6000,
                                    label = "Searching Vehicle",
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = false,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "veh@std@ds@base",
                                        anim = "hotwire",
                                        flags = 49,
                                    },
                                    prop = {
                                        model = nil,
                                    }
                                },function()
                                end)
                                Citizen.Wait(6000)
                                isSearching = false
                                exports['mythic_notify']:DoHudText('error', 'You search the vehicle and find nothing')
                                table.insert(searchedVehicles, plate)
                            end
                        end
                    end
                    -- Hotwiring
                    if IsControlJustReleased(0, 74) and not isHotwiring then -- E
                        TriggerEvent('onyx:beginHotwire', plate)
                    end
                else
                    SetVehicleEngineOn(veh, true, true, false)
                end
            end
        end
    end
end)
 
RegisterNetEvent('onyx:updatePlates')
AddEventHandler('onyx:updatePlates', function(plate)
    table.insert(vehicles, plate)
end)

function givePlayerKeys(plate)
    local vehPlate = plate
    table.insert(vehicles, vehPlate)
end

RegisterNetEvent('onyx:beginHotwire')
AddEventHandler('onyx:beginHotwire', function(plate)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    RequestAnimDict("veh@std@ds@base")

    while not HasAnimDictLoaded("veh@std@ds@base") do
        Citizen.Wait(100)
	end
    local time = 60000 -- in ms

    local vehPlate = plate
    isHotwiring = true

    SetVehicleEngineOn(veh, false, true, true)
    --toggleEngine()
    SetVehicleLights(veh, 0)

    local pdnoti = math.random( 1, 10 )

    if pdnoti >= 4 then
        local street1 = GetStreetAndZone()
        local esxder = IsPedMale(PlayerPedId())
        local targetVehicle = object
        local origin = GetEntityCoords(PlayerPedId())
        if not DoesEntityExist(targetVehicle) then
        vehicleData = GetVehicleDescription() or {}
        plyPos = GetEntityCoords(PlayerPedId(), true)
        if ESX.GetPlayerData().job.name == 'police' then
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = '10-60 A',
                    firstStreet = street1,
                    esxder = esxder,
                    model = vehicleData.model,
                    plate = vehicleData.plate,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    isImportant = false,
                    priority = 1,
                    dispatchMessage = "Vehicle Theft",
                    origin = {
                    x = plyPos.x,
                    y = plyPos.y,
                    z = plyPos.z
                    }
                })
            end
        end
    end

    --TriggerEvent("civilian:alertPolice",150.0,"lockpick",0,false)
    if isHotwiring then
        ESX.ShowHelpNotification("press ~INPUT_CONTEXT~ cancel hotwire")
    end
    local alarmChance = math.random(1, 8)

    if alarmChance == 1 then
        SetVehicleAlarm(veh, true)
        StartVehicleAlarm(veh) 
    end
    exports['mythic_progbar']:Progress({
        name = "hotwiring",
        duration = 60000,
        label = "HOTWIRING",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "veh@std@ds@base",
            anim = "hotwire",
            flags = 49,
        },
        prop = {
            model = nil,
        }
    },function()
    end)
    
    TaskPlayAnim(PlayerPedId(), "veh@std@ds@base", "hotwire", 8.0, 8.0, -1, 1, 0.3, true, true, true)
    Citizen.Wait(time)
    --exports['progressBars']:startUI(time, "Hotwiring")
    Wait(1000)
    givePlayerKeys(plate)
    --table.insert(vehicles, vehPlate)
    local plat = GetVehicleNumberPlateText(veh)
    local platenew = string.lower(plat)
    TriggerEvent("ls:newVehicle", veh, platenew, nil)
    StopAnimTask(PlayerPedId(), 'veh@std@ds@base', 'hotwire', 1.0)
    isHotwiring = false
    SetVehicleEngineOn(veh, true, true, false)
end)

function hasKeys(plate)
    local vehPlate = (plate)
    for k, v in ipairs(vehicles) do
        if v == vehPlate or v == vehPlate .. ' ' then
            return true
        end
    end
    return false
end

function beginRobTimer(entity)
    local timer = 18

    while canRob do
        timer = timer - 1
        if timer == 0 then
            canRob = false
            SetBlockingOfNonTemporaryEvents(entity, false)
        end
        Wait(1000)
    end
end

function hasBeenSearched(plate)
    local vehPlate = (plate)
    for k, v in ipairs(searchedVehicles) do
        if v == vehPlate then
            return true
        end
    end
    return false
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 460
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.3, 0.3)
	SetTextFont(6)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 160)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0115, 0.02 + factor, 0.027, 28, 28, 28, 95)
end
---- Main thread
-- The logic of the script is here
Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- If the defined key is pressed
        if(IsControlJustPressed(1, globalConf["CLIENT"].key))then

            -- Init player infos
            local ply = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(ply, true)
            local px, py, pz = table.unpack(GetEntityCoords(ply, true))
            isInside = false

            -- Retrieve the local ID of the targeted vehicle
            if(IsPedInAnyVehicle(ply, true))then
                -- by sitting inside him
                localVehId = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                isInside = true
            else
                -- by targeting the vehicle
                localVehId = GetTargetedVehicle(pCoords, ply)
            end

            -- Get targeted vehicle infos
            if(localVehId and localVehId ~= 0)then
                local localVehPlate = string.lower(GetVehicleNumberPlateText(localVehId))
                local localVehLockStatus = GetVehicleDoorLockStatus(localVehId)
                local hasKey = false

                -- If the vehicle appear in the table (if this is the player's vehicle or a locked vehicle)
                for plate, vehicle in pairs(vehicles) do
                    if(string.lower(plate) == localVehPlate)then
                        -- If the vehicle is not locked (this is the player's vehicle)
                        if(vehicle ~= "locked")then
                            hasKey = true
                            if(time > timer)then
                                -- update the vehicle infos (Useful for hydrating instances created by the /givekey command)
                                vehicle.update(localVehId, localVehLockStatus)
                                -- Lock or unlock the vehicle
                                playLockAnim()

                                vehicle.lock()
                                if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                                    Wait(500)
                                    local flickers = 0
                                    while flickers < 2 do
                                        SetVehicleLights(localVehId, 2)
                                        Wait(170)
                                        SetVehicleLights(localVehId, 0)
                                        flickers = flickers + 1
                                        Wait(170)
                                    end
                                end
                                time = 0
                            else
                                --TriggerEvent("ls:notify", "You have to wait " .. (timer / 1000) .." seconds")
                                exports['mythic_notify']:DoHudText('inform', "You have to wait " .. (timer / 1000) .." seconds")
                            end
                        else
                            --TriggerEvent("ls:notify", "The keys aren't inside")
                            exports['mythic_notify']:DoHudText('error', "The keys aren't inside")
                        end
                    end
                end

--[[                 -- If the player doesn't have the keys
                if(not hasKey)then
                    -- If the player is inside the vehicle
                    if(isInside)then
                        -- If the player find the keys
                        if(canSteal())then
                            -- Check if the vehicle is already owned.
                            -- And send the parameters to create the vehicle object if this is not the case.
                            TriggerServerEvent('ls:checkOwner', localVehId, localVehPlate, localVehLockStatus)
                        else
                            -- If the player doesn't find the keys
                            -- Lock the vehicle (players can't try to find the keys again)
                            vehicles[localVehPlate] = "locked"
                            TriggerServerEvent("ls:lockTheVehicle", localVehPlate)
                            --TriggerEvent("ls:notify", "The keys aren't inside")
                            exports['mythic_notify']:DoHudText('error', "The keys aren't inside")
                            
                        end
                    end
                end ]]
            end
        end
    end
end)

function givePlayerKeys(plate)
    local vehPlate = plate
    table.insert(vehicles, vehPlate)
end

function playLockAnim(vehicle)
    local dict = "anim@mp_player_intmenu@key_fob@"
    RequestAnimDict(dict)

    local veh = vehicle

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
    end
end
---- Timer
Citizen.CreateThread(function()
    timer = globalConf['CLIENT'].lockTimer * 1000
    time = 0
	while true do
		Wait(1000)
		time = time + 1000
	end
end)

---- Prevents the player from breaking the window if the vehicle is locked
-- (fixing a bug in the previous version)
--[[ Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
        	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
	        local lock = GetVehicleDoorLockStatus(veh)
	        if lock == 4 then
	        	ClearPedTasks(ped)
	        end
        end
	end
end)
 ]]
---- Locks vehicles if non-playable characters are in them
-- Can be disabled in "config/shared.lua"
if(globalConf['CLIENT'].disableCar_NPC)then
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            local ped = GetPlayerPed(-1)
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
                local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
                local lock = GetVehicleDoorLockStatus(veh)
                if lock == 7 then
                    SetVehicleDoorsLocked(veh, 2)
                end
                local pedd = GetPedInVehicleSeat(veh, -1)
                if pedd then
                    SetPedCanBeDraggedOut(pedd, false)
                end
            end
        end
    end)
end

------------------------    EVENTS      ------------------------
------------------------     :)         ------------------------

---- Update a vehicle plate (for developers)
-- @param string oldPlate
-- @param string newPlate
RegisterNetEvent("ls:updateVehiclePlate")
AddEventHandler("ls:updateVehiclePlate", function(oldPlate, newPlate)
    local oldPlate = string.lower(oldPlate)
    local newPlate = string.lower(newPlate)

    if(vehicles[oldPlate])then
        vehicles[newPlate] = vehicles[oldPlate]
        vehicles[oldPlate] = nil

        TriggerServerEvent("ls:updateServerVehiclePlate", oldPlate, newPlate)
    end
end)

---- Event called from the server
-- Get the keys and create the vehicle Object if the vehicle has no owner
-- @param boolean hasOwner
-- @param int localVehId
-- @param string localVehPlate
-- @param int localVehLockStatus
RegisterNetEvent("ls:getHasOwner")
AddEventHandler("ls:getHasOwner", function(hasOwner, localVehId, localVehPlate, localVehLockStatus)
    if(not hasOwner)then
        TriggerEvent("ls:newVehicle", localVehId, localVehPlate, localVehLockStatus)
        TriggerServerEvent("ls:addOwner", localVehPlate)

        TriggerEvent("ls:notify", getRandomMsg())
    else
        TriggerEvent("ls:notify", "This vehicle is not yours")
    end
end)

---- Create a new vehicle object
-- @param int id [opt]
-- @param string plate
-- @param string lockStatus [opt]
RegisterNetEvent("ls:newVehicle")
AddEventHandler("ls:newVehicle", function(id, plate, lockStatus)
    if(plate)then
        local plate = string.lower(plate)
        if(not id)then id = nil end
        if(not lockStatus)then lockStatus = nil end
        vehicles[plate] = newVehicle()
        vehicles[plate].__construct(id, plate, lockStatus)
    else
        print("Can't create the vehicle instance. Missing argument PLATE")
    end
end)

---- Event called from server when a player execute the /givekey command
-- Create a new vehicle object with its plate
-- @param string plate
RegisterNetEvent("ls:giveKeys")
AddEventHandler("ls:giveKeys", function(plate)
    local plate = string.lower(plate)
    TriggerEvent("ls:newVehicle", nil, plate, nil)
end)

---- Piece of code from Scott's InteractSound script : https://forum.fivem.net/t/release-play-custom-sounds-for-interactions/8282
-- I've decided to use only one part of its script so that administrators don't have to download more scripts. I hope you won't forget to thank him!
RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)

RegisterNetEvent('ls:notify')
AddEventHandler('ls:notify', function(text, duration)
	Notify(text, duration)
end)

------------------------    FUNCTIONS      ------------------------
------------------------        :O         ------------------------

---- A simple algorithm that checks if the player finds the keys or not.
-- @return boolean
function canSteal()
    nb = math.random(1, 100)
    percentage = globalConf["CLIENT"].percentage
    if(nb < percentage)then
        return true
    else
        return false
    end
end

---- Return a random message
-- @return string
function getRandomMsg()
    msgNb = math.random(1, #randomMsg)
    return randomMsg[msgNb]
end

---- Get a vehicle in direction
-- @param array coordFrom
-- @param array coordTo
-- @return int
function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

---- Get the vehicle in front of the player
-- @param array pCoords
-- @param int ply
-- @return int
function GetTargetedVehicle(pCoords, ply)
    for i = 1, 200 do
        coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, (6.281)/i, 0.0)
        targetedVehicle = GetVehicleInDirection(pCoords, coordB)
        if(targetedVehicle ~= nil and targetedVehicle ~= 0)then
            return targetedVehicle
        end
    end
    return
end


---- Notify the player
-- Can be configured in "config/shared.lua"
-- @param string text
-- @param float duration [opt]
--[[ function Notify(text, duration)
	if(globalConf['CLIENT'].notification)then
		if(globalConf['CLIENT'].notification == 1)then
			if(not duration)then
				duration = 0.080
			end
			SetNotificationTextEntry("STRING")
			AddTextComponentString(text)
			Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_LIFEINVADER", "CHAR_LIFEINVADER", true, 1, "LockSystem V" .. _VERSION, "By Deediezi", duration)
			DrawNotification_4(false, true)
		elseif(globalConf['CLIENT'].notification == 2)then
			TriggerEvent('chatMessage', '^1LockSystem V' .. _VERSION, {255, 255, 255}, text)
		else
			return
		end
	else
		return
	end
end ]]
function Notify(text, duration)
    exports["mythic_notify"]:DoHudText('inform', text)
end
