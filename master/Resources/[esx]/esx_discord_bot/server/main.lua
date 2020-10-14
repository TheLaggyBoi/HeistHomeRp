ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

settings = {
	LogKills = true, -- Log when a player kill an other player.
	LogEnterPoliceVehicle = true, -- Log when an player enter in a police vehicle.
	LogEnterBlackListedVehicle = true, -- Log when a player enter in a blacklisted vehicle.
	LogPedJacking = true, -- Log when a player is jacking a car
	LogChatServer = true, -- Log when a player is talking in the chat , /command works too.
	LogLoginServer = true, -- Log when a player is connecting/disconnecting to the server.
	LogItemTransfer = true, -- Log when a player is giving an item.
	LogWeaponTransfer = true, -- Log when a player is giving a weapon.
	LogMoneyTransfer = true, -- Log when a player is giving money
	LogMoneyBankTransfert = true, -- Log when a player is giving money from bankaccount

}

--Send the message to your discord server
function sendToDiscord (name,message,color)
  local DiscordWebHook = Config.webhook
  -- Modify here your discordWebHook username = name, content = message,embeds = embeds

local embeds = {
    {
        ["title"]=message,
        ["type"]="rich",
        ["color"] =color,
        ["footer"]=  {
            ["text"]= "ESX-discord_bot_alert",
       },
    }
}

  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end



-- Send the first notification
sendToDiscord(_U('server'),_U('server_start'),Config.green)

-- Event when a player is writing
AddEventHandler('chatMessage', function(author, color, message)
  if(settings.LogChatServer)then
      local player = ESX.GetPlayerFromId(author)
     sendToDiscord(_U('server_chat'), player.name .." : "..message,Config.grey)
  end
end)


-- Event when a player is connecting
RegisterServerEvent("esx:playerconnected")
AddEventHandler('esx:playerconnected', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local id = xPlayer.identifier
  if(settings.LogLoginServer)then
    sendToDiscord(_U('server_connecting'), id .." ".. GetPlayerName(source) .." ".. _('user_connecting'),Config.grey)
  end
end)

-- Event when a player is disconnecting
AddEventHandler('playerDropped', function(reason)
  local xPlayer = ESX.GetPlayerFromId(source)
  local id = xPlayer.identifier
  if(settings.LogLoginServer)then
    sendToDiscord(_U('server_disconnecting'),  id .." ".. GetPlayerName(source) .." ".. _('user_disconnecting') .. "("..reason..")",Config.grey)
  end
end)

--[[ ESX.RegisterServerCallback('GetCharacterNameServer', function(source, cb, target) -- GR10
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, inventory FROM users WHERE identifier = @identifier", {
      ['@identifier'] = xPlayer.identifier
  })

  local firstname = result[1].firstname
  local lastname  = result[1].lastname
  local inventory = result[1].inventory

  cb(''.. firstname .. ' ' .. lastname .. ' ' .. inventory ..'')
end)

RegisterCommand("invi", function(source)

  sendToDiscord("Player Inventory ",GetPlayerName(source) .." ".."("..inventory..")",Config.grey)
end)
 ]]
-- Add event when a player give an item
--  TriggerEvent("esx:giveitemalert",sourceXPlayer.name,targetXPlayer.name,ESX.Items[itemName].label,itemCount) -> ESX_extended
RegisterServerEvent("esx:giveitemalert")
AddEventHandler("esx:giveitemalert", function(name,nametarget,itemname,amount)
   if(settings.LogItemTransfer)then
    sendToDiscord(_U('server_item_transfer'),name.._('user_gives_to')..nametarget.." "..amount .." "..itemname,Config.orange)
   end
  if itemName == 'money' then
    local playerName = GetPlayerName(name)
    local playerNametarget = GetPlayerName(nametarget)
    local DiscordWebHook = "https://discordapp.com/api/webhooks/759475033914736641/-WHeAqzqNh-ZyU46azQd3YQVMhhcCmg0AzQEyyqP_sIrFskKBwJjCencvjWa2OEOjntx"
     msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nHandedOverTo :"..playerNametarget.."``````xl\nMoneyAmount : "..amount.."```"
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
  end

end)

-- Add event when a player give money
-- TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount) -> ESX_extended
RegisterServerEvent("esx:givemoneyalert")
AddEventHandler("esx:givemoneyalert", function(name,nametarget,amount)
  if(settings.LogMoneyTransfer)then
    sendToDiscord(_U('server_money_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..amount .." dollars",Config.orange)
  end
  local playerName = GetPlayerName(name)
  local playerNametarget = GetPlayerName(nametarget)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/759475033914736641/-WHeAqzqNh-ZyU46azQd3YQVMhhcCmg0AzQEyyqP_sIrFskKBwJjCencvjWa2OEOjntx"
   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nHandedOverTo :"..playerNametarget.."``````xl\nMoneyAmount : "..amount.." dollars```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

-- Add event when a player give money
-- TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount) -> ESX_extended
RegisterServerEvent("esx:givemoneybankalert")
AddEventHandler("esx:givemoneybankalert", function(name,nametarget,amount)
  if(settings.LogMoneyBankTransfert)then
   sendToDiscord(_U('server_moneybank_transfer'),name.." ".. _('user_gives_to') .." "..nametarget.." "..amount .." dollars",Config.orange)
  end

end)


-- Add event when a player give weapon
--  TriggerEvent("esx:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel) -> ESX_extended
RegisterServerEvent("esx:giveweaponalert")
AddEventHandler("esx:giveweaponalert", function(name,nametarget,weaponlabel)
  if(settings.LogWeaponTransfer)then
    sendToDiscord(_U('server_weapon_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..weaponlabel,Config.orange)
  end

end)

-- Add event when a player is washing money
--  TriggerEvent("esx:washingmoneyalert",xPlayer.name,amount) -> ESX_society
RegisterServerEvent("esx:washingmoneyalert")
AddEventHandler("esx:washingmoneyalert", function(name,amount)
  sendToDiscord(_U('server_washingmoney'),name.." ".._('user_washingmoney').." ".. amount .." dollars",Config.orange)

end)

-- Event when a player is in a blacklisted vehicle
RegisterServerEvent("esx:enterblacklistedcar")
AddEventHandler("esx:enterblacklistedcar", function(model)
   local xPlayer = ESX.GetPlayerFromId(source)
   sendToDiscord(_U('server_blacklistedvehicle'),xPlayer.name.." ".._('user_entered_in').." ".. model ,Config.red)

end)


-- Event when a player (not policeman) is in a police vehicle
RegisterServerEvent("esx:enterpolicecar")
AddEventHandler("esx:enterpolicecar", function(model)
 	 local xPlayer = ESX.GetPlayerFromId(source)
 	 sendToDiscord(_U('server_policecar'),xPlayer.name.." ".._('user_entered_in').." ".. model , Config.blue)

end)


-- Event when a player is jacking a car
RegisterServerEvent("esx:jackingcar")
AddEventHandler("esx:jackingcar", function(model)
   local xPlayer = ESX.GetPlayerFromId(source)
   sendToDiscord(_U('server_carjacking'),xPlayer.name.." ".._('user_carjacking').." ".. model,Config.purple)

end)

RegisterServerEvent("esx:chatlog")
AddEventHandler("esx:chatlog", function(args, xPlayer)
local playerName = GetPlayerName(xPlayer.source)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/761661946084327465/UUYhUeG_vACAGQW8ZgabW2WuD8p7aN5OhhSinx9eilkV7bWLomK8JTdTOnBa_3UKYJ-P"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nChatlog : "..args.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:invilog")
AddEventHandler("esx:invilog", function(data, xPlayer)
local playerName = GetPlayerName(xPlayer.source)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/759460878705229857/mGqpzdtAgK17pxG1qi4Rs_5CHbw9cfEBvu44mFiAepRvUALi2_wKg3cZlWo7Vio9Qw0m"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nInventory : "..data.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:revivelog")
AddEventHandler("esx:revivelog", function(target, xPlayer)
local playerName = GetPlayerName(xPlayer.source)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/763112108757876746/yj-JVQY6X8IofeixvZJ4wR2yweUC_WY67AYaRvrMf4s25BIi4HmMthmgQsMpSJAyiCXU"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nRevived : "..target.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:money")
AddEventHandler("esx:money", function(data2, xPlayer)

local playerName = GetPlayerName(xPlayer.source)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/759466690261680218/Ug0MBXXoy9Dzg_JSd6N_Sd2ZUmcj0drXvbQuOVknPjblFkPgb1rAIikxY_9Tzix7ebc4"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nDATA : "..data2.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:trunk")
AddEventHandler("esx:trunk", function(p, xPlayer, data)
local playerName = GetPlayerName(xPlayer.source)
  local DiscordWebHook = "https://discordapp.com/api/webhooks/759467488554516481/T12sObNUZOKcKBMbWjn6sKBQb_2MuKVw28l1vv-wHXC2zKf7_IGOh1uQjqHPFyuJRqlC"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nPutInTrunk : "..data.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:trunkout")
AddEventHandler("esx:trunkout", function(p, xPlayer, data3)
local playerName = GetPlayerName(xPlayer.source)

  local DiscordWebHook = "https://discordapp.com/api/webhooks/759469063553810512/VYKs6hztc5pC4QHXU8jrM_TXTEx4aXQwhxeERwE9B6azotAkQnCDmaZCcaFbwsa-ha3Y"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nTookFromTrunk : "..data3.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:motelin")
AddEventHandler("esx:motelin", function(storage, xPlayer, put)
local playerName = GetPlayerName(xPlayer.source)

  local DiscordWebHook = "https://discordapp.com/api/webhooks/763106008104304661/KYfCnQbJnp5XNWqX2g4qmj6SAzsrN5N6hx_bhSS_lKE0zzTPUxhdfVhwZYlarrVKjsFJ"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nStorageId :"..json.encode(p).."``````xl\nPutInMotel : "..put.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)


RegisterServerEvent("esx:motelout")
AddEventHandler("esx:motelout", function(storage, xPlayer, out)
local playerName = GetPlayerName(xPlayer.source)

  local DiscordWebHook = "https://discordapp.com/api/webhooks/763106553308905544/eVRqOkYCGGmmROT9PLXIUxMzOsEoZI6qOdbEMrT9eloK181KzSfv9goVSaMKZPkiqblK"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nStorageId :"..json.encode(p).."``````xl\nTookFromMotel : "..out.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:transfervehicle")
AddEventHandler("esx:transfervehicle", function(p, xPlayer, target)
local playerName = GetPlayerName(xPlayer.source)
local targetplayer = GetPlayerName(target)

  local DiscordWebHook = "https://discordapp.com/api/webhooks/759471698461589514/D3HXYH8jhUjtO3gOKY08BkoLHNtcL5Hm-0m8_UaECAAApYsqGFUlW7_c9KR0ITHtiyTS"
  msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nTransferedTo : "..targetplayer.."```"
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
end)
-- Event when a player is killing an other one

RegisterServerEvent('esx:killerlog')
AddEventHandler('esx:killerlog', function(t,killer, kilerT) -- t : 0 = NPC, 1 = player
  local xPlayer = ESX.GetPlayerFromId(source)
  if(t == 1) then
     local xPlayer = ESX.GetPlayerFromId(source)
     local xPlayerKiller = ESX.GetPlayerFromId(killer)

     if(xPlayerKiller.name ~= nil and xPlayer.name ~= nil)then

       if(kilerT.killerinveh) then
         local model = kilerT.killervehname

            sendToDiscord(_U('server_kill'), xPlayer.name .." ".._('user_kill').." "..xPlayerKiller.name.." ".._('with').." "..model,Config.red)



       else
            sendToDiscord(_U('server_kill'), xPlayer.name .." ".._('user_kill').." "..xPlayerKiller.name,Config.red)



       end
    end
  else
     sendToDiscord(_U('server_kill'), xPlayer.name .." ".. _('user_kill_environnement'),Config.red)
  end

end)
