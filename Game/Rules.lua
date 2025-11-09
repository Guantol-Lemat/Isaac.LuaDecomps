--#region Dependencies

local GameUtils = require("Game.Utils")
local RoomTransitionUtils = require("Game.Transition.RoomTransition.Utils")
local StageTransitionUtils = require("Game.Transition.StageTransition.Utils")
local ScreenRules = require("Admin.Screen.Rules")

--#endregion

---@class GameRules
local Module = {}

---@param context Context
---@param game GameComponent
local function InterpolationUpdate(context, game)
    local consoleUpdated = false
    -- local consoleUpdated = Console:Update()
    if consoleUpdated then
        return
    end

    if RoomTransitionUtils.IsActive(game.m_roomTransition) then
        -- RoomTransition::Interpolate
    elseif StageTransitionUtils.IsActive(game.m_stageTransition) then
        -- StageTransition::Interpolate
    end

    if not GameUtils.IsPaused(game) and not ScreenRules.ShouldTriggerLostFocusPause(context, context:GetScreen()) and not false--[[something with netplay manager]] then
        -- Room::Interpolate
        -- HellBackdrop::Interpolate
        -- PlayerManager::Interpolate
    end
end

---@param context Context
---@param game GameComponent
---@param duration integer
local function ShakeScreen(context, game, duration)
end

---@param context Context
---@param game GameComponent
---@return ChallengeParamsComponent
local function GetChallengeParams(context, game)
    local dailyChallenge = game.m_dailyChallenge
    if dailyChallenge.m_id ~= 0 then
        return dailyChallenge.m_challengeParams
    end

    return context:GetChallengeParams(game.m_challenge)
end

--#region Module

Module.InterpolationUpdate = InterpolationUpdate
Module.ShakeScreen = ShakeScreen
Module.GetChallengeParams = GetChallengeParams

--#endregion

return Module