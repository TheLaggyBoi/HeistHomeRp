Config = {}
Config.Locale = "en"
Config.IncludeCash = false -- Include cash in inventory?
Config.IncludeWeapons = false -- Include weapons in inventory?
Config.IncludeAccounts = true -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.OpenControl = 289 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.
Config.MaxWeight = 250 --SAME AS THE DEFAULT ON ES EXTENDED CONFIG

-- List of item names that will close ui when used
Config.CloseUiItems = {
    "phone", "hamburger", "water", "bread", "cupcake", "cigarette", "weed_seed", "tunerchip", "fixkit", "medikit", "repairkit", "carokit", "joint", "meth", "marijuana", 
}

Config.ShopBlipID = 52
Config.LiquorBlipID = 93
Config.YouToolBlipID = 402
Config.PrisonShopBlipID = 52
Config.WeedStoreBlipID = 140
Config.WeaponShopBlipID = 110
Config.PoliceShopShopBlipID = 110

Config.ShopLength = 14
Config.LiquorLength = 10
Config.YouToolLength = 2
Config.PrisonShopLength = 2
Config.PoliceShopLength = 2

Config.Color = 0
Config.WeaponColor = 1

Config.WeaponLiscence = {x = 451.48, y = -973.13, z = 30.68}
Config.LicensePrice = 5000

Config.Shops = {
    RegularShop = {
        Locations = {
            { x = 373.875, y = 325.896, z = 102.566 },
            --{ x = -1104.52, y = -821.67, z = 13.28 },
            { x = 2557.458, y = 382.282, z = 107.622 },
            { x = -3038.939, y = 585.954, z = 6.908 },
            { x = -3241.927, y = 1001.462, z = 11.830 },
            { x = 547.431, y = 2671.710, z = 41.156 },
            { x = 1961.464, y = 3740.672, z = 31.343 },
            { x = 2678.916, y = 3280.671, z = 54.241 },
            { x = 1729.216, y = 6414.131, z = 34.037 },
            { x = -48.519, y = -1757.514, z = 28.421 },
            { x = 1163.373, y = -323.801, z = 68.205 },
            { x = -707.501, y = -914.260, z = 18.215 },
            { x = -1820.523, y = 792.518, z = 137.118 },
            { x = 1698.388, y = 4924.404, z = 41.063 },
            { x = 25.723, y = -1346.966, z = 28.497 },
            --{ x = 268.26, y = -979.44, z = 28.37 },
        },
        Items = {
            { name = 'bread' , price = 10},
            { name = 'water', price = 15},
            {name = 'hamburger', price = 30},
            {name = 'donut', price = 10},
            {name = 'energetic', price = 35 },   
            {name = 'phone', price = 300},
            {name = 'cupcake', price = 5},
            {name = 'cigarette', price = 5},            
            {name = 'bandage', price = 25},
            {name = 'medikit', price = 150}
       
        }
    },

    IlegalShop = {
        Locations = {
            { x = 459.34, y = -979.09, z = 30.69 },
            { x = 461.5, y = -981.09, z = 30.69 },
        },
        Items = {
            {name = 'hamburger', price = 30},
            {name = 'donut', price = 10},
            {name = 'water', price = 15 },
            {name = 'energetic', price = 35 },
            {name = 'cuffkeys', price = 55 },             
            {name = 'phone', price = 300 },
            {name = "bulletproof", price = 800},
            {name = "radio", price = 50},
            {name = 'parachute', price = 50},
            {name = "WEAPON_FLASHLIGHT", price = 50},
            {name = "WEAPON_KNIFE", price = 200},
            {name = "WEAPON_STUNGUN", price = 300},
            {name = "WEAPON_PISTOL", price = 500},
            {name = "WEAPON_COMBATPISTOL", price = 500},
            {name = "WEAPON_APPISTOL", price = 1500},
            {name = "WEAPON_SMG", price = 2000},
            {name = "WEAPON_CARBINERIFLE", price = 3000},
            {name = "disc_ammo_pistol", price = 100},
            {name = "disc_ammo_pistol_large", price = 300},
            {name = "disc_ammo_smg", price = 200},
            {name = "disc_ammo_smg_large", price = 500},
            {name = "disc_ammo_rifle", price = 300},
            {name = "disc_ammo_rifle_large", price = 800}
        }
    },

    RobsLiquor = {
        Locations = {
            { x = 1135.808, y = -982.281, z = 45.415 },
            { x = -1222.915, y = -906.983, z = 11.326 },
            { x = -1487.553, y = -379.107, z = 39.163 },
            { x = -2968.243, y = 390.910, z = 14.043 },
            { x = 1166.024, y = 2708.930, z = 37.157 },
            { x = 1392.562, y = 3604.684, z = 33.980 },
            { x = -1393.409, y = -606.624, z = 29.319 }
        },
        Items = {
            { name = 'cigarette', price = 5},
            { name = 'icetea', price = 10},
            { name = 'beer',price = 15},
            { name = 'whisky', price = 50},
            { name = 'tequila', price = 60},
            { name = 'vodka', price = 70}

        }
    },

    YouTool = {
        Locations = {
            { x = 46.64, y = -1749.71, z = 29.63 },
        },
        Items = {
            {name = 'fixkit', price = 2500}, -- add more items here
            {name = 'parachute', price = 50},            
            {name = 'oxygen_mask', price = 200},
            {name = 'binoculars', price = 50},
            {name = 'lockpick', price = 200},
            {name = 'handcuffs', price = 1200},
        }
    },

    PrisonShop = {
        Locations = {
            { x = -1278.05, y = -1094.1, z = 7.39 },
        },
        Items = {
            {name = 'handcuffs', price = 1200}, 
            {name = 'darknet', price = 2500}
        }
    },

--     WeaponShop = {
--         Locations = {
--             { x = -662.180, y = -934.961, z = 20.829 },
--             { x = 21.79, y = -1106.72, z = 29.80 }
          
--         },
--         Weapons = {
--             {name = "WEAPON_BAT", price = 10},
--             {name = "WEAPON_KNUCKLE", price = 50},
--             {name = "WEAPON_FLASHLIGHT", price = 10},
--             {name = "WEAPON_KNIFE", price = 100},
--             {name = "WEAPON_STUNGUN", price = 300},
--             {name = "WEAPON_PISTOL", price = 1000},
--             {name = "WEAPON_COMBATPISTOL", price = 1500},
--             {name = "WEAPON_APPISTOL", price = 4500},
--             {name = "WEAPON_SMG", price = 10000}
-- --[[        {name = "WEAPON_ADVANCEDRIFLE", price = 45},
--             {name = "WEAPON_ASSAULTRIFLE", price = 45},
--             {name = "WEAPON_ASSAULTSHOTGUN", price = 25},
--             {name = "WEAPON_ASSAULTSMG", price = 45},
--             {name = "WEAPON_AUTOSHOTGUN", price = 45},
--             {name = "WEAPON_CARBINERIFLE", price = 25}, ]]
-- --[[        {name = "WEAPON_PUMPSHOTGUN", price = 25} ]]
--         },

--         Items = {
--             {name = "disc_ammo_pistol", price = 300},
--             {name = "disc_ammo_pistol_large", price = 1000},
--             {name = "disc_ammo_smg", price = 4500},
--             {name = "disc_ammo_smg_large", price = 25000},
            
--         }
--     },
    WeaponShop = {

        Locations = {

            { x = 22.09, y = -1107.28, z = 29.80 },

            { x = -662.180, y = -934.961, z = 20.829 }

        

        },

        Weapons = {

            { name = "WEAPON_PISTOL", price = 2000},

            { name = "WEAPON_STUNGUN", price = 500},

            { name = "WEAPON_VINTAGEPISTOL", price = 3500},

            { name = "WEAPON_KNIFE", price = 500},

            { name = "WEAPON_SWITCHBLADE", price = 600},

            { name = "WEAPON_FLASHLIGHT", price = 50},

            { name = "WEAPON_BAT", price = 100}



        },

        Ammo = {

            -- { name = "disc_ammo_pistol", price = 300},

            -- { name = "disc_ammo_pistol_large", price = 1000},

            -- { name = "disc_ammo_smg", price = 4500},

            -- { name = "disc_ammo_smg_large", price = 25000}

        },

        Items = {

           { name = "bulletproof", price = 800},

           { name = "disc_ammo_pistol", price = 150},

           { name = "disc_ammo_smg", price = 1000},

           { name = "disc_ammo_rifle", price = 1500}

        }

    },

    LicenseShop = {
        Locations = {
            {x = 451.48, y = -973.13, z = 30.68}
        }
    },

    PoliceShop = {
       Locations = {
            --{ x = 461.5, y = -981.09, z = 30.69 },

        },
        Items = {
        }
}
}

Config.Throwables = {
    WEAPON_MOLOTOV = 615608432,
    WEAPON_GRENADE = -1813897027,
    WEAPON_STICKYBOMB = 741814745,
    WEAPON_PROXMINE = -1420407917,
    WEAPON_SMOKEGRENADE = -37975472,
    WEAPON_PIPEBOMB = -1169823560,
    WEAPON_FLARE = 1233104067,
    WEAPON_SNOWBALL = 126349499
}

Config.FuelCan = 883325847

Config.PropList = {
    cash = {["model"] = 'prop_cash_pile_02', ["bone"] = 28422, ["x"] = 0.02, ["y"] = 0.02, ["z"] = -0.08, ["xR"] = 270.0, ["yR"] = 180.0, ["zR"] = 0.0}
}