---@class RoomConfigContext
local Module = {}

---@class RoomConfigContext.GetRandomRoom
---@field curseOfGiant boolean
---@field isVoid boolean

---@class RoomConfigContext.GetRandomBossRoom : RoomConfigContext.GetRandomRoom
---@field persistentGameData PersistentDataComponent
---@field localStageId StbType | integer
---@field gameStateFlags GameStateFlag | integer
---@field curseOfGiant boolean
---@field isVoid boolean

---@param result RoomConfigContext.GetRandomRoom
---@param stage LevelStage | integer
---@param curses LevelCurse | integer
---@return RoomConfigContext.GetRandomRoom
local function BuildGetRandomRoomContext(result, stage, curses)
    result.curseOfGiant = (curses & LevelCurse.CURSE_OF_GIANT) ~= 0
    result.isVoid = stage == LevelStage.STAGE7

    return result
end

---@param result RoomConfigContext.GetRandomBossRoom
---@param stage LevelStage | integer
---@param gameStateFlags GameStateFlag | integer
---@param curses LevelCurse | integer
---@param localStageId StbType | integer
---@return RoomConfigContext.GetRandomBossRoom
local function BuildGetRandomBossRoomContext(result, persistentGameData, stage, gameStateFlags, curses, localStageId)
    result.persistentGameData = persistentGameData
    result.localStageId = localStageId
    result.gameStateFlags = gameStateFlags
    result.curseOfGiant = (curses & LevelCurse.CURSE_OF_GIANT) ~= 0
    result.isVoid = stage == LevelStage.STAGE7

    return result
end

--#region Module

Module.BuildGetRandomRoom = BuildGetRandomRoomContext
Module.BuildGetRandomBossRoomContext = BuildGetRandomBossRoomContext

--#endregion

return Module