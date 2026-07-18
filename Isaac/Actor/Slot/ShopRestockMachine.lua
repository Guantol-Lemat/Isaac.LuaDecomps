--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IsaacUtils = require("Isaac.Utils.Common")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_WIGGLE_END = "WiggleEnd"
local ANIMATION_IDLE = "Idle"
local ANIMATION_DEATH = "Death"
local ANIMATION_COIN_INSERT = "CoinInsert"

local EVENT_COIN_INSERT = "CoinInsert"

local SOUND_COIN_INSERT = SoundEffect.SOUND_COIN_SLOT

---@type Slot.Switch.Init
local function ShopRestockMachine_Init(slot, ctx)
    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(1.7, 0.75)
    slot.m_flags = slot.m_flags | EntityFlag.FLAG_NO_KNOCKBACK
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function ShopRestockMachine_HandleRestock(slot, ctx)
    if slot.m_state == SlotState.DESTROYED then
        -- trigger second ShopRestock on destruction
        if slot.m_triggerTimer <= 0 then
            return
        end

        slot.m_triggerTimer = slot.m_triggerTimer - 1
        if slot.m_triggerTimer == 0 then
            IRoom.ShopRestockFull(ctx, ctx.game.m_level.m_room)
        end

        return
    end

    local event_shopRestock = slot.m_sprite:IsFinished(ANIMATION_WIGGLE_END)
    if not event_shopRestock then
        return
    end

    -- trigger restock
    IRoom.ShopRestockFull(ctx, ctx.game.m_level.m_room)
    slot.m_donationValue = 0
    slot.m_sprite:Play(ANIMATION_IDLE, false)

    local timesUsed = slot.m_triggerTimer + 1
    slot.m_triggerTimer = timesUsed

    local triggerExplosion = timesUsed > 4 and slot.m_dropRNG:RandomInt(2) == 0
    if not triggerExplosion then
        return
    end

    slot.m_triggerTimer = 0
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
        slot.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )

    IEntitySlot.CreateDropsFromExplosion(slot, ctx)
    slot.m_state = 3
    slot.m_sprite:Play(ANIMATION_DEATH, false)
end

---@type Slot.Switch.UpdatePrize
local function ShopRestockMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    local event_coinInsert = mySprite:IsOverlayEventTriggered(EVENT_COIN_INSERT)

    if not event_coinInsert then
        return
    end

    local myRng = slot.m_dropRNG
    local donationValue = slot.m_donationValue

    slot.m_state = SlotState.IDLE

    local restock = false

    if donationValue == 0 then
        restock = myRng:RandomInt(4) == 0
    elseif donationValue == 1 then
        restock = myRng:RandomInt(3) == 0
    elseif donationValue == 2 then
        restock = myRng:RandomInt(2) == 0
    else
        restock = myRng:RandomInt(4) ~= 0
    end

    if not restock then
        slot.m_donationValue = donationValue + 1
    else
        -- trigger restock (slightly different compared to the one in HandleRestock)
        IRoom.ShopRestockFull(ctx, ctx.game.m_level.m_room)
        slot.m_donationValue = 0

        local timesUsed = slot.m_triggerTimer + 1
        slot.m_triggerTimer = timesUsed

        local triggerExplosion = timesUsed > 4 and slot.m_dropRNG:RandomInt(2) == 0
        if not triggerExplosion then
            return
        end

        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        IEntitySlot.CreateDropsFromExplosion(slot, ctx)
        slot.m_state = 3
        slot.m_sprite:Play(ANIMATION_DEATH, false)
    end

    slot.m_timeout = 15
    IManager.PlaySound(ctx, SOUND_COIN_INSERT, 1.0, 2, false, 1.0)
end

---@type Slot.Switch.PaySlot
local function ShopRestockMachine_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function ShopRestockMachine_PlayerInteraction(slot, ctx, player)
    slot.m_sprite:PlayOverlay(ANIMATION_COIN_INSERT, true)
    slot.m_state = SlotState.REWARD
end

---@type Slot.Switch.CustomDestroy
local function ShopRestockMachine_CustomDestroy(slot, ctx)
    local destroyed = slot.m_state == SlotState.DESTROYED
    if destroyed then
        return
    end

    IRoom.ShopRestockFull(ctx, ctx.game.m_level.m_room)
    slot.m_triggerTimer = 0

    local myRng = slot.m_dropRNG
    local secondTrigger = myRng:RandomInt(3) ~= 0

    if secondTrigger then
        slot.m_triggerTimer = myRng:RandomInt(7) + 7
    end

    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
        slot.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )

    IEntitySlot.CreateDropsFromExplosion(slot, ctx)
    slot.m_state = SlotState.DESTROYED
    slot.m_sprite:Play(ANIMATION_DEATH, false)
end

---@type Slot.Switch.CustomExplosionDrops
local function ShopRestockMachine_CustomExplosionDrops(slot, ctx, closure)
    local myRng = slot.m_dropRNG
    local velocityRng = closure.extraRng
    local coinCount = myRng:RandomInt(4)

    for i = 1, coinCount, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, velocityRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )
    end
end

---@class Actor.ShopRestockMachine
local Module = {}

--#region Module

Module.Init = ShopRestockMachine_Init
Module.HandleRestock = ShopRestockMachine_HandleRestock
Module.UpdatePrize = ShopRestockMachine_UpdatePrize
Module.PaySlot = ShopRestockMachine_PaySlot
Module.PlayerInteraction = ShopRestockMachine_PlayerInteraction
Module.CustomDestroy = ShopRestockMachine_CustomDestroy
Module.CustomExplosionDrops = ShopRestockMachine_CustomExplosionDrops

--#endregion

return Module