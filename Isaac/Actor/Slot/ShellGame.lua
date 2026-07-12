--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IEntityNPC = require("Isaac.Interface.Entity_NPC")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_TELEPORT = "Teleport"
local ANIMATION_PAY_SHUFFLE = "PayShuffle"
local ANIMATION_SHELL_PRIZE = {
    [1] = "Shell1Prize",
    [2] = "Shell2Prize",
    [3] = "Shell3Prize",
}

local EVENT_PRIZE = "Prize"
local EVENT_SHUFFLE = "Shuffle"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_NO_PRIZE = SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ
local SOUND_SHUFFLE = SoundEffect.SOUND_SHELLGAME

local BLUE_SPIDER_PRIZE = PickupVariant.PICKUP_NULL

---@param slot Component.Entity.Slot
---@return Vector
local function get_shell_position_offset(slot)
    return Vector((slot.m_shellGame_shellIndex - 1) * 37.0, 5.0)
end

---@param slot Component.Entity.Slot
---@return Vector
local function get_shell_base_velocity(slot)
    return Vector((slot.m_shellGame_shellIndex - 1) * 4.0, 4.0)
end

---A custom version of EntityPickup.get_random_pickup_velocity
---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@return Vector position
---@return Vector velocity
local function get_random_pickup_velocity(slot, ctx)
    local position = get_shell_position_offset(slot)
    local baseVelocity = get_shell_base_velocity(slot)
    local velocity

    local tries = 0
    local validVelocity = false
    local room = ctx.game.m_level.m_room

    repeat
        local randomDirection = IsaacUtils.RandomVector()
        velocity = baseVelocity + randomDirection * 2.0
        local checkPosition = slot.m_position + (velocity * 7.0)
        validVelocity = IRoom.CheckLine(ctx, room, position, checkPosition, LineCheckMode.RAYCAST, 0, false, false)
    until tries > 10 or validVelocity

    return position, velocity
end

---@type Slot.Switch.UpdatePrize
local function award_prize(slot, ctx, player)
    local myRng = slot.m_dropRNG
    local prize = myRng:RandomInt(3) == 0
        or (IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false)
        and IEntityPlayer.GetCollectibleRNG(player, CollectibleType.COLLECTIBLE_LUCKY_FOOT):RandomInt(3) == 0)

    if not prize then
        IManager.PlaySound(ctx, SOUND_NO_PRIZE, 1.0, 2, false, 1.0)
        local position = slot.m_position + get_shell_position_offset(slot)

        if slot.m_variant == SlotVariant.HELL_GAME then
            IEntityNPC.ThrowSpider(ctx, position, nil, VECTOR_ZERO, false, -30.0)
        else
            local randomDirection = IsaacUtils.RandomVector()
            local baseVelocity = get_shell_base_velocity(slot)
            local velocity = baseVelocity + (randomDirection * 2.0)

            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_ATTACKFLY, 0,
                position, velocity, nil,
                0, myRng:Next()
            )
        end
    end

    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    local prizeType = slot.m_prizeType

    local prizeCount = 1
    if prizeType == PickupVariant.PICKUP_COIN then
        prizeCount = myRng:RandomInt(2) + 2
    elseif prizeType ~= PickupVariant.PICKUP_COLLECTIBLE then
        prizeCount = math.max(myRng:RandomInt(3), 2)
    end

    if prizeType == BLUE_SPIDER_PRIZE then
        local spawnPosition = slot.m_position + get_shell_position_offset(slot)
        for i = 1, prizeCount, 1 do
            IEntityPlayer.ThrowBlueSpider(ctx, player, spawnPosition, VECTOR_ZERO)
        end

        return
    end

    if prizeType == PickupVariant.PICKUP_COLLECTIBLE then
        if slot.m_variant == SlotVariant.HELL_GAME then
            local game = ctx.game
            local position = IEntitySlot.get_collectible_spawn_pos(ctx, slot)
            local collectible = slot.m_prizeCollectible

            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                position, VECTOR_ZERO, nil,
                collectible, myRng:Next()
            )

            IItemPool.RemoveCollectible(game.m_itemPool, ctx, collectible, false, false)
        else
            local position = IEntitySlot.get_collectible_spawn_pos(ctx, slot)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                position, VECTOR_ZERO, nil,
                CollectibleType.COLLECTIBLE_SKATOLE, myRng:Next()
            )
        end

        slot.m_state = SlotState.PAYOUT
        slot.m_sprite:Play(ANIMATION_TELEPORT, false)
        return
    end

    -- configure generic pickup spawn
    local pickupSubType = 0
    if prizeType == PickupVariant.PICKUP_HEART and slot.m_variant == SlotVariant.HELL_GAME then
        prizeCount = 1
        pickupSubType = HeartSubType.HEART_BLACK
    end

    if prizeType == PickupVariant.PICKUP_TAROTCARD then
        prizeCount = 1
    end

    -- spawn generic pickup
    for i = 1, prizeCount, 1 do
        local position, velocity = get_random_pickup_velocity(slot, ctx)

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, prizeType,
            position, velocity, nil,
            pickupSubType, myRng:Next()
        )
    end
end

---@type Slot.Switch.Init
local function ShellGame_Init(slot, ctx)
    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(3.0, 0.75)
    slot.m_shellGame_prizeSprite = slot.m_sprite:Copy()
end

---@type Slot.Switch.UpdatePrize
local function ShellGame_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_SHELL_PRIZE[slot.m_shellGame_shellIndex + 1], false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if event_prize then
        award_prize(slot, ctx, player, extraRng)
    end

    local event_returnIdle = mySprite:IsFinished()
    if event_returnIdle then
        slot.m_state = SlotState.IDLE
        mySprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function ShellGame_PostUpdate(slot, ctx)
    local event_soundShuffle = slot.m_sprite:IsPlaying(ANIMATION_PAY_SHUFFLE) and slot.m_sprite:IsEventTriggered(EVENT_SHUFFLE)
    if event_soundShuffle then
        local pitch = IsaacUtils.RandomFloat() * 0.1 + 1.0
        local volume = IsaacUtils.RandomFloat() * 0.1 + 0.5
        IManager.PlaySound(ctx, SOUND_SHUFFLE, volume, 2, false, pitch)
    end
end

---@param slot Component.Entity.Slot
local function ShellGame_PostRender(slot)
    local prizeSprite = slot.m_shellGame_prizeSprite
    if prizeSprite:IsPlaying() then
        prizeSprite:Render(slot.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
    end
end

---@class Actor.ShellGame
local Module = {}

--#region Module

Module.Init = ShellGame_Init
Module.UpdatePrize = ShellGame_UpdatePrize
Module.PostUpdate = ShellGame_PostUpdate
Module.PostRender = ShellGame_PostRender

--#endregion

return Module