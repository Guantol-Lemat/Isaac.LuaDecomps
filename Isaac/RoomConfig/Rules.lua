--#region Dependencies

--#endregion

---@class RoomConfigRules
local Module = {}

---@param myContext RoomConfigContext.GetRandomRoom
---@param roomConfig RoomConfigComponent
---@param seed integer
---@param reduceWeight boolean
---@param stageID StbType | integer
---@param roomType RoomType | integer
---@param shape RoomShape | integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors integer
---@param subtype RoomSubType | integer
---@param mode integer
---@return RoomDataComponent?
local function GetRandomRoom(myContext, roomConfig, seed, reduceWeight, stageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
end

---@param myContext RoomConfigContext.GetRandomRoom
---@param roomConfig RoomConfigComponent
---@param seed integer
---@param reduceWeight boolean
---@param stageID StbType | integer
---@param defaultStageID StbType | integer
---@param roomType RoomType | integer
---@param shape RoomShape | integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors integer
---@param subtype RoomSubType | integer
---@param mode integer
---@return RoomDataComponent?
local function GetRandomRoomFromOptionalStage(myContext, roomConfig, seed, reduceWeight, stageID, defaultStageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
    minVariant = 0
    maxVariant = -1
    mode = -1

    local roomData = GetRandomRoom(myContext, roomConfig, seed, reduceWeight, stageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
    if not roomData then
        roomData = GetRandomRoom(myContext, roomConfig, seed, reduceWeight, defaultStageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode)
    end

    return roomData
end

---@param myContext RoomConfigContext.GetRandomBossRoom
---@param bossId BossType | integer
---@param seed integer
---@return RoomDataComponent?
local function GetRandomBossRoom(myContext, bossId, seed)
end

--#region Module

Module.GetRandomRoom = GetRandomRoom
Module.GetRandomRoomFromOptionalStage = GetRandomRoomFromOptionalStage
Module.GetRandomBossRoom = GetRandomBossRoom

--#endregion

return Module