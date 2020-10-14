ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('HHCore:syncCarLights')
AddEventHandler('HHCore:syncCarLights', function(status)
	TriggerClientEvent('HHCore:syncCarLights', -1, source, status)
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	-- print("got to srv cmg2_animations:sync")
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	-- print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)


RegisterServerEvent("spushin")
AddEventHandler("spushin", function(targetSrc)
	TriggerClientEvent('pushin', targetSrc)
end)	

RegisterServerEvent("bpushin")
AddEventHandler("bpushin", function(targetSrc)
	TriggerClientEvent('liedown', targetSrc)
end)

RegisterServerEvent("iscarriedd")
AddEventHandler("iscarriedd", function(targetSrc,status)
	TriggerClientEvent('iscarried', targetSrc,status)
end)

RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_kekke_tackle:getTackled', targetPlayer.source, source)
	TriggerClientEvent('esx_kekke_tackle:playTackle', source)
end)

RegisterServerEvent("heli:spotlight")
AddEventHandler(
	"heli:spotlight",
	function(state)
		local serverID = source
		TriggerClientEvent("heli:spotlight", -1, serverID, state)
	end
)