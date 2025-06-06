-- modules/agencies/client/main.lua
-- Listens for the “/dmenu” command and opens the Duty Menu via the export.

-- 1) On resource start, ask the server for everyone’s current assignments:
Citizen.CreateThread(function()
    TriggerServerEvent("agencies:requestAllAssignments")
end)

-- 2) Register the chat command “/dmenu” to open the Duty Menu
RegisterCommand("dmenu", function()
    -- Use the export that menu.lua registered:
    -- Replace 'rcND_Main' with your actual resource name if different
    if exports['rcND_Main'] and exports['rcND_Main']:OpenDutyMenu then
        exports['rcND_Main']:OpenDutyMenu()
    else
        print("^1[Agencies]^7 Export 'OpenDutyMenu' not found! Did menu.lua load correctly?")
    end
end, false)
