--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local SpriteUtils = require("General.VanillaAPI.Sprite")
local ColorUtils = require("General.VanillaAPI.Color")
local IsaacUtils = require("Isaac.Utils.Common")
local HitListUtils = require("Isaac.Utils.HitList")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local IEntityKnife = require("Isaac.Interface.Entity_Knife")
local IEntityLaser = require("Isaac.Interface.Entity_Laser")

--#endregion

local VectorZero = Vector(0, 0)
local VectorOne = Vector(1, 1)

---@class Context.Gameplay.TearFetusUpdate
---@field player Component.Entity.Player?
---@field playerLuck number
---@field facingAngle number
---@field updateFacingDirection boolean

---@param knife Component.Entity.Knife
local function do_swing_attack(ctx, knife)
    local knifeScale = knife.m_sprite.Scale.X
    local swingBasePitch = 1.0 / (knifeScale * 0.5 + 0.5)
    swingBasePitch = math.max(swingBasePitch, 0.5)
    local swingPitch = swingBasePitch * (IsaacUtils.RandomFloat() * 0.2 + 0.9)
    IManager.PlaySound(ctx, SoundEffect.SOUND_SHELLGAME, 1.0, 1, false, swingPitch)

    IEntityKnife.PrepareSwing(knife, 1)
    IEntityKnife.Swing(ctx, knife)
end

---@param ctx Context.Common
---@param ctx_update Context.Gameplay.TearFetusUpdate
---@param tear Component.Entity.Tear
local function update_fetus_tech_x(ctx, ctx_update, tear)
    local ctx_game = ctx.game
    local player = ctx_update.player

    local techX_entity = tear.m_fetus_techXEntity.ref
    if not techX_entity and not tear.m_isDead then
        techX_entity = IGame.SpawnEx(
            ctx, ctx_game,
            EntityType.ENTITY_LASER, LaserVariant.THIN_RED,
            tear.m_position, VectorZero,
            player, 3, IsaacUtils.Random(), true
        )

        if not techX_entity then
            -- remove tech x flag
            tear.m_tearFlags = tear.m_tearFlags & TearFlags.TEAR_FETUS_TECHX
        else
            -- init tech x laser
            local techX_entityLaser = IEntity.ToLaser(techX_entity)
            assert(techX_entityLaser)

            if player then
                local techX_color = ColorUtils.Copy(player.m_laserColor)
                techX_entityLaser:SetColor(ctx, techX_color, -1, -1, false, true)
            end

            techX_entityLaser.m_positionOffset = tear.m_positionOffset
            IEntity.SetParent(techX_entityLaser, tear)
            techX_entityLaser.m_depthOffset = 3000.0

            local techX_removedFlags = TearFlags.TEAR_GROW | TearFlags.TEAR_SHRINK | TearFlags.TEAR_FETUS
            techX_entityLaser.m_tearFlags = tear.m_tearFlags & ~techX_removedFlags
            techX_entityLaser:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)
            techX_entityLaser.m_timeout = 300
            IEntityLaser.SetScale(techX_entityLaser, tear.m_fScale * 0.75)
            techX_entityLaser.m_radius = tear.m_fScale * 25.0 + 14.0
            IEntity.SetSpawnerEntity(techX_entityLaser, player)

            techX_entityLaser:Update(ctx)
            IEntity.set_entity_ref(tear.m_fetus_techXEntity, techX_entityLaser)
        end
    end

    if not techX_entity then
        return
    end

    local techX_entityLaser = IEntity.ToLaser(techX_entity)
    assert(techX_entityLaser)

    local techX_scale = tear.m_fScale * 0.75
    IEntityLaser.SetScale(techX_entityLaser, techX_scale)
    local techX_radius =  tear.m_fScale * 50.0 + 6.0
    techX_entityLaser.m_radius = techX_radius
end

---@param ctx Context.Common
---@param ctx_update Context.Gameplay.TearFetusUpdate
---@param tear Component.Entity.Tear
local function update_fetus_sword(ctx, ctx_update, tear)
    local ctx_game = ctx.game
    local player = ctx_update.player
    local facingAngle = ctx_update.facingAngle

    local sword_entity = tear.m_fetus_knifeEntity.ref
    -- spawn sword entity
    if not sword_entity and not tear.m_isDead then
        local sword_variant = tear.m_tearFlags & TearFlags.TEAR_FETUS_TECH ~= 0
            and KnifeVariant.TECH_SWORD
            or KnifeVariant.SPIRIT_SWORD

        sword_entity = IGame.Spawn(
            ctx, ctx_game,
            EntityType.ENTITY_KNIFE, sword_variant,
            tear.m_position, VectorZero,
            player, 0, IsaacUtils.Random()
        )

        local sword_entityKnife = IEntity.ToKnife(sword_entity)
        assert(sword_entityKnife)

        IEntity.SetParent(sword_entity, tear)
        local color = tear.m_sprite.Color
        sword_entityKnife:SetColor(ctx, color, -1, -1, false, true)

        sword_entityKnife.m_tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_GROW | TearFlags.TEAR_SHRINK)
        sword_entityKnife:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)
        IEntityKnife.SetRotationOffset(sword_entityKnife, 0.0)

        sword_entityKnife.m_sprite.Scale = VectorOne * (tear.m_fScale * 0.6)
        sword_entityKnife:Update(ctx)
        IEntity.set_entity_ref(tear.m_fetus_knifeEntity, sword_entityKnife)
        sword_entityKnife.m_rotation = facingAngle
    end

    if not sword_entity then
        return
    end

    local sword_entityKnife = IEntity.ToKnife(sword_entity)
    assert(sword_entityKnife)

    sword_entityKnife:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)

    local myScale = tear.m_fScale
    sword_entityKnife.m_sprite.Scale = VectorOne * (myScale * 0.6)
    local sword_offset = Vector(0.0, 6.0) * myScale
    sword_entityKnife.m_positionOffset = tear.m_positionOffset + sword_offset

    -- update attack state
    local facingDirection = Vector.FromAngle(facingAngle) -- unused
    local sword_charge = sword_entityKnife.m_charge
    if sword_charge > 1.1 then
        -- do spin attack
        IEntityKnife.SpinAttack(ctx, sword_entityKnife, 1, 0)
        sword_charge = 0.0
        sword_entityKnife.m_charge = 0.0
        sword_entityKnife.m_sword_isCharged = false
    else
        if sword_entityKnife.m_meleeSwingInputHeld_qqq then
            -- charge sword
            sword_charge = sword_charge + 0.04
            sword_entityKnife.m_charge = sword_charge
            sword_entityKnife.m_sword_isCharged = sword_charge >= 1.0
        elseif sword_entityKnife.m_isSwinging then
            -- swing sword
            do_swing_attack(ctx, sword_entityKnife)
        end
    end

    -- sword is doing nothing
    local shouldRemove = not sword_entityKnife.m_isFlying and
        not sword_entityKnife.m_isSwinging and
        not sword_entityKnife.m_meleeSwingInputHeld_qqq

    if shouldRemove then
        sword_entityKnife:Remove(ctx)
    end

    -- update visuals
    if sword_entityKnife.m_exists then
        local sword_animation = sword_entityKnife.m_sprite:GetAnimation()
        if sword_animation ~= "Spin" then
            sword_entityKnife.m_rotation = facingAngle
        else
            local hitOffset = IEntity.get_null_offset(sword_entityKnife, "Hit")
            local sword_sprite = sword_entityKnife.m_sprite
            local animation_length = sword_sprite:GetCurrentAnimationData():GetLength()
            local animation_angleStep = 360.0 / animation_length

            local hitAngle = hitOffset:GetAngleDegrees()
            hitAngle = MathUtils.NormalizeAngle(hitAngle)
            if hitAngle < 0.0 then
                hitAngle = hitAngle + 360.0
            end

            local frame = hitAngle / animation_angleStep
            SpriteUtils.SetFramePrecise(sword_sprite, frame)
        end
    end
end

---@param ctx Context.Common
---@param ctx_update Context.Gameplay.TearFetusUpdate
---@param tear Component.Entity.Tear
local function update_fetus_knife(ctx, ctx_update, tear)
    local ctx_game = ctx.game
    local player = ctx_update.player
    local facingAngle = ctx_update.facingAngle

    local knife_entity = tear.m_fetus_knifeEntity.ref
    -- spawn knife entity
    if not knife_entity and not tear.m_isDead then
        knife_entity = IGame.Spawn(
            ctx, ctx_game,
            EntityType.ENTITY_KNIFE, KnifeVariant.MOMS_KNIFE,
            tear.m_position, VectorZero, player,
            0, IsaacUtils.Random()
        )

        local knife_entityKnife = IEntity.ToKnife(knife_entity)
        assert(knife_entityKnife)

        IEntity.SetParent(knife_entityKnife, tear)
        local color = tear.m_sprite.Color
        knife_entityKnife:SetColor(ctx, color, -1, -1, false, true)

        knife_entityKnife.m_tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_GROW | TearFlags.TEAR_SHRINK)
        knife_entityKnife:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)
        IEntityKnife.SetRotationOffset(knife_entityKnife, 0.0)

        knife_entityKnife.m_sprite.Scale = VectorOne * (tear.m_fScale * 0.5)
        knife_entityKnife:Update(ctx)
        IEntity.set_entity_ref(tear.m_fetus_knifeEntity, knife_entityKnife)
    end

    if not knife_entity then
        return
    end

    -- update knife entity
    local knife_entityKnife = IEntity.ToKnife(knife_entity)
    assert(knife_entityKnife)

    knife_entityKnife:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)
    local knife_scale = VectorOne * tear.m_fScale * 0.5
    knife_entityKnife.m_sprite.Scale = knife_scale

    local knife_offset = Vector(0.0, 4.0) * tear.m_fScale
    knife_entityKnife.m_positionOffset = tear.m_positionOffset + knife_offset
    knife_entityKnife.m_rotation = facingAngle
end

---@param ctx Context.Common
---@param ctx_update Context.Gameplay.TearFetusUpdate
---@param tear Component.Entity.Tear
local function update_fetus_bone(ctx, ctx_update, tear)
    local ctx_game = ctx.game
    local player = ctx_update.player
    local facingAngle = ctx_update.facingAngle

    local bone_entity = tear.m_fetus_knifeEntity.ref
    -- spawn bone entity
    if not bone_entity and not tear.m_isDead then
        bone_entity = IGame.Spawn(
            ctx, ctx_game,
            EntityType.ENTITY_KNIFE, KnifeVariant.BONE_CLUB,
            tear.m_position, VectorZero, player,
            0, IsaacUtils.Random()
        )

        local bone_entityKnife = IEntity.ToKnife(bone_entity)
        assert(bone_entityKnife)

        IEntity.SetParent(bone_entityKnife, tear)
        local color = tear.m_sprite.Color
        bone_entityKnife:SetColor(ctx, color, -1, -1, false, true)

        bone_entityKnife.m_tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_GROW | TearFlags.TEAR_SHRINK)
        bone_entityKnife:SetCollisionDamage(ctx, tear.m_collisionDamage)
        IEntityKnife.SetRotationOffset(bone_entityKnife, 0.0)

        bone_entityKnife.m_sprite.Scale = VectorOne * (tear.m_fScale * 0.6)
        bone_entityKnife:Update(ctx)
        IEntity.set_entity_ref(tear.m_fetus_knifeEntity, bone_entityKnife)
    end

    if not bone_entity then
        return
    end

    local bone_entityKnife = IEntity.ToKnife(bone_entity)
    assert(bone_entityKnife)

    local bone_offset = Vector(0.0, 6.0) * tear.m_fScale
    bone_entityKnife.m_positionOffset = tear.m_positionOffset + bone_offset
    bone_entityKnife.m_rotation = facingAngle

    -- try swing bone
    local target = tear.m_target.ref
    if not bone_entityKnife.m_isSwinging and target then
        local facingDirection = Vector.FromAngle(facingAngle)
        local toTargetDisplacement = target.m_position - tear.m_position
        local toTargetDirection = toTargetDisplacement:Normalized()
        local facingAlignment = toTargetDirection:Dot(facingDirection)

        local canSwing = facingAlignment > 0.1 and
            toTargetDisplacement:Length() < tear.m_fScale * 50.0

        if canSwing then
            -- perform swing
            do_swing_attack(ctx, bone_entityKnife)
        end
    end

    ctx_update.updateFacingDirection = true
end

---@param ctx Context.Common
---@param ctx_update Context.Gameplay.TearFetusUpdate
---@param tear Component.Entity.Tear
local function update_fetus_tech(ctx, ctx_update, tear)
    if tear.m_fetus_techFireCooldown > 0 then
        tear.m_fetus_techFireCooldown = tear.m_fetus_techFireCooldown - 1
        return
    end

    local player = ctx_update.player
    local facingAngle = ctx_update.facingAngle
    local playerLuck = ctx_update.playerLuck

    local ctx_game = ctx.game
    local ctx_room = ctx_game.m_level.m_room
    local shootDirection = Vector.FromAngle(facingAngle)
    local myPosition = tear.m_position

    local ctx_entityList = ctx_room.m_entityList
    local enemies = IEntityList.QueryRadius(ctx, ctx_entityList, myPosition, 140.0, EntityPartition.ENEMY)

    local numEnemies = #enemies
    if numEnemies == 0 then
        return
    end

    -- select target
    ---@type Component.Entity?
    local shoot_targetEntity = nil
    local shoot_directionAlignment = -1
    for i = 1, numEnemies, 1 do
        local enemy = enemies[i]
        local canTargetEnemy = IEntity.IsVulnerableEnemy(enemy, nil) and
            enemy.m_flags & (EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_NO_TARGET) == 0

        if not canTargetEnemy then
            goto continue
        end

        local canReach = tear.m_gridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_BULLET or
            IRoom.CheckLine(ctx, ctx_room, myPosition, enemy.m_position, LineCheckMode.PROJECTILE, 0, false, false)

        if not canReach then
            goto continue
        end

        local toEnemyDisplacement = enemy.m_position - myPosition
        local toEnemyDirection = toEnemyDisplacement:Normalized()
        local shootDirectionAlignment = toEnemyDirection:Dot(shootDirection)

        if shootDirectionAlignment > shoot_directionAlignment then
            shoot_directionAlignment = shootDirectionAlignment
            shoot_targetEntity = enemy
        end
        ::continue::
    end

    if shoot_directionAlignment <= 0.85 or not shoot_targetEntity then
        return
    end

    -- shoot laser
    tear.m_fetus_techFireCooldown = 8
    local shoot_toTargetDisplacement = shoot_targetEntity.m_position - myPosition
    local shoot_toTargetDirection = shoot_toTargetDisplacement:Normalized()
    local shoot_toTargetAngle = shoot_toTargetDirection:GetAngleDegrees()

    local techLaser = IEntityLaser.ShootAngle(
        ctx, LaserVariant.THIN_RED, myPosition, shoot_toTargetAngle,
        3, tear.m_positionOffset, player, true
    )

    if not techLaser then
        return
    end

    techLaser.m_oneHit = true
    techLaser.m_disableFollowParent = true
    local tearFlags = tear.m_tearFlags & ~(TearFlags.TEAR_GROW | TearFlags.TEAR_SHRINK)

    local keepFlagsChance = math.max(20 - playerLuck, 1)
    if IsaacUtils.RandomInt(keepFlagsChance) ~= 0 then
        local removedFlags = TearFlags.TEAR_STICKY | TearFlags.TEAR_BOOGER | TearFlags.TEAR_SPORE
        tearFlags = tearFlags & ~removedFlags
    end

    if IsaacUtils.RandomInt(keepFlagsChance) ~= 0 then
        local removedFlags = TearFlags.TEAR_POP | TearFlags.TEAR_ABSORB
        tearFlags = tearFlags & ~removedFlags
    end

    techLaser.m_tearFlags = tearFlags
    techLaser:SetCollisionDamage(ctx, tear.m_collisionDamage)

    local isFartherFromCamera = shoot_toTargetDirection.Y < -0.5 or shoot_toTargetDirection.X < -0.5
    local depthOffset = isFartherFromCamera and -10.0 or 3000.0
    techLaser.m_depthOffset = depthOffset

    if player then
        local color = ColorUtils.Copy(player.m_laserColor)
        color.A = tear.m_sprite.Color.A
        techLaser:SetColor(ctx, color, -1, -1, false, true)
    end

    techLaser.m_maxDistance = 140.0
    IEntityLaser.SetScale(techLaser, tear.m_fScale * 0.75)

    techLaser:Update(ctx)
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function search_target(ctx, tear)
    local ctx_room = ctx.game.m_level.m_room
    local ctx_entityList = ctx_room.m_entityList

    ---@type Component.Entity?
    local target = nil
    local target_inverseWeight = math.huge

    local myFutureDisplacement = tear.m_velocity * 5.0
    local samplePosition = tear.m_position + myFutureDisplacement

    local target_candidates = IEntityList.QueryRadius(ctx, ctx_entityList, samplePosition, 128.0, EntityPartition.ENEMY)
    for i = 1, target_candidates, 1 do
        local candidate = target_candidates[i]
        local isValidCandidate = IEntity.IsVulnerableEnemy(candidate) and
            candidate.m_flags & (EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_NO_TARGET) == 0 and
            IsaacUtils.RandomInt(2) ~= 0

        if not isValidCandidate then
            goto continue
        end

        local hasLineToCandidate = true
        if tear.m_gridCollisionClass == EntityGridCollisionClass.GRIDCOLL_BULLET then
            hasLineToCandidate = IRoom.CheckLine(
                ctx, ctx_room,
                tear.m_position, candidate.m_position,
                LineCheckMode.PROJECTILE, 0,
                false, false
            )
        end

        if not hasLineToCandidate then
            goto continue
        end

        local distance = samplePosition:Distance(candidate.m_position)
        local inverseWeight = IsaacUtils.RandomFloat() * 128.0 + distance
        if inverseWeight < target_inverseWeight then
            target = candidate
            target_inverseWeight = inverseWeight
        end
        ::continue::
    end

    IEntity.SetTarget(tear, target)
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local playerOwner = IEntityTear.GetPlayer(tear)

    local sprite = tear.m_sprite
    local sprite_frame = sprite:GetFrame()
    local shootAngle = 90 + (sprite_frame * 360 / 15.0)

    local player_luck = 0.0
    if playerOwner then
        player_luck = playerOwner.m_luck
    end

    ---@type Context.Gameplay.TearFetusUpdate
    local ctx_update = {
        player = playerOwner,
        playerLuck = player_luck,
        animationFrame = sprite_frame,
        facingAngle = shootAngle,
        updateFacingDirection = false
    }

    if tear.m_tearFlags & TearFlags.TEAR_FETUS_TECHX ~= 0 then
        update_fetus_tech_x(ctx, ctx_update, tear)
    end

    if tear.m_tearFlags & TearFlags.TEAR_FETUS_SWORD ~= 0 then
        update_fetus_sword(ctx, ctx_update, tear)
    elseif tear.m_tearFlags & TearFlags.TEAR_FETUS_KNIFE ~= 0 then
        update_fetus_knife(ctx, ctx_update, tear)
    elseif tear.m_tearFlags & TearFlags.TEAR_FETUS_BONE ~= 0 then
        update_fetus_bone(ctx, ctx_update, tear)
    end

    if tear.m_tearFlags & TearFlags.TEAR_FETUS_TECH ~= 0 then
        update_fetus_tech(ctx, ctx_update, tear)
    end

    local myPosition = tear.m_position

    -- dampen velocity on first 20 frames using a parabolic factor
    local velocityDampen_parabolaInput = 1.0 - MathUtils.Clamp(tear.m_localFrame / 10.0, 0.0, 2.0) -- [-1.0, 1.0]
    local velocityDampen_factor = velocityDampen_parabolaInput ^ 2.0
    tear.m_friction = 0.9 + 0.1 * velocityDampen_factor

    local homing_speedFactor = math.min(tear.m_localFrame / 45.0, 1.0)
    -- clear hit list
    if IEntity.IsFrame(ctx, tear, 8, tear.m_index) and not tear.m_stick_target.ref then
        HitListUtils.Clear(tear.m_hitList)
    end

    if not tear.m_target.ref and IEntity.IsFrame(ctx, tear, 4, tear.m_index) then
        search_target(ctx, tear)
    end

    local target = tear.m_target.ref
    if not target then
        return
    end

    -- home in on target
    local myVelocity = tear.m_velocity
    local myTimeScale = tear.m_timeScale
    local fromTargetDisplacement = myPosition - target.m_position
    local fromTargetDirection = fromTargetDisplacement:Normalized()
    local homing_velocityMisalignment = myVelocity:Dot(fromTargetDirection)
    local homing_speed = (homing_velocityMisalignment * 0.1 + 1.35) * homing_speedFactor

    local homing_distance = fromTargetDisplacement:Length()
    local homing_friction_distanceComponent = -(homing_distance * 0.0005) -- more distance -> less velocity

    local myDirection = myVelocity:Normalized()
    local homing_directionMisalignment = myDirection:Dot(fromTargetDirection)
    local homing_friction_misalignmentComponent = -(homing_directionMisalignment * 0.05) -- the more it is misaligned -> less velocity

    local homing_friction = 0.92 + homing_friction_misalignmentComponent + math.max(0.08 + homing_friction_distanceComponent, 0.0)
    homing_friction = math.min(homing_friction, 0.98)

    local homing_addedVelocity = -(fromTargetDirection * myTimeScale * homing_speed)
    myVelocity = myVelocity + homing_addedVelocity
    myVelocity = myDirection * IsaacUtils.TimeScaledFriction(homing_friction, myTimeScale)

    local homing_angleApproachStep = tear.m_tearFlags & TearFlags.TEAR_HOMING ~= 0 and 12.0 or 2.0 -- homing makes angle approach faster

    local mySpeed = myVelocity:Length()
    homing_angleApproachStep = homing_angleApproachStep * myTimeScale
    local homing_toTargetDisplacement = -fromTargetDisplacement
    local homing_toTargetAngle = homing_toTargetDisplacement:GetAngleDegrees()
    local myAngle = myVelocity:GetAngleDegrees()
    myAngle = MathUtils.ApproachAngle(myAngle, homing_toTargetAngle, homing_angleApproachStep)

    myVelocity = Vector.FromAngle(myAngle) * mySpeed
    tear.m_velocity = myVelocity

    -- update facing direction
    if ctx_update.updateFacingDirection and not VectorUtils.Equals(fromTargetDisplacement, VectorZero) then
        local animationLength = sprite:GetCurrentAnimationData():GetLength()
        local animationFrame = sprite:GetFrame()
        local angleStep = 360.0 / animationLength
        local currentAngle = animationFrame * angleStep

        local distanceSquared = fromTargetDisplacement:LengthSquared()
        -- the actual intention is to have the factor be tear.m_timeScale * 15.0 / distance,
        -- but to avoid a normalization we divide by distanceSquared,
        -- "removing" the magnitude of the displacement vector from the result
        local turningFactor = tear.m_timeScale * 15.0 / distanceSquared
        local steeringVector = fromTargetDisplacement * turningFactor

        local currentDirection = Vector.FromAngle(currentAngle)
        local finalDirection = currentDirection + steeringVector

        local finalAngle = finalDirection:GetAngleDegrees()
        finalAngle = MathUtils.NormalizeAngle(finalAngle)
        if finalAngle < 0.0 then
            finalAngle = finalAngle + 360.0
        end

        local preciseFrame = finalAngle / angleStep
        SpriteUtils.SetFramePrecise(sprite, preciseFrame)
    end
end

---@class Gameplay.TearFetusUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module