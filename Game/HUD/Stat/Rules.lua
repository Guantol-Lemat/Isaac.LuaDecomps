--#region Dependencies

local PlayerUtils = require("Entity.Player.Utils")
local PlayerRules = require("Entity.Player.Rules")

--#endregion

---@class StatHudRules
local Module = {}

---@param context Context
---@param player EntityPlayerComponent
---@param shouldEvaluate boolean
---@return boolean
local function hook_evaluate_player_has_stats_hud(context, player, shouldEvaluate)
    if player.m_playerType == PlayerType.PLAYER_THESOUL_B then
        return false
    end

    if PlayerUtils.IsHologram(player) then
        return false
    end

    return shouldEvaluate
end

---@param context Context
---@param player EntityPlayerComponent
---@return boolean
local function evaluate_player_has_stats_hud(context, player)
    if not PlayerRules.IsLocalPlayer(context, player) then
        return false
    end

    if player.m_variant ~= PlayerVariant.PLAYER then
        return false
    end

    if player.m_parent then
        return false
    end

    local shouldEvaluate = true
    shouldEvaluate = hook_evaluate_player_has_stats_hud(context, player, shouldEvaluate)
    return shouldEvaluate
end

---@param context Context
---@param statHud StatHUDComponent
---@param player EntityPlayerComponent
---@return integer?
local function GetPlayerId(context, statHud, player)
    if not evaluate_player_has_stats_hud(context, player) then
        return nil
    end

    local freeId = nil
    local playerStats = statHud.m_playerStats
    for i = 1, 2, 1 do
        if playerStats[i].m_player == player then
            return i
        end

        if not playerStats[i].m_player and not freeId then
            freeId = i
        end
    end

    if freeId then
        playerStats[freeId].m_player = player
        return freeId
    end

    return nil
end

--#region Module

Module.GetPlayerId = GetPlayerId

--#endregion

return Module