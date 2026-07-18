--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_WIGGLE = "Wiggle"
local ANIMATION_PRIZE = "Prize"
local ANIMATION_NO_PRIZE = "NoPrize"
local ANIMATION_DEATH = "Death"
local ANIMATION_REGENERATE = "Regenerate"
local ANIMATION_OUT_OF_PRIZES = "OutOfPrizes"
local ANIMATION_COIN_INSERT = "CoinInsert"

local LAYER_COLLECTIBLE = 2

local EVENT_PRIZE = "Prize"
local EVENT_EXPLOSION = "Explosion"

local SOUND_PRIZE = SoundEffect.SOUND_THUMBSUP
local SOUND_NO_PRIZE = SoundEffect.SOUND_THUMBS_DOWN
local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_COIN_SLOT

local STATE_OUT_OF_PRIZES = 4

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function CraneGame_PreUpdate(slot, ctx)
    if slot.m_state ~= SlotState.DESTROYED and slot.m_prizeCollectible == CollectibleType.COLLECTIBLE_NULL then
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_CRANE_GAME, slot.m_dropRNG:GetSeed(), 0, CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX)
        IEntitySlot.SetPrizeCollectible(slot, ctx, collectible)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function CraneGame_UpdateTimeoutPrize(slot, ctx)
    local shouldUpdate = slot.m_timeout == 0
    if not shouldUpdate then
        return
    end

    local mySprite = slot.m_sprite
    local myRng = slot.m_dropRNG

    local event_choosePrize = mySprite:IsFinished(ANIMATION_WIGGLE)
    if event_choosePrize then
        local dispense = myRng:RandomInt(4) == 0
        if dispense then
            mySprite:Play(ANIMATION_PRIZE, false)
            IManager.PlaySound(ctx, SOUND_PRIZE, 1.0, 2, false, 1.0)
        else
            mySprite:Play(ANIMATION_NO_PRIZE, false)
            IManager.PlaySound(ctx, SOUND_NO_PRIZE, 1.0, 2, false, 1.0)
        end
    end

    local event_spawnPrize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if event_spawnPrize then
        local seed = myRng:Next()
        local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)

        local collectible = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            position, VECTOR_ZERO, nil,
            slot.m_prizeCollectible, seed
        )

        collectible:Update(ctx)
        IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    end

    local event_explosion = mySprite:IsEventTriggered(EVENT_EXPLOSION)
    if event_explosion then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        IEntitySlot.CreateDropsFromExplosion(slot, ctx)
        slot.m_state = SlotState.DESTROYED
        mySprite:Play(ANIMATION_DEATH, false)
    end

    local event_restock = mySprite:IsFinished(ANIMATION_PRIZE)
    if event_restock then
        local dispenseCount = slot.m_donationValue + 1
        slot.m_donationValue = dispenseCount

        local explode = dispenseCount >= 3
        if explode then
            slot.m_state = STATE_OUT_OF_PRIZES
            mySprite:Play(ANIMATION_OUT_OF_PRIZES, false)
        else
            local itemPool = ctx.game.m_itemPool
            local seed = myRng:GetSeed()
            local collectible = IItemPool.GetCollectible(itemPool, ctx, ItemPoolType.POOL_CRANE_GAME, seed, 0, CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX)
            IEntitySlot.SetPrizeCollectible(slot, ctx, collectible)
            mySprite:Play(ANIMATION_REGENERATE, false)
        end
    end
end

--- no logic
local function CraneGame_UpdatePrize()
    return
end

---@type Slot.Switch.PaySlot
local function CraneGame_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 5)
end

---@type Slot.Switch.PlayerInteraction
local function CraneGame_PlayerInteraction(slot, ctx)
    IManager.PlaySound(ctx, SOUND_PAY, 1.0, 2, false, 1.0)
    SlotLib.SlotMachine_SetupPrize(slot)
    slot.m_sprite:PlayOverlay(ANIMATION_COIN_INSERT, true)
end

---@type Slot.Switch.OnSetPrizeCollectible
local function CraneGame_OnSetPrizeCollectible(slot, ctx, collectible)
    local prizeSprite = slot.m_sprite

    local curseOfBlind = ILevel.GetCurses(ctx, ctx.game.m_level) & LevelCurse.CURSE_OF_BLIND ~= 0
    IEntityPickup.SetupCollectibleGraphics(ctx, prizeSprite, LAYER_COLLECTIBLE, collectible, slot.m_dropRNG:GetSeed(), curseOfBlind)
    prizeSprite:LoadGraphics()
end

---@class Actor.CraneGame
local Module = {}

--#region Module

Module.PreUpdate = CraneGame_PreUpdate
Module.UpdateTimeoutPrize = CraneGame_UpdateTimeoutPrize
Module.UpdatePrize = CraneGame_UpdatePrize
Module.PaySlot = CraneGame_PaySlot
Module.PlayerInteraction = CraneGame_PlayerInteraction
Module.OnSetPrizeCollectible = CraneGame_OnSetPrizeCollectible

--#endregion

return Module