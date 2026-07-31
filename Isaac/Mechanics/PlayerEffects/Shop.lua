--#region Dependencies

local IEntityList = require("Isaac.Interface.EntityList")

--#endregion

---@param entityList Component.EntityList
---@return integer
local function CouponWisp_AddExtraCoins(entityList)
    return IEntityList.CountWisps(entityList, CollectibleType.COLLECTIBLE_COUPON)
end

---@class PlayerEffects.Shop
local Module = {}

--#region Module

Module.CouponWisp_AddExtraCoins = CouponWisp_AddExtraCoins

--#endregion

return Module