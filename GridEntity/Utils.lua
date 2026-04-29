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

---@param gridType GridEntityType | integer
local function IsHighPriority(gridType)
    return gridType == GridEntityType.GRID_TRAPDOOR or
        gridType == GridEntityType.GRID_STAIRS or
        gridType == GridEntityType.GRID_PRESSURE_PLATE or
        gridType == GridEntityType.GRID_TELEPORTER
end

local Module = {}

--#region Module

Module.GetPosition = GetPosition
Module.IsEasyCrushableOrWalkable = IsEasyCrushableOrWalkable
Module.IsDangerousCrushableOrWalkable = IsDangerousCrushableOrWalkable
Module.IsHighPriority = IsHighPriority

--#endregion

return Module