--#region Dependencies

local XY = require("General.XY")

--#endregion Dependencies

local ROOM_SIZE = {
    [0 + 1] = { 0, 0 },
    [RoomShape.ROOMSHAPE_1x1 + 1] = { 1, 1 },
    [RoomShape.ROOMSHAPE_IH + 1] = { 1, 1 },
    [RoomShape.ROOMSHAPE_IV + 1] = { 1, 1 },
    [RoomShape.ROOMSHAPE_1x2 + 1] = { 1, 2 },
    [RoomShape.ROOMSHAPE_IIV + 1] = { 1, 2 },
    [RoomShape.ROOMSHAPE_2x1 + 1] = { 2, 1 },
    [RoomShape.ROOMSHAPE_IIH + 1] = { 2, 1 },
    [RoomShape.ROOMSHAPE_2x2 + 1] = { 2, 2 },
    [RoomShape.ROOMSHAPE_LTL + 1] = { 2, 2 },
    [RoomShape.ROOMSHAPE_LTR + 1] = { 2, 2 },
    [RoomShape.ROOMSHAPE_LBL + 1] = { 2, 2 },
    [RoomShape.ROOMSHAPE_LBR + 1] = { 2, 2 },
}

local DIRECTION_TO_XY_OFFSET = {
    [Direction.LEFT + 1] = XY.New(-1, 0),
    [Direction.UP + 1] = XY.New(0, -1),
    [Direction.RIGHT + 1] = XY.New(1, 0),
    [Direction.DOWN + 1] = XY.New(0, -1)
}

---@param shape RoomShape | integer
---@return integer, integer
local function GetRoomSize(shape)
    local size = ROOM_SIZE[shape + 1]
    return size[1], size[2]
end

---@param direction Direction | integer
---@return Component.XY
local function GetXyDirection(direction)
    local offset = DIRECTION_TO_XY_OFFSET[direction + 1]
    return {X = offset.X, Y = offset.Y}
end

---@class Core.LevelGenerator.Constants
local Module = {}

--#region Module

Module.room_size = ROOM_SIZE
Module.GetRoomSize = GetRoomSize
Module.GetXyDirection = GetXyDirection

--#endregion

return Module