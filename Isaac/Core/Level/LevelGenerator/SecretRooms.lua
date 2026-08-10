--#region Dependencies

local XY = require("General.XY")
local MyUtils = require("Isaac.Core.Level.LevelGenerator.Utils")
local MyConstants = require("Isaac.Core.Level.LevelGenerator.Constants")
local ILevelGenerator = require("Isaac.Interface.LevelGenerator")

local ILevelGeneratorRoom = ILevelGenerator.Room

--#endregion

local ULTRA_SECRET_ORIGIN_POSITION_OFFSETS = {
    XY.New(-2, 0), -- LEFT
    XY.New(-1, -1), -- TOP-LEFT
    XY.New(0, -2), -- UP
    XY.New(1, -1), -- TOP-RIGHT
    XY.New(2, 0), -- RIGHT
    XY.New(1, 1), -- BOTTOM-RIGHT
    XY.New(0, 2), -- DOWN
    XY.New(-1, 1), -- BOTTOM-LEFT
}

---@alias LevelGenerator.Strategy.NewSecretRoom.GetOrigins fun(levelGen: Component.LevelGenerator, gridIdx: integer, blacklist: Set<integer>): integer, boolean
---@alias LevelGenerator.Strategy.NewSecretRoom.Place fun(room: Component.LevelGenerator.Room, levelGen: Component.LevelGenerator, position: Component.XY)

---@class LevelGenerator.Strategy.NewSecretRoom
---@field GetOrigins LevelGenerator.Strategy.NewSecretRoom.GetOrigins
---@field Place LevelGenerator.Strategy.NewSecretRoom.Place

---@param levelGen Component.LevelGenerator
---@param blacklist Set<integer>
---@param strategy LevelGenerator.Strategy.NewSecretRoom
---@return Component.LevelGenerator.Room?
local function get_new_secret_room(levelGen, blacklist, strategy)
    local myRng = levelGen.m_rng

    local bestCandidates = {}
    local bestScore = 0

    for i = 0, 169 - 1, 1 do
        local isFree = levelGen.m_occupiedPositions[i] < 0
            and levelGen.m_blockedPositions[i] == false
            and blacklist[i]

        if not isFree then
            goto continue
        end

        local score = myRng:RandomInt(5) + 10
        local originCount, invalidOrigin = strategy.GetOrigins(levelGen, i, blacklist)

        local invalid = originCount == 0 or invalidOrigin
        if invalid then
            goto continue
        end

        if originCount <= 2 then
            score = score - 3
        end

        if originCount <= 1 then
            score = score - 3
        end

        if bestScore < score then
            bestScore = score
            bestCandidates = {i}
        elseif bestScore == score then
            table.insert(bestCandidates, i)
        end
        ::continue::
    end

    local numCandidates = #bestCandidates
    if numCandidates == 0 then
        return nil
    end

    local gridIdx = bestCandidates[myRng:RandomInt(numCandidates) + 1]

    local position = MyUtils.ToXY(gridIdx)
    local room = ILevelGeneratorRoom.New(position, RoomShape.ROOMSHAPE_1x1)
    room.m_secret = true
    ILevelGenerator.place_room(levelGen, room)

    local roomIdx = levelGen.m_occupiedPositions[gridIdx + 1]
    room = levelGen.m_rooms[roomIdx + 1]
    ILevelGenerator.calc_required_doors(levelGen, room)

    strategy.Place(room, levelGen, position)
    return room
end

---@type LevelGenerator.Strategy.NewSecretRoom.GetOrigins
local function Secret_get_origins(levelGen, gridIdx)
    local originCount = 0
    local invalidPosition = false

    local position = MyUtils.ToXY(gridIdx)

    for i = Direction.LEFT, Direction.DOWN, 1 do
        local originPosition = XY.Add(position, MyConstants.GetXyDirection(i))
        local originIdx = ILevelGenerator.index(originPosition)

        local originIndex = levelGen.m_occupiedPositions[originIdx + 1]
        if originIndex < 0 then -- no room
            goto continue
        end

        local origin = levelGen.m_rooms[originIndex + 1]

        -- all doors that belong to the same side share the same "validity", so this works
        -- regardless of which door is the actual connection point.
        local originDirection = (i - 2) % 4 -- get the opposite direction
        local targetPosition = ILevelGenerator.get_door_target_position(origin.m_gridPosition, origin.m_shape, originDirection, false)
        if XY.IsInvalid(targetPosition) then
            invalidPosition = true
        else
            originCount = originCount + 1
        end
        ::continue::
    end

    return originCount, invalidPosition
end

---@type LevelGenerator.Strategy.NewSecretRoom.Place
local function Secret_place(room, levelGen, position)
    for i = Direction.LEFT, Direction.DOWN, 1 do
        local adjacentPosition = XY.Add(position, MyConstants.GetXyDirection(i))
        local adjacentIdx = ILevelGenerator.index(adjacentPosition)

        local isOrigin = adjacentIdx >= 0 -- valid
           and levelGen.m_occupiedPositions[adjacentIdx + 1] >= 0 -- occupied

        if isOrigin then
            local originIndex = levelGen.m_occupiedPositions[adjacentIdx + 1]
            -- recalculate doors
            ILevelGenerator.calc_required_doors(levelGen, levelGen.m_rooms[originIndex])
        end
    end
end

---@type LevelGenerator.Strategy.NewSecretRoom.GetOrigins
local function UltraSecret_get_origins(levelGen, gridIdx, blacklist)
    local originCount = 0
    local invalidPosition = false
    local position = MyUtils.ToXY(gridIdx)

    for i = Direction.LEFT, Direction.DOWN, 1 do
        local adjacentPosition = XY.Add(position, MyConstants.GetXyDirection(i))
        local adjacentIdx = ILevelGenerator.index(adjacentPosition)

        local notFree = adjacentIdx >= 0 -- valid
            and (levelGen.m_blockedPositions[adjacentIdx + 1] == true -- blocked
            or levelGen.m_occupiedPositions[adjacentIdx + 1] >= 0) -- occupied

        if notFree then
            invalidPosition = true
            return originCount, invalidPosition
        end
    end

    for i = 1, #ULTRA_SECRET_ORIGIN_POSITION_OFFSETS, 1 do
        local originOffset = ULTRA_SECRET_ORIGIN_POSITION_OFFSETS[i]
        local originPosition = XY.Add(position, originOffset)
        local originIdx = ILevelGenerator.index(originPosition)

        if originIdx < 0 then
            goto continue_1
        end

        local originIndex = levelGen.m_occupiedPositions[originIdx + 1]
        if originIndex < 0 then
            goto continue_1
        end

        local origin = levelGen.m_rooms[originIndex + 1]

        -- check that all adjacent red room origins are valid (they have a door and are not blacklisted)
        for j = Direction.LEFT, Direction.DOWN, 1 do
            -- this is used to filter only the directions that lead to a red room adjacent to
            -- the ultra secret room
            local isDirectionAligned = XY.Dot(originOffset, MyConstants.GetXyDirection(j)) > 0
            if not isDirectionAligned then
                goto continue_2
            end

            -- BUG: origin door is not properly calculated if shape is not 1x1
            local originDoor = (j - 2) % 4 -- get the opposite door
            local targetPosition = ILevelGenerator.get_door_target_position(origin.m_gridPosition, origin.m_shape, originDoor, false)
            local targetIdx = ILevelGenerator.index(targetPosition)

            local valid = targetIdx >= 0
                and blacklist[targetIdx] == nil

            if not valid then
                invalidPosition = true
                return originCount, invalidPosition
            end

            ::continue_2::
        end

        originCount = originCount + 1
        ::continue_1::
    end

    return originCount, invalidPosition
end

---@type LevelGenerator.Strategy.NewSecretRoom.Place
local function UltraSecret_place(room, levelGen, position)
    for i = 1, 8, 1 do
        local originPosition = XY.Add(position, ULTRA_SECRET_ORIGIN_POSITION_OFFSETS[i])
        local originIdx = ILevelGenerator.index(originPosition)

        if originIdx < 0 then
            goto continue_1
        end

        local originIndex = levelGen.m_occupiedPositions[originIdx + 1]
        if originIndex < 0 then
            goto continue_1
        end

        local origin = levelGen.m_rooms[originIndex + 1]

        for j = DoorSlot.LEFT0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
            local targetPosition = ILevelGenerator.get_door_target_position(room.m_gridPosition, room.m_shape, j, false)
            local targetIdx = ILevelGenerator.index(targetPosition)

            local isOriginDoor = not (targetIdx < 0) -- not invalid
                and not (levelGen.m_occupiedPositions[targetIdx + 1] < 0) -- not empty
                and XY.ManhattanDistance(targetPosition, position) == 1 -- adjacent

            if isOriginDoor then
                origin.m_doorsMask = origin.m_doorsMask | 1 << j
            end
        end
        ::continue_1::
    end
end

---@type LevelGenerator.Strategy.NewSecretRoom
local Secret_Strategy = {GetOrigins = Secret_get_origins, Place = Secret_place}

---@type LevelGenerator.Strategy.NewSecretRoom
local UltraSecret_Strategy = {GetOrigins = UltraSecret_get_origins, Place = UltraSecret_place}

---@param levelGen Component.LevelGenerator
---@param blacklist Set<integer>
---@return Component.LevelGenerator.Room?
local function GetNewSecretRoom(levelGen, blacklist)
    return get_new_secret_room(levelGen, blacklist, Secret_Strategy)
end

---@param levelGen Component.LevelGenerator
---@param blacklist Set<integer>
---@return Component.LevelGenerator.Room?
local function GetNewUltraSecretRoom(levelGen, blacklist)
    return get_new_secret_room(levelGen, blacklist, UltraSecret_Strategy)
end

---@class Core.LevelGenerator.SecretRooms
local Module = {}

--#region Module

Module.GetNewSecretRoom = GetNewSecretRoom
Module.GetNewUltraSecretRoom = GetNewUltraSecretRoom

--#endregion

return Module