--#region Dependencies

local Properties = require("Isaac.Mechanics.Pickup.Properties")
local Events = require("Isaac.Mechanics.Pickup.Events")
local Effects = require("Isaac.Mechanics.Pickup.Effects")

--#endregion

---@param subtype BombSubType
---@return boolean
local function IsTrollBomb_Type(subtype)
    return subtype == BombSubType.BOMB_TROLL
        or subtype == BombSubType.BOMB_SUPERTROLL
        or subtype == BombSubType.BOMB_GOLDENTROLL
end

---@param pickup Component.Entity.Pickup
---@return boolean
local function IsNoKnockback(pickup)
    local variant = pickup.m_variant
    return variant == PickupVariant.PICKUP_TROPHY
        or variant == PickupVariant.PICKUP_BIGCHEST
        or variant == PickupVariant.PICKUP_BED
        or variant == PickupVariant.PICKUP_COLLECTIBLE
        or variant == PickupVariant.PICKUP_SHOPITEM
        or variant == PickupVariant.PICKUP_MOMSCHEST
end

---@param pickup Component.Entity.Pickup
---@return boolean
local function IsNoOverwrite(pickup)
    local variant = pickup.m_variant
    return variant == PickupVariant.PICKUP_TROPHY
        or variant == PickupVariant.PICKUP_BIGCHEST
        or (variant == PickupVariant.PICKUP_BED and pickup.m_subtype == 10)
end

---@class Mechanics.Pickups
local Module = {}

--#region Module

Module.IsTrollBomb_Type = IsTrollBomb_Type
Module.IsNoKnockback = IsNoKnockback
Module.IsNoOverwrite = IsNoOverwrite
Module.IsIdleAppear = Properties.IsIdleAppear
Module.ItemShouldDuplicate = Properties.ItemShouldDuplicate
Module.PostPickupInit = Events.PostPickupInit
Module.Effects_CollectibleSelectModifiers = Effects.CollectibleSelectModifiers
Module.Effects_PostPickupSelect = Effects.PostPickupSelection
Module.Cantripped_InitCard = Effects.Cantripped_InitCard
Module.Effects_PreLoadGraphics = Effects.PreLoadGraphics
Module.GFuel_ReplacePickupGraphics = Effects.GFuel_ReplacePickupGraphics
Module.Effects_OnPickupAppear = Effects.OnPickupAppear
Module.Effects_InitCollectibleModifiers = Effects.InitCollectibleModifiers
Module.Effects_ShouldForceShopItem = Effects.ShouldForceShopItem

--#endregion

return Module