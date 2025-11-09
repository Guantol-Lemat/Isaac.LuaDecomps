--#region Dependencies

local LevelRules = require("Level.Rules")

--#endregion

---@class RoomConfigRules
local Module = {}

---@class RoomConfigRules.GetRandomRoomContext
---@field curseOfGiant boolean
---@field isVoid boolean

---@param context Context
---@param result RoomConfigRules.GetRandomRoomContext
---@return RoomConfigRules.GetRandomRoomContext
local function init_get_random_room_context(context, result)
    local level = context:GetLevel()
    local curses = LevelRules.GetCurses(context, level)

    result.curseOfGiant = (curses & LevelCurse.CURSE_OF_GIANT) ~= 0
    result.isVoid = level.m_stage == LevelStage.STAGE7

    return result
end

---@param myContext RoomConfigRules.GetRandomRoomContext
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

--#region Module

Module.init_get_random_room_context = init_get_random_room_context
Module.GetRandomRoom = GetRandomRoom

--#endregion

return Module