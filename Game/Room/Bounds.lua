--#region Dependencies



--#endregion

---@class LRoomAreaDescComponent

---@param room RoomComponent
---@return LRoomAreaDescComponent
local function GetLRoomAreaDesc(room)
end

---@param room RoomComponent
---@param position Vector
---@param topLeftX number
---@param topLeftY number
---@param bottomRightX number
---@param bottomRightY number
---@return Vector
local function GetClampedPosition(room, position, topLeftX, topLeftY, bottomRightX, bottomRightY)
end

---@param room RoomComponent
---@param position Vector
---@param topLeftX number
---@param topLeftY number
---@param bottomRightX number
---@param bottomRightY number
---@return Vector
local function ScreenWrapPosition(room, position, topLeftX, topLeftY, bottomRightX, bottomRightY)
end

local Module = {}

--#region Module

Module.GetLRoomAreaDesc = GetLRoomAreaDesc
Module.GetClampedPosition = GetClampedPosition
Module.ScreenWrapPosition = ScreenWrapPosition

--#endregion

return Module