
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

--[[ RegisterServerEvent('delivery:checkjob')
AddEventHandler('delivery:checkjob', function(source)
    local source = src
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.job.name == "delivery" then
      TriggerClientEvent('yesdelivery', src)
    else
      TriggerClientEvent('nodelivery', src)
    end
end) ]]


RegisterServerEvent('delivery:success')
AddEventHandler('delivery:success', function(price)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local total = price
  xPlayer.addMoney(total)
end)

RegisterServerEvent('delivery:change')
AddEventHandler('delivery:change', function(price)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local total = price
  xPlayer.removeAccountMoney('bank', total)
end)
