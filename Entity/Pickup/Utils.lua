--#region Dependencies

local TableUtils = require("General.Table")

--#endregion

---@class PickupUtils
local Module = {}

local CHEST_VARIANTS = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_REDCHEST,
    PickupVariant.PICKUP_BOMBCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_SPIKEDCHEST,
    PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_MOMSCHEST, PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_MEGACHEST, PickupVariant.PICKUP_HAUNTEDCHEST,
})

---@param variant PickupVariant | integer
local function IsChest(variant)
    return not not CHEST_VARIANTS[variant]
end

---@param pickup EntityPickupComponent
---@return integer
local function GetAlternatePedestal(pickup)
end

---@param pickup EntityPickupComponent
---@param pedestal integer
local function SetAlternatePedestal(pickup, pedestal)
end

---@param pickup EntityPickupComponent
---@return integer
local function SetNewOptionsPickupIndex(pickup)
end

--#region Module

Module.IsChest = IsChest
Module.GetAlternatePedestal = GetAlternatePedestal
Module.SetAlternatePedestal = SetAlternatePedestal
Module.SetNewOptionsPickupIndex = SetNewOptionsPickupIndex

--#endregion

return Module