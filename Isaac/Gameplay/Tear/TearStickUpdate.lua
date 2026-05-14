--#region Dependencies

local Enums = require("General.Enums")
local IsaacUtils = require("Isaac.Utils.Common")
local HitListUtils = require("Isaac.Utils.HitList")
local IGame = require("Isaac.Interface.Game")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")

--#endregion

local eTearDeathFlags = Enums.eTearDeathFlags

---@param variant TearVariant
---@return boolean
local function should_stop_animation(variant)
    return variant == TearVariant.BOOGER or variant == TearVariant.SPORE
end

---@param ctx Context.Gameplay.TearUpdate
---@param tear Component.Entity.Tear
local function setup_sticky_explosion(ctx, tear)
    tear.m_tearFlags = tear.m_tearFlags | TearFlags.TEAR_EXPLOSIVE
    tear.m_deathFlags = tear.m_deathFlags | eTearDeathFlags.FLAG_5
    tear.m_collisionDamage = tear.m_collisionDamage + 60.0

    local player = IEntityTear.GetPlayer(tear)
    if player then
        local bombScale = IEntityPlayer.GetBombScale(ctx, player, BitSet128())
        if bombScale >= 1.5 then
            tear.m_collisionDamage = tear.m_collisionDamage + 50.0
        end
    end
end

---@param ctx Context.Gameplay.TearUpdate
---@param tear Component.Entity.Tear
---@param stickTarget Component.Entity?
local function do_spore_explosion(ctx, tear, stickTarget)
    local ctx_game = ctx.game

    local player = IEntityTear.GetPlayer(tear)
    local fart_color = Color(
        1.0, 1.0, 1.0, 1.0,
        0.0, 0.0, 0.0,
        0.8, 0.8, 2.0, 1.0
    )

    local fart_source = player and player or tear
    local tearPosition = tear.m_position

    IGame.Fart(ctx, ctx_game, tearPosition, 85.0, fart_source, 1.0, 0, fart_color)
    if not stickTarget then
        return
    end

    local ctx_entityList = ctx_game.m_level.m_room.m_entityList

    local numSubTears
    if tear.m_flags & EntityFlag.FLAG_REDUCE_GIBS ~= 0 then
        numSubTears = IsaacUtils.RandomInt(2)
    else
        numSubTears = IsaacUtils.RandomInt(3) + 2
    end

    -- angle offset that affects all tears
    local randomAngleOffset = IsaacUtils.RandomFloat() * 360.0

    local targetBlackList = HitListUtils.New()
    HitListUtils.AddEntity(targetBlackList, stickTarget)

    local candidates = IEntityList.QueryRadius(ctx, ctx_entityList, tearPosition, 200.0, EntityPartition.ENEMY)

    for i = 1, numSubTears, 1 do
        local idx = i - 1
        local randomAngle = (IsaacUtils.RandomFloat() * 0.8 + (idx - 0.4)) * 360
        randomAngle = randomAngle / numSubTears + randomAngleOffset
        local subTear_direction = Vector.FromAngle(randomAngle)

        local subTear_targetLowestDistance = 1000000000.0
        local subTear_targetEntity = nil
        for ii = 0, #candidates, 1 do
            local entry = candidates[ii]

            local validEntry = IEntity.IsVulnerableEnemy(entry) and
                entry.m_flags & EntityFlag.FLAG_FRIENDLY == 0 and
                not HitListUtils.IsInHitList(targetBlackList, entry)

            if not validEntry then
                goto continue
            end


            local subTear_futureOffset = subTear_direction * 200.0
            local subTear_futurePosition = tear.m_position + subTear_futureOffset
            local futureTargetDistance = subTear_futurePosition:DistanceSquared(entry.m_position)

            if futureTargetDistance < subTear_targetLowestDistance then
                subTear_targetLowestDistance = futureTargetDistance
                subTear_targetEntity = entry
            end
            ::continue::
        end

        if subTear_targetEntity then
            HitListUtils.AddEntity(targetBlackList, subTear_targetEntity)
            local targetPredictedPosition = IEntity.get_predicted_target_pos(tear, subTear_targetEntity, 0.1)
            local predictedDisplacement = targetPredictedPosition - tear.m_position
            subTear_direction = predictedDisplacement:Normalized()
        end

        local subTear_randomSpeed = IsaacUtils.RandomFloat() * 4.0 + 8.0
        local subTear_seed = Random()

        local subTear_spawner = tear.m_spawnerEntity.ref
        local subTear_velocity = subTear_direction * subTear_randomSpeed
        local subTear_position = tearPosition - tear.m_velocity

        local subTear_entity = IGame.Spawn(
            ctx, ctx_game,
            tear.m_type, tear.m_variant,
            subTear_position, subTear_velocity,
            subTear_spawner, 0, subTear_seed
        )

        local subTear_entityTear = IEntity.ToTear(subTear_entity)
        assert(subTear_entityTear)

        IEntityTear.SetHeight(ctx, subTear_entityTear, -23.75)
        local bannedFlags = TearFlags.TEAR_HYDROBOUNCE |
            TearFlags.TEAR_ABSORB | TearFlags.TEAR_BONE |
            TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_SPLIT |
            TearFlags.TEAR_QUADSPLIT

        local forcedFlags = TearFlags.TEAR_PIERCING |
            TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING

        local flags = tear.m_flags & ~bannedFlags
        flags = flags | forcedFlags
        subTear_entityTear.m_tearFlags = flags

        local realScale = tear.m_baseScale * ctx.tear_scaleFactor
        IEntityTear.SetScale(ctx, subTear_entityTear, realScale * 0.2)
        subTear_entityTear:SetColor(ctx, tear.m_sprite.Color, -1, -1, false, true)
        IEntity.SetParent(subTear_entityTear, tear.m_parent.ref)

        HitListUtils.AddEntity(subTear_entityTear.m_hitList, stickTarget)
        subTear_entityTear.m_flags = subTear_entityTear & EntityFlag.FLAG_REDUCE_GIBS
        subTear_entityTear:Update(ctx)
    end
end

---@param ctx Context.Gameplay.TearUpdate
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local stickTarget = tear.m_stick_target.ref
    if not stickTarget then
        ---@type TearVariant
        local variant = tear.m_variant
        local sprite = tear.m_sprite
        -- restart animation
        if should_stop_animation(variant) and not sprite:IsPlaying() then
            local animation = sprite:GetAnimation()
            sprite:Play(animation, false)
        end

        return
    end

    if stickTarget.m_visible and stickTarget.m_entityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
        -- update stuck target
        tear.m_velocity = stickTarget.m_velocity
        tear.m_position = stickTarget.m_position + tear.m_stick_diff

        local sprite = tear.m_sprite
        if should_stop_animation(tear.m_variant) and sprite:IsPlaying() then
            sprite:Stop()
        end
    else
        -- detach target
        IEntity.set_entity_ref(tear.m_stick_target, nil)
        HitListUtils.Clear(tear.m_hitList)

        if should_stop_animation(tear.m_variant) then
            local sprite = tear.m_sprite
            local animation = sprite:GetAnimation()
            sprite:Play(animation)
        end
    end

    local timer = tear.m_stick_timer - 1
    tear.m_stick_timer = timer

    if timer > 0 then
        return
    end

    -- setup death params
    tear.m_isDead = true
    tear.m_deathFlags = tear.m_deathFlags | eTearDeathFlags.FLAG_6

    local scale = tear.m_baseScale * ctx.sticky_scaleFactor
    scale = math.max(scale, 0.01)
    tear.m_fScale = scale
    IEntityTear.reset_sprite_scale(ctx, tear)

    if tear.m_tearFlags & TearFlags.TEAR_STICKY ~= 0 then
        setup_sticky_explosion(ctx, tear)
    end

    if tear.m_tearFlags & TearFlags.TEAR_SPORE ~= 0 then
        do_spore_explosion(ctx, tear, stickTarget)
    end
end

---@class Gameplay.TearStickUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module