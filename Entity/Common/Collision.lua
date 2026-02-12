--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local EntityIdentity = require("Entity.Identity")
local PlayerRules = require("Entity.Player.Rules")
local RoomUtils = require("Room.Utils")
local RoomRules = require("Room.Rules")
local GridUtils = require("GridEntity.Common.Utils")
local VectorUtils = require("Math.VectorUtils")
local IsaacSoundRules = require("Admin.Sound.Rules")
local TemporaryEffectsUtils = require("Game.TemporaryEffects.TemporaryEffects")

local eSingeVariant = EntityIdentity.eSingeVariant
local VectorZero = VectorUtils.VectorZero

--#endregion

---@class EntityCollisionLogic
local Module = {}

local s_forcedCollision = 0

local function StartForcedCollision()
    s_forcedCollision = s_forcedCollision + 1
end

local function EndForcedCollision()
    s_forcedCollision = s_forcedCollision - 1
end

---@return boolean
local function IsForcedCollision()
    return s_forcedCollision ~= 0
end

---@param context Context
---@param entity EntityComponent
---@param interpolate boolean
---@param gridCollisionClass GridCollisionClass | integer
---@return EntityGridCollisionClass | integer
local function hook_pre_collide_with_grid(context, entity, interpolate, gridCollisionClass)
    if entity.m_type == EntityType.ENTITY_PROJECTILE and gridCollisionClass == GridCollisionClass.COLLISION_WALL and context:GetRoom().m_type == RoomType.ROOM_DUNGEON then
        gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
    end

    return gridCollisionClass
end

---@param context Context
---@param player EntityPlayerComponent
---@param gridEntity GridEntityComponent
---@param collisionClass GridCollisionClass
local function hook_on_player_grid_collision(context, player, gridEntity, collisionClass)
    if not gridEntity then
        return
    end

    local temporaryEffects = player.m_temporaryEffects
    local megaMush = TemporaryEffectsUtils.HasCollectibleEffect(temporaryEffects, CollectibleType.COLLECTIBLE_MEGA_MUSH)

    if megaMush then
        -- mega mush
    elseif PlayerRules.CanCrushGridEntity(context, player, gridEntity, collisionClass) then
        -- crush entity
    elseif collisionClass == GridCollisionClass.COLLISION_WALL and gridEntity.m_desc.m_type == GridEntityType.GRID_DOOR and player.m_itemState == CollectibleType.COLLECTIBLE_NOTCHED_AXE then
        -- try destroy door
    end
end

---@param room RoomComponent
---@param entity EntityComponent
---@param clampedRoomPosition Vector
---@param collidingAxis "X" | "Y"
---@param interpolate boolean
local function single_wall_axis_class(room, entity, clampedRoomPosition, collidingAxis, interpolate)
    local ignoredAxis = collidingAxis == "X" and "Y" or "X"

    if interpolate then
        entity.m_position[collidingAxis] = clampedRoomPosition[collidingAxis]
        return
    end

    if entity.m_position[collidingAxis] == clampedRoomPosition[collidingAxis] then
        entity.m_collidesWithGrid = false
        entity.m_position[collidingAxis] = clampedRoomPosition[collidingAxis]
        return
    end

    entity.m_collidesWithGrid = true
    entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
    local bounceDirection = entity.m_position[collidingAxis] > clampedRoomPosition[collidingAxis] and -1.0 or 1.0
    entity.m_gridCollisionDirection[collidingAxis] = bounceDirection
    entity.m_gridCollisionDirection[ignoredAxis] = 0.0
    entity.m_position[collidingAxis] = clampedRoomPosition[collidingAxis]
end

---@param room RoomComponent
---@param entity EntityComponent
---@param clampedRoomPosition Vector
---@param interpolate boolean
local function bullet_grid_collision_class(room, entity, clampedRoomPosition, interpolate)
    if interpolate then
        return
    end

    local position = entity.m_position
    local noWalls = room.m_bossId == BossType.MEGA_SATAN or (room.m_roomDescriptor.m_flags & RoomDescriptor.FLAG_NO_WALLS) ~= 0
    local colliderClass = RoomUtils.GetGridCollisionAtPos(room, position)

    local wallGrid = GridCollisionClass.COLLISION_WALL or colliderClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
    if wallGrid and not VectorUtils.Equals(position, clampedRoomPosition) then
        if noWalls then
            return
        end

        local deltaFromWall = clampedRoomPosition - position
        if deltaFromWall:Dot(entity.m_velocity) >= 0 then -- return if we are not moving away from the room bounds
            return
        end
    end

    if colliderClass ~= GridCollisionClass.COLLISION_SOLID and not wallGrid then
        if not (entity.m_type == EntityType.ENTITY_TEAR and colliderClass == GridCollisionClass.COLLISION_OBJECT) then
            return
        end
    end

    local gridEntity = RoomUtils.GetGridEntityFromPos(room, position)
    if not gridEntity or gridEntity.m_desc.m_type == GridEntityType.GRID_PIT then
        return
    end

    entity.m_collidesWithGrid = true
    entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
end

---@param context Context
---@param room RoomComponent
---@param entity EntityComponent
---@param gridCollisionClass EntityGridCollisionClass
---@param interpolate boolean
---@return Vector collisionDirection
local function evaluate_grid_collision(context, room, entity, gridCollisionClass, interpolate)
    local collisionDirection = Vector(0, 0)
    local gridCollisionPoints = entity.m_gridCollisionPoints
    local position = entity.m_position

    if gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        for i = 1, #gridCollisionPoints, 1 do
            local sample = gridCollisionPoints[i]
            local samplePosition = position + sample
            local colliderClass = RoomUtils.GetGridCollisionAtPos(room, samplePosition)
            if colliderClass ~= GridCollisionClass.COLLISION_NONE then
                collisionDirection = collisionDirection + sample
            end
        end
    elseif gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_PITSONLY then
        for i = 1, #gridCollisionPoints, 1 do
            local sample = gridCollisionPoints[i]
            local samplePosition = position + sample
            local colliderClass = RoomUtils.GetGridCollisionAtPos(room, samplePosition)
            if colliderClass ~= GridCollisionClass.COLLISION_PIT then
                collisionDirection = collisionDirection + sample
            end
        end
    elseif gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_NOPITS then
        for i = 1, #gridCollisionPoints, 1 do
            local sample = gridCollisionPoints[i]
            local samplePosition = position + sample
            local gridIdx = RoomUtils.GetGridIdx(room, samplePosition)
            local colliderClass = RoomUtils.GetGridCollision(room, gridIdx)
            local gridEntity = RoomUtils.GetGridEntity(room, gridIdx)

            if (colliderClass ~= GridCollisionClass.COLLISION_NONE and colliderClass ~= GridCollisionClass.COLLISION_PIT)
               and (gridEntity and gridEntity.m_desc.m_type ~= GridEntityType.GRID_PIT)  then
                collisionDirection = collisionDirection + sample
            end

            if not interpolate and entity.m_type == EntityType.ENTITY_FAMILIAR and entity.m_variant == FamiliarVariant.SAMSONS_CHAINS
               and (colliderClass == GridCollisionClass.COLLISION_SOLID or colliderClass == GridCollisionClass.COLLISION_OBJECT) and gridEntity ~= nil then
                if gridEntity.m_collisionClass == GridCollisionClass.COLLISION_SOLID and entity.m_velocity:LengthSquared() > 25.0 and gridEntity:Destroy(context, false) then
                    local gridPosition = GridUtils.GetPosition(room, gridEntity)
                    local collisionSide = VectorUtils.AxisAlignedUnitVector(gridPosition - position)
                    local bridgeGridEntity = RoomUtils.GetGridEntityFromPos(room, collisionSide * 40.0 + gridPosition)
                    RoomRules.TryMakeBridge(context, room, bridgeGridEntity, nil)
                else
                    collisionDirection.X = 0.0
                    collisionDirection.Y = 0.0
                end
            end
        end
    else -- this should be EntityGridCollisionClass.GRIDCOLL_WALLS, but it ends up being executed whatever the value may be
        for i = 1, #gridCollisionPoints, 1 do
            local sample = gridCollisionPoints[i]
            local samplePosition = position + sample
            local colliderClass = RoomUtils.GetGridCollisionAtPos(room, samplePosition)
            if not RoomUtils.IsDungeon(room)
               and (colliderClass == GridCollisionClass.COLLISION_WALL or colliderClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) then
                collisionDirection = collisionDirection + sample
            end
        end
    end

    return collisionDirection
end

---@param room RoomComponent
---@param entity EntityComponent
---@param pushBack Vector
---@return Vector? pushBack
local function tear_grid_push_back_adjust(room, entity, pushBack)
    local position = entity.m_position
    local gridIdx = RoomUtils.GetGridIdx(room, entity.m_position)
    local gridPosition = RoomUtils.GetGridPosition(room, gridIdx)
    local deltaFromGridPosition = position - gridPosition

    local sizeMulti = entity.m_sizeMulti
    local size = sizeMulti * entity.m_size
    if deltaFromGridPosition.X + math.abs(size.X) >= 20.0 and deltaFromGridPosition.Y + math.abs(size.Y) >= 20.0 then
        return
    end

    pushBack = Vector(0, 0)
    local dominantAxis = "X"
    if math.abs(sizeMulti.Y * deltaFromGridPosition.Y) > math.abs(sizeMulti.X * deltaFromGridPosition.X) then
        dominantAxis = "Y"
    end

    pushBack[dominantAxis] = deltaFromGridPosition[dominantAxis] > 0.0 and -size[dominantAxis] or size[dominantAxis]
    return pushBack
end

---@param room RoomComponent
---@param entity EntityComponent
local function npc_grid_manual_push_back(room, entity)
    local shift = entity.m_sizeMulti * entity.m_size - 20.0
    local position = entity.m_position
    local freePosition = RoomUtils.FindFreeTilePosition(room, position, 40.0)

    if freePosition.X - position.X > 0.0 then
        shift.X = -shift.X
    end

    if freePosition.Y - position.Y > 0.0 then
        shift.Y = -shift.Y
    end

    entity.m_position = freePosition + shift
end

---@param context Context
---@param room RoomComponent
---@param entity EntityComponent
---@param pushBackStrength number -- this is always a negative value, as such in order to increase the strength you must use subtractions
---@param basePushBack number -- this is always a negative value
---@return number? pushBackStrength
local function hook_on_grid_collision(context, room, entity, pushBackStrength, basePushBack)
    local entityType = entity.m_type

    if entityType == EntityType.ENTITY_GURDY_JR then
        local volume = math.min(-basePushBack * 0.05, 1.2)
        IsaacSoundRules.Play(context, context:GetSFXManager(), SoundEffect.SOUND_DEATH_BURST_LARGE, volume, 2, false, 1.0)
        pushBackStrength = pushBackStrength * 1.4
        return pushBackStrength
    end

    if entityType == EntityType.ENTITY_DIP or entityType == EntityType.ENTITY_SQUIRT then
        return pushBackStrength * 1.2
    end

    if entityType == EntityType.ENTITY_SINGE and entity.m_variant == eSingeVariant.SINGE_BALL then
        local pitch = context:RandomFloat() * 0.2 + 0.9
        local volume = math.min(entity.m_velocity:Length(), 1.2)
        IsaacSoundRules.Play(context, context:GetSFXManager(), SoundEffect.SOUND_STONE_IMPACT, volume, 2, false, pitch)
        return pushBackStrength * 1.2
    end

    if entityType == EntityType.ENTITY_BALL_AND_CHAIN then
        local pitch = context:RandomFloat() * 0.2 + 0.9
        local volume = math.min(entity.m_velocity:Length(), 1.2)
        IsaacSoundRules.Play(context, context:GetSFXManager(), SoundEffect.SOUND_BALL_AND_CHAIN_HIT, volume, 2, false, pitch)
        return pushBackStrength * 1.2
    end
end

---@param room RoomComponent
---@param entity EntityComponent
---@param collisionClass EntityGridCollisionClass | integer
---@param collisionDirection Vector
---@param velocityStrength number
local function grid_collision_adjust_position(room, entity, collisionClass, collisionDirection, velocityStrength)
    local adjustedDirection = collisionDirection * entity.m_sizeMulti
    local length = adjustedDirection:Length()
    local upperBound = length * entity.m_size

    velocityStrength = math.max(velocityStrength, 2.0)
    local lowerBound = upperBound - velocityStrength

    if collisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        local sampleCount = 12
        for i = 1, sampleCount, 1 do
            local samplePosition = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * samplePosition + entity.m_position
            local gridCollisionClass = RoomUtils.GetGridCollisionAtPos(room, gridPosition)
            if gridCollisionClass ~= GridCollisionClass.COLLISION_NONE then
                upperBound = samplePosition
            else
                lowerBound = samplePosition
            end
        end
    elseif collisionClass == EntityGridCollisionClass.GRIDCOLL_PITSONLY then
        local sampleCount = 6
        for i = 1, sampleCount, 1 do
            local samplePosition = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * samplePosition + entity.m_position
            local gridCollisionClass = RoomUtils.GetGridCollisionAtPos(room, gridPosition)
            if gridCollisionClass ~= GridCollisionClass.COLLISION_PIT then
                upperBound = samplePosition
            else
                lowerBound = samplePosition
            end
        end
    elseif collisionClass == EntityGridCollisionClass.GRIDCOLL_NOPITS then
        local sampleCount = 6
        for i = 1, sampleCount, 1 do
            local samplePosition = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * samplePosition + entity.m_position
            local gridCollisionClass = RoomUtils.GetGridCollisionAtPos(room, gridPosition)
            if gridCollisionClass ~= GridCollisionClass.COLLISION_NONE and gridCollisionClass ~= GridCollisionClass.COLLISION_PIT then
                upperBound = samplePosition
            else
                lowerBound = samplePosition
            end
        end
    else -- this should be EntityGridCollisionClass.GRIDCOLL_WALLS
        local sampleCount = 6
        for i = 1, sampleCount, 1 do
            local samplePosition = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * samplePosition + entity.m_position
            local gridCollisionClass = RoomUtils.GetGridCollisionAtPos(room, gridPosition)
            if gridCollisionClass == GridCollisionClass.COLLISION_WALL or gridCollisionClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
                upperBound = samplePosition
            else
                lowerBound = samplePosition
            end
        end
    end

    entity.m_position = entity.m_position + (lowerBound - upperBound) * collisionDirection
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

    local position = entity.m_position
    local room = context:GetRoom()
    local clampedRoomPosition = RoomUtils.GetClampedPosition(room, position, 0.0)

    if gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_WALLS_X then
        single_wall_axis_class(room, entity, clampedRoomPosition, "X", interpolate)
        return
    end

    if gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_WALLS_Y then
        single_wall_axis_class(room, entity, clampedRoomPosition, "Y", interpolate)
        return
    end

    if gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_BULLET then
        bullet_grid_collision_class(room, entity, clampedRoomPosition, interpolate)
        return
    end

    local wallCollisionDirection = Vector(0, 0)

    if gridCollisionClass < 8 then -- only do this on valid gridCollisionClass
        if not interpolate then
            local collided = not VectorUtils.Equals(position, clampedRoomPosition)
            entity.m_collidesWithGrid = collided
            if collided then
                entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
                if position.X ~= clampedRoomPosition.X then
                    wallCollisionDirection.X = position.X > clampedRoomPosition.X and 1.0 or -1.0
                end
                if position.Y ~= clampedRoomPosition.Y then
                    wallCollisionDirection.Y = position.Y > clampedRoomPosition.X and 1.0 or -1.0
                end
            end
        end

        position = VectorUtils.Copy(clampedRoomPosition)
        entity.m_position = position
    end

    local gridCollisionPoints = entity.m_gridCollisionPoints
    if #gridCollisionPoints == 0 then
        return
    end

    local collisionDirection = evaluate_grid_collision(context, room, entity, gridCollisionClass, interpolate)

    if VectorUtils.Equals(collisionDirection, VectorZero) then -- we didn't collide with any grid
        if not interpolate then
            entity.m_gridCollisionDirection = wallCollisionDirection
        end

        return
    end

    local entityType = entity.m_type
    if entityType == EntityType.ENTITY_TEAR then
        if collisionDirection:LengthSquared() < 0.001 then
            collisionDirection = tear_grid_push_back_adjust(room, entity, collisionDirection) or collisionDirection
        end
    elseif EntityUtils.IsEnemy(entity) then
        if collisionDirection:LengthSquared() < 0.001 then
            npc_grid_manual_push_back(room, entity)
            return
        end
    end

    collisionDirection:Normalize()
    if not interpolate then
        entity.m_gridCollisionDirection = collisionDirection
    end

    local basePushBackStrength = -collisionDirection:Dot(entity.m_velocity)
    if basePushBackStrength >= 0.0 then -- push back has same overall direction as the current velocity, hence it's not really a push back
        return
    end

    if not interpolate then
        entity.m_collidesWithGrid = true
        entity.m_velocityOnGridCollide = VectorUtils.Copy(entity.m_velocity)
        local pushBackStrength = basePushBackStrength * 1.8
        pushBackStrength = pushBackStrength - 0.1
        pushBackStrength = hook_on_grid_collision(context, room, entity, pushBackStrength, basePushBackStrength) or pushBackStrength
        entity.m_velocity =  entity.m_velocity + pushBackStrength * collisionDirection
    end

    local velocityStrength = entity.m_velocity:Length()
    if velocityStrength > 0.0 then
        grid_collision_adjust_position(room, entity, gridCollisionClass, collisionDirection, velocityStrength)
    end

    if not interpolate then
        local bounceDampingFactor = 1.0 - (-basePushBackStrength / velocityStrength) * 0.5
        entity.m_velocity = entity.m_velocity * bounceDampingFactor
    end
end

---@param context Context
---@param room RoomComponent
---@param player EntityPlayerComponent
---@param interpolate boolean
local function evaluate_player_beast_dungeon_wall_collision(context, room, player, interpolate)
    local position = player.m_position
    local samplePosition = VectorUtils.Copy(position)
    samplePosition.X = samplePosition.X - 0.0
    samplePosition.Y = samplePosition.Y - 20.0

    local clampedRoomPosition = RoomUtils.GetClampedPosition(room, position, player.m_size)
    clampedRoomPosition.X = clampedRoomPosition.X + 0.0
    clampedRoomPosition.Y = clampedRoomPosition.Y + 20.0

    if not interpolate then
        player.m_collidesWithGrid = not VectorUtils.Equals(position, clampedRoomPosition)
    end

    player.m_position.X = clampedRoomPosition.X
    player.m_position.Y = clampedRoomPosition.Y
end

---@param context Context
---@param room RoomComponent
---@param player EntityPlayerComponent
---@param interpolate boolean
local function evaluate_player_wall_collision(context, room, player, interpolate)
    local position = player.m_position
    local gridIdx = RoomUtils.GetGridIdx(room, position)
    local gridCollisionClass = RoomRules.GetSpecialGridCollision(context, room, player, position)

    if gridIdx >= 0 and RoomRules.GetSpecialGridCollision(context, room, player, position) ~= GridCollisionClass.COLLISION_WALL then
        return
    end

    local clampedRoomPosition = RoomUtils.GetClampedPosition(room, position, 0.0)
    if not interpolate then
        player.m_collidesWithGrid = not VectorUtils.Equals(position, clampedRoomPosition)
    end

    if not RoomUtils.IsDungeon(room) then
        player.m_position.X = clampedRoomPosition.X
        player.m_position.Y = clampedRoomPosition.Y
    end
end

---@param context Context
---@param room RoomComponent
---@param player EntityPlayerComponent
---@param interpolate boolean
---@return Vector collisionDirection
local function evaluate_player_grid_collision(context, room, player, interpolate)
    local collisionDirection = Vector(0, 0)
    local gridCollisionPoints = player.m_gridCollisionPoints
    local position = player.m_position
    local collisionClass = player.m_gridCollisionClass

    for i = 1, #gridCollisionPoints, 1 do
        local sampleOffset = gridCollisionPoints[i]
        local samplePosition = position + sampleOffset
        local sampleGridEntity = RoomUtils.GetGridEntityFromPos(room, samplePosition)
        local colliderClass = RoomRules.GetSpecialGridCollision(context, room, player, samplePosition)

        if not interpolate and sampleGridEntity then
            hook_on_player_grid_collision(context, player, sampleGridEntity, colliderClass)
        end

        if collisionClass == EntityGridCollisionClass.GRIDCOLL_WALLS and (colliderClass == GridCollisionClass.COLLISION_WALL or colliderClass == GridCollisionClass.COLLISION_SOLID or (sampleGridEntity and sampleGridEntity.m_desc.m_type == GridEntityType.GRID_DOOR)) then
            collisionDirection = collisionDirection + sampleOffset
        elseif collisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND and (colliderClass ~= GridCollisionClass.COLLISION_NONE and colliderClass ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) then
            collisionDirection = collisionDirection + sampleOffset
        end
    end

    return collisionDirection
end

---@param context Context
---@param room RoomComponent
---@param player EntityPlayerComponent
---@param collisionDirection Vector
local function player_grid_collision_adjust_position(context, room, player, collisionDirection)
    local upperBound = (collisionDirection * player.m_sizeMulti):Length() * player.m_size -- a distance that is going to be in the collision

    local speed = player.m_velocity:Length()
    speed = math.max(speed, 2.0)
    local lowerBound = upperBound - speed -- a distance that is going to be outside of the collision

    local collisionClass = player.m_gridCollisionClass
    if collisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        local sampleCount = 12
        for i = 1, sampleCount, 1 do
            local sampleDistance = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * sampleDistance + player.m_position
            local gridCollisionClass = RoomRules.GetSpecialGridCollision(context, room, player, gridPosition)
            if gridCollisionClass ~= GridCollisionClass.COLLISION_NONE or gridCollisionClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
                upperBound = sampleDistance
            else
                lowerBound = sampleDistance
            end
        end
    else
        local sampleCount = 6
        for i = 1, sampleCount, 1 do
            local samplePosition = (upperBound - lowerBound) * 0.5 + lowerBound
            local gridPosition = collisionDirection * samplePosition + player.m_position
            local gridCollisionClass = RoomRules.GetSpecialGridCollision(context, room, player, gridPosition)
            if gridCollisionClass == GridCollisionClass.COLLISION_WALL then
                upperBound = samplePosition
            else
                lowerBound = samplePosition
            end
        end
    end

    player.m_position = player.m_position + (lowerBound - upperBound) * collisionDirection
end

---@param context Context
---@param entity EntityComponent
---@param interpolate boolean
local function PlayerCollideWithGrid(context, entity, interpolate)
    local player = EntityUtils.ToPlayer(entity)
    if not player then
        context:LogMessage(3, "Called PlayerCollideWithGrid with Entity type != Entity_Player\n")
        return
    end

    if not interpolate then
        player.m_collidesWithGrid = false
    end

    if player.m_gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_NONE then
        return
    end

    if player.m_minecart then
        return
    end

    if #player.m_gridCollisionPoints == 0 then
        return
    end

    local room = context:GetRoom()
    local position = player.m_position
    local clampedRoomPosition = RoomUtils.GetClampedPosition(room, position, 0.0)

    if RoomUtils.IsBeastDungeon(room) then
        evaluate_player_beast_dungeon_wall_collision(context, room, player, interpolate)
    else
        evaluate_player_wall_collision(context ,room, player, interpolate)
    end

    local collisionDirection = evaluate_player_grid_collision(context, room, player, interpolate)

    if collisionDirection:LengthSquared() >= 0.001 then
        collisionDirection = collisionDirection * (1.0 / collisionDirection:Length())
        if not interpolate then
            player.m_gridCollisionDirection.X = collisionDirection.X
            player.m_gridCollisionDirection.Y = collisionDirection.Y
        end

        local pushBackStrength = -collisionDirection:Dot(player.m_velocity)
        if pushBackStrength < 0.0 and not interpolate then
            pushBackStrength = pushBackStrength * 0.9 - 0.1
            player.m_collidesWithGrid = true
            player.m_velocityOnGridCollide = VectorUtils.Copy(player.m_velocity)
            player.m_velocity = player.m_velocity + collisionDirection * pushBackStrength
        end

        player_grid_collision_adjust_position(context, room, player, collisionDirection)
    end
end

--#region Module

Module.StartForcedCollision = StartForcedCollision
Module.EndForcedCollision = EndForcedCollision
Module.IsForcedCollision = IsForcedCollision
Module.CollideWithGrid = CollideWithGrid
Module.PlayerCollideWithGrid = PlayerCollideWithGrid

--#endregion

return Module