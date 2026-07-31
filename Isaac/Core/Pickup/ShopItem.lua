--#region Dependencies

local Enums = require("Isaac.Enums")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

local IEntityRef = IEntity.EntityRef

--#endregion

local eShopItemPrice = Enums.eShopItemPrice

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param data table
local function can_pickup_heart(pickup, ctx, player, data)
    local healthType = IEntityPlayer.GetHealthType(player)
    if healthType == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        return true
    end

    local heartCost = data[1]
    local soulCost = data[2]

    if heartCost > 0 then
        if soulCost > 0 then
            return IEntityPlayer.GetEffectiveMaxHearts(player) > 1
        end

        if soulCost == 0 then
            return IEntityPlayer.GetEffectiveMaxHearts(player) > 0
        end
    elseif heartCost == 0 then
        if soulCost > 0 then
            return player.m_soulHearts > 0
        end
    end

    return true
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param damage number
local function can_pickup_spike_damage(pickup, ctx, player, damage)
    if IEntityPlayer.GetHealthType(player) == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        return true
    end

    local flags = DamageFlag.DAMAGE_NO_PENALTIES
        | DamageFlag.DAMAGE_INVINCIBLE
        | DamageFlag.DAMAGE_SPIKES

    return player:TakeDamage(ctx, damage, flags, IEntityRef.New(nil), 30)
end

local SPECIAL_COST = {
    [eShopItemPrice.HEART_1] = {data = {1, 0}, CanPickup = can_pickup_heart},
    [eShopItemPrice.HEART_2] = {data = {2, 0}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SOUL_3] = {data = {0, 3}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SOUL_2_HEART_1] = {data = {1, 2}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SPIKES] = {data = 2.0, CanPickup = can_pickup_spike_damage},
    [eShopItemPrice.YOUR_SOUL] = {CanPickup = function() return true end},
    [eShopItemPrice.SOUL_1] = {data = {0, 1}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SOUL_2] = {data = {0, 2}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SOUL_1_HEART_1] = {data = {1, 1}, CanPickup = can_pickup_heart},
    [eShopItemPrice.SOUL_2_HEART_1] = {data = {1, 2}, CanPickup = can_pickup_heart},
}

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
local function CanPickupShopItem(pickup, ctx, player)
    local price = pickup.m_price
    if price > 0 then
        local totalCoins = player.m_numCoins + PlayerEffects.CouponWisp_AddExtraCoins(ctx.game.m_level.m_room.m_entityList)
        return price <= totalCoins
    end

    local costHandler = SPECIAL_COST[price]
    if costHandler then
        return costHandler.CanPickup(pickup, ctx, player, costHandler.data)
    end

    return true
end

---@class Core.Pickup.ShopItem
local Module = {}

--#region Module

Module.CanPickupShopItem = CanPickupShopItem

--#endregion

return Module