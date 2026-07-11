--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IEntityEffect = require("Isaac.Interface.Entity_Effect")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_CHARGE = SoundEffect.SOUND_BATTERYCHARGE

local CHARGE_AMOUNT_POOL = {1, 1, 1, 2, 2, 3}

---@param ctx Context.Common
---@param timer Component.Entity.Effect
local function battery_bum_award_charge(ctx, timer)
    local entity = timer.m_parent.ref
    if not entity then
        return
    end

    local player = IEntity.ToPlayer(entity)
    if not player then
        return
    end

    for i = 1, 4, 1 do
        local slot = i - 1
        local amountAdded = IEntityPlayer.AddActiveCharge(ctx, player, 1, slot, false, true, false)
        if amountAdded > 0 then
            return
        end
    end
end

---@type Slot.Switch.UpdatePrize
local function BatteryBum_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG
    local collectiblePrize = myRng:RandomInt(16) == 0
    if collectiblePrize then
        IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
        local collectibleSeed = myRng:Next()
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_BATTERY_BUM, collectibleSeed, 0, CollectibleType.COLLECTIBLE_BATTERY_PACK)

        local seed = myRng:Next()
        local position = IEntitySlot.get_collectible_spawn_pos(ctx, slot)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            position, VECTOR_ZERO, nil,
            collectible, seed
        )

        slot.m_state = SlotState.PAYOUT
        mySprite:Play(ANIMATION_TELEPORT, false)

        local level = ctx.game.m_level
        ILevel.SetStateFlag(level, LevelStateFlag.STATE_BUM_LEFT, true)

        IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.BATTERY_BUM_COLLECTIBLE_PAYOUTS, 1)
        slot.m_donationValue = 0

        return
    end

    local pickupPrize = myRng:RandomInt(8) == 0
    if pickupPrize then
        local itemPool = ctx.game.m_itemPool

        IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)

        local trinketPrize_type
        if myRng:RandomInt(10) == 0 and IItemPool.RemoveTrinket(itemPool, TrinketType.TRINKET_AAA_BATTERY) then
            trinketPrize_type = TrinketType.TRINKET_AAA_BATTERY
        elseif myRng:RandomInt(10) == 0 and IItemPool.RemoveTrinket(itemPool, TrinketType.TRINKET_WATCH_BATTERY) then
            trinketPrize_type = TrinketType.TRINKET_WATCH_BATTERY
        end

        if trinketPrize_type then
            local seed = myRng:Next()
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                slot.m_position, velocity, nil,
                trinketPrize_type, seed
            )

            slot.m_donationValue = 0
            return
        end

        -- battery prize
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        slot.m_donationValue = 0
        return
    end

    -- charge prize
    local chargeAmountIdx = myRng:RandomInt(#CHARGE_AMOUNT_POOL) + 1
    local chargeAmount = CHARGE_AMOUNT_POOL[chargeAmountIdx]

    local active = IEntityPlayer.GetActiveItem(player, 0)
    local activeConfig = IItemConfig.GetCollectible(ctx.manager.m_itemConfig, ctx, active)

    local canChargeActive = activeConfig ~= nil and activeConfig.m_chargeType == ChargeType.NORMAL and chargeAmount > 0
    if canChargeActive then
        local awardChargeTimer = IEntityEffect.CreateTimer(ctx, battery_bum_award_charge, 20 / chargeAmount, chargeAmount, true)
        IEntity.SetParent(awardChargeTimer, player)
        awardChargeTimer:Update(ctx)
    end

    IEntityPlayer.AnimateHappy(ctx, player)
    IManager.PlaySound(ctx, SOUND_CHARGE, 1.0, 2, false, 1.0)

    local batteryEffect = IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.HEART,
        player.m_position, VECTOR_ZERO, nil,
        1, IsaacUtils.Random()
    )

    batteryEffect.m_sprite.Offset = Vector(0.0, -24.0)
    batteryEffect.m_depthOffset = 1.0
    slot.m_donationValue = 0
end

---@class Actor.BatteryBum
local Module = {}

--#region Module

Module.UpdatePrize = BatteryBum_UpdatePrize

--#endregion

return Module