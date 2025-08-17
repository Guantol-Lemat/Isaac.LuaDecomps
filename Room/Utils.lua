---@class RoomUtils
local Module = {}

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

--#region Module

Module.GetClampedPositionRaw = GetClampedPositionRaw
Module.GetClampedPosition = GetClampedPosition

--#endregion

return Module