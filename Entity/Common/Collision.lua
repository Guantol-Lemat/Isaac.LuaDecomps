--#region Dependencies

local Enums = require("General.Enums")
local RoomUtils = require("Room.Utils")
local VectorUtils = require("Math.VectorUtils")

local eGridCollisionClass = Enums.eGridCollisionClass

--#endregion

---@class EntityCollision
local Module = {}

---@param context Context
---@param entity EntityComponent
---@param interpolate boolean
---@param gridCollisionClass GridCollisionClass | integer
---@return GridCollisionClass | integer
local function hook_pre_collide_with_grid(context, entity, interpolate, gridCollisionClass)
    if entity.m_type == EntityType.ENTITY_PROJECTILE and gridCollisionClass == GridCollisionClass.COLLISION_WALL and context:GetRoom().m_type == RoomType.ROOM_DUNGEON then
        gridCollisionClass = eGridCollisionClass.NO_PITS
    end

    return gridCollisionClass
end

---@param context Context
---@param entity EntityComponent
---@param interpolate boolean
local function CollideWithGrid(context, entity, interpolate)
    if not interpolate then
        entity.m_collidesWithGrid = false
    end

    if entity.m_minecart then
        return
    end

    local gridCollisionClass = entity.m_gridCollisionClass
    if gridCollisionClass == GridCollisionClass.COLLISION_NONE then
        return
    end
    gridCollisionClass = hook_pre_collide_with_grid(context, entity, interpolate, gridCollisionClass)

    local clampedRoomPosition = RoomUtils.GetClampedPosition(context:GetRoom(), entity.m_position, 0.0)

    if gridCollisionClass == eGridCollisionClass.WALLS_X then
        if interpolate then
            entity.m_position.X = clampedRoomPosition.X
            return
        end

        if entity.m_position.X == clampedRoomPosition.X then
            entity.m_collidesWithGrid = false
            entity.m_position.X = clampedRoomPosition.X
            return
        end

        entity.m_collidesWithGrid = true
        entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
        local bounceDirection = entity.m_position.X > clampedRoomPosition.X and -1.0 or 1.0
        entity.m_wallBounceDirection = Vector(bounceDirection, 0.0)
        entity.m_position.X = clampedRoomPosition.X
        return
    end

    if gridCollisionClass == eGridCollisionClass.WALLS_Y then
        if interpolate then
            entity.m_position.Y = clampedRoomPosition.Y
            return
        end

        if entity.m_position.Y == clampedRoomPosition.Y then
            entity.m_collidesWithGrid = false
            entity.m_position.Y = clampedRoomPosition.Y
            return
        end

        entity.m_collidesWithGrid = true
        entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
        local bounceDirection = entity.m_position.Y > clampedRoomPosition.Y and -1.0 or 1.0
        entity.m_wallBounceDirection = Vector(0, bounceDirection)
        entity.m_position.Y = clampedRoomPosition.Y
        return
    end

    -- todo
end

--#region Module

Module.CollideWithGrid = CollideWithGrid

--#endregion

return Module