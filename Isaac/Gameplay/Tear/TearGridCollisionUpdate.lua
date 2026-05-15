--#region Dependencies

local Enums = require("General.Enums")
local VectorUtils = require("General.Math.VectorUtils")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")

local TearEffects = require("Isaac.Gameplay.Tear.TearEffects.TearEffectsGridCollision")

--#endregion

local eTearDeathFlags = Enums.eTearDeathFlags

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function tear_collides_with_grid(ctx, tear)
    if tear.m_variant == TearVariant.CHAOS_CARD then
        return false
    end

    if not tear.m_collidesWithGrid then
        return false
    end

    -- tear only collides with walls
    if tear.m_height <= -60.0 or tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 then
        local ctx_room = ctx.game.m_level.m_room
        local position = tear.m_position
        local posGridCollision = IRoom.GetGridCollisionAtPos(ctx_room, position)

        if posGridCollision == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER and IRoom.GetGridPathFromPos(ctx_room, position) < 2999 then
            return false
        end

        if posGridCollision ~= GridCollisionClass.COLLISION_WALL then
            return false
        end
    end

    local tearFlags = tear.m_tearFlags
    if tearFlags & TearFlags.TEAR_SPECTRAL ~= 0 then
        return false
    end

    if tearFlags & (TearFlags.TEAR_STICKY | TearFlags.TEAR_BOOGER | TearFlags.TEAR_SPORE) ~= 0 then
        if tear.m_stick_target.ref then
            return false
        end
    end

    return true
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function collide_with_floor(ctx, tear)
    -- stop card and setup sprite
    if tear.m_variant == TearVariant.CHAOS_CARD and not tear.m_isDead then
        tear.m_velocity = Vector(0, 0)
        tear.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        tear.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        local sprite = tear.m_sprite
        sprite.Rotation = 180.0
        sprite:Play("Stuck", false)
    end

    if tear.m_tearFlags & TearFlags.TEAR_HYDROBOUNCE ~= 0 then
        tear.m_fallingSpeed = tear.m_fallingSpeed * -1.6
        IEntityTear.SetHeight(ctx, tear, -5.0)
    end

    tear.m_isDead = true
    tear.m_deathFlags = tear.m_deathFlags | eTearDeathFlags.FLAG_2
    IEntityTear.trigger_collision(ctx, tear, nil)

    -- trigger streak end
    local parent = tear.m_parent.ref
    local parent_player = parent and IEntity.ToPlayer(parent)
    if parent_player and tear.m_deadEye_canEndStreak then
        if IEntityPlayer.HasCollectible(ctx, parent_player, CollectibleType.COLLECTIBLE_DEAD_EYE, false) then
            IEntityPlayer.ClearDeadEyeCharge(ctx, parent_player)
        end
        IEntityPlayer.TriggerNonEnemyTearHit(ctx, parent_player)
    end
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function try_collide_with_grid(ctx, tear)
    local ctx_room = ctx.game.m_level.m_room

    local bounces = tear.m_tearFlags & (TearFlags.TEAR_BOUNCE | TearFlags.TEAR_BOUNCE_WALLSONLY) ~= 0
        or tear.m_variant == TearVariant.FIRE
    bounces = bounces and not IRoom.IsBeastRoom(ctx_room)
    bounces = bounces or (tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 and tear.m_subtype & (1 << 1) ~= 0)

    if bounces then
        TearEffects.BounceTear(ctx, tear)
        return
    end

    if tear.m_tearFlags & TearFlags.TEAR_REROLL_ROCK_WISP ~= 0 then
        TearEffects.RerollRockWisp(ctx, tear)
        return
    end

    if not tear_collides_with_grid(ctx, tear) then
        return
    end

    tear.m_isDead = true
    local addedDeathFlags = eTearDeathFlags.FLAG_0

    -- collides with wall
    local gridCollisionPos = IRoom.GetGridCollisionAtPos(ctx_room, tear.m_position)
    if gridCollisionPos == GridCollisionClass.COLLISION_WALL or gridCollisionPos == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
        addedDeathFlags = addedDeathFlags | eTearDeathFlags.FLAG_1
    end

    tear.m_deathFlags = tear.m_deathFlags | addedDeathFlags
    IEntityTear.trigger_collision(ctx, tear, nil)
    IEntityTear.damage_grid(ctx, tear, tear.m_position)

    -- trigger streak end
    local parent = tear.m_parent.ref
    local parent_player = parent and IEntity.ToPlayer(parent)

    local canEndStreak = parent_player and tear.m_deadEye_canEndStreak
    if canEndStreak then
        local gridEntity = IRoom.GetGridEntityFromPos(ctx_room, tear.m_position)
        -- check if grid entity itself can end the streak
        canEndStreak = gridEntity == nil
            or (gridEntity.m_desc.m_type ~= GridEntityType.GRID_POOP and gridEntity.m_desc.m_type ~= GridEntityType.GRID_TNT)
    end

    if canEndStreak then
        ---@cast parent_player Component.Entity.Player
        IEntityPlayer.TriggerNonEnemyTearHit(ctx, parent_player)

        if IEntityPlayer.HasCollectible(ctx, parent_player, CollectibleType.COLLECTIBLE_DEAD_EYE, false) then
            IEntityPlayer.ClearDeadEyeCharge(ctx, parent_player)
        end
    end
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local hitFloor = tear.m_height > -5.0 or
        (tear.m_tearFlags & TearFlags.TEAR_HYDROBOUNCE ~= 0 and tear.m_height + tear.m_fallingSpeed > -5.0)

    if hitFloor and tear.m_tearFlags & TearFlags.TEAR_LUDOVICO == 0 then
        collide_with_floor(ctx, tear)
    else
        try_collide_with_grid(ctx, tear)
    end

    if tear.m_variant == TearVariant.CHAOS_CARD and not tear.m_isDead then
        local ctx_room = ctx.game.m_level.m_room
        local position = tear.m_position
        local clampedPosition = IRoom.GetClampedPosition(ctx_room, position, -20.0, -1.0, -20.0, -40.0)
        -- hit room limit
        if not VectorUtils.Equals(clampedPosition, position) then
            local topLeft = ctx_room.m_topLeftBound
            local bottomRight = ctx_room.m_bottomRightBound

            local sprite = tear.m_sprite
            sprite:Play("Stuck", false)

            if position.X < topLeft.X then
                sprite.Rotation = 90.0
                sprite.FlipX = true
            elseif position.X > bottomRight.X then
                sprite.Rotation = 90.0
            elseif position.Y < topLeft.Y then
                sprite.FlipX = tear.m_velocity.X < 0.0
            elseif position.Y > bottomRight.Y then
                sprite.FlipX = tear.m_velocity.X > 0.0
                sprite.FlipY = true
            end

            tear.m_velocity = Vector(0, 0)
            tear.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            tear.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            tear.m_isDead = true
            tear.m_deathFlags = tear.m_deathFlags | (eTearDeathFlags.FLAG_0 | eTearDeathFlags.FLAG_1)
        end

        local gridIndex = IRoom.GetGridIndex(ctx_room, position)
        IRoom.DestroyGrid(ctx_room, gridIndex, 0, false)
    end
end

---@class Gameplay.TearGridCollisionUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module