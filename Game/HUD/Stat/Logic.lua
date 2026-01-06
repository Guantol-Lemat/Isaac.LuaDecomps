--#region Dependencies

local PlayerManagerRules = require("Game.PlayerManager.Rules")
local StatHudUtils = require("HUD.Stat.Utils")
local StatHudRules = require("HUD.Stat.Rules")
local BitSetUtils = require("General.Bitset")

local eHudStat = StatHudUtils.eHudStat

--#endregion

---@class StatHudLogic
local Module = {}

---@param hud StatHUDComponent
---@param playerIndex integer
---@param statFlags integer
local function RecomputeStats(hud, playerIndex, statFlags)
    -- TODO
end

---@param context Context
---@param hud StatHUDComponent
local function hook_pre_update_stat_hud(context, hud)
    local playerManager = context:GetPlayerManager()
    hud.m_combineDeals = PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_DUALITY)
end

---@param hud StatHUDComponent
---@param playerIndex integer
local function update_player_stats(hud, playerIndex)
    local playerStats = hud.m_playerStats[playerIndex]
    for hudStat = 1, eHudStat.NUM_HUD_STATS, 1 do
        local stat = StatHudUtils.GetStat(playerStats, hudStat)
        if stat.m_deltaCountdown > 0 then
            stat.m_deltaCountdown = stat.m_deltaCountdown - 1
        end
    end
end

---@param context Context
---@param hud StatHUDComponent
local function Update(context, hud)
    local options = context:GetOptions()
    if not options.m_enableFoundHUD then
        return
    end

    local statFlags = BitSetUtils.SetAllBits(eHudStat.NUM_HUD_STATS)
    statFlags = BitSetUtils.Clear(statFlags, 1 << (eHudStat.PLANETARIUM_CHANCE - 1))

    hook_pre_update_stat_hud(context, hud)
    local playerManager = context:GetPlayerManager()

    for i = 1, #playerManager.m_players, 1 do
        local player = playerManager.m_players[i]
        local playerIndex = StatHudRules.GetPlayerId(context, hud, player)
        if playerIndex then
            RecomputeStats(hud, playerIndex, statFlags)
        end
    end

    for playerIdx = 1, 2, 1 do
        update_player_stats(hud, playerIdx)
    end
end

--#region Module

Module.Update = Update

--#endregion

return Module