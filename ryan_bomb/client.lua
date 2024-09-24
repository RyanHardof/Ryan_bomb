local QBCore = exports['qb-core']:GetCoreObject()

Bomb = {}
Bomb.__index = Bomb

function Bomb:new(entity, coords, isTest)
    local bomb = {
        entity = entity,
        coords = coords,
        isDefused = false,
        isTest = isTest or false
    }
    setmetatable(bomb, Bomb)
    return bomb
end

function Bomb:checkProximity(playerCoords, defuseRange)
    return #(playerCoords - self.coords) < defuseRange
end

function Bomb:defuse()
    self.isDefused = true
    QBCore.Functions.Notify(self.isTest and "Test bomb successfully defused." or "Bomb successfully defused.", "success")
end

local spawnedBombs = {}
local defuseRange = Config.DefuseDistance
local isRealBombActive = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.BombSpawnInterval * 1000)

        if not isRealBombActive then
            local spawnChance = math.random(1, 100)
            if spawnChance <= Config.BombSpawnChance then
                local location = Config.BombLocations[math.random(1, #Config.BombLocations)]
                local bombObject = Config.GetRandomBombObject()

                local bombEntity = CreateObject(GetHashKey(bombObject), location.coords.x, location.coords.y, location.coords.z, true, true, true)
                PlaceObjectOnGroundProperly(bombEntity)

                local newBomb = Bomb:new(bombEntity, location.coords, false)
                table.insert(spawnedBombs, newBomb)

                isRealBombActive = true

                QBCore.Functions.Notify("A bomb has been placed in the city!", "warning")

                exports['ps-dispatch']:Bomb()
            end
        end
    end
end)

RegisterNetEvent('ryan_bomb:useBombKit', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local foundBomb = false

    for _, bomb in pairs(spawnedBombs) do
        if bomb:checkProximity(playerCoords, defuseRange) then
            TriggerMinigame(bomb)
            foundBomb = true
            break
        end
    end

    if not foundBomb then
        QBCore.Functions.Notify("No bomb nearby to defuse.", "error")
    end
end)

RegisterNetEvent('ryan_bomb:useTestBomb', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local bombObject = Config.GetRandomBombObject()

    local bombEntity = CreateObject(GetHashKey(bombObject), playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    PlaceObjectOnGroundProperly(bombEntity)

    local newBomb = Bomb:new(bombEntity, playerCoords, true)
    table.insert(spawnedBombs, newBomb)

    QBCore.Functions.Notify("Test bomb spawned for practice.", "success")
end)

function TriggerMinigame(bomb)
    exports['boii_minigames']:pincode({
        style = 'default',
        difficulty = 1,
        guesses = 5
    }, function(success)
        if success then
            TriggerWireCutMinigame(bomb)
        else
            if bomb.isTest then
                QBCore.Functions.Notify("Test bomb defusal failed. Try again.", "error")
            else
                TriggerExplosion(bomb.coords)
                DeleteObject(bomb.entity)
                isRealBombActive = false
            end
        end
    end)
end

function TriggerWireCutMinigame(bomb)
    exports['boii_minigames']:wire_cut({
        style = 'default',
        timer = 15000
    }, function(success)
        if success then
            bomb:defuse()
            if not bomb.isTest then
                isRealBombActive = false
            end
        else
            if bomb.isTest then
                QBCore.Functions.Notify("Test bomb defusal failed. Try again.", "error")
            else
                TriggerExplosion(bomb.coords)
                DeleteObject(bomb.entity)
                isRealBombActive = false
            end
        end
    end)
end

function TriggerExplosion(coords)
    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
end

RegisterCommand('removebomb', function()
    for i = #spawnedBombs, 1, -1 do
        local bomb = spawnedBombs[i]
        if DoesEntityExist(bomb.entity) then
            DeleteObject(bomb.entity)
        end
        if not bomb.isTest then
            isRealBombActive = false
        end
        table.remove(spawnedBombs, i)
    end
    QBCore.Functions.Notify("All bombs removed.", "success")
end)

RegisterNetEvent('ryan_bomb:useBombBag', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local foundBomb = false

    for i, bomb in pairs(spawnedBombs) do
        if bomb:checkProximity(playerCoords, defuseRange) then
            if bomb.isDefused then
                DeleteObject(bomb.entity)
                table.remove(spawnedBombs, i)
                QBCore.Functions.Notify(bomb.isTest and "Test bomb safely picked up." or "Bomb safely picked up.", "success")
                foundBomb = true
                break
            elseif not bomb.isTest then
                TriggerExplosion(bomb.coords)
                DeleteObject(bomb.entity)
                table.remove(spawnedBombs, i)
                QBCore.Functions.Notify("You tried to pick up an armed bomb! It exploded.", "error")
                isRealBombActive = false
                foundBomb = true
                break
            else
                DeleteObject(bomb.entity)
                table.remove(spawnedBombs, i)
                QBCore.Functions.Notify("Test bomb safely picked up.", "success")
                foundBomb = true
                break
            end
        end
    end

    if not foundBomb then
        QBCore.Functions.Notify("No defused bomb nearby to pick up.", "error")
    end
end)
