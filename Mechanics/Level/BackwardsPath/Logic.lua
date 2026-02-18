--#region Dependencies



--#endregion

---@param myContext Context.Game
---@param level LevelComponent
---@return boolean
local function IsBackwardsPath(myContext, level)
    local game = myContext.game
    if (game.m_gameStateFlags & GameStateFlag.STATE_BACKWARDS_PATH) == 0 then
        return false
    end

    if not (LevelStage.STAGE1_1 <= level.m_stage and level.m_stage <= LevelStage.STAGE3_2) then
        return false
    end

    return true
end

---@param myContext Context.Game
---@param level LevelComponent
---@param stage LevelStage | integer
local function SaveBackwardsStage(myContext, level, stage)
end

local Module = {}

--#region Module

Module.IsBackwardsPath = IsBackwardsPath
Module.SaveBackwardsStage = SaveBackwardsStage

--#endregion

return Module