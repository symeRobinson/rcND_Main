Citizen.CreateThread(function()
    Config.Util_PrintVersion()
end)

-- Expose any utility functions to other client scripts if needed
exports('GetUtilConfig', function()
    return Config
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    print("^2[Agencies]^7 Client started. Config loaded: Subdivisions.SLMPD =")
    if Config and Config.Subdivisions and Config.Subdivisions.slmpd then
        print("  → Next SLMPD subdivision: " .. Config.Subdivisions.slmpd.patrol.label)
    else
        print("  → ^1Config.Subdivisions or Config.Subdivisions.slmpd is nil!^7")
    end
end)
