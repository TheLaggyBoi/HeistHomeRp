ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('dispatch:svNotify')
AddEventHandler('dispatch:svNotify', function(data)
    TriggerClientEvent('dispatch:clNotify',-1,data)
end)

RegisterServerEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords)

 --	TriggerClientEvent('esx_outlawalert:outlawNotify', -1, _U('gunshot', playerGender, streetName))
	TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
end)

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords)
	--TriggerClientEvent('esx_outlawalert:outlawNotify', -1, _U('carjack', playerGender, vehicleLabel, streetName))
	TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
end)