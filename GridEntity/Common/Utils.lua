--#region Dependencies

local RoomUtils = require("Room.Utils")

--#endregion

---@class GridEntityUtils
local Module = {}

---@param room RoomComponent
---@param gridEntity GridEntityComponent
---@return Vector
local function GetPosition(room, gridEntity)
    return RoomUtils.GetGridPosition(room, gridEntity.m_gridIdx)
end

--#region Module

Module.GetPosition = GetPosition

--#endregion

return Module