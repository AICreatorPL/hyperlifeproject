-- HL-RPG: Czat lokalny, globalny i /admins z kolorami i wykrywaniem Ownera po loginie/serialu

local chatRange = 100

local adminGroups = {
    ["Pomocnik"] = {color="#5af25a", order=1},           -- Zielony
    ["Opiekun"] = {color="#4cb2ff", order=2},            -- Niebieski
    ["Administrator"] = {color="#ff6e6e", order=3},       -- Jasny czerwony
    ["HeadAdmin"] = {color="#b50000", order=4},           -- Ciemny czerwony
    ["Owner"] = {color="#ffd700", order=5},               -- Złoty
}

local groupAliases = {
    ["Head Administrator"] = "HeadAdmin",
    ["HeadAdministrator"] = "HeadAdmin",
}

-- Login i serial, które mają zawsze Ownera niezależnie od ACL
local forcedOwners = {
    ["pabloescobaro69"] = true,
    ["admin"] = true,
    ["13812B8A3A425C062ACA9A560B6670A2"] = true,
}

function getPlayerAdminRank(player)
    local account = getPlayerAccount(player)
    local accName = account and getAccountName(account) or ""
    local serial = getPlayerSerial(player)

    if forcedOwners[accName] or forcedOwners[serial] then
        local info = adminGroups["Owner"]
        return "Owner", info.color, info.order
    end

    if not account or isGuestAccount(account) then return false end
    for groupName, info in pairs(adminGroups) do
        local group = aclGetGroup(groupName)
        if group and isObjectInACLGroup("user."..accName, group) then
            return groupName, info.color, info.order
        end
    end
    for alias, original in pairs(groupAliases) do
        local group = aclGetGroup(alias)
        if group and isObjectInACLGroup("user."..accName, group) then
            local info = adminGroups[original]
            return original, info.color, info.order
        end
    end
    return false
end

addCommandHandler("l", function(player, _, ...)
    local msg = table.concat({...}, " ")
    if #msg < 1 then
        outputChatBox("* Użycie: /l <wiadomość>", player, 255, 255, 100)
        return
    end
    local px, py, pz = getElementPosition(player)
    for _, v in ipairs(getElementsByType("player")) do
        local x, y, z = getElementPosition(v)
        if getDistanceBetweenPoints3D(px, py, pz, x, y, z) <= chatRange then
            outputChatBox("#7cc7ff[LOKALNY] #ffffff" .. getPlayerName(player) .. ": " .. msg, v, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("g", function(player, _, ...)
    local msg = table.concat({...}, " ")
    if #msg < 1 then
        outputChatBox("* Użycie: /g <wiadomość>", player, 255, 255, 100)
        return
    end
    local rank, color = getPlayerAdminRank(player)
    if not rank then
        outputChatBox("* Nie masz uprawnień do globalnego czatu.", player, 255, 80, 80)
        return
    end
    for _, v in ipairs(getElementsByType("player")) do
        outputChatBox(color.."[GLOBALNY]["..rank.."] #ffffff" .. getPlayerName(player) .. ": " .. msg, v, 255, 255, 255, true)
    end
end)

addCommandHandler("admins", function(player)
    local onlineAdmins = {}
    for _, v in ipairs(getElementsByType("player")) do
        local rank, color, order = getPlayerAdminRank(v)
        if rank then
            table.insert(onlineAdmins, {name=getPlayerName(v), rank=rank, color=color, order=order})
        end
    end
    table.sort(onlineAdmins, function(a, b) return a.order > b.order end)
    if #onlineAdmins == 0 then
        outputChatBox("Brak aktywnych administratorów.", player, 255, 200, 100)
    else
        local msg = "Aktywni administratorzy: "
        for i, admin in ipairs(onlineAdmins) do
            msg = msg .. admin.color.."["..admin.rank.."] "..admin.name.."#ffffff"
            if i < #onlineAdmins then msg = msg .. ", " end
        end
        outputChatBox(msg, player, 255, 255, 255, true)
    end
end)