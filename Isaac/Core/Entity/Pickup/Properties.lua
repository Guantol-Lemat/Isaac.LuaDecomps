--#region Dependencies

local TableUtils = require("General.Table")

--#endregion

local CAN_BE_PICKED = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_HEART,
    PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY,
    PickupVariant.PICKUP_BOMB,
    PickupVariant.PICKUP_THROWABLEBOMB,
    PickupVariant.PICKUP_POOP,
    PickupVariant.PICKUP_GRAB_BAG,
    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_LIL_BATTERY,
    PickupVariant.PICKUP_TAROTCARD,
    PickupVariant.PICKUP_TRINKET,
})

local CHEST_VARIANTS = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_CHEST,
    PickupVariant.PICKUP_LOCKEDCHEST,
    PickupVariant.PICKUP_REDCHEST,
    PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_SPIKEDCHEST,
    PickupVariant.PICKUP_MIMICCHEST,
    PickupVariant.PICKUP_MOMSCHEST,
    PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_WOODENCHEST,
    PickupVariant.PICKUP_MEGACHEST,
    PickupVariant.PICKUP_HAUNTEDCHEST,
})

---@param pickup Component.Entity.Pickup
---@return boolean
local function IsShopItem(pickup)
    return pickup ~= 0
end

---@param pickup Component.Entity.Pickup
---@param shopItemsAllowed boolean
---@return boolean
local function CanBePickedUp(pickup, shopItemsAllowed)
    return CAN_BE_PICKED[pickup.m_variant] ~= nil
        and (shopItemsAllowed or not IsShopItem(pickup))
end

---@param pickup Component.Entity.Pickup
---@return boolean
local function IsChest(pickup)
    return CHEST_VARIANTS[pickup.m_variant] ~= nil
end

---@param variant PickupVariant | integer
---@return boolean
local function IsChestVariant(variant)
    return CHEST_VARIANTS[variant] ~= nil
end

---@class Core.Pickup.Properties
local Module = {}

--#region Module

Module.IsShopItem = IsShopItem
Module.CanBePickedUp = CanBePickedUp
Module.IsChest = IsChest
Module.IsChestVariant = IsChestVariant

--#endregion

return Module