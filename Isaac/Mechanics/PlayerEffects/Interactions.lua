--#region Dependencies

local IItemConfig = require("Isaac.Interface.ItemConfig")
local IGame = require("Isaac.Interface.Game")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")

--#endregion

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
local function CanPickupShopItem(player, ctx, pickup)
    return not IEntityPlayer.IsHoldingItem(player)
        and IEntityPickup.CanPickupShopItem(pickup, ctx, player)
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
local function CanCollectPickup(player, ctx, pickup)
    if player.m_variant == PlayerVariant.CO_OP_BABY then
        local canCollect = player.m_babySkin == BabySubType.BABY_MAGNET
            and pickup.m_variant ~= PickupVariant.PICKUP_COLLECTIBLE
            and IEntityPickup.CanReroll(pickup, ctx)

        if not canCollect then
            return false
        end
    elseif player.m_variant ~= PlayerVariant.PLAYER then
        return false
    end

    if player.m_isCoopGhost then
        return false
    end

    local duplicateBookOfBelial = pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE
        and pickup.m_subtype == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL
        and IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, false)

    if duplicateBookOfBelial then
        return false
    end

    local subPlayer = player.m_parent ~= nil
    if subPlayer then
        local isCollectible = pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE or pickup.m_variant == PickupVariant.PICKUP_BROKEN_SHOVEL
        if isCollectible then
            local soulSubPlayer = ITemporaryEffects.HasNullEffect(player.m_temporaryEffects, NullItemID.ID_SOUL_FORGOTTEN)
                or ITemporaryEffects.HasNullEffect(player.m_temporaryEffects, NullItemID.ID_SOUL_JACOB)

            if soulSubPlayer then
                return false
            end
        end

        local requiresPocketInventory = pickup.m_variant == PickupVariant.PICKUP_TAROTCARD
            or pickup.m_variant == PickupVariant.PICKUP_PILL
            or pickup.m_variant == PickupVariant.PICKUP_TRINKET

        if requiresPocketInventory then
            return false
        end

        if pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
            local config = IItemConfig.GetCollectible(ctx.manager.m_itemConfig, ctx, pickup.m_subtype)
            local requiresActiveInventory = config ~= nil and config.m_itemType == ItemType.ITEM_ACTIVE
            if requiresActiveInventory then
                return false
            end
        end
    end

    return true
end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
local function BabyMagnet_GetEffectTarget(ctx, pickup)
    local player = IGame.GetNearestPlayerEx(ctx, pickup.m_position, true, false, false)
    if not player then
        player = IGame.GetPlayer(ctx.game, 0)
    end

    return player
end

---@class Mechanics.Player.Interactions
local Module = {}

--#region Module

Module.CanPickupShopItem = CanPickupShopItem
Module.CanCollectPickup = CanCollectPickup
Module.BabyMagnet_GetEffectTarget = BabyMagnet_GetEffectTarget

--#endregion

return Module