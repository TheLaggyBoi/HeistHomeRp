RegisterNetEvent("mythic_hospital:items:bandage")
AddEventHandler("mythic_hospital:items:bandage", function(item)
    exports['mythic_progbar']:Progress({
        name = "firstaid_action",
        duration = 5000,
        label = "Using Bandage...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_paper_bag_small",
        }
    }, function(cancelled)
        if not cancelled then
		local maxHealth = GetEntityMaxHealth(PlayerPedId())
		local health = GetEntityHealth(PlayerPedId())
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
        SetEntityHealth(PlayerPedId(), newHealth)
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        end
    end)
end)


RegisterNetEvent("mythic_hospital:items:medikit")
AddEventHandler("mythic_hospital:items:medikit", function(item)
    exports['mythic_progbar']:Progress({
        name = "firstaid_action",
        duration = 20000,
        label = "Using Medkit...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_ld_health_pack"
        },
    }, function(cancelled)
        if not cancelled then
	    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            TriggerEvent('mythic_hospital:client:FieldTreatLimbs')
            TriggerEvent('mythic_hospital:client:RemoveBleed')
			TriggerEvent('mythic_hospital:client:ResetLimbs')
        end
    end)
end)

RegisterNetEvent('mythic_hospital:items:pills')
AddEventHandler('mythic_hospital:items:pills', function(prop_name)
	if not IsAnimated then
		prop_name = 'p_weed_bottle_s' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

            exports['progressBars']:startUI( 3000, "Taking Pills")
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
            end)

            local hp = GetEntityHealth(playerPed)
            local pill = hp + 30
            SetEntityHealth(playerPed, pill)

		end)

	end
end)

RegisterNetEvent('mythic_hospital:items:vicodin')
AddEventHandler('mythic_hospital:items:vicodin', function(prop_name)
	if not IsAnimated then
		prop_name = 'p_weed_bottle_s' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
            
            exports['progressBars']:startUI( 3000, "Taking Vicodin")
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
            end)
            TriggerEvent('mythic_hospital:client:ResetLimbs')
		end)

	end
end)

RegisterNetEvent('mythic_hospital:items:morphine')
AddEventHandler('mythic_hospital:items:morphine', function(prop_name)
	if not IsAnimated then
		prop_name = 'prop_shots_glass_cs' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
            
            exports['progressBars']:startUI( 3000, "Taking Morphine")
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
            end)

            local hp = GetEntityHealth(playerPed)
            local morphine = hp + 50
            SetEntityHealth(playerPed, morphine)
            TriggerEvent('mythic_hospital:client:ResetLimbs')
		end)

	end
end)
