function OpenCupboard(room)
    TriggerEvent("conde_inventory:openPropertyInventory", {
        type = 'cupboard',
        owner = room
    })
end
