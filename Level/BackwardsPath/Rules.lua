--#region Dependencies

local GameUtils = require("Game.Utils")

--#endregion

---@class BackwardsPathRules
local Module = {}

---@param game GameComponent
---@param level LevelComponent
local function IsBackwardsPath(game, level)
    if not GameUtils.HasGameStateFlags(game, GameStateFlag.STATE_BACKWARDS_PATH) then
        return false
    end

    if not (LevelStage.STAGE1_1 <= level.m_stage and level.m_stage <= LevelStage.STAGE3_2) then
        return false
    end

    return true
end

--#region Module

Module.IsBackwardsPath = IsBackwardsPath

--#endregion

return Module