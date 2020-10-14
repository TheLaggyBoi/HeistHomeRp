ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hiddenprocess = vector3(1389.32, 3604.86, 38.94) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords
local hiddenstart = vector3(1779.16, 3640.62, 34.51) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords

RegisterNetEvent('coke:updateTable')
AddEventHandler('coke:updateTable', function(bool)
    TriggerClientEvent('coke:syncTable', -1, bool)
end)

--[[ ESX.RegisterUsableItem('coke', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coke', 1)
	TriggerClientEvent('coke:onUse', source)
end) ]]

ESX.RegisterServerCallback('coke:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

ESX.RegisterServerCallback('coke:startcoords', function(source, cb)
    cb(hiddenstart)
end)

ESX.RegisterServerCallback('coke:pay', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = Config.price
	local check = xPlayer.getMoney()
	if check >= price then
		xPlayer.removeMoney(price)
    	cb(true)
    else
      if Config.useMythic then
    	 TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = _U'no_money'})
      end
    	cb(false)
    end
end)

RegisterServerEvent("coke:processed")
AddEventHandler("coke:processed", function(x,y,z)
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
  	local pick = Config.randBrick
	xPlayer.removeInventoryItem('cokebrick', Config.takeBrick)
	xPlayer.addInventoryItem('coke', pick)
end)

ESX.RegisterServerCallback('coke:process', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local check = xPlayer.getInventoryItem('cokebrick').count
	if check >= 1 then
    	cb(true)
    else
      if Config.useMythic then
    	 TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'error', text = _U'no_brick'})
      end
    	cb(false)
    end
end)

RegisterServerEvent("coke:GiveItem")
AddEventHandler("coke:GiveItem", function()
  	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local br = math.random( 4, 10 )  
    xPlayer.addInventoryItem('cokebrick', br)
end)
