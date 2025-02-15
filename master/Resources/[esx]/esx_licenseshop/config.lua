Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100
Config.MarkerInfo = {Type = 27, r = 102, g = 102, b = 204, x = 2.0, y = 2.0, z = 1.0}
Config.BlipLicenseShop = {Sprite = 408, Color = 0, Display = 2, Scale = 1.0}

Config.EnablePeds = true -- If true then it will add Peds on Markers | false does the Opposite.
Config.RequireDMV = false -- If true then it will require players to have Drivers Permit to buy other Licenses | false does the Opposite.

Config.AdvancedVehicleShop = false -- Set to True if using esx_advancedvehicleshop
Config.LicenseAircraft = 10000
Config.LicenseBoating = 50

Config.AdvancedWeaponShop = false -- Set to true if using esx_advancedweaponshop
Config.LicenseMelee = 1
Config.LicenseHandgun = 10
Config.LicenseSMG = 100
Config.LicenseShotgun = 50
Config.LicenseAssault = 250
Config.LicenseLMG = 1000
Config.LicenseSniper = 1500

Config.DMVSchool = true -- Set to true if using esx_dmvschool
Config.SellDMV = false -- Set to true if Config.RequireDMV = false & you want players to be able to buy Drivers Permit
Config.LicenseCommercial = 5500
Config.LicenseDrivers = 5000
Config.LicenseDriversP = 2000
Config.LicenseMotocycle = 3500

Config.Drugs = true -- Set to true if using esx_drugs
Config.LicenseWeed = 10000

Config.WeaponShop = false -- Set to true if using esx_weaponshop
Config.LicenseWeapon = 10000

Config.Zones = {
	LicenseShop1 = { -- Next to esx_dmvschool
		Pos = vector3(1552.7, 3603.87, 38.78-0.90),
		Heading = 252.89
	}
}
