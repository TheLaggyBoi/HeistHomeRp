local vehiclesKHM = {}

Citizen.CreateThread(function()
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "vehicles.json")
    vehiclesKHM = json.decode(loadFile)

end)


RegisterServerEvent("ev-hud:server:vehiclesKHM")
AddEventHandler("ev-hud:server:vehiclesKHM", function(plate,kmh)
    if plate and kmh and type(vehiclesKHM) == 'table' then
        vehiclesKHM[plate] = kmh
        SaveResourceFile(GetCurrentResourceName(), "vehicles.json", json.encode(vehiclesKHM), -1)
        TriggerClientEvent("ev-hud:client:vehiclesKHM", -1, plate,kmh)
    end
end)

RegisterServerEvent("ev-hud:server:requestTable")
AddEventHandler("ev-hud:server:requestTable", function()
    TriggerClientEvent("ev-hud:client:vehiclesKHMTable", source, vehiclesKHM)
end)