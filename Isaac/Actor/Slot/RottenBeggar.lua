--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IEntityNPC = require("Isaac.Interface.Entity_NPC")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_SCAMPER

local TRINKET_POOL = {
    TrinketType.TRINKET_FISH_HEAD,
    TrinketType.TRINKET_FISH_TAIL,
    TrinketType.TRINKET_BOBS_BLADDER,
    TrinketType.TRINKET_ROTTEN_PENNY
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function RottenBeggar_SpawnWorms(slot, ctx)
    local event_spawnWorms = IEntity.GetFrameCount(ctx, slot) == 1
    if not event_spawnWorms then
        return
    end

    local spawnPoof = IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT,
        slot.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )

    local scale = IsaacUtils.RandomFloat() * 0.4 + 0.2
    spawnPoof.m_sprite.Scale = Vector(scale, scale)

    local color = Color(0.7, 0.9, 0.65, 1.0)
    spawnPoof:SetColor(ctx, color, -1, -1, false, true)

    spawnPoof:Update(ctx)

    IGame.SpawnParticles(
        ctx, ctx.game,
        slot.m_position, EffectVariant.WORM,
        IsaacUtils.RandomInt(3) + 1, 2.0, Color(), 100000.0, 0
    )
end

---@type Slot.Switch.UpdatePrize
local function RottenBeggar_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG

    local collectiblePrize = myRng:RandomInt(24) == 0
    if collectiblePrize then
        local game = ctx.game

        IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
        local collectibleSeed = myRng:Next()
        local collectible = IItemPool.GetCollectible(game.m_itemPool, ctx, ItemPoolType.POOL_ROTTEN_BEGGAR, collectibleSeed, 0, CollectibleType.COLLECTIBLE_ROTTEN_MEAT)

        local seed = myRng:Next()
        local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)
        IGame.Spawn(
            ctx, game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            position, VECTOR_ZERO, nil,
            collectible, seed
        )

        slot.m_state = SlotState.PAYOUT
        mySprite:Play(ANIMATION_TELEPORT, false)

        ILevel.SetStateFlag(game.m_level, LevelStateFlag.STATE_BUM_LEFT, true)
        slot.m_donationValue = 0

        return
    end

    local familiarPrize = myRng:RandomInt(4) ~= 0
    if familiarPrize then
        IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)

        local blueFlies = myRng:RandomInt(2) == 0
        if blueFlies then
            local count = myRng:RandomInt(3) + 1
            IEntityPlayer.AddBlueFlies(ctx, player, count, slot.m_position, nil)
        else
            -- blue spiders
            local count = myRng:RandomInt(3) + 1
            for i = 1, count, 1 do
                IEntityPlayer.ThrowBlueSpider(ctx, player, slot.m_position, VECTOR_ZERO)
            end
        end

        slot.m_donationValue = 0
        return
    end

    local heartRandomInt = myRng:RandomInt(6)
    if heartRandomInt == 0 then -- boneHeartPrize
        if IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, Achievement.BONE_HEARTS) then
            IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
                slot.m_position, velocity, nil,
                HeartSubType.HEART_BONE, myRng:Next()
            )

            slot.m_donationValue = 0
            return
        end
    elseif 1 <= heartRandomInt <= 3 then -- rottenHeartPrize
        if IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, Achievement.ROTTEN_HEARTS) then
            IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
                slot.m_position, velocity, nil,
                HeartSubType.HEART_ROTTEN, myRng:Next()
            )

            slot.m_donationValue = 0
            return
        end
    end

    local trinketRng = RNG(myRng:GetSeed(), 7)
    local trinketIdx = trinketRng:RandomInt(#TRINKET_POOL * 2) + 1
    local trinketPrize = trinketIdx <= #TRINKET_POOL

    if trinketPrize then
        local trinket = TRINKET_POOL[trinketIdx]
        local available = IItemPool.RemoveTrinket(ctx.game.m_itemPool, trinket)

        if available then
            IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                slot.m_position, velocity, nil,
                trinket, myRng:Next()
            )

            slot.m_donationValue = 0
            return
        end
    end

    -- fart
    IGame.Fart(ctx, ctx.game, slot.m_position, 85.0, player, 1.0, 0, Color())
    IGame.ButterBeanFart(ctx, ctx.game, slot.m_position, 120.0, player, false, false)
    slot.m_donationValue = 0
end

---@type Slot.Switch.PaySlot
local function RottenBeggar_PaySlot(slot, ctx, player)
    return SlotLib.PayCoins(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function RottenBeggar_PlayerInteraction(slot, ctx, player)
    local GetTargetValue = SlotLib.Beggar_LowTargetDonationValue
    return SlotLib.Beggar_PlayerInteraction(slot, ctx, player, SOUND_PAY, GetTargetValue)
end

---@type Slot.Switch.OnDestroy
local function RottenBeggar_OnDestroy(slot, ctx)
    SlotLib.Beggar_Destroy(slot, ctx)
    local level = ctx.game.m_level
    ILevel.SetStateFlag(level, LevelStateFlag.STATE_BUM_KILLED, true)
end

---@type Slot.Switch.CustomExplosionDrops
local function RottenBeggar_CustomExplosionDrops(slot, ctx, closure)
    local velocityRng = closure.extraRng
    local myRng = slot.m_dropRNG

    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, velocityRng)
    IEntityNPC.ThrowMaggot(ctx, slot.m_position, -10.0, velocity, -8.0) 
    velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, velocityRng)
    IEntityNPC.ThrowMaggot(ctx, slot.m_position, -10.0, velocity, -8.0) 

    local gibFlags = GibFlag.WORM | GibFlag.GUT | GibFlag.BONE
    IEntity.SpawnGibs(ctx, slot.m_position, 5, gibFlags, 40.0, nil, Color(), VECTOR_ZERO, 1.0)

    local rottenHeartDrop = myRng:RandomInt(3) == 0
    if rottenHeartDrop then
        velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, velocityRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,
            slot.m_position, velocity, nil,
            HeartSubType.HEART_ROTTEN, myRng:Next()
        )
    end
end

---@class Actor.RottenBeggar
local Module = {}

--#region Module

Module.SpawnWorms = RottenBeggar_SpawnWorms
Module.UpdatePrize = RottenBeggar_UpdatePrize
Module.PaySlot = RottenBeggar_PaySlot
Module.PlayerInteraction = RottenBeggar_PlayerInteraction
Module.OnDestroy = RottenBeggar_OnDestroy
Module.CustomExplosionDrops = RottenBeggar_CustomExplosionDrops

--#endregion

return Module