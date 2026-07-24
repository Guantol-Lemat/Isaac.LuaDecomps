--#region Dependencies

local Enums = require("Isaac.Enums")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils.Common")
local HitListUtils = require("Isaac.Utils.HitList")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")

local eFireTearFlags = Enums.eFireTearFlags
--#endregion

local VectorZero = Vector(0, 0)

---@class Closure.Gameplay.TearLudovicoUpdate
---@field isMain boolean
---@field player Component.Entity.Player?
---@field subtypeFlag boolean

---@param variant TearVariant | integer
local function should_reload_config(variant)
    return variant ~= TearVariant.TOOTH and
        variant ~= TearVariant.STONE and
        variant ~= TearVariant.BOOGER and
        variant ~= TearVariant.EGG and
        variant ~= TearVariant.RAZOR and
        variant ~= TearVariant.BONE and
        variant ~= TearVariant.BLACK_TOOTH and
        variant ~= TearVariant.SPORE
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param closure Closure.Gameplay.TearLudovicoUpdate
---@param frameDelta integer
local function update_ludovico_effects(ctx, tear, closure, frameDelta)
    HitListUtils.Clear(tear.m_hitList)
    IEntityTear.damage_grid(ctx, tear, tear.m_position)

    local isMainTear = closure.isMain
    local player = closure.player
    local subtypeFlag = closure.subtypeFlag
    local speed = tear.m_velocity:Length()

    if not player then
        return
    end

    -- update tear params
    local spawner = tear.m_spawnerEntity.ref
    local tearParams = IEntityPlayer.GetTearHitParams(
        ctx, player, WeaponType.WEAPON_LUDOVICO_TECHNIQUE,
        1.0, IsaacUtils.RandomInt(2) * 2 - 1, spawner
    )

    tear.m_stick_timer = 0

    if tear.m_variant ~= tearParams.tearVariant then
        -- reload config for variant
        tear.m_variant = tearParams.tearVariant
        if should_reload_config(tearParams.tearVariant) then
            IEntity.load_entity_config(ctx, tear)
            tear.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            local config = tear.m_config
            if config then
                local sprite = tear.m_sprite
                sprite:Load(config.anm2Path, true)
                sprite:Play(sprite:GetDefaultAnimationName(), false)
                sprite.Rotation = 0.0
                IEntityTear.reset_sprite_scale(ctx, tear)
            end
        end
    end

    if subtypeFlag then
        if speed > 10.0 then
            local damage_multiplier = MathUtils.MapToRange(speed, {10.0, 20.0}, {1.0, 6.0}, true)
            local damage_flatIncrease = MathUtils.MapToRange(speed, {10.0, 15.0}, {0.0, 6.0}, true)
            tearParams.tearDamage = tearParams.tearDamage * damage_multiplier + damage_flatIncrease
        end

        tearParams.tearFlags = tearParams.tearFlags | TearFlags.TEAR_SPECTRAL
    end

    tear.m_collisionDamage = tearParams.tearDamage
    tear:SetColor(ctx, tearParams.tearColor, -1, -1, false, true)

    local tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_BOUNCE)
    tearFlags = tearFlags | TearFlags.TEAR_LUDOVICO
    tear.m_tearFlags = tearFlags

    if isMainTear then
        local parent = tear.m_parent.ref
        assert(parent) -- we should only enter here if the there is a player owner

        -- update grow and shrink damage multipliers
        if tearFlags & TearFlags.TEAR_GROW ~= 0 then
            local distance = parent.m_position:Distance(tear.m_position)
            distance = MathUtils.Clamp(distance, 1.0, 700.0)
            local damageMultiplier = distance / 700.0 + 1.0
            tear.m_collisionDamage = tear.m_collisionDamage * damageMultiplier
        end

        if tearFlags & TearFlags.TEAR_SHRINK ~= 0 then
            local distance = parent.m_position:Distance(tear.m_position)
            distance = MathUtils.Clamp(distance, 0.0, 700.0)
            local damageMultiplier = 1.0 - distance / 900.0
            tear.m_collisionDamage = tear.m_collisionDamage * damageMultiplier
        end
    end

    if tearFlags & TearFlags.TEAR_OCCULT ~= 0 and player.m_fireDirection ~= Direction.NO_DIRECTION then
        for i = 1, frameDelta, 1 do
            local fire_speed = player.m_shotSpeed * 10.0
            local fire_direction = IsaacUtils.RandomVector()
            local fire_velocity = fire_direction * fire_speed
            local fire_flags = eFireTearFlags.CANNOT_BE_EYE | eFireTearFlags.NO_TRACTOR_BEAM | eFireTearFlags.CANNOT_TRIGGER_STREAK_END

            IEntityPlayer.FireTear(
                ctx, player,
                tear.m_position, fire_velocity,
                fire_flags, tear, 1.0
            )
        end
    end
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param closure Closure.Gameplay.TearLudovicoUpdate
local function update_main_tear(ctx, tear, closure)
    ---all children are assumed to be Tears
    ---@type Component.Entity.Tear[]
    local children = {}
    local currentChild = tear.m_child.ref
    while currentChild do
        table.insert(children)
        currentChild = currentChild.m_child.ref
    end

    -- sync and update children
    for i = 1, #children, 1 do
        local child = children[i]
        child.m_velocity = VectorUtils.Copy(tear.m_velocity)

        -- update orbit position
        local orbit_baseAngle = (i - 1) / #children * 360.0
        local orbit_frameCount = IEntity.GetFrameCount(ctx, tear)
        local orbit_angle = orbit_frameCount * 5.0 + orbit_baseAngle

        local orbit_distance = tear.m_size * 2
        -- lerp from 0 to tear.m_size * 2 over 50 frames
        local child_frameCount = IEntity.GetFrameCount(ctx, child)
        if child_frameCount < 50 then
            orbit_distance = child_frameCount / 50.0 * orbit_distance
        end

        local orbit_direction = Vector.FromAngle(orbit_angle)
        local orbit_offset = orbit_direction * orbit_distance
        local child_targetPosition = tear.m_position + orbit_offset
        local child_addVelocity = child_targetPosition - child.m_position
        IEntity.AddVelocity(child, child_addVelocity, false)

        -- update and sync other fields
        IEntityTear.SetScale(ctx, child, tear.m_fScale * 0.5)
        local color = tear.m_sprite.Color
        child:SetColor(ctx, color, -1, -1, false, true)
        child.m_tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_EXPLOSIVE)
        child.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        child:SetCollisionDamage(ctx, tear.m_collisionDamage)
        child.m_rotation = MathUtils.NormalizeAngle(orbit_angle + 90.0)
    end

    local parent = tear.m_parent.ref
    if not parent then
        return
    end

    if parent.m_type == EntityType.ENTITY_FAMILIAR then
        -- create repulsion when adjacent to ludovico tears
        local ctx_room = ctx.game.m_level.m_room
        local ctx_entityList = ctx_room.m_entityList

        local adjacentTears = IEntityList.QueryRadius(ctx, ctx_entityList, tear.m_position, 24.0, EntityPartition.TEAR)
        for i = 1, #adjacentTears, 1 do
            local adjacentTear = IEntity.ToTear(adjacentTears[i])
            if not adjacentTear or adjacentTear == tear then
                goto continue
            end

            local isMainLudovicoTear = adjacentTear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 and IEntityTear.IsMainTear(adjacentTear)
            if not isMainLudovicoTear then
                goto continue
            end

            local adjacent_fromDisplacement = tear.m_position - adjacentTear.m_position
            local adjacent_distance = adjacent_fromDisplacement:Length()
            local adjacent_repulsionMagnitude = 0.0
            if adjacent_distance < 24.0 then -- in repulsion radius
                adjacent_repulsionMagnitude = 4.0 / (adjacent_distance + 1.0)
            end

            -- if they match exactly
            if VectorUtils.Equals(adjacent_fromDisplacement, VectorZero) then
                adjacent_fromDisplacement = IsaacUtils.RandomVector()
            end

            if adjacent_repulsionMagnitude > 0.0 then
                local adjacent_fromDirection = adjacent_fromDisplacement:Normalized()
                local repulsion = adjacent_fromDirection * adjacent_repulsionMagnitude
                IEntity.AddVelocity(tear, repulsion, false)
            end
            ::continue::
        end
    end

    if closure.subtypeFlag then
        if parent.m_position:DistanceSquared(tear.m_position) <= 1600.0 then
            -- slow down movement
            tear.m_friction = tear.m_friction * 0.9
        else
            -- slightly push towards the parent
            local toParentDisplacement = parent.m_position - tear.m_position
            local toParentDirection = toParentDisplacement:Normalized()
            local push = toParentDirection * 0.1
            IEntity.AddVelocity(tear, push, false)
        end

        return
    end

    if parent.m_type == EntityType.ENTITY_PLAYER then
        local parent_entityPlayer = IEntity.ToPlayer(parent)
        assert(parent_entityPlayer)

        -- remove children if player doesn't have ludovico technique
        if not IEntityPlayer.HasWeaponType(parent_entityPlayer, WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
            local child = tear.m_child.ref
            while child do
                child:Remove(ctx)
                child = child.m_child.ref
            end
        end
    end
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param closure Closure.Gameplay.TearLudovicoUpdate
local function update_child_tear(ctx, tear, closure)
    local parent = tear.m_parent.ref
    local isMainTear = closure.isMain

    if parent and parent.m_type == EntityType.ENTITY_TEAR and tear.m_variant ~= parent.m_variant then
        -- sync child variant
        tear.m_variant = parent.m_variant
        if should_reload_config(tear.m_variant) then
            IEntity.load_entity_config(ctx, tear)
            local config = tear.m_config
            if config then
                local sprite = tear.m_sprite
                sprite:Load(config.anm2Path, true)
                sprite:Play(sprite:GetDefaultAnimationName(), false)
                IEntityTear.reset_sprite_scale(ctx, tear)
            end
        end
    end

    ---@type TearVariant | integer
    local variant = tear.m_variant
    local spriteRotates = variant == TearVariant.FIRE_MIND or
        variant == TearVariant.DARK_MATTER or
        variant == TearVariant.MYSTERIOUS or
        variant == TearVariant.COIN or
        variant == TearVariant.EYE or
        variant == TearVariant.EYE_BLOOD

    spriteRotates = spriteRotates or
        tear.m_tearFlags & TearFlags.TEAR_FLAT ~= 0

    if spriteRotates then
        tear.m_sprite.Rotation = tear.m_rotation
    end

    if not parent then
        tear:Remove(ctx)
        return
    end

    if tear.m_subtype & (1 << 0) ~= 0 then
        local myParentOffset = tear.m_parentOffset
        local myIndex = tear.m_index

        local distanceMultiplier_variableComponent = IEntity.GetFrameCount(ctx, tear) + myIndex * 32
        local distanceMultiplier = distanceMultiplier_variableComponent * 0.08 * 0.5 + 1.0

        local baseDistance = myParentOffset:Length()
        local realDistance = baseDistance * distanceMultiplier
        local realOffset = myParentOffset:Resized(realDistance)

        tear.m_position = realOffset + parent.m_position
        local myConstantRotation = MathUtils.MapToRange(myIndex % 10, {0.0, 10.0}, {-4.0, -3.0}, true)
        tear.m_parentOffset = myParentOffset:Rotated(myConstantRotation)
    end
end

---@param ctx Context.Gameplay.TearUpdate
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local subtypeFlag = tear.m_subtype & (1 << 1) ~= 0
    local isMainTear = IEntityTear.IsMainTear(tear)

    local frictionReductionFactor = subtypeFlag and 0.98 or 0.7
    tear.m_friction = tear.m_friction * frictionReductionFactor
    local player = IEntityTear.GetPlayer(tear)
    local player_maxFireDelay = player and player.m_maxFireDelay or 10.0

    ---@type Closure.Gameplay.TearLudovicoUpdate
    local closure = {
        subtypeFlag = subtypeFlag,
        isMain = isMainTear,
        player = player,
    }

    local shouldDisableFlatTear = tear.m_tearFlags & TearFlags.TEAR_FLAT ~= 0 and
        (player ~= nil or not IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_FLAT_WORM, false)) -- The playerOwner check is wrong and leads to a crash

    if shouldDisableFlatTear then
        tear.m_sizeMulti = Vector(1, 1)
        tear.m_flags = tear.m_flags ~ TearFlags.TEAR_FLAT
    end

    local parent = tear.m_parent.ref
    if parent and parent.m_type == EntityType.ENTITY_FAMILIAR then
        ctx.tear_scaleFactor = ctx.tear_scaleFactor * 0.75
    end

    local speed = tear.m_velocity:Length()
    if subtypeFlag then
        local scaleFactor_speedComponent MathUtils.MapToRange(speed, {10.0, 20.0}, {0.9, 2.0}, true)
        ctx.tear_scaleFactor = ctx.tear_scaleFactor * scaleFactor_speedComponent
    end

    local effectsUpdate_deltaTime = IEntity.IsTimeScaledFrame(ctx, tear, player_maxFireDelay, 0.0)
    if effectsUpdate_deltaTime ~= 0 then
        update_ludovico_effects(ctx, tear, closure, effectsUpdate_deltaTime)
    end

    if not isMainTear then
        update_child_tear(ctx, tear, closure)
    else
        update_main_tear(ctx, tear, closure)
    end
end

---@class Gameplay.TearLudovicoUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module