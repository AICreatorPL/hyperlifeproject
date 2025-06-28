-- Podstawowe funkcje serwera (inicjalizacja, spawn gracza)
local spawnPosition = {x = 1481.1, y = -1759.5, z = 13.5} -- Urząd Miasta LS

function spawnPlayerAtCityHall(player)
    spawnPlayer(player, spawnPosition.x, spawnPosition.y, spawnPosition.z, 0, 0, 0, 0)
    fadeCamera(player, true)
    setCameraTarget(player, player)
    outputChatBox("Witaj na HL-RPG! Miłej gry.", player, 0, 255, 0)
end

addEvent("hlrpg:spawnPlayerCityHall", true)
addEventHandler("hlrpg:spawnPlayerCityHall", root, function()
    spawnPlayerAtCityHall(source)
end)