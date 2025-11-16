---@class RoomConfigUtils
local Module = {}

---@param stage LevelStage | integer
---@param stageType StageType | integer
---@param mode integer
---@return StbType | integer
local function GetStageId(stage, stageType, mode)
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

--#region Module

Module.GetStageId = GetStageId
Module.DoorsToString = DoorsToString
Module.GetRooms = GetRooms
Module.GetVoidRooms = GetVoidRooms
Module.GetRoom = GetRoom

--#endregion

return Module