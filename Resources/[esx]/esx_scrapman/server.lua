ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('smerfikcraft:scrapmetaliarzzbier') 
AddEventHandler('smerfikcraft:scrapmetaliarzzbier', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jabka = xPlayer.getInventoryItem('scrapmetal').count
    if jabka < 40 then

            TriggerClientEvent('smerfik:zamrozcrft22', _source)


            TriggerClientEvent('zacznijtekst2', _source)

            TriggerClientEvent('smerfik:craftanimacja22', _source)
            TriggerClientEvent('smerfik:tekstjab2', _source)
            Citizen.Wait(20000)

        local ilosc = math.random(2, 10)
        local chance = math.random(1,5)
        if chance == 1 then
            xPlayer.addInventoryItem('scrapmetal', ilosc)
        elseif chance == 2 then
            xPlayer.addInventoryItem('steel', ilosc)
        elseif chance == 3 then
            xPlayer.addInventoryItem('plastic', ilosc)
        elseif chance == 4 then
            xPlayer.addInventoryItem('glass', ilosc)
        else
            xPlayer.addInventoryItem('rubber', ilosc)
        end
        TriggerClientEvent('smerfik:odmrozcrft22', _source)

        TriggerClientEvent('esx:showNotification', _source, 'You collected ~y~'.. ilosc .. ' scrap')
    else
        TriggerClientEvent('smerfik:zdejmijznaczek2', _source)
        TriggerClientEvent('esx:showNotification', _source, '~y~ You have no room for more scrap!')   
    end
end)


RegisterServerEvent('smerfik:pobierzjablka2') 
AddEventHandler('smerfik:pobierzjablka2', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeMoney(3000)

end)
RegisterServerEvent('smerfik:pobierzjablka22') 
AddEventHandler('smerfik:pobierzjablka22', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(3000)
    TriggerClientEvent('esx:deleteVehicle', source)

end)
RegisterServerEvent('smerfikcraft:skup2') 
AddEventHandler('smerfikcraft:skup2', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jabka = xPlayer.getInventoryItem('scrapmetal').count
    if jabka >= 1 then 

        local cena = 40
        xPlayer.removeInventoryItem('scrapmetal', ESX.Math.Round(jabka / 4))
        TriggerClientEvent('sprzedawanie:jablekanim2', _source)
        Citizen.Wait(3000)
        xPlayer.removeInventoryItem('scrapmetal', ESX.Math.Round(jabka / 4))
        TriggerClientEvent('sprzedawanie:jablekanim2', _source)
        Citizen.Wait(3000)
        xPlayer.removeInventoryItem('scrapmetal', ESX.Math.Round(jabka / 4))
        TriggerClientEvent('sprzedawanie:jablekanim2', _source)
        Citizen.Wait(3000)
        local jabka2 = xPlayer.getInventoryItem('scrapmetal').count
        xPlayer.removeInventoryItem('scrapmetal', jabka2)
        TriggerClientEvent('sprzedawanie:jablekanim2', _source)
        Citizen.Wait(3000)
        xPlayer.addMoney(jabka * cena)
        TriggerClientEvent('odlacz:propa', _source)
        TriggerClientEvent('esx:showHelpNotification', _source, 'You sold ~y~' .. ESX.Math.Round(jabka) ..' ~w~scrap')
    else
        TriggerClientEvent('esx:showHelpNotification', _source, '~y~You have no scrap metal')
    end
end)
