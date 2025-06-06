AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print("[utils] Server main initialized, version: " .. Config.Version)
end)

-- Expose any utility functions to other server scripts if needed
exports('GetUtilConfig', function()
    return Config
end)
