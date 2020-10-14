local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


local DoingBreak			  = false       -- don't touch
local GUI                     = {}          -- don't touch
ESX                           = nil         -- don't touch
GUI.Time                      = 0           -- don't touch
local PlayerData              = {}          -- don't touch
local showPro                 = false       -- don't touch
local stealing                = false       -- don't touch
local peeking                 = false       -- don't touch

------------------------------------------------------
------------------------------------------------------
--local useQalleCameraSystem    = true       --( https://github.com/qalle-fivem/esx-qalle-camerasystem )
--local chancePoliceNoti        = 50          -- the procent police get notified (only numbers like 30, 10, 40. You get it.)
--local useBlip                 = true      -- if u want blip
--local useInteractSound        = true       -- if you wanna use InteractSound (when u lockpick the door)


local text = "~g~[E]~w~ Lockpick" -- lockpick the door
local textUnlock = "~g~[E]~w~ Enter" -- enter the house
local insideText = "~g~[E]~w~ Exit" -- exit the door
local searchText = "~g~[E]~w~ Search" -- search the spot
local emptyMessage = "There is nothing here!" -- if you press E where it is empty
local emptyMessage3D = "~r~Empty" -- if the spot is empty
local closetText = "~g~[E]~w~ Peek into closet" -- text at closet

local lockpickQuestionText = "Do you want to lockpick?" -- confirmation menu title
local noLockpickText = "You don't have any lockpick!" -- if you don't have a lockpick and you try to do the burglary
local yesText = "Yes" -- in confirmation menu
local noText = "No" -- -- in confirmation menu

local shirt = "Shirt" -- in menu and notification
local pants = "Pants" -- -- in menu and notification
local hat = "Hat" -- -- in menu and notification
local shoes = "Shoes" -- -- in menu and notification

local youFound = "You found" -- when you steal something

local PlayerData              = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

local search = {
    ["C4"] = { x = 2344.03, y = 3070.01, z = 48.15, item = 'c4_bank', amount = math.random(1,2)},
    ["C41"] = { x = 2371.66, y = 3081.75, z = 48.15, item = 'c4_bank', amount = math.random(0,2)},
    ["RaspberryChip"]  = {x = 2341.4, y = 3045.1, z = 48.15, item = 'raspberry', amount = math.random(2,4)},

}

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      for k,v in pairs(search) do
        local playerPed = PlayerPedId()
        local house = k
        local coords = GetEntityCoords(playerPed)
      end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5000)
--    if stealing == true then
      if showPro == true then
      TriggerEvent('Heist')
      Citizen.Wait(1)
      local Q = true
    elseif Q == true then
      Citizen.SetTimeout(3000)
      --print("hello")
    else
      --print("looped")
    end
  end
end)
  

Citizen.CreateThread(function()
    while stealing == false do
      Citizen.Wait(5)
      for k,v in pairs(search) do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist   = GetDistanceBetweenCoords(v.x, v.y, v.z, coords.x, coords.y, coords.z, false)
          if dist <= 1.2 and v.amount > 0 then
            DrawText3D(v.x, v.y, v.z, searchText, 0.4)
            if dist <= 0.5 and IsControlJustPressed(0, Keys["E"]) then
              steal(k)
            end
        elseif v.amount < 1 and dist <= 1.2 then
          DrawText3D(v.x, v.y, v.z, emptyMessage3D, 0.4)
          if IsControlJustPressed(0, Keys["E"]) and dist <= 0.5 then 
            ESX.ShowNotification(emptyMessage)
          end
        end
      end
    end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(6)
    if showPro == true then
      local playerPed = PlayerPedId()
		  local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
	end
end)

function steal(k)
    local values = GetHouseValues(k, search)
    local playerPed = PlayerPedId()
    stealing = true
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(2000)
    procent(50)
    if values.amount >= 2 then
      local rndm = math.random(1,2)
      TriggerServerEvent('Heist:Add', values.item, rndm)
        ESX.ShowNotification( youFound .. ' ' .. rndm  .. ' ' .. k)
        values.amount = values.amount - rndm
    else
      TriggerServerEvent('Heist:Add', values.item, 1)
        ESX.ShowNotification(youFound .. ' 1 ' .. k)
        values.amount = values.amount - 1
    end
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    stealing = false
end

function SetCoords(playerPed, x, y, z)
    SetEntityCoords(playerPed, x, y, z)
    Citizen.Wait(100)
    SetEntityCoords(playerPed, x, y, z)
end

function fade()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
end

function loaddict(dict)
    while not HasAnimDictLoaded(dict) do
      RequestAnimDict(dict)
      Wait(10)
    end
end

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
  
    local factor = (string.len(text)) / 270
    DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function procent(time)
    showPro = true
    TimeLeft = 0
    repeat
    TimeLeft = TimeLeft + 1        -- thank you (github.com/Loffes)
    Citizen.Wait(time)
    until(TimeLeft == 100)
    showPro = false
end

function GetHouseValues(house, pair)
    for k,v in pairs(pair) do
        if k == house then
            return v
        end
    end
end




local teams = {
  {name = "enemies", model = "g_m_m_chicold_01", weapon = "WEAPON_COMBATPISTOL"},
  {name = "enemies2", model = "g_m_m_chicold_01", weapon = "WEAPON_HEAVYPISTOL"}
}

local j = nil

for i = 1, #teams, 1 do
  AddRelationshipGroup(teams[i].name)
end

RegisterNetEvent('Heist')
AddEventHandler('Heist', function()
  local totalPeople = 10
  for i=1, totalPeople, 1 do
      j = math.random(1,#teams)
      local ped = GetHashKey(teams[j].model)
      RequestModel(ped)
      while not HasModelLoaded(ped) do
          Citizen.Wait(1)
      end

      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
      newPed = CreatePed(4, ped, x+20+math.random(-totalPeople, totalPeople), y+20+math.random(-totalPeople,totalPeople), z, 0.0, false, true)
      SetPedCombatAttributes(newPed, 5, true)
      SetPedCombatAttributes(newPed, 46, true)
      SetPedRelationshipGroupHash(newPed, GetHashKey(teams[j].name))
      SetRelationshipBetweenGroups(0, GetHashKey(teams[1].name), GetHashKey(teams[2].name))

      if teams[j].name == "enemies" then
          SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
          SetPedAccuracy(newPed, math.random(40, 80))
      else
          SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
      end
      GiveWeaponToPed(newPed, GetHashKey(teams[j].weapon), 250, true, false)
      TaskStartScenarioInPlace(newPed, "WORLD_HUMAN_SMOKING", 0, true)
      SetPedArmour(newPed, 50)
      SetPedMaxHealth(newPed, 100)
      TaskCombatPed(newPed, GetPlayerPed(-1), 0, 16)
      SetPedDropsWeaponsWhenDead(newPed, false)
  end
end)

------------------------blips---------------------------
--[[ Citizen.CreateThread(function()
  --for i=1, #Config.Zones, 1 do
    --local blip = AddBlipForCoord(Config.Zones[i])
    local blip = AddBlipForCoord(vector3(2341, 3045, 48))
		SetBlipSprite (blip, 418)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('Scrapyard')
    EndTextCommandSetBlipName(blip)
  --end
end) ]]

