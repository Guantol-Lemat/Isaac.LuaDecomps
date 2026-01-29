--#region Dependencies

local LevelUtils = require("Game.Level.Utils")

--#endregion

---@class RoomContext.IsCurrentRoomLastBoss
---@field level LevelComponent

---@param myContext RoomContext.GetFrameCount
---@param room RoomComponent
---@return integer
local function GetFrameCount(myContext, room)
    if not room.m_isInitialized then
        return -1
    end

    return myContext.frameCount - room.m_initialFrameCount
end

---@param room RoomComponent
---@return boolean
local function IsClear(room)
    local flags = room.m_roomDescriptor.m_flags
    return (flags & RoomDescriptor.FLAG_CLEAR) ~= 0
end

---@param room RoomComponent
---@return boolean
local function IsDungeon(room)
    return room.m_type == RoomType.ROOM_DUNGEON
end

---@param room RoomComponent
---@return boolean
local function IsBeastDungeon(room)
    local data = room.m_roomDescriptor.m_data
    if not data then
        return false
    end

    return data.m_type == RoomType.ROOM_DUNGEON and data.m_stageID == StbType.HOME
end

---@param myContext RoomContext.IsCurrentRoomLastBoss
---@return boolean
local function IsCurrentRoomLastBoss(myContext)
    local level = myContext.level
    local room = LevelUtils.GetRoomByIdx(level, level.m_roomIdx, Dimension.CURRENT)
    return room.m_listIdx == level.m_lastBossListIdx
end

---@param position Vector
---@return Vector
local function ToGridTile(position)
    local x = math.floor((position.X - 40.0) / 40.0 + 0.5)
    local y = math.floor((position.Y - 120.0) / 40.0 + 0.5)

    return Vector(x, y)
end

---@param room RoomComponent
---@param position Vector
---@return integer
local function GetGridIdx(room, position)
    local x = math.floor((position.X - 40.0) / 40.0 + 0.5)
    local y = math.floor((position.Y - 120.0) / 40.0 + 0.5)

    local width = room.m_gridWidth
    if (0 >= x or x >= width) or (0 >= y or y >= room.m_gridHeight) then
        return -1
    end

    return x + y * width
end

---@param room RoomComponent
---@param tile Vector
---@return integer
local function GetGridIndexByTile(room, tile)
    local x = tile.X
    local y = tile.Y

    local width = room.m_gridWidth
    if (0 >= x or x >= width) or (0 >= y or y >= room.m_gridHeight) then
        return -1
    end

    return x + y * width
end

---@param room RoomComponent
---@param gridIdx integer
---@return Vector
local function GetGridPosition(room, gridIdx)
    local width = room.m_gridWidth
    local x = (gridIdx % width) * 40.0 + 40.0
    local y = (gridIdx / width) * 40.0 + 120.0

    return Vector(x, y)
end

---@param room RoomComponent
---@param gridIdx integer
---@return Vector
local function GetGridTile(room, gridIdx)
    local width = room.m_gridWidth
    local x = gridIdx % width
    local y = math.floor(gridIdx / width)

    return Vector(x, y)
end

---@param room RoomComponent
---@param position Vector
---@param topLeft Vector
---@param bottomRight Vector
---@return Vector
local function GetClampedPositionRaw(room, position, topLeft, bottomRight)
end

---@param room RoomComponent
---@param position Vector
---@param margin number
---@return Vector
local function GetClampedPosition(room, position, margin)
    local marginVector = Vector(margin, margin)
    return GetClampedPositionRaw(room, position, marginVector, marginVector)
end

---@param room RoomComponent
---@return Vector
local function GetCenterPos(room)
end

---@param room RoomComponent
---@param gridIdx integer
---@return GridCollisionClass | integer
local function GetGridCollision(room, gridIdx)
end

---@param room RoomComponent
---@param position Vector
---@return GridCollisionClass | integer
local function GetGridCollisionAtPos(room, position)
    return GetGridCollision(room, GetGridIdx(room, position))
end

---@param room RoomComponent
---@return integer
local function GetGridPath(room, gridIndex)
    if 0 <= gridIndex and gridIndex < 448 then
        return room.m_gridPaths[gridIndex + 1]
    end

    return 0
end

---@param room RoomComponent
---@param gridIndex integer
---@param value integer
---@return boolean
local function SetGridPath(room, gridIndex, value)
    if 0 <= gridIndex and gridIndex < 448 then
        room.m_gridPaths[gridIndex + 1] = value
        return true
    end

    return false
end

---@param room RoomComponent
---@param gridIdx integer
---@return GridEntityComponent?
local function GetGridEntity(room, gridIdx)
end

---@param room RoomComponent
---@param position Vector
---@return GridEntityComponent?
local function GetGridEntityFromPos(room, position)
    return GetGridEntity(room, GetGridIdx(room, position))
end

---@param room RoomComponent
---@param position Vector
---@param distanceThreshold number
---@return Vector
local function FindFreeTilePosition(room, position, distanceThreshold)
end

---@param room RoomComponent
---@param position Vector
---@param initialStep number
---@param avoidActiveEntities boolean
---@param allowPits boolean
---@return Vector
local function FindFreePickupSpawnPosition(room, position, initialStep, avoidActiveEntities, allowPits)
end

---@param room RoomComponent
---@return RenderMode
local function GetRenderMode(room)
end

---@param myContext Context.Common
---@param seed integer
---@param noDecrease boolean
---@return CollectibleType
local function GetSeededCollectible(myContext, seed, noDecrease)
end

local Module = {}

--#region Module

Module.GetFrameCount = GetFrameCount
Module.IsClear = IsClear
Module.IsDungeon = IsDungeon
Module.IsBeastDungeon = IsBeastDungeon
Module.IsCurrentRoomLastBoss = IsCurrentRoomLastBoss
Module.ToGridTile = ToGridTile
Module.GetGridIdx = GetGridIdx
Module.GetGridIndexByTile = GetGridIndexByTile
Module.GetGridPosition = GetGridPosition
Module.GetGridTile = GetGridTile
Module.GetClampedPositionRaw = GetClampedPositionRaw
Module.GetClampedPosition = GetClampedPosition
Module.GetCenterPos = GetCenterPos
Module.GetGridCollision = GetGridCollision
Module.GetGridCollisionAtPos = GetGridCollisionAtPos
Module.GetGridPath = GetGridPath
Module.SetGridPath = SetGridPath
Module.GetGridEntity = GetGridEntity
Module.GetGridEntityFromPos = GetGridEntityFromPos
Module.FindFreeTilePosition = FindFreeTilePosition
Module.FindFreePickupSpawnPosition = FindFreePickupSpawnPosition
Module.GetRenderMode = GetRenderMode
Module.GetSeededCollectible = GetSeededCollectible

--#endregion

return Module