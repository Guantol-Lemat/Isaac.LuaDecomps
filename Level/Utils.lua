--#region Dependencies

local GameUtils = require("Game.Utils")

--#endregion

---@class LevelUtils
local Module = {}

---@param level LevelComponent
---@return boolean
local function IsAltPath(level)
end

---@param stage LevelStage | integer
---@param stageType StageType | integer
local function GetFloor(stage, stageType)
    if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
        return stage + 1
    end

    return stage
end

--#region Module

Module.IsAltPath = IsAltPath
Module.GetFloor = GetFloor

--#endregion

return Module