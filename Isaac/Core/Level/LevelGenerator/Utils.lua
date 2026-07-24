--#region Dependencies

local XY = require("General.XY")

--#endregion

local s_RoomSize = {
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

---@param shape RoomShape | integer
---@return Component.XY[]
local function calc_placement_offsets(shape)
    local placementOffsets = {}
    local size = s_RoomSize[shape + 1]

    for h = 1, size[2], 1 do
        for w = 1, size[1], 1 do
            table.insert(placementOffsets, XY.New(w - 1, h - 1))
        end
    end

    if shape >= RoomShape.ROOMSHAPE_LTL and shape <= RoomShape.ROOMSHAPE_LBR then
        local lShape = shape - RoomShape.ROOMSHAPE_LTL
        local missingIdx = lShape + 1
        table.remove(placementOffsets, missingIdx)
    end

    return placementOffsets
end

---@param direction Direction | integer
---@return Component.XY
local function get_direction_offset(direction)
    local directionSign = direction // 2 == 0 and -1 or 1
    local hShift = direction % 2 == 0 and 1 or 0
    local vShift = direction % 2 == 1 and 1 or 0

    return XY.New(hShift * directionSign, vShift * directionSign)
end

local s_PlacementOffsets = {
    [0 + 1] = calc_placement_offsets(0),
    [RoomShape.ROOMSHAPE_1x1 + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_1x1),
    [RoomShape.ROOMSHAPE_IH + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_IH),
    [RoomShape.ROOMSHAPE_IV + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_IV),
    [RoomShape.ROOMSHAPE_1x2 + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_1x2),
    [RoomShape.ROOMSHAPE_IIV + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_IIV),
    [RoomShape.ROOMSHAPE_2x1 + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_2x1),
    [RoomShape.ROOMSHAPE_IIH + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_IIH),
    [RoomShape.ROOMSHAPE_2x2 + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_2x2),
    [RoomShape.ROOMSHAPE_LTL + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_LTL),
    [RoomShape.ROOMSHAPE_LTR + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_LTR),
    [RoomShape.ROOMSHAPE_LBL + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_LBL),
    [RoomShape.ROOMSHAPE_LBR + 1] = calc_placement_offsets(RoomShape.ROOMSHAPE_LBR)
}

---Returns the gridIdx for the given position.
---
---Returns -1 for an invalid position.
---@param xy Component.XY
---@return integer
local function Index(xy)
    local x = xy.X
    local y = xy.Y

    if (not (0 <= x and x < 13)) or (not (0 <= y and y < 13)) then
        return -1
    end

    return y * 13 + x
end

---@param idx integer
---@return Component.XY
local function to_xy(idx)
    local x = idx % 13
    local y = idx // 13

    return XY.New(x, y)
end

---@param shape RoomShape | integer
---@param door DoorSlot | integer
---@return integer, integer
local function get_door_source_offset(shape, door)
    local doorOrientation = door % 2
    local oppositeOrientation = (1 - doorOrientation)

    local doorDirection = door % 4
    local doorOrientationWeight = doorDirection >= 2 and 1 or 0
    local oppositeOrientationWeight = door >= 4 and 1 or 0

    local orientationWeight = {0, 0}
    orientationWeight[doorOrientation + 1] = doorOrientationWeight
    orientationWeight[oppositeOrientation + 1] = oppositeOrientationWeight

    local roomSize = s_RoomSize[shape + 1]
    local hSize, vSize = roomSize[1], roomSize[2]

    local source = {(hSize - 1) * orientationWeight[1], (vSize - 1) * orientationWeight[2]}

    if shape >= RoomShape.ROOMSHAPE_LTL and shape <= RoomShape.ROOMSHAPE_LBR then
        local lShape = shape - RoomShape.ROOMSHAPE_LTL
        local missing = {lShape // 2, lShape % 2}

        if source[1] == missing[1] and source[2] == missing[2] then
            local directionSign = doorDirection // 2 == 0 and -1 or 1
            source[doorOrientation + 1] = source[doorOrientation + 1] - directionSign
        end
    end

    return source[1], source[2]
end

---@param shape RoomShape | integer
---@return integer, integer
local function GetRoomSize(shape)
    local size = s_RoomSize[shape + 1]
    return size[1], size[2]
end

---Determines if the given room shape has the given door slot.
---@param shape RoomShape | integer
---@param door DoorSlot | integer
---@param ignoreClosetLimits boolean
local function HasShapeSlot(shape, door, ignoreClosetLimits)
    local doorOrientation = door % 2
    local doorIsHorizontal = door % 2 == 0
    if not ignoreClosetLimits then
        local horizontalLimit = shape == RoomShape.ROOMSHAPE_IV or shape == RoomShape.ROOMSHAPE_IIV
        if horizontalLimit and doorIsHorizontal then
            return false
        end

        local verticalLimit = shape == RoomShape.ROOMSHAPE_IH or shape == RoomShape.ROOMSHAPE_IIH
        if verticalLimit and not doorIsHorizontal then
            return false
        end
    end

    local orientationSize = s_RoomSize[shape + 1][doorOrientation + 1]
    local requiredSize = door // 4 + 1
    return orientationSize >= requiredSize
end

---Determines for the given shape, the XY position where the given door is located.
---@param position Component.XY
---@param shape RoomShape | integer
---@param door DoorSlot | integer
---@return Component.XY
local function GetDoorSourcePosition(position, shape, door)
    if not HasShapeSlot(shape, door, false) then
        return XY.NewInvalid()
    end

    if shape >= RoomShape.NUM_ROOMSHAPES then
        return XY.NewInvalid()
    end

    local x, y = get_door_source_offset(shape, door)
    return XY.New(position.X + x, position.Y + y)
end

---Determines for the given shape, where the door leads to.
---@param position Component.XY
---@param shape RoomShape | integer
---@param door DoorSlot | integer
---@param ignoreClosetLimits boolean
---@return Component.XY
local function GetDoorTargetPosition(position, shape, door, ignoreClosetLimits)
    if not HasShapeSlot(shape, door, ignoreClosetLimits) then
        return XY.NewInvalid()
    end

    local x, y = get_door_source_offset(shape, door)

    local doorOrientation = door % 2
    local directionSign = (door % 4) // 2 == 0 and -1 or 1
    local targetOffset = {0, 0}
    targetOffset[doorOrientation + 1] = directionSign

    return XY.New(position.X + x + targetOffset[1], position.Y + y + targetOffset[2])
end

---Gives the slots occupied by the given shape
---@param shape RoomShape | integer
---@return Component.XY[]
local function GetRoomPlacementOffsets(shape)
    return s_PlacementOffsets[shape + 1]
end

---Checks if the shape does not occupy an already occupied positions
---or a blocked position.
---@param levelGen Component.LevelGenerator
---@param position Component.XY
---@param shape RoomShape | integer
---@return boolean
local function IsPosFree(levelGen, position, shape)
    local megaSatanIdx = -1

    local startingRoom = levelGen.m_rooms[1]
    if startingRoom then
        local startingPosition = startingRoom.m_gridPosition
        local megaSatanPosition = XY.New(startingPosition.X, startingPosition.Y - 1)
        megaSatanIdx = Index(megaSatanPosition)
    end

    local placementOffsets = GetRoomPlacementOffsets(shape)
    for i = 1, #placementOffsets, 1 do
        local placementPosition = XY.Add(position, placementOffsets[i])
        local placementIdx = Index(placementPosition)

        local canPlace = placementIdx >= 0
            and not (levelGen.m_isChapter6 and placementIdx == megaSatanIdx)
            and levelGen.m_occupiedPositions[placementIdx + 1] < 0
            and levelGen.m_blockedPositions[placementIdx + 1] == false

        if not canPlace then
            return false
        end
    end

    return true
end

---Checks if the placed room would have a valid connection to all neighbors
---@param levelGen Component.LevelGenerator
---@param position Component.XY
---@param shape RoomShape | integer
---@return boolean
local function IsPlacementValid(levelGen, position, shape)
    for door = DoorSlot.LEFT0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        local sourcePosition = GetDoorSourcePosition(position, shape, door)
        local targetPosition = GetDoorTargetPosition(position, shape, door, true)

        local targetIdx = Index(targetPosition)
        local targetIsFree = targetIdx < 0
            or levelGen.m_occupiedPositions[targetIdx + 1] < 0

        if targetIsFree then
            goto continue
        end

        if XY.IsInvalid(sourcePosition) then
            return false
        end

        local neighborIdx = levelGen.m_occupiedPositions[targetIdx + 1]
        local neighbor = levelGen.m_rooms[neighborIdx + 1]

        for neighborDoor = DoorSlot.LEFT0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
            local neighborTargetPosition = GetDoorTargetPosition(neighbor.m_gridPosition, neighbor.m_shape, neighborDoor, false)
            -- connection found
            if XY.Equals(neighborTargetPosition, sourcePosition) then
                break
            end

            -- iterated all rooms, none had a connection to source position
            if neighborDoor == DoorSlot.NUM_DOOR_SLOTS - 1 then
                return false
            end
        end
        ::continue::
    end

    return true
end

---Counts how many neighbors the current room at the given position has
---
---If the given position is not occupied by a room, then the amount of
---rooms adjacent to that position is counted instead.
---@param levelGen Component.LevelGenerator
---@param position Component.XY
---@return integer
local function CountNeighbors(levelGen, position)
    local count = 0
    local roomGridIdx = Index(position)
    local roomIdx = levelGen.m_occupiedPositions[roomGridIdx + 1]

    for i = Direction.LEFT, Direction.DOWN, 1 do
        local neighborPosition = XY.Add(position, get_direction_offset(i))
        local neighborGridIdx = Index(neighborPosition)

        if neighborGridIdx < 0 then
            goto continue
        end

        local neighborIdx = levelGen.m_occupiedPositions[neighborGridIdx + 1]
        if neighborIdx > -1 and neighborIdx ~= roomIdx then
            count = count + 1
        end
        ::continue::
    end

    return count
end

---Blocks the given position.
---
---Handles invalid positions
---@param levelGen Component.LevelGenerator
---@param position Component.XY
local function BlockPosition(levelGen, position)
    local gridIdx = Index(position)
    if gridIdx >= 0 then
        levelGen.m_blockedPositions[gridIdx + 1] = true
    end
end

---Blocks both the given position and it's neighbors
---@param levelGen Component.LevelGenerator
---@param position Component.XY
local function block_occupied_and_neighbors(levelGen, position)
    BlockPosition(levelGen, position)

    for dir = Direction.LEFT, Direction.DOWN, 1 do
        local dirOffset = get_direction_offset(dir)
        local neighborPosition = XY.Add(position, dirOffset)
        BlockPosition(levelGen, neighborPosition)
    end
end

---Blocks all the occupied and neighbor positions of each room
---from the given LevelGenerator.
---@param levelGen Component.LevelGenerator
---@param other Component.LevelGenerator
local function BlockOccupiedAndNeighbors_LevelGen(levelGen, other)
    -- in game this is implemented differently:
    -- given an idx check if any of it's neighbors are occupied, but this leads to the same
    -- outcome
    for i = 0, 168, 1 do
        if other.m_occupiedPositions[i + 1] >= 0 then
            local position = to_xy(i)
            block_occupied_and_neighbors(levelGen, position)
        end
    end
end

---Blocks the occupied and neighbor positions the given room.
---@param levelGen Component.LevelGenerator
---@param room Component.LevelGenerator.Room
local function BlockOccupiedAndNeighbors_Room(levelGen, room)
    local placementOffsets = GetRoomPlacementOffsets(room.m_shape)
    local roomGridPosition = room.m_gridPosition

    for i = 1, #placementOffsets, 1 do
        local offset = placementOffsets[i]
        local placementPosition = XY.Add(roomGridPosition, offset)

        BlockPosition(levelGen, placementPosition)

        for dir = Direction.LEFT, Direction.DOWN, 1 do
            local dirOffset = get_direction_offset(dir)
            local neighborPosition = XY.Add(placementPosition, dirOffset)
            BlockPosition(levelGen, neighborPosition)
        end
    end
end

---Blocks the TargetPosition of the given disabled doors.
---
---A door is disabled if the bit for that door is false.
---@param levelGen Component.LevelGenerator
---@param room Component.LevelGenerator.Room
---@param doors integer
local function BlockDisabledDoorPositions(levelGen, room, doors)
    for i = DoorSlot.LEFT0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        if doors & (1 << i) ~= 0 then
            goto continue
        end

        local targetPosition = GetDoorTargetPosition(room.m_gridPosition, room.m_shape, i, true)
        BlockPosition(levelGen, targetPosition)
        ::continue::
    end
end

---Gets the list of yet to be placed rooms
---
---The list depends on the deadEnd pool and nonDeadEnd pool
---@param levelGen Component.LevelGenerator
---@return Component.LevelGenerator.Room[]
local function GetRemainingRooms(levelGen)
    local remainingRooms = {}
    local rooms = levelGen.m_rooms

    local normalRooms = levelGen.m_nonDeadEnds
    for i = 1, #normalRooms, 1 do
        local roomIdx = normalRooms[i]
        table.insert(remainingRooms, rooms[roomIdx + 1])
    end

    local deadEnds = levelGen.m_deadEnds
    for i = 1, #deadEnds, 1 do
        local roomIdx = deadEnds[i]
        table.insert(remainingRooms, rooms[roomIdx + 1])
    end

    return remainingRooms
end

---@class Level.LevelGenerator.Utils
local Module = {}

--#region Module

Module.Index = Index
Module.GetRoomSize = GetRoomSize
Module.HasShapeSlot = HasShapeSlot
Module.GetDoorSourcePosition = GetDoorSourcePosition
Module.GetDoorTargetPosition = GetDoorTargetPosition
Module.GetRoomPlacementOffsets = GetRoomPlacementOffsets
Module.IsPosFree = IsPosFree
Module.IsPlacementValid = IsPlacementValid
Module.CountNeighbors = CountNeighbors
Module.BlockPosition = BlockPosition
Module.BlockOccupiedAndNeighbors_LevelGen = BlockOccupiedAndNeighbors_LevelGen
Module.BlockOccupiedAndNeighbors_Room = BlockOccupiedAndNeighbors_Room
Module.BlockDisabledDoorPositions = BlockDisabledDoorPositions
Module.GetRemainingRooms = GetRemainingRooms

--#endregion

return Module