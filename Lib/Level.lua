---@class Decomp.Lib.Level
local Lib_Level = {}
Decomp.Lib.Level = Lib_Level

local g_Game = Game()

---@param level Level
---@return LevelStage | integer stage
function Lib_Level.GetTrueStage(level)
    local curses = level:GetCurses()
    local stage = level:GetStage()
    if (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 then
        stage = stage + 1
    end

    return stage
end

---@param level Level
---@return LevelStage | integer stage
function Lib_Level.GetTrueAbsoluteStage(level)
    if g_Game:IsGreedMode() then
        return level:GetAbsoluteStage()
    end

    return Lib_Level.GetTrueStage(level)
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