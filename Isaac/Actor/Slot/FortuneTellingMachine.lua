--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IsaacUtils = require("Isaac.Utils.Common")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_DEATH = "Death"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_COIN_SLOT

---@type Slot.Switch.UpdatePrize
local function FortuneTellingMachine_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG

    local fortuneChance = ctx.game.m_difficulty == Difficulty.DIFFICULTY_HARD and 0.85 or 0.65
    if IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
        fortuneChance = fortuneChance * 0.46
    end

    local randomFloat = myRng:RandomFloat()
    local fortunePrize = randomFloat < fortuneChance

    if fortunePrize then
        local fortuneSeedPrize = randomFloat < 0.02
        if fortuneSeedPrize then
            IGame.ShowFortuneSeed(ctx.game, ctx)
        else
            IGame.ShowFortuneGeneral(ctx, ctx.game)
        end

        return
    end

    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)

    local explosion = myRng:RandomInt(20) == 0
    if explosion then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION,
            slot.m_position, VECTOR_ZERO, nil,
            0, IsaacUtils.Random()
        )

        IEntitySlot.CreateDropsFromExplosion(slot, ctx)
        mySprite:Play(ANIMATION_DEATH, false)
        slot.m_state = SlotState.DESTROYED

        return
    end

    local collectiblePrize = myRng:RandomInt(30) == 0
    if collectiblePrize then
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
            CollectibleType.COLLECTIBLE_CRYSTAL_BALL, myRng:Next()
        )
        ---@cast collectibleEntity Component.Entity.Pickup
        IEntityPickup.SetAlternatePedestal(ctx, collectibleEntity, PedestalType.FORTUNE_TELLING_MACHINE)
        collectibleEntity:Update(ctx)

        return
    end

    local cardPrize = myRng:RandomInt(3) == 0
    if cardPrize then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )
    end

    local soulHeartPrize = myRng:RandomInt(3) == 0
        and not (IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
        and PlayerEffects.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

    if soulHeartPrize then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
            slot.m_position, velocity, nil,
            HeartSubType.HEART_SOUL, myRng:Next()
        )

        return
    end

    -- trinket prize
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
        slot.m_position, velocity, nil,
        0, myRng:Next()
    )
end

---@type Slot.Switch.PaySlot
local function FortuneTellingMachine_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function FortuneTellingMachine_PlayerInteraction(slot, ctx)
    IManager.PlaySound(ctx, SOUND_PAY, 1.0, 2, false, 1.0)
    SlotLib.SlotMachine_SetupPrize(slot)
end

---@class Actor.FortuneTellingMachine
local Module = {}

--#region Module

Module.UpdatePrize = FortuneTellingMachine_UpdatePrize
Module.PaySlot = FortuneTellingMachine_PaySlot
Module.PlayerInteraction = FortuneTellingMachine_PlayerInteraction

--#endregion

return Module