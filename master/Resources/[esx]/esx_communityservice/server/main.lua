ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--TriggerEvent('es:addGroupCommand', 'comserv', 'admin', function(source, args, user)
ESX.RegisterCommand('comserv', 'admin', function(source, args, user)
	if args[1] and getIdentity(args[1]) ~= nil and tonumber(args[2]) then
		TriggerEvent('esx_communityservice:sendToCommunityService', tonumber(args[1]), tonumber(args[2]))
	else
		TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('give_player_community'), params = {{name = "id", help = _U('target_id')}, {name = "actions", help = _U('action_count_suggested')}}})
_U('system_msn')


--TriggerEvent('es:addGroupCommand', 'endcomserv', 'admin', function(source, args, user)
ESX.RegisterCommand('endcomserv', 'admin', function(source, args, user)
	if args[1] then
		if getIdentity(args[1]) ~= nil then
			TriggerEvent('esx_communityservice:endCommunityServiceCommand', tonumber(args[1]))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id')  } } )
		end
	else
		TriggerEvent('esx_communityservice:endCommunityServiceCommand', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('unjail_people'), params = {{name = "id", help = _U('target_id')}}})

RegisterCommand("comser", function(source, args, user)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if args[1] and getIdentity(args[1]) ~= nil and tonumber(args[2]) then
		if xPlayer.job.name == 'police' then
			TriggerEvent('esx_communityservice:sendToCommunityService', tonumber(args[1]), tonumber(args[2]))
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } )
	end
end)

RegisterCommand("comserend", function(source, args, user)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if args[1] and getIdentity(args[1]) ~= nil and tonumber(args[2]) then
		if xPlayer.job.name == 'police' then
			TriggerEvent('esx_communityservice:endCommunityServiceCommand', source)
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } )
	end
end)
RegisterServerEvent('esx_communityservice:endCommunityServiceCommand')
AddEventHandler('esx_communityservice:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_communityservice:finishCommunityService')
AddEventHandler('esx_communityservice:finishCommunityService', function()
	releaseFromCommunityService(source)
end)

RegisterServerEvent('esx_communityservice:completeService')
AddEventHandler('esx_communityservice:completeService', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		else
			print ("ESX_CommunityService :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)




RegisterServerEvent('esx_communityservice:extendService')
AddEventHandler('esx_communityservice:extendService', function()
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _source = source
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@extension_value'] = Config.ServiceExtensionOnEscape
			})
		else
			print ("ESX_CommunityService :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)






RegisterServerEvent('esx_communityservice:sendToCommunityService')
AddEventHandler('esx_communityservice:sendToCommunityService', function(target, actions_count)
	local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = xPlayer.identifier
	local pname = getIdentity(target)
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining) VALUES (@identifier, @actions_remaining)', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		end
	end)
	local time = actions_count
	local fal = { "JUDGE :".." ".. pname.firstname .. " " .. pname.lastname.." has been sentenced for " ..time.. " months of community service."}
	local messageFull = {
		template = '<div style="padding: 8px; margin: 8px; background-color: rgba(0, 50, 190, 0.8); border-radius: 25px;"><i class="far fa-building"style="font-size:15px"></i>{1}</font></i></b></div>',
		args = {jobName, fal, msg}
	}
	TriggerClientEvent('chat:addMessage', -1, messageFull)
	--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge').." ", _U('comserv_msg', pname.firstname .. " " .. pname.lastname, actions_count) }, color = { 147, 196, 109 } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_communityservice:inCommunityService', target, actions_count)
end)


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

RegisterServerEvent('esx_communityservice:checkIfSentenced')
AddEventHandler('esx_communityservice:checkIfSentenced', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil and result[1].actions_remaining > 0 then
			--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(_source), ESX.Math.Round(result[1].jail_time / 60)) }, color = { 147, 196, 109 } })
			TriggerClientEvent('esx_communityservice:inCommunityService', _source, tonumber(result[1].actions_remaining))
		end
	end)
end)







function releaseFromCommunityService(target)

	local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = xPlayer.identifier
	local pname = getIdentity(target)
	
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})

			local fal = { "JUDGE :".." ".. pname.firstname .. " " .. pname.lastname.." has finished Community Service."}
			local messageFull = {
				template = '<div style="padding: 8px; margin: 8px; background-color: rgba(0, 50, 190, 0.8); border-radius: 25px;"><i class="far fa-building"style="font-size:15px"></i>{1}</font></i></b></div>',
				args = {jobName, fal, msg}
			}
			TriggerClientEvent('chat:addMessage', -1, messageFull)
			--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge').." ", _U('comserv_finished',  pname.firstname .. " " .. pname.lastname) }, color = { 147, 196, 109 } })
		end
	end)

	TriggerClientEvent('esx_communityservice:finishCommunityService', target)
end
