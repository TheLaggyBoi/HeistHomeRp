ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)
	TriggerClientEvent('mythic_hospital:items:bandage', source)
end)

ESX.RegisterUsableItem('pills', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pills', 1)
	TriggerClientEvent('mythic_hospital:items:pills', source)
end)

ESX.RegisterUsableItem('morphine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)
	TriggerClientEvent('mythic_hospital:items:morphine', source)
end)

ESX.RegisterUsableItem('vicodin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vicodin', 1)
	TriggerClientEvent('mythic_hospital:items:vicodin', source)
end)

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)
	TriggerClientEvent('mythic_hospital:items:medikit', source)
end)
