--#region Dependencies

local Log = require("General.Log")

--#endregion

---@class EntityConfigUtils
local Module = {}

---@param type integer
---@param variant integer?
---@param subtype integer?
local function GetHash(type, variant, subtype)
    variant = variant or 0
    subtype = subtype or 0
    return type << 12 | variant << 8 | subtype
end

---@param entityConfig EntityConfigComponent
---@param playerType PlayerType | integer
---@return EntityConfig.PlayerComponent
local function GetPlayer(entityConfig, playerType)
    local config = entityConfig.m_players[playerType + 1]
    if not config then
        local message = string.format("Could not load config for player type %d\n", playerType)
        Log.LogMessage(3, message)
        error(message, 0)
    end

    return config
end

---@param entityConfig EntityConfigComponent
---@param seed integer
---@return string
local function GetRandomEdenHairSheet(entityConfig, seed)
    local edenHairs = entityConfig.m_edenHair

    local count = #edenHairs
    if count == 0 then
        Log.LogMessage(3, "Eden has no hair!\n")
        error("Eden has no hair!", 0)
    end

    local hairId = (seed % count) + 1
    return edenHairs[hairId]
end

--#region Module

Module.GetHash = GetHash
Module.GetPlayer = GetPlayer
Module.GetRandomEdenHairSheet = GetRandomEdenHairSheet

--#endregion

return Module