ESX = nil
local GUI = {}
local PlayerData = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time = 0
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local entityWorld = nil
local globalplate = nil
local lastChecked = 0
local isplaying = false
local lib, ani = 'mini@repair', 'fixing_a_ped'
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
  "esx:playerLoaded",
  function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

AddEventHandler(
  "onResourceStart",
  function()
    PlayerData = xPlayer
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	local PlayerData = ESX.GetPlayerData()
	
	if PlayerData == nil then
		PlayerData = ESX.GetPlayerData()
    		PlayerData.job = job
		print ('Kofferbak kan beroep niet synchroniseren. Dit is niet erg.')  -- Cannot sync job, not bad
	else
		print ('Kofferbak heeft je beroep gesynchroniseerd.') -- Can sync job
		PlayerData.job = job
	end
end)

RegisterNetEvent("esx_trunk_inventory:setOwnedVehicule")
AddEventHandler(
  "esx_trunk_inventory:setOwnedVehicule",
  function(vehicle)
    vehiclePlate = vehicle
    --print("vehiclePlate: ", ESX.DumpTable(vehiclePlate))
  end
)

function getItemyWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = Config.DefaultWeight
    if arrayWeight[item] ~= nil then
      itemWeight = arrayWeight[item]
    end
  end
  return itemWeight
end

function VehicleInFront()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
  local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, result = GetRaycastResult(rayHandle)
  return result
end

function openmenuvehicle()
  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)
  local vehicle = VehicleInFront()
  globalplate = GetVehicleNumberPlateText(vehicle)

  if not IsPedInAnyVehicle(playerPed) then
    myVeh = false
    local thisVeh = VehicleInFront()
    PlayerData = ESX.GetPlayerData()

    for i = 1, #vehiclePlate do
      local vPlate = all_trim(vehiclePlate[i].plate)
      local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
      --print('vPlate: ',vPlate)
      --print('vFront: ',vFront)
      --if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
      if vPlate == vFront then
        myVeh = true
      elseif lastChecked < GetGameTimer() - 60000 then
        TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
        lastChecked = GetGameTimer()
        Wait(2000)
        for i = 1, #vehiclePlate do
          local vPlate = all_trim(vehiclePlate[i].plate)
          local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
          if vPlate == vFront then
            myVeh = true
          end
        end
      end
    end

    if not Config.CheckOwnership or (Config.AllowPolice and PlayerData.job.name == "police") or (Config.CheckOwnership and myVeh) then
      if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
        CloseToVehicle = true
        local vehFront = VehicleInFront()
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
        local playerPed = GetPlayerPed()

        if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
          lastVehicle = vehFront
          local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
          local locked = GetVehicleDoorLockStatus(closecar)
          local class = GetVehicleClass(vehFront)
          ESX.UI.Menu.CloseAll()

          if ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "inventory") then
            -- SetVehicleDoorShut(vehFront, 5, false)
            print('lol')
          else
            if locked == 1 or class == 15 or class == 16 or class == 14 then
              SetVehicleDoorOpen(vehFront, 5, false, false)
              ESX.UI.Menu.CloseAll()

              if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
                CloseToVehicle = true
                OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehFront), Config.VehicleWeight[class], myVeh)
                  ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, ani, 8.0, -8.0, -1, 120, 0.0, false, false, false)
                  end)
                  isplaying = true
              end

            
            else
           
            --exports['big_notify']:Notify('true', _U("trunk_closed"))
            exports['mythic_notify']:DoHudText('inform', 'Trunk is closed')
            end
          end
        else
         
            --exports['big_notify']:Notify('false', _U("no_veh_nearby"))
            exports['mythic_notify']:DoHudText('inform', 'no vehicle nearby')
        end
        lastOpen = true
        SetVehicleDoorOpen(vehFront, 5, false)
        GUI.Time = GetGameTimer()
      end
    else
      -- Not their vehicle
    
           -- exports['big_notify']:Notify('false', _U("nacho_veh"))
            exports['mythic_notify']:DoHudText('inform', 'vehicle does not belong to you')
    end
  end
end
local count = 0

-- Key controls
Citizen.CreateThread(
  function()
    while true do
      Wait(0)
      if IsControlJustReleased(0, Config.OpenKey) and (GetGameTimer() - GUI.Time) > 1000 then
        openmenuvehicle()
        GUI.Time = GetGameTimer()
      end
    end
    if isplaying == true then
      if IsControlJustReleased(0, 202) or IsControlJustReleased(0, 177) then
        StopAnimTask(PedPlayerId(), lib, ani, false)
        isplaying = false
      end
    end
  end
)

RegisterCommand("boot", function()
  openmenuvehicle()
  GUI.Time = GetGameTimer()
end)

Citizen.CreateThread(
  function()
    while true do
      Wait(0)
      local pos = GetEntityCoords(GetPlayerPed(-1))
      if CloseToVehicle then
        local vehicle = GetClosestVehicle(pos["x"], pos["y"], pos["z"], 2.0, 0, 70)
        if DoesEntityExist(vehicle) then
          CloseToVehicle = true
        else
          CloseToVehicle = false
          lastOpen = false
          ESX.UI.Menu.CloseAll()

        end
      end
    end
  end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
  "esx:playerLoaded",
  function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

function OpenCoffreInventoryMenu(plate, max, myVeh)
  ESX.TriggerServerCallback(
    "esx_trunk:getInventoryV",
    function(inventory)
      text = _U("trunk_info", plate, (inventory.weight / 100), (max / 100))
      data = {plate = plate, max = max, myVeh = myVeh, text = text}
      TriggerEvent("conde_inventory:openTrunkInventory", data, inventory.blackMoney, inventory.cashMoney, inventory.items, inventory.weapons)
    end,
    plate
  )
end

function all_trim(s)
  if s then
    return s:match "^%s*(.*)":match "(.-)%s*$"
  else
    return "noTagProvided"
  end
end

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end
