--[[ COMMANDS ]]--

local ESX = true
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('cls', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('ooc', function(source, args, rawCommand) -- /ooc
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message ooc"><b>OOC {0} : </b> {1}</div>',
                args = { user, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message ooc"><b>OOC {0} : </b> {1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

--[[ RegisterCommand('twt', function(source, args, rawCommand) -- /twt 
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message twt"><b>Twitter User @{0} : </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message twt"><b>Twitter User @{0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)
 ]]
RegisterCommand('adv', function(source, args, rawCommand) -- /adv
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message advert"><b>Advertisment by {0} : </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message advert"><b>Advertisment by {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

RegisterCommand('darkweb', function(source, args, rawCommand) -- /web
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local user = 'GUEST'
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message dweb"><b>DarkWeb {0} : </b>{1}</div>',
                args = { user, msg }
            })
        else
            local user = 'GUEST'
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message dweb"><b>DarkWeb {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

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