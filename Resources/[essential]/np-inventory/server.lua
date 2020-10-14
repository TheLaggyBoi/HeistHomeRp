ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('server-inventory-request-identifier')
AddEventHandler('server-inventory-request-identifier', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local steam = xPlayer.identifier
    TriggerClientEvent('inventory-client-identifier', src, steam)
end)


RegisterCommand('evidence', function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local boxID = args[1]

    if xPlayer.job.name == 'police' and boxID and type(tonumber(boxID)) == 'number' then
        TriggerClientEvent("server-inventory-open", src, "1", "evidence-" .. boxID)
    end
end)

--[[RegisterCommand('InvItem', function(source, args, raw)
    local target = --ESX.GetPlayerFromId(tonumber(args[1]))
    local item = args[2]
    local amount = tonumber(args[3])

    if target ~= nil then
        if item ~= nil then
            if amount ~= nil then
                TriggerClientEvent('player:receiveItem', target, ""..item.."", amount)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Invalid Amount'})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Invalid Item'})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'This player is not online'})
    end
end)]]

TriggerEvent('es:addGroupCommand', 'giveitem', 'admin', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(args[1])
	local item    = args[2]
    local count   = (args[3] == nil and 1 or tonumber(args[3]))

	if count ~= nil then
		if xPlayer ~= nil then
            TriggerClientEvent('player:receiveItem', xPlayer.source, ""..item.."", count)
		else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Invalid Item'})
		end
	else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Invalid Amount'})
	end
end, function(source, args, user)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'You dont have permissions'})
end, {help='Give a item n dat'})

RegisterServerEvent('inentory:removecash')
AddEventHandler('inentory:removecash', function(source,cash)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeMoney(cash)
end)
