local chatRange = 100

local adminGroups = {
    ["Owner"] = {color="#ffd700", label="Owner"},
    ["HeadAdmin"] = {color="#b50000", label="Head Administrator"},
    ["Administrator"] = {color="#ff6e6e", label="Administrator"},
    ["Opiekun"] = {color="#4cb2ff", label="Opiekun"},
    ["Pomocnik"] = {color="#5af25a", label="Pomocnik"},
}
local groupOrder = {
    "Owner",
    "HeadAdmin",
    "Administrator",
    "Opiekun",
    "Pomocnik"
}
local forcedOwners = {
    ["pabloescobaro69"] = true,
    ["admin"] = true,
    ["13812B8A3A425C062ACA9A560B6670A2"] = true,
}

-- Pobierz rangę i kolor nicku gracza
function getPlayerAdminInfo(player)
    local account = getPlayerAccount(player)
    local accName = account and getAccountName(account) or ""
    local serial = getPlayerSerial(player)
    if forcedOwners[accName] or forcedOwners[serial] then
        local info = adminGroups["Owner"]
        return info.label, info.color
    end
    if not account or isGuestAccount(account) then return "Gracz", "#ffffff" end
    for groupName, info in pairs(adminGroups) do
        local group = aclGetGroup(groupName)
        if group and isObjectInACLGroup("user."..accName, group) then
            return info.label, info.color
        end
    end
    return "Gracz", "#ffffff"
end

-- Funkcja pomocnicza do pobierania ID postaci (lub serialu jeśli brak)
function getPlayerID(player)
    return getElementData(player, "player:id") or getPlayerSerial(player)
end

-- /g oraz czat lokalny
addEventHandler("onPlayerChat", root, function(message, messageType)
    if messageType ~= 0 then return end -- tylko normalny czat

    -- Czat globalny przez /g
    if message:sub(1,3) == "/g " and #message > 3 then
        local gmsg = message:sub(4)
        local playerID = tostring(getPlayerID(source))
        local label, color = getPlayerAdminInfo(source)
        local nick = string.format("%s%s#ffffff", color, getPlayerName(source))
        local globalPrefix = string.format("#ffcc00[GLOBALNY][%s][%s]", playerID, label)
        for _, v in ipairs(getElementsByType("player")) do
            outputChatBox(string.format("%s: %s: %s", globalPrefix, nick, gmsg), v, 255,255,255,true)
        end
        cancelEvent()
        return
    end

    -- Czat lokalny (T)
    local label, color = getPlayerAdminInfo(source)
    local nick = string.format("%s%s#ffffff", color, getPlayerName(source))
    local px, py, pz = getElementPosition(source)
    for _, v in ipairs(getElementsByType("player")) do
        local x, y, z = getElementPosition(v)
        if getDistanceBetweenPoints3D(px, py, pz, x, y, z) <= chatRange then
            outputChatBox("#7cc7ff[LOKALNY] "..nick..": "..message, v, 255,255,255,true)
        end
    end
    cancelEvent()
end)

-- /admins
addCommandHandler("admins", function(player)
    local grouped = {}
    for _, groupName in ipairs(groupOrder) do
        grouped[groupName] = {}
    end
    for _, v in ipairs(getElementsByType("player")) do
        local label, _ = getPlayerAdminInfo(v)
        for _, groupName in ipairs(groupOrder) do
            if label == adminGroups[groupName].label then
                table.insert(grouped[groupName], getPlayerName(v))
            end
        end
    end
    outputChatBox("----- Lista administracji -----", player, 200, 200, 255)
    for _, groupName in ipairs(groupOrder) do
        local color = adminGroups[groupName].color
        local label = adminGroups[groupName].label
        outputChatBox(color.."["..label.."]:", player, 255,255,255,true)
        if #grouped[groupName] > 0 then
            outputChatBox(color..table.concat(grouped[groupName], ", ").."#ffffff", player, 255,255,255,true)
        else
            outputChatBox("#888888brak#ffffff", player, 255,255,255,true)
        end
    end
    outputChatBox("------------------------------", player, 200, 200, 255)
end)