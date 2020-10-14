ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ RegisterServerEvent('kypo-addjoint')
AddEventHandler('kypo-addjoint', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('joint', 1)
end) ]]

ESX.RegisterUsableItem('cigarette', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cigarette', 1)

	TriggerClientEvent('esx_basicneeds:OnSmokeCigarette', source)
	--TriggerClientEvent('esx:showNotification', source, ('You used a cigarette'))
	TriggerClientEvent('esx_status:remove', source, 'stress', 45000)
end)
ESX.RegisterUsableItem('joint', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('joint', 1)

	TriggerClientEvent('kypo-drug-effect:onjoint', source)
	--TriggerClientEvent('esx:showNotification', source, ('You used a cigarette'))
	TriggerClientEvent('esx_status:remove', source, 'stress', 150000)
end)

--[[ RegisterServerEvent('addstress')
AddEventHandler('addstress', function()
	TriggerClientEvent('esx_status:add', source, 'stress', 25000)
end) ]]

--------------------------------------------------------------------------------------------
ESX.RegisterUsableItem('coke', function(source)
        
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('coke', 1)
	
	TriggerClientEvent('kypo-drug-effect:onCoke', source)
	end)
	
	-- Item use
	ESX.RegisterUsableItem('marijuana', function(source)
		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('marijuana', 1)
	TriggerClientEvent('kypo-drug-effect:onWeed', source)
	Citizen.Wait(5000)
	xPlayer.addInventoryItem('joint', 3)
	end)
	
	ESX.RegisterUsableItem('heroin', function(source)
		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('heroin', 1)
	
	TriggerClientEvent('kypo-drug-effect:onHeroin', source)
	end)
	
	ESX.RegisterUsableItem('lsd', function(source)
		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('lsd', 1)
	
	TriggerClientEvent('kypo-drug-effect:onLsd', source)
	end)
	
	ESX.RegisterUsableItem('meth', function(source)
		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('meth', 1)
	
	TriggerClientEvent('kypo-drug-effect:onMeth', source)
	TriggerClientEvent('esx_status:remove', source, 'stress', 50000)
	end)
	
	ESX.RegisterUsableItem('lsa', function(source)
		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('lsa', 1)
	
	TriggerClientEvent('kypo-drug-effect:onLsa', source)
	end)
	

	-----------------------------------------------------------------------------------------------------------------