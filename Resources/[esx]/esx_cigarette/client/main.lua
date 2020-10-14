ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--[[ Citizen.CreateThread(function()
	Citizen.Wait(500)
	local ped = GetPlayerPed(-1)
		while true do
			Citizen.Wait(1)
			if IsPedShooting(ped) or GetPedConfigFlag(ped, 78, 1) then
				TriggerEvent('stress', source)
				exports['mythic_notify']:DoHudText('error', 'stress gained');
				Citizen.Wait(10000)
			end
		end
end)

RegisterNetEvent('stress')
AddEventHandler('stress', function()
	TriggerServerEvent('addstress', source)
end)
 ]]

 local weaponstress = {
	[453432689] = 1000, -- PISTOL
	[3219281620] = 1000, -- PISTOL MK2
	[1593441988] = 1000, -- COMBAT PISTOL
	[584646201] = 1000, -- AP PISTOL
	[2578377531] = 1200, -- PISTOL .50
	[3523564046] = 650, -- HEAVY PISTOL
	[-1716589765] = 6500, --pistol50
	[137902532] = 750, -- VINTAGE PISTOL
	[3696079510] = 750, -- MARKSMAN PISTOL
	[1198879012] = 100, -- FLARE GUN
	-- [324215364] = 1000, -- MICRO SMG
	-- [736523883] = 1000, -- SMG
	-- [2024373456] = 1000, -- SMG MK2
	-- [4024951519] = 1000, -- ASSAULT SMG
	-- [3220176749] = 3500, -- ASSAULT RIFLE
	-- [961495388] = 3500, -- ASSAULT RIFLE MK2
	-- [2210333304] = 3500, -- CARBINE RIFLE
	-- [4208062921] = 3500, -- CARBINE RIFLE MK2
	-- [2937143193] = 3500, -- ADVANCED RIFLE
	-- [2634544996] = 3500, -- MG
	-- [2144741730] = 3500, -- COMBAT MG
	-- [3686625920] = 3500, -- COMBAT MG MK2
	-- [487013001] = 6833, -- PUMP SHOTGUN
	-- [1432025498] = 6833, -- PUMP SHOTGUN MK2
	-- [2017895192] = 3500, -- SAWNOFF SHOTGUN
	-- [3800352039] = 6833, -- ASSAULT SHOTGUN
	-- [2640438543] = 6833, -- BULLPUP SHOTGUN
	-- [911657153] = 100, -- STUN GUN
	-- [100416529] = 3500, -- SNIPER RIFLE
	-- [205991906] = 3500, -- HEAVY SNIPER
	-- [177293209] = 3500, -- HEAVY SNIPER MK2
	-- [856002082] = 3500, -- REMOTE SNIPER
	-- [2726580491] = 3500, -- GRENADE LAUNCHER
	-- [1305664598] = 3500, -- GRENADE LAUNCHER SMOKE
	-- [2982836145] = 3500, -- RPG
	-- [1752584910] = 3500, -- STINGER
	-- [1119849093] = 3500, -- MINIGUN
	[3218215474] = 1000, -- SNS PISTOL
  -- [1627465347] = 1000, -- GUSENBERG
	-- [3231910285] = 1000, -- SPECIAL CARBINE
	-- [-1768145561] = 0.25, -- SPECIAL CARBINE MK2
	-- [2132975508] = 3500, -- BULLPUP RIFLE
	-- [-2066285827] = 3500, -- BULLPUP RIFLE MK2
	-- [-1746263880] = 750, -- DOUBLE ACTION REVOLVER
	-- [2828843422] = 750, -- MUSKET
	-- [984333226] = 6833, -- HEAVY SHOTGUN
	-- [3342088282] = 6833, -- MARKSMAN RIFLE
	-- [1785463520] = 6833, -- MARKSMAN RIFLE MK2
	-- [1672152130] = 6833, -- HOMING LAUNCHER
	-- [1198879012] = 100, -- FLARE GUN
	-- [171789620] = 1000, -- COMBAT PDW
	-- [3696079510] = 750, -- MARKSMAN PISTOL
  -- 	[1834241177] = 6833, -- RAILGUN
	[3675956304] = 750, -- MACHINE PISTOL
	-- [3249783761] = 750, -- REVOLVER
	-- [-879347409] = 1200, -- REVOLVER MK2
	-- [4019527611] = 01800, -- DOUBLE BARREL SHOTGUN
	-- [1649403952] = 1000, -- COMPACT RIFLE
	-- [317205821] = 6833, -- AUTO SHOTGUN
	-- [125959754] = 3500, -- COMPACT LAUNCHER
	-- [3173288789] = 1000, -- MINI SMG	
	-- [2009644972] = 1000, -- SNS PISTOL MK2
	-- [-1813897027] = 1000, -- Grenade	
	-- [741814745] = 1000, -- StickyBomb		
	-- [-494615257] = 1000, -- AssaultShotgun		
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(ped)
		if IsPedShooting(ped) then
		  TriggerEvent('esx_status:add', 'stress', 500)
			--   exports['mythic_notify']:DoHudText('error', 'stress gained');
			--  print(weaponstress[weapon])
		end
		if GetPedConfigFlag(ped, 78, 1) then
			TriggerEvent('esx_status:add', 'stress', 800)
			Citizen.Wait(5000)
			exports['mythic_notify']:DoHudText('error', 'stress gained');
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
		if IsPedOnAnyBike(ped) then
		  TriggerEvent('esx_status:remove','stress',300)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)
		local speed = GetEntitySpeed(GetVehiclePedIsIn(ped,true)) * 2.6
		if IsPedInAnyVehicle(ped,false)	and speed >= 180 then
		  TriggerEvent('esx_status:add','stress',2000)
		  exports['mythic_notify']:DoHudText('error', 'stress gained');
		  print(speed)
		  Citizen.Wait(3000)
		end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
		if IsPedSwimming(ped) then
		  TriggerEvent('esx_status:remove','stress',200)
		end
	end
end)


RegisterNetEvent('esx_basicneeds:OnSmokeCigarette')
AddEventHandler('esx_basicneeds:OnSmokeCigarette', function()
	prop_name = prop_name or 'ng_proc_cigarette01a' ---used cigarett prop for now. Tired of trying to place object.
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	local boneIndex = GetPedBoneIndex(ped, 64017)
			
    if not IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) then
        RequestAnimDict("amb@world_human_smoking@male@male_b@idle_a")
        while not HasAnimDictLoaded("amb@world_human_smoking@male@male_b@idle_a") do
            Citizen.Wait(100)
        end

		Wait(100)
		AttachEntityToEntity(prop, ped, boneIndex, 0.015, 0.0100, 0.0250, 0.024, -100.0, 40.0, true, true, false, true, 1, true)
		TaskPlayAnim(ped, 'amb@world_human_smoking@male@male_b@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
		exports['mythic_notify']:DoHudText('success', 'stress reduced');
        Wait(2000)
		while IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) do
			Wait(1)
			if IsControlPressed(0, 153) or IsControlPressed(0, 38) then
				Citizen.Wait(3000)--5 secondes
				DetachEntity(prop, true, false)
				ClearPedSecondaryTask(ped)
				DeleteObject(prop)
				break
			else
				DetachEntity(prop, true, false)
				ClearPedSecondaryTask(ped)
				DeleteObject(prop)
            end
        end
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('kypo-drug-effect:onCoke')
AddEventHandler('kypo-drug-effect:onCoke', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  
    RequestAnimSet("MOVE_M@QUICK") 
    while not HasAnimSetLoaded("MOVE_M@QUICK") do
      Citizen.Wait(0)
    end    
    exports['mythic_notify']:DoHudText('success', 'You took some cocaine!')
    ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
      TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
  
      Citizen.Wait(3000)
      IsAnimated = false
      ClearPedSecondaryTask(playerPed)
      DeleteObject(prop)
    end)
    AddArmourToPed(playerPed, 10)
    SetPedMovementClipset(playerPed, "MOVE_M@QUICK", true)
	  SetPedMoveRateOverride(PlayerId(),10.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.49)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
    Citizen.Wait(20000)
-- after wait stop all 
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('kypo-drug-effect:onWeed')
AddEventHandler('kypo-drug-effect:onWeed', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  local source = PlayerPedId()
  if not IsPedInAnyVehicle(playerPed) then
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, 1)
    exports['progressBars']:startUI( 5000, "Rolling Joint")  
    Citizen.Wait(5000)
    ClearPedTasksImmediately(playerPed)
  else
    exports['progressBars']:startUI( 5000, "Rolling Joint")  
    Citizen.Wait(5000)
  end
  ClearPedSecondaryTask(playerPed)
	exports['mythic_notify']:DoHudText('success', 'You Rolled 3 Joints!')
end)

RegisterNetEvent('kypo-drug-effect:onjoint')
AddEventHandler('kypo-drug-effect:onjoint', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed) then
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
      Citizen.Wait(8000)
      ClearPedTasksImmediately(playerPed)
    else
      RequestAnimDict("amb@world_human_smoking@male@male_b@idle_a")
      while not HasAnimDictLoaded("amb@world_human_smoking@male@male_b@idle_a") do
          Citizen.Wait(100)
      end
      TaskPlayAnim(ped, 'amb@world_human_smoking@male@male_b@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
      Citizen.Wait(8000)
      ClearPedSecondaryTask(playerPed)
    end
    ClearPedSecondaryTask(playerPed)
    exports['mythic_notify']:DoHudText('success', 'You took some weed!')
    exports['mythic_notify']:DoHudText('success', 'Stress Reduced')
    --SetTimecycleModifier("spectator6")
    --SetPedMotionBlur(playerPed, true)
    -- SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@VERYDRUNK", true)
    -- SetPedIsDrunk(playerPed, true)
    --AnimpostfxPlay("ChopVision", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.0)
	--SetPlayerSprint(playerPed, true)
	ResetPlayerStamina(playerPed)
	SetEntityHealth(GetPlayerPed(-1), 200)
	AddArmourToPed(playerPed, 25)
	--TriggerEvent('mythic_hospital:client:RemoveBleed')
--vvvvvvvvvvvvvvvv
    Citizen.Wait(25000)
--^^^^^^^^^^^^^^^^
--Time of effect
--  after wait stop all effects
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
	SetTimecycleModifierStrength(0.0)
	--SetPlayerSprint(playerPed, false)
	ResetPlayerStamina(playerPed)
end)

RegisterNetEvent('kypo-drug-effect:onHeroin')
AddEventHandler('kypo-drug-effect:onHeroin', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@hobo@a") 
    while not HasAnimSetLoaded("move_m@hobo@a") do
      Citizen.Wait(0)
    end    
    exports['mythic_notify']:DoHudText('success', 'You took some Heroin!')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator3")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@hobo@a", true)
    SetPedIsDrunk(playerPed, true)
    AnimpostfxPlay("HeistCelebPass", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
	
    SetEntityHealth(GetPlayerPed(-1), 150)
    AddArmourToPed(playerPed, 100)
--vvvvvvvvvvvvvvvv
    Citizen.Wait(100000)
--^^^^^^^^^^^^^^^^
--Time of effect
--  after wait stop all effects
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('kypo-drug-effect:onLsd')
AddEventHandler('kypo-drug-effect:onLsd', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@buzzed") 
    while not HasAnimSetLoaded("move_m@buzzed") do
      Citizen.Wait(0)
    end    
    exports['mythic_notify']:DoHudText('success', 'You took some LSD!')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@buzzed", true)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("Rampage", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
	
    SetEntityHealth(GetPlayerPed(-1), 200)
--vvvvvvvvvvvvvvvv
    Citizen.Wait(100000)
--^^^^^^^^^^^^^^^^
--Time of effect
--  after wait stop all effects
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('kypo-drug-effect:onMeth')
AddEventHandler('kypo-drug-effect:onMeth', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@drunk@slightlydrunk") 
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
      Citizen.Wait(0)
    end    
	exports['mythic_notify']:DoHudText('success', 'You took some Meth!')
	ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
		TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

		Citizen.Wait(3000)
		IsAnimated = false
		ClearPedSecondaryTask(playerPed)
		DeleteObject(prop)
	end)
    --TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    ---Citizen.Wait(3000)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("SuccessMichael", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
	
	--SetEntityHealth(GetPlayerPed(-1), 200)
	TriggerEvent('mythic_hospital:client:RemoveBleed')
	SetPlayerInvincible(playerPed, true)
	AddArmourToPed(playerPed, 50)
--vvvvvvvvvvvvvvvv
    Citizen.Wait(25000)
--^^^^^^^^^^^^^^^^
--Time of effect
--  after wait stop all effects
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
	SetTimecycleModifierStrength(0.0)
	SetPlayerInvincible(playerPed, false)
end)

RegisterNetEvent('kypo-drug-effect:onLsa')
AddEventHandler('kypo-drug-effect:onLsa', function()
  
  local playerPed = GetPlayerPed(-1)
  local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@buzzed") 
    while not HasAnimSetLoaded("move_m@buzzed") do
      Citizen.Wait(0)
    end    
    exports['mythic_notify']:DoHudText('success', 'You took some LSA!')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@buzzed", true)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("Rampage", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
	
    SetEntityHealth(GetPlayerPed(-1), 200)
--vvvvvvvvvvvvvvvv
    Citizen.Wait(100000)
--^^^^^^^^^^^^^^^^
--Time of effect
--  after wait stop all effects
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------