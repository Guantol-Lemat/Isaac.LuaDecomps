--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_SCAMPER

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collectible CollectibleType | integer
---@param seed integer
local function award_collectible(slot, ctx, collectible, seed)
    local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)
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
    ILevel.SetStateFlag(level, LevelStateFlag.STATE_BUM_LEFT, true)
end

---@type Slot.Switch.UpdatePrize
local function Beggar_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite

    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG
    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)

    local goodPrizes = myRng:RandomInt(2) ~= 0
    if not goodPrizes then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)

        local heartPrize = myRng:RandomInt(3) == 0
            and not (IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
            and PlayerEffects.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

        if heartPrize then
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )

            return
        end

        local keyPrize = myRng:RandomInt(2) == 0
        if keyPrize then
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )

            return
        end

        -- bomb prize
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        return
    end

    local beggarCollectiblePrize = myRng:RandomInt(2) ~= 0
    if beggarCollectiblePrize then
        local seed = myRng:Next()
        local collectibleSeed = myRng:Next()
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_BEGGAR, collectibleSeed, 0, CollectibleType.COLLECTIBLE_NULL)

        award_collectible(slot, ctx, collectible, seed)
        return
    end

    local hpPrize = myRng:RandomInt(2) == 0
    if hpPrize then
        local collectible = CollectibleType.COLLECTIBLE_LUNCH + myRng:RandomInt(5)

        local playerManager = ctx.game.m_playerManager
        local offensivePool = IPlayerManager.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_THELOST_B)
            or IPlayerManager.AnyoneHasBirthright(playerManager, ctx, PlayerType.PLAYER_THELOST)
        if offensivePool then
            local seed = myRng:Next()
            collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_BEGGAR, seed, 0, CollectibleType.COLLECTIBLE_NULL)
        end

        award_collectible(slot, ctx, collectible, myRng:Next())
        return
    end

    -- card prize
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
        slot.m_position, velocity, nil,
        0, myRng:Next()
    )
end

---@type Slot.Switch.PaySlot
local function Beggar_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function Beggar_PlayerInteraction(slot, ctx, player)
    local GetTargetValue = SlotLib.Beggar_HighTargetDonationValue
    return SlotLib.Beggar_PlayerInteraction(slot, ctx, player, SOUND_PAY, GetTargetValue)
end

---@type Slot.Switch.OnDestroy
local function Beggar_OnDestroy(slot, ctx)
    SlotLib.Beggar_Destroy(slot, ctx)
    local level = ctx.game.m_level
    ILevel.SetStateFlag(level, LevelStateFlag.STATE_BUM_KILLED, true)
end

---@class Actor.Beggar
local Module = {}

--#region Module

Module.UpdatePrize = Beggar_UpdatePrize
Module.PaySlot = Beggar_PaySlot
Module.PlayerInteraction = Beggar_PlayerInteraction
Module.OnDestroy = Beggar_OnDestroy

--#endregion

return Module