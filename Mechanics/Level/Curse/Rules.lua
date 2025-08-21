--#region Dependencies

local GameUtils = require("Game.Utils")

--#endregion

---@class CurseRules
local Module = {}

---@param context Context
---@param stage LevelStage
---@param result boolean
---@return boolean
local function hook_can_have_curse_of_labyrinth(context, stage, result)
    local game = context:GetGame()
    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if GameUtils.IsGreedMode(game) then
        return false
    end

    return result
end

---@param context Context
---@param stage LevelStage
local function CanStageHaveCurseOfLabyrinth(context, stage)
    if not (LevelStage.STAGE1_1 <= stage and stage <= LevelStage.STAGE4_2) then
        return false
    end

    local result = stage % 2 == 1
    result = hook_can_have_curse_of_labyrinth(context, stage, result)
    return result
end

---@param context Context
---@param result boolean
---@return boolean
local function hook_can_have_curse_of_the_lost(context, result)
    local game = context:GetGame()
    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if GameUtils.IsGreedMode(game) then
        return false
    end

    return result
end

---@param context Context
local function CanHaveCurseOfTheLost(context)
    local result = true
    result = hook_can_have_curse_of_the_lost(context, result)
    return result
end

---@param context Context
---@param result boolean
---@return boolean
local function hook_can_have_curse_of_maze(context, result)
    local game = context:GetGame()
    if GameUtils.IsGreedMode(game) then
        return false
    end

    return result
end

---@param context Context
local function CanHaveCurseOfMaze(context)
    local result = true
    result = hook_can_have_curse_of_the_lost(context, result)
    return result
end

---@param context Context
local function CanHaveCurseOfBlind(context)
    local game = context:GetGame()
    if game.m_dailyChallenge.m_id ~= 0 then
        return false
    end

    return true
end

--#region Module

Module.CanStageHaveCurseOfLabyrinth = CanStageHaveCurseOfLabyrinth
Module.CanHaveCurseOfTheLost = CanHaveCurseOfTheLost
Module.CanHaveCurseOfMaze = CanHaveCurseOfMaze
Module.CanHaveCurseOfBlind = CanHaveCurseOfBlind

--#endregion

return Module