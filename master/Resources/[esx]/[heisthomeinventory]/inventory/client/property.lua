local propertyData
local propertyName

RegisterNetEvent("conde_inventory:openPropertyInventory")
AddEventHandler(
    "conde_inventory:openPropertyInventory",
    function(data)
        propertyName = data.inventory_name
        setPropertyInventoryData(data)
        openPropertyInventory()
    end
)

function refreshPropertyInventory()
    ESX.TriggerServerCallback(
            "disc-property:getPropertyInventoryFor",
            function(data)
                setDiscPropertyInventoryData(data)
            end,
            propertyName
    )
end

function setPropertyInventoryData(data)
    propertyData = data
    items = {}

    local accounts = data.item_account or {}
    local moneys = data.item_money or {}
    local propertyItems = data.item_standard or {}
    local propertyWeapons = data.item_weapon or {}

    for i = 1, #accounts, 1 do
        local account = accounts[i]
        accountData = {
            label = _U(account.name),
            count = account.count,
            type = "item_account",
            name = account.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #moneys, 1 do
        local money = moneys[i]
        accountData = {
            label = _U(money.name),
            count = money.count,
            type = "item_money",
            name = money.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.label = item.name
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                    items,
                    {
                        label = ESX.GetWeaponLabel(weapon.name),
                        count = weapon.count,
                        limit = -1,
                        type = "item_weapon",
                        name = weapon.name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    }
            )
        end
    end

    SendNUIMessage(
            {
                action = "setSecondInventoryItems",
                itemList = items
            }
    )
end

function openPropertyInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "property"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoProperty",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("esx_property:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
        end

        Wait(150)
        refreshPropertyInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromProperty",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TriggerServerEvent("esx_property:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
            openPropertyInventory() --Apparently switches INSTANTLY to your own property inventory when you try to drop/take items from an other one's. You can't duplicate anymore.
        end

        Wait(150)
        refreshPropertyInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)
