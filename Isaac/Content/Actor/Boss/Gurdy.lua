--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityNpc = require("Isaac.Interface.Entity_NPC")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils.Common")
local ProjectileParams = require("Isaac.Utils.ProjectileParams")

--#endregion

---@type fun(animationIdx: integer): string
local function ANIMATION_IDLE(animationIdx) return string.format("Idle%d", animationIdx) end
---@type fun(animationIdx: integer): string
local function ANIMATION_ATTACK(animationIdx) return string.format("Attack%d", animationIdx) end
local EVENT_SHOOT = "Shoot"

local SOUND_SUMMON = SoundEffect.SOUND_SUMMONSOUND
local SOUND_FLY_SPAWN = SoundEffect.SOUND_BOSS_LITE_HISS
local SOUND_POOTER_SPAWN = SoundEffect.SOUND_BOSS_BUG_HISS
local SOUND_SHOOT = SoundEffect.SOUND_BOSS_LITE_GURGLE
local SOUND_SHOOT_SIDE = SoundEffect.SOUND_BOSS_GURGLE_ROAR

local ATTACK_FLY = 1
local ATTACK_SHOOT = 2
local ATTACK_POOTER = 3
local ATTACK_SHOOT_LEFT = 4
local ATTACK_SHOOT_RIGHT = 5
local ATTACK_BOIL = 6

local BOSS_COLOR_GREEN = 1

local VECTOR_ZERO = Vector(0, 0)

---@type fun(npc: Component.Entity.Npc, value: integer)
local function Gurdy_set_attack_type(npc, value) npc.m_I1 = value end

---@type fun(npc: Component.Entity.Npc): integer
local function Gurdy_get_attack_type(npc) return npc.m_I1 end

---@type fun(npc: Component.Entity.Npc, value: number)
local function Gurdy_set_player_damaged(npc, value) npc.m_V1.X = value end

---@type fun(npc: Component.Entity.Npc): number
local function Gurdy_get_player_damaged(npc) return npc.m_V1.X end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gurdy_state_init(npc, ctx)
    -- Teleport players to the bottom part of the room
    local game = ctx.game
    local room = game.m_level.m_room
    local descriptor = room.m_roomDescriptor

    local shouldTeleportPlayers = (not descriptor or not descriptor.m_data or descriptor.m_data.m_shape == RoomShape.ROOMSHAPE_1x1)
        and npc.m_spawnGridIdx >= 0 -- is room spawn

    if shouldTeleportPlayers then
        local players = game.m_playerManager.m_players
        for i = 1, #players, 1 do
            local player = players[i]
            local position = Vector(npc.m_position.X, 400.0)

            if i ~= 1 then
                local angle = IsaacUtils.RandomFloat() * 2 * math.pi
                local randomDirection = Vector(math.cos(angle), math.cos(angle))
                position = position + (randomDirection * 20.0)
            end

            IEntityPlayer.Teleport(player, ctx, position, false, false)
        end
    end

    npc.m_position.Y = npc.m_position + 25.0
    VectorUtils.Assign(npc.m_targetPosition, npc.m_position)
    npc.m_state = NpcState.STATE_IDLE
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gurdy_update_children_push(npc, ctx)
    local children = IEntityNpc.query_npcs_spawnertype(ctx, npc.m_type, EntityType.ENTITY_NULL, false)
    for i = 1, #children, 1 do
        local child = children[i]
        local shouldPushAway = IEntity.ToNPC(child) ~= nil -- is npc
            and child.m_type ~= EntityType.ENTITY_BOIL -- not boil
            and child ~= npc -- not self

        if shouldPushAway then
            local selfToChild = child.m_position - npc.m_position
            local distance = selfToChild:Length()

            if 0.01 < distance and distance < 80.0 then -- in push range
                local speed = ((80.0 - distance) * 0.03) / distance -- push is greater the less distance there is
                local addVelocity = selfToChild * speed
                IEntity.AddVelocity(child, addVelocity, false)
            end
        end
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
---@param playerTarget Component.Entity
local function Gurdy_state_idle(npc, ctx, playerTarget)
    if npc.m_stateFrame == 0 then -- init idle
        local animationIdx = IsaacUtils.RandomInt(2) * 2 | 1 -- 1 or 3
        if Gurdy_get_player_damaged(npc) > 0.0 then
            animationIdx = 2
            Gurdy_set_player_damaged(npc, 0.0)
        end

        local animation = ANIMATION_IDLE(animationIdx)
        npc.m_sprite:Play(animation, true)
        npc.m_stateFrame = npc.m_stateFrame + 1

        return
    end

    if not npc.m_sprite:IsFinished() then -- event evaluateAttack
        return
    end

    local attackIndex = 0

    local doSpawnAttack = IsaacUtils.RandomInt(3) == 0
        or playerTarget.m_position.Y <= 200.0 -- player is above npc
        or IRoom.GetAliveEnemiesCount(ctx.game.m_level.m_room) > 7
        or npc.m_subtype == BOSS_COLOR_GREEN

    if doSpawnAttack then
        if IRoom.GetAliveEnemiesCount(ctx.game.m_level.m_room) < 14 then
            local SPAWN_ATTACKS = {ATTACK_POOTER, ATTACK_FLY, ATTACK_BOIL}
            attackIndex = SPAWN_ATTACKS[IsaacUtils.RandomInt(#SPAWN_ATTACKS) + 1]
        end
    else
        local targetToSelf = npc.m_position - playerTarget.m_position
        local isTargetOnSide = math.abs(targetToSelf.Y) < math.abs(targetToSelf.X)
            or targetToSelf.Y > 0.0

        if isTargetOnSide then
            attackIndex = targetToSelf.X > 0.0 and ATTACK_SHOOT_LEFT or ATTACK_SHOOT_RIGHT
        else
            attackIndex = ATTACK_SHOOT
        end
    end

    npc.m_stateFrame = 0
    if attackIndex <= 0 then
        return
    end

    npc.m_state = NpcState.STATE_ATTACK
    local animation = ANIMATION_ATTACK(attackIndex)
    npc.m_sprite:Play(animation, false)
    Gurdy_set_attack_type(npc, attackIndex)
    Gurdy_set_player_damaged(npc, 0.0)
end

---@type table<integer, fun(npc: Component.Entity.Npc, ctx: Context.Common)>
local Switch_Gurdy_attack = {
    [ATTACK_FLY] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SUMMON, 1.0, 2, false, 1.0)
        IEntityNpc.play_sound(npc, ctx, SOUND_FLY_SPAWN, 1.0, 2, false, 1.0)

        local position = npc.m_position + Vector(40.0, -65.0)
        local velocity = Vector(0.0, -20.0)

        local fly1 = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_ATTACKFLY, 0,
            position, velocity, npc,
            0, IsaacUtils.Random()
        )

        position = npc.m_position + Vector(-40.0, -65.0)
        velocity = Vector(0.0, -20.0)

        local fly2 = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_ATTACKFLY, 0,
            position, velocity, npc,
            0, IsaacUtils.Random()
        )

        ---@cast fly1 Component.Entity.Npc
        ---@cast fly2 Component.Entity.Npc

        fly1.m_unkBool = true
        fly2.m_unkBool = true

        fly1.m_health = fly1.m_health - 2.0
        fly2.m_health = fly2.m_health - 2.0
    end,
    [ATTACK_SHOOT] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SHOOT, 1.0, 2, false, 1.0)
        local randomPositionVariation = IsaacUtils.RandomFloat() * 30.0 - 15.0
        local position = npc.m_position + Vector(randomPositionVariation, -20.0)

        local randomSpreadVariation = IsaacUtils.RandomFloat() * 3.0 - 1.5
        local velocity = Vector(randomSpreadVariation, 10.0)

        IEntityNpc.fire_projectiles(npc, ctx, position, velocity, ProjectileMode.SPREAD_FIVE, ProjectileParams.New())
    end,
    [ATTACK_POOTER] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SUMMON, 0.7, 2, false, 1.0)
        IEntityNpc.play_sound(npc, ctx, SOUND_POOTER_SPAWN, 1.0, 2, false, 1.0)

        local position = npc.m_position + Vector(60.0, -25.0)
        local velocity = Vector(10.0, 0.0)

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_POOTER, 0,
            position, velocity, npc,
            0, IsaacUtils.Random()
        )
    end,
    [ATTACK_SHOOT_LEFT] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SHOOT_SIDE, 1.0, 2, false, 1.0)
        local randomPositionVariation = IsaacUtils.RandomFloat() * 30.0 - 15.0
        local position = npc.m_position + Vector(13.0, -18.0 - randomPositionVariation)

        local randomSpreadVariation = (IsaacUtils.RandomFloat() * 3.0 + 1.0) - 1.5
        local velocity = Vector(-10.0, randomSpreadVariation)

        IEntityNpc.fire_projectiles(npc, ctx, position, velocity, ProjectileMode.SPREAD_FIVE, ProjectileParams.New())
    end,
    [ATTACK_SHOOT_RIGHT] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SHOOT_SIDE, 1.0, 2, false, 1.0)
        local randomPositionVariation = IsaacUtils.RandomFloat() * 30.0 - 15.0
        local position = npc.m_position + Vector(-13.0, -18.0 - randomPositionVariation)

        local randomSpreadVariation = (IsaacUtils.RandomFloat() * 3.0 + 1.0) - 1.5
        local velocity = Vector(10.0, randomSpreadVariation)

        IEntityNpc.fire_projectiles(npc, ctx, position, velocity, ProjectileMode.SPREAD_FIVE, ProjectileParams.New())
    end,
    [ATTACK_BOIL] = function (npc, ctx)
        IEntityNpc.play_sound(npc, ctx, SOUND_SUMMON, 1.2, 2, false, 1.0)
        local boils = IEntityNpc.query_npcs_type(ctx, EntityType.ENTITY_BOIL, -1)

        local positions = {npc.m_position + Vector(42.0, 45.0), npc.m_position + Vector(-42.0, 45.0)}
        for i = 1, 2, 1 do
            local position = positions[i]
            local free = true

            for j = 1, #boils, 1 do
                local boil = boils[j]
                if boil.m_position:DistanceSquared(position) < 400.0 then
                    free = false
                    -- act as if it respawned
                    boil.m_health = boil.m_maxHealth
                    IGame.Spawn(
                        ctx, ctx.game,
                        EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
                        position, VECTOR_ZERO, nil,
                        0, IsaacUtils.Random()
                    )
                end
            end

            if free then
                IGame.Spawn(
                    ctx, ctx.game,
                    EntityType.ENTITY_BOIL, 0,
                    position, VECTOR_ZERO, npc,
                    0, IsaacUtils.Random()
                )
            end
        end
    end
}

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gurdy_state_attack(npc, ctx)
    local mySprite = npc.m_sprite

    if mySprite:IsFinished() then -- event_finished
        npc.m_stateFrame = 0
        npc.m_state = NpcState.STATE_IDLE
        return
    end

    if mySprite:IsEventTriggered(EVENT_SHOOT) then -- event_shoot
        local attackType = Gurdy_get_attack_type(npc)
        local attack = Switch_Gurdy_attack[attackType]
        if attack then attack(npc, ctx) end
        return
    end
end

---@param npc Component.Entity.Npc
---@param ctx Context.Common
local function Gurdy_Update(npc, ctx)
    local playerTarget = IEntityNpc.GetPlayerTarget(npc, ctx)
    if npc.m_state == NpcState.STATE_INIT then
        Gurdy_state_init(npc, ctx)
        return
    end

    npc.m_velocity = npc.m_targetPosition - npc.m_position
    IEntity.MultiplyFriction(npc, 0.8)

    Gurdy_update_children_push(npc, ctx)

    if npc.m_state == NpcState.STATE_IDLE then
        Gurdy_state_idle(npc, ctx, playerTarget)
    elseif npc.m_state == NpcState.STATE_ATTACK then
        Gurdy_state_attack(npc, ctx)
    end
end

---@type Npc.Event.TriggerPlayerDamaged
local function Gurdy_TriggerPlayerDamaged(npc)
    Gurdy_set_player_damaged(npc, 1.0)
end

---@class Actor.Gurdy
local Module = {}

--#region Module

Module.Update = Gurdy_Update
Module.TriggerPlayerDamaged = Gurdy_TriggerPlayerDamaged

--#endregion

return Module