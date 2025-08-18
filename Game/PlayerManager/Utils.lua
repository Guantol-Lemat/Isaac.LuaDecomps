--#region Dependencies

local PlayerUtils = require("Entity.Player.Utils")

--#endregion

---@class PlayerManagerUtils
local Module = {}

---@param playerManager PlayerManagerComponent
---@return boolean
local function IsCoopPlay(playerManager)
    local numPlayers = #playerManager.m_players
    if #numPlayers < 2 then
        return false
    end

    local playerCount = 0
    for i = 1, numPlayers, 1 do
        local player = playerManager.m_players[i]
        if player.m_variant == PlayerVariant.PLAYER and PlayerUtils.IsMainPlayerCharacter(player) then
            playerCount = playerCount + 1
        end
    end

    return playerCount > 1
end

---@param playerManager PlayerManagerComponent
---@return number
local function GetNumCoopPlayers(playerManager)
    local numPlayers = #playerManager.m_players
    local playerCount = 0
    for i = 1, numPlayers, 1 do
        local player = playerManager.m_players[i]
        if player.m_variant == PlayerVariant.PLAYER and PlayerUtils.IsMainPlayerCharacter(player) and not player.m_isCoopGhost then
            playerCount = playerCount + 1
        end
    end

    return playerCount
end

--#region Module

Module.IsCoopPlay = IsCoopPlay
Module.GetNumCoopPlayers = GetNumCoopPlayers

--#endregion

return Module