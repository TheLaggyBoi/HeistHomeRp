-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

windowRolled = false

menuOpen = false
-- Shop Thread:
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player)
		for k,v in pairs(Config.Locksmith) do
			local dist = GetDistanceBetweenCoords(v.Pos[1], v.Pos[2], v.Pos[3], coords.x, coords.y, coords.z, false)
			local mk = v.Marker
			if mk.Enable and dist <= mk.DrawDist and not menuOpen then
				DrawMarker(mk.Type, v.Pos[1], v.Pos[2], v.Pos[3]-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, mk.Scale.x, mk.Scale.y, mk.Scale.z, mk.Color.r, mk.Color.g, mk.Color.b, mk.Color.a, false, true, 2, false, false, false, false)
			end
			if dist <= 1.5 and not menuOpen then
				DrawText3Ds(v.Pos[1], v.Pos[2], v.Pos[3]+0.2, Lang['open_locksmith'])
				if IsControlJustPressed(0, v.Key) then
					OpenKeyShopMenu()
					Citizen.Wait(250)
				end
			end
		end
		for k,v in pairs(Config.AlarmShop) do
			local dist = GetDistanceBetweenCoords(v.Pos[1], v.Pos[2], v.Pos[3], coords.x, coords.y, coords.z, false)
			local mk = v.Marker
			if mk.Enable and dist <= mk.DrawDist and not menuOpen then
				DrawMarker(mk.Type, v.Pos[1], v.Pos[2], v.Pos[3]-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, mk.Scale.x, mk.Scale.y, mk.Scale.z, mk.Color.r, mk.Color.g, mk.Color.b, mk.Color.a, false, true, 2, false, false, false, false)
			end
			if dist <= 1.5 and not menuOpen then
				DrawText3Ds(v.Pos[1], v.Pos[2], v.Pos[3]+0.2, Lang['open_alarmshop'])
				if IsControlJustPressed(0, v.Key) then
					OpenAlarmShopMenu()
					Citizen.Wait(250)
				end
			end
		end
	end
end)

RegisterNetEvent('t1ger_keys:openKeyShop')
AddEventHandler('t1ger_keys:openKeyShop', function()
	OpenKeyShopMenu()
end)

RegisterNetEvent('t1ger_keys:openAlarmShop')
AddEventHandler('t1ger_keys:openAlarmShop', function()
	OpenAlarmShopMenu()
end)

-- Function to open Key Shop 
function OpenKeyShopMenu()
	menuOpen = true
	local playerPed  = GetPlayerPed(-1)
	FreezeEntityPosition(playerPed, true)
	local elements = {}
	
	ESX.TriggerServerCallback("t1ger_keys:fetchData", function(vehicles)
		
		for k,v in pairs(vehicles) do
			local vehHash = v.vehicle.model
			local vehName = GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel = GetLabelText(vehName)
			if v.gotKey == 0 then
				table.insert(elements,{ label = vehLabel.." ("..v.plate..")" , name = vehLabel, plate = v.plate,  gotKey = v.gotKey})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_main_menu",
			{
				title    = Lang['shop_main_title'],
				align    = "center",
				elements = elements
			},
		function(data, menu)
			menu.close()
			OpenRegisterKeyMenu(data.current.plate, data.current.name, data.current.gotKey)
			FreezeEntityPosition(playerPed, false)
		end, function(data, menu)
			menu.close()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, false)
			menuOpen = false
		end)
	end)
	
end

-- Function to confirm registering a new key
function OpenRegisterKeyMenu(plate)	
	local elements = {
		{ label = Lang['reg_key_accept'], value = "reg_accept" },
		{ label = Lang['reg_key_decline'], value = "reg_decline" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "register_key_confirm",
		{
			title    = (Lang['reg_key_title']):format(Config.RegisterKeyPrice),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'reg_accept') then
			TriggerServerEvent('t1ger_keys:registerNewKey', plate)
			ShowNotifyESX(Lang['key_reg_accepted'])
			menu.close()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, false)
			menuOpen = false
		end
		if(data.current.value == 'reg_decline') then
			menu.close()
			ShowNotifyESX(Lang['key_reg_declined'])
			OpenKeyShopMenu()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		OpenKeyShopMenu()
	end)
end

-- Function to open Alarm Shop 
function OpenAlarmShopMenu()
	menuOpen = true
	local playerPed  = GetPlayerPed(-1)
	FreezeEntityPosition(playerPed, true)
	local elements = {}
	ESX.TriggerServerCallback("t1ger_keys:fetchData", function(vehicles)
		
		for k,v in pairs(vehicles) do
			local vehHash = v.vehicle.model
			local vehName = GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel = GetLabelText(vehName)
			local carModel = string.lower(vehName)
			if v.gotKey == 1 then
				table.insert(elements,{ label = vehLabel.." ("..v.plate..")" , name = vehLabel, plate = v.plate,  gotKey = v.gotKey, alarm = v.alarm, model = carModel})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "alarm_main_menu",
			{
				title    = Lang['alarm_main_title'],
				align    = "center",
				elements = elements
			},
		function(data, menu)
			menu.close()
			OpenAlarmSelectMenu(data.current.plate, data.current.name, data.current.gotKey, data.current.alarm, data.current.model)
			FreezeEntityPosition(playerPed, false)
		end, function(data, menu)
			menu.close()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, false)
			menuOpen = false
		end)
	end)
	
end

-- Function to select alarm:
function OpenAlarmSelectMenu(plate,name,gotKey,alarm,model)	
	local elements = {
		{ label = Lang['alarm_grade_0'], value = 0 },
		{ label = Lang['alarm_grade_1'], value = 1 },
		{ label = Lang['alarm_grade_2'], value = 2 },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "select_alarm_menu",
		{
			title    = Lang['alarm_select_title'],
			align    = "center",
			elements = elements
		},
	function(data, menu)
		TriggerServerEvent('t1ger_keys:updateCarAlarm', plate, data.current.value, model)
		menu.close()
		OpenAlarmShopMenu()
	end, function(data, menu)
		menu.close()
		OpenAlarmShopMenu()
	end)
end

-- Give Keys Command:
RegisterCommand('givekeys', function(source, args)
	OwnedKeysActions()
end, false)

-- Car Menu Command:
RegisterCommand('carmenu', function(source, args)
	OpenCarMenu()
end, false)

-- Function to open car menu: 
function OpenCarMenu()
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)
	local car = nil
	if IsPedInAnyVehicle(plyPed,  false) then
		car = GetVehiclePedIsIn(plyPed, false)
	else
		car = GetClosestVehicle(coords.x, coords.y, coords.z, 6.0, 0, 71)
	end
	
	local elements = {
		{ label = Lang['your_keys'], value = "your_keys_btn" },
		{ label = Lang['veh_windows_menu'], value = "veh_window_menu" },
		{ label = Lang['veh_door_menu'], value = "veh_door_menu" },
		{ label = Lang['veh_engine_label'], value = "veh_eng_btn" },
		{ label = Lang['veh_neon_label'], value = "veh_neon_btn" },
	}
	
	if Config.t1ger_carinsurance then
		table.insert(elements,{ label = Lang['insurance_menu'] , value = "open_insurance_menu"})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "register_key_confirm",
		{
			title    = Lang['car_menu_title'],
			align    = "center",
			elements = elements
		},
	function(data, menu)
		
		-- KEYS:
		if (data.current.value == 'your_keys_btn') then
			OwnedKeysActions()
		
		-- WINDOWS:
		elseif (data.current.value == 'veh_window_menu') then
			local elements = {}
			if DoesEntityExist(car) then
				local windowLabel = {{
					[0] = Lang['window_front_r'],
					[1] = Lang['window_front_l'],
					[2] = Lang['window_rear_r'],
					[3] = Lang['window_rear_l'],
				}}
				for i = 0,3 do
					if DoesVehicleHaveDoor(car, i) then
						local labelTxt = ''
						for k,v in pairs(windowLabel) do
							labelTxt = v[i]
							table.insert(elements,{ label = labelTxt , windowIndex = i})
						end
					end
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "veh_window_choose_menu", {
					title    = Lang['veh_windows_menu_title'],
					align    = "center",
					elements = elements
				},
				function(data2, menu2)
					if not windowRolled then 
						RollDownWindow(car, data2.current.windowIndex)
						windowRolled = true
					else 
						RollUpWindow(car, data2.current.windowIndex)
						windowRolled = false
					end	
				end, function(data2, menu2)
					menu2.close()
					ESX.UI.Menu.CloseAll()
					OpenCarMenu()
				end)
			else
				ShowNotifyESX(Lang['no_veh_nearby'])
			end
		
		-- DOORS:
		elseif (data.current.value == 'veh_door_menu') then
			local elements = {}
			if DoesEntityExist(car) then
				local doorLabel = {{
					[0] = Lang['door_front_left'],
					[1] = Lang['door_front_right'],
					[2] = Lang['door_rear_left'],
					[3] = Lang['door_rear_right'],
					[4] = Lang['door_hood'],
					[5] = Lang['door_trunk'],
				}}
				local CarDoors = GetNumberOfVehicleDoors(car)
				for i = 0,CarDoors do
					if DoesVehicleHaveDoor(car, i) then
						local labelTxt = ''
						for k,v in pairs(doorLabel) do
							labelTxt = v[i]
							table.insert(elements,{ label = labelTxt , doorIndex = i})
						end
					end
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "veh_door_choose_menu", {
					title    = Lang['veh_door_menu_title'],
					align    = "center",
					elements = elements
				},
				function(data2, menu2)
					if GetVehicleDoorAngleRatio(car, data2.current.doorIndex) > 0.0 then 
						SetVehicleDoorShut(car, data2.current.doorIndex, false)
					else 
						SetVehicleDoorOpen(car, data2.current.doorIndex, false)
					end	
				end, function(data2, menu2)
					menu2.close()
					ESX.UI.Menu.CloseAll()
					OpenCarMenu()
				end)
			else
				ShowNotifyESX(Lang['no_veh_nearby'])
			end
		
		-- ENGINE:
		elseif (data.current.value == 'veh_eng_btn') then
			if DoesEntityExist(car) then
				if GetIsVehicleEngineRunning(car) then
					SetVehicleEngineOn(car,false,true,true)
				else
					SetVehicleEngineOn(car,true,true,true)
				end
			else
				ShowNotifyESX(Lang['no_veh_nearby'])
			end
		
		-- NEON:
		elseif (data.current.value == 'veh_neon_btn') then
			if DoesEntityExist(car) then
				if GetIsVehicleEngineRunning(car) then
					for i=0,3,1 do
						if IsVehicleNeonLightEnabled(car,i) then
							SetVehicleNeonLightEnabled(car,i,false)
						else
							SetVehicleNeonLightEnabled(car,i,true)
						end
					end
				else
					ShowNotifyESX(Lang['eng_not_running'])
				end
			else
				ShowNotifyESX(Lang['no_veh_nearby'])
			end
		
		-- INSURANCE:
		elseif (data.current.value == 'open_insurance_menu') then
			local elements = {}
			
			ESX.TriggerServerCallback("t1ger_keys:fetchInsuranceData", function(insuredCars)
				if insuredCars ~= nil then
					for k,v in pairs(insuredCars) do
						local vehHash = v.vehicle.model
						local vehName = GetDisplayNameFromVehicleModel(vehHash)
						local vehLabel = GetLabelText(vehName)
						table.insert(elements,{ label = vehLabel.." ("..v.plate..")" , name = vehLabel, plate = v.plate, insurance = v.insurance})
						
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), "see_insured_cars",
							{
								title    = Lang['insured_cars_title'],
								align    = "center",
								elements = elements
							},
						function(data2, menu2)
							menu2.close()
						end, function(data2, menu2)
							menu.close()
							ESX.UI.Menu.CloseAll()
							OpenCarMenu()
						end)
						
					end
				else
					ShowNotifyESX(Lang['no_insured_cars'])
				end
			end)
			
		end	
				
	end, function(data, menu)
		car = nil
		menu.close()
		ESX.UI.Menu.CloseAll()
	end)
	
end


-- Thread For Key Binding to Toggle Car Locks:
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 303) then
			ToggleVehicleLock()
		end
		if IsControlJustReleased(0, 166) then
			OpenCarMenu()
		end
	end
end)

-- Lock Toggle Anim Function /w effects:
function LockToggleEffects(car,locked)
	local plyPed = GetPlayerPed(-1)
	local prop = GetHashKey('p_car_keys_01')
	local animDict = 'anim@mp_player_intmenu@key_fob@'
	local animLib = 'fob_click'
	SetCurrentPedWeapon(plyPed, GetHashKey("WEAPON_UNARMED")) 
	RequestModel(prop)
	while not HasModelLoaded(prop) do
	    Citizen.Wait(10)
	end
	local keyFob = CreateObject(prop, 1.0, 1.0, 1.0, 1, 1, 0)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(1)
	end
	AttachEntityToEntity(keyFob, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.04, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	TaskPlayAnim(plyPed, animDict, animLib, 15.0, -10.0, 1500, 49, 0, false, false, false)
	PlaySoundFromEntity(-1, "Remote_Control_Fob", plyPed, "PI_Menu_Sounds", 1, 0)
	SetVehicleLights(car,2)
	Citizen.Wait(200)
	SetVehicleLights(car,1)
	Citizen.Wait(200)
	SetVehicleLights(car,2)
	Citizen.Wait(200)
	
	if locked then
		SetVehicleDoorsLocked(car, 1)
		PlayVehicleDoorOpenSound(car, 0)
		PlaySoundFromEntity(-1, "Remote_Control_Open", car, "PI_Menu_Sounds", 1, 0)
		ShowNotifyESX(Lang['car_unlocked'])
		
	elseif not locked then
		SetVehicleDoorsLocked(car, 2)
		PlayVehicleDoorCloseSound(car, 0)
		PlaySoundFromEntity(-1, "Remote_Control_Close", car, "PI_Menu_Sounds", 1, 0)
		ShowNotifyESX(Lang['car_locked'])
	end
	
	Citizen.Wait(200)
	SetVehicleLights(car,1)
	SetVehicleLights(car,0)
	Citizen.Wait(200)
	DeleteEntity(keyFob)
end


hotwireCar = nil
lockedVeh = nil

RegisterNetEvent("t1ger_keys:lockpickCL")
AddEventHandler("t1ger_keys:lockpickCL",function(k,v)
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)

	if IsPedInAnyVehicle(plyPed, false) then
		lockedVeh = GetVehiclePedIsIn(plyPed, false)
	else
		lockedVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 6.0, 0, 71)
	end
	local closePlate = GetVehicleNumberPlateText(lockedVeh)
	local closeHash = GetEntityModel(lockedVeh)
	
	if DoesEntityExist(lockedVeh) then
		Citizen.CreateThread(function()
			if GetVehicleDoorLockStatus(lockedVeh) == 1 or GetVehicleDoorLockStatus(lockedVeh) == 0 then
				ShowNotifyESX("Veh not locked")
			elseif GetVehicleDoorLockStatus(lockedVeh) == 2 then
				local percentChance = (math.random() * 100)
				ESX.TriggerServerCallback('t1ger_keys:isCarOwned', function(isCarOwned,alarmType)
					local lockpickSuccess = false
					if isCarOwned then 
						if alarmType == 0 then
							if percentChance <= v.ChanceOne then
								lockpickSuccess = true
							end
						elseif alarmType == 1 then
							if percentChance <= v.ChanceTwo then
								lockpickSuccess = true
							end
						elseif alarmType == 2 then
							if percentChance <= v.ChanceThree then
								lockpickSuccess = true
							end
						end
						LockpickCarFunction(k,v,lockpickSuccess)
					else
						if percentChance <= v.ChanceOne then
							lockpickSuccess = true
						end
						LockpickCarFunction(k,v,lockpickSuccess)
					end
				end, closePlate)
			end
		end)
	else
		ShowNotifyESX(Lang['no_veh_nearby'])
	end
end)

function LockpickCarFunction(k,v,success)
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)

	if IsPedInAnyVehicle(plyPed, false) then
		lockedVeh = GetVehiclePedIsIn(plyPed, false)
	else
		lockedVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 6.0, 0, 71)
	end
	local closePlate = GetVehicleNumberPlateText(lockedVeh)
	local closeHash = GetEntityModel(lockedVeh)
	
	ESX.TriggerServerCallback('t1ger_keys:removeLockpick', function(ItemRemoved)
		if ItemRemoved then
			RequestAnimDict(v.AnimDict)
			while not HasAnimDictLoaded(v.AnimDict) do
				Citizen.Wait(10)
			end
			if v.PoliceAlert then
				NotifyPoliceFunction()
			end
			SetCurrentPedWeapon(plyPed, GetHashKey("WEAPON_UNARMED"),true)
			Citizen.Wait(300)
			FreezeEntityPosition(plyPed, true)
			TaskPlayAnim(plyPed, v.AnimDict, v.AnimName, 3.0, 1.0, -1, 31, 0, 0, 0)
			if v.EnableAlarmSound then
				SetVehicleAlarm(lockedVeh, true)
				SetVehicleAlarmTimeLeft(lockedVeh, (v.CarAlarmTime * 1000))
				StartVehicleAlarm(lockedVeh)
			end
			exports['progressBars']:startUI((v.LockpickTime * 1000), v.ProgressBarText)
			Citizen.Wait(v.LockpickTime * 1000)
			
			if not success then
				ShowNotifyESX(Lang['lockpick_fail'])
				
				ClearPedTasks(plyPed)
				FreezeEntityPosition(plyPed, false)
			else
				ShowNotifyESX(Lang['lockpick_success'])
				SetVehicleDoorsLockedForAllPlayers(lockedVeh, false)
				SetVehicleDoorsLocked(lockedVeh,1)
				SetVehicleNeedsToBeHotwired(lockedVeh, false)
				
				ClearPedTasks(plyPed)
				FreezeEntityPosition(plyPed, false)
				
				CarHotwired = false
				
				while not CarHotwired do
					Citizen.Wait(1)
					if IsPedInAnyVehicle(plyPed, false) then
						hotwireCar = GetVehiclePedIsUsing(plyPed)
						if not IsVehicleNeedsToBeHotwired(hotwireCar) then
							SetVehicleNeedsToBeHotwired(lockedVeh, false)
						end
						if GetPedInVehicleSeat(hotwireCar, -1) == plyPed then
							if GetIsVehicleEngineRunning(hotwireCar) then
								SetVehicleEngineOn(hotwireCar,false,true,true)
							else
								SetVehicleEngineOn(hotwireCar,false,true,true)
							end
							SetVehicleUndriveable(hotwireCar,true)
						end
					end
					if GetDistanceBetweenCoords(coords,GetEntityCoords(lockedVeh),true) > 15 then
						CarHotwired = true
					end
				end
					
				if CarHotwired then
					SetVehicleEngineOn(hotwireCar,true,false,false)
					SetVehicleUndriveable(hotwireCar,false)
					SetVehicleNeedsToBeHotwired(hotwireCar, false)
					CarHotwired = false
					lockedVeh = nil
					hotwireCar = nil
				end
			end
		end
	end)
end

-- Hotwire Command:
RegisterCommand('hotwire', function(source, args)
	HotwireCarFunction()
end, false)

function HotwireCarFunction()
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)
	for k,v in pairs(Config.HotwireFeature) do 
		if IsPedInAnyVehicle(plyPed, false) then
			if GetVehiclePedIsUsing(plyPed) == hotwireCar and hotwireCar ~= nil then
				hotwireCar = GetVehiclePedIsUsing(plyPed)
				if GetPedInVehicleSeat(hotwireCar, -1) == plyPed then
					RequestAnimDict(v.AnimDict)
					while not HasAnimDictLoaded(v.AnimDict) do
						Citizen.Wait(10)
					end
					FreezeEntityPosition(plyPed, true)
					TaskPlayAnim(plyPed, v.AnimDict, v.AnimName, 8.0, -8.0, -1, 49, 0, 0, 0)
					exports['progressBars']:startUI((v.HotwireTime * 1000), v.ProgressBarText)
					Citizen.Wait(v.HotwireTime * 1000)
					ClearPedTasks(plyPed)
					FreezeEntityPosition(plyPed, false)
					local hotwireChance = (math.random() * 100)
					if Config.HotwireChance > hotwireChance then
						ShowNotifyESX(Lang['hotwire_success'])
						CarHotwired = true
					else
						ShowNotifyESX(Lang['hotwire_fail'])
						CarHotwired = false
					end
				else
					ShowNotifyESX(Lang['not_in_drv_seat'])
				end
			else
				ShowNotifyESX(Lang['hotwire_impossible'])
			end
		else
			ShowNotifyESX(Lang['not_in_a_veh'])
		end
	end
end

-- Thread to trigger aim & steal:
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
		local plyPed = PlayerPedId()
		if StealingVehicle(plyPed) then
			 Citizen.Wait(5)
		end	 
    end
end)

local isSearching = false
local isHotwiring = false
local engine = false
local isshowing = false
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
                if not HasTempCarKeys(plate) and not isHotwiring and not isSearching then
                    local pos = GetEntityCoords(ped)

                    DrawText3Ds(pos.x, pos.y, pos.z + 0.2, '~w~[H]~w~Hotwire|~w~[Space]~w~ Engine')
                    SetVehicleEngineOn(veh, false, true, true)
					if IsControlJustReleased(0, 74) and not isHotwiring then -- E

						isHotwiring = true

						RequestAnimDict("veh@std@ds@base")

						while not HasAnimDictLoaded("veh@std@ds@base") do
							Citizen.Wait(100)
						end

						local chnce = math.random(1, 5)
						
						if chnce >=2 then
							AlertPoliceFunction(veh)
							TriggerEvent('esx-alerts:vehiclesteal')
						end

						if isHotwiring then
							ESX.ShowHelpNotification("press ~INPUT_CONTEXT~ cancel hotwire")
						end
					
							local alarmChance = math.random(1, 10)
					
							if alarmChance == 1 then
								SetVehicleAlarm(veh, true)
								StartVehicleAlarm(veh) 
							end
						exports['mythic_progbar']:Progress({
							name = "hotwiring",
							duration = 10000,
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
						Citizen.Wait(10000)
						Wait(1000)
						TriggerServerEvent("t1ger_keys:stolenCarKeys", plate)
						StopAnimTask(PlayerPedId(), 'veh@std@ds@base', 'hotwire', 1.0)
						isHotwiring = false
						SetVehicleEngineOn(veh, true, true, false)
					elseif IsControlJustReleased(0, 22) and HasTempCarKeys(plate) then
						SetVehicleEngineOn(veh, true, true, false)
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
        local ped = PlayerPedId()
        local lastVehicle = GetVehiclePedIsIn(ped, true)
        if not IsPedInVehicle(ped, lastVehicle, true) then 
            if DoesEntityExist(lastVehicle) and not IsEntityDead(lastVehicle) then
                SetVehicleEngineOn(lastVehicle, false, false, true)
            end
        end
    end
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

searchableCar = nil
-- function to steal:
function StealingVehicle(plyPed)
    local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

    if aiming then
		local pedType = GetPedType(entity)
		local animalped = false
		if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
		    animalped = true
		end
		
		if animalped then return false end
        if not DoesEntityExist(entity) then return false end
        if not IsEntityAPed(entity) then return false end
		if not IsPedArmed(GetPlayerPed(-1), 6) then return false end
        if IsPedAPlayer(entity) then return false end
		if IsPedArmed(entity, 7) then return false end
        if IsEntityDead(entity) then return false end
        if IsPedDeadOrDying(entity, 1) then return false end

		if IsPedInAnyVehicle(entity, false) and GetEntitySpeed(veh) < 1.5 then
			if GetVehiclePedIsIn(entity) then
				local robCar = GetVehiclePedIsUsing(entity)

				if not DoesEntityExist(robCar) then return false end
				if GetDistanceBetweenCoords(GetEntityCoords(plyPed),GetEntityCoords(robCar),true) > 12.0 then return false end
				
				local _, taskSequence = OpenSequenceTask()
				TaskSetBlockingOfNonTemporaryEvents(0, true)
				TaskLeaveVehicle(0, robCar, 256)
				TaskHandsUp(0, (Config.HandsUpTime*1000), plyPed, -1)
				CloseSequenceTask(taskSequence)
				
				SetPedDropsWeaponsWhenDead(entity,false)
				SetPedFleeAttributes(entity, 0, 0)
				SetPedCombatAttributes(entity, 17, 1)
				TaskSetBlockingOfNonTemporaryEvents(entity, true)
				SetPedSeeingRange(entity, 0.0)
				SetPedHearingRange(entity, 0.0)
				SetPedAlertness(entity, 0)
				SetPedKeepTask(entity, true)
				
				TaskPerformSequence(entity, taskSequence)
				Citizen.Wait(1000)
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
				Citizen.Wait((Config.HandsUpTime*1000))
				RequestAnimDict("mp_common")
				while not HasAnimDictLoaded("mp_common") do
					Citizen.Wait(0)
				end			
				local keyDropChance = (math.random() * 100)

				if Config.PedGivesKeyChance > keyDropChance then
					TaskPlayAnim(entity, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0 )
					Citizen.Wait(1400)
					ClearPedTasks(entity)
					ShowNotifyESX(Lang['npc_give_keys'])
					TriggerServerEvent('t1ger_keys:stolenCarKeys', GetVehicleNumberPlateText(robCar))
					SetPedFleeAttributes(entity, 16, false)
				else
					ShowNotifyESX(Lang['npc_ran_away'])
				end
				TaskSmartFleePed(entity, plyPed, 40.0, 20000)
				TaskSetBlockingOfNonTemporaryEvents(entity, false)
				searchableCar = robCar
				Citizen.Wait(math.random(Config.AlertTime.min,Config.AlertTime.max))
				AlertPoliceFunction(robCar)
				TriggerEvent('esx-alerts:vehiclesteal')
			end
		end

        return true
    end

    return false
end

-- Car Search Command:
RegisterCommand('carsearch', function(source, args)
	SearchCarFunction()
end, false)

function SearchCarFunction()
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)
	for k,v in pairs(Config.SearchCar) do 
		if IsPedInAnyVehicle(plyPed, false) then
			if GetVehiclePedIsUsing(plyPed) == searchableCar and searchableCar ~= nil then
				searchableCar = GetVehiclePedIsUsing(plyPed)
				if GetPedInVehicleSeat(searchableCar, -1) == plyPed then
					RequestAnimDict(v.AnimDict)
					while not HasAnimDictLoaded(v.AnimDict) do
						Citizen.Wait(10)
					end
					FreezeEntityPosition(plyPed, true)
					TaskPlayAnim(plyPed, v.AnimDict, v.AnimName, 8.0, -8.0, -1, 49, 0, 0, 0)
					exports['progressBars']:startUI((v.HotwireTime * 1000), v.ProgressBarText)
					Citizen.Wait(v.HotwireTime * 1000)
					ClearPedTasks(plyPed)
					FreezeEntityPosition(plyPed, false)
					TriggerServerEvent("t1ger_keys:giveSearchReward")
					searchableCar = nil
				else
					ShowNotifyESX(Lang['not_in_drv_seat'])
				end
			else
				ShowNotifyESX(Lang['search_impossible'])
			end
		else
			ShowNotifyESX(Lang['not_in_a_veh'])
		end
	end
end
