ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local beds = {
    --{ x = 324.26, y = -582.8, z = 44.2, h = 344.15, taken = false },
    { x = 319.41, y = -581.04, z = 44.2, h = 344.15, taken = false },
    { x = 313.93, y = -579.04, z = 44.2, h = 344.15, taken = false },
	{ x = 309.34, y = -577.41, z = 44.2, h = 344.15, taken = false },
	{ x = 307.72, y = -581.75, z = 44.2, h = 155.54, taken = false },
	{ x = 311.06, y = -582.96, z = 44.2, h = 155.54, taken = false },
	{ x = 314.47, y = -584.2, z = 44.2, h = 155.54, taken = false },
	{ x = 317.67, y = -585.37, z = 44.2, h = 155.54, taken = false },
	{ x = 322.62, y = -587.17, z = 44.2, h = 155.54, taken = false },
	--{ x = 357.34, y = -594.45, z = 43.11, h = 160.0, taken = false },
--{ x = 350.80, y = -591.72, z = 43.11, h = 160.0, taken = false },
	--{ x = 346.89, y = -591.01, z = 42.58, h = 160.0, taken = false },
}

local bedsTaken = {}
local injuryBasePrice = 100

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function()
    for k, v in pairs(beds) do
        if not v.taken then
            v.taken = true
            bedsTaken[source] = k
            TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
            return
        end
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No Beds Available' })
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
    local foundbed = false
    for k, v in pairs(beds) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 3.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', bedID)
				
                return
            else
                TriggerEvent('mythic_chat:server:System', source, 'That Bed Is Taken')
            end
        end
    end

    if not foundbed then
        TriggerEvent('mythic_chat:server:System', source, 'Not Near A Hospital Bed')
    end
end)

RegisterServerEvent('mythic_hospital:server:bill')
AddEventHandler('mythic_hospital:server:bill', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local bill = 550
	xPlayer.removeAccountMoney("bank", 550)
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local injuries = GetCharsInjuries(src)

    local totalBill = injuryBasePrice

    if injuries ~= nil then
        for k, v in pairs(injuries.limbs) do
            if v.isDamaged then
                totalBill = totalBill + (injuryBasePrice * v.severity)
            end
        end

        if injuries.isBleeding > 0 then
            totalBill = totalBill + (injuryBasePrice * injuries.isBleeding)
        end
    end

	local xPlayer = ESX.GetPlayerFromId(src)
    --xPlayer.removeMoney(totalBill)
    xPlayer.removeAccountMoney('bank', 550)
	--account.removeMoney(totalBill)
	--exports['mythic_notify']:DoHudText('inform', 'You were Charged ' ..totalBill
	--Citizen.Wait(500)
	--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You Were Charged 1500$' })
	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	TriggerClientEvent('mythic_hospital:client:Healing', src)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)
RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) == 'boolean' then
	--[[	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})]]
	end
end)
