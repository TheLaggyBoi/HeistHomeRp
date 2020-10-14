ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Start of Dark Net

--[[ TriggerEvent('esx_phone:registerNumber', 'darknet', _U('phone_darknet'), true, false, true, true)

function OnDarkNetItemChange(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local found    = false
	local darknet  = xPlayer.getInventoryItem('darknet')

	if darknet.count > 0 then
		found = true
	end

	if found then
		TriggerEvent('esx_phone:addSource', 'darknet', source)
	else
		TriggerEvent('esx_phone:removeSource', 'darknet', source)
	end
end

RegisterServerEvent('esx_phone:reload')
AddEventHandler('esx_phone:reload', function(phoneNumber)
AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local darknet  = xPlayer.getInventoryItem('darknet')

	if darknet.count > 0 then
		TriggerEvent('esx_phone:addSource', 'darknet', source)
	end
end)
end)

AddEventHandler('esx:playerDropped', function(source)
	TriggerEvent('esx_phone:removeSource', 'darknet', source)
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	if item.name == 'darknet' then
		OnDarkNetItemChange(source)
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'darknet' then
		OnDarkNetItemChange(source)
	end
end) ]]

-- End of Dark Net

ESX.RegisterUsableItem('parachute', function(source)
	TriggerClientEvent('useparachute', source)
end)
 
 
RegisterServerEvent('parachute:equip')
AddEventHandler('parachute:equip',function()
 
	local player = ESX.GetPlayerFromId(source)
	player.removeInventoryItem('parachute', 1)
 
end) 

-- Oxygen Mask
ESX.RegisterUsableItem('oxygen_mask', function(source)
	TriggerClientEvent('esx_extraitems:oxygen_mask', source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('oxygen_mask', 1)
end)

-- Bullet-Proof Vest
ESX.RegisterUsableItem('bulletproof', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:bulletproof', source)
	xPlayer.removeInventoryItem('bulletproof', 1)
end)

-- First Aid Kit
--[[ESX.RegisterUsableItem('firstaidkit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:firstaidkit', source)
	xPlayer.removeInventoryItem('firstaidkit', 1)
end)]]

-- Weapon Clip
ESX.RegisterUsableItem('clip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:clipcli', source)
	xPlayer.removeInventoryItem('clip', 1)
end)

-- Drill
--[[ESX.RegisterUsableItem('drill', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_extraitems:startDrill', source)
	xPlayer.removeInventoryItem('drill', 1)
end)]]
-- Lock Pick
--[[ESX.RegisterUsableItem('lockpick', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:lockpick', _source)
	xPlayer.removeInventoryItem('lockpick', 1)
end)]]--

-- Binoculars
ESX.RegisterUsableItem('binoculars', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:binoculars', source)
end)
--- handcuffs
ESX.RegisterUsableItem('handcuffs', function(source)
	TriggerClientEvent('extraitem:onhandcuffs', source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('handcuffs', 1)
end)

ESX.RegisterUsableItem('cuffkeys', function(source)
	TriggerClientEvent('extraitem:onuncuffs', source)
	local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.removeInventoryItem('cuffkeys', 1)
end)

RegisterServerEvent('extraitem:requestarrest')
AddEventHandler('extraitem:requestarrest', function(target, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('extraitem:getarrested', target, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('extraitem:doarrested', _source)
end)

RegisterServerEvent('extraitem:requestrelease')
AddEventHandler('extraitem:requestrelease', function(target, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('extraitem:getuncuffed', target, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('extraitem:douncuffing', _source)
end)