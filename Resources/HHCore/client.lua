ESX = nil

local carryingBackInProgress = false
iamcarried = false
iamcarrying = false
local inside = false
local playerd = nil
carried = false

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

scanId = 0
cityRobbery = false
local myspawns = {}
CCTVCamLocations = {
	[1] =  { ['x'] = 92.17,['y'] = -1923.14,['z'] = 29.5,['h'] = 205.95, ['info'] = ' Ballas', ["recent"] = false },
	[2] =  { ['x'] = -176.26,['y'] = -1681.15,['z'] = 47.43,['h'] = 313.29, ['info'] = ' Famillies', ["recent"] = false },
	[3] =  { ['x'] = 285.95,['y'] = -2003.95,['z'] = 35.0,['h'] = 226.0, ['info'] = ' Vagos', ["recent"] = false },
	[4] =  { ['x'] = 241.98,['y'] = 216.54,['z'] = 108.29,['h'] = 267.31, ['info'] = ' P bank inside', ["recent"] = false },
	[5] =  { ['x'] = 180.01,['y'] = 180.36,['z'] = 112.54,['h'] = 313.29, ['info'] = ' P bank outside', ["recent"] = false },
}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()

	RegisterCommand("cctv", function (source, args, rawCommand)

		local cam = args[1]
	
		local xPlayer = ESX.GetPlayerData()
		local job = xPlayer.job
		local jobname = xPlayer.job.name
		if job and jobname == 'police' then
			TriggerEvent('cctv:camera', cam)
		end
	end)


	
	inCam = false
	cctvCam = 0
	RegisterNetEvent("cctv:camera")
	AddEventHandler("cctv:camera", function(camNumber)
		camNumber = tonumber(camNumber)
		if inCam then
			inCam = false
			PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
			--TaskStartScenarioInPlace(PlayerPedId(), 'world_human_stand_mobile_upright', 0, true)
			Wait(250)
			ClearPedTasks(GetPlayerPed(-1))
		else
			if camNumber > 0 and camNumber < #CCTVCamLocations+1 then
				PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
				TriggerEvent("cctv:startcamera",camNumber)
			else
				exports['mythic_notify']:SendAlert('error', "This camera appears to be faulty")
			end
		end
	end)
	
	RegisterNetEvent("cctv:startcamera")
	AddEventHandler("cctv:startcamera", function(camNumber)
	
		TaskStartScenarioInPlace(PlayerPedId(), 'world_human_stand_mobile_upright', 0, true)
		local camNumber = tonumber(camNumber)
		local x = CCTVCamLocations[camNumber]["x"]
		local y = CCTVCamLocations[camNumber]["y"]
		local z = CCTVCamLocations[camNumber]["z"]
		local h = CCTVCamLocations[camNumber]["h"]
	
		print("starting cam")
		inCam = true
	
		SetTimecycleModifier("heliGunCam")
		SetTimecycleModifierStrength(1.0)
		local scaleform = RequestScaleformMovie("TRAFFIC_CAM")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
	
		local lPed = GetPlayerPed(-1)
		cctvCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamCoord(cctvCam,x,y,z+1.2)						
		SetCamRot(cctvCam, -15.0,0.0,h)
		SetCamFov(cctvCam, 110.0)
		RenderScriptCams(true, false, 0, 1, 0)
		PushScaleformMovieFunction(scaleform, "PLAY_CAM_MOVIE")
		SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
		PopScaleformMovieFunctionVoid()
	
		while inCam do
			SetCamCoord(cctvCam,x,y,z+1.2)						
			-- SetCamRot(cctvCam, -15.0,0.0,h)
			PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
			PushScaleformMovieFunctionParameterFloat(GetEntityCoords(h).z)
			PushScaleformMovieFunctionParameterFloat(1.0)
			PushScaleformMovieFunctionParameterFloat(GetCamRot(cctvCam, 2).z)
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Citizen.Wait(1)
		end
		ClearFocus()
		ClearTimecycleModifier()
		RenderScriptCams(false, false, 0, 1, 0)
		SetScaleformMovieAsNoLongerNeeded(scaleform)
		DestroyCam(cctvCam, false)
		SetNightvision(false)
		SetSeethrough(false)	
	
	end)
	
	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(0)
			if inCam then
	
				local rota = GetCamRot(cctvCam, 2)
	
				if IsControlPressed(1, Keys['N4']) then
					SetCamRot(cctvCam, rota.x, 0.0, rota.z + 0.7, 2)
				end
	
				if IsControlPressed(1, Keys['N6']) then
					SetCamRot(cctvCam, rota.x, 0.0, rota.z - 0.7, 2)
				end
	
				if IsControlPressed(1, Keys['N8']) then
					SetCamRot(cctvCam, rota.x + 0.7, 0.0, rota.z, 2)
				end
	
				if IsControlPressed(1, Keys['N5']) then
					SetCamRot(cctvCam, rota.x - 0.7, 0.0, rota.z, 2)
				end
			end
		end
	end)
end)

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end)

RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
----------------------------------tackle----------------------------------------
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX               				= nil
local PlayerData                = {}
local PoliceJob 				= 'police'

local isTackling				= false
local isGettingTackled			= false

local tackleLib					= 'missmic2ig_11'
local tackleAnim 				= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim			= 'mic_2_ig_11_intro_p_one'

local lastTackleTime			= 0
local isRagdoll					= false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if isRagdoll then
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
	isGettingTackled = true

	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(GetPlayerPed(-1), true, false)

	isRagdoll = true
	Citizen.Wait(3000)
	isRagdoll = false

	isGettingTackled = false
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

	isTackling = false

end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Wait(0)

		if IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['G']) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 and PlayerData.job.name == PoliceJob then
			Citizen.Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 1.5 and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent('esx_kekke_tackle:tryTackle', GetPlayerServerId(closestPlayer))
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	DrawMarker(37, -1037.24, -2727.25, 20.12, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0) --- The GoPostal depot location
		if GetDistanceBetweenCoords(-1037.24, -2727.25, 20.12, GetEntityCoords(LocalPed())) < 2.0 then
			ESX.ShowHelpNotification("press ~INPUT_CONTEXT~ to Rent a Cycle")
			if (IsControlJustReleased(1, 38)) then
				spawnrent()
			end
		end
	end
end)

--DrawMarker(22, -1037.24, -2727.25, 20.12, 0, 0, 0, 0, 0, 0, 1, 1, 1, 255, 165, 0, 165, 0, 0, 0, 0)


function LocalPed()
	return GetPlayerPed(-1)
end

function spawnrent()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('Scorcher')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local plate = math.random(100, 900)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 180, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, "RENT"..plate)
	local platenew = GetVehicleNumberPlateText(spawned_car)
	TriggerServerEvent('garage:addKeys', platenew)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
	--startjob()

end

--------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Wait(0)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(0.5)
        SetPedDensityMultiplierThisFrame(0.2)
        SetRandomVehicleDensityMultiplierThisFrame(0.5)
        SetParkedVehicleDensityMultiplierThisFrame(0.5)
		SetScenarioPedDensityMultiplierThisFrame(0.2, 0.3)
		--ClearArea(400, -1000, 29.46, 0.1, true, false, true, false)
		--ClearAreaOfVehicles(400, -1000, 29.46, 1, false, false, false, false, false)
    end
end)
--------------------------------------------------------------crouch and prone----------------------------------
local crouched = false
local proned = false
crouchKey = 26
proneKey = 36

Citizen.CreateThread( function()
	while true do 
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(ped) ) then 
			ProneMovement()
			DisableControlAction( 0, proneKey, true ) 
			DisableControlAction( 0, crouchKey, true ) 
			if ( not IsPauseMenuActive() ) then 
				if ( IsDisabledControlJustPressed( 0, crouchKey ) and not proned ) then 
					RequestAnimSet( "move_ped_crouched" )
					RequestAnimSet("MOVE_M@TOUGH_GUY@")
					
					while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
						Citizen.Wait( 100 )
					end 
					while ( not HasAnimSetLoaded( "MOVE_M@TOUGH_GUY@" ) ) do 
						Citizen.Wait( 100 )
					end 		
					if ( crouched and not proned ) then 
						ResetPedMovementClipset( ped )
						ResetPedStrafeClipset(ped)
						SetPedMovementClipset( ped,"MOVE_M@TOUGH_GUY@", 0.5)
						crouched = false 
					elseif ( not crouched and not proned ) then
						SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
						SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
						crouched = true 
					end 
				elseif ( IsDisabledControlJustPressed(0, proneKey) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) then
					if proned then
						ESX.Streaming.RequestAnimDict('get_up@directional@movement@from_knees@action', function()
							TaskPlayAnim(ped, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
						end)
						Citizen.Wait(1000)
						--ClearPedTasksImmediately(ped)
						ClearPedSecondaryTask(ped)
						proned = false
					elseif not proned then
						RequestAnimSet( "move_crawl" )
						while ( not HasAnimSetLoaded( "move_crawl" ) ) do 
							Citizen.Wait( 100 )
						end
						Citizen.Wait(100) 
						ClearPedTasksImmediately(ped)
						--ClearPedSecondaryTask(ped)
						proned = true
						if IsPedSprinting(ped) or IsPedRunning(ped) or GetEntitySpeed(ped) > 5 then
							TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
							Citizen.Wait(1000)
						end
						SetProned()
					end
				end
			end
		else
			proned = false
			crouched = false
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end


function ProneMovement()
	if proned then
		ped = PlayerPedId()
		DisableControlAction(0, 23)
		if IsControlPressed(0, 32) or IsControlPressed(0, 33) then
			DisablePlayerFiring(ped, true)
		 elseif IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) then
		 	DisablePlayerFiring(ped, false)
		 end
		if IsControlJustPressed(0, 32) and not movefwd then
			movefwd = true
			Citizen.Wait(200)
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, 32) and movefwd then
			Citizen.Wait(200)
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
			movefwd = false
		end		
		if IsControlJustPressed(0, 33) and not movebwd then
			Citizen.Wait(200)
			movebwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, 33) and movebwd then 
			Citizen.Wait(200)
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
		    movebwd = false
		end
		if IsControlPressed(0, 34) then
			SetEntityHeading(ped, GetEntityHeading(ped)+2.0 )
		elseif IsControlPressed(0, 35) then
			SetEntityHeading(ped, GetEntityHeading(ped)-2.0 )
		end
	end
end
----- ]]-----------------------------------------------------------------------------------------------------------
-- Created by Deziel0495 and IllusiveTea --

-- NOTICE
-- This script is licensed under "No License". https://choosealicense.com/no-license/
-- You are allowed to: Download, Use and Edit the Script. 
-- You are not allowed to: Copy, re-release, re-distribute it without our written permission.

--- DO NOT EDIT THIS
local holstered = true

-- RESTRICTED PEDS --
-- I've only listed peds that have a remote speaker mic, but any ped listed here will do the animations.
local skins = {
	"s_m_y_cop_01",
	"s_f_y_cop_01",
	"s_m_y_hwaycop_01",
	"s_m_y_sheriff_01",
	"s_f_y_sheriff_01",
	"s_m_y_ranger_01",
	"s_f_y_ranger_01",
	"mp_m_freemode_01",
	"mp_f_freemode_01",
}

-- Add/remove weapon hashes here to be added for holster checks.
local weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_STUNGUN",

}

-- -- HOLD WEAPON HOLSTER ANIMATION --

Citizen.CreateThread( function()
	while true do 
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and CheckSkin(ped) then 
			DisableControlAction( 0, 20, true ) -- INPUT_MULTIPLAYER_INFO (Z)
			if not IsPauseMenuActive() then 
				loadAnimDict( "reaction@intimidation@cop@unarmed" )
				loadAnimDict( "reaction@intimidation@1h" )
				loadAnimDict( "weapons@pistol_1h@gang" )		
				if IsDisabledControlJustReleased( 0, 20 ) then -- INPUT_MULTIPLAYER_INFO (Z)
					ClearPedTasks(ped)
					--SetEnableHandcuffs(ped, false)
					--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				else
					if IsDisabledControlJustPressed( 0, 20 ) and CheckSkin(ped) then -- INPUT_MULTIPLAYER_INFO (Z)
						local xPlayer = ESX.GetPlayerData()
						local job = xPlayer.job
						local jobname = xPlayer.job.name
						if jobname == 'police' then
						--SetEnableHandcuffs(ped, true)
						--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true) 
						--TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
							TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 35.0, 8.0, -1, 50, 8.0, 0, 0, 0 )
						end
					end
					if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "reaction@intimidation@cop@unarmed", "intro", 3) then 
						DisableActions(ped)
					end	
				end
			end 
		end 
	end
end )

-- -- HOLSTER/UNHOLSTER PISTOL --
 
--[[  Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and CheckSkin(ped) then
			loadAnimDict( "rcmjosh4" )
			loadAnimDict( "weapons@pistol@" )
			if CheckWeapon(ped) then
				if holstered then
					TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 6.0, 2.0, -1, 48, 5, 0, 0, 0 )
					Citizen.Wait(600)
					ClearPedTasks(ped)
					holstered = false
				end
				--SetPedComponentVariation(ped, 9, 0, 0, 0)
			elseif not CheckWeapon(ped) then
				if not holstered then
					TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(500)
					ClearPedTasks(ped)
					holstered = true
				end
				--SetPedComponentVariation(ped, 9, 1, 0, 0)
			end
		end
	end
end) ]]

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

scanId = 0
cityRobbery = false
local myspawns = {}
CCTVCamLocations = {
	[1] =  { ['x'] = 92.17,['y'] = -1923.14,['z'] = 29.5,['h'] = 205.95, ['info'] = ' Ballas', ["recent"] = false },
	[2] =  { ['x'] = -176.26,['y'] = -1681.15,['z'] = 47.43,['h'] = 313.29, ['info'] = ' Famillies', ["recent"] = false },
	[3] =  { ['x'] = 285.95,['y'] = -2003.95,['z'] = 35.0,['h'] = 226.0, ['info'] = ' Vagos', ["recent"] = false },
	[4] =  { ['x'] = 241.98,['y'] = 216.54,['z'] = 108.29,['h'] = 267.31, ['info'] = ' P bank inside', ["recent"] = false },
	[5] =  { ['x'] = 180.01,['y'] = 180.36,['z'] = 112.54,['h'] = 313.29, ['info'] = ' P bank outside', ["recent"] = false },
}




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and CheckSkin(ped) then
			loadAnimDict( "reaction@intimidation@cop@unarmed" )
			loadAnimDict( "reaction@intimidation@1h" )
			if CheckWeapon(ped) then
				if holstered then
					TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 1, 0, 0, 0 )
					Citizen.Wait(2000)
					ClearPedTasks(ped)
					holstered = false
				end
				--SetPedComponentVariation(ped, 9, 0, 0, 0)
			elseif not CheckWeapon(ped) then
				if not holstered then
					TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 1, 0, 0, 0 )
					Citizen.Wait(1500)
					ClearPedTasks(ped)
					holstered = true
				end
				--SetPedComponentVariation(ped, 9, 1, 0, 0)
			end
		end
	end
end)
-- -- DO NOT REMOVE THESE! --

function CheckSkin(ped)
	for i = 1, #skins do
		if GetHashKey(skins[i]) == GetEntityModel(ped) then
			return true
		end
	end
	return false
end

function CheckWeapon(ped)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end


------------------ disable gun rewards--------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		DisablePlayerVehicleRewards(PlayerId())
	end
end)
---------------------------disable WeaponDrop-----------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_CARBINERIFLE'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PISTOL'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'))
	end
end)
---------------------------pointfinger----------------------------
local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)

--------------------------- Handsup-------------------------------
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	local dict = "missminuteman_1ig_2"

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	local handsup = false

	while true do
		Citizen.Wait(10)
		if IsControlJustPressed(1, Keys['X']) and GetLastInputMethod(2) and IsPedOnFoot(PlayerPedId()) then
			if not handsup then
				TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
				handsup = true
			else
				handsup = false
				ClearPedTasks(PlayerPedId())
			end
		end
	end
end)
-------------------------------------------------------------------
-- RADIO ANIMATIONS --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
			if not IsPauseMenuActive() then 
				loadAnimDict( "random@arrests" )
				loadAnimDict("cellphone@")
				if IsControlJustReleased( 0, 137 ) and IsEntityPlayingAnim(ped, "random@arrests", "generic_radio_enter", 3) or IsEntityPlayingAnim(ped, "random@arrests", "radio_chatter", 3) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
					--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
					ClearPedTasks(ped)
					--SetEnableHandcuffs(ped, false)
				else
					if IsControlJustPressed( 0, 137 ) and not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_to_call", 3) and not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
						TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						--SetEnableHandcuffs(ped, true)
					elseif IsControlJustPressed( 0, 137 ) and not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_to_call", 3) and IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
						TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						--SetEnableHandcuffs(ped, true)
					end 
--[[ 					if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
						DisableActions(ped)
					elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
						DisableActions(ped)
					end ]]
				end
			end 
		end 
	end
end )


function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end


----------------------------------------------
-- External Vehicle Commands, Made by FAXES --
----------------------------------------------

--- Config ---

usingKeyPress = false -- Allow use of a key press combo (default Ctrl + E) to open trunk/hood from outside
togKey = 38 -- E


--- Code ---

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand("trunk", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Trunk Closed.")
        else	
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Trunk Opened.")
        end
    else
        if distanceToVeh < 6 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Trunk Closed.")
            else
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Trunk Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
end)

RegisterCommand("hood", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Hood Closed.")
        else	
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Hood Opened.")
        end
    else
        if distanceToVeh < 4 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Hood Closed.")
            else	
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Hood Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
end)

RegisterCommand("door", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/door [door]")
        ShowInfo("~y~Possible doors:")
        ShowInfo("1(Front Left Door), 2(Front Right Door)")
        ShowInfo("3(Back Left Door), 4(Back Right Door)")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
                ShowInfo("[EVC] ~g~Door Closed.")
            else	
                SetVehicleDoorOpen(veh, door, false, false)
                ShowInfo("[EVC] ~g~Door Opened.")
            end
        else
            if distanceToVeh < 4 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                    SetVehicleDoorShut(vehLast, door, false)
                    ShowInfo("[EVC] ~g~Door Closed.")
                else	
                    SetVehicleDoorOpen(vehLast, door, false, false)
                    ShowInfo("[EVC] ~g~Door Opened.")
                end
            else
                ShowInfo("[EVC] ~y~Too far away from vehicle.")
            end
        end
    end
end)
--------------------------------windows-------------------------------------
RegisterCommand("windowdown", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	local down = false
    
    if args[1] == "1" then -- Front Left Door
        window = 0
    elseif args[1] == "2" then -- Front Right Door
        window = 1
    elseif args[1] == "3" then -- Back Left Door
        window = 2
    elseif args[1] == "4" then -- Back Right Door
        window = 3
    else
        window = nil
        ShowInfo("Usage: ~n~~b~/window [window]")
        ShowInfo("~y~Possible windows:")
        ShowInfo("1(Front Left Window), 2(Front Right Window)")
        ShowInfo("3(Back Left Window), 4(Back Right Window)")
    end

	if window ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if down == false then
                RollDownWindow(veh, window)
				ShowInfo("[EVC] ~g~Window Opened.")
				down = true
			end
        else
            if distanceToVeh < 2 then
                RollDownWindow(veh, window)
				ShowInfo("[EVC] ~g~Window Opened.")
				down = true
            else
                ShowInfo("[EVC] ~y~Too far away from vehicle.")
            end
        end
    end
end)
------------------------
RegisterCommand("windowup", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	local down = true
    
    if args[1] == "1" then -- Front Left Door
        window = 0
    elseif args[1] == "2" then -- Front Right Door
        window = 1
    elseif args[1] == "3" then -- Back Left Door
        window = 2
    elseif args[1] == "4" then -- Back Right Door
        window = 3
    else
        window = nil
        ShowInfo("Usage: ~n~~b~/window [window]")
        ShowInfo("~y~Possible windows:")
        ShowInfo("1(Front Left Window), 2(Front Right Window)")
        ShowInfo("3(Back Left Window), 4(Back Right Window)")
    end

	if window ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if down == true then
                RollUpWindow(veh, window)
				ShowInfo("[EVC] ~g~Window Closes.")
				down = false
			end
        else
            if distanceToVeh < 2 then
                RollUpWindow(veh, window)
				ShowInfo("[EVC] ~g~Window Closed.")
				down = false
            else
                ShowInfo("[EVC] ~y~Too far away from vehicle.")
            end
        end
    end
end)
----------------------------------------------------------------------------

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                            ShowInfo("[EVC] ~g~Trunk Closed.")
                        else	
                            SetVehicleDoorOpen(vehLast, door, false, false)
                            ShowInfo("[EVC] ~g~Trunk Opened.")
                        end
                    else
                        ShowInfo("[EVC] ~y~Too far away from vehicle.")
                    end
                end
            end
        end
    end)
end

--[[ ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

animDict = 'missfbi5ig_0'
animName = 'lyinginpain_loop_steve'

RegisterCommand('civ', function()
	LoadModel('v_med_emptybed')
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed, true)
	local bedHash = GetHashKey('v_med_emptybed')

	if (ESX.PlayerData.job.name == 'ambulance') then
    CreateObject(bedHash, playerPos.x, playerPos.y + 1.0, playerPos.z - 0.95, true, true, true)
	--local civiere = CreateObject(GetHashKey('v_med_emptybed'), GetEntityCoords(PlayerPedId()), true)
	else
		exports['mythic_notify']:DoHudText('error', ' Only EMS Can Access Stretcher! ')
	end
end, false)

RegisterCommand('rciv', function()
	local civiere = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('v_med_emptybed'))

	if DoesEntityExist(civiere) then
		DeleteEntity(civiere)
	end
end, false)

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("v_med_emptybed"), false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local civiereCoords = GetEntityCoords(closestObject)
			local civiereForward = GetEntityForwardVector(closestObject)
			
			local sitCoords = (civiereCoords + civiereForward * - 0.5)
			local pickupCoords = (civiereCoords + civiereForward * 0.3)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 2.0 then
				DrawText3Ds(sitCoords, "[G] Sleep On Bed", 0.4)

				if IsControlJustPressed(0, 47) then
					Sit(closestObject)
				end
			end

			if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 2.0 then
				DrawText3Ds(pickupCoords, "[E] Push Bed", 0.4)

				if IsControlJustPressed(0, 38) then
					PickUp(closestObject)
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

Sit = function(civiereObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayerciv()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfbi5ig_0', 'lyinginpain_loop_steve', 3) then
			ShowNotification("Somebody is already using the civiere!")
			return
		end
	end

	LoadAnim("missfbi5ig_0")

	AttachEntityToEntity(PlayerPedId(), civiereObject, 0, 0, 0.0, 1.3, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(civiereObject)

	while IsEntityAttachedToEntity(PlayerPedId(), civiereObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfbi5ig_0', 'lyinginpain_loop_steve', 1) then
			
			TaskPlayAnim(PlayerPedId(), 'missfbi5ig_0', 'lyinginpain_loop_steve', 1.0, 2.0, -1, 45, 1.0, 0, 0, 0)
			
			
		end

		if IsControlPressed(0, 32) then
			local x, y, z  = table.unpack(GetEntityCoords(civiereObject) + GetEntityForwardVector(civiereObject) * -0.02)
			SetEntityCoords(civiereObject, x,y,z)
			PlaceObjectOnGroundProperly(civiereObject)
			
			TaskPlayAnim(playerPed,missfbi5ig_0, lyinginpain_loop_steve, 8.0, 1.0, 1, 45, 1.0, 0, 0, 0)
			--SetEntityCoords(playerPed, bedCoords.x , bedCoords.y, bedCoords.z, 1, 1, 0, 0)
            --SetEntityHeading(playerPed, GetEntityHeading(bed) + 180.0)
            --TaskPlayAnim(playerPed,animDict, animName, 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.4

			if heading > 360 then
				heading = 0
			end

			--SetEntityHeading(civiereObject,  heading)
			SetEntityHeading(playerPed, GetEntityHeading(bed) + 180.0)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.4

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(civiereObject,  heading)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(civiereObject) + GetEntityForwardVector(civiereObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUp = function(civiereObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayerciv()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ShowNotification("Somebody is already driving the civiere!")
			return
		end
	end

	NetworkRequestControlOfEntity(civiereObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(civiereObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.0, -1.2, -1.0, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(civiereObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(civiereObject, true, true)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(civiereObject, true, true)
		end
	end
end

DrawText3Ds = function(coords, text, scale)
	local x,y,z = coords.x, coords.y, coords.z
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 370

	DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end]]
--[[ GetPlayers = function()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

GetClosestPlayerciv = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end ]]

--[[ LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end ]]
--------------------------------------------------------/job---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("job", function(source, args, raw)
	Show()
end, false)

function Show()
	--ESX.ShowNotification('You are working as an: ~g~' .. PlayerData.job.label .. " ~s~-~g~ " .. PlayerData.job.grade_label)
	exports['mythic_notify']:DoHudText('inform','You are working as an ' .. PlayerData.job.label .. ' and your rank is '.. PlayerData.job.grade_label)
end


Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if carryingBackInProgress  then
			sleep= 0
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,32,true) -- move (w)
			DisableControlAction(0,34,true) -- move (a)
			DisableControlAction(0,33,true) -- move (s)
			DisableControlAction(0,35,true) -- move (d)
			DisableControlAction(0,48,true) -- move (d)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)			
			DisableControlAction(0, Keys['F1'], true) --NO PHONE
			DisableControlAction(0, Keys['F2'], true) -- NO INVENTORY
			DisableControlAction(0, Keys['F3'], true) -- NO MENUS
			DisableControlAction(0, Keys['F6'], true) -- NO MENUS
			DisableControlAction(0, Keys['F7'], true) -- NO MENUS
			DisableControlAction(0, Keys['F9'], true) -- NO MENUS
			DisableControlAction(0, Keys['X'], true) -- NO MENUS
			DisableControlAction(0, Keys['F'], true)		
		end
		Citizen.Wait(sleep)
	end
end)


Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if carryingBackInProgress then
			sleep = 50
			
			local vehicled = VehicleInFront()
			if vehicled then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local trunk = GetEntityBoneIndexByName(vehicled, 'bumper_r')
			if trunk == -1 then
				trunk = GetEntityBoneIndexByName(vehicled, 'platelight')
				if trunk == -1 then
					if GetHashKey('ambulance') == GetEntityModel(vehicled) then 
						trunk = GetEntityBoneIndexByName(vehicled, 'door_dside_r')
					end
					if trunk == -1 then
						if GetVehicleClass(vehicled) ~= 8 then
							trunk = GetEntityBoneIndexByName(vehicled, 'exhaust')
						end
					end
					-- if trunk == -1 then
					-- 	trunk = 	 GetEntityBoneIndexByName(vehicled, 'boot')
					-- end
				end
			end
				if trunk ~= -1 then
					local coords = GetWorldPositionOfEntityBone(vehicled, trunk)
					local distance  = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true)	
					if  distance <= 2 and carryingBackInProgress and carried ~=nil then
						sleep = 2
						ESX.Game.Utils.DrawText3D(coords, 'Press [~b~ALT~s~] to Put in Trunk',0.8) --Draw 3d text
						insidecar(carried,vehicled)
					end 
				end		
		end
	end
		Citizen.Wait(sleep)
	end
end)



RegisterCommand("carry",function(source, args)
	if GetEntityHealth(PlayerPedId()) > 105 and GetVehiclePedIsIn(PlayerPedId(),false)==0 then
		if not carryingBackInProgress then
			local player = PlayerPedId()	
			lib = 'missfinale_c2mcs_1'
			anim1 = 'fin_c2_mcs_1_camman'
			lib2 = 'nm'
			anim2 = 'firemans_carry'
			distans = 0.15
			distans2 = 0.27
			height = 0.63
			spin = 0.0		
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 33
			animFlagTarget = 1
			local closestPlayer = GetClosestPlayer(3)
			if closestPlayer ~= nil then
				target = GetPlayerServerId(closestPlayer)
				if GetVehiclePedIsIn(GetPlayerPed(closestPlayer),false)==0 or GetEntityHealth(GetPlayerPed(closestPlayer))<=105 then
					carryingBackInProgress = true
					ClearPedTasksImmediately(PlayerPedId())   
					ClearPedTasksImmediately(closestPlayer)   
					inside = false	
					TriggerServerEvent("cmg2_animations:stop",target)
					playerd = target
					TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					carried = closestPlayer
				end
			end
		else
			carryingBackInProgress = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer = GetClosestPlayer(3)
			target = GetPlayerServerId(closestPlayer)
			ClearPedTasksImmediately(closestPlayer)   
			inside = false	
			TriggerServerEvent("cmg2_animations:stop",target)
		end
		
	end
end,false)



RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	isOnBed = false

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	if spin == nil then spin = 180.0 end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)

	if controlFlag == nil then controlFlag = 0 end

	while carryingBackInProgress do
		if not IsEntityPlayingAnim(playerPed, animationLib, animation2, 3) then
			TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		end
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	while carryingBackInProgress do
		if not IsEntityPlayingAnim(playerPed, animationLib, animation, 3) then
			TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		end
		Citizen.Wait(100)
	end
	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carryingBackInProgress = false
	ClearPedTasksImmediately(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
	inside = false
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
	if closestDistance <= radius and closestDistance ~=-1 then
		return closestPlayer
	else
		return nil
	end
end


RegisterCommand("tout",function(source, args)
	if GetEntityHealth(PlayerPedId()) > 105 then
		if inside then
			DetachEntity(PlayerPedId(), true, true)
			ClearPedTasksImmediately(PlayerPedId())   
			inside = false
		end
	end
end)


function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 6.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end
 

function insidecar(player,vehicles)		
	if IsDisabledControlPressed(0, 19) and GetVehiclePedIsIn(player, false) == 0 and DoesEntityExist(vehicles) and IsEntityAVehicle(vehicles) then
		ClearPedTasksImmediately(PlayerPedId())
		ClearPedTasksImmediately(player)
		DetachEntity(player, true, false)
		carryingBackInProgress = false
		-- target =
		TriggerServerEvent("cmg2_animations:stop", GetPlayerServerId(player))		
		TriggerServerEvent("spushin", GetPlayerServerId(player))
	end			
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent("pushin")
AddEventHandler("pushin", function(target)	
	local ped = GetPlayerPed(GetPlayerFromServerId(target))
	local pos = GetEntityCoords(ped,true)
	local vehicle, distance = ESX.Game.GetClosestVehicle(pos)
	SetVehicleDoorOpen(vehicle, 5, false, false)
	if not inside then
		AttachEntityToEntity(ped, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
		if IsEntityAttached(ped) then
			loadDict('timetable@floyd@cryingonbed@base')
			inside = true		
			if not IsEntityPlayingAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 3) then
				TaskPlayAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			end
		-- else
		-- 	inside = false
		end   
	-- elseif inside then
	-- 	DetachEntity(ped, true, true)
	-- 	ClearPedTasksImmediately(ped)   
	-- 	inside = false	
	end	
	Citizen.Wait(2000)
	SetVehicleDoorShut(vehicle, 5, false,false)
end)

Citizen.CreateThread(function()
	while true do 
		if inside then
			if not IsEntityPlayingAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 3) then
				TaskPlayAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			end												
		end
		Citizen.Wait(50)
	end
end)


function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end
-----------------------------------------------qalle coords------------------------------------------------------------------------------------------------------------
local coordsVisible = false

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

RegisterCommand("coords", function()
    ToggleCoords()
end)
--------------------------------------------------------------------------------------heli cameras---------------------------------------------------------------------------------
-- FiveM Heli Cam by davwheat and mraes
-- Version 2.0 05-11-2018 (DD-MM-YYYY)

-- config
local fov_max = 90.0
local fov_min = 7.5 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)
local showLSPDlogo = 0 -- 1 for ON, 0 for OFF
local minHeightAboveGround = 1.5 -- default: 1.5. Minimum height above ground to activate Heli Cam (in metres). Should be between 1 and 20.
local useMilesPerHour = 0 -- 0 is kmh; 1 is mph

-- Script starts here
local helicam = false
local polmav_hash = GetHashKey("polmav") -- change to another heli if you want :P
local fov = (fov_max + fov_min) * 0.5
local vision_state = 0 -- 0 is normal, 1 is night vision, 2 is thermal vision

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0)
			if IsPlayerInPolmav() then
				local lPed = GetPlayerPed(-1)
				local heli = GetVehiclePedIsIn(lPed)

				if IsHeliHighEnough(heli) then
					if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						helicam = true
					end

					if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
						Citizen.Trace("Attempting rapel from helicopter...")
						if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TaskRappelFromHeli(lPed, 1)
						else
							SetNotificationTextEntry("STRING")
							AddTextComponentString("~r~Can't rappel from this seat")
							DrawNotification(false, false)
							PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
						end
					end
				end

				if IsControlJustPressed(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == lPed then
					spotlight_state = not spotlight_state
					TriggerServerEvent("heli:spotlight", spotlight_state)
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

			if helicam then
				SetTimecycleModifier("heliGunCam")
				SetTimecycleModifierStrength(0.3)
				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(0)
				end
				local lPed = GetPlayerPed(-1)
				local heli = GetVehiclePedIsIn(lPed)
				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
				AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
				SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
				SetCamFov(cam, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(showLSPDlogo) -- 0 for nothing, 1 for LSPD logo
				PopScaleformMovieFunctionVoid()
				local locked_on_vehicle = nil
				while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
					if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						helicam = false
					end
					if IsControlJustPressed(0, toggle_vision) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						ChangeVision()
					end

					if locked_on_vehicle then
						if DoesEntityExist(locked_on_vehicle) then
							PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
							RenderVehicleInfo(locked_on_vehicle)
							if IsControlJustPressed(0, toggle_lock_on) then
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								locked_on_vehicle = nil
								local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
								local fov = GetCamFov(cam)
								local old
								cam = cam
								DestroyCam(old_cam, false)
								cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
								AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
								SetCamRot(cam, rot, 2)
								SetCamFov(cam, fov)
								RenderScriptCams(true, false, 0, 1, 0)
							end
						else
							locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
						end
					else
						local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
						CheckInputRotation(cam, zoomvalue)
						local vehicle_detected = GetVehicleInView(cam)
						if DoesEntityExist(vehicle_detected) then
							RenderVehicleInfo(vehicle_detected)
							if IsControlJustPressed(0, toggle_lock_on) then
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								locked_on_vehicle = vehicle_detected
							end
						end
					end
					HandleZoom(cam)
					HideHUDThisFrame()
					PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					Citizen.Wait(0)
				end
				helicam = false
				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5 -- reset to starting zoom level
				RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
				SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
				DestroyCam(cam, false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end
	end
)

RegisterNetEvent("heli:spotlight")
AddEventHandler(
	"heli:spotlight",
	function(serverID, state)
		local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
		SetVehicleSearchlight(heli, state, false)
		Citizen.Trace("Set heli light state to " .. tostring(state) .. " for serverID: " .. serverID)
	end
)

function IsPlayerInPolmav()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > minHeightAboveGround
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0, 241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0, 242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov) * 0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle =
		CastRayPointToPoint(coords, coords + (forward_vector * 200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	local numberOfPassengers = GetVehicleNumberOfPassengers(vehicle)
	local isDriverSeatOccupied = IsVehicleSeatFree(vehicle, -1)
	local vehicleSpeed = GetEntitySpeed(vehicle)

	local spdUnits = ""

	if useMilesPerHour then
		vehicleSpeed = vehicleSpeed * 2.236936 -- mph
		spdUnits = "mph"
	else
		vehicleSpeed = vehicleSpeed * 3.6 -- kmh
		spdUnits = "km/h"
	end

	if isDriverSeatOccupied then
		numberOfPassengers = numberOfPassengers + 1
	end

	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(
		"Vehicle: " .. vehname .. "        Plate: " .. licenseplate .. "\nSpeed: " .. math.ceil(vehicleSpeed) .. "        Total occupants: " .. numberOfPassengers
	)
	DrawText(0.45, 0.9)
end

-- function HandleSpotlight(cam)
-- if IsControlJustPressed(0, toggle_spotlight) then
-- PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
-- spotlight_state = not spotlight_state
-- end
-- if spotlight_state then
-- local rotation = GetCamRot(cam, 2)
-- local forward_vector = RotAnglesToVec(rotation)
-- local camcoords = GetCamCoord(cam)
-- DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 10.0, 0.0, 2.0, 1.0)
-- end
-- end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

------------------------------------------------------------------------------Vehicle Names-----------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	AddTextEntry('avz', '2017 Aston Martin Vanquish')
	AddTextEntry('rs7', 'RS7 Sportsback')
	AddTextEntry('bmci', 'BMW M5 F90 2018')
	AddTextEntry('x6m', '2016 BMW X6M')
	AddTextEntry('divo', 'Bugatti Divo')
	AddTextEntry('gmt900escalade', 'Cadillac Escalade GMT900s')
	AddTextEntry('cone', 'Cadillac Limo')
	AddTextEntry('cats', 'Cadillac ATS-V Coupe')
	AddTextEntry('2018zl1', '2018 Chevrolet Camaro ZL1')
	AddTextEntry('camaross', 'Camaro SS')
	AddTextEntry('subn', 'Chevrolet Suburban 2016')
	AddTextEntry('718', 'Porsche 718 Convertible')
	AddTextEntry('z4', 'BMW Z4 Convertible')
	AddTextEntry('18f350ds', 'Ford F350')
	AddTextEntry('19gt500', 'Ford GT 500 2019')
	AddTextEntry('fmgt', 'Ford Mustang GT 2018')
	AddTextEntry('gt2017', 'Ford GT 2017')
	AddTextEntry('RAPTOR150', 'Ford Raptor 150')
	AddTextEntry('raptor2017', 'Ford Raptor 2017')
	AddTextEntry('velociraptor', 'Ford F 150 Velociraptor')
	AddTextEntry('crawler', 'Jeep Crawler')
	AddTextEntry('dcd', 'Dodge Challenger')
	AddTextEntry('rc', 'KTM RC 200')
	AddTextEntry('aventadors', 'Lamborghini Aventador')
	AddTextEntry('lp610', 'Lamborghini Huracan LP610')
	AddTextEntry('rmodlp770', 'Lamborghini Centenario')
	AddTextEntry('urus', 'Lamborghini Urus')
	AddTextEntry('rmodp1gtr', 'Mclaren P1 GTR')
	AddTextEntry('720stc', 'Mclaren 720s')
	AddTextEntry('senna', 'Mclaren Senna')
	AddTextEntry('gtr', 'Nissan GTR')
	AddTextEntry('cayenne', 'Porsche Cayenne 2016')
	AddTextEntry('por4s', 'Porsche 911 Carrera')
	AddTextEntry('techart17', 'Porsche TChart 2017')
	AddTextEntry('dawn', 'Rolls Royce Dawn 2019')
	AddTextEntry('ts1', 'Zenovo TS1')
end)