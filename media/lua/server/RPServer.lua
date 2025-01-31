require "shared/RPSandboxVars"

Events.OnServerStarted.Add(function()
    if not RPMod.IsEnabled() then return end

    print("Roleplay Mod is enabled!")
    print("Welcome Messages: ", table.concat(RPMod.GetWelcomeMessages(), ", "))
end)

local function onClientCommand(module, command, player, args)
    if module == "RPMod" then
        if command == "requestWelcomeMessages" then
            local messages = RPMod.GetWelcomeMessages()
            sendServerCommand(player, "RPMod", "receiveWelcomeMessages", { messages = messages })
        elseif command == "applyServerConfig" then
            local iniFile = args.iniFile
            if iniFile then
                -- Aplicar la configuración del servidor desde el archivo .ini
                applyServerConfig(iniFile)
            end
        end
    end
end

function applyServerConfig(iniFile)
    -- Aquí se aplicaría la configuración del servidor desde el archivo .ini
    -- Esto es solo un ejemplo, necesitarías implementar la lógica para aplicar la configuración
    print("Applying server config from: " .. iniFile)
end

Events.OnClientCommand.Add(onClientCommand)