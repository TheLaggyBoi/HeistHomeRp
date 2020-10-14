ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
RegisterServerEvent('baseevents:enteringVehicle')
AddEventHandler('baseevents:enteringVehicle', function(currentVehicle, currentSeat, displayname, netId)
    TriggerClientEvent('disc-hud:EnteringVehicle', source, currentVehicle, currentSeat, displayname, netId)
end)

RegisterServerEvent('baseevents:enteringAborted')
AddEventHandler('baseevents:enteringAborted', function()
    TriggerClientEvent('disc-hud:EnteringVehicleAborted', source)
end)

RegisterServerEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, displayname)
    TriggerClientEvent('disc-hud:EnteredVehicle', source, currentVehicle, currentSeat, displayname)
end)

RegisterServerEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, displayname)
    TriggerClientEvent('disc-hud:LeftVehicle', source, currentVehicle, currentSeat, displayname)
end)

RegisterServerEvent('enzy:stress')
AddEventHandler('enzy:stress', function()
    TriggerClientEvent('esx_status:add', source, 'stress', 50000)
end)