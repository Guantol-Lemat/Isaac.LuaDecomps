--#region Dependencies

local Enums = require("General.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntitySlot = require("Isaac.Interface.Entity_Slot")
local IItemPool = require("Isaac.Interface.ItemPool")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_PRIZE = "Prize"
local ANIMATION_TELEPORT = "Teleport"

local EVENT_PRIZE = "Prize"

local SOUND_SPAWN = SoundEffect.SOUND_SLOTSPAWN

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
    level.m_levelStateFlag = level.m_levelStateFlag | (1 << LevelStateFlag.STATE_EVIL_BUM_LEFT)
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

---@class Actor.DevilBeggar
local Module = {}

--#region Module

Module.UpdatePrize = DevilBeggar_UpdatePrize

--#endregion

return Module