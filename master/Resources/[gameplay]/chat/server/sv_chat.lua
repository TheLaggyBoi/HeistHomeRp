RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:server:ClearChat')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
       TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
    end

    print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)
    --TriggerEvent("esx:chatlog", command, source)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- command suggestions for clients

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end
--Player Joined
AddEventHandler('chat:init', function()

    --TriggerClientEvent('chat:addMessage', -1, { template = '<div class="chat-message join"><b>Town {0} : </b> {1}</div>', args = { GetPlayerName(source), "Caught a bus in" } })

   -- TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
end)
--Player Left
AddEventHandler('playerDropped', function(reason)

    --TriggerClientEvent('chat:addMessage', -1, { template = '<div class="chat-message server"><b>Town {0} : </b> {1}</div>', args = { GetPlayerName(source), "Caught a bus out" } })

      --  TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

--Uncomment linees 73-75 or 77-70 to add /say into the chat rather than on person. (Must comment it out in cl_chat.lua)

--[[
    RegisterCommand('say', function(source, args, rawCommand)
   TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

    RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chat:addMessage', -1, {=template = '<div class="chat-message server"><b>Console {0} : </b> {1}</div>', args = { (source == 1) and 'Announcement' or GetPlayerName(source), rawCommand:sub(5) }})
end)
]]

AddEventHandler('chat:init', function()
    --refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
