---@class RoomUtils
local Module = {}

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
---@return RenderMode
local function GetRenderMode(room)
end

--#region Module

Module.IsBeastDungeon = IsBeastDungeon
Module.GetClampedPositionRaw = GetClampedPositionRaw
Module.GetClampedPosition = GetClampedPosition
Module.GetRenderMode = GetRenderMode

--#endregion

return Module