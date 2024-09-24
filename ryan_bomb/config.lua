Config = {}

-- Bomb spawn settings
Config.BombSpawnInterval = 10 -- Time interval in seconds (30 minutes by default)
Config.BombSpawnChance = 100 -- 25% chance of bomb spawning at each interval

-- Time (in seconds) for the bomb to explode after being placed
Config.BombTimer = 300 -- Time before the bomb explodes (in seconds)

-- Distance to defuse the bomb (in meters)
Config.DefuseDistance = 3.0

-- Which player jobs and their allowed numeric grades can defuse the bomb
Config.DefuseJobs = {
    ['police'] = { 27 }  -- Allow police job to defuse with specific grade
}

-- Bomb spawn locations with categories (either 'object' or 'vehicle')
Config.BombLocations = {
    {
        coords = vector3(-50.5394, -135.9060, 57.6843),
        category = 'object' 
    },
    {
        coords = vector3(-32.2890, -134.7072, 57.1033),
        category = 'object' 
    },
    {
        coords = vector3(-57.4587, -137.1533, 57.8312),
        category = 'object' 
    },
    {
        coords = vector3(-60.3142, -126.7382, 57.8720),
        category = 'object'  
    }
}

-- List of possible bomb objects
Config.BombObjects = {
    'prop_big_bag_01',
    'prop_cs_heist_bag_02',
    'prop_carrier_bag_01_lod',
    'prop_shopping_bags01',
    'm24_1_prop_m41_cokebag_01a',
    'ch_prop_ch_duffbag_gruppe_01a',
    'prop_paper_bag_small',
    'ng_proc_binbag_02a',
    'hei_p_f_bag_var7_bus_s',
    'prop_beach_bag_01a',
    'xs_prop_trinket_bag_01a',
    'xm_prop_x17_bag_01c',
    'prop_food_cb_bag_01',
    'prop_beach_bag_01b',
    'ch_chint10_binbags_smallroom_01',
    'prop_rub_binbag_03',
    'v_corp_facebeanbagc',
    'm23_2_prop_m32_bag_professionals_01a',
    'v_ret_ps_toiletbag',
    'reh_prop_reh_bag_outfit_01a',
    'ch_p_m_bag_var10_arm_s',
    'prop_snow_bin_02'
}

function Config.GetRandomBombObject()
    return Config.BombObjects[math.random(1, #Config.BombObjects)]
end
