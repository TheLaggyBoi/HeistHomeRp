Config = {}

Config.AlignMenu = "center" -- this is where the menu is located [left, right, center, top-right, top-left etc.]

Config.CreateTableInDatabase = true -- enable this the first time you start the script, this will create everything in the database.

Config.MotelPrice = 10000-- this is the price that you will pay when you buy the motel.
Config.KeyPrice = 500 -- this is the price for each key that you want to buy.

Config.Weapons = true -- enable this if you want weapons in the storage.
Config.DirtyMoney = true -- enable this if you want dirty money in the storage.

Config.Debug = true -- enable this only if you know what you're doing.

Config.MotelInterior = {
    ["exit"] = vector3(151.34562683105, -1007.6842041016, -99.0),
    ["wardrobe"] = vector3(151.74401855469, -1001.3790283203, -99.0),
    ["invite"] = vector3(152.84375, -1007.8104248047, -99.0)
}

Config.ActionLabel = {
    ["exit"] = "Exit",
    ["wardrobe"] = "Wardrobe",
    ["invite"] = "Invite"
}

Config.LandLord = {
    ["position"] = vector3(-1477.14, -674.39, 29.04), 
    ["position2"] = vector3(313.14, -224.99, 54.22)
}

Config.MotelsEntrances = { -- every motel entrance, add more if you want another one.
    [1] = vector3(-1493.73, -668.37, 29.03),
    [2] = vector3(-1498.08, -664.65, 29.03),
    [3] = vector3(-1495.28, -661.55, 29.03),
    [4] = vector3(-1490.71, -658.2, 29.03),
    [5] = vector3(-1486.73, -655.33, 29.58),
    [6] = vector3(-1482.18, -652, 29.58),
    [7] = vector3(-1478.12, -649.17, 29.58),
    [8] = vector3(-1473.54, -645.76, 29.58),
    [9] = vector3(-1469.63, -642.91, 29.58),
    [10] = vector3(-1465.01, -639.53, 29.58),
    [11] = vector3(-1461.22, -640.96, 29.58),
    [12] = vector3(-1452.38, -653.06, 29.58),
    [13] = vector3(-1454.49, -656.02, 29.58),
    [14] = vector3(-1458.96, -659.25, 29.58),
    [15] = vector3(-1462.91, -662.18, 29.58),
    [16] = vector3(-1467.58, -665.59, 29.58),
    [17] = vector3(-1471.57, -668.37, 29.58),
    [18] = vector3(-1461.27, -640.9, 33.38),
    [19] = vector3(-1457.89, -645.54, 33.38),
    [20] = vector3(-1455.72, -648.56, 33.38),
    [21] = vector3(-1452.37, -653.25, 33.38),
    [22] = vector3(-1454.38, -655.96, 33.38),
    [23] = vector3(-1459.1, -659.3, 33.38),
    [24] = vector3(-1462.96, -662.12, 33.38),
    [25] = vector3(-1467.52, -665.51, 33.38),
    [26] = vector3(-1471.67, -668.43, 33.28),
    [27] = vector3(-1476.11, -671.66, 33.38),
    [28] = vector3(-1465.08, -639.63, 33.38),
    [29] = vector3(-1469.71, -642.99, 33.38),
    [30] = vector3(-1473.68, -645.84, 33.38),
    [31] = vector3(-1478.11, -649.16, 33.38),
    [32] = vector3(-1482.2, -652.02, 33.38),
    [33] = vector3(-1486.84, -655.46, 33.38),
    [34] = vector3(-1490.75, -658.29, 33.38),
    [35] = vector3(-1495.35, -661.59, 33.38),
    [36] = vector3(-1498.06, -664.57, 33.38),
    [37] = vector3(-1493.7, -668.27, 33.38),
    [38] = vector3(-1489.81, -671.42, 33.38),
    [39] = vector3(329.3, -225.2, 54.22),
    [40] = vector3(334.96, -227.37, 54.22),
    [41] = vector3(337.13, -224.78, 54.22),
    [42] = vector3(339.24, -219.45, 54.22),
    [43] = vector3(340.99, -214.86, 54.22),
    [44] = vector3(343.01, -209.62, 54.22),
    [45] = vector3(344.73, -205.15, 54.22),
    [46] = vector3(321.29,-196.93, 54.22),
    [47] = vector3(319.28, -196.26, 54.22),
    [48] = vector3(313.27, -198.09, 54.22),
    [49] = vector3(311.27, -203.33, 54.22)

}

-- This is the keys configuration where we can change the keys we use / add new keys.
Config.Keys = {
    ["ENTER"] = 215,

    ["ARROW LEFT"] = 174,
    ["ARROW RIGHT"] = 175,
    ["ARROW UP"] = 172,
    ["ARROW DOWN"] = 173,

    ["INSERT"] = 121,
    ["DELETE"] = 178,

    ["Q"] = 44,
    ["E"] = 38,

    ["G"] = 47,
    ["F"] = 23,

    ["X"] = 73
}

-- This is the tutorial in the left corner to show how to control the furnishing menu.
Config.HelpTextMessage = "~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~ ~INPUT_CELLPHONE_RIGHT~ Move it ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_VEH_FLY_ATTACK_CAMERA~ / ~INPUT_CELLPHONE_OPTION~ Height ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_COVER~ / ~INPUT_CONTEXT~ Turn ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_DETONATE~ Put it down ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_SPRINT~ Speed ​​Up ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_ENTER~ Open the menu ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_FRONTEND_ENDSCREEN_ACCEPT~ Save ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_VEH_DUCK~ Cancel & Delete ~n~"

UUID = function()
    math.randomseed(GetGameTimer() * math.random())

    return math.random(100000, 999999)
end