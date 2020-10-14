ESX = nil

local vehicles = {}
local searchedVehicles = {}
local pickedVehicled = {}
local hasCheckedOwnedVehs = false
local lockDisable = false
local engine = nil
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
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

local button = 167 -- 167 (F6 by default)
local commandEnabled = true -- (false by default) If you set this to true, typing "/engine" in chat will also toggle your engine.

-- You're all set now!


-- Code, no need to modify this, unless you know what you're doing or you want to fuck shit up.
-- No support will be provided if you modify this part below.





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

function toggleEngine()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    SetVehicleEngineOn(vehicle, true, true, true)
end

function toggleEngineoff()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    SetVehicleEngineOn(vehicle, false, true, true)
end

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


function givePlayerKeys(plate)
    local vehPlate = plate
    table.insert(vehicles, vehPlate)
end

function hasToggledLock()
    lockDisable = true
    Wait(100)
    lockDisable = false
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


function toggleLock(vehicle)
    local veh = vehicle

    local plate = GetVehicleNumberPlateText(veh)
    local lockStatus = GetVehicleDoorLockStatus(veh)
    if hasKeys(plate) and not lockDisable then
        print('lock status: ' .. lockStatus)
        if lockStatus == 1 then
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleDoorShut(veh, 0, true)
            SetVehicleDoorShut(veh, 1, true)
            SetVehicleDoorShut(veh, 2, true)
            SetVehicleDoorShut(veh, 3, true)
            SetVehicleDoorShut(veh, 4, true)
            SetVehicleDoorShut(veh, 5, true)            
            SetVehicleDoorsLockedForAllPlayers(veh, true)
            exports['mythic_notify']:DoHudText('inform', 'Vehicle Locked')
            playLockAnim()
            PlayVehicleDoorCloseSound(vehicle, 1)
            hasToggledLock()
        elseif lockStatus == 2 then
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            exports['mythic_notify']:DoHudText('inform', 'Vehicle Unlocked')
            playLockAnim(veh)
            PlayVehicleDoorOpenSound(vehicle, 1)
            hasToggledLock()
        else
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleDoorShut(veh, 0, true)
            SetVehicleDoorShut(veh, 1, true)
            SetVehicleDoorShut(veh, 2, true)
            SetVehicleDoorShut(veh, 3, true)
            SetVehicleDoorShut(veh, 4, true)
            SetVehicleDoorShut(veh, 5, true)
            SetVehicleDoorsLockedForAllPlayers(veh, true)
            exports['mythic_notify']:DoHudText('inform', 'Vehicle Locked')
            playLockAnim()
            PlayVehicleDoorCloseSound(vehicle, 1)
            hasToggledLock()

        end
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            Wait(500)
            local flickers = 0
            while flickers < 2 do
                SetVehicleLights(veh, 2)
                Wait(170)
                SetVehicleLights(veh, 0)
                flickers = flickers + 1
                Wait(170)
            end
        end
    end
end


RegisterNetEvent('onyx:pickDoor')
AddEventHandler('onyx:pickDoor', function()
    -- TODO: Lockpicking vehicle doors to gain access
end)

-- Locking vehicles
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if IsControlJustReleased(0, 303) then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                toggleLock(veh)

            else
                local veh = GetClosestVehicle(pos.x, pos.y, pos.z, 3.0, 0, 70)
                if DoesEntityExist(veh) then
                    toggleLock(veh)
                end
            end
        end

        -- TODO: Unable to gain access to vehicles without a lockpick or keys
        -- local enteringVeh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
        -- local enteringPlate = GetVehicleNumberPlateText(enteringVeh)

        -- if not hasKeys(entertingPlate) then
        --     SetVehicleDoorsLocked(enteringVeh, 2)
        -- end
    end
end)

local isSearching = false
local isHotwiring = false
local engine = false
local isshowing = false


--[[ Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped)
            local driver = GetPedInVehicleSeat(veh, -1)
            local plate = GetVehicleNumberPlateText(veh)
            if driver == ped then
                if hasKeys(plate) and not isHotwiring and not isSearching and not isshowing then
                    local pos = GetEntityCoords(ped)
                    if not isshowing then 
                        DrawText3Ds(pos.x, pos.y, pos.z + 0.2, 'Press ~y~[H] ~w~to hotwire or ~g~[Space] ~w~Engine')
                        isshowing = true
                    else
                        isshowing = false
                    end
                    if IsControlJustReleased(0, 74) and not isHotwiring then
                        print('lol')
                        isshowing = false
                    elseif IsControlJustReleased(0, 22) and not engine and not isHotwiring then
                        SetVehicleEngineOn(veh, true, false, true)
                        isshowing = false
                        engine = true
                    elseif IsControlJustReleased(0, 22) and engine and not isHotwiring then
                        SetVehicleEngineOn(veh, false, false, true)
                        engine = false
                        isshowing = false
                    end
                end
            end
        end
    end
end) ]]

-- Has entered vehicle without keys
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
                                table.insert(vehicles, plate)
                                TriggerServerEvent('onyx:updateSearchedVehTable', plate)
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

                                -- Update veh table so other players cant search the same vehicle
                                TriggerServerEvent('onyx:updateSearchedVehTable', plate)
                                table.insert(searchedVehicles, plate)
                            end
                        end
                    end
                    -- Hotwiring
                    if IsControlJustReleased(0, 74) and not isHotwiring then -- E
                        TriggerServerEvent('onyx:reqHotwiring', plate)
                    end
                else
                    SetVehicleEngineOn(veh, true, true, false)
                end
            end
        end
    end
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

RegisterNetEvent('onyx:updatePlates')
AddEventHandler('onyx:updatePlates', function(plate)
    table.insert(vehicles, plate)
end)

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

    if Config.HotwireAlarmEnabled then
        local alarmChance = math.random(1, Config.HotwireAlarmChance)

        if alarmChance == 1 then
            SetVehicleAlarm(veh, true)
            StartVehicleAlarm(veh) 
        end
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
    --exports['progressBars']:startUI(time, "Hotwiring")
    TaskPlayAnim(PlayerPedId(), "veh@std@ds@base", "hotwire", 8.0, 8.0, -1, 1, 0.3, true, true, true)
    Citizen.Wait(time)
    Wait(1000)
    table.insert(vehicles, vehPlate)
    StopAnimTask(PlayerPedId(), 'veh@std@ds@base', 'hotwire', 1.0)
    isHotwiring = false
    SetVehicleEngineOn(veh, true, true, false)
end)
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
                        exports['mythic_notify']:DoHudText('inform', 'You rob the keys')
                    end
                    SetBlockingOfNonTemporaryEvents(prevPed, false)
                    canRob = false
--[[                 end
            end ]]
        end
    end
end)

RegisterCommand("givekey", function(source, args, rawCommand)
    -- Wait for next frame just to be safe
    Citizen.Wait(0)
    local player = GetPlayerPed(-1)
    local curVeh = GetVehiclePedIsIn(player, false)
    local plate = GetVehicleNumberPlateText(curVeh)
    local player, distance = ESX.Game.GetClosestPlayer()
    
    if distance ~= -1 and distance <= 3.0 then
        exports["onyxLocksystem_lock"]:givePlayerKeys(plate)GetPlayerServerId(PlayerId())GetPlayerServerId(player)
    else
        exports['mythic_notify']:DoHudText('inform', 'No Players Nearby')
    end

    end, false)


RegisterNetEvent('givekeys')
AddEventHandler('givekeys', function(plate, target)
    local player = GetPlayerPed(-1)
    local curVeh = GetVehiclePedIsIn(player, false)
    local passenger = GetPedInVehicleSeat(curVeh, 0)
    local passname = GetPlayerName(passenger)
    local driver = GetPedInVehicleSeat(curVeh, -1)
    local plate = GetVehicleNumberPlateText(curVeh)

    if player == driver and hasKeys(plate) then
        givePlayerKeys(plate)
        exports['mythic_notify']:DoHudText('inform', "You Gave Keys ".. plate .." To "..passname)
    else 
       exports['mythic_notify']:DoHudText('inform', "You can't do that.")
    end
end)

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

function isNpc(ped)
    if IsPedAPlayer(ped) then
        return false
    else
        return true
    end
end


RegisterNetEvent('onyx:returnSearchedVehTable')
AddEventHandler('onyx:returnSearchedVehTable', function(plate)
    local vehPlate = plate
    table.insert(searchedVehicles, vehPlate)
end)

function hasBeenSearched(plate)
    local vehPlate = plate
    for k, v in ipairs(searchedVehicles) do
        if v == vehPlate then
            return true
        end
    end
    return false
end

function hasKeys(plate)
    local vehPlate = plate
    for k, v in ipairs(vehicles) do
        if v == vehPlate or v == vehPlate .. ' ' then
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