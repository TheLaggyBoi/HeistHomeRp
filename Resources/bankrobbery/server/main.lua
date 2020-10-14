ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local robberyBusy = false
local timeOut = false
local webhook = 'https://discordapp.com/api/webhooks/726583809482555423/rEMxFeO8DrHA2i3ooCJ2au5J3MrAn0bii083Xtsb6O97yP1kZD8MR7FqBOo9wewo99M4'

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("lh-bankrobbery:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

ESX.RegisterServerCallback('bank:getOnlinePolice', function(source, cb)
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

RegisterServerEvent('lh-bankrobbery:server:setBankState')
AddEventHandler('lh-bankrobbery:server:setBankState', function(bankId, state)
    if bankId == "pacific" then
        if not robberyBusy then
            Config.BigBanks["pacific"]["isOpened"] = state
            TriggerClientEvent('lh-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('lh-bankrobbery:server:setTimeout')
        end
    else
        if not robberyBusy then
            Config.SmallBanks[bankId]["isOpened"] = state
            TriggerClientEvent('lh-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('lh-banking:server:SetBankClosed', bankId, true)
            TriggerEvent('lh-bankrobbery:server:SetSmallbankTimeout', bankId)
        end
    end
    robberyBusy = true
end)

RegisterServerEvent('bank:small')
AddEventHandler('bank:small', function(targetCoords, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local messageFull
    fal = "Bank Alarms Triggered!"
    msg = "LSPD HIGH Alert!"
	if emergency == 'smallbank' then
		--TriggerEvent('3dme:shareDisplay', "Calls 911")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(159, 35, 35, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> BANK ROBBERY IN PROGRESS | {0}  {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('bank:smallblip', -1, targetCoords, emergency)
    TriggerClientEvent('bank:EmergencySend', -1, messageFull)
end)

RegisterServerEvent('bank:big')
AddEventHandler('bank:big', function(targetCoords, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local messageFull
    fal = "Bank Alarms Triggered!"
    msg = "LSPD HIGH Alert!"
	if emergency == 'bigbank' then
		--TriggerEvent('3dme:shareDisplay', "Calls 911")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(225, 35, 35, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> BANK ROBBERY IN PROGRESS | {0}  {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('bank:smallblip', -1, targetCoords, emergency)
    TriggerClientEvent('bank:EmergencySend', -1, messageFull)
end)

RegisterServerEvent('lh-bankrobbery:server:setLockerState')
AddEventHandler('lh-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end

    TriggerClientEvent('lh-bankrobbery:client:setLockerState', -1, bankId, lockerId, state, bool)
end)

RegisterServerEvent('lh-bankrobbery:server:recieveItem')
AddEventHandler('lh-bankrobbery:server:recieveItem', function(type)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local amount = math.random(10000, 15000)
    xPlayer.addAccountMoney('black_money', amount)
    --TriggerEvent("robbery:logs", GetPlayerName(src) .. ' Recieved ' .. k .. ' (' .. amount .. ')', src)

end)

ESX.RegisterServerCallback('lh-bankrobbery:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

ESX.RegisterServerCallback('lh-bankrobbery:server:GetConfig', function(source, cb)
    cb(Config)
end)

ESX.RegisterServerCallback('lh-bankrobbery:server:HasItem', function(source, cb, item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    cb(xPlayer.getInventoryItem(item)["count"] >= (count or 1))
end)

RegisterServerEvent('lh-bankrobbery:server:setTimeout')
AddEventHandler('lh-bankrobbery:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false

                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
                end


                TriggerClientEvent('lh-bankrobbery:client:ClearTimeoutDoors', -1)
                Config.BigBanks["pacific"]["isOpened"] = false
            end)
        end
    end
end)

RegisterServerEvent('lh-bankrobbery:server:SetSmallbankTimeout')
AddEventHandler('lh-bankrobbery:server:SetSmallbankTimeout', function(BankId)
    if not robberyBusy then
        SetTimeout(30 * (60 * 1000), function()
            Config.SmallBanks[BankId]["isOpened"] = false
            for k, v in pairs(Config.SmallBanks[BankId]["lockers"]) do
                Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
                Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
            end
            timeOut = false
            robberyBusy = false
            TriggerClientEvent('lh-bankrobbery:client:ResetFleecaLockers', -1, BankId)
            TriggerEvent('lh-banking:server:SetBankClosed', BankId, false)
        end)
    end
end)

RegisterServerEvent('lh-bankrobbery:server:SetStationStatus')
AddEventHandler('lh-bankrobbery:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("lh-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("lh-bankrobbery:client:disableAllBankSecurity", -1)
    else
        CheckStationHits()
    end
end)

RegisterServerEvent('robbery:StartServerFire')
AddEventHandler('robbery:StartServerFire', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("robbery:StartFire", -1, coords, maxChildren, isGasFire)


end)

RegisterServerEvent('robbery:StopFires')
AddEventHandler('robbery:StopFires', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("robbery:StopFires", -1)
end)

RegisterServerEvent('lh-bankrobbery:Server:RemoveItem')
AddEventHandler('lh-bankrobbery:Server:RemoveItem', function(item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.removeInventoryItem(item, count)
end)

RegisterServerEvent('lh-bankrobbery:Server:RemoveItemthermite')
AddEventHandler('lh-bankrobbery:Server:RemoveItemthermite', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.removeInventoryItem('thermite', 1)
end)


function CheckStationHits()
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 18, false)
        TriggerClientEvent("police:client:SetCamera", -1, 7, false)
    end
    if Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 8, false)
        TriggerClientEvent("police:client:SetCamera", -1, 5, false)
        TriggerClientEvent("police:client:SetCamera", -1, 6, false)
    end
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 2, false)
        TriggerClientEvent("police:client:SetCamera", -1, 3, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[8].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 9, false)
        TriggerClientEvent("police:client:SetCamera", -1, 10, false)
    end
    if Config.PowerStations[9].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 11, false)
        TriggerClientEvent("police:client:SetCamera", -1, 12, false)
        TriggerClientEvent("police:client:SetCamera", -1, 13, false)
    end
    if Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 14, false)
        TriggerClientEvent("police:client:SetCamera", -1, 17, false)
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 15, false)
        TriggerClientEvent("police:client:SetCamera", -1, 16, false)
    end
    if Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 20, false)
    end
    if Config.PowerStations[11].hit and Config.PowerStations[1].hit and Config.PowerStations[2].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 21, false)
        TriggerClientEvent("lh-bankrobbery:client:BankSecurity", 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 22, false)
        TriggerClientEvent("lh-bankrobbery:client:BankSecurity", 2, false)
    end
    if Config.PowerStations[8].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 23, false)
        TriggerClientEvent("lh-bankrobbery:client:BankSecurity", 3, false)
    end
    if Config.PowerStations[12].hit and Config.PowerStations[13].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 24, false)
        TriggerClientEvent("lh-bankrobbery:client:BankSecurity", 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 25, false)
        TriggerClientEvent("lh-bankrobbery:client:BankSecurity", 5, false)
    end
end

function AllStationsHit()
    local retval = true
    for k, v in pairs(Config.PowerStations) do
        if not Config.PowerStations[k].hit then
            retval = false
        end
    end
    return retval
end

ESX.RegisterUsableItem("thermite", function(source)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("robbery:UseThermite", source)
end)

ESX.RegisterUsableItem("security_card_01", function(source)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("lh-bankrobbery:UseBankcardA", source)
end)

ESX.RegisterUsableItem("electronickit", function(source)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("electronickit:UseElectronickit", source)
end)


RegisterServerEvent('robbery:logs')
AddEventHandler('robbery:logs', function(data, src)
    local webhook = 'https://discordapp.com/api/webhooks/763676461541490728/l1eTmPqi18P1WGWkmUp55FqSt2ueHyg6nQ7vQb2czcmsL6Q77sHtyUwAtr7A-vL7icb0'
    local id = src or source
    local time = os.date("%Y/%m/%d %X")
    local msg = 'Server name: '.. GetConvar('sv_hostname', 'Invaild Server Name') .. '\n Player IP: '.. GetPlayerEndpoint(id) .. '\n Player Steam: '.. GetPlayerIdentifier(id)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Robbery logs", content = "```css\n[" .. time .. "] " .. data .. "\n " .. msg .. "```"}), {['Content-Type'] = 'application/json'})
end)