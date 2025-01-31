require "shared/RPSandboxVars"
require "UI/RPClientUI"

RPClient = {}

local currentMessageIndex = 1
local welcomeMessages = {}
local roles = {}
local selectedRole = nil

function RPClient.showNextMessage()
    if currentMessageIndex <= #welcomeMessages then
        local message = welcomeMessages[currentMessageIndex]
        currentMessageIndex = currentMessageIndex + 1
        if RPClientUI.instance then
            RPClientUI.instance:showMessage(message)
        else
            print("Error: RPClientUI.instance is nil")
        end
    else
        if RPClientUI.instance then
            RPClientUI.instance:showRoleSelection(roles)
        else
            print("Error: RPClientUI.instance is nil")
        end
    end
end

function RPClient.onRoleSelected(roleName)
    for _, role in ipairs(roles) do
        if role.Name == roleName then
            selectedRole = role
            break
        end
    end
    -- Mostrar la descripción del rol seleccionado si no es nil
    if selectedRole then
        if RPClientUI.instance then
            RPClientUI.instance:showRoleDescription(selectedRole)
        else
            print("Error: RPClientUI.instance is nil")
        end
    else
        print("Error: selectedRole is nil")
    end
end

function RPClient.confirmRoleSelection()
    -- Guardar la elección del jugador
    RPClient.savePlayerRole(selectedRole)
    -- Continuar con la creación del personaje
    if RPClientUI.instance then
        RPClientUI.instance:hide()
    else
        print("Error: RPClientUI.instance is nil")
    end
end

function RPClient.savePlayerRole(role)
    local player = getPlayer()
    if player then
        -- Guardar la elección del jugador en una variable global
        player:getModData().selectedRole = role
        print("Player role selected: ", role.Name)
    else
        print("Error: getPlayer() returned nil")
    end
end

function RPClient.showWelcomeMessages()
    if not RPMod.IsEnabled() then return end

    welcomeMessages = RPMod.GetWelcomeMessages()
    roles = RPMod.GetRoles()
    currentMessageIndex = 1
    if RPClientUI.instance then
        RPClientUI.instance:show()
        RPClient.showNextMessage()
    else
        print("RPClientUI.instance is nil")
    end
end

function RPClient.showPostCreationMessages()
    if not RPMod.IsEnabled() then return end

    local postCreationMessages = RPMod.GetPostCreationMessages()
    for _, message in ipairs(postCreationMessages) do
        if RPClientUI.instance then
            RPClientUI.instance:showMessage(message)
        else
            print("Error: RPClientUI.instance is nil")
        end
    end

    -- Mostrar mensajes específicos del rol
    prints("Showing role messages..."+selectedRole.Messages)
    if selectedRole and selectedRole.Messages then
        local roleMessages = luautils.split(selectedRole.Messages, ";")
        for _, message in ipairs(roleMessages) do
            if RPClientUI.instance then
                RPClientUI.instance:showMessage(message)
            else
                print("Error: RPClientUI.instance is nil")
            end
        end
    end
end

Events.OnGameStart.Add(function()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local ui = RPClientUI:new(0, 0, screenWidth, screenHeight)
    ui:initialise()
    ui:addToUIManager()
    RPClientUI.instance = ui
end)

local function OnConnected()
    print("OnConnected triggered")  -- Para depuración
    if not RPClientUI.instance then
        local screenWidth = getCore():getScreenWidth()
        local screenHeight = getCore():getScreenHeight()
        local ui = RPClientUI:new(0, 0, screenWidth, screenHeight)
        ui:initialise()
        ui:addToUIManager()
        RPClientUI.instance = ui
    end
    RPClient.showWelcomeMessages()
end

Events.OnConnected.Add(OnConnected)
Events.OnCreatePlayer.Add(RPClient.showPostCreationMessages)