---@class RoomUtils
local Module = {}

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

---@param room RoomComponent
---@param position Vector
---@return integer
local function GetGridIdx(room, position)
end

---@param room RoomComponent
---@param gridIdx integer
---@return Vector
local function GetGridPosition(room, gridIdx)
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
---@return RenderMode
local function GetRenderMode(room)
end

--#region Module

Module.GetFrameCount = GetFrameCount
Module.IsClear = IsClear
Module.IsDungeon = IsDungeon
Module.IsBeastDungeon = IsBeastDungeon
Module.GetGridIdx = GetGridIdx
Module.GetGridPosition = GetGridPosition
Module.GetClampedPositionRaw = GetClampedPositionRaw
Module.GetClampedPosition = GetClampedPosition
Module.GetGridCollision = GetGridCollision
Module.GetGridCollisionAtPos = GetGridCollisionAtPos
Module.GetGridEntity = GetGridEntity
Module.GetGridEntityFromPos = GetGridEntityFromPos
Module.FindFreeTilePosition = FindFreeTilePosition
Module.GetRenderMode = GetRenderMode

--#endregion

return Module