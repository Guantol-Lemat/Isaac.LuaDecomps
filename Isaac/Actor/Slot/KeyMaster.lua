--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IItemPool = require("Isaac.Interface.ItemPool")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN

local CHEST_POOL = {
    PickupVariant.PICKUP_CHEST,
    PickupVariant.PICKUP_LOCKEDCHEST,
    PickupVariant.PICKUP_REDCHEST
}

---@type Slot.Switch.UpdatePrize
local function KeyMaster_UpdatePrize(slot, ctx, player, extraRng)
    local mySprite = slot.m_sprite
    mySprite:Play(ANIMATION_PRIZE, false)

    local event_prize = mySprite:IsEventTriggered(EVENT_PRIZE)
    if not event_prize then
        return
    end

    local myRng = slot.m_dropRNG
    IManager.PlaySound(ctx, SOUND_SPAWN, 1.0, 2, false, 1.0)
    local itemPrize = myRng:RandomInt(8) == 0

    if itemPrize then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)

        local itemPool = ctx.game.m_itemPool
        local collectiblePrize = myRng:RandomInt(2) == 0
            and not IItemPool.RemoveTrinket(itemPool, TrinketType.TRINKET_PAPER_CLIP)

        if collectiblePrize then
            local seed = myRng:Next()
            local collectibleSeed = myRng:Next()
            local collectible = IItemPool.GetCollectible(itemPool, ctx, ItemPoolType.POOL_KEY_MASTER, collectibleSeed, 0, CollectibleType.COLLECTIBLE_NULL)

            local positionOffset = Vector(0.0, 80.0)
            local position = slot.m_position + positionOffset
            position = IRoom.FindFreePickupSpawnPosition(ctx.game.m_level.m_room, position, 0.0, false, false)

            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                position, VECTOR_ZERO, nil,
                collectible, seed
            )
        else
            -- trinket prize
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                slot.m_position, velocity, slot,
                TrinketType.TRINKET_PAPER_CLIP, myRng:Next()
            )
        end

        -- setup teleport
        slot.m_state = SlotState.PAYOUT
        slot.m_sprite:Play(ANIMATION_TELEPORT, false)

        return
    end

    -- chest prize
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
    velocity = velocity * 5.0
    local seed = myRng:Next()
    local chestVariant = CHEST_POOL[myRng:RandomInt(3) + 1]

    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, chestVariant,
        slot.m_position, velocity, nil,
        0, seed
    )
end

---@class Actor.KeyMaster
local Module = {}

--#region Module

Module.UpdatePrize = KeyMaster_UpdatePrize

--#endregion

return Module