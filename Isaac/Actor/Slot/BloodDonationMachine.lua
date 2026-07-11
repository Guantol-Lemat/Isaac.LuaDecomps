--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local IItemPool = require("Isaac.Interface.ItemPool")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN_PRIZE = SoundEffect.SOUND_BLOODBANK_SPAWN

---@type Slot.Switch.UpdatePrize
local function trigger_prize(slot, ctx, player, extraRng)
    local myRng = slot.m_dropRNG

    local childsHeartPrize = myRng:RandomInt(100) == 0 and IItemPool.RemoveTrinket(ctx.game.m_itemPool, TrinketType.TRINKET_CHILDS_HEART)
    if childsHeartPrize then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
            slot.m_position, velocity, nil,
            TrinketType.TRINKET_CHILDS_HEART, IsaacUtils.Random()
        )

        return
    end

    local collectiblePrize = myRng:RandomInt(15) == 0
    if collectiblePrize then
        local itemPool = ctx.game.m_itemPool

        local bloodBag = (myRng:RandomInt(2) == 0 or not IItemPool.CanSpawnCollectible(itemPool, ctx, CollectibleType.COLLECTIBLE_IV_BAG, 0))
            and IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, Achievement.BLOOD_BAG)
        local collectible = bloodBag and CollectibleType.COLLECTIBLE_BLOOD_BAG or CollectibleType.COLLECTIBLE_IV_BAG
        IItemPool.RemoveCollectible(itemPool, ctx, collectible, false, false)

        slot:Remove(ctx)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        local collectibleEntity = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            slot.m_position, VECTOR_ZERO, nil,
            collectible, myRng:Next()
        )

        ---@cast collectibleEntity Component.Entity.Pickup
        IEntityPickup.SetAlternatePedestal(ctx, collectibleEntity, PedestalType.BLOOD_DONATION_MACHINE)
        collectibleEntity:Update(ctx)

        return
    end

    -- coin prize
    local hasPhd = IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_PHD, false)
    local lowCoin = IEntityPlayer.GetHealthType(player) == HealthType.COIN
    local coinCount
    local bonusCoin

    if lowCoin then
        coinCount = myRng:RandomInt(2)
        if hasPhd then
            local bonusCoinRng = RNG(myRng:GetSeed(), 8)
            bonusCoin = bonusCoinRng:RandomInt(4) == 0
        end
    else
        local max = IGame.IsHardMode(ctx.game) and 1 or 2
        coinCount = math.max(myRng:RandomInt(max + 1), 1)
        bonusCoin = hasPhd
    end

    if bonusCoin then
        coinCount = coinCount + 1
    end

    for i = 1, coinCount, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )
    end
end

---@type Slot.Switch.UpdatePrize
local function BloodDonationMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    local myRng = slot.m_dropRNG

    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    trigger_prize(slot, ctx, player, extraRng)

    local spawnedReward = slot.m_exists == true
    if spawnedReward then
        IManager.PlaySound(ctx, SOUND_SPAWN_PRIZE, 1.0, 2, false, 1.0)

        local effect = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            3, IsaacUtils.Random()
        )
        effect.m_sprite.Offset = Vector(0.0, -2.0)
        effect.m_depthOffset = 5.0
    end
end

---@class Actor.BloodDonationMachine
local Module = {}

--#region Module

Module.UpdatePrize = BloodDonationMachine_UpdatePrize

--#endregion

return Module