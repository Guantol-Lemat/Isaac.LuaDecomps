--#region Dependencies

local EntityIdentity = require("Entity.Identity")
local EntityUtils = require("Entity.Utils")
local EntityCast = require("Entity.TypeCast")
local NpcUtils = require("Entity.NPC.Utils")
local AiUtils = require("Mechanics.NPC.Action.AiUtils")
local NpcFireProjectile = require("Mechanics.NPC.Action.FireProjectile")
local NpcPathfinder = require("Mechanics.NPC.Action.Pathfinder")
local EffectUtils = require("Entity.Effect.Utils")
local LaserUtils = require("Entity.Laser.Utils")
local IsaacUtils = require("Isaac.Utils")
local GameSpawn = require("Game.Spawn")
local RoomUtils = require("Game.Room.Utils")
local RoomBounds = require("Game.Room.Bounds")

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local VanillaColorUtils = require("General.VanillaAPI.Color")

--#endregion

---HAUNT_FIELDS
---m_targetPosition -> m_wallVelocity
---m_I1 -> m_lilHauntCount
---m_V2.X -> m_pinkChampion_bloodShotAngleProgress

---LIL_HAUNT_FIELDS
---m_I1 -> m_spawnIndex

local eHauntVariant = EntityIdentity.eHauntVariant
local eHauntSubtype = EntityIdentity.eHauntSubtype

local VECTOR_ZERO = Vector(0.0, 0.0)
local HAUNT_BASE_WALL_VELOCITY = Vector(0.3, 0.0)
local LIL_HAUNT_SPAWN_COLOR = Color(1.0, 1.0, 1.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local LIL_HAUNT_UNHIDDEN_COLOR = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local LIL_HAUNT_PHANTOM_DAMAGE_COLOR = Color(1.0, 1.0, 1.0, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local SPLAT_COLOR = Color(0.0, 0.0, 0.0, 0.3, 0.8, 0.8, 0.8, 0.0, 0.0, 0.0, 0.0)

---@param ctx Context.Common
---@param npc EntityNPCComponent
local function update_haunt(ctx, npc)
    local ctx_game = ctx.game
    local state = npc.m_state

    local evaluateLilHaunts = npc.m_I1 > 0 and EntityUtils.IsFrame(ctx, npc, 4, 0)
    if evaluateLilHaunts then
        local lilHaunt_count = 0
        local lilHaunt_list = NpcUtils.QueryNpCsType(ctx, EntityType.ENTITY_THE_HAUNT, eHauntVariant.LIL_HAUNT)

        for i = 1, #lilHaunt_list, 1 do
            if lilHaunt_list[i].m_parent.ref == npc then
                lilHaunt_count = lilHaunt_count + 1
            end
        end

        npc.m_I1 = lilHaunt_count
    end

    local isInvulnerable = state == NpcState.STATE_MOVE or state == NpcState.STATE_SPECIAL
    -- deny damage
    if isInvulnerable and npc.m_damage_damageTaken > 0.0 then
        -- change color
        if state == NpcState.STATE_MOVE and npc.m_I1 > 0 then
            local mySprite = npc.m_sprite
            local color = VanillaColorUtils.Copy(mySprite.Color)
            color.A = 0.2
            npc:SetColor(ctx, color, 10, 1, false, true)
        end

        -- deny damage
        npc.m_damage_entries = {}
        npc.m_damage_damageTaken = 0
        npc.m_damage_flagsTaken = 0
    end

    if state == NpcState.STATE_MOVE then
        local mySprite = npc.m_sprite
        if npc.m_I1 <= 0 then
            -- transition to special state
            npc.m_flags = npc.m_flags & ~EntityFlag.FLAG_NO_TARGET
            mySprite:Play("AngrySkin", false)
            NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_BOO_MAD, 1.0, 600, false, 1.0)

            local animation = mySprite:GetCurrentAnimationData()
            local animationLength = animation and animation:GetLength() or 0

            -- this is not technically correct (GetFrame returns a floored frame)
            local normalizedFrame = mySprite:GetFrame() / animationLength

            -- update transition alpha
            local animation_alpha = normalizedFrame * 0.5 + 0.5
            local layers = mySprite:GetAllLayers()
            for i = 1, #layers, 1 do
                local layer = layers[i]
                local color = layer:GetColor()
                color.A = animation_alpha
                layer:SetColor(color)
            end

            local wallPosition = ctx_game.m_level.m_room.m_topLeftBound.Y + 30.0
            npc.m_position.Y = MathUtils.Lerp(npc.m_position.Y, wallPosition, normalizedFrame)

            if mySprite:IsFinished() then
                -- transition to state special
                mySprite:Play("Peel", false)
                NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_SKIN_PULL, 1.0, 2, false, 1.0)

                state = NpcState.STATE_SPECIAL
                npc.m_state = state
                ctx_game.m_hud.m_bossBar_forceBottomPosition = true
            end

            npc.m_friction = npc.m_friction * 0.5
        else
            -- lil haunts still alive
            mySprite:Play("IdleSkin", false)
            NpcPathfinder.MoveRandomlyBoss(ctx, npc.m_pathfinder, false)
            npc.m_friction = npc.m_friction * 0.9
        end
    elseif state == NpcState.STATE_SPECIAL then
        local mySprite = npc.m_sprite
        local layers = mySprite:GetAllLayers()

        -- set alpha to 1
        for i = 1, #layers, 1 do
            local layer = layers[i]
            local color = layer:GetColor()
            color.A = 1.0
            layer:SetColor(color)
        end

        -- transition to state idle
        if mySprite:IsFinished() then
            state = NpcState.STATE_IDLE
            npc.m_state = state
            npc.m_stateFrame = 0
            npc.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end
    elseif state == NpcState.STATE_IDLE then
        local mySprite = npc.m_sprite
        if mySprite:IsFinished() then
            mySprite:Play("IdleNoSkin", false)
        end

        local target_position = AiUtils.CalcTargetPosition(ctx, npc, 0.0)
        local target_displacement = target_position - npc.m_position

        local canSideDash = math.abs(target_displacement.Y) < 40.0
        if canSideDash and IsaacUtils.RandomInt(40) == 0 then
            -- dash
            local dash_wallSpeedX = math.abs(npc.m_targetPosition.X)
            local dash_velocityX = math.abs(npc.m_velocity.X)
            local dash_speed = IsaacUtils.RandomFloat() * 5.0 + 10.0

            if target_displacement.X < 0.0 then
                dash_wallSpeedX = -dash_wallSpeedX
                dash_velocityX = -dash_velocityX
                dash_speed = -dash_speed
            end

            npc.m_targetPosition.X = dash_wallSpeedX
            npc.m_velocity.X = dash_velocityX + dash_speed
            mySprite:Play("AngryNoSkin", false)
        end

        npc.m_stateFrame = npc.m_stateFrame + 1

        local canAttack = npc.m_stateFrame > 60
        if canAttack and IsaacUtils.RandomInt(60) == 0 then
            if IsaacUtils.RandomInt(2) == 0 then
                state = NpcState.STATE_ATTACK
                npc.m_V2.X = 0.0
            else
                state = NpcState.STATE_ATTACK2
            end

            npc.m_state = state
        end
    end

    if state == NpcState.STATE_ATTACK then
        local mySprite = npc.m_sprite
        mySprite:Play("SpitNoSkin", false)

        if npc.m_subtype == eHauntSubtype.CHAMPION_PINK then
            if mySprite:WasEventTriggered("Shoot") and not mySprite:WasEventTriggered("Stop") and EntityUtils.IsFrame(ctx, npc, 2, 0) then
                local fire_params = NpcFireProjectile.NewProjectileParams()
                fire_params.m_fallingAccelModifier = -0.1

                local target_position = AiUtils.CalcTargetPosition(ctx, npc, 0.0)
                local target_displacement = target_position - npc.m_position
                local fire_baseVelocity = target_displacement:Resized(10.0)

                local fire_sideSign = EntityUtils.IsFrame(ctx, npc, 4, 0) and 1.0 or -1.0
                local fire_angleIntensity = npc.m_V2 * 0.5 * fire_sideSign + 0.5
                local fire_angle = fire_angleIntensity * 120.0 - 60.0
                local fire_velocity = fire_baseVelocity:Rotated(fire_angle)

                local fire_position = npc.m_position + npc.m_velocity
                NpcFireProjectile.FireProjectiles(
                    ctx, npc,
                    fire_position, fire_velocity,
                    ProjectileMode.SINGLE, fire_params
                )
                NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_GHOST_SHOOT, 1.0, 2, false, 1.0)
                npc.m_V2.X = npc.m_V2.X + 0.125
            end
        elseif mySprite:IsEventTriggered("Shoot") then
            local fire_position = npc.m_position + npc.m_velocity
            local fire_velocity = Vector(0.0, 10.0)
            local fire_params = NpcFireProjectile.NewProjectileParams()
            NpcFireProjectile.FireProjectiles(
                ctx, npc,
                fire_position, fire_velocity,
                ProjectileMode.SPREAD_FIVE, fire_params
            )
            NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_GHOST_SHOOT, 1.0, 2, false, 1.0)
        end

        if mySprite:IsFinished() then
            state = NpcState.STATE_IDLE
            npc.m_state = state
            npc.m_stateFrame = 0
        end
    elseif state == NpcState.STATE_ATTACK2 then
        local mySprite = npc.m_sprite
        mySprite:Play("LaserNoSkin", true)

        if mySprite:IsEventTriggered("Shoot") then
            if npc.m_subtype == eHauntSubtype.CHAMPION_BLACK then
                -- throw spiders
                local targetPlayer = AiUtils.GetPlayerTarget(ctx, npc)
                local myPosition = npc.m_position

                local room = ctx_game.m_level.m_room
                local spider_basePosition = VectorUtils.Lerp(myPosition, targetPlayer.m_position, 0.5)
                local spider_finalPosition = RoomUtils.FindFreePickupSpawnPosition(room, spider_basePosition, 0.0, false, false)
                AiUtils.ThrowSpider(ctx, myPosition, npc, spider_finalPosition, false, -50.0)

                if IsaacUtils.RandomInt(2) == 0 then
                    local spider_randomOffset = IsaacUtils.RandomVector * (IsaacUtils.RandomFloat() * 50.0)
                    spider_basePosition = spider_basePosition + spider_randomOffset

                    spider_basePosition = RoomBounds.GetClampedPosition(room, spider_basePosition, 0.0, 0.0, 0.0, 0.0)
                    spider_finalPosition = RoomUtils.FindFreePickupSpawnPosition(room, spider_basePosition, 0.0, false, false)
                    AiUtils.ThrowSpider(ctx, myPosition, npc, spider_finalPosition, false, -50.0)
                end
            elseif npc.m_subtype == eHauntSubtype.CHAMPION_PINK then
                -- shoot double bouncing laser
                local laser_currentAngle = 135.0
                local laser_posOffset = Vector(0.0, -50.0)

                for i = 1, 2, 1 do
                    local laser_entity = LaserUtils.ShootAngle(
                        ctx, LaserVariant.THICK_RED,
                        npc.m_position, laser_currentAngle,
                        10, laser_posOffset, npc, false
                    )

                    laser_entity.m_depthOffset = 3000.0
                    laser_entity.m_tearFlags = TearFlags.TEAR_BOUNCE
                    laser_entity:Update(ctx)

                    laser_currentAngle = laser_currentAngle - 90.0
                end
            else
                -- shoot single laser
                local laser_angle = 90.0
                local laser_posOffset = Vector(0.0, -50.0)

                local laser_entity = LaserUtils.ShootAngle(
                    ctx, LaserVariant.THICK_RED,
                    npc.m_position, laser_angle,
                    10, laser_posOffset, npc, false
                )

                laser_entity.m_depthOffset = 3000.0
                laser_entity:Update(ctx)
            end

            NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_GHOST_ROAR, 1.0, 2, false, 1.0)
        end

        if mySprite:IsFinished() then
            state = NpcState.STATE_IDLE
            npc.m_state = state
            npc.m_stateFrame = 0
        end
    end

    local hasWallMovement = state == NpcState.STATE_IDLE or state == NpcState.STATE_ATTACK or state == NpcState.STATE_ATTACK2
    if hasWallMovement then
        npc.m_velocity = npc.m_velocity + (npc.m_targetPosition * npc.m_timeScale)
        -- reached wall
        if npc.m_collidesWithGrid and math.abs(npc.m_gridCollisionDirection.X) > 0.5 then
            -- change movement direction
            local wallVelocity = -npc.m_targetPosition
            npc.m_targetPosition = wallVelocity
            npc.m_velocity = npc.m_velocity + (wallVelocity * 15.0)
        end
    end

    npc.m_friction = npc.m_friction * 0.96

    -- keep on upper wall
    if state ~= NpcState.STATE_MOVE then
        local room = ctx_game.m_level.m_room
        npc.m_position.Y = room.m_topLeftBound.Y + 30.0
    end
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
local function update_lil_haunt(ctx, npc)
    local state = npc.m_state
    AiUtils.SetChargeBar(npc, false, 0.0, 60.0, npc.m_stateFrame)

    if state == NpcState.STATE_MOVE then
        local sprite = npc.m_sprite
        if sprite:IsFinished() then
            sprite:Play("FloatChase", false)
        end

        local possessor_controllerIdx = npc.m_possessor_controllerIdx

        -- update movement
        local target_position = AiUtils.CalcTargetPosition(ctx, npc, 0.0)
        local target_displacement = target_position - npc.m_position
        local target_distance = target_displacement:Length()

        if possessor_controllerIdx == -1 then
            -- update non possessor movement
            local playerTarget = AiUtils.GetPlayerTarget(ctx, npc)
            local target_predictedOffset = playerTarget.m_velocity * target_distance * 0.5
            local target_predictedDisplacement = target_displacement + target_predictedOffset
            local velocity = target_predictedDisplacement:Normalized() * 0.5

            EntityUtils.AddVelocity(npc, velocity, false)
        else
            local input = AiUtils.GetMovementInput(ctx, npc, 0.0)
            local velocity = input * 0.5
            EntityUtils.AddVelocity(npc, velocity, false)
        end

        npc.m_friction = npc.m_friction * 0.95
        sprite.FlipX = npc.m_velocity.X > 0.0

        local shouldAttack
        do
            if possessor_controllerIdx ~= -1 then
                shouldAttack = npc.m_stateFrame > 60 and AiUtils.CanShootPlayer(ctx, npc, 1000.0, false, 7)
            else
                shouldAttack = npc.m_stateFrame > 90 and target_distance < math.sqrt(4000.0) and IsaacUtils.RandomInt(50) == 0
            end
        end

        if shouldAttack then
            AiUtils.UpdatePlayerAim(ctx, npc, true)
            state = NpcState.STATE_ATTACK
            npc.m_state = state
        end

        npc.m_stateFrame = npc.m_stateFrame + (npc.m_localFrame - npc.m_lastLocalFrame)
    elseif state == NpcState.STATE_ATTACK then
        AiUtils.UpdatePlayerAim(ctx, npc, false)

        local sprite = npc.m_sprite
        sprite:Play("Shoot", false)

        if sprite:IsEventTriggered("Shoot") then
            -- shoot
            local sound_pitch = IsaacUtils.RandomFloat() * 0.1 + 1.2
            NpcUtils.PlaySound(ctx, npc, SoundEffect.SOUND_WORM_SPIT, 1.0, 2, false, sound_pitch)

            -- spawn blood effect
            local myPosition = npc.m_position
            local blood_spriteOffset = Vector(0.0, -12.0)
            local blood_velocity = VECTOR_ZERO
            local blood_color = npc.m_splatColor

            local blood_effect = NpcUtils.MakeBloodEffect(
                ctx, 1,
                myPosition, blood_spriteOffset,
                blood_color, blood_velocity
            )

            blood_effect.m_depthOffset = 4.0
            EffectUtils.FollowParent(blood_effect, npc)

            -- fire projectile
            local aimVector
            if npc.m_possessor_controllerIdx ~= -1 then
                aimVector = npc.m_possessor_aim
            else
                local target_entity = AiUtils.GetPlayerTarget(ctx, npc)
                local target_displacement = target_entity - npc.m_position
                local target_predictedOffset = target_entity.m_velocity * 5.0
                aimVector = target_displacement + target_predictedOffset
            end

            local fire_position = npc.m_position
            local fire_velocity = aimVector:Normalized() * 10.0
            local fire_params = NpcFireProjectile.NewProjectileParams()
            NpcFireProjectile.FireProjectiles(
                ctx, npc,
                fire_position, fire_velocity,
                ProjectileMode.SINGLE, fire_params
            )

            state = NpcState.STATE_MOVE
            npc.m_state = state
        end

        npc.m_friction = npc.m_friction * 0.5
        npc.m_stateFrame = 0
    elseif state == NpcState.STATE_IDLE then
        local sprite = npc.m_sprite
        sprite:Play("Float", false)

        local lilHaunt_count = 0
        local parent_subtype = 0

        local parent_npc = NpcUtils.GetParentNPC(npc)
        if parent_npc then
            parent_subtype = parent_npc.m_subtype
            lilHaunt_count = parent_npc.m_I1

            -- update movement

            ---This is an altered "initial count" that represent the amount
            ---of entities in the orbit, however it may also be a non integral
            ---when transitioning from a count ot another, in order to provide
            ---a smooth transition for the attached entities
            ---@type number
            local orbit_virtualCount = lilHaunt_count

            parent_subtype = npc.m_subtype
            -- create a smooth transition for when the first lil haunt is
            -- detached from the orbit.
            if parent_subtype == eHauntSubtype.NORMAL then
                local myFrameCount = EntityUtils.GetFrameCount(ctx, npc)
                orbit_virtualCount = 3.0
                -- transitioning from 3 to 2
                if 90 < myFrameCount and myFrameCount < 150 then
                    local interpolationFactor = (myFrameCount - 90) / (150 - 90)
                    orbit_virtualCount = 3.0 - interpolationFactor
                end

                if myFrameCount >= 150 then
                    orbit_virtualCount = 2.0
                end
            end

            local room = ctx.game.m_level.m_room
            local room_frameCount = RoomUtils(ctx, room)

            local orbit_baseAngle = (npc.m_I1 / orbit_virtualCount) * 360.0
            local orbit_currentAngle = orbit_baseAngle + room_frameCount * 2 - 40.0
            local orbit_position = Vector.FromAngle(orbit_currentAngle) * 50.0

            npc.m_position = parent_npc.m_position + orbit_position
        end

        npc.m_friction = npc.m_friction * 0.5

        -- deny any taken damage
        if npc.m_damage_damageTaken > 0.0 then
            npc:SetColor(ctx, LIL_HAUNT_PHANTOM_DAMAGE_COLOR, 10, 1, false, true)
            npc.m_damage_entries = {}
            npc.m_damage_damageTaken = 0
            npc.m_damage_flagsTaken = 0
        end

        ---@return boolean
        local function should_transition_to_move()
            -- should individual lil haunt detach
            if (npc.m_I1 == 0 or parent_subtype ~= eHauntSubtype.NORMAL) and EntityUtils.GetFrameCount(ctx, npc) > 90 then
                return true
            end

            -- parent is regular haunt and first has died
            if (lilHaunt_count < 3 and parent_subtype == eHauntSubtype.NORMAL) then
                return true
            end

            if npc.m_possessor_controllerIdx ~= 1 then
                return true
            end

            return false
        end

        if should_transition_to_move() then
            sprite:Play("FloatChase", false)
            npc:SetColor(ctx, LIL_HAUNT_UNHIDDEN_COLOR, -1, -1, false, true)

            state = NpcState.STATE_MOVE
            npc.m_state = state
        end
    end

    -- adjust velocity to head towards the room bounds
    if state ~= NpcState.STATE_IDLE then
        local room = ctx.game.m_level.m_room
        local clampedPosition = RoomBounds.GetClampedPosition(room, npc.m_position, 0.0, 0.0, 0.0, 0.0)
        local positionToClamped_displacement = clampedPosition - npc.m_position

        if not VectorUtils.Equals(positionToClamped_displacement, VECTOR_ZERO) then
            local positionToClamped_direction = positionToClamped_displacement:Normalized()
            local positionToClamped_velocityAlignment = positionToClamped_direction:Dot(npc.m_velocity)

            -- factor is stronger when velocity the velocity is not aligned with the direction
            local positionToClamped_velocityFactor = MathUtils.Clamp(-positionToClamped_velocityAlignment, 0.2, 1.0)
            local positionToClamped_velocityAdjustment = positionToClamped_direction * positionToClamped_velocityFactor
            npc.m_velocity = npc.m_velocity + (positionToClamped_velocityAdjustment * npc.m_timeScale)
        end
    end

    local parent = npc.m_parent.ref
    if parent and parent.m_isDead then
        npc:Kill(ctx)
    end
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
local function UpdateAI(ctx, npc)
    local ctx_game = ctx.game

    local variant = npc.m_variant
    local state = npc.m_state

    -- init entity
    if state == NpcState.STATE_INIT then
        if variant == eHauntVariant.HAUNT then
            -- init haunt
            npc.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            npc.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

            -- evaluate lil haunts count
            local subtype = npc.m_subtype
            local lilHaunt_count = 3
            if subtype == eHauntSubtype.CHAMPION_BLACK then lilHaunt_count = 2 end
            if subtype == eHauntSubtype.CHAMPION_PINK then lilHaunt_count = 1 end

            npc.m_I1 = lilHaunt_count

            -- spawn lil haunts
            for i = 1, lilHaunt_count, 1 do
                local lilHaunt_it = i - 1
                local lilHaunt_seed = IsaacUtils.Random()

                local lilHaunt_angle = (lilHaunt_it / lilHaunt_count) * 360
                local lilHaunt_positionOffset = Vector.FromAngle(lilHaunt_angle) * 50.0
                local lilHaunt_position = npc.m_position + lilHaunt_positionOffset

                local lilHaunt_entity = GameSpawn.Spawn(
                    ctx, ctx_game,
                    npc.m_type, eHauntVariant.LIL_HAUNT, 0,
                    lilHaunt_seed, lilHaunt_position, Vector(0, 0), npc
                )

                local lilHaunt_npc = EntityCast.StaticToNPC(lilHaunt_entity)
                EntityUtils.SetEntityReference(lilHaunt_npc.m_parent, npc)
                lilHaunt_npc:SetColor(ctx, LIL_HAUNT_SPAWN_COLOR, -1, -1, false, true)
                lilHaunt_npc.m_I1 = lilHaunt_it
                lilHaunt_npc.m_invincible = true
            end

            npc.m_targetPosition = HAUNT_BASE_WALL_VELOCITY

            -- set alpha for all layers
            local sprite = npc.m_sprite
            local layerCount = sprite:GetLayerCount()
            for i = 1, layerCount, 1 do
                local layer = sprite:GetLayer(i - 1)
                assert(layer)
                local color = layer:GetColor()
                color.A = 0.5
                layer:SetColor(color)
            end

            npc.m_flags = npc.m_flags | EntityFlag.FLAG_NO_TARGET
            state = NpcState.STATE_MOVE
        else
            -- init lil haunt
            npc.m_flags = npc.m_flags | EntityFlag.FLAG_DONT_COUNT_BOSS_HP
            state = NpcState.STATE_IDLE
            npc.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        end

        npc.m_state = state
        npc.m_splatColor = VanillaColorUtils.Copy(SPLAT_COLOR)
        return
    end

    npc.m_invincible = false

    if variant == eHauntVariant.HAUNT then
        update_haunt(ctx, npc)
    elseif variant == eHauntVariant.LIL_HAUNT then
        update_lil_haunt(ctx, npc)
    end
end

---@class Actor.Boss.Haunt
local Module = {}

--#region Module

Module.UpdateAI = UpdateAI

--#endregion

return Module