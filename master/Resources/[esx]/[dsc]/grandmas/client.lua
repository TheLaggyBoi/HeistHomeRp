ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Create Blips here if you want
--[[Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2433.91, 4965.50, 42.00)

    SetBlipSprite (blip, 357)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 59)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Grandmas House")
    EndTextCommandSetBlipName(blip)
    
end)]]--

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(plyCoords.x, plyCoords.y, plyCoords.z) - plyCoords)
        local coords = vector3(2436.08, 4966.85, 42.35)
        if distance < 10 then

            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    if GetDistanceBetweenCoords(plyCoords, 2436.08, 4966.85, 42.35, true) < 1.5 then        
                        ESX.Game.Utils.DrawText3D({x = 2436.08, y = 4966.85,z = 42.35},'Press [~y~E~s~] to ~o~Ask Grandma~s~ to Treat You',0.5)
                            -- Draw3DText(coords.x, coords.y, coords.z - plyCoords, '[E] - Check in for $1,000') 
                            --Draw3DText(distance.x, distance.y, distance.z - coords, '[E] - Check in for $1,000')
                        if IsControlJustReleased(0, 38) then
                            DisableControlAction(0, 38, true)
                            if (GetEntityHealth(PlayerPedId()) <= 200) then
                                exports['progressBars']:startUI( 20000, "Grandma is Treating You!")
                                Citizen.Wait(20000)
                                TriggerEvent('disc-death:revive')
                                exports['mythic_notify']:DoHudText('success', 'You are Healthy Now')
                            else
                                exports['mythic_notify']:DoHudText('error', 'You do not need medical attention')
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    RequestModel(GetHashKey("ig_mrs_thornhill"))    
    while not HasModelLoaded(GetHashKey("ig_mrs_thornhill")) do
        Wait(1)
    end    
    local npc = CreatePed(4, GetHashKey("ig_mrs_thornhill"), 2437.22, 4966.59, 42.35 - 0.90, 0, false, true)
        
    SetEntityHeading(npc,  83.13)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)