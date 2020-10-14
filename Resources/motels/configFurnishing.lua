Config.MegaMall = {
    ["entrance"] = {
        ["pos"] = vector3(814.342835, -93.543252, 80.6852656),
        ["label"] = "Enter Ikea"
    },
    ["exit"] = {
        ["pos"] = vector3(1087.4390869141, -3099.419921875, -38.99995803833),
        ["label"] = "Get Out"
    },
    ["computer"] = {
        ["pos"] = vector3(1088.4245605469, -3101.2800292969, -38.99995803833),
        ["label"] = "Open the catalog."
    },
    ["object"] = {
        ["pos"] = vector3(1095.916015625, -3100.3781738281, -38.99995803833),
        ["rotation"] = vector3(0.0, 0.0, 270.0)
    }
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


Config.FurnishingPurchasables = {
    ["Beds"] = {
        ["big_double_bed"] = {
            ["label"] = "Double Bed",
            ["description"] = "Bed",
            ["price"] = 70,
            ["model"] = `apa_mp_h_bed_double_09`
        },
        ["big_black_bed"] = {
            ["label"] = "big Bed",
            ["description"] = "Bed",
            ["price"] = 90,
            ["model"] = `apa_mp_h_yacht_bed_02`
        },
        ["big_black_doublebed"] = {
            ["label"] = "Black two person bed",
            ["description"] ="Bed",
            ["price"] = 80,
            ["model"] = `apa_mp_h_bed_double_08`
        },
        ["big_beige_double_bed"] = {
            ["label"] = "Brown big bed",
            ["description"] = "Bed",
            ["price"] = 110,
            ["model"] = `apa_mp_h_yacht_bed_01`
        },
    },

    ["Plant"] = {
        ["high_brown_pot"] = {
            ["label"] = "Tall plant in brown pot",
            ["description"] = "Tall plant in brown pot",
            ["price"] = 45,
            ["model"] = `apa_mp_h_acc_plant_tall_01`
        },
        ["short_blue_pot"] = {
            ["label"] = "little blue plant",
            ["description"] = "little blue plant",
            ["price"] = 10,
            ["model"] = `apa_mp_h_acc_vase_flowers_04`
        },
        ["palm_white_pot"] = {
            ["label"] = "Palm plant in white bowl",
            ["description"] = "Palm plant in white bowl",
            ["price"] = 40,
            ["model"] = `apa_mp_h_acc_plant_palm_01`
        },
        ["hole_wase"] = {
            ["label"] = "Plant in tall pot",
            ["description"] = "Plant in tall pot",
            ["price"] = 20,
            ["model"] = `apa_mp_h_acc_vase_flowers_02`
        },
        ["white_flower_vase"] = {
            ["label"] = "White bouquet in vase",
            ["description"] = "White bouquet in vase",
            ["price"] = 15,
            ["model"] = `hei_heist_acc_flowers_01`
        },
        ["long_vase"] = {
            ["label"] = "Tall plant in vase",
            ["description"] = "Tall plant in vase",
            ["price"] = 25,
            ["model"] = `prop_plant_int_03b`
        }
    },

    ["Storage"] = {
        ["large_drawer"] = {
            ["label"] = "Large siphon",
            ["description"] = "A large siphon where you can hold your belongings",
            ["price"] = 75,
            ["model"] = `hei_heist_bed_chestdrawer_04`,
            ["func"] = function(furnishId)
                OpenStorage("motel-" .. furnishId)
            end
        },
        ["chest_drawer"] = {
            ["label"] = "Siphoner",
            ["description"] = "The siphon where you can keep your belongings.",
            ["price"] = 65,
            ["model"] = `apa_mp_h_bed_chestdrawer_02`,
            ["func"] = function(furnishId)
                OpenStorage("motel-" .. furnishId)
            end
        },
        ["mini_fridge"] = {
            ["label"] = "Mini refrigerator",
            ["description"] = "A mini fridge where you can hold your meals.",
            ["price"] = 70,
            ["model"] = `prop_bar_fridge_03`,
            ["func"] = function(furnishId)
                OpenStorage("motel-" .. furnishId)
            end
        },
    },
    
    ["Rugs"] = {
        ["big_rug"] = {
            ["label"] = "Black / White colored rug",
            ["description"] = "Black / White colored rug",
            ["price"] = 56,
            ["model"] = `apa_mp_h_acc_rugwoolm_03`
        },
        ["beige_rug"] = {
            ["label"] = "Beige colored rug",
            ["description"] = "Beige colored rug",
            ["price"] = 70,
            ["model"] = `apa_mp_h_acc_rugwoolm_04`
        },
        ["beige_brown_circle_rug"] = {
            ["label"] = "Beige Brwon colored rug",
            ["description"] = "Beige Brown colored rug",
            ["price"] = 80,
            ["model"] = `apa_mp_h_acc_rugwoolm_01`
        },
        ["blue_white_turqoise_rug"] = {
            ["label"] = "Blue / White / Turquoise rug",
            ["description"] = "Blue / White / Turquoise rug",
            ["price"] = 80,
            ["model"] = `apa_mp_h_acc_rugwoolm_02`
        },
    },
    
    ["lamps"] = {
        ["floorlamp_mp_apa"] = {
            ["label"] = "Floor lamp",
            ["description"] = "Floor lamp",
            ["price"] = 60,
            ["model"] = `apa_mp_h_floorlamp_b`
        },
        ["floorlamp_basic_mp_apa"] = {
            ["label"] = "Yellow light lamp",
            ["description"] = "Yellow light lamp",
            ["price"] = 70,
            ["model"] = `apa_mp_h_floorlamp_c`
        },
        ["hanging_brown_yellow_lamp"] = {
            ["label"] = "Yellow illuminated hanging lamp",
            ["description"] = "Yellow illuminated hanging lamp",
            ["price"] = 90,
            ["model"] = `apa_mp_h_lit_floorlamp_05`
        },
        ["red_modern_lamp"] = {
            ["label"] = "Red Modern Lamp",
            ["description"] = "Red Modern Lamp",
            ["price"] = 150,
            ["model"] = `apa_mp_h_lit_floorlamp_13`
        },
        ["table_lamp_small"] = {
            ["label"] = "Small table lamp",
            ["description"] = "Small table lamp",
            ["price"] = 35,
            ["model"] = `apa_mp_h_lit_lamptable_09`
        },
        ["table_lamp_modern_small"] = {
            ["label"] = "Medium modern lamp",
            ["description"] = "Medium modern lamp",
            ["price"] = 40,
            ["model"] = `apa_mp_h_yacht_table_lamp_01`
        },
        ["ek_colored_fan_lamp"] = {
            ["label"] = "Fan lamp",
            ["description"] = "Fan lamp",
            ["price"] = 75,
            ["model"] = `bkr_prop_biker_ceiling_fan_base`
        },
        ["table_lamp_white"] = {
            ["label"] = "Small table lamp",
            ["description"] = "Small table lamp",
            ["price"] = 30,
            ["model"] = `v_ilev_fh_lampa_on`
        },
    },

    ["Units"] = {
        ["gray_white_tv_table"] = {
            ["label"] = "Gray and white television unit",
            ["description"] = "Gray and white television unit",
            ["price"] = 80,
            ["model"] = `apa_mp_h_str_sideboardl_13`
        },
        ["gray_white_tv_smaller_table"] = {
            ["label"] = "Gray-White small unit",
            ["description"] = "Gray-White small unit",
            ["price"] = 40,
            ["model"] = `apa_mp_h_str_sideboards_01`
        },
        ["ek_colored_tv_table"] = {
            ["label"] = "Tree color tv table",
            ["description"] = "Tree color tv table",
            ["price"] = 60,
            ["model"] = `apa_mp_h_str_sideboardm_02`
        },
    },

    ["Tables"] = {
        ["modern_triangle_table"] = {
            ["label"] = "Modern desk",
            ["description"] = "Modern desk",
            ["price"] = 60,
            ["model"] = `apa_mp_h_tab_coffee_07`
        },
        ["square_glass_table"] = {
            ["label"] = "Glass table",
            ["description"] = "Glass table",
            ["price"] = 50,
            ["model"] = `apa_mp_h_tab_sidelrg_07`
        },
        ["tree_ram_glass_table"] = {
            ["label"] = "Wooden table",
            ["description"] = "Wooden table",
            ["price"] = 75,
            ["model"] = `apa_mp_h_yacht_coffee_table_02`
        },
        ["metal_table"] = {
            ["label"] = "Metal sofa table",
            ["description"] = "Metal sofa table",
            ["price"] = 80,
            ["model"] = `apa_mp_h_yacht_coffee_table_01`
        },
    },

    ["Tables"] = {
        ["orange_painting"] = {
            ["label"] = "Orange table",
            ["description"] = "It's a beautiful painting.",
            ["price"] = 50,
            ["model"] = `apa_p_h_acc_artwalll_02`
        },
        ["blue_painting"] = {
            ["label"] = "Blue table",
            ["description"] = "A cool painting",
            ["price"] = 56,
            ["model"] = `apa_p_h_acc_artwalll_01`
        },
        ["turqoise_painting"] = {
            ["label"] = "Turquoise painting",
            ["description"] = "small and pleasant.",
            ["price"] = 45,
            ["model"] = `apa_p_h_acc_artwallm_04`
        },
    },

    ["Electronic Products"] = {
        ["big_tv"] = {
            ["label"] = "big tv",
            ["description"] = "A large TV with excellent quality",
            ["price"] = 250,
            ["model"] = `ex_prop_ex_tv_flat_01`
        },
        ["i_mac_keyboard"] = {
            ["label"] = "IMac with keyboard",
            ["description"] = "IMac with keyboard",
            ["price"] = 140,
            ["model"] = `ex_prop_trailer_monitor_01`
        },
        ["black_laptop"] = {
            ["label"] = "Black laptop",
            ["description"] = "Black laptop",
            ["price"] = 100,
            ["model"] = `p_amb_lap_top_02`
        },
        ["i_max_keyboard"] = {
            ["label"] = "IMax with keyboard",
            ["description"] = "IMax with keyboard",
            ["price"] = 170,
            ["model"] = `xm_prop_x17_computer_01`
        },
    },
}