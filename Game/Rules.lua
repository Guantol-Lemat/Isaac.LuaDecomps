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

--#region Module

Module.InterpolationUpdate = InterpolationUpdate

--#endregion

return Module