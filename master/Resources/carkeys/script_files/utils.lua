-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 
ESX = nil

-- Police Notify:
local isCop = false
local streetName
local _

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	isCop = IsPlayerJobCop()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	isCop = IsPlayerJobCop()
end)

-- [[ ESX SHOW ADVANCED NOTIFICATION ]] --
RegisterNetEvent('t1ger_keys:ShowAdvancedNotifyESX')
AddEventHandler('t1ger_keys:ShowAdvancedNotifyESX', function(title, subject, msg, icon, iconType)
	ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType)
	-- If you want to switch ESX.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
	
end)

-- [[ ESX SHOW NOTIFICATION ]] --
RegisterNetEvent('t1ger_keys:ShowNotifyESX')
AddEventHandler('t1ger_keys:ShowNotifyESX', function(msg)
	ShowNotifyESX(msg)
end)

function ShowNotifyESX(msg)
	--ESX.ShowNotification(msg)
	exports['mythic_notify']:DoHudText('inform', msg)
	-- If you want to switch ESX.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
end

-- [[ POLICE ALERTS ]] --
function NotifyPoliceFunction()
	TriggerServerEvent('t1ger_keys:PoliceNotifySV',GetEntityCoords(GetPlayerPed(-1)),streetName)
	-- If you want to use your own alert:
	-- 1) Comment out the 'TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)'
	-- 2) replace whatever even you use to trigger your alert.
	
end

function AlertPoliceFunction(stolenCar)
	if DoesEntityExist(stolenCar) then
		local plate = GetVehicleNumberPlateText(stolenCar)
		local make = GetDisplayNameFromVehicleModel(GetEntityModel(stolenCar))
		local color1, color2 = GetVehicleColours(stolenCar)
		local headi = getCardinalDirectionFromHeading(stolenCar)
		local plyPos = GetEntityCoords(PlayerPedId())
		if color1 == 0 then color1 = 1 end
		if color2 == 0 then color2 = 2 end
		if color1 == -1 then color1 = 158 end
		if color2 == -1 then color2 = 158 end
		TriggerServerEvent('dispatch:svNotify', {
				dispatchCode = '10-67 B',
				firstStreet = streetName,
				esxder = esxder,
				model = make,
				plate = plate,
				--firstColor = data.firstColor,
				--secondColor = data.secondColor,
				heading = headi,
				isImportant = false,
				priority = 1,
				dispatchMessage = "Vehicle Theft",
				origin = {
				x = plyPos.x,
				y = plyPos.y,
				z = plyPos.z
				}
			})
		--local vehicleinformation = "^0^*Armed^r Grand Theft Auto at ^3"..streetName.."^0 | ^6Make: ^0^*"..make.." | ^6Plate: ^0^*" .. plate .. " | ^6Colors: ^0^*" .. colors[color1] .. " ^6on ^0^*" .. colors[color2] 
		--TriggerServerEvent("t1ger_keys:PoliceNotifySV2", GetEntityCoords(GetPlayerPed(-1)), streetName, vehicleinformation)
	end
	-- If you want to use your own alert:
	-- 1) Comment out the 'TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)'
	-- 2) replace whatever even you use to trigger your alert.
	
end
function AlertPoliceFunction2(stolenCar)
	if DoesEntityExist(stolenCar) then
		local plate = GetVehicleNumberPlateText(stolenCar)
		local make = GetDisplayNameFromVehicleModel(GetEntityModel(stolenCar))
		local color1, color2 = GetVehicleColours(stolenCar)
		local headi = getCardinalDirectionFromHeading(stolenCar)
		local plyPos = GetEntityCoords(PlayerPedId())
		if color1 == 0 then color1 = 1 end
		if color2 == 0 then color2 = 2 end
		if color1 == -1 then color1 = 158 end
		if color2 == -1 then color2 = 158 end
		TriggerServerEvent('dispatch:svNotify', {
				dispatchCode = '10-67 A',
				firstStreet = streetName,
				esxder = esxder,
				model = make,
				plate = plate,
				--firstColor = data.firstColor,
				--secondColor = data.secondColor,
				heading = headi,
				isImportant = false,
				priority = 1,
				dispatchMessage = "Vehicle Theft",
				origin = {
				x = plyPos.x,
				y = plyPos.y,
				z = plyPos.z
				}
			})
		--local vehicleinformation = "^0^*Armed^r Grand Theft Auto at ^3"..streetName.."^0 | ^6Make: ^0^*"..make.." | ^6Plate: ^0^*" .. plate .. " | ^6Colors: ^0^*" .. colors[color1] .. " ^6on ^0^*" .. colors[color2] 
		--TriggerServerEvent("t1ger_keys:PoliceNotifySV2", GetEntityCoords(GetPlayerPed(-1)), streetName, vehicleinformation)
	end
	-- If you want to use your own alert:
	-- 1) Comment out the 'TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)'
	-- 2) replace whatever even you use to trigger your alert.
	
end

function getCardinalDirectionFromHeading()
    local heading = GetEntityHeading(PlayerPedId())
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
	end
end


RegisterNetEvent('t1ger_keys:PoliceNotifyCL')
AddEventHandler('t1ger_keys:PoliceNotifyCL', function(alert)
	if isCop then
		TriggerEvent('chat:addMessage', { args = {(Lang['dispatch_name']).. alert}})
	end
end)

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

RegisterNetEvent('t1ger_keys:PoliceNotifyBlip')
AddEventHandler('t1ger_keys:PoliceNotifyBlip', function(targetCoords)
	if isCop then 
		for k,v in pairs(Config.AlertBlip) do
			if v.Enable then
				local copBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, v.Radius)
				SetBlipHighDetail(copBlip, true)
				SetBlipColour(copBlip, v.Color)
				SetBlipAlpha(copBlip, v.Alpha)
				SetBlipAsShortRange(copBlip, true)
				while v.Alpha ~= 0 do
					Citizen.Wait(v.Time * 4)
					v.Alpha = v.Alpha - 1
					SetBlipAlpha(copBlip, v.Alpha)

					if v.Alpha == 0 then
						RemoveBlip(copBlip)
						return
					end
				end
			end
		end
	end
end)

-- Map Blips:
Citizen.CreateThread(function()
	for k,v in pairs(Config.Locksmith) do
		CreateMapBlip(k,v)
	end	
	for k,v in pairs(Config.AlarmShop) do
		CreateMapBlip(k,v)
	end	
end)

function CreateMapBlip(k,v)
	if v.Blip.Enable then
		local blip = AddBlipForCoord(v.Blip.Pos[1], v.Blip.Pos[2], v.Blip.Pos[3])
		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Blip.Name)
		EndTextCommandSetBlipName(blip)
	end
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z+1)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.43, 0.43)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function IsPlayerJobCop()	
	if not PlayerData then return false end
	if not PlayerData.job then return false end
	for k,v in pairs(Config.AllowedJobs) do
		if PlayerData.job.name == v then return true end
	end
	return false
end


colors = {
--[0] = "Metallic Black",

[1] = "Metallic Graphite Black",

[2] = "Metallic Black Steal",

[3] = "Metallic Dark Silver",

[4] = "Metallic Silver",

[5] = "Metallic Blue Silver",

[6] = "Metallic Steel Gray",

[7] = "Metallic Shadow Silver",

[8] = "Metallic Stone Silver",

[9] = "Metallic Midnight Silver",

[10] = "Metallic Gun Metal",

[11] = "Metallic Anthracite Grey",

[12] = "Matte Black",

[13] = "Matte Gray",

[14] = "Matte Light Grey",

[15] = "Util Black",

[16] = "Util Black Poly",

[17] = "Util Dark silver",

[18] = "Util Silver",

[19] = "Util Gun Metal",

[20] = "Util Shadow Silver",

[21] = "Worn Black",

[22] = "Worn Graphite",

[23] = "Worn Silver Grey",

[24] = "Worn Silver",

[25] = "Worn Blue Silver",

[26] = "Worn Shadow Silver",

[27] = "Metallic Red",

[28] = "Metallic Torino Red",

[29] = "Metallic Formula Red",

[30] = "Metallic Blaze Red",

[31] = "Metallic Graceful Red",

[32] = "Metallic Garnet Red",

[33] = "Metallic Desert Red",

[34] = "Metallic Cabernet Red",

[35] = "Metallic Candy Red",

[36] = "Metallic Sunrise Orange",

[37] = "Metallic Classic Gold",

[38] = "Metallic Orange",

[39] = "Matte Red",

[40] = "Matte Dark Red",

[41] = "Matte Orange",

[42] = "Matte Yellow",

[43] = "Util Red",

[44] = "Util Bright Red",

[45] = "Util Garnet Red",

[46] = "Worn Red",

[47] = "Worn Golden Red",

[48] = "Worn Dark Red",

[49] = "Metallic Dark Green",

[50] = "Metallic Racing Green",

[51] = "Metallic Sea Green",

[52] = "Metallic Olive Green",

[53] = "Metallic Green",

[54] = "Metallic Gasoline Blue Green",

[55] = "Matte Lime Green",

[56] = "Util Dark Green",

[57] = "Util Green",

[58] = "Worn Dark Green",

[59] = "Worn Green",

[60] = "Worn Sea Wash",

[61] = "Metallic Midnight Blue",

[62] = "Metallic Dark Blue",

[63] = "Metallic Saxony Blue",

[64] = "Metallic Blue",

[65] = "Metallic Mariner Blue",

[66] = "Metallic Harbor Blue",

[67] = "Metallic Diamond Blue",

[68] = "Metallic Surf Blue",

[69] = "Metallic Nautical Blue",

[70] = "Metallic Bright Blue",

[71] = "Metallic Purple Blue",

[72] = "Metallic Spinnaker Blue",

[73] = "Metallic Ultra Blue",

[74] = "Metallic Bright Blue",

[75] = "Util Dark Blue",

[76] = "Util Midnight Blue",

[77] = "Util Blue",

[78] = "Util Sea Foam Blue",

[79] = "Uil Lightning blue",

[80] = "Util Maui Blue Poly",

[81] = "Util Bright Blue",

[82] = "Matte Dark Blue",

[83] = "Matte Blue",

[84] = "Matte Midnight Blue",

[85] = "Worn Dark blue",

[86] = "Worn Blue",

[87] = "Worn Light blue",

[88] = "Metallic Taxi Yellow",

[89] = "Metallic Race Yellow",

[90] = "Metallic Bronze",

[91] = "Metallic Yellow Bird",

[92] = "Metallic Lime",

[93] = "Metallic Champagne",

[94] = "Metallic Pueblo Beige",

[95] = "Metallic Dark Ivory",

[96] = "Metallic Choco Brown",

[97] = "Metallic Golden Brown",

[98] = "Metallic Light Brown",

[99] = "Metallic Straw Beige",

[100] = "Metallic Moss Brown",

[101] = "Metallic Biston Brown",

[102] = "Metallic Beechwood",

[103] = "Metallic Dark Beechwood",

[104] = "Metallic Choco Orange",

[105] = "Metallic Beach Sand",

[106] = "Metallic Sun Bleeched Sand",

[107] = "Metallic Cream",

[108] = "Util Brown",

[109] = "Util Medium Brown",

[110] = "Util Light Brown",

[111] = "Metallic White",

[112] = "Metallic Frost White",

[113] = "Worn Honey Beige",

[114] = "Worn Brown",

[115] = "Worn Dark Brown",

[116] = "Worn straw beige",

[117] = "Brushed Steel",

[118] = "Brushed Black steel",

[119] = "Brushed Aluminium",

[120] = "Chrome",

[121] = "Worn Off White",

[122] = "Util Off White",

[123] = "Worn Orange",

[124] = "Worn Light Orange",

[125] = "Metallic Securicor Green",

[126] = "Worn Taxi Yellow",

[127] = "police car blue",

[128] = "Matte Green",

[129] = "Matte Brown",

[130] = "Worn Orange",

[131] = "Matte White",

[132] = "Worn White",

[133] = "Worn Olive Army Green",

[134] = "Pure White",

[135] = "Hot Pink",

[136] = "Salmon pink",

[137] = "Metallic Vermillion Pink",

[138] = "Orange",

[139] = "Green",

[140] = "Blue",

[141] = "Mettalic Black Blue",

[142] = "Metallic Black Purple",

[143] = "Metallic Black Red",

[144] = "hunter green",

[145] = "Metallic Purple",

[146] = "Metaillic V Dark Blue",

[147] = "MODSHOP BLACK1",

[148] = "Matte Purple",

[149] = "Matte Dark Purple",

[150] = "Metallic Lava Red",

[151] = "Matte Forest Green",

[152] = "Matte Olive Drab",

[153] = "Matte Desert Brown",

[154] = "Matte Desert Tan",

[155] = "Matte Foilage Green",

[156] = "DEFAULT ALLOY COLOR",

[157] = "Epsilon Blue",

[158] = "Unknown",

}