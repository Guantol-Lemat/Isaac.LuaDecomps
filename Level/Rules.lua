--#region Dependencies

local CurseRules = require("Level.Curse.Rules")

--#endregion

---@class LevelRules
local Module = {}

---@param context Context
---@param level LevelComponent
---@param stage LevelStage
---@return LevelStage
local function hook_effective_stage(context, level, stage)
    if CurseRules.HasCurses(context, level, LevelCurse.CURSE_OF_LABYRINTH) then
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

Module.GetEffectiveStage = GetEffectiveStage
Module.ShowName = ShowName

--#endregion

return Module