-- Prosty system logowania/rejestracji (XML), automatyczne logowanie do konta MTA, spawn, Owner po loginie/serialu

local xmlPath = "accounts/accounts.xml"

local function loadAccountsXML()
    local xml = xmlLoadFile(xmlPath)
    if not xml then
        xml = xmlCreateFile(xmlPath, "accounts")
        xmlSaveFile(xml)
    end
    return xml
end

local function accountExists(username)
    local xml = loadAccountsXML()
    for _, node in ipairs(xmlNodeGetChildren(xml)) do
        if xmlNodeGetAttribute(node, "username") == username then
            xmlUnloadFile(xml)
            return node
        end
    end
    xmlUnloadFile(xml)
    return false
end

addEvent("hlrpg:register", true)
addEventHandler("hlrpg:register", root, function(username, password)
    if accountExists(username) then
        triggerClientEvent(source, "hlrpg:registerResult", source, false, "Konto o tej nazwie już istnieje.")
        return
    end
    local xml = loadAccountsXML()
    local node = xmlCreateChild(xml, "account")
    xmlNodeSetAttribute(node, "username", username)
    xmlNodeSetAttribute(node, "password", password) -- NIE UŻYWAĆ NA PRODUKCJI!
    xmlSaveFile(xml)
    xmlUnloadFile(xml)
    triggerClientEvent(source, "hlrpg:registerResult", source, true, "Pomyślnie zarejestrowano!")
end)

addEvent("hlrpg:login", true)
addEventHandler("hlrpg:login", root, function(username, password)
    local xml = loadAccountsXML()
    for _, node in ipairs(xmlNodeGetChildren(xml)) do
        if xmlNodeGetAttribute(node, "username") == username then
            if xmlNodeGetAttribute(node, "password") == password then
                xmlUnloadFile(xml)

                -- Logowanie do konta MTA!
                local acc = getAccount(username, password)
                if acc then
                    logIn(source, acc)
                end

                triggerClientEvent(source, "hlrpg:loginResult", source, true, "Zalogowano pomyślnie!")
                triggerEvent("hlrpg:spawnAtCityHall", source)
                return
            else
                xmlUnloadFile(xml)
                triggerClientEvent(source, "hlrpg:loginResult", source, false, "Błędne hasło.")
                return
            end
        end
    end
    xmlUnloadFile(xml)
    triggerClientEvent(source, "hlrpg:loginResult", source, false, "Nie znaleziono konta.")
end)

-- Spawn gracza na placu w parku przed urzędem miasta Los Santos
local spawnX, spawnY, spawnZ = 1481.1, -1763.8, 19.5
local spawnRot = 90

addEvent("hlrpg:spawnAtCityHall", true)
addEventHandler("hlrpg:spawnAtCityHall", root, function()
    spawnPlayer(source, spawnX, spawnY, spawnZ, spawnRot, 0, 0, 0)
    fadeCamera(source, true)
    setCameraTarget(source, source)
    outputChatBox("Witaj na HL-RPG!", source, 0, 255, 0)
end)