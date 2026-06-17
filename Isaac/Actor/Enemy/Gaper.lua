--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityNPC = require("Isaac.Interface.Entity_NPC")
local IPathfinder = require("Isaac.Interface.NPC_Pathfinder")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")
local EntityIdentity = require("Isaac.Enums.EntityIdentity")
local SpriteUtils = require("General.VanillaAPI.Sprite")
local ProjectileParams = require("Isaac.Utils.ProjectileParams")

--#endregion

local eGaperVariant = EntityIdentity.eGaperVariant
local eFattyVariant = EntityIdentity.eFattyVariant
local eStoneyVariant = EntityIdentity.eStoneyVariant
local eGusherVariant = EntityIdentity.eGusherVariant
local eConjoinedFattyVariant = EntityIdentity.eConjoinedFattyVariant
local eFirePlaceVariant = EntityIdentity.eFirePlaceVariant

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_HEAD = "Head"
local ANIMATION_HEAD_IDLE = "HeadIdle"
local ANIMATION_FIRE = "Fire"
local ANIMATION_ATTACK = "Attack"
local ANIMATION_WALK_VERT = "WalkVert"
local ANIMATION_WALK_HORI = "WalkHori"
local ANIMATION_ATTACK_VERT = "AttackVert"
local ANIMATION_ATTACK_HORI = "AttackHori"

local LAYER_FIRE = "Fire"
local NULL_LAYER_FIRE_POS = "FirePos"

local POSSESSOR_ROAR = ButtonAction.ACTION_PILLCARD

local GAPER_SOUND_ROAR = SoundEffect.SOUND_ZOMBIE_WALKER_KID

local STONEY_LAYER_ID_HEAD = 1
local STONEY_NULL_LAYER_ID_HEAD_GUIDE = 2
local STONEY_SOUND_ROAR = SoundEffect.SOUND_STONE_WALKER
local STONEY_SOUND_SHOOT = SoundEffect.SOUND_STONESHOOT
local STONEY_ANIMATION_SHOOT_AND_ROTATE_1 = "ShootAndRotate1"
local STONEY_ANIMATION_SHOOT_AND_ROTATE_2 = "ShootAndRotate2"
local STONEY_ANIMATION_PANT = "Pant"
local STONEY_EVENT_SHOOT = "Shoot"

local FATTY_SOUND_SETUP_ATTACK = SoundEffect.SOUND_ANGRY_GURGLE
local FATTY_SOUND_ROAR = SoundEffect.SOUND_MONSTER_ROAR_1
local FATTY_POSSESSOR_ATTACK = ButtonAction.ACTION_ITEM

local CONJOINED_FATTY_SOUND_SHOOT_LIQUID = SoundEffect.SOUND_HEARTIN
local CONJOINED_FATTY_SOUND_SHOOT_FART = SoundEffect.SOUND_FART
local CONJOINED_FATTY_EVENT_TARGET = "Target"
local CONJOINED_FATTY_EVENT_SHOOT = "Shoot"
local CONJOINED_FATTY_EVENT_SHOOT_STOP = "Stop"
local CONJOINED_FATTY_COLOR_BLOOD_EFFECT = Color(
    0.0, 0.0, 0.0, 1.0,
    0.08, 0.5, 0.01,
    0.0, 0.0, 0.0, 0.0
)

local BLUE_CONJOINED_FATTY_SOUND_SHOOT = SoundEffect.SOUND_HEARTOUT
local BLUE_CONJOINED_FATTY_EVENT_SHOOT = "Shoot"

local CYCLOPIA_EVENT_SHOOT = "Shoot"

local COLOR_NULLS_SPLAT_COLOR = Color(0.1, 0.0, 0.0, 1.0)
local COLOR_STONEY_SPLAT_COLOR = Color(
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    1.0, 1.0, 1.0, 1.0
)

local FIELD_GAPER_SPEED = "m_F1"
local FIELD_STONEY_WALK_STAMINA = "m_I1"
local FIELD_STONEY_RECOVER_COUNTDOWN = "m_I1"
local FIELD_STONEY_ROTATION_TYPE = "m_I2"

---@param npc Component.Entity.Npc
local function Stoney_SetupWalkStamina(npc)
    local walkStamina = IsaacUtils.RandomInt(60) + 90
    npc[FIELD_STONEY_WALK_STAMINA] = walkStamina
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gaper_Init(npc, ctx)
    local myType = npc.m_type
    local mySprite = npc.m_sprite
    npc.m_state = NpcState.STATE_MOVE
    npc.m_stateFrame = 0

    local hasHeadAnimation = myType ~= EntityType.ENTITY_FATTY
        and myType ~= EntityType.ENTITY_CONJOINED_FATTY
        and myType ~= EntityType.ENTITY_STONEY

    if myType == EntityType.ENTITY_STONEY then
        local enabledFlags = (EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR)
        npc.m_flags = npc.m_flags | enabledFlags
        npc.m_invincible = true
    end

    if hasHeadAnimation then
        if myType == EntityType.ENTITY_GAPER and npc.m_variant == eGaperVariant.FLAMING_GAPER then
            mySprite:PlayOverlay(ANIMATION_HEAD, false)
        else
            mySprite:SetOverlayFrame(ANIMATION_HEAD, 0)
        end
    end

    if myType == EntityType.ENTITY_FATTY and eFattyVariant.FLAMING_FATTY then
        mySprite:SetOverlayRenderPriority(true)
        mySprite:PlayOverlay(ANIMATION_FIRE, false)
    end

    mySprite:SetFrame(ANIMATION_WALK_VERT, 0)

    if myType == EntityType.ENTITY_NULLS then
        npc.m_splatColor = COLOR_NULLS_SPLAT_COLOR
    elseif myType == EntityType.ENTITY_STONEY then
        npc.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.m_splatColor = COLOR_STONEY_SPLAT_COLOR
        Stoney_SetupWalkStamina(npc)

        if npc.m_variant == eStoneyVariant.CROSS_STONEY then
            mySprite:PlayOverlay(ANIMATION_HEAD_IDLE, false)

            local headGuideFrame = SpriteUtils.GetNullFrameById(mySprite, STONEY_NULL_LAYER_ID_HEAD_GUIDE)
            local headLayer = mySprite:GetLayer(STONEY_LAYER_ID_HEAD)
            if headGuideFrame and headLayer then
                headLayer:SetPos(headGuideFrame:GetPos())
                headLayer:SetSize(headGuideFrame:GetScale())
            end
        end
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gaper_Death(npc, ctx)
    local isOverKill = npc.m_health <= -25.0
    if isOverKill then
        return
    end

    local shouldRevive = IsaacUtils.RandomInt(2) == 0
    if not shouldRevive then
        return
    end

    local myType = npc.m_type
    if myType == EntityType.ENTITY_GAPER then
        local gusher_variant
        if IsaacUtils.RandomInt(3) == 0 and npc.m_variant ~= eGaperVariant.FLAMING_GAPER then
            gusher_variant = eGusherVariant.PACER
        else
            gusher_variant = eGusherVariant.GUSHER
        end

        IEntityNPC.Morph(ctx, npc, EntityType.ENTITY_GUSHER, gusher_variant, 0, -1)
        npc.m_isDead = false
        npc.m_health = npc.m_maxHealth
        npc.m_projectileCooldown = IsaacUtils.RandomInt(20) + 20
        return
    end

    if myType == EntityType.ENTITY_FATTY then
        local variant = npc.m_variant
        if variant == eFattyVariant.PALE_FATTY then
            IEntityNPC.Morph(ctx, npc, EntityType.ENTITY_BLUBBER, 0, 0, -1)
            npc.m_isDead = false
            npc.m_health = npc.m_maxHealth
            return
        end

        if variant == eFattyVariant.FLAMING_FATTY then
            local game = ctx.game
            local spawn_type = EntityType.ENTITY_FIREPLACE
            local spawn_variant = eFirePlaceVariant.MOVABLE_FIRE_PLACE
            local spawn_subtype = 0
            local spawn_pos = npc.m_position
            local spawn_vel = Vector(0, 0)
            local spawn_spawner = npc
            local spawn_seed = IsaacUtils.Random()

            local fire_entity = IGame.Spawn(
                ctx, game, spawn_type, spawn_variant,
                spawn_pos, spawn_vel, spawn_spawner,
                spawn_subtype, spawn_seed
            )

            fire_entity.m_targetPosition = VectorUtils.Copy(fire_entity.m_position)
            return
        end
    end

    if myType == EntityType.ENTITY_CONJOINED_FATTY then
        if npc.m_variant == eConjoinedFattyVariant.CONJOINED_FATTY then
            IEntityNPC.Morph(ctx, npc, EntityType.ENTITY_FATTY, eFattyVariant.FATTY, 0, -1)
            npc.m_isDead = false
            npc.m_health = npc.m_maxHealth
        end

        return
    end

end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gaper_UpdateSpeed(npc, ctx)
    local myType = npc.m_type
    local myVariant = npc.m_variant

    local speed = 0.6

    if myType == EntityType.ENTITY_FATTY or myType == EntityType.ENTITY_CONJOINED_FATTY then
        speed = 0.3
        if myType == EntityType.ENTITY_FATTY and myVariant == eFattyVariant.FLAMING_FATTY then
            speed = 0.33
        end

        npc[FIELD_GAPER_SPEED] = speed
        return
    end

    if myType == EntityType.ENTITY_STONEY then
        if myVariant == eStoneyVariant.CROSS_STONEY then
            speed = 0.48
        end

        npc[FIELD_GAPER_SPEED] = speed
        return
    end

    if myType == EntityType.ENTITY_NULLS then
        npc[FIELD_GAPER_SPEED] = 0.9
        return
    end

    if myType == EntityType.ENTITY_CYCLOPIA and myVariant == 1 then
        npc[FIELD_GAPER_SPEED] = 0.498
        return
    end

    local mySprite = npc.m_sprite
    if myVariant == 2 then
        speed = 0.5478
        mySprite:PlayOverlay(ANIMATION_HEAD, false)
    elseif mySprite:GetOverlayFrame() > 0 then
        speed = 0.72
    end

    npc[FIELD_GAPER_SPEED] = speed
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gaper_UpdateRoar(npc, ctx)
    local triggerRoar
    local isPossessed = npc.m_possessor_controllerIdx ~= -1

    if isPossessed then
        triggerRoar = IEntityNPC.IsActionTriggered(ctx, npc, POSSESSOR_ROAR)
    else
        local playerTarget = IEntityNPC.GetPlayerTarget(ctx, npc)
        local enemyTarget = IEntityNPC.IsEnemyTarget(npc, playerTarget)

        triggerRoar = enemyTarget
            and npc.m_pathfinder.m_hasDirectPath
            and IsaacUtils.RandomInt(3) == 0
    end

    local myType = npc.m_type
    local cannotRoar = myType == EntityType.ENTITY_STONEY
        and (npc.m_state == NpcState.STATE_SPECIAL or npc.m_variant == eStoneyVariant.CROSS_STONEY)

    if not triggerRoar or cannotRoar then
        return
    end

    -- trigger roar
    local roar_pitch
    local roar_frameDelay
    local roar_sound

    if myType == EntityType.ENTITY_FATTY or myType == EntityType.ENTITY_CONJOINED_FATTY then
        roar_pitch = 1.0
        roar_frameDelay = 60
        roar_sound = FATTY_SOUND_ROAR
    elseif myType == EntityType.ENTITY_STONEY then
        roar_pitch = IsaacUtils.RandomFloat() * 0.1 + 0.9
        roar_frameDelay = 60
        roar_sound = STONEY_SOUND_ROAR
    else
        roar_pitch = 1.0
        roar_frameDelay = 40
        roar_sound = GAPER_SOUND_ROAR
    end

    IEntityNPC.play_sound(ctx, npc, roar_sound, 1.0, roar_frameDelay, false, roar_pitch)
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Fatty_CanTriggerAttack(npc, ctx)
    local myPlayerTarget = IEntityNPC.GetPlayerTarget(ctx, npc)
    local isPossessed = npc.m_possessor_controllerIdx ~= -1
    local fatty_triggerAttack

    if isPossessed then
        fatty_triggerAttack = IEntityNPC.IsActionPressed(ctx, npc, FATTY_POSSESSOR_ATTACK)
            and not VectorUtils.Equals(IEntityNPC.GetShootingInput(ctx, npc, 0.1), Vector(0, 0))
    else
        local target_isEnemy = IEntityNPC.IsEnemyTarget(npc, myPlayerTarget)
        fatty_triggerAttack = target_isEnemy
            and npc.m_position:DistanceSquared(myPlayerTarget.m_position) < 40000.0
            and IsaacUtils.RandomInt(120) == 0
    end

    return fatty_triggerAttack and npc.m_stateFrame > 99
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Fatty_SetupAttack(npc, ctx)
    IEntityNPC.play_sound(ctx, npc, FATTY_SOUND_SETUP_ATTACK, 1.0, 5, false, 1.0)
    local myVelocity = npc.m_velocity
    local horizontalAnimation = math.abs(myVelocity.X) > math.abs(myVelocity.Y)
        and myVelocity:LengthSquared() > 0.01

    npc.m_state = NpcState.STATE_ATTACK
    npc.m_stateFrame = 0

    if horizontalAnimation then
        local sprite = npc.m_sprite
        sprite:Play(ANIMATION_ATTACK_HORI, false)
        sprite.FlipX = myVelocity.X < 0.0
    else
        npc.m_sprite:Play(ANIMATION_ATTACK_VERT, false)
    end

    IEntityNPC.update_player_aim(ctx, npc, true)
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Fatty_Attack(npc, ctx)
    if npc.m_sprite:IsEventTriggered(BLUE_CONJOINED_FATTY_EVENT_SHOOT) then
        local myPos = npc.m_position
        local game = ctx.game

        IGame.ButterBeanFart(ctx, game, myPos, 120.0, npc, true, false)
        local variant = npc.m_variant

        if variant == eFattyVariant.PALE_FATTY then
            local projectile_velocity = Vector(8.0, 6.0)
            local projectileParams = ProjectileParams.New()
            IEntityNPC.fire_projectiles(ctx, npc, myPos, projectile_velocity, ProjectileMode.CIRCLE_CUSTOM, projectileParams)
        elseif variant == eFattyVariant.FLAMING_FATTY then
            local fire_seed = IsaacUtils.Random()
            local fire_type = EntityType.ENTITY_FIREPLACE
            local fire_variant = eFirePlaceVariant.MOVABLE_FIRE_PLACE
            local fire_subtype = 0
            local fire_velocity = VECTOR_ZERO

            local fire_entity = IGame.Spawn(
                ctx, game, fire_type, fire_variant,
                myPos, fire_velocity, npc,
                fire_subtype, fire_seed
            )

            fire_entity.m_targetPosition = VectorUtils.Copy(fire_entity.m_position)
        end
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function ConjoinedFatty_Attack(npc, ctx)
    local mySprite = npc.m_sprite

    if mySprite:IsEventTriggered(CONJOINED_FATTY_EVENT_TARGET) then
        local target = IEntityNPC.GetPlayerTarget(ctx, npc)
        local targetDisplacement = target.m_position - npc.m_position
        npc.m_targetPosition = targetDisplacement:Normalized()
    end

    local event_shoot = mySprite:IsEventTriggered(CONJOINED_FATTY_EVENT_SHOOT)
    local possessor_shouldTarget = event_shoot
        and npc.m_possessor_controllerIdx ~= 1 and
        not VectorUtils.Equals(npc.m_possessor_aim, VECTOR_ZERO)

    if possessor_shouldTarget then
        npc.m_targetPosition = npc.m_possessor_aim:Normalized()
    end

    if event_shoot and not mySprite:IsEventTriggered(CONJOINED_FATTY_EVENT_SHOOT_STOP) then
        local myStateFrame = npc.m_stateFrame
        if myStateFrame == 0 then
            -- play shoot sound
            IManager.PlaySound(ctx, CONJOINED_FATTY_SOUND_SHOOT_LIQUID, 0.7, 2, false, 1.0)
            IManager.PlaySound(ctx, CONJOINED_FATTY_SOUND_SHOOT_FART, 1.0, 2, false, 1.0)
        end

        local shootDirection = npc.m_targetPosition
        local creep_offset = shootDirection * myStateFrame * 25.0
        local creep_pos = npc.m_position + creep_offset

        local creep_type = EntityType.ENTITY_EFFECT
        local creep_variant = EffectVariant.CREEP_GREEN
        local creep_subtype = 0
        local creep_vel = VECTOR_ZERO
        local creep_spawner = npc
        local creep_seed = IsaacUtils.Random()
        local creep_scale = myStateFrame * 0.07 + 0.9

        local game = ctx.game

        local creep_entity = IGame.Spawn(
            ctx, game, creep_type, creep_variant,
            creep_pos, creep_vel, creep_spawner,
            creep_subtype, creep_seed
        )

        ---@cast creep_entity Component.Entity.Effect
        creep_entity.m_timeout = 15
        creep_entity.m_lifeSpan = 15
        creep_entity.m_sprite.Scale = Vector(creep_scale, creep_scale)
        creep_entity:Update(ctx)

        if IRoom.IsPositionInRoom(game.m_level.m_room, creep_pos, 0.0) then
            local randomVelocity = IsaacUtils.RandomFloat()
            local bloodEffect_velocity = shootDirection * randomVelocity * 2
            local bloodEffect_color = CONJOINED_FATTY_COLOR_BLOOD_EFFECT
            local bloodEffect_offset = Vector(0.0, IsaacUtils.RandomFloat() * -16.0)
            local bloodEffect_pos = creep_pos - (shootDirection * 5.0)

            local bloodEffect_entity = IEntityNPC.MakeBloodEffect(
                ctx, EffectVariant.BLOOD_EXPLOSION,
                bloodEffect_pos, bloodEffect_offset,
                bloodEffect_color, bloodEffect_velocity
            )

            bloodEffect_entity.m_sprite.Rotation = IsaacUtils.RandomFloat() * 360.0

            local bloodSplat_seed = IsaacUtils.Random()
            local bloodSplat_type = EntityType.ENTITY_EFFECT
            local bloodSplat_variant = EffectVariant.BLOOD_SPLAT
            local bloodSplat_subtype = 0

            local bloodSplat_entity = IGame.Spawn(
                ctx, game, bloodSplat_type, bloodSplat_variant,
                creep_pos, VECTOR_ZERO, nil,
                bloodSplat_subtype, bloodSplat_seed
            )

            local bloodSplat_color = CONJOINED_FATTY_COLOR_BLOOD_EFFECT
            bloodSplat_entity.m_sizeMulti = Vector(creep_scale, creep_scale)
            bloodSplat_entity:SetColor(ctx, bloodEffect_color, -1, -1, false, true)
            bloodSplat_entity:Update(ctx)
        end

        npc.m_stateFrame = npc.m_stateFrame + IEntity.GetFrameDelta(npc)
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function BlueConjoinedFatty_Attack(npc, ctx)
    if npc.m_sprite:IsEventTriggered(BLUE_CONJOINED_FATTY_EVENT_SHOOT) then
        IManager.PlaySound(ctx, BLUE_CONJOINED_FATTY_SOUND_SHOOT, 1.0, 2, false, 1.0)

        local projectileParams = ProjectileParams.New()
        local flags = ProjectileFlags.SMART | ProjectileFlags.EXPLODE
        projectileParams.bulletFlags = projectileParams.bulletFlags | flags
        projectileParams.scale = 1.5
        local playerTarget = IEntityNPC.GetPlayerTarget(ctx, npc)
        local shootDirection_base = playerTarget.m_position - npc.m_position

        local isPossessed = npc.m_possessor_controllerIdx ~= -1
        if isPossessed and not VectorUtils.Equals(npc.m_possessor_aim, VECTOR_ZERO) then
            shootDirection_base = npc.m_possessor_aim
        end

        local shootVelocity = shootDirection_base:Resized(7.0)
        IEntityNPC.fire_projectiles(ctx, npc, npc.m_position, shootVelocity, ProjectileMode.SINGLE, projectileParams)
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Cyclopia_Attack(npc, ctx)
    local mySprite = npc.m_sprite

    IEntityNPC.update_player_aim(ctx, npc, false)
    local eventShoot = mySprite:IsEventTriggered(CYCLOPIA_EVENT_SHOOT)
    if eventShoot then
        local myPos = npc.m_position
        local isPossessed = npc.m_possessor_controllerIdx ~= -1
        local shootDirection_base

        if isPossessed then
            shootDirection_base = npc.m_possessor_aim
        else
            local target = IEntityNPC.GetPlayerTarget(ctx, npc)
            shootDirection_base = target.m_position - myPos
        end

        local projectileParams = ProjectileParams.New()
        local projectile_velocity = shootDirection_base:Resized(7.0)

        IEntityNPC.fire_projectiles(ctx, npc, myPos, projectile_velocity, ProjectileMode.SINGLE, projectileParams)
    end

    local eventAttackEnd = mySprite:IsOverlayFinished()
    if eventAttackEnd then
        npc.m_state = NpcState.STATE_MOVE
        npc.m_stateFrame = 0
        mySprite:SetOverlayFrame(ANIMATION_HEAD, 0.0)
    end

    npc.m_friction = npc.m_friction * 0.4
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Cyclopia_UpdateSpawnCreep(npc, ctx)
    local shouldSpawnCreep = IEntity.IsTimeScaledFrame(ctx, npc, 7, npc.m_index % 7)
    if not shouldSpawnCreep then
        return
    end

    local creep_type = EntityType.ENTITY_EFFECT
    local creep_variant = EffectVariant.CREEP_RED
    local creep_subtype = 0
    local creep_pos = npc.m_position
    local creep_vel = VECTOR_ZERO
    local creep_spawner = npc
    local creep_seed = IsaacUtils.Random()

    local creep_entity = IGame.Spawn(
        ctx, ctx.game, creep_type, creep_variant,
        creep_pos, creep_vel, creep_spawner,
        creep_subtype, creep_seed
    )

    ---@cast creep_entity Component.Entity.Effect
    creep_entity.m_timeout = 20
    creep_entity.m_lifeSpan = 20

    local creep_scale = IsaacUtils.RandomFloat() * 0.3 + 0.2
    creep_entity.m_sprite.Scale = Vector(creep_scale, creep_scale)
    creep_entity:Update(ctx)
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Cyclopia_UpdateAttackTrigger(npc, ctx)
    if npc.m_state ~= NpcState.STATE_MOVE or npc.m_projectileCooldown >= 1 then
        return
    end

    local isPossessed = npc.m_possessor_controllerIdx ~= -1
    local shouldAttack
    local projectileCooldown

    if isPossessed then
        IEntityNPC.update_player_aim(ctx, npc, true)
        local isAiming = not VectorUtils.Equals(npc.m_possessor_aim, VECTOR_ZERO)
        shouldAttack = isAiming
        projectileCooldown = 45
    else
        shouldAttack = npc.m_pathfinder.m_hasDirectPath
            and IsaacUtils.RandomInt(30) == 0
            and npc.m_position:DistanceSquared(IEntityNPC.GetPlayerTarget(ctx, npc).m_position) < 40000.0

        projectileCooldown = 60
    end

    if shouldAttack then
        npc.m_projectileCooldown = projectileCooldown
        npc.m_state = NpcState.STATE_ATTACK
        npc.m_sprite:PlayOverlay(ANIMATION_ATTACK, false)
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Stoney_CheckDeath(npc, ctx)
    local room = ctx.game.m_level.m_room

    local shouldDie = IEntityNPC.get_alive_enemy_count(ctx, npc) < 1
        and (not room.m_hasTriggerPressurePlates or room.m_clearDelay < 9)
        and npc.m_state ~= NpcState.STATE_DEATH

    if not shouldDie then
        return
    end

    local myVariant = npc.m_variant
    npc.m_state = NpcState.STATE_DEATH
    npc.m_stateFrame = 0
    npc.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    if myVariant == eStoneyVariant.CROSS_STONEY then
        local mySprite = npc.m_sprite
        local overlay = SpriteUtils.GetOverlayAnimState(mySprite)
        SpriteUtils.ResetAnimationState(overlay, nil)

        local headLayer = mySprite:GetLayer(STONEY_LAYER_ID_HEAD)
        headLayer:SetPos(VECTOR_ZERO)
        headLayer:SetPos(VECTOR_ZERO)
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Stoney_Move(npc, ctx)
    if npc.m_variant == eStoneyVariant.CROSS_STONEY then
        local rotationType = npc[FIELD_STONEY_ROTATION_TYPE]
        local animation = rotationType == 1 and STONEY_ANIMATION_SHOOT_AND_ROTATE_1 or STONEY_ANIMATION_SHOOT_AND_ROTATE_2

        local mySprite = npc.m_sprite
        mySprite:PlayOverlay(animation, false)

        local eventShoot = mySprite:IsEventTriggered(STONEY_EVENT_SHOOT)
        if eventShoot then
            IEntityNPC.play_sound(ctx, npc, STONEY_SOUND_SHOOT, 1.0, 0, false, 1.0)
            local projectileParams = ProjectileParams.New()
            local myVelocity = npc.m_velocity
            projectileParams.heightModifier = -15.0
            projectileParams.fallingAccelModifier = 0.3
            local projectile_pos = npc.m_position + myVelocity * 2
            local projectile_vel = Vector(10.0, 0.0)
            local projectile_mode = rotationType == 1 and ProjectileMode.PLUS or ProjectileMode.CROSS

            IEntityNPC.fire_projectiles(ctx, npc, projectile_pos, projectile_vel, projectile_mode, projectileParams)
        end

        local eventRotationEnd = mySprite:IsOverlayFinished()
        if eventRotationEnd then
            -- alternate rotation types
            npc[FIELD_STONEY_ROTATION_TYPE] = 1 - rotationType
        end

        return
    end

    local stamina = npc[FIELD_STONEY_WALK_STAMINA]
    if stamina > 0 then
        stamina = stamina - IEntity.GetFrameDelta(npc)
        npc[FIELD_STONEY_WALK_STAMINA] = stamina
    end

    if stamina <= 0 then
        npc.m_state = NpcState.STATE_SPECIAL
        local mySprite = npc.m_sprite
        mySprite:Play(STONEY_ANIMATION_PANT, false)
        npc[FIELD_STONEY_RECOVER_COUNTDOWN] = (IsaacUtils.RandomInt(4) + 2) * 21
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Stoney_PantRecover(npc, ctx)
    npc.m_velocity = VECTOR_ZERO
    local recoverCountdown = npc[FIELD_STONEY_RECOVER_COUNTDOWN]

    if recoverCountdown > 0 then
        recoverCountdown = recoverCountdown - IEntity.GetFrameDelta(npc)
        npc[FIELD_STONEY_RECOVER_COUNTDOWN] = recoverCountdown
    end

    if recoverCountdown <= 0 then
        npc.m_state = NpcState.STATE_MOVE
        Stoney_SetupWalkStamina(npc)
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Stoney_UpdateHead(npc, ctx)
    local mySprite = npc.m_sprite
    local headGuide = SpriteUtils.GetNullFrameById(mySprite, STONEY_NULL_LAYER_ID_HEAD_GUIDE)

    if not headGuide or not headGuide:IsVisible() then
        local headLayer = mySprite:GetLayer(STONEY_LAYER_ID_HEAD)
        headLayer:SetVisible(false)
    else
        local headLayer = mySprite:GetLayer(STONEY_LAYER_ID_HEAD)
        headLayer:SetVisible(true)
        headLayer:SetPos(headGuide:GetPos())
        headLayer:SetSize(headGuide:GetScale())
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function RottenGaper_UpdateAi(npc, ctx)
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function UpdateAi(npc, ctx)
    if npc.m_type == EntityType.ENTITY_GAPER and npc.m_variant == eGaperVariant.ROTTEN_GAPER then
        RottenGaper_UpdateAi(npc, ctx)
        return
    end

    -- undo damage done by entities spawned by Gapers
    if npc.m_damage_damageTaken > 0 then
        for i = 1, #npc.m_damage_entries, 1 do
            local entry = npc.m_damage_entries[i]
            local byChild = entry.source.spawnerType == npc.m_type
            if byChild then
                entry.damage = 0.0
            end
        end
    end

    if npc.m_state == NpcState.STATE_INIT then
        Gaper_Init(npc, ctx)
    end

    -- update fire gfx
    local hasFireGfx = npc.m_type == EntityType.ENTITY_FATTY and npc.m_variant == eFattyVariant.FLAMING_FATTY
    if hasFireGfx then
        local mySprite = npc.m_sprite
        local fireNullFrame = mySprite:GetNullFrame(NULL_LAYER_FIRE_POS)
        local fireLayer = mySprite:GetLayer(LAYER_FIRE)

        if fireNullFrame and fireNullFrame:IsVisible() and fireLayer then
            fireLayer:SetPos(fireNullFrame:GetPos())
            fireLayer:SetSize(fireNullFrame:GetScale())
        end
    end

    -- this should never happen
    if npc.m_state == NpcState.STATE_INIT then
        return
    end

    if npc.m_isDead then
        Gaper_Death(npc, ctx)
        return
    end

    local myType = npc.m_type
    if myType == EntityType.ENTITY_FATTY or myType == EntityType.ENTITY_CONJOINED_FATTY then
        local myState = npc.m_state
        if myState == NpcState.STATE_MOVE then
            if npc.m_stateFrame < 100 then
                npc.m_stateFrame = IEntity.GetFrameDelta(npc) + npc.m_stateFrame
            end

            local fatty_triggerAttack = Fatty_CanTriggerAttack(npc, ctx)
            if fatty_triggerAttack then
                Fatty_SetupAttack(npc, ctx)
                return
            end
        elseif myState == NpcState.STATE_ATTACK then
            IEntityNPC.update_player_aim(ctx, npc, false)
            if npc.m_type == EntityType.ENTITY_CONJOINED_FATTY and npc.m_variant == eConjoinedFattyVariant.CONJOINED_FATTY then
                ConjoinedFatty_Attack(npc, ctx)
            elseif npc.m_type == EntityType.ENTITY_CONJOINED_FATTY then
                BlueConjoinedFatty_Attack(npc, ctx)
            else
                Fatty_Attack(npc, ctx)
            end

            local eventAttackEnd = not npc.m_sprite:IsFinished()
            if eventAttackEnd then
                npc.m_state = NpcState.STATE_MOVE
                npc.m_stateFrame = 0
            end

            npc.m_friction = npc.m_friction * 0.4
            return
        end
    elseif myType == EntityType.ENTITY_CYCLOPIA and npc.m_state == NpcState.STATE_ATTACK then
        Cyclopia_Attack(npc, ctx)
    end

    local updateWalkAnimation = npc.m_type ~= EntityType.ENTITY_STONEY or npc.m_state ~= NpcState.STATE_SPECIAL
    if updateWalkAnimation then
        IEntityNPC.anim_walkframe_HorizVert(npc, ANIMATION_WALK_HORI, ANIMATION_ATTACK_VERT, 0.1)
    end

    Gaper_UpdateSpeed(npc, ctx)

    -- update movement
    local shouldEvade = npc.m_flags & (EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK) ~= 0
    if shouldEvade then
        local target = IEntityNPC.GetPlayerTarget(ctx, npc)
        local myPathfinder = npc.m_pathfinder

        IPathfinder.EvadeTarget(ctx, myPathfinder, target.m_position, true)
        npc.m_friction = npc.m_friction * 0.8

        if myType == EntityType.ENTITY_FATTY or myType == EntityType.ENTITY_CONJOINED_FATTY and myPathfinder.m_evade_movementCountdown > 0 then
            npc.m_friction = npc.m_friction * 0.8
        end
    else
        local speed = npc[FIELD_GAPER_SPEED]
        local pathMarker = myType == EntityType.ENTITY_STONEY and 100 or 900

        local targetPosition = IEntityNPC.CalcTargetPosition(ctx, npc, 0.0)
        IPathfinder.FindGridPath(ctx, npc.m_pathfinder, targetPosition, speed, pathMarker, true)
    end

    Gaper_UpdateRoar(npc, ctx)

    -- activate head animation
    local activateHead = npc.m_variant == 0
        and npc.m_pathfinder.m_hasDirectPath
        and (myType ~= EntityType.ENTITY_FATTY and myType ~= EntityType.ENTITY_CONJOINED_FATTY and myType ~= EntityType.ENTITY_STONEY)
        and npc.m_sprite:GetOverlayFrame() < 1

    if activateHead then
        npc.m_sprite:PlayOverlay(ANIMATION_HEAD, true)
    end

    if npc.m_type == EntityType.ENTITY_CYCLOPIA then
        Cyclopia_UpdateSpawnCreep(npc, ctx)
        Cyclopia_UpdateAttackTrigger(npc, ctx)

        if npc.m_projectileCooldown > 0 then
            npc.m_projectileCooldown = npc.m_projectileCooldown - IEntity.GetFrameDelta(npc)
        end
    end

    if npc.m_type == EntityType.ENTITY_STONEY then
        Stoney_CheckDeath(npc, ctx)

        if npc.m_state == NpcState.STATE_MOVE then
            Stoney_Move(npc, ctx)

        elseif npc.m_state == NpcState.STATE_SPECIAL then
            Stoney_PantRecover(npc, ctx)
        end

        local shouldUpdateHead = npc.m_variant == eStoneyVariant.CROSS_STONEY
            and npc.m_state ~= NpcState.STATE_DEATH

        if shouldUpdateHead then
            Stoney_UpdateHead(npc, ctx)
        end
    end
end

---@class Actor.Gaper
local Module = {}

--#region Module

Module.UpdateAi = UpdateAi

--#endregion

return Module