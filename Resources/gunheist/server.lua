ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('gunheist:getItemAmount', function(source, cb, item)
    --[[ 	print('gcphone:getItemAmount call item : ' .. item) ]]
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)

    if items == nil then
        cb(0)
    else
        cb(items.count)
    end
end)
ESX.RegisterServerCallback('gunheist:getOnlinePolice', function(source, cb)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)

RegisterServerEvent('gunheist:returnkeycard')
AddEventHandler('gunheist:returnkeycard', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    Citizen.Wait(2000)
    xPlayer.addInventoryItem('keycard', 1)

end)
    
ESX.RegisterUsableItem('satellitephone', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    local cops = 0
    for i=1, #xPlayers, 1 do
     local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    if cops >= 0 then
        TriggerClientEvent('gunheist:OnSatUse', source)
        Citizen.Wait(1000)
        xPlayer.removeInventoryItem('keycard', 1)
    else
        TriggerClientEvent('esx:showNotification', source,"Not Enough Cops")
    end
end)

--[[ RegisterServerEvent('gunheist:alert')
AddEventHandler('gunheist:alert', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    local cops = 0
    for i=1, #xPlayers, 1 do
     local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    if cops >= 0 then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message advert"><b>LSPD High Alert! Weapon Heist in Progress! </b></div>',
                    args = { fal, msg }
                })
                TriggerClientEvent('esx:showNotification', xPlayers[i],"Class 3 Weapon Heist in Progress")
                TriggerClientEvent('gunheist:killblip', xPlayers[i])
                TriggerClientEvent('gunheist:setblip', xPlayers[i])
            end
        end

        Citizen.Wait(100000)
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('gunheist:killblip', xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('esx:showNotification', xPlayers[i],"They Have The Supplies!")
            end
        end
    end

end) ]]

RegisterServerEvent('gunheist:code3')
AddEventHandler('gunheist:code3', function(targetCoords, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local messageFull
    fal = "Suspicious Activity at"
    msg = "LSPD HIGH Alert!"
	if emergency == 'code3' then
		--TriggerEvent('3dme:shareDisplay', "Calls 911")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(219, 35, 35, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> CODE 3 | {0}  {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('gunheist:setblip', -1, targetCoords, emergency)
    TriggerClientEvent('gunheist:EmergencySend', -1, messageFull)
end)

RegisterServerEvent('gunheist:pickedUpgun')
AddEventHandler('gunheist:pickedUpgun', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local num = math.random(1, 3)
    local weapon1 = 'WEAPON_APPISTOL'
    local weapon2 = 'WEAPON_ASSAULTSMG'
    local weapon3 = 'WEAPON_COMPACTRIFLE'

    if num == 3 then
        xPlayer.addInventoryItem('disc_ammo_pistol_large', 3)
        xPlayer.addInventoryItem(weapon1, 3)
    elseif num == 2 then
        xPlayer.addInventoryItem('disc_ammo_smg_large', 3)
        xPlayer.addInventoryItem(weapon2, 1)
    elseif num == 1 then
        xPlayer.addInventoryItem('disc_ammo_rifle_large', 3)
        xPlayer.addInventoryItem(weapon3, 1)
    end

end)
