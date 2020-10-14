Config               = {}

Config.DrawDistance  = 100
Config.Size          = { x = 1.5, y = 1.5, z = 0.5 }
Config.Color         = { r = 0, g = 155, b = 253 }
Config.Type          = 23

Config.Locale        = 'en'

Config.LicenseEnable = false -- only turn this on if you are using esx_license
Config.LicensePrice  = 5000

Config.Zones = {

	GunShop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(22.0, -1107.2, 28.8),

			vector3(-662.47, -934.97, 21.83),

			vector3(252.67, -49.7, 69.94)
		}
	
	},

	BlackWeashop = {
		Legal = false,
		Items = {},
		Locations = {
			vector3(728.92, 4188.70, 39.75)
		}
	}
}
