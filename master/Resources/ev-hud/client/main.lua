ESX = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end


    ESX.PlayerData = ESX.GetPlayerData()

    TriggerServerEvent("ev-hud:server:requestTable")
end)

local EVHud = true
local speed = 0.0
local seatbeltOn = false
local cruiseOn = false
local seatbeltEjectSpeed = 45               -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 100              -- Acceleration threshold to eject player (G's)

local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local stress = 100
local drunk = 0
local belt = false
local cruiseInput = 137                     -- Toggle cruise on/off with CAPSLOCK or A button (controller)
local cruiseColorOn = {160, 255, 160}       -- Color used when seatbelt is on
local cruiseColorOff = {255, 255, 255}      -- Color used when seatbelt is off
local screenPosX = 0.165                    -- X coordinate (top left corner of HUD)
local screenPosY = 0.882                    -- Y coordinate (top left corner of HUD)

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
	if hour <= 9 then
		hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

--[[ RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('disc-hud:getMoney', {}, function(data)
        SendNUIMessage({
            action = 'display',
            cash = data.cash,
            bank = data.bank
        })
    end)
end) ]]

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do 
        if ESX ~= nil and EVHud then
            speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local time = CalculateTimeToDisplay()
            local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
            local fuel = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                health = GetEntityHealth(GetPlayerPed(-1)),
                armor = GetPedArmour(GetPlayerPed(-1)),
                thirst = thirst,
                hunger = hunger,
                drunk = drunk,
                stress = stress,
                bleeding = bleedingPercentage,
                direction = GetDirectionText(GetEntityHeading(GetPlayerPed(-1))),
                street1 = GetStreetNameFromHashKey(street1),
                street2 = GetStreetNameFromHashKey(street2),
                area_zone = current_zone,
                speed = math.ceil(speed),
                fuel = fuel,
                time = time,
                engine = engine,
            })
            Citizen.Wait(500)
        else
            Citizen.Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
    local currSpeed = 0
    local prevVelocity = { x = 0.0, y = 0.0, z = 0.0 }
    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player)
    local prevHp = GetEntityHealth(veh)
    while true do
        Citizen.Wait(0)
        local prevSpeed = currSpeed
        local position = GetEntityCoords(player)
        currSpeed = GetEntitySpeed(veh)
        if not seatbeltIsOn then
            local vehIsMovingFwd = GetEntitySpeedVector(veh, true).y > 1.0
            local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
            if (vehIsMovingFwd and (prevSpeed > seatbeltEjectSpeed) and (vehAcc > (seatbeltEjectAccel * 9.81))) then
                SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                Citizen.Wait(1)
                SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
            else
                prevVelocity = GetEntityVelocity(veh)
            end
        else
            DisableControlAction(0, 75)
        end
    end
end)


local enableCruise = false
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait( 0 )   
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped, false)
		local vehicleModel = GetEntityModel(vehicle)
		--local speed = GetEntitySpeed(vehicle)
		local float Max = GetVehicleMaxSpeed(vehicleModel)
        if ( ped ) then
            local inVehicle = IsPedSittingInAnyVehicle(ped)
            if inVehicle and IsControlJustPressed(0, 26) then
                if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                --vehicle = GetVehiclePedIsIn(ped, false)
                    if enableCruise == false then
                       local speed = GetEntitySpeed(vehicle)
                        SetEntityMaxSpeed(vehicle, speed)
                        --SetVehicleForwardSpeed(vehicle, speed)
                        --TriggerEvent("chatMessage", "[Cruise Control: ]", {255, 255, 255}, "Cruise control enabled, MAX speed".. math.floor(speed*3.6).."km/h")
                        enableCruise = true
                    else
                    
                        SetEntityMaxSpeed(vehicle, Max)
                        ---TriggerEvent("chatMessage", "[Cruise Control: ]", {255, 255, 255}, "Cruise control DISABLED, MAX speed".. math.floor(Max*3.6).. "km/h")
                        enableCruise = false
                    end
                end
            end
        end
	end
end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and EVHud then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
    end
end)

RegisterCommand('hudon', function()
    EVHud = true
end)

RegisterCommand('hudoff', function()
    EVHud = false
    SendNUIMessage({
        action = "hudtick",
        show = false,
        health = GetEntityHealth(GetPlayerPed(-1)),
        armor = GetPedArmour(GetPlayerPed(-1)),
        thirst = false,
        hunger = false,
        drunk = false,
        stress = false,
        bleeding = false,
        direction = false,
        street1 = false,
        street2 = false,
        area_zone = false,
        speed = false,
        fuel = false,
        time = false,
        engine = false,
    })
end)

local movieview = false
local UI = { 
	x =  0.000 ,
	y = -0.001 ,
}

---------------------------------------------------------------------------
-- Toggle movie view --
---------------------------------------------------------------------------

RegisterCommand("movieon", function(source, args, rawCommand)
    movieview = true
    SendNUIMessage({
        action = "car",
        show = false,
    })
end, false)

RegisterCommand("movieoff", function(source, args, rawCommand)
	movieview = false
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if movieview then
			HideHUDThisFrame()
			drawRct(UI.x + 0.0, 	UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
			drawRct(UI.x + 0.0, 	UI.y + 0.85, 1.0,0.151,0,0,0,255) -- Bottom Bar
		end
	end
end)

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

--FUNCTIONS--


Citizen.CreateThread(function()
	while true do
		TriggerEvent('esx_status:getStatus', 'hunger', function(h)
            TriggerEvent('esx_status:getStatus', 'thirst', function(t)
                TriggerEvent('esx_status:getStatus', 'drunk', function(d)
                    TriggerEvent('esx_status:getStatus', 'stress', function(s)
                        hunger = h.getPercent()
                        thirst = t.getPercent()
                        drunk = d.getPercent()
                        stress = s.getPercent()
                    end)
				end)
			end)
        end)
        Citizen.Wait(300)

	end
end)

local vehiclesKHM = {}

Citizen.CreateThread(function()

	while true do
        Citizen.Wait(1)
        
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if DoesEntityExist(veh) then

            local plate = GetVehicleNumberPlateText(veh)
            local k = GetEntitySpeed(veh) * 3.6
            local h = ((k/60)/1000)/2.5

            if not vehiclesKHM[plate] then
                vehiclesKHM[plate] = 0
            end

            if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                vehiclesKHM[plate] = vehiclesKHM[plate] + h
            end

            TriggerEvent("ev-hud:client:UpdateDrivingMeters", true, math.floor(vehiclesKHM[plate]))
        end

        if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(PlayerPedId()) then
            seatbeltOn = not seatbeltOn
             if not seatbeltOn then
                TriggerEvent("seatbelt:client:ToggleSeatbelt",false)
                exports['mythic_notify']:DoHudText('inform', 'Seatbelt Off')
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'seatbeltoff', 0.1)
                Citizen.Wait(1000)
                belt = false
                --TriggerEvent("notification",'Seat Belt Disabled',2)
			else
                TriggerEvent("seatbelt:client:ToggleSeatbelt",true)
                exports['mythic_notify']:DoHudText('inform', 'Seatbelt On')
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'seatbelton', 0.1)
                Citizen.Wait(1000)
                belt = true
				--TriggerEvent("notification",'Seat Belt Enabled',1)
            end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1)) --morpheause show ammo fix
        DisplayAmmoThisFrame(currentWeapon)
        DisplayAmmoThisFrame(true)
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if DoesEntityExist(veh) then
            local plate = GetVehicleNumberPlateText(veh)
            if vehiclesKHM[plate] and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                TriggerServerEvent("ev-hud:server:vehiclesKHM", plate, vehiclesKHM[plate])
            end
        end
	end
end)

RegisterNetEvent("ev-hud:client:vehiclesKHM")
AddEventHandler("ev-hud:client:vehiclesKHM", function(plate,kmh)
    vehiclesKHM[plate] = kmh
end)

RegisterNetEvent("ev-hud:client:vehiclesKHMTable")
AddEventHandler("ev-hud:client:vehiclesKHMTable", function(table)
    vehiclesKHM = table
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('ev-hud:client:ToggleHarness')
AddEventHandler('ev-hud:client:ToggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        toggle = toggle
    })
end)

RegisterNetEvent('ev-hud:client:UpdateNitrous')
AddEventHandler('ev-hud:client:UpdateNitrous', function(toggle, level, IsActive)
    SendNUIMessage({
        action = "nitrous",
        toggle = toggle,
        level = level,
        active = IsActive
    })
end)

RegisterNetEvent('ev-hud:client:UpdateDrivingMeters')
AddEventHandler('ev-hud:client:UpdateDrivingMeters', function(toggle, amount)
    SendNUIMessage({
        action = "UpdateDrivingMeters",
        amount = amount,
        toggle = toggle,
    })
end)

RegisterNetEvent('ev-hud:client:UpdateVoiceProximity')
AddEventHandler('ev-hud:client:UpdateVoiceProximity', function(Proximity)
    SendNUIMessage({
        action = "proximity",
        prox = Proximity
    })
end)

RegisterNetEvent('ev-hud:client:ProximityActive')
AddEventHandler('ev-hud:client:ProximityActive', function(active)
    SendNUIMessage({
        action = "talking",
        IsTalking = active
    })
end)


local LastHeading = nil
local Rotating = "left"

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local PlayerHeading = GetEntityHeading(ped)
        if LastHeading ~= nil then
            if PlayerHeading < LastHeading then
                Rotating = "right"
            elseif PlayerHeading > LastHeading then
                Rotating = "left"
            end
        end
        LastHeading = PlayerHeading
        SendNUIMessage({
            action = "UpdateCompass",
            heading = PlayerHeading,
            lookside = Rotating,
        })
        Citizen.Wait(6)
    end
end)

--[[ Citizen.CreateThread(function()
    local player = PlayerPedId()
    while IsPedInAnyVehicle(player) do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 29) then
            local vehClass = GetVehicleClass(veh)
            if vehClass ~= 8 and vehClass ~= 13 and vehClass ~= 14 then
                if seatbeltIsOn then
                    exports['mythic_notify']:DoHudText('inform', 'Seatbelt Off')
                else
                    exports['mythic_notify']:DoHudText('inform', 'Seatbelt On')
                end
                seatbeltIsOn = not seatbeltIsOn
                SendNUIMessage({
                    action = 'seatbelt',
                    seatbelt = seatbeltOn,
                })
            end
        end
    end
end) ]]


function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Noord"
    elseif (heading >= 45 and heading < 135) then
        return "Oost"
    elseif (heading >=135 and heading < 225) then
        return "Zuid"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HideHudComponentThisFrame(7) -- Area Name
        HideHudComponentThisFrame(9) -- Street Name
        HideHudComponentThisFrame(3) -- SP Cash display
        HideHudComponentThisFrame(4)  -- MP Cash display
        HideHudComponentThisFrame(13) -- Cash changesSetPedHelmet(PlayerPedId(), false)
        --SetHealthArmorType(3)
    end
end)
--[[ 
Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)
 ]]
--[[ Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end) ]]

--[[ Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
    Wait(0)
    Citizen.InvokeNative(0xF6E48914C7A8694E, minimap, "SETUP_HEALTH_ARMOUR")
    Citizen.InvokeNative(0xC3D0841A0CC546A6,3)
    Citizen.InvokeNative(0xC6796A8FFA375E53 )
    end
end)
 ]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if belt == true then
            DisableControlAction(0, 75)
        else
            belt = false
        end
    end
end)

function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
        SetRadarBigmapEnabled(false, false)
	end
end)
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        SetRadarBigmapEnabled(false, false)
	end
end)

---------------------------------------------------------------------
--[[
    MINIMAP SCALEFORM UTILITY
    BY GLITCHDETECTOR
    CUSTOM
]]

--[[ SatNav = {
    ["NONE"] = {icon = 0},
    ["UP"] = {icon = 1},
    ["DOWN"] = {icon = 2},
    ["LEFT"] = {icon = 3},
    ["RIGHT"] = {icon = 4},
    ["EXIT_LEFT"] = {icon = 5},
    ["EXIT_RIGHT"] = {icon = 6},
    ["UP_LEFT"] = {icon = 7},
    ["UP_RIGHT"] = {icon = 8},
    ["MERGE_RIGHT"] = {icon = 9},
    ["MERGE_LEFT"] = {icon = 10},
    ["UTURN"] = {icon = 11},
}

MinimapScaleform = {
    scaleform = nil,
}

local function getMinimap()
    return MinimapScaleform.scaleform
end

function SetSatNavDirection(direction)
    local dir = SatNav[direction]
    if type(direction) == 'number' then
        dir = direction
    end
    if dir then
        BeginScaleformMovieMethod(getMinimap(), "SET_SATNAV_DIRECTION")
        ScaleformMovieMethodAddParamInt(dir.icon)
        EndScaleformMovieMethod()
    end
end

function SetSatNavDistance(distance)
    BeginScaleformMovieMethod(getMinimap(), "SET_SATNAV_DISTANCE")
    ScaleformMovieMethodAddParamInt(distance)
    EndScaleformMovieMethod()
end

function SetSatNavState(show)
    BeginScaleformMovieMethod(getMinimap(), (show and "SHOW_SATNAV" or "HIDE_SATNAV"))
    EndScaleformMovieMethod()
end

function SetStallWarningState(show)
    BeginScaleformMovieMethod(getMinimap(), "SHOW_STALL_WARNING")
    ScaleformMovieMethodAddParamBool(show)
    EndScaleformMovieMethod()
end

function SetAbilityGlow(show)
    BeginScaleformMovieMethod(getMinimap(), "SET_ABILITY_BAR_GLOW")
    ScaleformMovieMethodAddParamBool(show)
    EndScaleformMovieMethod()
end

function SetAbilityVisible(show)
    BeginScaleformMovieMethod(getMinimap(), "SET_ABILITY_BAR_VISIBILITY_IN_MULTIPLAYER")
    ScaleformMovieMethodAddParamBool(show)
    EndScaleformMovieMethod()
end

function ShowYoke(x, y, vis, alpha)
    BeginScaleformMovieMethod(getMinimap(), "SHOW_YOKE")
    ScaleformMovieMethodAddParamFloat(show)
    ScaleformMovieMethodAddParamFloat(show)
    ScaleformMovieMethodAddParamBool(show)
    ScaleformMovieMethodAddParamInt(alpha)
    EndScaleformMovieMethod()
end

function SetHealthArmorType(type)
    BeginScaleformMovieMethod(getMinimap(), "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(type)
    EndScaleformMovieMethod()
end

function SetHealthAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_PLAYER_HEALTH")
    ScaleformMovieMethodAddParamInt(amount)
    ScaleformMovieMethodAddParamFloat(0)
    ScaleformMovieMethodAddParamFloat(2000)
    ScaleformMovieMethodAddParamBool(false)
    EndScaleformMovieMethod()
end

function SetArmorAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_PLAYER_ARMOUR")
    ScaleformMovieMethodAddParamInt(amount)
    ScaleformMovieMethodAddParamFloat(0)
    ScaleformMovieMethodAddParamFloat(2000)
    EndScaleformMovieMethod()
end

function SetAbilityAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_ABILITY_BAR")
    ScaleformMovieMethodAddParamInt(amount)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamFloat(100)
    EndScaleformMovieMethod()
end

function SetAirAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_AIR_BAR")
    ScaleformMovieMethodAddParamFloat(amount)
    EndScaleformMovieMethod()
end

Citizen.CreateThread(function()
    MinimapScaleform.scaleform = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end) ]]