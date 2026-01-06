--#region Dependencies

local Log = require("General.Log")
local XYUtils = require("General.XY")

--#endregion

---@class LevelGeneratorUtils
local Module = {}

local ROOM_SIZE = {
    {0, 0},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 2},
    {1, 2},
    {2, 1},
    {2, 1},
    {2, 2},
    {2, 2},
    {2, 2},
    {2, 2},
    {2, 2},
}

---@param shape Shape | integer
---@return XYComponent
local function get_room_size(shape)
    return ROOM_SIZE[shape + 1]
end

---@param levelGen LevelGeneratorComponent
---@param shape RoomShape | integer
---@param doors integer
---@return LevelGeneratorRoomComponent?
local function GetNewEndRoom(levelGen, shape, doors)
end

---@param levelGen LevelGeneratorComponent
---@param room LevelGeneratorRoomComponent
local function AddEndRoom(levelGen, room)
end

---@param levelGen LevelGeneratorComponent
---@return LevelGeneratorRoomComponent[]
local function GetRemainingRooms(levelGen)
end

---@param levelGen LevelGeneratorComponent
local function ResetBlockedPosition(levelGen)
    local blockedPositions = levelGen.m_blockedPositions
    for i = 1, 169, 1 do
        blockedPositions[i] = false
    end
end

---@param levelGen LevelGeneratorComponent
---@param xy XYComponent
local function BlockPosition(levelGen, xy)
    local gridIdx = XYUtils.ToRoomIdx(xy)
    if gridIdx >= 0 then
        levelGen.m_blockedPositions[gridIdx + 1] = true
    end
end

---@param levelGen LevelGeneratorComponent
---@param room LevelGeneratorRoomComponent
local function BlockOccupiedAndNeighbors(levelGen, room)
end

--#region Module

Module.get_room_size = get_room_size
Module.GetNewEndRoom = GetNewEndRoom
Module.AddEndRoom = AddEndRoom
Module.GetRemainingRooms = GetRemainingRooms
Module.ResetBlockedPosition = ResetBlockedPosition
Module.BlockPosition = BlockPosition
Module.BlockOccupiedAndNeighbors = BlockOccupiedAndNeighbors

--#endregion

return Module