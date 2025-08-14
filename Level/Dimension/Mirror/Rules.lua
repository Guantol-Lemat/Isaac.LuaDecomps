--#region Dependencies

local GameUtils = require("Game.Utils")
local LevelUtils = require("Level.Utils")
local LevelRules = require("Level.Rules")
local BackwardsUtils = require("Level.BackwardsPath.Utils")

--#endregion

---@class MirrorDimensionRules
local Module = {}

---@param context Context
---@param game GameComponent
---@param level LevelComponent
---@return boolean
local function LevelHasMirrorDimension(context, game, level)
    if GameUtils.IsGreedMode(game) then
        return false
    end

    if BackwardsUtils.IsBackwardsPath(game, level) then
        return false
    end

    if not LevelUtils.IsAltPath(level) then
        return false
    end

    local stage = LevelRules.GetEffectiveStage(context, level)
    return stage == LevelStage.STAGE1_2
end

---@param context Context
---@param game GameComponent
---@param level LevelComponent
---@return boolean
local function IsMirrorWorld(context, game, level)
    return level.m_dimension == Dimension.KNIFE_PUZZLE and LevelHasMirrorDimension(context, game, level)
end

--#region Module

Module.LevelHasMirrorDimension = LevelHasMirrorDimension
Module.IsMirrorWorld = IsMirrorWorld

--#endregion

return Module