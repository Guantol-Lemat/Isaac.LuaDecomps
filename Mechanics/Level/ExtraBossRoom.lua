--#region Dependencies

local GameUtils = require("Game.Utils")

--#endregion

---@class LevelContext.GetExtraBossRoomStage
---@field game GameComponent

---@param myContext LevelContext.GetExtraBossRoomStage
---@param stage LevelStage | integer
---@param stageType StageType | integer
---@return boolean, LevelStage, StageType
local function GetExtraBossRoomStage(myContext, stage, stageType)
    local isGreed = GameUtils.IsGreedMode(myContext.game)

    local stage4
    local stage5
    local chapterLength

    if isGreed then
        stage4 = LevelStage.STAGE4_GREED
        stage5 = LevelStage.STAGE5_GREED
        chapterLength = 1
    else
        stage4 = LevelStage.STAGE4_1
        stage5 = LevelStage.STAGE5
        chapterLength = 2
    end

    if stage >= stage5 then
        return false, stage, stageType
    end

    -- increase Chapter
    stage = stage + chapterLength

    -- adjust stage
    if not isGreed and stage == LevelStage.STAGE3_2 then -- stage that would always pick Mom's bossID
        stage = LevelStage.STAGE3_1
    end
    stage = math.min(stage, stage4)

    if stage >= stage4 then
        stageType = stageType == StageType.STAGETYPE_REPENTANCE_B and StageType.STAGETYPE_REPENTANCE or stageType
    end

    return true, stage, stageType
end

local Module = {}

--#region Module

Module.GetExtraBossRoomStage = GetExtraBossRoomStage

--#endregion

return Module