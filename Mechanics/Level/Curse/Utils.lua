--#region Dependencies

local GameUtils = require("Game.Utils")
local SeedsUtils = require("Admin.Seeds.Utils")

--#endregion

---@class LevelContext.Curses
---@field game GameComponent

---@param myContext LevelContext.Curses
---@param stage LevelStage
local function CanStageHaveCurseOfLabyrinth(myContext, stage)
    if not (LevelStage.STAGE1_1 <= stage and stage <= LevelStage.STAGE4_2) then
        return false
    end

    local game = myContext.game
    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if GameUtils.IsGreedMode(game) then
        return false
    end

    local result = stage % 2 == 1
    return result
end

---@param myContext LevelContext.Curses
---@return boolean
local function CanHaveCurseOfTheLost(myContext)
    local game = myContext.game
    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if GameUtils.IsGreedMode(game) then
        return false
    end

    return true
end

---@param myContext LevelContext.Curses
local function CanHaveCurseOfMaze(myContext)
    local game = myContext.game
    if GameUtils.IsGreedMode(myContext.game) then
        return false
    end

    return true
end

---@param myContext LevelContext.Curses
local function CanHaveCurseOfBlind(myContext)
    local game = myContext.game
    if game.m_dailyChallenge.m_id ~= 0 then
        return false
    end

    return true
end

---@param myContext LevelContext.Curses
---@param level LevelComponent
---@return LevelCurse | integer
local function GetCurses(myContext, level)
    local curses = level.m_curses
    local game = myContext.game
    local seeds = game.m_seeds

    local permanentCurses = SeedsUtils.GetSpecialSeedPermanentCurses(seeds)
    local bannedCurses = SeedsUtils.GetSpecialSeedBannedCurses(seeds)

    -- In the game only the permanent curses check for Curse of the labyrinth (and only for curse of the labyrinth)
    -- This is because the check is in GetSpecialSeedPermanentCurses, however that function should not be the one to handle these checks
    if (permanentCurses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 and not CanStageHaveCurseOfLabyrinth(myContext, level.m_stage) then
        permanentCurses = permanentCurses & ~LevelCurse.CURSE_OF_LABYRINTH
    end

    curses = (curses | permanentCurses | game.m_debugCurses) & ~bannedCurses
    return curses
end

local Module = {}

--#region Module

Module.GetCurses = GetCurses
Module.CanStageHaveCurseOfLabyrinth = CanStageHaveCurseOfLabyrinth
Module.CanHaveCurseOfTheLost = CanHaveCurseOfTheLost
Module.CanHaveCurseOfMaze = CanHaveCurseOfMaze
Module.CanHaveCurseOfBlind = CanHaveCurseOfBlind

--#endregion

return Module