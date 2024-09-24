local QBCore = exports['qb-core']:GetCoreObject()

local bombData = {} 

RegisterCommand('plantbomb', function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local coords = GetEntityCoords(GetPlayerPed(source))
        local bombId = math.random(1000, 9999) 

        bombData[bombId] = {
            plantedBy = source,
            coords = coords,
            countdown = Config.BombTimer
        }

        TriggerClientEvent('ryan_bomb:client:spawnBomb', -1, coords, bombId)
        
        startBombCountdown(bombId)
    end
end)

function startBombCountdown(bombId)
    local bomb = bombData[bombId]
    if bomb then
        SetTimeout(bomb.countdown * 1000, function()
            if bombData[bombId] then
                TriggerClientEvent('ryan_bomb:client:explodeBomb', -1, bomb.coords)
                bombData[bombId] = nil
            end
        end)
    end
end

RegisterNetEvent('ryan_bomb:server:attemptDefuse', function(bombId)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if bombData[bombId] then
        local bomb = bombData[bombId]
        local playerCoords = GetEntityCoords(GetPlayerPed(source))

        if #(bomb.coords - playerCoords) < Config.DefuseDistance then
            local job = Player.PlayerData.job.name
            if inTable(Config.DefuseJobs, job) then
                TriggerClientEvent('ryan_bomb:client:defuseBomb', -1, bomb.coords, bombId)
                bombData[bombId] = nil
            else
                TriggerClientEvent('QBCore:Notify', source, 'You are not authorized to defuse this bomb!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'You are too far from the bomb!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'Bomb does not exist!', 'error')
    end
end)

QBCore.Functions.CreateUseableItem("bombkit", function(source, item)
    TriggerClientEvent('ryan_bomb:useBombKit', source)
end)

QBCore.Functions.CreateUseableItem("testbomb", function(source, item)
    TriggerClientEvent('ryan_bomb:useTestBomb', source)
end)

QBCore.Functions.CreateUseableItem("bombbag", function(source, item)
    TriggerClientEvent('ryan_bomb:useBombBag', source)
end)

RegisterCommand('removebomb', function(source, args)
    for bombId, bomb in pairs(bombData) do
        TriggerClientEvent('ryan_bomb:client:removeBomb', -1, bomb.coords, bombId)
        bombData[bombId] = nil
    end
    QBCore.Functions.Notify(source, "All bombs have been removed.", "success")
end)

function inTable(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end
