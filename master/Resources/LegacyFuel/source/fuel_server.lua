ESX = nil

if Config.UseESX then
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			xPlayer.removeMoney(amount)
		end
	end)
end

RegisterServerEvent('fuel:jerrycan')
AddEventHandler('fuel:jerrycan', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem("WEAPON_PETROLCAN",1)
end)