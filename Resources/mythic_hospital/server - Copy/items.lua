ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)
	TriggerClientEvent('mythic_hospital:items:bandage', source)
end)

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)
	TriggerClientEvent('mythic_hospital:items:medikit', source)
end)
