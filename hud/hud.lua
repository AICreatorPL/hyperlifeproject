-- Ładowanie nowoczesnego HUD przez CEF
local browser = nil

function showHLRPGHud()
    if not browser then
        browser = createBrowser(screenX, screenY, true, true)
        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, "http://mta/local/hud/hud_cef.html")
            focusBrowser(browser)
        end)
    end
end

addEvent("hlrpg:showHud", true)
addEventHandler("hlrpg:showHud", root, showHLRPGHud)