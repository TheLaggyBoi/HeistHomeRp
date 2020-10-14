local ESX	 = nil
local open = false


-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		SendNUIMessage({
	action = "close"
})
	end
end)


RegisterCommand("close", function(source)
SetNuiFocus(false, false)
open = false
SendNUIMessage({
	action = "close"
})

end)


RegisterCommand("spawnmenu", function(source)
SetNuiFocus(true, true)
open = true
SendNUIMessage({
	action = "open"
})
end)

RegisterNUICallback('parken', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "close"
	})
	cb("ok")
	open = false
	SetEntityCoords(GetPlayerPed(-1), 215.02, -904.28, 30.69)
end)

RegisterNUICallback('sandy', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "close"
	})
	cb("ok")
	open = false
	SetEntityCoords(GetPlayerPed(-1), 1857.19, 3680.05, 33.79)
end)


RegisterNUICallback('hostpital', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "close"
	})
	cb("ok")
	open = false
	SetEntityCoords(GetPlayerPed(-1), 298.47, -582.46, 42.26)
end)

RegisterNUICallback('motel', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "close"
	})
	cb("ok")
	open = false
	SetEntityCoords(GetPlayerPed(-1), -351.59, 34.38, 47.86)
end)