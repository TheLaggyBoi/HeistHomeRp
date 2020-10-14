ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('cuffkeys', function(source)
	TriggerClientEvent('handcuff:uncuffing', target)
	local xPlayer  = ESX.GetPlayerFromId(source)
	--xPlayer.removeInventoryItem('cuffkeys', 1)
end)


ESX.RegisterUsableItem('handcuffs', function(source)
	TriggerClientEvent('handcuffs:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('handcuffs:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('handcuffs', 1)
end)

RegisterServerEvent('handcuffs:sync')
AddEventHandler('handcuffs:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('handcuffs:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('handcuffs:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('handcuffs', 1)
end)

RegisterServerEvent('handcuffs:stop')
AddEventHandler('handcuffs:stop', function(targetSrc)
	TriggerClientEvent('handcuffs:cl_stop', targetSrc)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('handcuffs', 1)
end)
