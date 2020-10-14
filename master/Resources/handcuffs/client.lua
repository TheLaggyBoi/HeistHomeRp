local isCuffed = false
local cuffedAnimNamePlaying = ""
local cuffedAnimDictPlaying = ""
local cuffedControlFlagPlaying = 0

RegisterCommand("cuff",function(source, args)
	if not isCuffed then
		local player = PlayerPedId()	
		lib = 'mp_arrest_paired'
		anim1 = 'cop_p2_back_right'
		lib2 = 'mp_arresting'
		anim2 = 'idle'
		distans = 0.15
		distans2 = 0.27
		height = 0.10
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			isCuffed = true
			TriggerServerEvent('handcuffs:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			drawNativeNotification("No one nearby to cuff")
		end
	else
		isCuffed = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		--DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("handcuffs:stop",target)
		end
	end
end,false)

RegisterCommand("uncuff",function(source, args)
	if isCuffed == true then
		TriggerServerEvent("handcuffs:stop",target)
	else
		drawNativeNotification("No One is Cuffed")
	end
end,false)

RegisterNetEvent('handcuffs:syncTarget')
AddEventHandler('handcuffs:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	isCuffed = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	--AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	--TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	TaskPlayAnim(targetped, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	cuffedAnimNamePlaying = animation2
	cuffedAnimDictPlaying = animationLib
	cuffedControlFlagPlaying = controlFlag

end)

RegisterNetEvent('handcuffs:syncMe')
AddEventHandler('handcuffs:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	cuffedAnimNamePlaying = animation
	cuffedAnimDictPlaying = animationLib
	cuffedControlFlagPlaying = controlFlag
end)

RegisterNetEvent('handcuffs:cl_stop')
AddEventHandler('handcuffs:cl_stop', function()
	isCuffed = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	--DetachEntity(GetPlayerPed(-1), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if isCuffed then 
			while not IsEntityPlayingAnim(GetPlayerPed(-1), cuffedAnimDictPlaying, cuffedAnimNamePlaying, 3) do
				TaskPlayAnim(GetPlayerPed(-1), cuffedAnimDictPlaying, cuffedAnimNamePlaying, 8.0, -8.0, 100000, cuffedControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
	if isCuffed == true then
		DisablePlayerFiring(GetPlayerPed(-1), true)
		DisableControlAction(0, 25, true)
		DisableControlAction(1, 140, true)
		DisableControlAction(1, 141, true)
		DisableControlAction(1, 142, true)
		SetPedPathCanUseLadders(GetPlayerPed(-1), false)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			DisableControlAction(0, 59, true)
		end
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
	end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	--print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end