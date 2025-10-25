--#region Dependencies

local BitSetUtils = require("General.Bitset")
local SeedsUtils = require("Admin.Seeds.Utils")
local CurseRules = require("Mechanics.Level.Curse.Rules")

--#endregion

---@class LevelRules
local Module = {}

---@param context Context
---@param level LevelComponent
---@param stage LevelStage | integer
---@param stageType StageType | integer
local function SetStage(context, level, stage, stageType)
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
    if BitSetUtils.Test(permanentCurses, LevelCurse.CURSE_OF_LABYRINTH) and not CurseRules.CanStageHaveCurseOfLabyrinth(context, level.m_stage) then
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

---@param context Context
---@param level LevelComponent
---@param stage LevelStage
---@return LevelStage
local function hook_effective_stage(context, level, stage)
    if HasCurses(context, level, LevelCurse.CURSE_OF_LABYRINTH) then
        stage = stage + 1
    end

    return stage
end

---@param context Context
---@param level LevelComponent
---@return LevelStage
local function GetEffectiveStage(context, level)
    local stage = level.m_stage
    stage = hook_effective_stage(context, level, stage)
    return stage
end

---@param context Context
---@param level LevelComponent
---@param sticky boolean
local function ShowName(context, level, sticky)
end

--#region Module

Module.SetStage = SetStage
Module.GetCurses = GetCurses
Module.HasCurses = HasCurses
Module.GetEffectiveStage = GetEffectiveStage
Module.ShowName = ShowName

--#endregion

return Module