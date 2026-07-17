--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_TEARIMPACTS

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collectible CollectibleType | integer
---@param seed integer
local function award_collectible(slot, ctx, collectible, seed)
    local position = IEntitySlot.get_collectible_spawn_pos(ctx, slot)
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
        position, VECTOR_ZERO, nil,
        collectible, seed
    )

    -- setup teleport
    slot.m_state = SlotState.PAYOUT
    slot.m_sprite:Play(ANIMATION_TELEPORT, false)

    local level = ctx.game.m_level
    ILevel.SetStateFlag(level, LevelStateFlag.STATE_EVIL_BUM_LEFT, true)
end

---@type Slot.Switch.UpdatePrize
local function DevilBeggar_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG

    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)

    local pocketItemPrize = myRng:RandomInt(4) == 0
    if pocketItemPrize then
        local pillPrize = myRng:RandomInt(2) == 0
        if pillPrize then
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )
        else
            -- card prize
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )
        end

        return
    end

    local collectiblePrize = myRng:RandomInt(4) == 0
    if collectiblePrize then
        local seed = myRng:Next()
        local collectibleSeed = myRng:Next()
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_DEMON_BEGGAR, collectibleSeed, 0, CollectibleType.COLLECTIBLE_NULL)

        award_collectible(slot, ctx, collectible, seed)
        return
    end

    -- trinket prize
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
        slot.m_position, velocity, nil,
        0, myRng:Next()
    )
end

---@type Slot.Switch.PaySlot
local function DevilBeggar_PaySlot(slot, ctx, player)
    return SlotLib.PayHeart(slot, ctx, player, 1.0)
end

---@type Slot.Switch.PlayerInteraction
local function DevilBeggar_PlayerInteraction(slot, ctx, player)
    local GetTargetValue = SlotLib.Beggar_HighTargetDonationValue
    return SlotLib.Beggar_PlayerInteraction(slot, ctx, player, SOUND_PAY, GetTargetValue)
end

---@type Slot.Switch.OnDestroy
local function DevilBeggar_OnDestroy(slot, ctx)
    SlotLib.Beggar_Destroy(slot, ctx)
    local level = ctx.game.m_level
    ILevel.SetStateFlag(level, LevelStateFlag.STATE_EVIL_BUM_KILLED, true)
end

---@class Actor.DevilBeggar
local Module = {}

--#region Module

Module.UpdatePrize = DevilBeggar_UpdatePrize
Module.PaySlot = DevilBeggar_PaySlot
Module.PlayerInteraction = DevilBeggar_PlayerInteraction
Module.OnDestroy = DevilBeggar_OnDestroy

--#endregion

return Module