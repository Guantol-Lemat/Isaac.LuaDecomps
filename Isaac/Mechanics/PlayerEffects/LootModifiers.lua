--#region Dependencies

local Enums = require("Isaac.Enums")
local IGame = require("Isaac.Interface.Game")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

--#endregion

---@class LootModifiers.Context.ExtraPickupVariant_Global
---@field aceSpadesRng RNG?
---@field safetyCapRng RNG?
---@field matchStickRng RNG?
---@field childsHeartRng RNG?
---@field daemonsTailRng RNG?
---@field rustedKeyRng RNG?

local ePickVelType = Enums.ePickVelType

---@param rng RNG
---@return boolean extraPickup
local function extra_pickup(rng)
    return rng:RandomInt(3) ~= 0
end

---@param rng RNG
---@return boolean heartBlocked
local function TryDaemonsTailBlock(rng)
    return rng:RandomInt(5) ~= 0
end

---@param myCtx LootModifiers.Context.ExtraPickupVariant_Global
---@param ctx Context.Common
---@param rng RNG
---@return LootModifiers.Context.ExtraPickupVariant_Global
local function ExtraPickupGlobal_setup_context(myCtx, ctx, rng)
    local _
    local playerManager = ctx.game.m_playerManager

    _, myCtx.aceSpadesRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_ACE_SPADES, rng:Next())
    _, myCtx.safetyCapRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_SAFETY_CAP, rng:Next())
    _, myCtx.matchStickRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_MATCH_STICK, rng:Next())
    _, myCtx.childsHeartRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_CHILDS_HEART, rng:Next())
    _, myCtx.rustedKeyRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_RUSTED_KEY, rng:Next())

    return myCtx
end

---@param ctx LootModifiers.Context.ExtraPickupVariant_Global
---@return PickupVariant?
---@return RNG?
local function ExtraPickupGlobal_get_variant(ctx)
    local rng

    rng = ctx.aceSpadesRng
    local cardPickup = rng and rng:RandomInt(2) == 0
    if cardPickup then
        return PickupVariant.PICKUP_TAROTCARD, rng
    end

    rng = ctx.safetyCapRng
    local pillPickup = rng and rng:RandomInt(2) == 0
    if pillPickup then
        return PickupVariant.PICKUP_PILL, rng
    end

    rng = ctx.matchStickRng
    local bombPickup = rng and rng:RandomInt(2) == 0
    if bombPickup then
        return PickupVariant.PICKUP_BOMB, rng
    end

    rng = ctx.childsHeartRng
    local heartPickup = rng and rng:RandomInt(2) == 0
        and not (ctx.daemonsTailRng and TryDaemonsTailBlock(ctx.daemonsTailRng))
    if heartPickup then
        return PickupVariant.PICKUP_HEART, rng
    end

    rng = ctx.rustedKeyRng
    local keyPickup = rng and rng:RandomInt(2) == 0
    if keyPickup then
        return PickupVariant.PICKUP_KEY, rng
    end
end

---@class Slot.Closure.ExplosionDrops
---@field lootCount integer
---@field daemonsTailRng RNG?
---@field velocityRng RNG

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param closure Slot.Closure.ExplosionDrops
local function LootModifiers_SlotExplosionDrops(slot, ctx, closure)
    if extra_pickup(slot.m_dropRNG) then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, closure.velocityRng)
        local setupRng = RNG(slot.m_initSeed, 27)

        local extraPickup_ctx = ExtraPickupGlobal_setup_context({daemonsTailRng = closure.daemonsTailRng}, ctx, setupRng)
        local extraPickup_variant, extraPickup_rng = ExtraPickupGlobal_get_variant(extraPickup_ctx)

        if extraPickup_variant then
            ---@cast extraPickup_rng RNG
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, extraPickup_variant,
                slot.m_position, velocity, nil,
                0, extraPickup_rng:Next()
            )
        end

        local luckyToe = IPlayerManager.AnyoneHasTrinket(ctx.game.m_playerManager, ctx, TrinketType.TRINKET_LUCKY_TOE)
        if luckyToe then
            closure.lootCount = closure.lootCount + 1
        end
    end
end

---@class PlayerEffects.LootModifiers
local Module = {}

--#region Module

Module.TryDaemonsTailBlock = TryDaemonsTailBlock
Module.SlotExplosionDrops = LootModifiers_SlotExplosionDrops

--#endregion

return Module