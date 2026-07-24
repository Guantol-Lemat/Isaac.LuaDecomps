--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")
local SlotLib = require("Isaac.Actor.Lib.Slot")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"
local ANIMATION_BOMBED = "Bombed"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN
local SOUND_PAY = SoundEffect.SOUND_SCAMPER

local STATE_BOMBED = 5

local PRIZE_HEART = 1
local PRIZE_COIN = 2
local PRIZE_COLLECTIBLE = 3

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function BombBum_BombedSpawnBomb(slot, ctx)
    if slot.m_triggerTimer <= 0 then
        return
    end

    local spawnBombTimer = slot.m_triggerTimer
    slot.m_triggerTimer = spawnBombTimer - 1

    local event_spawnBomb = spawnBombTimer % 5 == 0
    if not event_spawnBomb then
        return
    end

    local game = ctx.game
    local room = game.m_level.m_room
    local position = IRoom.FindRandomFreePickupSpawnPosition(room, false, false)
    local gridIndex = IRoom.GetGridIndex(room, position)

    if 0 <= gridIndex < 448 and room.m_gridPaths[gridIndex + 1] <= 950 then
        room.m_gridPaths[gridIndex + 1] = 900
    end

    IGame.Spawn(
        ctx, game,
        EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL,
        position, VECTOR_ZERO, slot,
        0, IsaacUtils.Random()
    )
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function BombBum_UpdateState(slot, ctx)
    local bombed = slot.m_state == STATE_BOMBED
    if not bombed then
        return
    end

    local mySprite = slot.m_sprite
    local event_startSpawning = mySprite:IsEventTriggered(EVENT_PRIZE)
    if event_startSpawning then
        slot.m_triggerTimer = 30
    end

    local event_endBombed = mySprite:IsFinished()
    if event_endBombed then
        slot.m_state = SlotState.IDLE
        mySprite:Play(ANIMATION_IDLE, false)
    end
end

---@type Slot.Switch.UpdatePrize
local function BombBum_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG

    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    local prizeType = slot.m_prizeType
    local collectiblePrize = prizeType ~= PRIZE_HEART or prizeType ~= PRIZE_COIN

    if collectiblePrize then
        local seed = myRng:Next()
        local collectibleSeed = myRng:Next()

        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_BOMB_BUM, collectibleSeed, 0, CollectibleType.COLLECTIBLE_NULL)
        local position = IEntitySlot.get_collectible_spawn_pos(slot, ctx)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            position, VECTOR_ZERO, slot,
            collectible, seed
        )

        -- setup teleport
        slot.m_state = SlotState.PAYOUT
        slot.m_sprite:Play(ANIMATION_TELEPORT, false)

        return
    end

    -- other pickup prizes
    local heartPrize = prizeType == PRIZE_HEART
        and not (IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_DAEMONS_TAIL, false)
        and PlayerEffects.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

    local pickupVariant = heartPrize and PickupVariant.PICKUP_HEART or PickupVariant.PICKUP_COIN
    local pickupCount = heartPrize and 1 or myRng:RandomInt(3) + 1

    for i = 1, pickupCount, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, pickupVariant,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )
    end
end

---@type Slot.Switch.PaySlot
local function BombBum_PaySlot(slot, ctx, player)
    return SlotLib.PayBombs(ctx, player, 1)
end

---@type Slot.Switch.PlayerInteraction
local function BombBum_PlayerInteraction(slot, ctx, player)
    IManager.PlaySound(ctx, SOUND_PAY, 1.0, 2, false, 1.0)
    local prizeRandom = slot.m_dropRNG:RandomInt(100)

    local prizeType = 0
    if prizeRandom < 25 then -- 25/100
        prizeType = PRIZE_HEART
    elseif prizeRandom < 35 then -- 10/100
        prizeType = PRIZE_COIN
    elseif prizeRandom < 40 then -- 5/100
        prizeType = PRIZE_COLLECTIBLE
    end

    slot.m_prizeType = prizeType
    local isPrize = prizeType ~= 0

    if isPrize then
        SlotLib.Beggar_SetupPrize(slot)
    else
        SlotLib.Beggar_SetupNoPrize(slot)
    end
end

---@type Slot.Switch.PreDestroy
local function BombBum_PreDestroy(slot, ctx, _, damageFlags, source)
    local damaged = damageFlags & DamageFlag.DAMAGE_CRUSH ~= 0
    if damaged then
        return true
    end

    -- setup bombed
    local canBeBombed = slot.m_state == SlotState.IDLE
        and source.m_spawnerType ~= EntityType.ENTITY_SLOT

    if not canBeBombed then
        return false
    end

    slot.m_sprite:Play(ANIMATION_BOMBED, true)
    slot.m_state = STATE_BOMBED
    return false
end

local BombBum_OnDestroy = SlotLib.Beggar_Destroy

---@class Actor.Slot.BombBum
local Module = {}

--#region Module

Module.BombedSpawnBomb = BombBum_BombedSpawnBomb
Module.UpdateState = BombBum_UpdateState
Module.UpdatePrize = BombBum_UpdatePrize
Module.PaySlot = BombBum_PaySlot
Module.PlayerInteraction = BombBum_PlayerInteraction
Module.PreDestroy = BombBum_PreDestroy
Module.OnDestroy = BombBum_OnDestroy

--#endregion

return Module