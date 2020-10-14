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
end)

function anim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

RegisterCommand("test21", function()
	local ped = PlayerPedId()
	anim("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@")
	TaskPlayAnim(ped, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", 8.0, 2.0, -1, 120, 0, 0, 0, 0)
end)
