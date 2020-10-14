ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('esx_pawnshop:buyFixkit')
AddEventHandler('esx_pawnshop:buyFixkit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 8000) then
		xPlayer.removeMoney(8000)
		
		xPlayer.addInventoryItem('fixkit', 1)
		
		notification("You bought one~g~fixkit")
	else
		notification("You dont have enough ~r~money")
	end		
end)


RegisterServerEvent('esx_pawnshop:buyBulletproof')
AddEventHandler('esx_pawnshop:buyBulletproof', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 3500) then
		xPlayer.removeMoney(3500)
		
		xPlayer.addInventoryItem('bulletproof', 1)
		
		notification("You bought one ~g~Vest")
	else
		notification("You dont have enough ~r~money")
	end		
end)


RegisterServerEvent('esx_pawnshop:buyDrill')
AddEventHandler('esx_pawnshop:buyDrill', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 4500) then
		xPlayer.removeMoney(4500)
		
		xPlayer.addInventoryItem('drill', 1)
		
		notification("You bought one ~g~Drill")
	else
		notification("You dont have enough ~r~money")
	end		
end)


RegisterServerEvent('esx_pawnshop:buyBlindfold')
AddEventHandler('esx_pawnshop:buyBlindfold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 162) then
		xPlayer.removeMoney(162)
		
		xPlayer.addInventoryItem('blindfold', 1)
		
		notification("You bought one ~g~Blindfold")
	else
		notification("You dont have enough ~r~money")
	end		
end)


RegisterServerEvent('esx_pawnshop:buyFishingrod')
AddEventHandler('esx_pawnshop:buyFishingrod', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 2590) then
		xPlayer.removeMoney(2590)
		
		xPlayer.addInventoryItem('fishing_rod', 1)
		
		notification("You bought one ~g~Fishingrod")
	else
		notification("You dont have enough ~r~money")
	end		
end)

RegisterServerEvent('esx_pawnshop:buyAntibiotika')
AddEventHandler('esx_pawnshop:buyAntibiotika', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 1230) then
		xPlayer.removeMoney(1230)
		
		xPlayer.addInventoryItem('anti', 1)
		
		notification("You bought one ~g~antibiotic")
	else
		notification("You dont have enough ~r~money")
	end		
end)

RegisterServerEvent('esx_pawnshop:buyPhone')
AddEventHandler('esx_pawnshop:buyPhone', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 3400) then
		xPlayer.removeMoney(3400)
		
		xPlayer.addInventoryItem('phone', 1)
		
		notification("You bought one ny ~g~Phone")
	else
		notification("You dont have enough ~r~money")
	end		
end)


-----Sälj
RegisterServerEvent('esx_pawnshop:sellring')
AddEventHandler('esx_pawnshop:sellring', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ring = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "ring" then
			ring = item.count
		end
	end
    
    if ring > 0 then
        xPlayer.removeInventoryItem('ring', 1)
        xPlayer.addMoney(150)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have a ring to sell!')
    end
end)

RegisterServerEvent('esx_pawnshop:sellrolex')
AddEventHandler('esx_pawnshop:sellrolex', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local rolex = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "rolex" then
			rolex = item.count
		end
	end
    
    if rolex > 0 then
        xPlayer.removeInventoryItem('rolex', 1)
        xPlayer.addMoney(300)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have a rolex to sell!')
    end
end)

RegisterServerEvent('esx_pawnshop:sellcamera')
AddEventHandler('esx_pawnshop:sellcamera', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local kamera = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "camera" then
			kamera = item.count
		end
	end
    
    if kamera > 0 then
        xPlayer.removeInventoryItem('camera', 1)
        xPlayer.addMoney(700)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have a camera to sell!')
    end
end)

RegisterServerEvent('esx_pawnshop:sellspeaker')
AddEventHandler('esx_pawnshop:sellspeaker', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local armband = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "speaker" then
			armband = item.count
		end
	end
    
    if armband > 0 then
        xPlayer.removeInventoryItem('speaker', 1)
        xPlayer.addMoney(500)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have a speaker to sell!')
    end
end)

RegisterServerEvent('esx_pawnshop:selllaptop')
AddEventHandler('esx_pawnshop:selllaptop', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local halsband = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "laptop" then
			halsband = item.count
		end
	end
    
    if halsband > 0 then
        xPlayer.removeInventoryItem('laptop', 1)
        xPlayer.addMoney(1000)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have a laptop to sell!')
    end
end)

RegisterServerEvent('esx_pawnshop:sellcoke_pooch')
AddEventHandler('esx_pawnshop:sellcoke_pooch', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local bottle = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "electronickit" then
			bottle = item.count
		end
	end
    
    if bottle > 0 then
        xPlayer.removeInventoryItem('electronickit', 1)
        xPlayer.addMoney(1500)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You dont have any kits to sell!')
    end
end)


function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end