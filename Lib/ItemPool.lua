---@class Decomp.Lib.ItemPool
local Lib_ItemPool = {}

local s_GreedItemPool = {
    [ItemPoolType.POOL_TREASURE] = ItemPoolType.POOL_GREED_TREASURE,
    [ItemPoolType.POOL_SHOP] = ItemPoolType.POOL_GREED_SHOP,
    [ItemPoolType.POOL_BOSS] = ItemPoolType.POOL_GREED_BOSS,
    [ItemPoolType.POOL_DEVIL] = ItemPoolType.POOL_GREED_DEVIL,
    [ItemPoolType.POOL_ANGEL] = ItemPoolType.POOL_GREED_ANGEL,
    [ItemPoolType.POOL_SECRET] = ItemPoolType.POOL_GREED_SECRET,
    [ItemPoolType.POOL_CURSE] = ItemPoolType.POOL_GREED_CURSE,
}

---@param poolType ItemPoolType | integer
---@return ItemPoolType | integer
local function GetGreedModePool(poolType)
    return s_GreedItemPool[poolType] or poolType
end

--#region Module

Lib_ItemPool.GetGreedModePool = GetGreedModePool

--#endregion

return Lib_ItemPool