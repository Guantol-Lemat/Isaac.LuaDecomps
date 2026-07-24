--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local ISeeds = require("Isaac.Interface.Seeds")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

--#endregion

---@param game Component.Game
---@param ctx Context.Common
---@return Component.ChallengeParam
local function GetChallengeParams(game, ctx)
    local dailyChallenge = game.m_dailyChallenge
    local inDaily = dailyChallenge.m_id ~= 0

    if inDaily then
        return dailyChallenge.m_challengeParams
    end

    return ctx.manager.m_challengeParams[game.m_challenge + 1]
end

---@param game Component.Game
---@param ctx Context.Common
---@return boolean
local function AchievementUnlocksDisallowed(game, ctx)
    local seeds = game.m_seeds
    return seeds.m_isCustomRun
        or ISeeds.AchievementUnlocksDisallowed(seeds)
        or IManager.AchievementUnlocksDisallowed(ctx, false)
        or game.m_isRerun_qqq
        or IManager.IsNetPlay(ctx.manager)
end

---@param game Component.Game
---@param speed number
local function Fadein(game, speed)
    game.m_fade_fadeInValue = game.m_itemOverlayEndRelated and 10.0^-5 or 1.0
    game.m_fade_speed = speed
    IPlayerManager.SetControlsEnabled(game.m_playerManager, false)
end

---@class Gameplay.Game.Misc
local Module = {}

--#region Module

Module.GetChallengeParams = GetChallengeParams
Module.AchievementUnlocksDisallowed = AchievementUnlocksDisallowed
Module.Fadein = Fadein

--#endregion

return Module