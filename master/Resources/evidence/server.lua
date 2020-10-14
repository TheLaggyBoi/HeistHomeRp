ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('evidence:pooled')
AddEventHandler('evidence:pooled', function(PooledData)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  local identifier = xPlayer.identifier

  -- TriggerClientEvent("CacheEvidence", source)  
  TriggerClientEvent('evidence:pooled', source, PooledData)
end)

-- BURASI SIKINTI
-- RegisterServerEvent('evidence:bulletInformation')
-- AddEventHandler('evidence:bulletInformation', function(source, information)
--   local src = source
--   local xPlayer = ESX.GetPlayerFromId(src)
--   local identifier = xPlayer.identifier
  -- getIdentity(source, function()
  -- TriggerClientEvent('evidence:bulletInformation', source, information)
  -- end)
-- end)
-- SIKINTI SONA ERDİ XD

RegisterServerEvent('evidence:clear')
AddEventHandler('evidence:clear', function(Id)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  local identifier = xPlayer.identifier

  TriggerClientEvent('evidence:remove:done', source, Id)
end)

RegisterServerEvent('evidence:removal')
AddEventHandler('evidence:removal', function(closestID)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  local identifier = xPlayer.identifier

  TriggerClientEvent('evidence:clear:done', source)
end)


function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],
		}
	else
		return nil
	end
end