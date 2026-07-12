--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")
local IsaacUtils = require("Isaac.Utils.Common")
local PickupUtils = require("Isaac.Gameplay.Pickup.PickupUtils")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN

local STATE_BOMBED = 5

local PRIZE_HEART = 1
local PRIZE_COIN = 2

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
        local position = IEntitySlot.get_collectible_spawn_pos(ctx, slot)
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
        and PickupUtils.TryDaemonsTailBlock(IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_DAEMONS_TAIL)))

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

---@class Actor.Slot.BombBum
local Module = {}

--#region Module

Module.BombedSpawnBomb = BombBum_BombedSpawnBomb
Module.UpdateState = BombBum_UpdateState
Module.UpdatePrize = BombBum_UpdatePrize

--#endregion

return Module