RPMod = RPMod or {}

RPMod.IsEnabled = function()
    return SandboxVars.RPMod and SandboxVars.RPMod.EnableRoleplay
end

RPMod.GetWelcomeMessages = function()
    local messages = SandboxVars.RPMod and SandboxVars.RPMod.WelcomeMessages
    if messages then
        local msgTable = luautils.split(messages, ";")
        print("Parsed Welcome Messages: ", table.concat(msgTable, ", "))
        return msgTable
    end
    print("No welcome messages found.")
    return {}
end

RPMod.GetRoles = function()
    local roles = SandboxVars.RPMod and SandboxVars.RPMod.Roles
    local parsedRoles = {}
    if roles then
        local roleList = luautils.split(roles, ";")
        for _, role in ipairs(roleList) do
            local name, description, messages, lvlUpNum = role:match("([^:]+):([^:]+):([^:]+):([^:]+)")
            if name and description and messages and lvlUpNum then
                table.insert(parsedRoles, { Name = name, Description = description, Messages = messages, LvLUpNum = tonumber(lvlUpNum) })
            end
        end
    end
    return parsedRoles
end

RPMod.GetPostCreationMessages = function()
    local messages = SandboxVars.RPMod and SandboxVars.RPMod.PostCreationMessages
    if messages then
        return luautils.split(messages, ";")
    end
    return {}
end

RPMod.GetEvents = function()
    local events = SandboxVars.RPMod and SandboxVars.RPMod.Events
    local parsedEvents = {}
    if events then
        local eventList = luautils.split(events, ";")
        for _, event in ipairs(eventList) do
            local time, message, chatMessage, preEventTime, iniFile, reconnectMessage = event:match("([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)")
            if time and message and chatMessage and preEventTime and iniFile and reconnectMessage then
                table.insert(parsedEvents, { Time = tonumber(time), Message = message, ChatMessage = chatMessage, PreEventTime = tonumber(preEventTime), IniFile = iniFile, ReconnectMessage = reconnectMessage })
            end
        end
    end
    return parsedEvents
end

luautils = luautils or {}

luautils.split = function(str, sep)
    local result = {}
    for part in str:gmatch("([^" .. sep .. "]+)") do
        table.insert(result, part)
    end
    return result
end