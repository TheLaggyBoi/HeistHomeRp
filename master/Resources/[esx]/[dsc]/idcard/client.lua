--local open = false

local ESX  = nil
 
-- ESX
-- Added this so you can include the rest of the Usage-stuff found on the GitHub page
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
 
-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
    open = true
    SendNUIMessage({
        action = "open",
        array  = data,
        type   = type
    })
end)
 
-- Key events
Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- Controls found in the FiveM docs:
        -- https://docs.fivem.net/game-references/controls/
 
        -- 38 = E
        if IsControlJustReleased(0, 56) then
            ESX.UI.Menu.Open(
				  'default', GetCurrentResourceName(), 'id_card_menu',
				  {
					  title    = 'Identification Docs menu',
					  elements = {
						  {label = 'Check your ID', value = 'checkID'},
			                          {label = 'Show your ID', value = 'showID'},
			                          {label = 'Check your driver license', value = 'checkDriver'},
			                          {label = 'Show your driver license', value = 'showDriver'},
			                          {label = 'Check your firearms license', value = 'checkFirearms'},
			                          {label = 'Show your firearms license', value = 'showFirearms'},
					  }
				  },
				  function(data, menu)
					  local val = data.current.value
					 
					  if val == 'checkID' then
						  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
					  elseif val == 'checkDriver' then
						  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
					  elseif val == 'checkFirearms' then
						  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
					  else
						  local player, distance = ESX.Game.GetClosestPlayer()
						 
						  if distance ~= -1 and distance <= 3.0 then
							  if val == 'showID' then
							  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
							  elseif val == 'showDriver' then
						  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
							  elseif val == 'showFirearms' then
						  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
							  end
						  else
							ESX.ShowNotification('No players nearby')
						  end
					  end
				  end,
				  function(data, menu)
					  menu.close()
				  end
			)

            -- (Taken from the Usage-guide on the GitHub page)
            -- Look at your own ID-card
--[[             TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	-- Show your ID-card to the closest person
local player, distance = ESX.Game.GetClosestPlayer()

if distance ~= -1 and distance <= 3.0 then
  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
else
  ESX.ShowNotification('No players nearby')
end ]]
        end
        if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
            SendNUIMessage({
                action = "close"
            })
            open = false
        end
    end
end)

---------------------Drivers--------------------------------------
--[[Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- Controls found in the FiveM docs:
        -- https://docs.fivem.net/game-references/controls/
 
        -- 38 = E
        if IsControlJustReleased(0, 166) then
            -- (Taken from the Usage-guide on the GitHub page)
            -- Look at your own ID-card
TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
	-- Show your ID-card to the closest person
local player, distance = ESX.Game.GetClosestPlayer()

if distance ~= -1 and distance <= 3.0 then
TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
else
  ESX.ShowNotification('No players nearby')
end
        end
        if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
            SendNUIMessage({
                action = "close"
            })
            open = false
        end
    end
end)]]

------------------- Open ID card-----------------------------------
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

