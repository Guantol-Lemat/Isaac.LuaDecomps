--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")
local RoomUtils = require("Game.Room.Utils")
local GridEntityUtils = require("GridEntity.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")

--#endregion

---@param room RoomComponent
---@param gridIdx integer
---@return GridEntityComponent?
local function GetGridEntity(room, gridIdx)
    if 0 <= gridIdx or gridIdx < 448 then
        return room.m_gridEntityList[gridIdx + 1]
    end

    return nil
end

---@param room RoomComponent
---@param gridIdx integer
---@return integer
local function GetGridPath(room, gridIdx)
    if 0 <= gridIdx or gridIdx < 448 then
        return room.m_gridPaths[gridIdx + 1]
    end

    return 0
end

---@param position Vector
---@return Vector
local function ToGridTile(position)
    local x = math.floor((position.X - 40.0) / 40.0 + 0.5)
    local y = math.floor((position.Y - 120.0) / 40.0 + 0.5)

    return Vector(x, y)
end

---@param room RoomComponent
---@param position Vector
---@return integer
local function GetGridIdx(room, position)
    local x = math.floor((position.X - 40.0) / 40.0 + 0.5)
    local y = math.floor((position.Y - 120.0) / 40.0 + 0.5)

    local width = room.m_gridWidth
    if (0 >= x or x >= width) or (0 >= y or y >= room.m_gridHeight) then
        return -1
    end

    return x + y * width
end

---@param room RoomComponent
---@param tile Vector
---@return integer
local function GetGridIndexByTile(room, tile)
    local x = tile.X
    local y = tile.Y

    local width = room.m_gridWidth
    if (0 >= x or x >= width) or (0 >= y or y >= room.m_gridHeight) then
        return -1
    end

    return x + y * width
end

---@param room RoomComponent
---@param gridIdx integer
---@return Vector
local function GetGridPosition(room, gridIdx)
    local width = room.m_gridWidth
    local x = (gridIdx % width) * 40.0 + 40.0
    local y = (gridIdx / width) * 40.0 + 120.0

    return Vector(x, y)
end

---@param room RoomComponent
---@param gridIdx integer
---@return GridCollisionClass | integer
local function GetGridCollision(room, gridIdx)
    if RoomUtils.IsBeastDungeon(room) then
        return GridCollisionClass.COLLISION_NONE
    end

    if gridIdx < 0 then
        return GridCollisionClass.COLLISION_WALL
    end

    local gridEntity = room.m_gridEntityList[gridIdx + 1]
    if gridEntity then
        return gridEntity.m_collisionClass
    end

    local pathMark = room.m_gridPaths[gridIdx + 1]
    if 3000 <= pathMark and pathMark < 4000 then
        return GridCollisionClass.COLLISION_PIT
    end

    if pathMark < 1000 then
        return GridCollisionClass.COLLISION_NONE
    end

    return GridCollisionClass.COLLISION_SOLID
end

---@param room RoomComponent
---@param position Vector
---@return GridCollisionClass | integer
local function GetGridCollisionAtPos(room, position)
    return GetGridCollision(room, GetGridIdx(room, position))
end

---@param myContext Context.Common
---@param room RoomComponent
---@param pos1 Vector
---@param pos2 Vector
---@param mode LineCheckMode
---@param gridPathThreshold integer
---@param ignoreWalls boolean
---@param ignoreCrushable boolean
---@return boolean, Vector
local function CheckLine(myContext, room, pos1, pos2, mode, gridPathThreshold, ignoreWalls, ignoreCrushable)
    local displacement = pos2 - pos1
    local distance = displacement:Length()

    if distance <= 0.0 then
        return true, VectorUtils.Copy(pos2)
    end

    ---@type Context.Room
    local roomContext = {room = room}
    local playerManager = myContext.game.m_playerManager
    local stepVector = displacement:Resize(10.0)
    local gridEntityList = room.m_gridEntityList

    --#region CheckGridIndex
    local startGridIdx = GetGridIdx(room, pos1)
    local partialHits = 0

    local switch_check_grid_index = {
        [LineCheckMode.ENTITY] = function(index)
            local collisionClass = GetGridCollision(room, index)

            if collisionClass == GridCollisionClass.COLLISION_NONE then
                if index ~= startGridIdx then
                    local pathMark = GetGridPath(room, index)
                    partialHits = gridPathThreshold < pathMark and partialHits + 1 or partialHits
                end

                return true
            end

            if not ignoreCrushable or index < 0 then
                return false
            end

            local gridEntity = gridEntityList[index + 1]
            if not gridEntity or not GridEntityUtils.IsEasyCrushableOrWalkable(roomContext, gridEntity) or not GridEntityUtils.IsDangerousCrushableOrWalkable(roomContext, gridEntity) then
                return false
            end

            return true
        end,
        [LineCheckMode.RAYCAST] = function(index)
            local collisionClass = GetGridCollision(room, index)
            if collisionClass ~= GridCollisionClass.COLLISION_NONE then
                return false
            end

            if index ~= startGridIdx then
                local pathMark = GetGridPath(room, index)
                partialHits = gridPathThreshold < pathMark and partialHits + 1 or partialHits
            end

            return true
        end,
        [LineCheckMode.EXPLOSION] = function(index)
            local collisionClass = GetGridCollision(room, index)
            local gridEntity = GetGridEntity(room, index)

            if not gridEntity then
                return collisionClass ~= GridCollisionClass.COLLISION_WALL
            end

            if collisionClass == GridCollisionClass.COLLISION_NONE then
                return true
            end

            local gridType = gridEntity.m_desc.m_type
            if gridType == GridEntityType.GRID_ROCKB then
                return false
            end

            if gridType == GridEntityType.GRID_LOCK and PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_BROKEN_PADLOCK) then
                return true
            end

            if collisionClass == GridCollisionClass.COLLISION_WALL and (gridType ~= GridEntityType.GRID_DOOR and (gridType ~= GridEntityType.GRID_WALL or !ignoreWalls)) then
                return false
            end

            if (GridEntityUtils.IsEasyCrushableOrWalkable(roomContext, gridEntity) or GridEntityUtils.IsDangerousCrushableOrWalkable(roomContext, gridEntity)) and ignoreCrushable then
                return false
            end

            return true
        end,
        [LineCheckMode.PROJECTILE] = function(index)
            local collisionClass = GetGridCollision(room, index)

            if collisionClass == GridCollisionClass.COLLISION_NONE or collisionClass == GridCollisionClass.COLLISION_PIT then
                return true
            end

            if not ignoreCrushable or index < 0 then
                return false
            end

            local gridEntity = gridEntityList[index + 1]
            if not gridEntity or not GridEntityUtils.IsEasyCrushableOrWalkable(roomContext, gridEntity) or not GridEntityUtils.IsDangerousCrushableOrWalkable(roomContext, gridEntity) then
                return false
            end

            return true
        end,
    }

    -- endregion

    -- ray march by a step of 10.0
    local currentPosition = pos1
    local currentDistance = 0.0
    local check_entity_line = switch_check_grid_index[mode] or function() return true end
    local hitPosition = currentPosition

    local THICK_LINE_CORNER_OFFSETS = {
        Vector(-1/2, -1/2), Vector(-1/2, 1/2),
        Vector(1/2, 1/2), Vector(1/2, -1/2),
    }

    local lineHasWidth = false
    local lineWidth = 0.0

    if mode == LineCheckMode.ENTITY or mode == LineCheckMode.PROJECTILE then
        lineHasWidth = true
        lineWidth = 10.0
    end

    repeat
        hitPosition = currentPosition
        currentPosition = currentPosition + stepVector
        partialHits = 0

        if lineHasWidth then
            -- create a ray with a width of 10.0
            for i = 1, #THICK_LINE_CORNER_OFFSETS, 1 do
                local testOffset = THICK_LINE_CORNER_OFFSETS[i] * lineWidth
                local testPosition = currentPosition + testOffset
                local testIdx = GetGridIdx(room, testPosition)

                if not check_entity_line(testIdx) then
                    return false, hitPosition
                end
            end
        else
            local testIdx = GetGridIdx(room, currentPosition)
            if not check_entity_line(testIdx) then
                return false, hitPosition
            end
        end
        currentDistance = currentDistance + 10.0
    until currentDistance >= distance

    if partialHits > 8 then
        return false, hitPosition
    end

    return true, VectorUtils.Copy(pos2)
end

local Module = {}

--#region Module

Module.CheckLine = CheckLine

--#endregion

return Module