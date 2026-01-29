local Module = {}

---@param context Context
---@param itemPool ItemPoolComponent
---@param pool ItemPoolType
---@param seed integer
---@param flags GetCollectibleFlag | integer
---@param defaultCollectible CollectibleType
---@return CollectibleType
local function GetCollectible(context, itemPool, pool, seed, flags, defaultCollectible)
    
end

---@param itemPool ItemPoolComponent
---@param collectible CollectibleType | integer
---@param checkIfAvailable boolean
---@param ignoreModifiers boolean
---@return boolean
local function RemoveCollectible(itemPool, collectible, checkIfAvailable, ignoreModifiers)
end

---@param itemPool ItemPoolComponent
---@param collectible CollectibleType | integer
---@param ignoreAchievement boolean
local function CanSpawnCollectible(itemPool, collectible, ignoreAchievement)
end

--#region Module

Module.GetCollectible = GetCollectible
Module.RemoveCollectible = RemoveCollectible
Module.CanSpawnCollectible = CanSpawnCollectible

--#endregion

return Module