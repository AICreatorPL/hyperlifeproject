-- Klient: Minimalny panel logowania/rejestracji (GUI)
local window, usernameEdit, passwordEdit, loginBtn, registerBtn, infoLbl

function showLogin()
    if window and isElement(window) then destroyElement(window) end
    local sx, sy = guiGetScreenSize()
    window = guiCreateWindow(sx/2-170, sy/2-110, 340, 220, "HL-RPG - Logowanie", false)
    guiWindowSetSizable(window, false)
    guiSetInputEnabled(true)

    guiCreateLabel(30, 40, 280, 22, "Nazwa użytkownika:", false, window)
    usernameEdit = guiCreateEdit(30, 60, 280, 25, "", false, window)

    guiCreateLabel(30, 90, 280, 22, "Hasło:", false, window)
    passwordEdit = guiCreateEdit(30, 110, 280, 25, "", false, window)
    guiEditSetMasked(passwordEdit, true)

    loginBtn = guiCreateButton(30, 150, 130, 35, "Zaloguj się", false, window)
    registerBtn = guiCreateButton(180, 150, 130, 35, "Zarejestruj się", false, window)
    infoLbl = guiCreateLabel(30, 190, 280, 18, "", false, window)
    guiLabelSetColor(infoLbl, 255, 80, 80)
    guiLabelSetHorizontalAlign(infoLbl, "center")

    addEventHandler("onClientGUIClick", loginBtn, function()
        local user = guiGetText(usernameEdit)
        local pass = guiGetText(passwordEdit)
        if #user < 3 or #pass < 3 then
            guiSetText(infoLbl, "Podaj poprawne dane!")
            return
        end
        triggerServerEvent("loginAccount", localPlayer, user, pass)
    end, false)

    addEventHandler("onClientGUIClick", registerBtn, function()
        local user = guiGetText(usernameEdit)
        local pass = guiGetText(passwordEdit)
        if #user < 3 or #pass < 3 then
            guiSetText(infoLbl, "Podaj poprawne dane!")
            return
        end
        triggerServerEvent("registerAccount", localPlayer, user, pass)
    end, false)
end

addEventHandler("onClientResourceStart", resourceRoot, showLogin)

addEvent("loginResult", true)
addEventHandler("loginResult", root, function(ok, msg)
    guiSetText(infoLbl, msg or "")
    if ok then
        setTimer(function()
            if window and isElement(window) then
                destroyElement(window)
                guiSetInputEnabled(false)
            end
            outputChatBox("Witaj na serwerze HL-RPG!", 0, 255, 0)
        end, 1200, 1)
    end
end)

addEvent("registerResult", true)
addEventHandler("registerResult", root, function(ok, msg)
    guiSetText(infoLbl, msg or "")
    if ok then
        setTimer(function()
            guiSetText(infoLbl, "Możesz się teraz zalogować!")
        end, 1200, 1)
    end
end)