--#region Dependencies

local GameUtils = require("Game.Utils")
local SeedsUtils = require("Admin.Seeds.Utils")
local BitSetUtils = require("General.Bitset")

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
---@param level LevelComponent
---@param curses LevelCurse | integer
---@return LevelCurse | integer
local function hook_get_curses(context, level, curses)
    local game = context:GetGame()
    local seeds = context:GetSeeds()

    local permanentCurses = SeedsUtils.GetSpecialSeedPermanentCurses(seeds)
    local bannedCurses = SeedsUtils.GetSpecialSeedBannedCurses(seeds)

    -- In the game only the permanent curses check for Curse of the labyrinth (and only for curse of the labyrinth)
    -- This is because the check is in GetSpecialSeedPermanentCurses, however that function should not be the one to handle these checks
    if BitSetUtils.Test(permanentCurses, LevelCurse.CURSE_OF_LABYRINTH) and not CanStageHaveCurseOfLabyrinth(context, level.m_stage) then
        permanentCurses = BitSetUtils.Clear(permanentCurses, LevelCurse.CURSE_OF_LABYRINTH) -- In the game only the permanent curses check for Curse of the labyrinth
    end

    curses = curses | permanentCurses | game.m_debugCurses
    curses = BitSetUtils.Clear(curses, bannedCurses)

    return curses
end

---@param context Context
---@param level LevelComponent
---@return LevelCurse | integer
local function GetCurses(context, level)
    local curses = level.m_curses
    curses = hook_get_curses(context, level, curses)
    return curses
end

---@param context Context
---@param level LevelComponent
---@param curses LevelCurse | integer
---@return boolean
local function HasCurses(context, level, curses)
    local curseBitset = GetCurses(context, level)
    return BitSetUtils.Test(curseBitset, curses)
end

--#region Module

Module.CanStageHaveCurseOfLabyrinth = CanStageHaveCurseOfLabyrinth
Module.GetCurses = GetCurses
Module.HasCurses = HasCurses

--#endregion

return Module