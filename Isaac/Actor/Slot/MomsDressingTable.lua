--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IItemPool = require("Isaac.Interface.ItemPool")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0.0, 0.0)

local ANIMATION_IDLE = "Idle"
local ANIMATION_APPEAR = "Appear"
local ANIMATION_USE = "Use"
local ANIMATION_BROKEN = "Broken"

local EVENT_GROUND = "Ground"

local SOUND_GROUND = SoundEffect.SOUND_CHEST_DROP
local SOUND_DRESS = SoundEffect.SOUND_CHEST_OPEN

local COLLECTIBLE_POOL = {
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_MOMS_PAD,
    CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
    CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
    CollectibleType.COLLECTIBLE_MOMS_WIG,
    CollectibleType.COLLECTIBLE_MOMS_PERFUME,
    CollectibleType.COLLECTIBLE_MOMS_PEARLS,
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function dress_player(slot, ctx, player)
    slot.m_sprite:Play(ANIMATION_USE, true)

    local poof = IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
        player.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )
    poof:Update(ctx)

    IManager.PlaySound(ctx, SOUND_DRESS, 1.0, 2, false, 1.0)
    local seed = slot.m_dropRNG:Next()
    IEntityPlayer.ShuffleCostumes(ctx, player, seed)
end

---@type Slot.Switch.Init
local function MomsDressingTable_Init(slot, ctx)
    slot.m_sizeMulti = Vector(1.5, 0.75)
    local appear = ctx.game.m_level.m_room.m_isFirstVisit
    if appear then
        slot.m_sprite:Play(ANIMATION_APPEAR, false)
        slot.m_visible = false
    else
        slot.m_sprite:Play(ANIMATION_IDLE, false)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function MomsDressingTable_PreUpdate(slot, ctx)
    if IEntity.GetFrameCount(ctx, slot) > 1 then
        slot.m_visible = true
        if slot.m_sprite:IsEventTriggered(EVENT_GROUND) then
            IManager.PlaySound(ctx, SOUND_GROUND, 1.0, 2, false, 1.0)
        end
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function MomsDressingTable_CustomHandlePlayerCollision(slot, ctx, player)
    local canInteract = player.m_variant == PlayerVariant.PLAYER
        and slot.m_state ~= SlotState.DESTROYED
        and not slot.m_sprite:IsPlaying()

    if canInteract then
        dress_player(slot, ctx, player)
    end
end

---@type Slot.Switch.OnDestroy
local function MomsDressingTable_OnDestroy(slot)
    slot.m_sprite:Play(ANIMATION_BROKEN, false)
    slot.m_state = SlotState.DESTROYED
end

---@type Slot.Switch.CustomExplosionDrops
local function MomsDressingTable_CustomExplosionDrops(slot, ctx, closure)
    local extraRng = closure.extraRng
    local rng = RNG(extraRng:GetSeed(), 31)

    local collectibleDrop = rng:RandomInt(100) == 0
    if collectibleDrop then
        local seed = rng:Next()
        local collectible = IItemPool.GetCollectibleFromList(ctx.game.m_itemPool, ctx, COLLECTIBLE_POOL, seed, CollectibleType.COLLECTIBLE_MOMS_HEELS, true, false)
        local collectible_entity = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            slot.m_position, VECTOR_ZERO, nil,
            collectible, rng:Next()
        )

        ---@cast collectible_entity Component.Entity.Pickup
        IEntityPickup.SetAlternatePedestal(ctx, collectible_entity, PedestalType.MOMS_DRESSING_TABLE)
        collectible_entity:Update(ctx)
        slot:Remove(ctx)

        return
    end

    local pillCount = rng:RandomInt(4) + 1
    for i = 1, pillCount, 1 do
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
            slot.m_position, velocity, nil,
            0, rng:Next()
        )
    end
end

---@class Actor.MomsDressingTable
local Module = {}

--#region Module

Module.Init = MomsDressingTable_Init
Module.PreUpdate = MomsDressingTable_PreUpdate
Module.CustomHandlePlayerCollision = MomsDressingTable_CustomHandlePlayerCollision
Module.OnDestroy = MomsDressingTable_OnDestroy
Module.CustomExplosionDrops = MomsDressingTable_CustomExplosionDrops

--#endregion

return Module