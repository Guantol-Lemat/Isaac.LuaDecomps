--#region Dependencies

local RoomGrid = require("Game.Room.Grid")

--#endregion

---@param myContext Context.Room
---@param gridEntity GridEntityComponent
---@return Vector
local function GetPosition(myContext, gridEntity)
    return RoomGrid.GetGridPosition(myContext.room, gridEntity.m_gridIdx)
end

---@param myContext Context.Room
---@param gridEntity GridEntityComponent
---@return boolean
local function IsEasyCrushableOrWalkable(myContext, gridEntity)
end

---@param myContext Context.Room
---@param gridEntity GridEntityComponent
---@return boolean
local function IsDangerousCrushableOrWalkable(myContext, gridEntity)
end

local Module = {}

--#region Module

Module.GetPosition = GetPosition
Module.IsEasyCrushableOrWalkable = IsEasyCrushableOrWalkable
Module.IsDangerousCrushableOrWalkable = IsDangerousCrushableOrWalkable

--#endregion

return Module