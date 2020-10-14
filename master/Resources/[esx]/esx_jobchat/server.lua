ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	--local result = MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier})
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end
 ]]
function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end
--[[ 
function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)

		local identity = result[1]
		if result[1].firstname ~= nil then
			return {
				identifier	= identity[1].identifier,
				firstname	= identity[1].firstname,
				lastname	= identity[1].lastname,
				dateofbirth	= identity[1].dateofbirth,
				sex			= identity[1].sex,
				height		= identity[1].height
			}
		end
	end)
end
 ]]
function GetRealPlayerName(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		return xPlayer.getName()
	else
		return GetPlayerName(playerId)
	end
end

RegisterServerEvent('esx_jobChat:chat')
AddEventHandler('esx_jobChat:chat', function(job, msg)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local pName= getIdentity(source)
	fal = pName.firstname .. " " .. pName.lastname
	jobName = string.upper(job)
	local messageFull = {
        template = '<div style="padding: 8px; margin: 8px; background-color: rgba(0, 153, 51, 0.9); border-radius: 25px;"><i class="far fa-building"style="font-size:15px"></i> [{0}] {1} : {2}</font></i></b></div>',
        args = {jobName, fal, msg}
    }
    TriggerClientEvent('esx_jobChat:Send', -1, messageFull, job)
end)

RegisterServerEvent('esx_jobChat:911')
AddEventHandler('esx_jobChat:911', function(targetCoords, msg, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local pName= getIdentity(source)
	local messageFull
	fal = pName.firstname .. " " .. pName.lastname
	if emergency == '911' then
		--TriggerEvent('3dme:shareDisplay', "Calls 911")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(219, 35, 35, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> [911] | Caller : {0} | Location : {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	else
		TriggerEvent('3dme:shareDisplay', "Calls 311")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(199, 0, 189, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> [311] | Caller : {0} | Location : {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('esx_jobChat:911Marker', -1, targetCoords, emergency)
    TriggerClientEvent('esx_jobChat:EmergencySend', -1, messageFull)
end)