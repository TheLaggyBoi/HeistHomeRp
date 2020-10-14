Config = {}

-- Ammo given by default to crafted weapons
Config.WeaponAmmo = 200
Config.Item = 1

Config.Recipes = {
	-- Can be a normal ESX item
--[[ 	["meth"] = { 
		{item = "methbrick", quantity = 1 }, 
		{item = "plasticbag", quantity = 5 },
	},

	["coke"] = { 
		{item = "cokebrick", quantity = 1 }, 
		{item = "plasticbag", quantity = 15 },
	},	
	 ]]
	["satellitephone"] = { 
		{item = "steel", quantity = 15 }, 
		{item = "plastic", quantity = 15 },
		{item = "wood", quantity = 15 },
		{item = "blowtorch", quantity = 1 },

	},
	
	-- Can be a weapon, must follow this format
--[[ 	['WEAPON_ASSAULTRIFLE'] = { 
		{item = "steel", quantity = 100}, 
		{item = "gunpowder", quantity = 50},
		{item = "plastic", quantity = 100},
		{item = "wood", quantity = 100},
		{item = "clip", quantity = 10},
	} ]]
}

-- Enable a shop to access the crafting menu
Config.Shop = {
	useShop = true,
	shopCoordinates = { x=962.5, y=-1585.5, z=29.6 },
	shopName = "Crafting Station",
	shopBlipID = 446,
	zoneSize = { x = 1.0, y = 1.0, z = 1.0 },
	zoneColor = { r = 255, g = 0, b = 0, a = 100 }
}

-- Enable crafting menu through a keyboard shortcut
Config.Keyboard = {
	useKeyboard = false,
	keyCode = 303
}
