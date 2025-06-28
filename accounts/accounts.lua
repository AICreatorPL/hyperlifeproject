-- Serwer: Prosty system logowania/rejestracji (XML)
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

addEvent("registerAccount", true)
addEventHandler("registerAccount", root, function(username, password)
    if accountExists(username) then
        triggerClientEvent(source, "registerResult", source, false, "Konto o tej nazwie już istnieje.")
        return
    end
    local xml = loadAccountsXML()
    local node = xmlCreateChild(xml, "account")
    xmlNodeSetAttribute(node, "username", username)
    xmlNodeSetAttribute(node, "password", password)
    xmlSaveFile(xml)
    xmlUnloadFile(xml)
    triggerClientEvent(source, "registerResult", source, true, "Pomyślnie zarejestrowano!")
end)

addEvent("loginAccount", true)
addEventHandler("loginAccount", root, function(username, password)
    local xml = loadAccountsXML()
    for _, node in ipairs(xmlNodeGetChildren(xml)) do
        if xmlNodeGetAttribute(node, "username") == username then
            if xmlNodeGetAttribute(node, "password") == password then
                xmlUnloadFile(xml)
                triggerClientEvent(source, "loginResult", source, true, "Zalogowano pomyślnie!")
                triggerEvent("spawnAtCityHall", source)
                return
            else
                xmlUnloadFile(xml)
                triggerClientEvent(source, "loginResult", source, false, "Błędne hasło.")
                return
            end
        end
    end
    xmlUnloadFile(xml)
    triggerClientEvent(source, "loginResult", source, false, "Nie znaleziono konta.")
end)

-- Spawn gracza pod urzędem
local spawnX, spawnY, spawnZ = 1481.1, -1771.6, 18.8 -- Chodnik przed urzędem, poprawiona pozycja
local spawnRot = 90

addEvent("spawnAtCityHall", true)
addEventHandler("spawnAtCityHall", root, function()
    spawnPlayer(source, spawnX, spawnY, spawnZ, spawnRot, 0, 0, 0)
    fadeCamera(source, true)
    setCameraTarget(source, source)
    outputChatBox("Witaj na HL-RPG!", source, 0, 255, 0)
end)