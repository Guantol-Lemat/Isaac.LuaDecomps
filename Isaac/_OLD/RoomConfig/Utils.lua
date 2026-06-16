--#region Dependencies

local GameUtils = require("Game.Utils")
local Enums = require("General.Enums")

local eStageId = Enums.eStageId
--#endregion


---@param myContext Context.Game
---@param stage LevelStage | integer
---@param stageType StageType | integer
---@param mode integer
---@return StbType | integer
local function GetStageID(myContext, stage, stageType, mode)
    if mode == -1 then
        mode = GameUtils.GetMode(myContext.game)
    end

    if mode == 1 then
        if stage == LevelStage.STAGE4_1 then
            return eStageId.ULTRA_GREED
        end

        if stage == LevelStage.STAGE3_2 then
            return eStageId.THE_SHOP
        end

        if stage == LevelStage.STAGE3_1 then
            return eStageId.SHEOL
        end

        local altPath = stageType == StageType.STAGETYPE_REPENTANCE or StageType.STAGETYPE_REPENTANCE_B
        if altPath then
            local offset = stage * 2 - 2
            if stageType == StageType.STAGETYPE_REPENTANCE_B then
                offset = offset + 1
            end

            return eStageId.DOWNPOUR + offset
        end

        local offset = stage * 3 - 3 + stageType
        return eStageId.BASEMENT + offset
    end

    if stage == LevelStage.STAGE8 then
        return eStageId.HOME
    end

    if stage == LevelStage.STAGE4_3 then
        return stageType == StageType.STAGETYPE_REPENTANCE and eStageId.ASCENT or eStageId.BLUE_WOMB
    end

    if stage == LevelStage.STAGE7 then
        return eStageId.VOID
    end

    if stage >= LevelStage.STAGE5 then
        local offset = (stage - LevelStage.STAGE5) * 2 + stageType
        return eStageId.SHEOL + offset
    end

    local altPath = stageType == StageType.STAGETYPE_REPENTANCE or StageType.STAGETYPE_REPENTANCE_B
    if altPath then
        local offset = stage * 2 - 2
        if stageType == StageType.STAGETYPE_REPENTANCE_B then
            offset = offset + 1
        end

        return eStageId.DOWNPOUR + offset
    end

    local offset = stage * 3 - 3 + stageType
    return eStageId.BASEMENT + offset
end

---@param doors integer
---@return string
local function DoorsToString(doors)
end

---@param roomConfig RoomConfigComponent
---@param stageId StbType | integer
---@param roomType RoomType | integer
---@param shape RoomShape | integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors eDoorFlags | integer
---@param subtype RoomSubType | integer
---@param mode integer
---@return RoomDataComponent[]
local function GetRooms(roomConfig, stageId, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
end

---@param roomConfig RoomConfigComponent
---@param roomType RoomType | integer
---@param shape RoomShape | integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors eDoorFlags | integer
---@param subtype RoomSubType | integer
---@param mode integer
---@return RoomDataComponent[]
local function GetVoidRooms(roomConfig, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
end

---@param roomConfig RoomConfigComponent
---@param stageID StbType | integer
---@param roomType RoomType | integer
---@param variant integer
---@param mode integer
---@return RoomDataComponent?
local function GetRoom(roomConfig, stageID, roomType, variant, mode)
end

local Module = {}

--#region Module

Module.GetStageID = GetStageID
Module.DoorsToString = DoorsToString
Module.GetRooms = GetRooms
Module.GetVoidRooms = GetVoidRooms
Module.GetRoom = GetRoom

--#endregion

return Module