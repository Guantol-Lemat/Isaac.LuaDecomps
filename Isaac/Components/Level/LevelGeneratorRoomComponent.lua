--#region Dependencies

local XY = require("General.XY")
local LevelGeneratorConstants = require("Isaac.Core.Level.LevelGenerator.Constants")

--#endregion

---@class Component.LevelGenerator.Room
---@field m_unkBool boolean : 0x0
---@field m_generationIndex integer : 0x4
---@field m_gridPosition Component.XY : 0x8
---@field m_horizontalSize integer : 0x10
---@field m_verticalSize integer : 0x14
---@field m_shape RoomShape | integer : 0x18
---@field m_doorsMask integer : 0x1c
---@field m_originDirection integer : 0x20
---@field m_originDoor DoorSlot | integer : 0x24
---@field m_linkPosition Component.XY : 0x28
---@field m_neighbors Set<integer> : 0x30
---@field m_deadEnd boolean : 0x3c
---@field m_distanceFromStart integer : 0x40
---@field m_secret boolean : 0x44

local UNINITIALIZED_INT = 0

---@param position Component.XY
---@param shape RoomShape | integer
---@return Component.LevelGenerator.Room
local function New(position, shape)
    local horizontalSize, verticalSize = LevelGeneratorConstants.GetRoomSize(shape)

    ---@type Component.LevelGenerator.Room
    return {
        m_unkBool = true,
        m_generationIndex = UNINITIALIZED_INT,
        m_gridPosition = XY.Copy(position),
        m_horizontalSize = horizontalSize,
        m_verticalSize = verticalSize,
        m_shape = shape,
        m_doorsMask = 0,
        m_originDirection = Direction.NO_DIRECTION,
        m_originDoor = DoorSlot.NO_DOOR_SLOT,
        m_linkPosition = XY.NewInvalid(),
        m_neighbors = {},
        m_deadEnd = false,
        m_distanceFromStart = 0,
        m_secret = false
    }
end

---@class Module.LevelGenerator.Room
local Module = {}

--#region Module

Module.New = New


--#endregion

return Module
