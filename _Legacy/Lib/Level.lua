---@class Decomp.Lib.Level
local Lib_Level = {}
Decomp.Lib.Level = Lib_Level

local g_Game = Game()

---@param api Decomp.IGlobalAPI
---@param level Decomp.LevelObject
---@return LevelStage | integer stage
local function GetTrueStage(api, level)
    local curses = api.Level.GetCurses(level)
    local stage = api.Level.GetStage(level)
    if (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 then
        stage = stage + 1
    end

    return stage
end

---@param env Decomp.EnvironmentObject
---@param level Decomp.LevelObject
---@return LevelStage | integer stage
local function GetTrueAbsoluteStage(env, level)
    local api = env._API
    local game = api.Isaac.GetGame(env)

    if api.Game.IsGreedMode(game) then
        return api.Level.GetAbsoluteStage(level)
    end

    return Lib_Level.GetTrueStage(api, level)
end

---@param level Level
---@return boolean
function Lib_Level.IsAltPath(level)
    local stageType = level:GetStageType()
    return stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
end

---@param level Level
---@return boolean
function Lib_Level.IsCorpseEntrance(level)
    if g_Game:IsGreedMode() or level:IsAscent() then
        return false
    end

    local stage = Lib_Level.GetTrueStage(level)
    return stage == LevelStage.STAGE3_2 and Lib_Level.IsAltPath(level) and g_Game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED)
end

--#region Module

Lib_Level.GetTrueStage = GetTrueStage
Lib_Level.GetTrueAbsoluteStage = GetTrueAbsoluteStage

--#endregion

return Lib_Level