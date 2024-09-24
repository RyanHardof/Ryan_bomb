For this script to work you need to have boii_minigames and ps-dispatch 

https://github.com/Project-Sloth/ps-dispatch
https://github.com/boiidevelopment/boii_minigames

For ps-dispatch you need to add these 

alert.lua
local function Bomb()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('bomb'),
        codeName = 'bomb',
        code = '10-80',
        icon = 'fas fa-fire',
        priority = 1,
        coords = coords,
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Bomb', Bomb)

config.lua
['bomb'] = {
        radius = 0,
        sprite = 501,
        color = 1,
        scale = 1.5,
        length = 2,
        sound = 'Lose_1st',
        sound2 = 'GTAO_FM_Events_Soundset',
        offset = true,
        flash = false
},

For anyother dispatch systems you will have to add it to the fxmanifest and add it to everything else


Item
bombkit                      = { name = 'bombkit',       label = 'Bomb Defusing Kit', weight = 1000, type = 'item', image = 'bombkit.png', unique = true, useable = true, description = 'Bomb Defusing Kit' },
testbomb                     = { name = 'testbomb',      label = 'Test Bomb', weight = 1000, type = 'item', image = 'testbomb.png', unique = true, useable = true, description = 'A fake bomb for testing purposes' },
bombbag                      = { name = 'bombbag',       label = 'Bomb Disposal Bag', weight = 1000, type = 'item', image = 'bombbag.png', unique = true, useable = true, description = 'A bag for holding bombs' },